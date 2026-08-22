; =============================================================================
; POPULOUS AMIGA - populous.asm
; Main entry point: Amiga OS setup, VBL interrupt, main game loop.
;
; This program:
;   1. Opens exec library (already open via ExecBase)
;   2. Saves system state (copper, interrupt vectors, DMA)
;   3. Allocates chip RAM for two screen framebuffers
;   4. Installs Level 3 VBL interrupt handler
;   5. Runs the main game loop (title → play → game-over)
;   6. On exit: restores system state and frees memory
;
; Build: vasm68k_mot -Fhunk populous.asm  (assembles all files via includes)
; Link:  vlink -bamigahunk *.o -o populous
;
; Entry: standard Amiga CLI startup (argc = d0, argv = a0 per AmigaOS ABI)
; =============================================================================

        include "hardware.inc"
        include "macros.inc"
        include "data.inc"

        ; External symbols from other modules
        xref    gfx_init, gfx_swap_buffers, gfx_clear_screen
        xref    gfx_blit_tile, gfx_blit_sprite
        xref    gfx_set_pixel, gfx_draw_rect, gfx_draw_minimap
        xref    gfx_set_palette, gfx_screen_a, gfx_screen_b
        xref    gfx_draw_buf, gfx_tile_data, gfx_spr_data, gfx_ui_data

        xref    map_init, map_randomize
        xref    map_raise_corner, map_lower_corner
        xref    map_get_raise_cost, map_get_lower_cost
        xref    map_do_flood, map_do_quake, map_do_volcano, map_do_swamp
        xref    terrain_height, terrain_flags
        xref    rnd_word, rnd_byte

        xref    peep_init, peep_spawn, peep_update_all, peep_set_command
        xref    peep_data, peep_count, papal_pos_ally, papal_pos_foe

        xref    house_init, house_add, house_update_all, house_find_at
        xref    house_destroy, house_data, house_count

        xref    sound_init, sound_play, sound_mute, sound_unmute

        xref    input_init, input_update
        xref    input_lmb_pressed, input_rmb_pressed
        xref    input_lmb_down, input_rmb_down
        xref    input_key_pressed, input_key_down
        xref    mouse_x, mouse_y
        xref    iso_screen_to_tile

        xref    ai_init, ai_update, ai_set_difficulty
        xref    power_jauge_ally, power_jauge_foe
        xref    quake_pending, quake_target_r, quake_target_c

; ===========================================================================
; Program entry
; ===========================================================================
        section code,code

        movem.l d0-d7/a0-a6,-(sp)

; --- ExecBase in a6 ---
        move.l  EXEC_BASE,a6

; --- Save system state ---
        ; Save copper list pointer
        move.l  CUSTOM+COP1LCH,old_cop1
        ; Save interrupt enable
        move.w  CUSTOM+INTENAR,old_intena
        ; Save DMA control
        move.w  CUSTOM+DMACONR,old_dmaconr

        ; Disable all interrupts and DMA (OS-free mode)
        move.w  #$7fff,CUSTOM+INTENA
        move.w  #$7fff,CUSTOM+DMACON

; --- Allocate chip RAM for framebuffers ---
        ; SCREEN_TOTAL bytes per buffer × 2 (double buffer)
        move.l  #SCREEN_TOTAL,d0
        move.l  #MEMF_CHIP|MEMF_CLEAR,d1
        jsr     LVO_ALLOCMEM(a6)
        tst.l   d0
        beq     .alloc_fail
        move.l  d0,gfx_screen_a

        move.l  #SCREEN_TOTAL,d0
        move.l  #MEMF_CHIP|MEMF_CLEAR,d1
        jsr     LVO_ALLOCMEM(a6)
        tst.l   d0
        beq     .alloc_fail_b
        move.l  d0,gfx_screen_b

