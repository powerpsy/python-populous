; =============================================================================
; POPULOUS AMIGA - gfx.asm
; Graphics engine: copper list setup, double-buffering, blitter tile copy,
; sprite cookie-cut, screen clear, and minimap rendering.
;
; Display: PAL 320×256, 5 bitplanes, 32 colours.
; Double buffer: two SCREEN_TOTAL-byte chip-RAM framebuffers.
;
; The two screen buffers are allocated by populous.asm via AllocMem(MEMF_CHIP).
; gfx_screen_a / gfx_screen_b hold their base addresses.
;
; Tile atlas (AmigaTiles1.PNG converted to planar format):
;   9 columns × 7 rows of 32×24 interleaved bitplane data.
;   gfx_tile_data points to converted chip-RAM data.
;
; Sprite atlas (AmigaSprites1.PNG converted):
;   16×16 sprites in 4 bitplanes (16 colours) with mask channel.
;   gfx_spr_data points to the atlas.
; =============================================================================

        include "hardware.inc"
        include "macros.inc"
        include "data.inc"

        xdef    gfx_init
        xdef    gfx_swap_buffers
        xdef    gfx_clear_screen
        xdef    gfx_blit_tile
        xdef    gfx_blit_sprite
        xdef    gfx_draw_rect
        xdef    gfx_set_pixel
        xdef    gfx_draw_minimap
        xdef    gfx_set_palette
        xdef    gfx_screen_a
        xdef    gfx_screen_b
        xdef    gfx_draw_buf
        xdef    gfx_tile_data
        xdef    gfx_spr_data
        xdef    gfx_ui_data

; ---------------------------------------------------------------------------
; gfx_init — set up copper list, DMA and display registers
; In: a0 = screen buffer A (chip RAM)
;     a1 = screen buffer B (chip RAM)
;     a2 = tile data (chip RAM, interleaved planar)
;     a3 = sprite data (chip RAM, planar)
;     a4 = UI overlay data (chip RAM, planar)
; ---------------------------------------------------------------------------
gfx_init:
        move.l  a0,gfx_screen_a
        move.l  a1,gfx_screen_b
        move.l  a0,gfx_draw_buf         ; Start drawing to buffer A
        move.l  a1,gfx_show_buf         ; Display buffer B first (drawn = A)
        move.l  a2,gfx_tile_data
        move.l  a3,gfx_spr_data
        move.l  a4,gfx_ui_data

        ; Build the initial copper list pointing to screen A
        bsr     gfx_build_copper

        ; Set bitplane modulos to 0 (contiguous lines)
        move.w  #0,CUSTOM+BPL1MOD
        move.w  #0,CUSTOM+BPL2MOD

        ; Set display window and data fetch
        move.w  #DIWSTRT_PAL,CUSTOM+DIWSTRT
        move.w  #DIWSTOP_PAL,CUSTOM+DIWSTOP
        move.w  #DDFSTRT_LORES,CUSTOM+DDFSTRT
        move.w  #DDFSTOP_LORES,CUSTOM+DDFSTOP

        ; BPLCON0: 5 bitplanes, colour enable
        move.w  #BPLCON0_5BPL,CUSTOM+BPLCON0
        ; BPLCON1: no scroll
        move.w  #0,CUSTOM+BPLCON1
        ; BPLCON2: sprite 0 has highest priority over playfield 2
        move.w  #$0024,CUSTOM+BPLCON2

        ; Enable DMA: master + copper + blitter + sprites + bitplanes
        move.w  #DMAF_SETCLR|DMAF_MASTER|DMAF_COPPER|DMAF_BLITTER|DMAF_SPRITE|$0100,CUSTOM+DMACON
        ; Bit 8 = bitplane DMA (BPLEN)
        move.w  #DMAF_SETCLR|$0100,CUSTOM+DMACON

        ; Point copper to our list
        move.l  #cop_list,CUSTOM+COP1LCH
        move.w  #0,CUSTOM+COPJMP1       ; Strobe to restart copper

        rts

