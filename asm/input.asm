; =============================================================================
; POPULOUS AMIGA - input.asm
; Mouse and keyboard input handling via CIA chips
;
; Mouse:   JOY0DAT counter for delta movement; CIA-A PRA bit 6 (LMB),
;          POTGOR bit 10 (RMB).
; Keyboard: CIA-A SDR serial register + CIA-A ICR SP flag.
;           Raw key codes are latched into key_state[] and key_new[].
; =============================================================================

        include "hardware.inc"
        include "data.inc"

        xdef    input_init
        xdef    input_update
        xdef    input_get_mouse_x
        xdef    input_get_mouse_y
        xdef    input_lmb_down
        xdef    input_rmb_down
        xdef    input_lmb_pressed
        xdef    input_rmb_pressed
        xdef    input_key_down
        xdef    input_key_pressed
        xdef    mouse_x
        xdef    mouse_y

; ---------------------------------------------------------------------------
; input_init — initialise CIA-A keyboard interrupt and mouse counters
; ---------------------------------------------------------------------------
input_init:
        ; Clear key state tables
        lea     key_state,a0
        moveq   #KEY_COUNT-1,d7
.clr:   clr.b   (a0)+
        dbf     d7,.clr

        lea     key_new,a0
        moveq   #KEY_COUNT-1,d7
.clr2:  clr.b   (a0)+
        dbf     d7,.clr2

        ; Clear mouse data
        clr.w   mouse_x
        clr.w   mouse_y
        clr.b   lmb_state
        clr.b   rmb_state
        clr.b   lmb_prev
        clr.b   rmb_prev

        ; Snapshot initial JOY0DAT values so first delta is 0
        move.w  CUSTOM+JOY0DAT,prev_joy0dat

        ; Install CIA-A keyboard interrupt via Level 2 (PORTS interrupt)
        ; We hook INTB_PORTS so that when CIA-A fires (SP bit in ICR),
        ; we read SDR and latch the key code.
        ; NOTE: For simplicity we poll the CIA in input_update instead of
        ;       using a full interrupt server.  This matches typical small
        ;       Amiga demos.  A real OS application would use AddIntServer.

        ; Enable CIA-A SP (serial port = keyboard) interrupt
        move.b  #%10001000,CIAA+CIAA_ICR  ; set SP bit, enable

        rts

; ---------------------------------------------------------------------------
; input_update — call once per frame to refresh all input state
; Must be called after VBL, before game logic.
; ---------------------------------------------------------------------------
input_update:
        ; --- Save previous button states ---
        move.b  lmb_state,lmb_prev
        move.b  rmb_state,rmb_prev

        ; --- Left Mouse Button (CIA-A PRA bit 6, active low) ---
        move.b  CIAA+CIAA_PRA,d0
        btst    #6,d0
        sne     d1                      ; d1=$ff if bit was set (button up)
        not.b   d1                      ; d1=$ff if button is down
        move.b  d1,lmb_state

        ; --- Right Mouse Button (POTGOR bit 10, active low) ---
        move.w  CUSTOM+POTGOR,d0
        btst    #10,d0
        sne     d1
        not.b   d1
        move.b  d1,rmb_state

        ; --- Mouse movement (JOY0DAT quadrature counters) ---
        move.w  CUSTOM+JOY0DAT,d0      ; d0 = current counter (Y in hi, X in lo)
        move.w  prev_joy0dat,d1        ; d1 = previous counter

        ; X delta (low byte)
        move.b  d0,d2
        sub.b   d1,d2                   ; signed 8-bit delta X
        ext.w   d2
        add.w   d2,mouse_x

        ; Y delta (high byte)
        move.w  d0,d2
        lsr.w   #8,d2
        move.w  d1,d3
        lsr.w   #8,d3
        sub.b   d3,d2                   ; signed 8-bit delta Y (quadrature)
        ext.w   d2
        add.w   d2,mouse_y

        move.w  d0,prev_joy0dat

        ; Clamp mouse to screen bounds
        tst.w   mouse_x
        bge.s   .clamp_x_max
        clr.w   mouse_x
        bra.s   .clamp_y
