; =============================================================================
; POPULOUS AMIGA - map.asm
; 64×64 terrain grid management.
;
; Terrain is stored as two parallel byte arrays:
;   terrain_height[GRID_H][GRID_W]  — altitude 0–7 at each corner
;   terrain_flags [GRID_H][GRID_W]  — TF_WATER / TF_SWAMP / TF_ROCK / TF_CONSTRUCTED
;
; Corner model (same as Python game_map.py):
;   Each tile (r,c) has four corners: NW(r,c), NE(r,c+1), SE(r+1,c+1), SW(r+1,c)
;   => altitude of corner at position (r,c) = terrain_height[r][c]
;
; All terrain mutation functions match the Python equivalents in game_map.py.
; =============================================================================

        include "hardware.inc"
        include "macros.inc"
        include "data.inc"

        xdef    map_init
        xdef    map_get_corner_alt
        xdef    map_set_corner_alt
        xdef    map_get_flags
        xdef    map_set_flag
        xdef    map_clear_flag
        xdef    map_raise_corner
        xdef    map_lower_corner
        xdef    map_get_raise_cost
        xdef    map_get_lower_cost
        xdef    map_get_tile_min_alt
        xdef    map_is_flat
        xdef    map_get_flat_area_score
        xdef    map_do_flood
        xdef    map_do_quake
        xdef    map_do_volcano
        xdef    map_do_swamp
        xdef    map_update_tile
        xdef    map_randomize
        xdef    terrain_height
        xdef    terrain_flags

; ---------------------------------------------------------------------------
; map_init — clear terrain and flags arrays, set water level
; ---------------------------------------------------------------------------
map_init:
        lea     terrain_height,a0
        lea     terrain_flags,a1
        move.w  #GRID_SIZE-1,d7
.clr:   clr.b   (a0)+
        clr.b   (a1)+
        dbf     d7,.clr
        rts

; ---------------------------------------------------------------------------
; map_randomize — generate a random terrain matching Python game_map randomise
; Simple fault-line algorithm: apply N random raises, then smooth
; ---------------------------------------------------------------------------
map_randomize:
        movem.l d0-d7/a0-a3,-(sp)

        ; Fill terrain with base altitude 1
        lea     terrain_height,a0
        move.w  #GRID_SIZE-1,d7
.fill:  move.b  #1,(a0)+
        dbf     d7,.fill

        ; Apply 80 random fault-line raises
        move.w  #80,d7
.fault: bsr     rnd_word                ; d0 = random word
        and.w   #$003f,d0               ; row 0–63
        move.w  d0,d5
        bsr     rnd_word
        and.w   #$003f,d0               ; col 0–63
        move.w  d0,d6

        ; Raise a 5×5 area around (d5,d6)
        move.w  d5,d3
        sub.w   #2,d3
        cmp.w   #0,d3
        bge.s   .r_ok
        clr.w   d3
.r_ok:  move.w  d6,d4
        sub.w   #2,d4
        cmp.w   #0,d4
        bge.s   .c_ok
        clr.w   d4
.c_ok:
        move.w  d3,d1
.r_inner:
        move.w  d4,d2
.c_inner:
        TERRAIN_IDX d1,d2,d0
        lea     terrain_height,a0
        move.b  (a0,d0.w),d0
        cmp.b   #ALT_MAX,d0
        bge.s   .no_raise
        addq.b  #1,(a0,d0.w)
.no_raise:
        addq.w  #1,d2
        cmp.w   #GRID_W,d2
        bge.s   .done_c
        move.w  d6,d0
        add.w   #2,d0
        cmp.w   d0,d2
        ble     .done_c
        bra     .c_inner
.done_c:
        addq.w  #1,d1
        cmp.w   #GRID_H,d1
        bge.s   .done_r
        move.w  d5,d0
        add.w   #2,d0
        cmp.w   d0,d1
        ble     .done_r
        bra     .r_inner
.done_r:
        dbf     d7,.fault

        ; Set water tiles (altitude=0 -> TF_WATER)
        lea     terrain_height,a0
        lea     terrain_flags,a1
        move.w  #GRID_SIZE-1,d7
.water: tst.b   (a0)
        bne.s   .not_water
        or.b    #TF_WATER,(a1)