; ---------------------------------------------------------------------------
; gfx_build_copper — construct copper list for the current draw buffer
; Uses gfx_show_buf (the buffer currently being displayed)
; ---------------------------------------------------------------------------
gfx_build_copper:
        lea     cop_list,a0

        ; --- Set bitplane pointers ---
        ; Buffer is interleaved: plane0_row0, plane1_row0, … plane4_row0, plane0_row1 …
        ; OR non-interleaved (simpler): all of plane0, all of plane1, …
        ; We use non-interleaved (each bitplane is SCREEN_SIZE bytes apart).
        move.l  gfx_show_buf,d0         ; Address of displayed buffer

        ; Plane 1 pointer
        move.l  d0,d1
        move.w  #BPL1PTH,(a0)+
        move.w  d1,(a0)+                ; High word
        move.w  #BPL1PTL,(a0)+
        swap    d1
        move.w  d1,(a0)+
        swap    d1

        ; Plane 2 pointer
        add.l   #SCREEN_SIZE,d1
        move.w  #BPL2PTH,(a0)+
        move.w  d1,(a0)+
        move.w  #BPL2PTL,(a0)+
        swap    d1
        move.w  d1,(a0)+
        swap    d1

        ; Plane 3 pointer
        add.l   #SCREEN_SIZE,d1
        move.w  #BPL3PTH,(a0)+
        move.w  d1,(a0)+
        move.w  #BPL3PTL,(a0)+
        swap    d1
        move.w  d1,(a0)+
        swap    d1

        ; Plane 4 pointer
        add.l   #SCREEN_SIZE,d1
        move.w  #BPL4PTH,(a0)+
        move.w  d1,(a0)+
        move.w  #BPL4PTL,(a0)+
        swap    d1
        move.w  d1,(a0)+
        swap    d1

        ; Plane 5 pointer
        add.l   #SCREEN_SIZE,d1
        move.w  #BPL5PTH,(a0)+
        move.w  d1,(a0)+
        move.w  #BPL5PTL,(a0)+
        swap    d1
        move.w  d1,(a0)+
        swap    d1

        ; --- Palette (written once, overwritten by gfx_set_palette) ---
        ; Initially load Populous palette  (filled by gfx_set_palette later)
        move.w  #COLOR00,(a0)+
        move.w  #$0000,(a0)+            ; COLOR00 = black background
        move.w  #COLOR01,(a0)+
        move.w  #$0005,(a0)+            ; deep blue (water)
        move.w  #COLOR02,(a0)+
        move.w  #$00a2,(a0)+            ; medium blue
        move.w  #COLOR03,(a0)+
        move.w  #$00f6,(a0)+            ; sky blue
        move.w  #COLOR04,(a0)+
        move.w  #$0050,(a0)+            ; dark green
        move.w  #COLOR05,(a0)+
        move.w  #$00a4,(a0)+            ; mid green
        move.w  #COLOR06,(a0)+
        move.w  #$0fc0,(a0)+            ; light green
        move.w  #COLOR07,(a0)+
        move.w  #$0a83,(a0)+            ; yellow-green
        move.w  #COLOR08,(a0)+
        move.w  #$0842,(a0)+            ; brown
        move.w  #COLOR09,(a0)+
        move.w  #$0c64,(a0)+            ; tan
        move.w  #COLOR10,(a0)+
        move.w  #$0fa3,(a0)+            ; sand
        move.w  #COLOR11,(a0)+
        move.w  #$0fff,(a0)+            ; white (snow/highlights)
        move.w  #COLOR12,(a0)+
        move.w  #$0888,(a0)+            ; grey
        move.w  #COLOR13,(a0)+
        move.w  #$0444,(a0)+            ; dark grey
        move.w  #COLOR14,(a0)+
        move.w  #$0f00,(a0)+            ; red (foe)
        move.w  #COLOR15,(a0)+
        move.w  #$00ff,(a0)+            ; cyan
        move.w  #COLOR16,(a0)+
        move.w  #$0f80,(a0)+            ; orange
        move.w  #COLOR17,(a0)+
        move.w  #$0fb0,(a0)+            ; yellow
        move.w  #COLOR18,(a0)+
        move.w  #$0f0f,(a0)+            ; magenta
        move.w  #COLOR19,(a0)+
        move.w  #$0622,(a0)+            ; dark red-brown
        move.w  #COLOR20,(a0)+
        move.w  #$0333,(a0)+
        move.w  #COLOR21,(a0)+
        move.w  #$0666,(a0)+
        move.w  #COLOR22,(a0)+
        move.w  #$0999,(a0)+
        move.w  #COLOR23,(a0)+
        move.w  #$0ccc,(a0)+
        move.w  #COLOR24,(a0)+
        move.w  #$0a00,(a0)+
        move.w  #COLOR25,(a0)+
        move.w  #$0050,(a0)+
        move.w  #COLOR26,(a0)+
        move.w  #$00a0,(a0)+
        move.w  #COLOR27,(a0)+
        move.w  #$0700,(a0)+
        move.w  #COLOR28,(a0)+
        move.w  #$0070,(a0)+
        move.w  #COLOR29,(a0)+
        move.w  #$0007,(a0)+
        move.w  #COLOR30,(a0)+
        move.w  #$0770,(a0)+
        move.w  #COLOR31,(a0)+
        move.w  #$0407,(a0)+

        ; End copper list
        move.w  #$ffff,(a0)+
        move.w  #$fffe,(a0)+

        ; Save end pointer for dynamic updates (palette patching)
        move.l  a0,cop_list_end

        rts