; --- Allocate chip RAM for tile data (placeholder — replace with converter) ---
        ; Tile data size: 5 planes × 7 rows × 9 tiles × TILE_FULL_H × TILE_ATLAS_BWIDTH
        ; = 6 planes (5 colour + 1 mask) × 7 × 9 × 24 × 36 = huge
        ; For a real build, a separate conversion tool writes planar data here.
        ; We allocate the space and zero it (tiles will appear blank until data is loaded).
        move.l  #TILE_DATA_SIZE,d0
        move.l  #MEMF_CHIP|MEMF_CLEAR,d1
        jsr     LVO_ALLOCMEM(a6)
        tst.l   d0
        beq     .alloc_fail_c
        move.l  d0,tile_data_ptr

; --- Allocate chip RAM for sprite data ---
        move.l  #SPR_DATA_SIZE,d0
        move.l  #MEMF_CHIP|MEMF_CLEAR,d1
        jsr     LVO_ALLOCMEM(a6)
        tst.l   d0
        beq     .alloc_fail_d
        move.l  d0,spr_data_ptr

; --- Install VBL interrupt ---
        ; Save old Level 3 interrupt vector ($6c)
        move.l  $6c,old_vbl_vec
        ; Install our handler
        move.l  #vbl_handler,$6c
        ; Enable VERTB interrupt
        move.w  #INTF_SETCLR|INTF_VERTB|INTF_INTEN,CUSTOM+INTENA

; --- Initialise subsystems ---
        bsr     sound_init
        bsr     map_init
        bsr     map_randomize
        bsr     house_init
        bsr     peep_init

        ; Initialise graphics
        move.l  gfx_screen_a,a0
        move.l  gfx_screen_b,a1
        move.l  tile_data_ptr,a2
        move.l  spr_data_ptr,a3
        move.l  spr_data_ptr,a4         ; ui_data = same as spr for now
        bsr     gfx_init

        bsr     input_init
        bsr     ai_init

        ; Initial power gauges
        clr.w   power_jauge_ally
        clr.w   power_jauge_foe

        ; Set game state to title screen
        move.b  #GSTATE_TITLE,game_state

        ; Spawn initial peeps (4 allies, 4 foes)
        bsr     init_spawn_peeps

; ===========================================================================
; Main game loop
; ===========================================================================
.main_loop:
        ; Wait for VBL (synchronise to 50 Hz PAL)
.wait_vbl:
        tst.b   vbl_flag
        beq     .wait_vbl
        clr.b   vbl_flag

        ; Update input
        bsr     input_update

        ; Check ESC / quit
        move.b  #KEY_ESC,d0
        bsr     input_key_pressed
        tst.b   d0
        bne     .exit

        ; Dispatch game state
        move.b  game_state,d0
        cmp.b   #GSTATE_TITLE,d0
        beq     .state_title
        cmp.b   #GSTATE_PLAY,d0
        beq     .state_play
        cmp.b   #GSTATE_MENU,d0
        beq     .state_menu
        cmp.b   #GSTATE_GAMEOVER,d0
        beq     .state_gameover
        bra     .main_loop

; --- Title screen ---
.state_title:
        bsr     draw_title_screen
        ; Any key → start game
        move.b  #KEY_ESC,d0
        bsr     input_key_pressed
        tst.b   d0
        bne     .exit
        bsr     input_lmb_pressed
        tst.b   d0
        beq     .main_loop
        move.b  #GSTATE_PLAY,game_state
        bra     .main_loop

; --- Gameplay ---
.state_play:
        bsr     game_update
        bsr     game_render
        ; Swap buffers after render
        bsr     gfx_swap_buffers
        bra     .main_loop

; --- Pause menu ---
.state_menu:
        bsr     draw_menu
        bra     .main_loop

; --- Game over ---
.state_gameover:
        bsr     draw_gameover
        bsr     input_lmb_pressed
        tst.b   d0
        beq     .main_loop
        move.b  #GSTATE_TITLE,game_state
        bra     .main_loop

