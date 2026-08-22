; =============================================================================
; POPULOUS AMIGA - house.asm
; Building (House) lifecycle management.
;
; Mirrors Python house.py:
;   - hut → house_small → … → castle (tiers 0–9)
;   - Territory score from flat-area scan
;   - Growth: life accumulates at tier-dependent speed; on overflow → spawn peep
;   - Buildings are destroyed if terrain under them is no longer flat
;   - Castle (tier 9) requires 5×5 flat zone (score ≥ 24)
; =============================================================================

        include "hardware.inc"
        include "macros.inc"
        include "data.inc"

        xdef    house_init
        xdef    house_add
        xdef    house_update_all
        xdef    house_find_at
        xdef    house_destroy
        xdef    house_data
        xdef    house_count

; Growth speeds indexed by tier (life increments per update tick)
house_growth_speeds:
        dc.b    1,2,3,4,5,6,8,10,12,16

; Max life per tier (16, 32, … 160)
house_max_life_tbl:
        dc.w    16,32,48,64,80,96,112,128,144,160

; Flat-area score thresholds for each tier
house_tier_thresholds:
        dc.b    0,1,3,5,7,9,11,12,14,16

; ---------------------------------------------------------------------------
; house_init — clear all house records
; ---------------------------------------------------------------------------
house_init:
        lea     house_data,a0
        move.w  #(MAX_HOUSES*HOUSE_SIZE)-1,d7
.clr:   clr.b   (a0)+
        dbf     d7,.clr
        clr.w   house_count
        rts

; ---------------------------------------------------------------------------
; house_add — add a new building at (r, c) for team
; In:  d0.w=r, d1.w=c, d2.b=team
; Out: d0.w = index (≥0) or -1 if no slot
; ---------------------------------------------------------------------------
house_add:
        movem.l d1-d7/a0,-(sp)
        ; Find a free slot (HOUSE_FLAG_DESTROYED set or HOUSE_LIFE=0 at slot never used)
        lea     house_data,a0
        move.w  house_count,d3
        cmp.w   #MAX_HOUSES,d3
        bge     .full

        ; Use house_count as next slot
        move.w  d3,d4
        mulu    #HOUSE_SIZE,d4
        add.l   d4,a0

        clr.b   HOUSE_FLAGS(a0)
        move.w  d0,HOUSE_R(a0)
        move.w  d1,HOUSE_C(a0)
        move.b  d2,HOUSE_TEAM(a0)
        move.b  #HOUSE_TYPE_HUT,HOUSE_TYPE(a0)
        move.w  #16,HOUSE_MAX_LIFE(a0)
        move.w  #8,HOUSE_LIFE(a0)       ; Start at half health
        clr.b   HOUSE_SCORE(a0)
        clr.b   HOUSE_TIER(a0)
        clr.b   HOUSE_GROWTH(a0)
        clr.b   HOUSE_OCC_CNT(a0)

        addq.w  #1,house_count
        move.w  d3,d0                   ; return index
        movem.l (sp)+,d1-d7/a0
        rts

.full:  move.w  #-1,d0
        movem.l (sp)+,d1-d7/a0
        rts

; ---------------------------------------------------------------------------
; house_update_all — update every building for one game tick
; In:  (none — uses globals)
;      a0 = pointer to game state (power jauge etc.) — not used here,
;           spawn flag on house is checked by populous.asm main loop
; Trashes: d0–d7/a0–a5
; ---------------------------------------------------------------------------
house_update_all:
        movem.l d0-d7/a0-a4,-(sp)
        move.w  house_count,d7
        beq     .done
        subq.w  #1,d7
        lea     house_data,a0

.loop:
        ; Skip destroyed buildings
        btst    #0,HOUSE_FLAGS(a0)      ; HOUSE_FLAG_DESTROYED
        bne     .next

        move.w  HOUSE_R(a0),d0
        move.w  HOUSE_C(a0),d1

        ; Get flat area score for centre tile
        move.b  #0,d2                   ; normal (not castle)
        bsr     map_get_flat_area_score
        move.w  d0,d3                   ; flat score

        ; If score = -1, terrain destroyed
        cmp.w   #-1,d3
        bne.s   .not_destroyed
        or.b    #HOUSE_FLAG_DESTROYED,HOUSE_FLAGS(a0)
        bra     .next
.not_destroyed:

        ; Determine tier from score
        bsr     house_score_to_tier     ; d0=score in, d0=tier out
        move.b  d0,HOUSE_TIER(a0)
        move.b  d0,d4

        ; Check for castle (score >= CASTLE_GRAND_SCORE)
        cmp.w   #CASTLE_GRAND_SCORE,d3
        blt.s   .not_castle
        move.b  #HOUSE_TYPE_CASTLE,HOUSE_TYPE(a0)
        move.b  #HOUSE_TYPE_CASTLE,d4
        bra.s   .got_type
