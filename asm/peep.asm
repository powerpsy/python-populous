; =============================================================================
; POPULOUS AMIGA - peep.asm
; Peep (unit) lifecycle and behaviour state machine.
;
; State machine (mirrors Python peep.py):
;   PEEP_STATE_EXPLORE  — wander, looking for buildable terrain
;   PEEP_STATE_BUILD    — move to a flat tile and request building
;   PEEP_STATE_ASSEMBLE — move toward friendly peeps (fusion)
;   PEEP_STATE_FIGHT    — seek enemy peeps / buildings
;   PEEP_STATE_PAPAL    — move toward papal magnet
;   (knight and drowning are flags, not separate states)
;
; Fusion (assemble): two peeps of same team on same tile merge into one
;   stronger peep (energy sum, up to 255).
; Combat: allied peep and foe peep on adjacent tile fight; one dies.
; Drowning: peep on water tile loses energy each tick; dies at 0.
; =============================================================================

        include "hardware.inc"
        include "macros.inc"
        include "data.inc"

        xdef    peep_init
        xdef    peep_spawn
        xdef    peep_update_all
        xdef    peep_set_command
        xdef    peep_data
        xdef    peep_count
        xdef    papal_pos_ally          ; (r.w, c.w) papal magnet ally
        xdef    papal_pos_foe

; Direction delta table (dr, dc) indexed by DIR_N..DIR_NW
dir_delta:
        dc.b    -1,-1   ; N
        dc.b    -1, 0   ; NE
        dc.b    -1, 1   ; E
        dc.b     0, 1   ; SE
        dc.b     1, 1   ; S
        dc.b     1, 0   ; SW
        dc.b     1,-1   ; W
        dc.b     0,-1   ; NW

; ---------------------------------------------------------------------------
; peep_init — clear all peep records
; ---------------------------------------------------------------------------
peep_init:
        lea     peep_data,a0
        move.w  #(MAX_PEEPS*PEEP_SIZE)-1,d7
.clr:   clr.b   (a0)+
        dbf     d7,.clr
        clr.w   peep_count
        rts

; ---------------------------------------------------------------------------
; peep_spawn — create a new peep near (r, c) for team
; In:  d0.w=r, d1.w=c, d2.b=team, d3.w=energy
; Out: d0.w = index (≥0) or -1
; ---------------------------------------------------------------------------
peep_spawn:
        movem.l d1-d7/a0,-(sp)
        cmp.w   #MAX_PEEPS,peep_count
        bge     .full

        ; Find first free slot (PEEP_FLAG_DEAD set)
        lea     peep_data,a0
        move.w  peep_count,d4
        mulu    #PEEP_SIZE,d4
        add.l   d4,a0

        clr.l   (a0)
        clr.l   4(a0)
        clr.l   8(a0)
        clr.l   12(a0)
        clr.l   16(a0)
        clr.l   20(a0)
        clr.l   24(a0)

        move.w  d0,PEEP_R(a0)
        move.w  d1,PEEP_C(a0)
        clr.b   PEEP_R_FRAC(a0)
        clr.b   PEEP_C_FRAC(a0)
        move.w  d3,PEEP_ENERGY(a0)
        move.b  #PEEP_STATE_EXPLORE,PEEP_STATE(a0)
        move.b  d2,PEEP_TEAM(a0)
        clr.b   PEEP_FLAGS(a0)
        clr.b   PEEP_ANIM(a0)
        clr.b   PEEP_ANIM_TMR(a0)
        move.b  #DIR_S,PEEP_DIR(a0)
        move.b  #-1,PEEP_HOME(a0)
        move.w  #PEEP_TICKS_NORMAL,PEEP_SPEED(a0)

        move.w  peep_count,d4
        addq.w  #1,peep_count
        move.w  d4,d0
        movem.l (sp)+,d1-d7/a0
        rts
.full:  move.w  #-1,d0
        movem.l (sp)+,d1-d7/a0
        rts

; ---------------------------------------------------------------------------
; peep_set_command — set behaviour state for all peeps of a team
; In:  d0.b=new_state, d1.b=team
;      d2.w=target_r, d3.w=target_c  (for PAPAL, ignored otherwise)
; ---------------------------------------------------------------------------
peep_set_command:
        movem.l d0-d4/a0,-(sp)
        lea     peep_data,a0
        move.w  peep_count,d4
        beq     .done
        subq.w  #1,d4
