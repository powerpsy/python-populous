; =============================================================================
; POPULOUS AMIGA - hardware.inc
; Amiga OCS/ECS Custom Chip Hardware Register Equates
; Source: Amiga Hardware Reference Manual (3rd edition, Commodore, 1992)
; All offsets relative to CUSTOM base ($DFF000)
; =============================================================================

CUSTOM          equ     $dff000         ; Custom chip base address
CIAA            equ     $bfe001         ; CIA-A base (odd byte addressing)
CIAB            equ     $bfd000         ; CIA-B base (even byte addressing)

; ---------------------------------------------------------------------------
; DMA Control  (write: DMACON $096, read: DMACONR $002)
; ---------------------------------------------------------------------------
DMACON          equ     $096
DMACONR         equ     $002
DMAF_SETCLR     equ     $8000           ; Bit 15: 1=set bits, 0=clear bits
DMAF_ALL        equ     $01ff           ; All DMA channel bits
DMAF_MASTER     equ     $0200           ; Master DMA enable (bit 9)
DMAF_COPPER     equ     $0080           ; Copper DMA   (bit 7)
DMAF_BLITTER    equ     $0040           ; Blitter DMA  (bit 6)
DMAF_SPRITE     equ     $0020           ; Sprite DMA   (bit 5)
DMAF_DISK       equ     $0010           ; Disk DMA     (bit 4)
DMAF_AUD3       equ     $0008           ; Audio ch.3   (bit 3)
DMAF_AUD2       equ     $0004           ; Audio ch.2   (bit 2)
DMAF_AUD1       equ     $0002           ; Audio ch.1   (bit 1)
DMAF_AUD0       equ     $0001           ; Audio ch.0   (bit 0)
; Convenience: enable all audio channels
DMAF_AUDIO      equ     DMAF_AUD0|DMAF_AUD1|DMAF_AUD2|DMAF_AUD3

; ---------------------------------------------------------------------------
; Interrupt Enable/Request  (INTENA $09a / INTENAR $01c, INTREQ $09c / INTREQR $01e)
; ---------------------------------------------------------------------------
INTENA          equ     $09a
INTENAR         equ     $01c
INTREQ          equ     $09c
INTREQR         equ     $01e
INTF_SETCLR     equ     $8000
INTF_INTEN      equ     $4000           ; Master interrupt enable
INTF_EXTER      equ     $2000
INTF_DSKSYNC    equ     $1000
INTF_RBF        equ     $0800
INTF_AUD3       equ     $0400
INTF_AUD2       equ     $0200
INTF_AUD1       equ     $0100
INTF_AUD0       equ     $0080
INTF_BLIT       equ     $0040           ; Blitter finished
INTF_VERTB      equ     $0020           ; Vertical blank
INTF_COPER      equ     $0010           ; Copper
INTF_PORTS      equ     $0008           ; I/O ports / timers (CIA-A flag)
INTF_SOFT       equ     $0004           ; Software interrupt
INTF_DSKBLK     equ     $0002
INTF_TBE        equ     $0001

; ---------------------------------------------------------------------------
; Beam Position  (read-only)
; ---------------------------------------------------------------------------
VPOSR           equ     $004            ; Vert. most sig. bit + LOF flag
VHPOSR          equ     $006            ; Vert. and horiz. beam position

; ---------------------------------------------------------------------------
; Display Window & Data Fetch
; ---------------------------------------------------------------------------
DIWSTRT         equ     $08e
DIWSTOP         equ     $090
DDFSTRT         equ     $092
DDFSTOP         equ     $094

; PAL full-screen values (320×256, overscan borders removed)
DIWSTRT_PAL     equ     $2c81           ; V=$2c, H=$81
DIWSTOP_PAL     equ     $f4c1           ; V=$f4, H=$c1
DDFSTRT_LORES   equ     $0038
DDFSTOP_LORES   equ     $00d0

; ---------------------------------------------------------------------------
; Bitplane Control
; ---------------------------------------------------------------------------
BPLCON0         equ     $100
BPLCON1         equ     $102            ; Horizontal scroll (fine, per-plane)
BPLCON2         equ     $104            ; Sprite/playfield priority
BPL1MOD         equ     $108            ; Modulo odd planes
BPL2MOD         equ     $10a            ; Modulo even planes

; BPLCON0 bit fields
BPL_HIRES       equ     $8000           ; Hi-res (640 pixels wide)
BPL_BPU_SHIFT   equ     12              ; Bits 14:12 = number of bitplanes
BPL_COLOR       equ     $0200           ; Colour enable
BPL_LACE        equ     $0004           ; Interlace