.not_castle:
        ; Map tier to type
        lea     house_type_map,a1
        move.b  (a1,d4.w),HOUSE_TYPE(a0)
        move.b  (a1,d4.w),d4

.got_type:
        ; Update max life and growth speed
        and.w   #$00ff,d4
        cmp.w   #9,d4
        bgt.s   .clamp_tier
        bra.s   .update_life
.clamp_tier:
        move.b  #9,d4

.update_life:
        lea     house_max_life_tbl,a1
        lsl.w   #1,d4                   ; word index
        move.w  (a1,d4.w),HOUSE_MAX_LIFE(a0)
        lsr.w   #1,d4

        ; Grow life
        lea     house_growth_speeds,a1
        move.b  (a1,d4.w),d1            ; growth speed
        add.w   d1,HOUSE_LIFE(a0)

        ; Clamp and check spawn
        move.w  HOUSE_MAX_LIFE(a0),d2
        cmp.w   d2,HOUSE_LIFE(a0)
        blt.s   .no_spawn
        move.w  d2,HOUSE_LIFE(a0)       ; cap at max
        ; Signal spawn pending
        or.b    #HOUSE_FLAG_SPAWN_PEND,HOUSE_FLAGS(a0)
        clr.w   HOUSE_LIFE(a0)          ; Reset life after spawn

.no_spawn:
        ; Ensure life >= 1
        cmp.w   #1,HOUSE_LIFE(a0)
        bge.s   .life_ok
        move.w  #1,HOUSE_LIFE(a0)
.life_ok:

.next:  add.l   #HOUSE_SIZE,a0
        dbf     d7,.loop

.done:  movem.l (sp)+,d0-d7/a0-a4
        rts

; ---------------------------------------------------------------------------
; house_score_to_tier — map flat-area score to tier index
; In:  d0.w = score,  Out: d0.b = tier (0–8)
; ---------------------------------------------------------------------------
house_score_to_tier:
        lea     house_tier_thresholds,a0
        moveq   #0,d1                   ; current tier
        moveq   #8,d2                   ; max non-castle tier = 8
.loop:  cmp.b   d2,d1
        bge.s   .done
        move.b  (a0,d1.w),d3
        and.w   #$00ff,d3
        cmp.w   d3,d0
        bge.s   .ok
        subq.w  #1,d1
        bra.s   .done
.ok:    addq.w  #1,d1
        bra     .loop
.done:  tst.w   d1
        bge.s   .ret
        clr.w   d1
.ret:   move.b  d1,d0
        rts

; House type map indexed by tier
house_type_map:
        dc.b    HOUSE_TYPE_HUT, HOUSE_TYPE_HOUSE_S, HOUSE_TYPE_HOUSE_M
        dc.b    HOUSE_TYPE_CASTLE_S, HOUSE_TYPE_CASTLE_M, HOUSE_TYPE_CASTLE_L
        dc.b    HOUSE_TYPE_FORT_S, HOUSE_TYPE_FORT_M, HOUSE_TYPE_FORT_L
        dc.b    HOUSE_TYPE_CASTLE
        dc.b    0                       ; pad

; ---------------------------------------------------------------------------
; house_find_at — find a house at tile (r,c)
; In:  d0.w=r, d1.w=c
; Out: d0.w = index (≥0) or -1 if not found
; ---------------------------------------------------------------------------
house_find_at:
        lea     house_data,a0
        move.w  house_count,d2
        beq     .not_found
        subq.w  #1,d2
        clr.w   d3
.loop:
        btst    #0,HOUSE_FLAGS(a0)
        bne.s   .skip
        cmp.w   HOUSE_R(a0),d0
        bne.s   .skip
        cmp.w   HOUSE_C(a0),d1
        bne.s   .skip
        move.w  d3,d0
        rts
.skip:  add.l   #HOUSE_SIZE,a0
        addq.w  #1,d3
        dbf     d2,.loop
.not_found:
        move.w  #-1,d0
        rts

; ---------------------------------------------------------------------------
; house_destroy — mark a house as destroyed
; In:  d0.w = index
; ---------------------------------------------------------------------------
house_destroy:
        cmp.w   #MAX_HOUSES,d0
        bge     .done
        lea     house_data,a0
        mulu    #HOUSE_SIZE,d0
        add.l   d0,a0
        or.b    #HOUSE_FLAG_DESTROYED,HOUSE_FLAGS(a0)
.done:  rts

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
        section data_c,data_c
house_count:    dc.w    0

        section bss_c,bss_c
house_data:     ds.b    MAX_HOUSES*HOUSE_SIZE