.not_water:
        addq.l  #1,a0
        addq.l  #1,a1
        dbf     d7,.water

        movem.l (sp)+,d0-d7/a0-a3
        rts

; ---------------------------------------------------------------------------
; map_get_corner_alt — get altitude of corner at (r, c)
; In:  d0.w = r,  d1.w = c
; Out: d0.b = altitude (0–7), or 0 if out of bounds
; ---------------------------------------------------------------------------
map_get_corner_alt:
        ; Clamp to 0..GRID_H,  0..GRID_W
        tst.w   d0
        blt.s   .zero
        tst.w   d1
        blt.s   .zero
        cmp.w   #GRID_H,d0
        bgt.s   .zero
        cmp.w   #GRID_W,d1
        bgt.s   .zero

        TERRAIN_IDX d0,d1,d2
        lea     terrain_height,a0
        move.b  (a0,d2.w),d0
        rts
.zero:  moveq   #0,d0
        rts

; ---------------------------------------------------------------------------
; map_set_corner_alt — set altitude of corner at (r, c)
; In:  d0.w = r,  d1.w = c,  d2.b = new altitude
; ---------------------------------------------------------------------------
map_set_corner_alt:
        tst.w   d0
        blt     .done
        tst.w   d1
        blt     .done
        cmp.w   #GRID_H,d0
        bge     .done
        cmp.w   #GRID_W,d1
        bge     .done
        TERRAIN_IDX d0,d1,d3
        lea     terrain_height,a0
        move.b  d2,(a0,d3.w)
        ; Update TF_WATER flag
        lea     terrain_flags,a0
        tst.b   d2
        bne.s   .clear_water
        or.b    #TF_WATER,(a0,d3.w)
        bra     .done
.clear_water:
        and.b   #~TF_WATER,(a0,d3.w)
.done:  rts

; ---------------------------------------------------------------------------
; map_get_flags — return terrain flags byte
; In:  d0.w = r,  d1.w = c
; Out: d0.b = flags
; ---------------------------------------------------------------------------
map_get_flags:
        tst.w   d0
        blt.s   .zero
        tst.w   d1
        blt.s   .zero
        cmp.w   #GRID_H,d0
        bge.s   .zero
        cmp.w   #GRID_W,d1
        bge.s   .zero
        TERRAIN_IDX d0,d1,d2
        lea     terrain_flags,a0
        move.b  (a0,d2.w),d0
        rts
.zero:  clr.b   d0
        rts

; ---------------------------------------------------------------------------
; map_set_flag / map_clear_flag
; In:  d0.w=r, d1.w=c, d2.b=flag mask
; ---------------------------------------------------------------------------
map_set_flag:
        tst.w   d0
        blt     .done
        tst.w   d1
        blt     .done
        cmp.w   #GRID_H,d0
        bge     .done
        cmp.w   #GRID_W,d1
        bge     .done
        TERRAIN_IDX d0,d1,d3
        lea     terrain_flags,a0
        or.b    d2,(a0,d3.w)
.done:  rts

map_clear_flag:
        tst.w   d0
        blt     .done
        tst.w   d1
        blt     .done
        cmp.w   #GRID_H,d0
        bge     .done
        cmp.w   #GRID_W,d1
        bge     .done
        TERRAIN_IDX d0,d1,d3
        lea     terrain_flags,a0
        not.b   d2
        and.b   d2,(a0,d3.w)
.done:  rts

; ---------------------------------------------------------------------------
; map_get_tile_min_alt — return minimum altitude of the 4 corners of tile (r,c)
; In:  d0.w=r, d1.w=c
; Out: d0.b = min altitude (0–7)
; Trashes: d1–d4
; ---------------------------------------------------------------------------
map_get_tile_min_alt:
        movem.l d1-d4,-(sp)
        move.w  d0,d2
        move.w  d1,d3

        ; NW = (r, c)
        bsr     map_get_corner_alt
        move.b  d0,d4

        ; NE = (r, c+1)
        move.w  d2,d0
        move.w  d3,d1
        addq.w  #1,d1
        bsr     map_get_corner_alt
        cmp.b   d4,d0
        bge.s   .ne_ok
        move.b  d0,d4