.loop:
        btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a0)       ; DEAD?
        bne.s   .skip
        cmp.b   PEEP_TEAM(a0),d1
        bne.s   .skip
        ; Don't override knights
        btst    #PEEP_FLAG_KNIGHT_BIT,PEEP_FLAGS(a0)
        bne.s   .skip
        move.b  d0,PEEP_STATE(a0)
        move.w  d2,PEEP_TARGET_R(a0)
        move.w  d3,PEEP_TARGET_C(a0)
.skip:  add.l   #PEEP_SIZE,a0
        dbf     d4,.loop
.done:  movem.l (sp)+,d0-d4/a0
        rts

; ---------------------------------------------------------------------------
; peep_update_all — advance all peeps by one tick
; Trashes: d0–d7/a0–a5
; ---------------------------------------------------------------------------
peep_update_all:
        movem.l d0-d7/a0-a5,-(sp)
        move.w  peep_count,d7
        beq     .done
        subq.w  #1,d7
        lea     peep_data,a0

.loop:
        btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a0)
        bne     .next_peep

        ; --- Drowning check ---
        btst    #PEEP_FLAG_DROWNING_BIT,PEEP_FLAGS(a0)
        bne     .do_drown

        ; Is peep on water?
        move.w  PEEP_R(a0),d0
        move.w  PEEP_C(a0),d1
        bsr     map_get_flags
        btst    #0,d0                   ; TF_WATER
        beq.s   .not_drowning
        ; Start drowning
        or.b    #PEEP_FLAG_DROWNING,PEEP_FLAGS(a0)
        bra     .next_peep

.not_drowning:
        ; --- Animation ---
        subq.b  #1,PEEP_ANIM_TMR(a0)
        bgt.s   .anim_done
        move.b  #PEEP_ANIM_TICKS,PEEP_ANIM_TMR(a0)
        move.b  PEEP_ANIM(a0),d0
        addq.b  #1,d0
        and.b   #3,d0
        move.b  d0,PEEP_ANIM(a0)
.anim_done:

        ; --- Movement speed timer ---
        move.w  PEEP_SPEED(a0),d1
        subq.w  #1,PEEP_SPEED(a0)
        bgt     .next_peep              ; Not time to move yet
        ; Reset timer
        btst    #PEEP_FLAG_KNIGHT_BIT,PEEP_FLAGS(a0)
        bne.s   .knight_speed
        move.w  #PEEP_TICKS_NORMAL,PEEP_SPEED(a0)
        bra.s   .do_move
.knight_speed:
        move.w  #PEEP_TICKS_KNIGHT,PEEP_SPEED(a0)

        ; --- State machine ---
.do_move:
        move.b  PEEP_STATE(a0),d0
        cmp.b   #PEEP_STATE_BUILD,d0
        beq     .state_build
        cmp.b   #PEEP_STATE_ASSEMBLE,d0
        beq     .state_assemble
        cmp.b   #PEEP_STATE_FIGHT,d0
        beq     .state_fight
        cmp.b   #PEEP_STATE_PAPAL,d0
        beq     .state_papal
        ; Default: explore
        bsr     peep_move_explore
        bra     .next_peep

.state_build:
        bsr     peep_move_build
        bra     .next_peep

.state_assemble:
        bsr     peep_move_assemble
        bra     .next_peep

.state_fight:
        bsr     peep_move_fight
        bra     .next_peep

.state_papal:
        bsr     peep_move_papal
        bra     .next_peep

        ; --- Drowning ---
.do_drown:
        ; Decrease energy each tick
        sub.w   #2,PEEP_ENERGY(a0)
        bgt.s   .still_alive
        ; Die
        or.b    #PEEP_FLAG_DEAD,PEEP_FLAGS(a0)
        bra     .next_peep
.still_alive:
        ; Advance drowning animation frame
        subq.b  #1,PEEP_ANIM_TMR(a0)
        bgt.s   .next_peep
        move.b  #PEEP_ANIM_TICKS,PEEP_ANIM_TMR(a0)
        move.b  PEEP_ANIM(a0),d0
        addq.b  #1,d0
        and.b   #3,d0
        move.b  d0,PEEP_ANIM(a0)

