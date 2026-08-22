; =============================================================================
; POPULOUS AMIGA - ai.asm
; Computer opponent AI — mirrors Python ai_player.py
;
; Three independent cooldown timers (in game ticks at 50 Hz):
;   terrain_timer   — raise/lower terrain near own buildings/peeps
;   power_timer     — use divine powers (quake, volcano, flood, swamp, knight)
;   command_timer   — change peep behaviour command
;
; Each timer fires when its counter reaches zero, executes its action, then
; resets. The difficulty setting maps to AI_TERRAIN_TICKS_* etc. from data.inc.
; =============================================================================

        include "hardware.inc"
        include "macros.inc"
        include "data.inc"

        xdef    ai_init
        xdef    ai_update
        xdef    ai_set_difficulty

; AI state record (one per team, but only team FOE uses it here)
; Offset constants
AI_TERRAIN_CNT  equ     0       ; .w remaining ticks before terrain action
AI_POWER_CNT    equ     2       ; .w remaining ticks before power action
AI_CMD_CNT      equ     4       ; .w remaining ticks before command action
AI_TERRAIN_RATE equ     6       ; .w period (ticks) for terrain actions
AI_POWER_RATE   equ     8       ; .w period for power actions
AI_CMD_RATE     equ     10      ; .w period for command changes
AI_TEAM         equ     12      ; .b team (always TEAM_FOE)
AI_PAD          equ     13      ; .b pad
AI_SIZE         equ     14

; ---------------------------------------------------------------------------
; ai_init — initialise AI state for the foe team
; ---------------------------------------------------------------------------
ai_init:
        lea     ai_state,a0
        ; Default: medium difficulty
        move.w  #AI_TERRAIN_TICKS_SLOW,AI_TERRAIN_CNT(a0)
        move.w  #AI_POWER_TICKS,AI_POWER_CNT(a0)
        move.w  #AI_CMD_TICKS_SLOW,AI_CMD_CNT(a0)
        move.w  #AI_TERRAIN_TICKS_SLOW,AI_TERRAIN_RATE(a0)
        move.w  #AI_POWER_TICKS,AI_POWER_RATE(a0)
        move.w  #AI_CMD_TICKS_SLOW,AI_CMD_RATE(a0)
        move.b  #TEAM_FOE,AI_TEAM(a0)
        rts

; ---------------------------------------------------------------------------
; ai_set_difficulty — configure timers from a 0–15 difficulty value
; In:  d0.b = reaction_speed (0=slow, 15=fast)
;      d1.b = command_rate   (0=never, 15=fast)
; ---------------------------------------------------------------------------
ai_set_difficulty:
        lea     ai_state,a0

        ; terrain rate: 0 → AI_TERRAIN_TICKS_SLOW, 15 → AI_TERRAIN_TICKS_FAST
        ; Linear interp using integer approximation
        and.w   #$00ff,d0
        moveq   #0,d2
        move.w  d0,d2
        muls    #(AI_TERRAIN_TICKS_SLOW-AI_TERRAIN_TICKS_FAST),d2
        divu    #15,d2
        move.w  #AI_TERRAIN_TICKS_SLOW,d3
        sub.w   d2,d3
        move.w  d3,AI_TERRAIN_RATE(a0)
        move.w  d3,AI_TERRAIN_CNT(a0)

        ; command rate: 0 → very large, 1 → 6000 ticks, 15 → 250 ticks
        and.w   #$00ff,d1
        beq.s   .cmd_never
        cmp.w   #1,d1
        beq.s   .cmd_slow
        ; Between 2 and 15: interp 6000 → 250
        move.w  d1,d2
        subq.w  #1,d2                   ; 1–14
        muls    #(AI_CMD_TICKS_SLOW-AI_CMD_TICKS_FAST),d2
        divu    #14,d2
        move.w  #AI_CMD_TICKS_SLOW,d3
        sub.w   d2,d3
        move.w  d3,AI_CMD_RATE(a0)
        move.w  d3,AI_CMD_CNT(a0)
        bra.s   .done
.cmd_never:
        move.w  #$7fff,AI_CMD_RATE(a0)
        move.w  #$7fff,AI_CMD_CNT(a0)
        bra.s   .done