; ---------------------------------------------------------------------------
; gfx_swap_buffers — swap displayed / draw buffers after VBL
; Patches the copper list bitplane pointers in place for the new display.
; ---------------------------------------------------------------------------
gfx_swap_buffers:
        ; Swap pointers
        move.l  gfx_draw_buf,d0
        move.l  gfx_show_buf,d1
        move.l  d1,gfx_draw_buf
        move.l  d0,gfx_show_buf

        ; Rebuild copper list (fast — just update plane pointers)
        bsr     gfx_build_copper

        ; Strobe copper to restart from updated list
        move.w  #0,CUSTOM+COPJMP1
        rts

; ---------------------------------------------------------------------------
; gfx_clear_screen — clear the current draw buffer to colour 0 (black)
; Uses the blitter (D-only fill) per bitplane.
; ---------------------------------------------------------------------------
gfx_clear_screen:
        move.l  gfx_draw_buf,a0
        moveq   #SCREEN_PLANES-1,d7

.plane: BLTWAIT
        move.w  #$0100,CUSTOM+BLTCON0   ; D = 0 (clear)
        move.w  #$0000,CUSTOM+BLTCON1
        move.w  #$ffff,CUSTOM+BLTAFWM
        move.w  #$ffff,CUSTOM+BLTALWM
        clr.w   CUSTOM+BLTDMOD
        move.l  a0,CUSTOM+BLTDPTH
        ; Size = height=SCREEN_H lines, width=SCREEN_BWIDTH/2 words
        move.w  #(SCREEN_H<<6)|(SCREEN_BWIDTH/2),CUSTOM+BLTSIZE
        add.l   #SCREEN_SIZE,a0
        dbf     d7,.plane
        rts

; ---------------------------------------------------------------------------
; gfx_blit_tile — blit one isometric tile into the draw buffer
;
; In:  d0.w = screen X of tile left edge
;      d1.w = screen Y of tile top edge
;      d2.b = tile column in atlas (0–8)
;      d3.b = tile row in atlas    (0–6)
;      d4.w = tile height override (0 = use TILE_FULL_H)
; Trashes: d0–d6/a0–a3
;
; The tile atlas is assumed to already be in planar format (5 planes,
; TILE_W×TILE_FULL_H each, stored sequentially by plane).
; The mask (transparency) is stored as a 6th plane following the 5 colour planes.
; ---------------------------------------------------------------------------
gfx_blit_tile:
        ; Clip: skip tiles entirely off screen
        tst.w   d0
        blt     .clip_right
        cmp.w   #SCREEN_W,d0
        bge     .skip
        tst.w   d1
        blt     .clip_right
        cmp.w   #SCREEN_H,d1
        bge     .skip