.clamp_x_max:
        cmp.w   #SCREEN_W-1,mouse_x
        ble.s   .clamp_y
        move.w  #SCREEN_W-1,mouse_x
.clamp_y:
        tst.w   mouse_y
        bge.s   .clamp_y_max
        clr.w   mouse_y
        bra.s   .kbd
.clamp_y_max:
        cmp.w   #SCREEN_H-1,mouse_y
        ble.s   .kbd
        move.w  #SCREEN_H-1,mouse_y

        ; --- Keyboard (poll CIA-A ICR for SP flag) ---
.kbd:
        ; Clear new-key array each frame
        lea     key_new,a0
        moveq   #KEY_COUNT-1,d7
.clr:   clr.b   (a0)+
        dbf     d7,.clr

        ; Poll for pending key codes
.kbd_poll:
        move.b  CIAA+CIAA_ICR,d0       ; Read & clear CIA-A ICR
        btst    #3,d0                   ; Bit 3 = SP (keyboard data ready)
        beq.s   .kbd_done

        move.b  CIAA+CIAA_SDR,d1       ; Read raw scan code from SDR
        ; Raw code: bits 7:1 = key number, bit 0 = 0 (make) or 1 (break)
        rol.b   #1,d1                   ; Rotate: key number into bits 7:1, key-up into bit 0
        move.b  d1,d2                   ; Save
        lsr.b   #1,d1                   ; d1 = key index (0–127)
        and.w   #$007f,d1               ; Mask to 7 bits

        ; Handshake: pulse CIA-A CRA to acknowledge
        move.b  CIAA+CIAA_CRA,d0
        or.b    #$40,d0                 ; Set bit 6 (SPMODE = output)
        move.b  d0,CIAA+CIAA_CRA
        and.b   #$bf,d0
        move.b  d0,CIAA+CIAA_CRA

        ; Update key_state and key_new
        lea     key_state,a0
        lea     key_new,a1
        btst    #0,d2                   ; Bit 0 of original (pre-rotate) = key-up
        bne.s   .key_up
        ; Key down
        move.b  #1,(a0,d1.w)            ; key_state[key] = 1
        move.b  #1,(a1,d1.w)            ; key_new[key]   = 1 (just pressed)
        bra.s   .kbd_poll
.key_up:
        clr.b   (a0,d1.w)               ; key_state[key] = 0
        bra.s   .kbd_poll

.kbd_done:
        rts

; ---------------------------------------------------------------------------
; input_get_mouse_x — return mouse X in d0.w
; ---------------------------------------------------------------------------
input_get_mouse_x:
        move.w  mouse_x,d0
        rts

; ---------------------------------------------------------------------------
; input_get_mouse_y — return mouse Y in d0.w
; ---------------------------------------------------------------------------
input_get_mouse_y:
        move.w  mouse_y,d0
        rts

; ---------------------------------------------------------------------------
; input_lmb_down — return d0.b = 1 if LMB currently held
; ---------------------------------------------------------------------------
input_lmb_down:
        move.b  lmb_state,d0
        rts

; ---------------------------------------------------------------------------
; input_rmb_down — return d0.b = 1 if RMB currently held
; ---------------------------------------------------------------------------
input_rmb_down:
        move.b  rmb_state,d0
        rts

; ---------------------------------------------------------------------------
; input_lmb_pressed — return d0.b = 1 if LMB just pressed this frame
; ---------------------------------------------------------------------------
input_lmb_pressed:
        move.b  lmb_state,d0
        and.b   #1,d0
        move.b  lmb_prev,d1
        and.b   #1,d1
        sub.b   d1,d0                   ; 1 only if currently down and was up
        bge.s   .done
        clr.b   d0
.done:  rts