.next_peep:
        add.l   #PEEP_SIZE,a0
        dbf     d7,.loop

        ; --- Post-update: check fusions and combat ---
        bsr     peep_check_fusions
        bsr     peep_check_combat

.done:  movem.l (sp)+,d0-d7/a0-a5
        rts

; ---------------------------------------------------------------------------
; peep_move_explore — random wander toward buildable terrain
; a0 = current peep
; ---------------------------------------------------------------------------
peep_move_explore:
        ; Pick a random direction with slight bias toward unexplored terrain
        bsr     rnd_byte
        and.b   #7,d0                   ; 0–7
        move.b  d0,PEEP_DIR(a0)

        move.w  PEEP_R(a0),d1
        move.w  PEEP_C(a0),d2

        lea     dir_delta,a1
        lsl.w   #1,d0
        move.b  (a1,d0.w),d3            ; dr (signed)
        move.b  1(a1,d0.w),d4           ; dc (signed)
        ext.w   d3
        ext.w   d4

        add.w   d3,d1
        add.w   d4,d2

        ; Bounds clamp
        tst.w   d1
        bge.s   .r_pos
        clr.w   d1
.r_pos: cmp.w   #GRID_H-1,d1
        ble.s   .c_check
        move.w  #GRID_H-1,d1
.c_check:
        tst.w   d2
        bge.s   .c_pos
        clr.w   d2
.c_pos: cmp.w   #GRID_W-1,d2
        ble.s   .do_step
        move.w  #GRID_W-1,d2

.do_step:
        move.w  d1,PEEP_R(a0)
        move.w  d2,PEEP_C(a0)
        rts

; ---------------------------------------------------------------------------
; peep_move_build — move toward the nearest buildable flat tile, then build
; a0 = current peep
; ---------------------------------------------------------------------------
peep_move_build:
        ; If peep has a target, move toward it; else pick new target
        move.w  PEEP_TARGET_R(a0),d2
        cmp.w   #-1,d2
        beq.s   .pick_target

        ; Move one step toward target
        move.w  PEEP_R(a0),d0
        move.w  PEEP_C(a0),d1
        bsr     peep_step_toward
        rts

.pick_target:
        ; Search a 5×5 area for a flat non-water tile
        move.w  PEEP_R(a0),d5
        move.w  PEEP_C(a0),d6
        move.w  #-2,d3
.br:    move.w  #-2,d4
.bc:
        move.w  d5,d0
        add.w   d3,d0
        move.w  d6,d1
        add.w   d4,d1
        tst.w   d0
        blt.s   .bskip
        tst.w   d1
        blt.s   .bskip
        cmp.w   #GRID_H-1,d0
        bge.s   .bskip
        cmp.w   #GRID_W-1,d1
        bge.s   .bskip
        bsr     map_get_flags
        btst    #0,d0
        bne.s   .bskip          ; water
        move.w  d5,d0
        add.w   d3,d0
        move.w  d6,d1
        add.w   d4,d1
        bsr     map_is_flat
        tst.b   d0
        beq.s   .bskip
        ; Found a buildable tile
        move.w  d5,d0
        add.w   d3,d0
        move.w  d6,d1
        add.w   d4,d1
        move.w  d0,PEEP_TARGET_R(a0)
        move.w  d1,PEEP_TARGET_C(a0)
        rts
.bskip:
        addq.w  #1,d4
        cmp.w   #2,d4
        ble     .bc
        addq.w  #1,d3
        cmp.w   #2,d3
        ble     .br

        ; No target found — explore instead
        bsr     peep_move_explore
        rts

; ---------------------------------------------------------------------------
; peep_move_assemble — move toward another friendly peep for fusion
; ---------------------------------------------------------------------------
peep_move_assemble:
        ; Move toward the nearest same-team peep that isn't us
        movem.l d0-d6/a1,-(sp)
        move.w  PEEP_R(a0),d5
        move.w  PEEP_C(a0),d6
        move.b  PEEP_TEAM(a0),d3

        lea     peep_data,a1
        move.w  peep_count,d4
        beq     .no_friend
        subq.w  #1,d4
        move.w  #$7fff,d2               ; best dist²
        move.w  #-1,d1                  ; best index