; Prebuilt BPLCON0 values
BPLCON0_5BPL    equ     (5<<BPL_BPU_SHIFT)|BPL_COLOR   ; 5 planes, colour on

; Bitplane pointer registers (high word / low word pairs)
BPL1PTH         equ     $0e0
BPL1PTL         equ     $0e2
BPL2PTH         equ     $0e4
BPL2PTL         equ     $0e6
BPL3PTH         equ     $0e8
BPL3PTL         equ     $0ea
BPL4PTH         equ     $0ec
BPL4PTL         equ     $0ee
BPL5PTH         equ     $0f0
BPL5PTL         equ     $0f2

; ---------------------------------------------------------------------------
; Palette (COLOR00–COLOR31, each 12-bit $0RGB, big-endian word at offset)
; ---------------------------------------------------------------------------
COLOR00         equ     $180
COLOR01         equ     $182
COLOR02         equ     $184
COLOR03         equ     $186
COLOR04         equ     $188
COLOR05         equ     $18a
COLOR06         equ     $18c
COLOR07         equ     $18e
COLOR08         equ     $190
COLOR09         equ     $192
COLOR10         equ     $194
COLOR11         equ     $196
COLOR12         equ     $198
COLOR13         equ     $19a
COLOR14         equ     $19c
COLOR15         equ     $19e
COLOR16         equ     $1a0
COLOR17         equ     $1a2
COLOR18         equ     $1a4
COLOR19         equ     $1a6
COLOR20         equ     $1a8
COLOR21         equ     $1aa
COLOR22         equ     $1ac
COLOR23         equ     $1ae
COLOR24         equ     $1b0
COLOR25         equ     $1b2
COLOR26         equ     $1b4
COLOR27         equ     $1b6
COLOR28         equ     $1b8
COLOR29         equ     $1ba
COLOR30         equ     $1bc
COLOR31         equ     $1be

; ---------------------------------------------------------------------------
; Copper
; ---------------------------------------------------------------------------
COP1LCH         equ     $080            ; Copper list 1 high word
COP1LCL         equ     $082            ; Copper list 1 low word
COP2LCH         equ     $084
COP2LCL         equ     $086
COPJMP1         equ     $088            ; Strobe: restart copper from list 1
COPJMP2         equ     $08a            ; Strobe: restart copper from list 2

; ---------------------------------------------------------------------------
; Blitter
; ---------------------------------------------------------------------------
BLTCON0         equ     $040
BLTCON1         equ     $042
BLTAFWM         equ     $044            ; First-word mask channel A
BLTALWM         equ     $046            ; Last-word mask channel A
BLTCPTH         equ     $048
BLTCPTL         equ     $04a
BLTBPTH         equ     $04c
BLTBPTL         equ     $04e
BLTAPTH         equ     $050
BLTAPTL         equ     $052
BLTDPTH         equ     $054
BLTDPTL         equ     $056
BLTSIZE         equ     $058            ; Size + trigger (bits 15:6 = height, 5:0 = width in words)
BLTCMOD         equ     $060
BLTBMOD         equ     $062
BLTAMOD         equ     $064
BLTDMOD         equ     $066
BLTCDAT         equ     $070
BLTBDAT         equ     $072
BLTADAT         equ     $074

; BLTCON0 common operation codes (ASH shift = 0)
; Logic function byte: LF = result of minterm (D = f(A,B,C))
; Useful presets:
BLTOP_A_TO_D        equ     $09f0       ; D = A           (copy, uses A+D)
BLTOP_COOKIE_CUT    equ     $0dfc       ; D = (A&B)|(~A&C) (cookie-cut sprite over background)
BLTOP_FILL_ZERO     equ     $0100       ; D = 0            (clear, channel D only)
BLTOP_OR            equ     $0fca       ; D = A | B | C

; Blitter busy flag in DMACONR bit 14 (also in $002 bit 14)
BLIT_BUSY_BIT   equ     14

; ---------------------------------------------------------------------------
; Hardware Sprites (8 sprites, SPR0..SPR7)
; ---------------------------------------------------------------------------
SPR0PTH         equ     $120
SPR0PTL         equ     $122
SPR1PTH         equ     $124
SPR1PTL         equ     $126
SPR2PTH         equ     $128
SPR2PTL         equ     $12a
SPR3PTH         equ     $12c
SPR3PTL         equ     $12e
SPR4PTH         equ     $130
SPR4PTL         equ     $132
SPR5PTH         equ     $134
SPR5PTL         equ     $136
SPR6PTH         equ     $138
SPR6PTL         equ     $13a
SPR7PTH         equ     $13c
SPR7PTL         equ     $13e

; Sprite control words (per-sprite registers, copper-writeable)
SPR0POS         equ     $140
SPR0CTL         equ     $142
SPR0DATA        equ     $144
SPR0DATB        equ     $146