.ne_ok:
        ; SE = (r+1, c+1)
        move.w  d2,d0
        addq.w  #1,d0
        move.w  d3,d1
        addq.w  #1,d1
        bsr     map_get_corner_alt
        cmp.b   d4,d0
        bge.s   .se_ok
        move.b  d0,d4
.se_ok:
        ; SW = (r+1, c)
        move.w  d2,d0
        addq.w  #1,d0
        move.w  d3,d1
        bsr     map_get_corner_alt
        cmp.b   d4,d0
        bge.s   .sw_ok
        move.b  d0,d4
.sw_ok:
        move.b  d4,d0
        movem.l (sp)+,d1-d4
        rts

; ---------------------------------------------------------------------------
; map_is_flat — check if all 4 corners of tile (r,c) have the same altitude
; In:  d0.w=r, d1.w=c
; Out: d0.b = 1 if flat, 0 otherwise
; Trashes: d1–d4
; ---------------------------------------------------------------------------
map_is_flat:
        movem.l d1-d5,-(sp)
        move.w  d0,d4
        move.w  d1,d5

        bsr     map_get_tile_min_alt
        move.b  d0,d3                   ; min altitude

        ; Max altitude
        move.w  d4,d0
        move.w  d5,d1
        addq.w  #1,d0
        addq.w  #1,d1
        bsr     map_get_corner_alt
        move.b  d0,d2

        move.w  d4,d0
        move.w  d5,d1
        bsr     map_get_corner_alt
        cmp.b   d2,d0
        bgt.s   .upd
        move.b  d0,d2
.upd:
        ; Compare min == max
        cmp.b   d3,d2
        seq     d0
        and.b   #1,d0
        movem.l (sp)+,d1-d5
        rts

; ---------------------------------------------------------------------------
; map_get_flat_area_score — count flat buildable tiles in a 5×5 zone
; (identical to Python get_flat_area_score)
; In:  d0.w=center_r, d1.w=center_c
;      d2.b=0 normal (4×4), 1=castle (5×5 up to score 24)
; Out: d0.w = score (number of flat tiles), d1.w = -1 if centre not flat
; Trashes: d2–d7/a0
; ---------------------------------------------------------------------------
map_get_flat_area_score:
        movem.l d2-d7/a0,-(sp)
        move.w  d0,d4                   ; centre r
        move.w  d1,d5                   ; centre c

        ; Check centre tile flatness
        bsr     map_is_flat
        tst.b   d0
        bne.s   .centre_flat
        ; Centre not flat → return -1
        move.w  #-1,d0
        move.w  #-1,d1
        movem.l (sp)+,d2-d7/a0
        rts

.centre_flat:
        ; Determine scan range
        tst.b   d2
        beq.s   .norm_range
        move.w  #-2,d6          ; castle: -2 to +2
        move.w  #2,d7
        bra.s   .scan
.norm_range:
        move.w  #-2,d6          ; normal: -2 to +2 (same, just threshold differs)
        move.w  #2,d7

.scan:
        clr.w   d3              ; score counter

        move.w  d6,d0           ; dr = -2
.dr_loop:
        move.w  d6,d1           ; dc = -2
.dc_loop:
        move.w  d4,d2
        add.w   d0,d2           ; tr = centre_r + dr
        move.w  d5,d3_tmp
        add.w   d1,d3_tmp       ; tc = centre_c + dc

        ; Bounds check
        tst.w   d2
        blt.s   .skip_tile
        tst.w   d3_tmp
        blt.s   .skip_tile
        cmp.w   #GRID_H-1,d2
        bge.s   .skip_tile
        cmp.w   #GRID_W-1,d3_tmp
        bge.s   .skip_tile

        ; Check water
        move.w  d2,d3_arg
        move.w  d3_tmp,d4_arg
        bsr     map_get_flags
        btst    #0,d0           ; TF_WATER
        bne.s   .skip_tile

        ; Check flat
        move.w  d3_arg,d0
        move.w  d4_arg,d1
        bsr     map_is_flat
        tst.b   d0
        beq.s   .skip_tile

        addq.w  #1,d3           ; increment score
.skip_tile:
        addq.w  #1,d1           ; dc++
        cmp.w   d7,d1
        ble     .dc_loop
        addq.w  #1,d0           ; dr++
        cmp.w   d7,d0
        ble     .dr_loop

        move.w  d3,d0           ; score
        movem.l (sp)+,d2-d7/a0
        rts