; ===========================================================================
; Exit / cleanup
; ===========================================================================
.exit:
        ; Disable our interrupt
        move.w  #$7fff,CUSTOM+INTENA
        ; Restore old VBL vector
        move.l  old_vbl_vec,$6c

        ; Restore DMA and interrupts
        move.w  old_intena,d0
        or.w    #INTF_SETCLR,d0
        move.w  d0,CUSTOM+INTENA
        move.w  old_dmaconr,d0
        or.w    #DMAF_SETCLR,d0
        move.w  d0,CUSTOM+DMACON

        ; Restore copper list
        move.l  old_cop1,CUSTOM+COP1LCH
        move.w  #0,CUSTOM+COPJMP1

        ; Free chip RAM
        move.l  gfx_screen_b,a1
        move.l  #SCREEN_TOTAL,d0
        jsr     LVO_FREEMEM(a6)

        move.l  gfx_screen_a,a1
        move.l  #SCREEN_TOTAL,d0
        jsr     LVO_FREEMEM(a6)

        move.l  tile_data_ptr,a1
        move.l  #TILE_DATA_SIZE,d0
        jsr     LVO_FREEMEM(a6)

        move.l  spr_data_ptr,a1
        move.l  #SPR_DATA_SIZE,d0
        jsr     LVO_FREEMEM(a6)

        movem.l (sp)+,d0-d7/a0-a6
        moveq   #0,d0                   ; return 0 = no error
        rts

.alloc_fail_d:
        move.l  tile_data_ptr,a1
        move.l  #TILE_DATA_SIZE,d0
        jsr     LVO_FREEMEM(a6)
.alloc_fail_c:
        move.l  gfx_screen_b,a1
        move.l  #SCREEN_TOTAL,d0
        jsr     LVO_FREEMEM(a6)
.alloc_fail_b:
        move.l  gfx_screen_a,a1
        move.l  #SCREEN_TOTAL,d0
        jsr     LVO_FREEMEM(a6)
.alloc_fail:
        movem.l (sp)+,d0-d7/a0-a6
        moveq   #1,d0                   ; return 1 = error
        rts

; ===========================================================================
; VBL interrupt handler (Level 3, vector $6c)
; ===========================================================================
vbl_handler:
        movem.l d0/a0,-(sp)

        ; Acknowledge VERTB interrupt
        move.w  #INTF_VERTB,CUSTOM+INTREQ

        ; Set VBL flag for main loop
        st      vbl_flag

        ; Accumulate power gauges
        addq.w  #1,vbl_count
        move.w  vbl_count,d0
        and.w   #(POWER_ACCUM_TICKS-1),d0
        bne.s   .vbl_done
        ; Every POWER_ACCUM_TICKS frames: +1 to each team's jauge
        move.w  power_jauge_ally,d0
        cmp.w   #POWER_MAX,d0
        bge.s   .skip_ally
        addq.w  #1,power_jauge_ally
.skip_ally:
        move.w  power_jauge_foe,d0
        cmp.w   #POWER_MAX,d0
        bge.s   .vbl_done
        addq.w  #1,power_jauge_foe

.vbl_done:
        movem.l (sp)+,d0/a0
        rte

; ===========================================================================
; init_spawn_peeps — place initial peeps for both teams
; ===========================================================================
init_spawn_peeps:
        ; Spawn 4 allies around (20, 20)
        move.w  #4,d7
        move.w  #20,d5
        move.w  #20,d6
.spawn_ally:
        move.w  d5,d0
        move.w  d6,d1
        move.b  #TEAM_ALLY,d2
        move.w  #16,d3
        bsr     peep_spawn
        addq.w  #1,d5
        dbf     d7,.spawn_ally

        ; Spawn 4 foes around (44, 44)
        move.w  #4,d7
        move.w  #44,d5
        move.w  #44,d6
