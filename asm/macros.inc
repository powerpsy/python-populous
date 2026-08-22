; =============================================================================
; POPULOUS AMIGA - macros.inc
; Reusable 68000 macros for Copper, Blitter, VBL, etc.
; =============================================================================

; ---------------------------------------------------------------------------
; Copper list construction macros
; (must be placed in chip RAM and pointed to by COP1LCH/COP1LCL)
; ---------------------------------------------------------------------------

; CMOVE reg,val  — write val to hardware register reg via copper MOVE
; reg = offset from $DFF000 (e.g. COLOR00 = $180)
CMOVE   MACRO   reg,val
        dc.w    (reg),((val)&$ffff)
        ENDM

; CWAIT vp,hp   — wait until beam reaches vp (vertical) hp (horizontal)
; vp = 0–255, hp = 0–227 (only even pixels), hp must be even
CWAIT   MACRO   vp,hp
        dc.w    (((vp)&$ff)<<8)|(((hp)&$fe)|$01),$fffe
        ENDM

; CEND  — terminate copper list
CEND    MACRO
        dc.w    $ffff,$fffe
        ENDM

; CJUMP adr  — copper JMP to absolute address
CJUMP   MACRO   adr
        dc.w    $0088,((adr)>>16)&$ffff
        dc.w    $008a,((adr)&$ffff)
        ENDM

; ---------------------------------------------------------------------------
; Blitter macros
; ---------------------------------------------------------------------------

; BLTWAIT — spin until blitter is no longer busy
; Reads DMACONR bit 14 (blitter busy); must use CUSTOM base in a4 or direct
BLTWAIT MACRO
.\@bw:  btst    #BLIT_BUSY_BIT,CUSTOM+DMACONR
        bne.s   .\@bw
        ENDM

; BLTCLEAR dst,w_words,h_lines — fill rectangular region with 0
; dst=chip RAM address, w_words=width in 16-bit words, h_lines=height in lines
; Uses channel D only (BLTCON0 = $0100)
BLTCLEAR MACRO  dst,w_words,h_lines
        BLTWAIT
        move.w  #$0100,CUSTOM+BLTCON0   ; D = 0
        move.w  #$0000,CUSTOM+BLTCON1
        move.w  #$ffff,CUSTOM+BLTAFWM
        move.w  #$ffff,CUSTOM+BLTALWM
        clr.w   CUSTOM+BLTDMOD
        move.l  #(dst),CUSTOM+BLTDPTH
        move.w  #(((h_lines)<<6)|((w_words)&$3f)),CUSTOM+BLTSIZE
        ENDM

; ---------------------------------------------------------------------------
; VBL synchronisation
; ---------------------------------------------------------------------------

; VBLWAIT — busy-wait until vertical blank starts (beam line >= $2c)
VBLWAIT MACRO
.\@vw:  move.w  CUSTOM+VPOSR,d0
        and.w   #$7f00,d0
        cmp.w   #$2c00,d0
        bne.s   .\@vw
        ENDM

; ---------------------------------------------------------------------------
; Register save / restore
; ---------------------------------------------------------------------------

PUSHALL MACRO
        movem.l d0-d7/a0-a6,-(sp)
        ENDM

POPALL  MACRO
        movem.l (sp)+,d0-d7/a0-a6
        ENDM

; ---------------------------------------------------------------------------
; Fixed-point arithmetic helpers (8.8 format: hi byte=integer, lo byte=frac)
; ---------------------------------------------------------------------------

; FPMUL d_reg, imm — multiply a.b fixed-point d_reg by integer imm
; Result kept in high 16 bits (truncate fraction)
FPMUL   MACRO   d_reg,imm
        mulu    #(imm),\1
        swap    \1
        ENDM

; ---------------------------------------------------------------------------
; Isometric projection  (mirrors Python formula)
; Given tile (r,c) and altitude alt, compute screen (sx, sy):
;   sx = (c - r) * TILE_HALF_W + MAP_OFFSET_X
;   sy = (c + r) * TILE_HALF_H + MAP_OFFSET_Y - alt * ALT_PIXEL_STEP
;
; Usage: ISO_PROJ r_reg, c_reg, alt_reg, sx_reg, sy_reg
; All registers must be .w data registers (d0–d7), no overlap allowed.
; ---------------------------------------------------------------------------
ISO_PROJ MACRO  r_reg, c_reg, alt_reg, sx_reg, sy_reg
        move.w  \2,\4               ; sx = c
        sub.w   \1,\4               ;    - r
        muls    #TILE_HALF_W,\4     ;    * TILE_HALF_W
        add.w   #MAP_OFFSET_X,\4   ;    + MAP_OFFSET_X

        move.w  \2,\5               ; sy = c
        add.w   \1,\5               ;    + r
        muls    #TILE_HALF_H,\5     ;    * TILE_HALF_H
        add.w   #MAP_OFFSET_Y,\5   ;    + MAP_OFFSET_Y
        move.w  \3,d7
        muls    #ALT_PIXEL_STEP,d7
        sub.w   d7,\5               ;    - alt * ALT_PIXEL_STEP
        ENDM

; ---------------------------------------------------------------------------
; Terrain index helper: (r, c) -> byte offset in terrain array
;   offset = r * GRID_W + c
; ---------------------------------------------------------------------------
TERRAIN_IDX MACRO r_reg, c_reg, out_reg
        move.w  \1,\3
        mulu    #GRID_W,\3
        add.w   \2,\3
        ENDM

; ---------------------------------------------------------------------------
; Peep array index helper: index -> byte offset in peep array
;   offset = index * PEEP_SIZE
; ---------------------------------------------------------------------------
PEEP_OFFSET MACRO idx_reg
        mulu    #PEEP_SIZE,\1
        ENDM

HOUSE_OFFSET MACRO idx_reg
        mulu    #HOUSE_SIZE,\1
        ENDM