.cmd_slow:
        move.w  #AI_CMD_TICKS_SLOW,AI_CMD_RATE(a0)
        move.w  #AI_CMD_TICKS_SLOW,AI_CMD_CNT(a0)

.done:  rts

; ---------------------------------------------------------------------------
; ai_update — called every game tick; fires actions when timers expire
; In: (uses globals: house_data, peep_data, terrain arrays, power_jauge)
; ---------------------------------------------------------------------------
ai_update:
        movem.l d0-d7/a0-a4,-(sp)
        lea     ai_state,a0

        ; --- Terrain timer ---
        subq.w  #1,AI_TERRAIN_CNT(a0)
        bgt.s   .check_power
        move.w  AI_TERRAIN_RATE(a0),AI_TERRAIN_CNT(a0)
        bsr     ai_do_terrain

.check_power:
        subq.w  #1,AI_POWER_CNT(a0)
        bgt.s   .check_cmd
        move.w  AI_POWER_RATE(a0),AI_POWER_CNT(a0)
        bsr     ai_do_power

.check_cmd:
        subq.w  #1,AI_CMD_CNT(a0)
        bgt.s   .done
        move.w  AI_CMD_RATE(a0),AI_CMD_CNT(a0)
        bsr     ai_do_command

.done:  movem.l (sp)+,d0-d7/a0-a4
        rts

; ---------------------------------------------------------------------------
; ai_do_terrain — raise or lower a corner near own buildings/peeps
; ---------------------------------------------------------------------------
ai_do_terrain:
        ; Find a random building belonging to TEAM_FOE
        lea     house_data,a1
        move.w  house_count,d7
        beq     .try_peeps
        subq.w  #1,d7

        ; Pick random starting index
        bsr     rnd_byte
        and.w   #$003f,d0
        cmp.w   d7,d0
        ble.s   .scan_house_start
        clr.w   d0
.scan_house_start:
        move.w  d0,d6
        mulu    #HOUSE_SIZE,d6
        add.l   d6,a1               ; a1 = first candidate house

.scan_house:
        btst    #0,HOUSE_FLAGS(a1)
        bne.s   .next_house
        cmp.b   #TEAM_FOE,HOUSE_TEAM(a1)
        bne.s   .next_house
        ; Use this house as target
        move.w  HOUSE_R(a1),d5
        move.w  HOUSE_C(a1),d6
        bra.s   .pick_corner

.next_house:
        add.l   #HOUSE_SIZE,a1
        dbf     d7,.scan_house

.try_peeps:
        ; Try a random FOE peep
        lea     peep_data,a1
        move.w  peep_count,d7
        beq     .no_target
        subq.w  #1,d7
.scan_peep:
        btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a1)
        bne.s   .np
        cmp.b   #TEAM_FOE,PEEP_TEAM(a1)
        bne.s   .np
        move.w  PEEP_R(a1),d5
        move.w  PEEP_C(a1),d6
        bra.s   .pick_corner
.np:    add.l   #PEEP_SIZE,a1
        dbf     d7,.scan_peep
        bra     .no_target

.pick_corner:
        ; Pick a random offset within ±2 tiles
        bsr     rnd_byte
        and.b   #3,d0
        subq.b  #1,d0                   ; -1 to +2
        ext.w   d0
        add.w   d0,d5
        bsr     rnd_byte
        and.b   #3,d0
        subq.b  #1,d0
        ext.w   d0
        add.w   d0,d6

        ; Bounds check
        tst.w   d5
        blt     .no_target
        tst.w   d6
        blt     .no_target
        cmp.w   #GRID_H,d5
        bge     .no_target
        cmp.w   #GRID_W,d6
        bge     .no_target

        ; Check power gauge for FOE team
        move.w  power_jauge_foe,d4
        ; 50% chance raise vs lower
        bsr     rnd_byte
        and.b   #1,d0
        beq.s   .try_lower

        ; Try raise
        cmp.w   #COST_RAISE,d4
        blt.s   .no_target
        move.w  d5,d0
        move.w  d6,d1
        bsr     map_raise_corner
        sub.w   #COST_RAISE,power_jauge_foe
        bra.s   .no_target

.try_lower:
        cmp.w   #COST_LOWER,d4
        blt.s   .no_target
        move.w  d5,d0
        move.w  d6,d1
        bsr     map_lower_corner
        sub.w   #COST_LOWER,power_jauge_foe