.scan:
        btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a1)
        bne.s   .skip_p
        cmp.a   a0,a1
        beq.s   .skip_p
        cmp.b   PEEP_TEAM(a1),d3
        bne.s   .skip_p
        ; Compute distance²
        move.w  PEEP_R(a1),d0
        sub.w   d5,d0
        muls    d0,d0
        move.w  PEEP_C(a1),d7
        sub.w   d6,d7
        muls    d7,d7
        add.w   d7,d0
        cmp.w   d2,d0
        bge.s   .skip_p
        move.w  d0,d2
        move.w  PEEP_R(a1),best_r
        move.w  PEEP_C(a1),best_c
        moveq   #1,d1                   ; mark that we found a valid friend
.skip_p:
        add.l   #PEEP_SIZE,a1
        dbf     d4,.scan

        tst.w   d1
        blt.s   .no_friend
        move.w  best_r,PEEP_TARGET_R(a0)
        move.w  best_c,PEEP_TARGET_C(a0)
        move.w  PEEP_R(a0),d0
        move.w  PEEP_C(a0),d1
        bsr     peep_step_toward
        movem.l (sp)+,d0-d6/a1
        rts
.no_friend:
        movem.l (sp)+,d0-d6/a1
        bra     peep_move_explore

best_r: dc.w    0
best_c: dc.w    0

; ---------------------------------------------------------------------------
; peep_move_fight — seek nearest enemy peep or building
; ---------------------------------------------------------------------------
peep_move_fight:
        movem.l d0-d6/a1,-(sp)
        move.w  PEEP_R(a0),d5
        move.w  PEEP_C(a0),d6
        move.b  PEEP_TEAM(a0),d3

        ; Scan for nearest enemy peep
        lea     peep_data,a1
        move.w  peep_count,d4
        beq     .no_enemy
        subq.w  #1,d4
        move.w  #$7fff,d2
        move.w  #-1,d1

.escan:
        btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a1)
        bne.s   .eskip
        cmp.b   PEEP_TEAM(a1),d3
        beq.s   .eskip              ; same team
        move.w  PEEP_R(a1),d0
        sub.w   d5,d0
        muls    d0,d0
        move.w  PEEP_C(a1),d7
        sub.w   d6,d7
        muls    d7,d7
        add.w   d7,d0
        cmp.w   d2,d0
        bge.s   .eskip
        move.w  d0,d2
        move.w  PEEP_R(a1),fight_tr
        move.w  PEEP_C(a1),fight_tc
        moveq   #1,d1
.eskip: add.l   #PEEP_SIZE,a1
        dbf     d4,.escan

        tst.w   d1
        blt.s   .no_enemy
        move.w  fight_tr,PEEP_TARGET_R(a0)
        move.w  fight_tc,PEEP_TARGET_C(a0)
        move.w  PEEP_R(a0),d0
        move.w  PEEP_C(a0),d1
        bsr     peep_step_toward
        movem.l (sp)+,d0-d6/a1
        rts
.no_enemy:
        movem.l (sp)+,d0-d6/a1
        bra     peep_move_explore

fight_tr: dc.w  0
fight_tc: dc.w  0

; ---------------------------------------------------------------------------
; peep_move_papal — move toward papal magnet position
; ---------------------------------------------------------------------------
peep_move_papal:
        move.b  PEEP_TEAM(a0),d0
        tst.b   d0
        beq.s   .ally_papal
        ; Foe team
        move.w  papal_pos_foe,PEEP_TARGET_R(a0)
        move.w  papal_pos_foe+2,PEEP_TARGET_C(a0)
        bra.s   .do_papal_move
.ally_papal:
        move.w  papal_pos_ally,PEEP_TARGET_R(a0)
        move.w  papal_pos_ally+2,PEEP_TARGET_C(a0)
.do_papal_move:
        move.w  PEEP_R(a0),d0
        move.w  PEEP_C(a0),d1
        bsr     peep_step_toward
        rts

