; =============================================================================
; POPULOUS AMIGA - data.inc
; Game data structure field offsets and game-wide constants.
; Must be kept in sync with the Python settings.py and game logic.
; =============================================================================

; ---------------------------------------------------------------------------
; Screen / Display constants  (PAL 320x256, 5 bitplanes = 32 colours)
; ---------------------------------------------------------------------------
SCREEN_W        equ     320
SCREEN_H        equ     256
SCREEN_BWIDTH   equ     SCREEN_W/8      ; Bytes per scanline per bitplane = 40
SCREEN_PLANES   equ     5               ; Number of bitplanes
SCREEN_SIZE     equ     SCREEN_BWIDTH*SCREEN_H   ; One plane = 10240 bytes
SCREEN_TOTAL    equ     SCREEN_SIZE*SCREEN_PLANES ; All planes = 51200 bytes
; Double-buffer: two full frame buffers
SCREEN_BUF_SZ   equ     SCREEN_TOTAL*2

; ---------------------------------------------------------------------------
; Tile & Isometric layout  (matches Python settings.py)
; ---------------------------------------------------------------------------
TILE_W          equ     32
TILE_H          equ     16              ; Visible tile height (isometric)
TILE_FULL_H     equ     24              ; Full sprite height including wall depth
TILE_HALF_W     equ     TILE_W/2        ; = 16
TILE_HALF_H     equ     TILE_H/2        ; = 8
TILE_BWIDTH     equ     TILE_W/8        ; Bytes per tile row per plane = 4

; Tile atlas layout (from settings.py TILES_V_LINES / TILES_H_LINES)
; Source PNG layout: 9 columns x 7 rows of 32x24 tiles (stride 35x50 in PNG)
TILE_COLS       equ     9
TILE_ROWS       equ     7
TILE_ATLAS_BWIDTH equ   (TILE_COLS*TILE_W)/8    ; Bytes per scanline in tile atlas = 36
TILE_ATLAS_PLANE_SZ equ TILE_ATLAS_BWIDTH*TILE_FULL_H  ; One plane of atlas tile row

; Altitude
ALT_PIXEL_STEP  equ     4               ; Pixels per altitude unit (replaces ALTITUDE_PIXEL_STEP=1 for readability on 320px screen)
ALT_MIN         equ     0
ALT_MAX         equ     7

; Tile indices (column, row) — packed as (row<<4)|col for fast lookup
; Matches Python SLOPE_TILES / TILE_WATER / TILE_FLAT etc.
TILE_WATER_IDX  equ     (0<<4)|0        ; (0,0)
TILE_FLAT_IDX   equ     (1<<4)|6        ; (1,6)
TILE_SWAMP_IDX  equ     (5<<4)|8        ; (5,8)
TILE_WATER2_IDX equ     (1<<4)|7        ; (1,7) water animation frame 2

; ---------------------------------------------------------------------------
; Map / Camera
; ---------------------------------------------------------------------------
GRID_W          equ     64
GRID_H          equ     64
GRID_SIZE       equ     GRID_W*GRID_H   ; = 4096 bytes for terrain array

VIEW_W          equ     10              ; Visible columns (320 / TILE_HALF_W * 2 ≈ 10)
VIEW_H          equ     8               ; Visible rows

; Camera origin (top-left of visible area on screen, in pixels)
MAP_OFFSET_X    equ     160             ; SCREEN_W / 2
MAP_OFFSET_Y    equ     48              ; SCREEN_H / 4

; ---------------------------------------------------------------------------
; Entity counts
; ---------------------------------------------------------------------------
MAX_PEEPS       equ     128             ; Max peep records (both teams)
MAX_HOUSES      equ     64              ; Max building records

; ---------------------------------------------------------------------------
; Teams
; ---------------------------------------------------------------------------
TEAM_ALLY       equ     0
TEAM_FOE        equ     1