.spawn_foe:
        move.w  d5,d0
        move.w  d6,d1
        move.b  #TEAM_FOE,d2
        move.w  #16,d3
        bsr     peep_spawn
        addq.w  #1,d5
        dbf     d7,.spawn_foe

        ; Place initial buildings
        move.w  #20,d0
        move.w  #20,d1
        move.b  #TEAM_ALLY,d2
        bsr     house_add

        move.w  #44,d0
        move.w  #44,d1
        move.b  #TEAM_FOE,d2
        bsr     house_add

        rts

; ===========================================================================
; game_update — one logic tick (called each VBL)
; ===========================================================================
game_update:
        movem.l d0-d7/a0-a4,-(sp)

        ; --- Terrain quake timer ---
        tst.b   quake_pending
        beq.s   .no_quake
        subq.b  #1,quake_pending
        move.w  quake_target_r,d0
        move.w  quake_target_c,d1
        bsr     map_do_quake
        moveq   #SFX_QUAKE,d0
        bsr     sound_play
.no_quake:

        ; --- Mouse / terrain interaction ---
        bsr     input_lmb_down
        tst.b   d0
        beq.s   .try_rmb

        ; Get tile under mouse
        move.w  mouse_x,d0
        move.w  mouse_y,d1
        move.w  camera_r,d2
        move.w  camera_c,d3
        bsr     iso_screen_to_tile      ; d4=r, d5=c
        cmp.w   #-1,d4
        beq.s   .try_rmb
        ; Check cost
        move.w  d4,d0
        move.w  d5,d1
        bsr     map_get_raise_cost
        tst.w   d0
        beq.s   .try_rmb
        cmp.w   power_jauge_ally,d0
        bgt.s   .try_rmb
        sub.w   d0,power_jauge_ally
        move.w  d4,d0
        move.w  d5,d1
        bsr     map_raise_corner
        bra.s   .no_rmb

.try_rmb:
        bsr     input_rmb_down
        tst.b   d0
        beq.s   .no_rmb
        move.w  mouse_x,d0
        move.w  mouse_y,d1
        move.w  camera_r,d2
        move.w  camera_c,d3
        bsr     iso_screen_to_tile
        cmp.w   #-1,d4
        beq.s   .no_rmb
        move.w  d4,d0
        move.w  d5,d1
        bsr     map_get_lower_cost
        tst.w   d0
        beq.s   .no_rmb
        cmp.w   power_jauge_ally,d0
        bgt.s   .no_rmb
        sub.w   d0,power_jauge_ally
        move.w  d4,d0
        move.w  d5,d1
        bsr     map_lower_corner
.no_rmb:

        ; --- Camera movement via arrow keys ---
        move.b  #KEY_LEFT,d0
        bsr     input_key_down
        tst.b   d0
        beq.s   .no_left
        sub.w   #1,camera_c
        tst.w   camera_c
        bge.s   .no_left
        clr.w   camera_c
.no_left:
        move.b  #KEY_RIGHT,d0
        bsr     input_key_down
        tst.b   d0
        beq.s   .no_right
        add.w   #1,camera_c
        cmp.w   #CAM_MAX_C,camera_c
        ble.s   .no_right
        move.w  #CAM_MAX_C,camera_c
.no_right:
        move.b  #KEY_UP,d0
        bsr     input_key_down
        tst.b   d0
        beq.s   .no_up
        sub.w   #1,camera_r
        tst.w   camera_r
        bge.s   .no_up
        clr.w   camera_r
.no_up:
        move.b  #KEY_DOWN,d0
        bsr     input_key_down
        tst.b   d0
        beq.s   .no_down
        add.w   #1,camera_r
        cmp.w   #CAM_MAX_R,camera_r
        ble.s   .no_down
        move.w  #CAM_MAX_R,camera_r
.no_down:

        ; --- Function keys ---
        move.b  #KEY_F1,d0
        bsr     input_key_pressed
        tst.b   d0
        beq.s   .no_f1
        ; F1: kill all peeps (debug)
        lea     peep_data,a0
        move.w  peep_count,d7
        beq.s   .no_f1
        subq.w  #1,d7