; ---------------------------------------------------------------------------
; peep_step_toward — move one tile closer to PEEP_TARGET (r,c)
; In: d0.w=current_r, d1.w=current_c, a0=peep
; ---------------------------------------------------------------------------
peep_step_toward:
        move.w  PEEP_TARGET_R(a0),d2
        move.w  PEEP_TARGET_C(a0),d3

        ; Already at target?
        cmp.w   d0,d2
        bne.s   .not_same
        cmp.w   d1,d3
        bne.s   .not_same
        ; At target — stop
        rts

.not_same:
        ; Compute step
        move.w  d0,d4
        move.w  d1,d5

        ; dr: +1, -1, or 0
        cmp.w   d4,d2
        bgt.s   .r_pos
        blt.s   .r_neg
        bra.s   .r_zero
.r_pos: addq.w  #1,d4
        bra.s   .c_step
.r_neg: subq.w  #1,d4
        bra.s   .c_step
.r_zero:

.c_step:
        cmp.w   d5,d3
        bgt.s   .c_pos
        blt.s   .c_neg
        bra.s   .c_zero
.c_pos: addq.w  #1,d5
        bra.s   .check
.c_neg: subq.w  #1,d5
        bra.s   .check
.c_zero:

.check:
        ; Bounds
        tst.w   d4
        blt.s   .step_fail
        tst.w   d5
        blt.s   .step_fail
        cmp.w   #GRID_H-1,d4
        bgt.s   .step_fail
        cmp.w   #GRID_W-1,d5
        bgt.s   .step_fail

        move.w  d4,PEEP_R(a0)
        move.w  d5,PEEP_C(a0)

        ; Update direction sprite based on delta
        sub.w   d0,d4                   ; dr
        sub.w   d1,d5                   ; dc
        bsr     peep_delta_to_dir
        move.b  d0,PEEP_DIR(a0)
        rts

.step_fail:
        rts

; ---------------------------------------------------------------------------
; peep_delta_to_dir — map (dr, dc) delta to DIR constant
; In: d4.w=dr, d5.w=dc  Out: d0.b = direction
; ---------------------------------------------------------------------------
peep_delta_to_dir:
        tst.w   d4
        blt.s   .north
        bgt.s   .south
        ; dr=0
        tst.w   d5
        blt.s   .west_h
        bgt.s   .east_h
        move.b  #DIR_S,d0               ; stationary, keep south
        rts
.east_h:  move.b  #DIR_SE,d0 : rts
.west_h:  move.b  #DIR_NW,d0 : rts

.north:
        tst.w   d5
        blt.s   .n_w
        bgt.s   .n_e
        move.b  #DIR_N,d0 : rts
.n_e:   move.b  #DIR_NE,d0 : rts
.n_w:   move.b  #DIR_NW,d0 : rts

.south:
        tst.w   d5
        blt.s   .s_w
        bgt.s   .s_e
        move.b  #DIR_S,d0 : rts
.s_e:   move.b  #DIR_SE,d0 : rts
.s_w:   move.b  #DIR_SW,d0 : rts

; ---------------------------------------------------------------------------
; peep_check_fusions — merge co-located same-team peeps
; Two peeps on the exact same tile fuse: sum energy (capped 255), one dies.
; ---------------------------------------------------------------------------
peep_check_fusions:
        movem.l d0-d7/a0-a2,-(sp)
        move.w  peep_count,d7
        beq     .done
        subq.w  #1,d7
        lea     peep_data,a0

.outer:
        btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a0)
        bne.s   .next_o
        btst    #PEEP_FLAG_KNIGHT_BIT,PEEP_FLAGS(a0)
        bne.s   .next_o         ; Knights don't fuse

        move.w  PEEP_R(a0),d0
        move.w  PEEP_C(a0),d1
        move.b  PEEP_TEAM(a0),d2

        ; Inner scan: all peeps, skip self and already-dead
        lea     peep_data,a1
        move.w  peep_count,d6
        beq.s   .next_o
        subq.w  #1,d6