.no_target:
        rts

; ---------------------------------------------------------------------------
; ai_do_power — use a divine power against the ally team
; ---------------------------------------------------------------------------
ai_do_power:
        ; Find a random ally building/peep as target
        lea     house_data,a1
        move.w  house_count,d7
        beq     .no_pow_target
        subq.w  #1,d7
        move.w  #-1,d4
.scan_pow:
        btst    #0,HOUSE_FLAGS(a1)
        bne.s   .pow_skip
        cmp.b   #TEAM_ALLY,HOUSE_TEAM(a1)
        bne.s   .pow_skip
        move.w  HOUSE_R(a1),d5
        move.w  HOUSE_C(a1),d6
        moveq   #1,d4
.pow_skip:
        add.l   #HOUSE_SIZE,a1
        dbf     d7,.scan_pow

        tst.w   d4
        blt     .no_pow_target

        ; Choose a power at random (weighted by cost feasibility)
        bsr     rnd_byte
        and.b   #$03,d0
        move.w  power_jauge_foe,d3

        cmp.b   #0,d0
        bne.s   .try_quake
        cmp.w   #COST_VOLCANO,d3
        blt     .no_pow_target
        move.w  d5,d0
        move.w  d6,d1
        bsr     map_do_volcano
        sub.w   #COST_VOLCANO,power_jauge_foe
        bra     .no_pow_target

.try_quake:
        cmp.b   #1,d0
        bne.s   .try_swamp
        cmp.w   #COST_QUAKE,d3
        blt     .no_pow_target
        ; Quake: set timer in main state (flagged via quake_pending)
        move.w  d5,quake_target_r
        move.w  d6,quake_target_c
        move.b  #1,quake_pending
        sub.w   #COST_QUAKE,power_jauge_foe
        bra     .no_pow_target

.try_swamp:
        cmp.b   #2,d0
        bne.s   .try_flood
        cmp.w   #COST_SWAMP,d3
        blt     .no_pow_target
        move.w  d5,d0
        move.w  d6,d1
        bsr     map_do_swamp
        sub.w   #COST_SWAMP,power_jauge_foe
        bra     .no_pow_target

.try_flood:
        cmp.w   #COST_FLOOD,d3
        blt     .no_pow_target
        bsr     map_do_flood
        sub.w   #COST_FLOOD,power_jauge_foe

.no_pow_target:
        rts

; ---------------------------------------------------------------------------
; ai_do_command — change FOE peep behaviour command
; ---------------------------------------------------------------------------
ai_do_command:
        ; Weighted random: 60% build, 20% assemble, 15% fight, 5% papal
        bsr     rnd_byte
        and.w   #$00ff,d0
        cmp.b   #153,d0                 ; 60% = 153/256 ≈ 60%
        blt.s   .cmd_build
        cmp.b   #204,d0                 ; 20% = 51/256 window
        blt.s   .cmd_assemble
        cmp.b   #242,d0                 ; 15%
        blt.s   .cmd_fight
        ; 5% papal
        move.b  #PEEP_STATE_PAPAL,d0
        bra.s   .apply
.cmd_build:
        move.b  #PEEP_STATE_BUILD,d0
        bra.s   .apply
.cmd_assemble:
        move.b  #PEEP_STATE_ASSEMBLE,d0
        bra.s   .apply
.cmd_fight:
        move.b  #PEEP_STATE_FIGHT,d0

.apply:
        move.b  #TEAM_FOE,d1
        ; For papal, use current FOE papal position
        move.w  papal_pos_foe,d2
        move.w  papal_pos_foe+2,d3
        bsr     peep_set_command
        rts

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
        section data_c,data_c

ai_state:           ds.b    AI_SIZE

; Power gauges (also accessed by populous.asm main loop)
        xdef    power_jauge_ally
        xdef    power_jauge_foe
        xdef    quake_pending
        xdef    quake_target_r
        xdef    quake_target_c

power_jauge_ally:   dc.w    0
power_jauge_foe:    dc.w    0
quake_pending:      dc.b    0
quake_foe_pending:  dc.b    0
quake_target_r:     dc.w    32
quake_target_c:     dc.w    32