.clip_right:
        ; Compute source offset into tile atlas
        ; Tile atlas layout: rows of tiles, each tile TILE_W × TILE_FULL_H
        ; Atlas row stride = TILE_COLS * TILE_W pixels = 9*32 = 288 pixels = 36 bytes (per plane per scanline)
        ; Offset of tile (col, row) in bytes within one plane:
        ;   x_byte = d2 * TILE_BWIDTH  (= d2 * 4)
        ;   y_byte = d3 * TILE_FULL_H * TILE_ATLAS_BWIDTH
        ; TILE_ATLAS_BWIDTH defined in data.inc = 36

        ; Source address in tile atlas for this tile
        move.l  gfx_tile_data,a2

        ; y offset into atlas
        and.w   #$00ff,d3
        mulu    #TILE_FULL_H*TILE_ATLAS_BWIDTH,d3
        add.l   d3,a2

        ; x offset into atlas
        and.w   #$00ff,d2
        mulu    #TILE_BWIDTH,d2
        add.l   d2,a2
        ; a2 = pointer to tile in atlas (plane 0)

        ; Destination address: screen pixel (d0, d1)
        ; Byte offset = d1 * SCREEN_BWIDTH + d0/8
        ; But d0 might not be byte-aligned — handle pixel shift
        move.w  d0,d5
        and.w   #$000f,d5               ; shift amount (0–15)
        asr.w   #3,d0                   ; d0 = byte offset of left edge in row (may be one byte left of pixel)
        ; If shift != 0, blit is 3 words wide instead of 2
        move.w  #2,d6                   ; default width in words
        tst.w   d5
        beq.s   .no_shift
        moveq   #3,d6                   ; shifted tile needs extra word
.no_shift:

        ; Tile height
        tst.w   d4
        bne.s   .has_h
        move.w  #TILE_FULL_H,d4
.has_h:

        ; Destination address
        move.l  gfx_draw_buf,a0
        mulu    #SCREEN_BWIDTH,d1
        add.l   d1,a0
        add.w   d0,a0
        ; a0 = destination (plane 0 of draw buffer)

        ; Atlas mask plane follows the 5 colour planes
        ; mask_ptr = a2 + SCREEN_PLANES * atlas_plane_size
        ; atlas_plane_size = TILE_ATLAS_BWIDTH * TILE_FULL_H
        move.l  a2,a3
        move.l  #SCREEN_PLANES*TILE_ATLAS_BWIDTH*TILE_FULL_H,d2
        add.l   d2,a3
        ; a3 = mask plane in atlas

        ; Source modulo = TILE_ATLAS_BWIDTH - (words_we_copy * 2)
        move.w  d6,d3
        lsl.w   #1,d3                   ; bytes copied per row
        move.w  #TILE_ATLAS_BWIDTH,d2
        sub.w   d3,d2                   ; atlas modulo per plane

        ; Destination modulo = SCREEN_BWIDTH - (words_we_copy * 2)
        move.w  #SCREEN_BWIDTH,d3
        sub.w   d6,d3
        sub.w   d6,d3                   ; screen modulo per plane

        ; Blitter: cookie-cut for each of the 5 planes
        ; BLTCON0 = $0dfc + (shift << 12)  : D = (A & B) | (~A & C)  (A=mask, B=src, C=dst)
        ; BLTCON1 = (shift << 12)
        lsl.w   #8,d5
        lsl.w   #4,d5                   ; shift << 12 for ASH field

        moveq   #SCREEN_PLANES-1,d7