; ---------------------------------------------------------------------------
; Peep record layout  (PEEP_SIZE bytes each, 32 bytes aligned)
; ---------------------------------------------------------------------------
PEEP_R          equ     0       ; .w  Integer row position
PEEP_C          equ     2       ; .w  Integer col position
PEEP_R_FRAC     equ     4       ; .b  Fractional row (0–255, 256 = 1 tile)
PEEP_C_FRAC     equ     5       ; .b  Fractional col
PEEP_ENERGY     equ     6       ; .w  Energy / HP (0 = dead)
PEEP_STATE      equ     8       ; .b  Behaviour state (PEEP_STATE_*)
PEEP_TEAM       equ     9       ; .b  TEAM_ALLY or TEAM_FOE
PEEP_ANIM       equ     10      ; .b  Current animation frame (0–3)
PEEP_ANIM_TMR   equ     11      ; .b  Ticks until next animation frame
PEEP_DIR        equ     12      ; .b  Movement direction (0=N…7=NW, 8 dirs)
PEEP_FLAGS      equ     13      ; .b  Bit flags (see PEEP_FLAG_*)
PEEP_TARGET_R   equ     14      ; .w  Target tile row
PEEP_TARGET_C   equ     16      ; .w  Target tile col
PEEP_SPEED      equ     18      ; .w  Speed accumulator (ticks per tile)
PEEP_WEAPON     equ     20      ; .b  Weapon index (0=none, 1=sword, …)
PEEP_BATTLE_TMR equ     21      ; .b  Ticks remaining in battle
PEEP_DROWN_CNT  equ     22      ; .b  Drowning counter (0 = alive)
PEEP_HOME       equ     23      ; .b  Index of home House (-1 = homeless)
                                ;     4 bytes free
PEEP_SIZE       equ     28      ; Must be even; pad to 28 for alignment

; PEEP_FLAGS bits (bit numbers for BTST/BSET/BCLR)
PEEP_FLAG_DEAD_BIT      equ     0
PEEP_FLAG_KNIGHT_BIT    equ     1
PEEP_FLAG_LEADER_BIT    equ     2
PEEP_FLAG_SHIELD_BIT    equ     3
PEEP_FLAG_DROWNING_BIT  equ     4
PEEP_FLAG_WAITING_BIT   equ     5
; Mask versions (for OR/AND)
PEEP_FLAG_DEAD      equ     $01
PEEP_FLAG_KNIGHT    equ     $02
PEEP_FLAG_LEADER    equ     $04
PEEP_FLAG_SHIELD    equ     $08
PEEP_FLAG_DROWNING  equ     $10
PEEP_FLAG_WAITING   equ     $20 ; Standing still (assemble / papal)

; Peep behaviour states
PEEP_STATE_BUILD    equ     0   ; _go_build
PEEP_STATE_ASSEMBLE equ     1   ; _go_assemble
PEEP_STATE_FIGHT    equ     2   ; _go_fight
PEEP_STATE_PAPAL    equ     3   ; _go_papal
PEEP_STATE_IDLE     equ     4
PEEP_STATE_EXPLORE  equ     5   ; exploring (default wandering)

; Peep directions (matching sprite rows in AmigaSprites1.PNG)
DIR_N           equ     0
DIR_NE          equ     1
DIR_E           equ     2
DIR_SE          equ     3
DIR_S           equ     4
DIR_SW          equ     5
DIR_W           equ     6
DIR_NW          equ     7

; Isometric direction delta table (r, c) for each of the 8 directions
; Used by peep movement routines
; Format: .b delta_r, delta_c  (signed, multiplied by 1 per step)
ISO_DR_N        equ     -1
ISO_DC_N        equ     -1
ISO_DR_NE       equ     -1
ISO_DC_NE       equ      0
ISO_DR_E        equ     -1
ISO_DC_E        equ      1
ISO_DR_SE       equ      0
ISO_DC_SE       equ      1
ISO_DR_S        equ      1
ISO_DC_S        equ      1
ISO_DR_SW       equ      1
ISO_DC_SW       equ      0
ISO_DR_W        equ      1
ISO_DC_W        equ     -1
ISO_DR_NW       equ      0
ISO_DC_NW       equ     -1