.inner:
        tst.w   d6
        blt.s   .next_o
        cmp.a   a0,a1                   ; skip self
        beq.s   .next_i
        btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a1)
        bne.s   .next_i
        cmp.b   PEEP_TEAM(a1),d2
        bne.s   .next_i
        btst    #PEEP_FLAG_KNIGHT_BIT,PEEP_FLAGS(a1)
        bne.s   .next_i
        cmp.w   PEEP_R(a1),d0
        bne.s   .next_i
        cmp.w   PEEP_C(a1),d1
        bne.s   .next_i
        ; Fuse: merge energy
        move.w  PEEP_ENERGY(a0),d3
        add.w   PEEP_ENERGY(a1),d3
        cmp.w   #255,d3
        ble.s   .ok_e
        move.w  #255,d3
.ok_e:  move.w  d3,PEEP_ENERGY(a0)
        ; Kill the inner peep
        or.b    #PEEP_FLAG_DEAD,PEEP_FLAGS(a1)
        ; Transfer shield if inner had it
        btst    #PEEP_FLAG_SHIELD_BIT,PEEP_FLAGS(a1)
        beq.s   .next_i
        or.b    #PEEP_FLAG_SHIELD,PEEP_FLAGS(a0)
.next_i:
        add.l   #PEEP_SIZE,a1
        subq.w  #1,d6
        bra     .inner
.next_o:
        add.l   #PEEP_SIZE,a0
        dbf     d7,.outer
.done:  movem.l (sp)+,d0-d7/a0-a2
        rts

; ---------------------------------------------------------------------------
; peep_check_combat — battle adjacent enemy peeps
; ---------------------------------------------------------------------------
peep_check_combat:
        movem.l d0-d7/a0-a2,-(sp)
        move.w  peep_count,d7
        beq     .done
        subq.w  #1,d7
        lea     peep_data,a0

.co:    btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a0)
        bne     .co_next
        move.w  PEEP_R(a0),d0
        move.w  PEEP_C(a0),d1
        move.b  PEEP_TEAM(a0),d2

        ; Scan for enemies within 1 tile
        lea     peep_data,a1
        move.w  peep_count,d5
        subq.w  #1,d5
.ci:    tst.w   d5
        blt.s   .co_next
        cmp.a   a0,a1
        beq.s   .ci_next
        btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a1)
        bne.s   .ci_next
        cmp.b   PEEP_TEAM(a1),d2
        beq.s   .ci_next        ; same team

        ; Check adjacency (Manhattan distance ≤ 1)
        move.w  PEEP_R(a1),d3
        sub.w   d0,d3
        bge.s   .r_abs
        neg.w   d3
.r_abs: move.w  PEEP_C(a1),d4
        sub.w   d1,d4
        bge.s   .c_abs
        neg.w   d4
.c_abs:
        add.w   d3,d4
        cmp.w   #1,d4
        bgt.s   .ci_next

        ; Battle: each loses energy proportional to opponent's energy + random
        bsr     rnd_byte
        and.w   #$001f,d0               ; 0–31 random bonus
        move.w  PEEP_ENERGY(a1),d3
        add.w   d0,d3                   ; attacker strength
        sub.w   d3,PEEP_ENERGY(a0)

        bsr     rnd_byte
        and.w   #$001f,d0
        move.w  PEEP_ENERGY(a0),d4
        add.w   d0,d4
        sub.w   d4,PEEP_ENERGY(a1)

        ; Kill if energy ≤ 0
        tst.w   PEEP_ENERGY(a0)
        bgt.s   .a0_alive
        or.b    #PEEP_FLAG_DEAD,PEEP_FLAGS(a0)
.a0_alive:
        tst.w   PEEP_ENERGY(a1)
        bgt.s   .ci_next
        or.b    #PEEP_FLAG_DEAD,PEEP_FLAGS(a1)

.ci_next:
        add.l   #PEEP_SIZE,a1
        subq.w  #1,d5
        bra     .ci
.co_next:
        add.l   #PEEP_SIZE,a0
        dbf     d7,.co
.done:  movem.l (sp)+,d0-d7/a0-a2
        rts

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
        section data_c,data_c
peep_count:         dc.w    0
papal_pos_ally:     dc.w    32,32       ; (r, c) default centre
papal_pos_foe:      dc.w    32,32

        section bss_c,bss_c
peep_data:          ds.b    MAX_PEEPS*PEEP_SIZE