.kill_peeps:
        or.b    #PEEP_FLAG_DEAD,PEEP_FLAGS(a0)
        add.l   #PEEP_SIZE,a0
        dbf     d7,.kill_peeps
        clr.w   peep_count
.no_f1:

        move.b  #KEY_F2,d0
        bsr     input_key_pressed
        tst.b   d0
        beq.s   .no_f2
        ; F2: destroy all buildings (debug)
        lea     house_data,a0
        move.w  house_count,d7
        beq.s   .no_f2
        subq.w  #1,d7
.kill_houses:
        or.b    #HOUSE_FLAG_DESTROYED,HOUSE_FLAGS(a0)
        add.l   #HOUSE_SIZE,a0
        dbf     d7,.kill_houses
        clr.w   house_count
.no_f2:

        move.b  #KEY_F3,d0
        bsr     input_key_pressed
        tst.b   d0
        beq.s   .no_f3
        ; F3: new random map
        bsr     map_init
        bsr     map_randomize
        bsr     house_init
        bsr     peep_init
        bsr     init_spawn_peeps
.no_f3:

        ; --- Update game logic ---
        bsr     house_update_all

        ; Check for pending peep spawns from buildings
        bsr     process_house_spawns

        bsr     peep_update_all

        ; Update AI
        bsr     ai_update

        ; --- Check game-over condition ---
        ; Game over if either team has no peeps and no buildings
        bsr     check_gameover

        movem.l (sp)+,d0-d7/a0-a4
        rts

; ===========================================================================
; process_house_spawns — iterate houses, spawn peeps where pending
; ===========================================================================
process_house_spawns:
        movem.l d0-d5/a0,-(sp)
        lea     house_data,a0
        move.w  house_count,d7
        beq     .done
        subq.w  #1,d7
.loop:
        btst    #0,HOUSE_FLAGS(a0)
        bne.s   .skip
        btst    #3,HOUSE_FLAGS(a0)      ; HOUSE_FLAG_SPAWN_PEND
        beq.s   .skip
        ; Clear flag
        and.b   #~HOUSE_FLAG_SPAWN_PEND,HOUSE_FLAGS(a0)
        ; Spawn a peep at house position
        move.w  HOUSE_R(a0),d0
        move.w  HOUSE_C(a0),d1
        move.b  HOUSE_TEAM(a0),d2
        move.w  #16,d3                  ; starting energy
        bsr     peep_spawn
.skip:  add.l   #HOUSE_SIZE,a0
        dbf     d7,.loop
.done:  movem.l (sp)+,d0-d5/a0
        rts

; ===========================================================================
; check_gameover — detect win/lose condition
; ===========================================================================
check_gameover:
        movem.l d0-d3/a0,-(sp)
        ; Count ally peeps + houses
        clr.w   d0                      ; ally count
        clr.w   d1                      ; foe count

        lea     peep_data,a0
        move.w  peep_count,d3
        beq.s   .no_peeps
        subq.w  #1,d3
.cp:    btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a0)
        bne.s   .cp_skip
        tst.b   PEEP_TEAM(a0)
        beq.s   .cp_ally
        addq.w  #1,d1
        bra.s   .cp_skip
.cp_ally: addq.w #1,d0
.cp_skip: add.l #PEEP_SIZE,a0
        dbf     d3,.cp
.no_peeps:

        lea     house_data,a0
        move.w  house_count,d3
        beq.s   .check_win
        subq.w  #1,d3
.ch:    btst    #0,HOUSE_FLAGS(a0)
        bne.s   .ch_skip
        tst.b   HOUSE_TEAM(a0)
        beq.s   .ch_ally
        addq.w  #1,d1
        bra.s   .ch_skip
.ch_ally: addq.w #1,d0
.ch_skip: add.l #HOUSE_SIZE,a0
        dbf     d3,.ch