; Peep movement timing (ticks between tile steps, PAL = 50 ticks/s)
PEEP_TICKS_NORMAL   equ     5   ; 10 tiles/s
PEEP_TICKS_KNIGHT   equ     3   ; ~17 tiles/s (knight is faster)

; Peep animation timing (ticks between frames)
PEEP_ANIM_TICKS     equ     8   ; 6.25 fps animation

; ---------------------------------------------------------------------------
; House record layout  (HOUSE_SIZE bytes each)
; ---------------------------------------------------------------------------
HOUSE_R         equ     0       ; .w  Tile row of centre
HOUSE_C         equ     2       ; .w  Tile col of centre
HOUSE_TYPE      equ     4       ; .b  Building type (HOUSE_TYPE_*)
HOUSE_TEAM      equ     5       ; .b  TEAM_ALLY or TEAM_FOE
HOUSE_LIFE      equ     6       ; .w  Current life (integer; max = HOUSE_MAX_LIFE)
HOUSE_MAX_LIFE  equ     8       ; .w  Maximum life for current tier
HOUSE_FLAGS     equ     10      ; .b  Bit flags (HOUSE_FLAG_*)
HOUSE_SCORE     equ     11      ; .b  Flat-area score (number of valid tiles)
HOUSE_TIER      equ     12      ; .b  Current tier index (0–9)
HOUSE_GROWTH    equ     13      ; .b  Growth ticks remaining until life increment
HOUSE_OCC_CNT   equ     14      ; .b  Number of occupied tiles
HOUSE_PAD       equ     15      ; .b  Padding
HOUSE_SIZE      equ     16

; HOUSE_FLAGS bits
HOUSE_FLAG_DESTROYED    equ     $01
HOUSE_FLAG_LEADER       equ     $02
HOUSE_FLAG_SHIELD       equ     $04
HOUSE_FLAG_SPAWN_PEND   equ     $08 ; Pending peep spawn

; House types (tier index → type)
HOUSE_TYPE_HUT          equ     0
HOUSE_TYPE_HOUSE_S      equ     1
HOUSE_TYPE_HOUSE_M      equ     2
HOUSE_TYPE_CASTLE_S     equ     3
HOUSE_TYPE_CASTLE_M     equ     4
HOUSE_TYPE_CASTLE_L     equ     5
HOUSE_TYPE_FORT_S       equ     6
HOUSE_TYPE_FORT_M       equ     7
HOUSE_TYPE_FORT_L       equ     8
HOUSE_TYPE_CASTLE       equ     9   ; Grand Castle (5×5 flat zone)

; House growth speeds (life points per game tick, indexed by tier)
; Matches Python GROWTH_SPEEDS = [1,2,3,4,5,6,8,10,12,16]
; Stored as bytes in house_growth_tbl

; House tier thresholds (minimum flat-area score to reach that tier)
; Matches Python thresholds = [0,1,3,5,7,9,11,12,14,16]
; Stored as bytes in house_tier_thresholds

; Castle grand tier requires score >= 24 (5×5 area)
CASTLE_GRAND_SCORE      equ     24

; ---------------------------------------------------------------------------
; Camera record
; ---------------------------------------------------------------------------
CAM_R           equ     0       ; .w  Top-left tile row
CAM_C           equ     2       ; .w  Top-left tile col
CAM_SIZE        equ     4

CAM_MAX_R       equ     GRID_H-VIEW_H   ; = 56
CAM_MAX_C       equ     GRID_W-VIEW_W   ; = 54

; ---------------------------------------------------------------------------
; Divine Powers
; ---------------------------------------------------------------------------
POWER_MAX       equ     1000
POWER_ACCUM_TICKS equ   25      ; Game ticks between power accumulation (+1)