; Temporary argument storage (since 68000 lacks enough registers)
d3_tmp: dc.w    0
d3_arg: dc.w    0
d4_arg: dc.w    0

; ---------------------------------------------------------------------------
; map_get_raise_cost — returns the mana cost to raise corner (r,c)
; In:  d0.w=r, d1.w=c
; Out: d0.w = cost (0 if not raiseable)
; ---------------------------------------------------------------------------
map_get_raise_cost:
        bsr     map_get_corner_alt
        cmp.b   #ALT_MAX,d0
        beq.s   .zero
        move.w  #COST_RAISE,d0
        rts
.zero:  clr.w   d0
        rts

; ---------------------------------------------------------------------------
; map_get_lower_cost
; In:  d0.w=r, d1.w=c
; Out: d0.w = cost (0 if not lowerable)
; ---------------------------------------------------------------------------
map_get_lower_cost:
        bsr     map_get_corner_alt
        tst.b   d0
        beq.s   .zero
        move.w  #COST_LOWER,d0
        rts
.zero:  clr.w   d0
        rts

; ---------------------------------------------------------------------------
; map_raise_corner — raise corner (r,c) by 1, clamped to ALT_MAX
; In:  d0.w=r, d1.w=c
; ---------------------------------------------------------------------------
map_raise_corner:
        movem.l d0-d2,-(sp)
        move.w  d0,d2
        move.w  d1,d1
        bsr     map_get_corner_alt
        cmp.b   #ALT_MAX,d0
        bge.s   .done
        addq.b  #1,d0
        move.w  d2,d0_tmp
        move.w  d1,d1_tmp
        bsr     .set
.done:  movem.l (sp)+,d0-d2
        rts
.set:   move.w  d0_tmp,d0
        move.w  d1_tmp,d1
        and.w   #$00ff,d2
        bsr     map_set_corner_alt
        rts

d0_tmp: dc.w    0
d1_tmp: dc.w    0

; ---------------------------------------------------------------------------
; map_lower_corner — lower corner (r,c) by 1, clamped to ALT_MIN
; In:  d0.w=r, d1.w=c
; ---------------------------------------------------------------------------
map_lower_corner:
        movem.l d0-d2,-(sp)
        move.w  d0,d2
        bsr     map_get_corner_alt
        tst.b   d0
        beq.s   .done
        subq.b  #1,d0
        move.w  d2,d0_tmp
        move.w  d1,d1_tmp
        bsr     map_raise_corner.set    ; reuse .set sub
.done:  movem.l (sp)+,d0-d2
        rts

; ---------------------------------------------------------------------------
; map_do_flood — raise water level (lower all terrain by 1, water expands)
; Matches Python game_map.do_flood()
; ---------------------------------------------------------------------------
map_do_flood:
        movem.l d0-d3/a0-a1,-(sp)
        lea     terrain_height,a0
        lea     terrain_flags,a1
        move.w  #GRID_SIZE-1,d7
.loop:  move.b  (a0),d0
        tst.b   d0
        beq.s   .already_water
        subq.b  #1,d0
        move.b  d0,(a0)
        tst.b   d0
        bne.s   .not_water_now
.already_water:
        or.b    #TF_WATER,(a1)
        bra.s   .next
.not_water_now:
        and.b   #~TF_WATER,(a1)
.next:  addq.l  #1,a0
        addq.l  #1,a1
        dbf     d7,.loop
        movem.l (sp)+,d0-d3/a0-a1
        rts

; ---------------------------------------------------------------------------
; map_do_quake — random terrain destruction around a target tile
; In:  d0.w=center_r, d1.w=center_c
; Matches Python game_map.do_quake()
; ---------------------------------------------------------------------------
map_do_quake:
        movem.l d0-d7/a0,-(sp)
        move.w  d0,d5
        move.w  d1,d6

        ; Iterate a 7×7 area, random chance to lower corners
        move.w  #-3,d3