.plane_loop:
        BLTWAIT

        ; BLTCON0: cookie-cut op + shift
        move.w  #$0dfc,d0
        or.w    d5,d0
        move.w  d0,CUSTOM+BLTCON0
        move.w  d5,CUSTOM+BLTCON1

        move.w  #$ffff,CUSTOM+BLTAFWM
        ; Last word mask depends on shift
        move.w  #$0000,CUSTOM+BLTALWM   ; Zero-fill last shifted word

        ; Modulos
        move.w  d2,CUSTOM+BLTAMOD       ; Mask modulo
        move.w  d2,CUSTOM+BLTBMOD       ; Source modulo
        move.w  d3,CUSTOM+BLTCMOD       ; Dest modulo (read)
        move.w  d3,CUSTOM+BLTDMOD       ; Dest modulo (write)

        ; Pointers: A=mask, B=source, C=dest(old), D=dest(new)
        move.l  a3,CUSTOM+BLTAPTH       ; Mask (A)
        move.l  a2,CUSTOM+BLTBPTH       ; Source tile (B)
        move.l  a0,CUSTOM+BLTCPTH       ; Destination (C = current screen)
        move.l  a0,CUSTOM+BLTDPTH       ; Destination (D = write back)

        ; Size: height × width-in-words
        move.w  d4,d0
        lsl.w   #6,d0
        or.w    d6,d0
        move.w  d0,CUSTOM+BLTSIZE

        ; Advance pointers to next bitplane
        ; Atlas plane stride = TILE_ATLAS_BWIDTH * TILE_FULL_H
        add.l   #TILE_ATLAS_BWIDTH*TILE_FULL_H,a2
        add.l   #TILE_ATLAS_BWIDTH*TILE_FULL_H,a3
        ; Screen plane stride = SCREEN_SIZE
        add.l   #SCREEN_SIZE,a0

        dbf     d7,.plane_loop

.skip:  rts

; ---------------------------------------------------------------------------
; gfx_blit_sprite — draw a 16×16 sprite onto the draw buffer
;
; In:  d0.w = screen X
;      d1.w = screen Y
;      d2.b = sprite column in atlas (0–7  : animation frame 0–3, team *2)
;      d3.b = sprite row in atlas    (direction / type row)
;      d4.b = team (0=ally/blue, 1=foe/red) — adjusts palette offset
; Trashes: d0–d6/a0–a3
;
; Sprite atlas: 16×16 pixels per entry, 4 bitplanes (16 colours),
; stored with a 1-plane mask following the 4 colour planes.
; The sprite palette uses colours 16–31 (sprite priority from BPLCON2).
; ---------------------------------------------------------------------------
gfx_blit_sprite:
        ; Clip check
        tst.w   d0
        blt     .skip
        cmp.w   #SCREEN_W,d0
        bge     .skip
        tst.w   d1
        blt     .skip
        cmp.w   #SCREEN_H,d1
        bge     .skip

        ; Source offset in sprite atlas (SPRITE_ATLAS_W, SPRITE_BWIDTH, SPRITE_ATLAS_BWIDTH from data.inc)
        move.l  gfx_spr_data,a2
        and.w   #$00ff,d3
        mulu    #SPRITE_H*SPRITE_ATLAS_BWIDTH,d3
        add.l   d3,a2
        and.w   #$00ff,d2
        mulu    #SPRITE_BWIDTH,d2
        add.l   d2,a2

        ; Pixel shift
        move.w  d0,d5
        and.w   #$000f,d5
        asr.w   #3,d0
        move.w  #2,d6
        tst.w   d5
        beq.s   .no_shift
        moveq   #3,d6
.no_shift:

        ; Destination
        move.l  gfx_draw_buf,a0
        mulu    #SCREEN_BWIDTH,d1
        add.l   d1,a0
        add.w   d0,a0

        ; Mask plane (4 colour planes then mask)
        move.l  a2,a3
        add.l   #4*SPRITE_ATLAS_BWIDTH*SPRITE_H,a3

        ; Modulos
        move.w  #SPRITE_ATLAS_BWIDTH,d2
        move.w  d6,d3
        lsl.w   #1,d3
        sub.w   d3,d2

        move.w  #SCREEN_BWIDTH,d3
        sub.w   d6,d3
        sub.w   d6,d3

        lsl.w   #8,d5
        lsl.w   #4,d5

        ; Sprites use only 4 bitplanes (blit to planes 0–3, skip plane 4)
        moveq   #3,d7
.spr_plane:
        BLTWAIT
        move.w  #$0dfc,d0
        or.w    d5,d0
        move.w  d0,CUSTOM+BLTCON0
        move.w  d5,CUSTOM+BLTCON1
        move.w  #$ffff,CUSTOM+BLTAFWM
        move.w  #$0000,CUSTOM+BLTALWM
        move.w  d2,CUSTOM+BLTAMOD
        move.w  d2,CUSTOM+BLTBMOD
        move.w  d3,CUSTOM+BLTCMOD
        move.w  d3,CUSTOM+BLTDMOD
        move.l  a3,CUSTOM+BLTAPTH
        move.l  a2,CUSTOM+BLTBPTH
        move.l  a0,CUSTOM+BLTCPTH
        move.l  a0,CUSTOM+BLTDPTH
        move.w  #(SPRITE_H<<6)|d6,CUSTOM+BLTSIZE
        add.l   #SPRITE_ATLAS_BWIDTH*SPRITE_H,a2
        add.l   #SPRITE_ATLAS_BWIDTH*SPRITE_H,a3
        add.l   #SCREEN_SIZE,a0
        dbf     d7,.spr_plane