; Power costs  (match Python POWER_COSTS dict)
COST_QUAKE      equ     100
COST_KNIGHT     equ     350
COST_VOLCANO    equ     200
COST_SWAMP      equ     50
COST_FLOOD      equ     500
COST_WAR        equ     300
COST_PAPAL      equ     50
COST_RAISE      equ     5       ; Terrain raise (per corner)
COST_LOWER      equ     3       ; Terrain lower

; ---------------------------------------------------------------------------
; Game states
; ---------------------------------------------------------------------------
GSTATE_TITLE    equ     0
GSTATE_PLAY     equ     1
GSTATE_MENU     equ     2
GSTATE_GAMEOVER equ     3

; ---------------------------------------------------------------------------
; AI difficulty constants  (match Python AIPlayer.set_difficulty)
; ---------------------------------------------------------------------------
AI_TERRAIN_TICKS_SLOW   equ     150     ; ~3 s at 50 Hz
AI_TERRAIN_TICKS_FAST   equ     17      ; ~0.33 s
AI_POWER_TICKS          equ     500     ; ~10 s
AI_CMD_TICKS_SLOW       equ     6000    ; ~120 s
AI_CMD_TICKS_FAST       equ     250     ; ~5 s

; ---------------------------------------------------------------------------
; Terrain flags (terrain_flags array, one byte per tile)
; ---------------------------------------------------------------------------
TF_WATER        equ     $01
TF_SWAMP        equ     $02
TF_ROCK         equ     $04
TF_CONSTRUCTED  equ     $08
TF_PAPAL_ALLY   equ     $10
TF_PAPAL_FOE    equ     $20

; ---------------------------------------------------------------------------
; Sprite layout in AmigaSprites1.PNG  (16×16 per frame)
; Row = animation direction (0=N…7=NW), Col = frame (0–3)
; Plus additional rows for drowning, knight, leader etc.
; ---------------------------------------------------------------------------
SPRITE_W        equ     16
SPRITE_H        equ     16
SPRITE_STRIDE_X equ     19              ; Pixels between sprites in atlas X
SPRITE_STRIDE_Y equ     19              ; Pixels between sprites in atlas Y
SPRITE_START_X  equ     11
SPRITE_START_Y  equ     10

; Sprite atlas constants (also used by gfx.asm)
SPRITE_ATLAS_W      equ     8               ; Columns in sprite atlas
SPRITE_BWIDTH       equ     SPRITE_W/8      ; = 2 bytes per row per plane
SPRITE_ATLAS_BWIDTH equ     SPRITE_ATLAS_W*SPRITE_BWIDTH  ; = 16 bytes

; Sprite row indices in sheet
SPR_ROW_WALK    equ     0               ; Rows 0–7: walking N,NE,E,SE,S,SW,W,NW (4 frames each)
SPR_ROW_DROWN   equ     8               ; Row 8: drowning animation (4 frames)
SPR_ROW_FIGHT   equ     9               ; Row 9: combat
SPR_ROW_BUILD   equ     10              ; Row 10: building
SPR_ROW_PAPAL   equ     11              ; Row 11: carrying cross / evil sign
SPR_ROW_KNIGHT  equ     12              ; Row 12: knight (on horse)

; ---------------------------------------------------------------------------
; Keyboard scan codes (Amiga raw codes from CIA-A SDR)
; ---------------------------------------------------------------------------
KEY_F1          equ     $50
KEY_F2          equ     $51
KEY_F3          equ     $52
KEY_F4          equ     $53
KEY_F12         equ     $5f
KEY_TAB         equ     $42
KEY_ESC         equ     $45
KEY_UP          equ     $4c
KEY_DOWN        equ     $4d
KEY_LEFT        equ     $4f
KEY_RIGHT       equ     $4e
KEY_SECTION     equ     $00             ; § key (debug toggle)

; Keyboard key state array size
KEY_COUNT       equ     128