.dr:    move.w  #-3,d4
.dc:
        move.w  d5,d0
        add.w   d3,d0
        move.w  d6,d1
        add.w   d4,d1
        ; Bounds check
        tst.w   d0
        blt.s   .skip
        tst.w   d1
        blt.s   .skip
        cmp.w   #GRID_H,d0
        bge.s   .skip
        cmp.w   #GRID_W,d1
        bge.s   .skip

        ; Random chance: 50%
        bsr     rnd_byte
        and.b   #1,d0
        beq.s   .skip

        ; Lower by 1 or 2
        bsr     rnd_byte
        and.b   #1,d2
        addq.b  #1,d2           ; lower 1–2 times
.lower_loop:
        bsr     map_lower_corner
        dbf     d2,.lower_loop

.skip:  addq.w  #1,d4
        cmp.w   #3,d4
        ble     .dc
        addq.w  #1,d3
        cmp.w   #3,d3
        ble     .dr

        movem.l (sp)+,d0-d7/a0
        rts

; ---------------------------------------------------------------------------
; map_do_volcano — create a small mountain at (r,c)
; In:  d0.w=r, d1.w=c
; Matches Python game_map.do_volcano()
; ---------------------------------------------------------------------------
map_do_volcano:
        movem.l d0-d7/a0,-(sp)
        move.w  d0,d5
        move.w  d1,d6

        ; Raise all corners in a 3×3 area to ALT_MAX, center to ALT_MAX
        move.w  #-1,d3
.vdr:   move.w  #-1,d4
.vdc:
        move.w  d5,d0
        add.w   d3,d0
        move.w  d6,d1
        add.w   d4,d1
        tst.w   d0
        blt.s   .vskip
        tst.w   d1
        blt.s   .vskip
        cmp.w   #GRID_H,d0
        bge.s   .vskip
        cmp.w   #GRID_W,d1
        bge.s   .vskip

        move.b  #ALT_MAX,d2
        bsr     map_set_corner_alt

.vskip: addq.w  #1,d4
        cmp.w   #1,d4
        ble     .vdc
        addq.w  #1,d3
        cmp.w   #1,d3
        ble     .vdr

        ; Set rock flag at centre
        move.w  d5,d0
        move.w  d6,d1
        move.b  #TF_ROCK,d2
        bsr     map_set_flag

        movem.l (sp)+,d0-d7/a0
        rts

; ---------------------------------------------------------------------------
; map_do_swamp — convert a tile to swamp
; In:  d0.w=r, d1.w=c
; ---------------------------------------------------------------------------
map_do_swamp:
        move.b  #TF_SWAMP,d2
        bsr     map_set_flag
        ; Lower all corners by 1 to create a depression
        movem.l d0-d1,-(sp)
        bsr     map_lower_corner
        addq.w  #1,d1
        bsr     map_lower_corner
        addq.w  #1,d0
        bsr     map_lower_corner
        subq.w  #1,d1
        bsr     map_lower_corner
        movem.l (sp)+,d0-d1
        rts

; ---------------------------------------------------------------------------
; map_update_tile — recompute flags for a tile after terrain change
; In:  d0.w=r, d1.w=c
; ---------------------------------------------------------------------------
map_update_tile:
        bsr     map_get_tile_min_alt
        tst.b   d0
        bne.s   .not_water
        move.w  d0,d0
        bsr     map_set_flag
        rts
.not_water:
        move.b  #TF_WATER,d2
        bsr     map_clear_flag
        rts

; ---------------------------------------------------------------------------
; rnd_word / rnd_byte — fast pseudo-random using a Galois LFSR (32-bit)
; Out: d0.w = random word (rnd_word), d0.b = random byte (rnd_byte)
; ---------------------------------------------------------------------------
        xdef    rnd_word
        xdef    rnd_byte
rnd_word:
        move.l  rnd_seed,d0
        lsr.l   #1,d0
        bcc.s   .no_xor
        eor.l   #$80000057,d0           ; Galois polynomial
.no_xor:
        move.l  d0,rnd_seed
        rts

rnd_byte:
        bsr     rnd_word
        rts                             ; low byte of d0 = random byte

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
        section data_c,data_c

rnd_seed:   dc.l    $deadbeef           ; LFSR seed (non-zero)

        section bss_c,bss_c             ; uninitialized chip RAM

terrain_height: ds.b    GRID_SIZE
terrain_flags:  ds.b    GRID_SIZE