.skip:  rts

; ---------------------------------------------------------------------------
; gfx_set_pixel — set a single pixel (debug / minimap use)
; In:  d0.w = X,  d1.w = Y,  d2.b = colour index (0–31)
; Trashes: d0–d4/a0
; ---------------------------------------------------------------------------
gfx_set_pixel:
        ; Bounds check
        tst.w   d0
        blt     .done
        tst.w   d1
        blt     .done
        cmp.w   #SCREEN_W,d0
        bge     .done
        cmp.w   #SCREEN_H,d1
        bge     .done

        ; Byte offset in row
        move.w  d0,d3
        lsr.w   #3,d3                   ; byte column
        move.w  d0,d4
        and.w   #7,d4                   ; bit within byte (bit 7 = leftmost)
        moveq   #7,d0
        sub.w   d4,d0                   ; d0 = bit position within byte

        ; Row offset
        move.l  gfx_draw_buf,a0
        mulu    #SCREEN_BWIDTH,d1
        add.l   d1,a0
        add.w   d3,a0                   ; a0 = byte address in plane 0

        ; Set/clear bit for each of 5 planes based on colour index
        and.w   #$001f,d2               ; colour = 5-bit value
        moveq   #0,d3
        moveq   #SCREEN_PLANES-1,d4

.bit_loop:
        btst    d3,d2                   ; is this plane bit set?
        beq.s   .clear_bit
        bset    d0,(a0)                 ; set pixel bit
        bra.s   .next_plane
.clear_bit:
        bclr    d0,(a0)
.next_plane:
        add.l   #SCREEN_SIZE,a0         ; advance to next plane
        addq.w  #1,d3
        dbf     d4,.bit_loop

.done:  rts

; ---------------------------------------------------------------------------
; gfx_draw_rect — draw a filled rectangle (used for UI, health bars)
; In:  d0.w=x, d1.w=y, d2.w=width, d3.w=height, d4.b=colour
; Trashes: d0–d6/a0
; ---------------------------------------------------------------------------
gfx_draw_rect:
        ; For each scan line use blitter D-only fill of colour value
        ; (set appropriate bits in each plane for every word in the row).
        ; Colour=0 already handled by gfx_clear_screen.

        ; Clip
        tst.w   d2
        ble     .done
        tst.w   d3
        ble     .done

        and.w   #$001f,d4

        ; For simplicity, draw pixel-by-pixel (suitable for small UI elements)
        movem.l d0-d5,-(sp)
        move.w  d1,d5                   ; save start Y
        add.w   d3,d5                   ; d5 = end Y
        move.w  d0,d3                   ; save start X (d3 free now)

.row:   move.w  d3,d6                   ; current X = start X
        add.w   d2,d3
        ; d3 = end X
.col:   ; Call gfx_set_pixel (d0=X, d1=Y, d2=colour)
        move.w  d6,d0
        move.w  d1,d1
        move.b  d4,d2
        bsr     gfx_set_pixel
        addq.w  #1,d6
        cmp.w   d3,d6
        blt     .col
        move.w  d3,d3
        addq.w  #1,d1
        cmp.w   d5,d1
        blt     .row

        movem.l (sp)+,d0-d5
.done:  rts

; ---------------------------------------------------------------------------
; gfx_set_palette — write 32 colour entries into the copper list palette area
; In: a0 = pointer to 32 words of $0RGB values
; Trashes: d0/d1/a1
; ---------------------------------------------------------------------------
gfx_set_palette:
        ; Find the palette section in the copper list
        ; The palette starts after the 10 bitplane pointer entries (5×4 words = 20 words)
        lea     cop_list,a1
        add.w   #20*4,a1                ; skip 10 CMOVE instructions (4 bytes each)
        ; Now a1 points to COLOR00 CMOVE; step over register word to reach value
        addq.w  #2,a1                   ; skip COLOR00 register word
        moveq   #31,d0