; ---------------------------------------------------------------------------
; Paula — Audio Channels 0–3
; Each channel stride = $10
; ---------------------------------------------------------------------------
AUD0LCH         equ     $0a0
AUD0LCL         equ     $0a2
AUD0LEN         equ     $0a4
AUD0PER         equ     $0a6
AUD0VOL         equ     $0a8

AUD1LCH         equ     $0b0
AUD1LCL         equ     $0b2
AUD1LEN         equ     $0b4
AUD1PER         equ     $0b6
AUD1VOL         equ     $0b8

AUD2LCH         equ     $0c0
AUD2LCL         equ     $0c2
AUD2LEN         equ     $0c4
AUD2PER         equ     $0c6
AUD2VOL         equ     $0c8

AUD3LCH         equ     $0d0
AUD3LCL         equ     $0d2
AUD3LEN         equ     $0d4
AUD3PER         equ     $0d6
AUD3VOL         equ     $0d8

; Volume max
AUD_VOL_MAX     equ     64

; ---------------------------------------------------------------------------
; CIA-A  ($BFE001, odd bytes — keyboard, TOD, drive LED, fire button)
; ---------------------------------------------------------------------------
CIAA_PRA        equ     $0
CIAA_PRB        equ     $200
CIAA_DDRA       equ     $400
CIAA_DDRB       equ     $600
CIAA_TALO       equ     $800
CIAA_TAHI       equ     $a00
CIAA_TBLO       equ     $c00
CIAA_TBHI       equ     $e00
CIAA_TODLO      equ     $1000
CIAA_TODMID     equ     $1200
CIAA_TODHI      equ     $1400
CIAA_SDR        equ     $1800           ; Serial data register (keyboard scan codes)
CIAA_ICR        equ     $1c00           ; Interrupt control register
CIAA_CRA        equ     $1e00
CIAA_CRB        equ     $2000

; CIA-A PRA bits
CIAA_LED        equ     $02             ; Bit 1: drive LED (0=on)
CIAA_OVL        equ     $01             ; Bit 0: Chip RAM overlay
; Fire buttons (read from CIA-A PRA, active low)
CIAA_FIRE0      equ     $40             ; Bit 6: left mouse button / fire 0
CIAA_FIRE1      equ     $80             ; Bit 7: right mouse button (via CIA-B?)

; ---------------------------------------------------------------------------
; CIA-B  ($BFD000, even bytes — disk, serial, mouse buttons)
; ---------------------------------------------------------------------------
CIAB_PRA        equ     $0              ; Disk control
CIAB_PRB        equ     $100            ; Mouse/joystick button port
CIAB_DDRA       equ     $200
CIAB_DDRB       equ     $300

; Right mouse button via CIA-B PRA bit 2 (active low)
CIAB_RMB        equ     $04

; ---------------------------------------------------------------------------
; Mouse / Joystick
; ---------------------------------------------------------------------------
JOY0DAT         equ     $00a            ; Mouse counter (H=Y, L=X)
JOY1DAT         equ     $00c            ; Joystick
POTGO           equ     $034            ; Potentiometer start
POTGOR          equ     $016            ; Potentiometer read (right mouse button)

; Right mouse button from POTGOR bit 10 (active low when pressed)
POTGOR_RMB      equ     $0400

; ---------------------------------------------------------------------------
; Exec Library  (needed for OpenLibrary / supervisor calls)
; ---------------------------------------------------------------------------
EXEC_BASE       equ     $4              ; ExecBase pointer at absolute $4
LVO_SUPERVISE   equ     -30             ; Supervisor() LVO
LVO_DISABLE     equ     -120            ; Disable()
LVO_ENABLE      equ     -126            ; Enable()
LVO_OPENLIB     equ     -552            ; OpenLibrary()
LVO_CLOSELIB    equ     -414            ; CloseLibrary()
LVO_ALLOCMEM    equ     -198            ; AllocMem()
LVO_FREEMEM     equ     -210            ; FreeMem()
LVO_SETEXCPT    equ     -300            ; SetExcVec()
LVO_SETINTV     equ     -162            ; SetIntVector()
LVO_ADDINTVEC   equ     -168            ; AddIntServer()
LVO_REMINTVEC   equ     -174            ; RemIntServer()

; AllocMem flags
MEMF_CHIP       equ     $0002           ; Chip RAM (DMA accessible)
MEMF_FAST       equ     $0004           ; Fast RAM
MEMF_PUBLIC     equ     $0001
MEMF_CLEAR      equ     $00010000       ; Clear memory on allocation

; Interrupt number
INTB_VERTB      equ     5               ; Level 3 VERTB interrupt server index