; ---------------------------------------------------------------------------
; input_rmb_pressed — return d0.b = 1 if RMB just pressed this frame
; ---------------------------------------------------------------------------
input_rmb_pressed:
        move.b  rmb_state,d0
        and.b   #1,d0
        move.b  rmb_prev,d1
        and.b   #1,d1
        sub.b   d1,d0
        bge.s   .done2
        clr.b   d0
.done2: rts

; ---------------------------------------------------------------------------
; input_key_down  key_code  (in d0.b) — return d0.b = 1 if key held
; ---------------------------------------------------------------------------
input_key_down:
        and.w   #$007f,d0
        lea     key_state,a0
        move.b  (a0,d0.w),d0
        rts

; ---------------------------------------------------------------------------
; input_key_pressed  key_code  (in d0.b) — return d0.b = 1 if just pressed
; ---------------------------------------------------------------------------
input_key_pressed:
        and.w   #$007f,d0
        lea     key_new,a0
        move.b  (a0,d0.w),d0
        rts

; ---------------------------------------------------------------------------
; iso_screen_to_tile — convert screen (sx, sy) + camera (cr, cc) to tile (r, c)
;
; In:  d0.w = screen X,  d1.w = screen Y
;      d2.w = camera row, d3.w = camera col
; Out: d4.w = tile row,   d5.w = tile col  (-1,-1 if out of map)
;
; Inverse of ISO_PROJ macro:
;   sx - MAP_OFFSET_X = (c - r) * TILE_HALF_W
;   sy - MAP_OFFSET_Y = (c + r) * TILE_HALF_H
;   => c - r = (sx - MAP_OFFSET_X) / TILE_HALF_W
;   => c + r = (sy - MAP_OFFSET_Y) / TILE_HALF_H
;   => 2c = sum_cr + diff_cr  => c = (sum_cr + diff_cr) / 2
;   => 2r = sum_cr - diff_cr  => r = (sum_cr - diff_cr) / 2
; ---------------------------------------------------------------------------
        xdef    iso_screen_to_tile
iso_screen_to_tile:
        movem.l d0-d3,-(sp)

        sub.w   #MAP_OFFSET_X,d0
        sub.w   #MAP_OFFSET_Y,d1

        ; Divide by half-widths (shift)
        asr.w   #4,d0                   ; d0 = (sx-off) / TILE_HALF_W  (c - r)
        asr.w   #3,d1                   ; d1 = (sy-off) / TILE_HALF_H  (c + r)

        ; c = (d0 + d1) / 2,  r = (d1 - d0) / 2
        move.w  d0,d4
        add.w   d1,d4
        asr.w   #1,d4                   ; d4 = c (relative to camera)

        move.w  d1,d5
        sub.w   d0,d5
        asr.w   #1,d5                   ; d5 = r (relative to camera)

        ; Add camera offset
        add.w   d2,d5                   ; d5 = tile row (absolute)
        add.w   d3,d4                   ; d4 = tile col (absolute)

        ; Swap so d4=row, d5=col (caller expects row first)
        exg     d4,d5

        ; Bounds check
        tst.w   d4
        blt.s   .oob
        tst.w   d5
        blt.s   .oob
        cmp.w   #GRID_H,d4
        bge.s   .oob
        cmp.w   #GRID_W,d5
        bge.s   .oob
        bra.s   .done_iso

.oob:   move.w  #-1,d4
        move.w  #-1,d5
.done_iso:
        movem.l (sp)+,d0-d3
        rts

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
        section data_c,data_c           ; chip RAM data section

mouse_x:        dc.w    SCREEN_W/2
mouse_y:        dc.w    SCREEN_H/2
prev_joy0dat:   dc.w    0
lmb_state:      dc.b    0
rmb_state:      dc.b    0
lmb_prev:       dc.b    0
rmb_prev:       dc.b    0

key_state:      ds.b    KEY_COUNT
key_new:        ds.b    KEY_COUNT