.pal:   move.w  (a0)+,(a1)             ; write colour value
        addq.w  #4,a1                   ; step to next colour (4 bytes per CMOVE)
        dbf     d0,.pal
        rts

; ---------------------------------------------------------------------------
; gfx_draw_minimap — render the 128×64 diamond minimap
; In:  d0.w = screen X of minimap top-left
;      d1.w = screen Y of minimap top-left
;      a0   = terrain_height array (GRID_SIZE bytes)
;      a1   = terrain_flags array  (GRID_SIZE bytes)
;      a2   = house_data array
;      d2.w = number of houses
;      d3.w = camera row
;      d4.w = camera col
; Trashes: everything — call from a context where registers are safe.
; ---------------------------------------------------------------------------
gfx_draw_minimap:
        movem.l d0-d7/a0-a5,-(sp)
        move.w  d0,mini_ox
        move.w  d1,mini_oy
        move.l  a0,mini_ter
        move.l  a1,mini_flg
        move.l  a2,mini_hou
        move.w  d2,mini_hcnt
        move.w  d3,mini_cam_r
        move.w  d4,mini_cam_c

        ; Iterate all tiles
        clr.w   d5                      ; r = 0
.row_loop:
        clr.w   d6                      ; c = 0
.col_loop:
        ; Get terrain altitude
        move.l  mini_ter,a3
        TERRAIN_IDX d5,d6,d0
        move.b  (a3,d0.w),d0            ; altitude

        ; Get flags
        move.l  mini_flg,a3
        TERRAIN_IDX d5,d6,d1
        move.b  (a3,d1.w),d1            ; flags

        ; Colour selection
        moveq   #5,d2                   ; default: mid green
        btst    #0,d1                   ; TF_WATER
        bne.s   .is_water
        tst.b   d0
        beq.s   .is_water
        moveq   #5,d2
        bra.s   .draw_pixel
.is_water:
        moveq   #1,d2                   ; deep blue (water)

.draw_pixel:
        ; Isometric minimap: px = mini_ox + c + 64 - r,  py = mini_oy + (c+r)/2
        move.w  d6,d3                   ; c
        add.w   #64,d3
        sub.w   d5,d3                   ; c + 64 - r
        add.w   mini_ox,d3              ; + offset X

        move.w  d6,d4                   ; c
        add.w   d5,d4                   ; + r
        lsr.w   #1,d4                   ; / 2
        add.w   mini_oy,d4              ; + offset Y

        move.w  d3,d0
        move.w  d4,d1
        bsr     gfx_set_pixel           ; colour already in d2

        addq.w  #1,d6
        cmp.w   #GRID_W,d6
        blt     .col_loop

        addq.w  #1,d5
        cmp.w   #GRID_H,d5
        blt     .row_loop

        ; Draw camera rectangle outline (white = colour 11)
        ; p1 top, p2 right, p3 bottom, p4 left
        ; (skip for brevity — draw as single pixel marker)

        movem.l (sp)+,d0-d7/a0-a5
        rts

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
        section data_c,data_c

gfx_screen_a:   dc.l    0
gfx_screen_b:   dc.l    0
gfx_draw_buf:   dc.l    0
gfx_show_buf:   dc.l    0
gfx_tile_data:  dc.l    0
gfx_spr_data:   dc.l    0
gfx_ui_data:    dc.l    0
cop_list_end:   dc.l    0

; Copper list — must be in chip RAM.
; Size: 10 BPL ptr entries (4 bytes each) + 32 palette entries (4 each) + end (4) = 40+128+4 = 172 bytes
cop_list:       ds.b    256             ; Reserve 256 bytes

; Minimap temporaries
mini_ox:        dc.w    0
mini_oy:        dc.w    0
mini_ter:       dc.l    0
mini_flg:       dc.l    0
mini_hou:       dc.l    0
mini_hcnt:      dc.w    0
mini_cam_r:     dc.w    0
mini_cam_c:     dc.w    0