.check_win:
        ; If ally count = 0 → game over (lose)
        ; If foe count = 0  → game over (win)
        tst.w   d0
        beq.s   .gameover
        tst.w   d1
        bne.s   .still_playing
.gameover:
        move.b  #GSTATE_GAMEOVER,game_state
.still_playing:
        movem.l (sp)+,d0-d3/a0
        rts

; ===========================================================================
; game_render — draw the current frame into the draw buffer
; ===========================================================================
game_render:
        movem.l d0-d7/a0-a4,-(sp)

        ; Clear screen
        bsr     gfx_clear_screen

        ; --- Draw terrain tiles ---
        ; Visible range: camera to camera + VIEW_H + VIEW_W
        ; Draw in isometric order: increasing r+c (painter's algorithm)
        move.w  camera_r,d5             ; base row
        move.w  camera_c,d6             ; base col

        ; Iterate view rows + a few extra for overlap
        move.w  #VIEW_H+2,d4            ; rows to draw
        move.w  d5,d3                   ; current row

.tile_row:
        move.w  d6,d2                   ; current col
        move.w  #VIEW_W+2,d7
.tile_col:
        ; Compute screen position for tile (d3, d2) relative to camera
        move.w  d2,d0                   ; c
        sub.w   d3,d0                   ; c - r
        muls    #TILE_HALF_W,d0
        add.w   #MAP_OFFSET_X,d0        ; sx

        move.w  d2,d1                   ; c
        add.w   d3,d1                   ; c + r
        muls    #TILE_HALF_H,d1
        add.w   #MAP_OFFSET_Y,d1        ; sy (before altitude)

        ; Get min altitude for vertical offset
        move.w  d3,d3_save
        move.w  d2,d2_save
        move.w  d3,d0_a0
        move.w  d2,d1_a0
        ; Reuse d0/d1 for map_get_tile_min_alt
        move.w  d3,d0
        move.w  d2,d1
        bsr     map_get_tile_min_alt
        move.b  d0,d3_alt               ; alt

        ; Adjust screen Y by altitude
        and.w   #$00ff,d0
        muls    #ALT_PIXEL_STEP,d0
        sub.w   d0,d1                   ; sy -= alt * ALT_PIXEL_STEP

        ; Look up tile index (slope detection simplified: use flat tile for now)
        ; Full slope detection would call a get_tile_index routine
        move.w  d1,d1_save              ; save sy
        move.w  d0_a0_save,d2_tile      ; tile col in atlas (simplified)
        move.w  #TILE_FLAT_IDX>>4,d3_tile ; tile row
        move.w  #TILE_FLAT_IDX&$f,d4_tile ; tile col

        ; Call gfx_blit_tile: d0=sx, d1=sy, d2=tile_col, d3=tile_row, d4=0 (default height)
        move.w  sx_tmp,d0
        move.w  sy_tmp,d1
        move.b  d4_tile_b,d2
        move.b  d3_tile_b,d3
        clr.w   d4
        bsr     gfx_blit_tile

        move.w  d2_save,d2
        move.w  d3_save,d3
        addq.w  #1,d2
        dbf     d7,.tile_col
        addq.w  #1,d3
        dbf     d4,.tile_row

        ; --- Draw houses ---
        bsr     draw_houses

        ; --- Draw peeps ---
        bsr     draw_peeps

        ; --- Draw UI ---
        bsr     draw_ui

        movem.l (sp)+,d0-d7/a0-a4
        rts

; ===========================================================================
; draw_houses — render all buildings in the current view
; ===========================================================================
draw_houses:
        movem.l d0-d7/a0,-(sp)
        lea     house_data,a0
        move.w  house_count,d7
        beq     .done
        subq.w  #1,d7

.loop:
        btst    #0,HOUSE_FLAGS(a0)
        bne     .skip

        move.w  HOUSE_R(a0),d5
        move.w  HOUSE_C(a0),d6

        ; Viewport cull
        sub.w   camera_r,d5
        sub.w   camera_c,d6
        tst.w   d5
        blt     .skip
        tst.w   d6
        blt     .skip
        cmp.w   #VIEW_H+1,d5
        bgt     .skip
        cmp.w   #VIEW_W+1,d6
        bgt     .skip

        ; Isometric screen position (simplified — no altitude offset here)
        move.w  d6,d0                   ; c-cam
        sub.w   d5,d0
        muls    #TILE_HALF_W,d0
        add.w   #MAP_OFFSET_X,d0        ; sx

        move.w  d6,d1
        add.w   d5,d1
        muls    #TILE_HALF_H,d1
        add.w   #MAP_OFFSET_Y,d1        ; sy

        ; Select building tile atlas entry based on type
        move.b  HOUSE_TYPE(a0),d2       ; building type index
        ; Atlas row 3 for buildings (matches BUILDING_TILES in settings.py)
        move.b  #3,d3
        add.b   #6,d2                   ; offset into atlas col
        clr.w   d4
        bsr     gfx_blit_tile

.skip:  add.l   #HOUSE_SIZE,a0
        dbf     d7,.loop
.done:  movem.l (sp)+,d0-d7/a0
        rts

; ===========================================================================
; draw_peeps — render all peeps in the current view
; ===========================================================================
draw_peeps:
        movem.l d0-d7/a0,-(sp)
        lea     peep_data,a0
        move.w  peep_count,d7
        beq     .done
        subq.w  #1,d7

.loop:
        btst    #PEEP_FLAG_DEAD_BIT,PEEP_FLAGS(a0)       ; DEAD
        bne     .skip

        move.w  PEEP_R(a0),d5
        move.w  PEEP_C(a0),d6
        sub.w   camera_r,d5
        sub.w   camera_c,d6
        tst.w   d5
        blt     .skip
        tst.w   d6
        blt     .skip
        cmp.w   #VIEW_H+1,d5
        bgt     .skip
        cmp.w   #VIEW_W+1,d6
        bgt     .skip

        ; Screen position
        move.w  d6,d0
        sub.w   d5,d0
        muls    #TILE_HALF_W,d0
        add.w   #MAP_OFFSET_X-SPRITE_W/2,d0

        move.w  d6,d1
        add.w   d5,d1
        muls    #TILE_HALF_H,d1
        add.w   #MAP_OFFSET_Y-SPRITE_H,d1

        ; Sprite atlas: row = direction, col = animation frame
        move.b  PEEP_DIR(a0),d3
        ; Knight uses a different row
        btst    #PEEP_FLAG_KNIGHT_BIT,PEEP_FLAGS(a0)
        beq.s   .not_knight
        move.b  #SPR_ROW_KNIGHT,d3
.not_knight:
        ; Drowning uses row SPR_ROW_DROWN
        btst    #PEEP_FLAG_DROWNING_BIT,PEEP_FLAGS(a0)
        beq.s   .not_drown
        move.b  #SPR_ROW_DROWN,d3
.not_drown:
        move.b  PEEP_ANIM(a0),d2
        ; FOE team: offset frame column by 4 (alternate palette via different atlas column)
        move.b  PEEP_TEAM(a0),d4
        bsr     gfx_blit_sprite

.skip:  add.l   #PEEP_SIZE,a0
        dbf     d7,.loop
.done:  movem.l (sp)+,d0-d7/a0
        rts

; ===========================================================================
; draw_ui — HUD: power gauge, minimap, cursor
; ===========================================================================
draw_ui:
        movem.l d0-d6/a0,-(sp)

        ; Power gauge ally (left side, top)
        ; Draw as a horizontal bar: yellow = filled, dark = empty
        move.w  power_jauge_ally,d2
        mulu    #100,d2
        divu    #POWER_MAX,d2           ; 0–100 percent
        and.w   #$00ff,d2
        move.w  #10,d0
        move.w  #10,d1
        move.w  d2,d2                   ; width
        move.w  #4,d3                   ; height
        move.b  #17,d4                  ; colour 17 = yellow
        bsr     gfx_draw_rect

        ; Power gauge foe (right side)
        move.w  power_jauge_foe,d2
        mulu    #100,d2
        divu    #POWER_MAX,d2
        and.w   #$00ff,d2
        move.w  #210,d0
        move.w  #10,d1
        move.w  d2,d2
        move.w  #4,d3
        move.b  #14,d4                  ; colour 14 = red
        bsr     gfx_draw_rect

        ; Minimap (top right area)
        move.w  #148,d0                 ; minimap X
        move.w  #180,d1                 ; minimap Y
        lea     terrain_height,a0
        lea     terrain_flags,a1
        lea     house_data,a2
        move.w  house_count,d2
        move.w  camera_r,d3
        move.w  camera_c,d4
        bsr     gfx_draw_minimap

        movem.l (sp)+,d0-d6/a0
        rts

; ===========================================================================
; draw_title_screen / draw_menu / draw_gameover — placeholder screens
; ===========================================================================
draw_title_screen:
        bsr     gfx_clear_screen
        ; Draw "POPULOUS" in large letters using bitmap font tiles would go here
        rts

draw_menu:
        ; ESC menu: RETURN / OPTIONS / QUIT
        ; Simplified: draw coloured rectangles as buttons
        move.w  #100,d0
        move.w  #80,d1
        move.w  #120,d2
        move.w  #20,d3
        move.b  #5,d4
        bsr     gfx_draw_rect           ; RETURN button
        move.w  #100,d0
        move.w  #110,d1
        bsr     gfx_draw_rect           ; OPTIONS button
        move.w  #100,d0
        move.w  #140,d1
        move.b  #14,d4
        bsr     gfx_draw_rect           ; QUIT button
        ; Check clicks on QUIT button
        bsr     input_lmb_pressed
        tst.b   d0
        beq.s   .done
        move.w  mouse_y,d0
        cmp.w   #140,d0
        blt.s   .done
        cmp.w   #160,d0
        bgt.s   .done
        ; Quit button pressed
        move.b  #GSTATE_GAMEOVER,game_state
.done:  rts

draw_gameover:
        bsr     gfx_clear_screen
        ; Draw win/lose message (placeholder)
        rts

; ===========================================================================
; Data
; ===========================================================================
        section data_c,data_c

game_state:     dc.b    GSTATE_TITLE
                dc.b    0               ; pad

camera_r:       dc.w    28              ; Start camera at ~centre
camera_c:       dc.w    28

vbl_flag:       dc.b    0
                dc.b    0
vbl_count:      dc.w    0

old_cop1:       dc.l    0
old_intena:     dc.w    0
old_dmaconr:    dc.w    0
old_vbl_vec:    dc.l    0

tile_data_ptr:  dc.l    0
spr_data_ptr:   dc.l    0

; Temporary render variables (avoid stack churn in inner loop)
sx_tmp:         dc.w    0
sy_tmp:         dc.w    0
d0_a0_save:     dc.w    0
d0_a0_save2:    dc.w    0
d2_save:        dc.w    0
d3_save:        dc.w    0
d3_alt:         dc.b    0
d3_tile_b:      dc.b    0
d4_tile_b:      dc.b    0
                dc.b    0
d1_save:        dc.w    0
d2_tile:        dc.w    0
d3_tile:        dc.w    0
d4_tile:        dc.w    0
d0_a0:          dc.w    0
d1_a0:          dc.w    0

; Memory allocation constants
TILE_DATA_SIZE  equ     6*TILE_COLS*TILE_ROWS*TILE_FULL_H*(TILE_COLS*TILE_W/8)
                        ; 6 planes (5 colour + mask) × atlas dimensions
SPR_DATA_SIZE   equ     5*SPRITE_ATLAS_W*13*SPRITE_H*SPRITE_BWIDTH
                        ; 5 planes × 8 cols × 13 rows × 16 × 2
