; =============================================================================
; POPULOUS AMIGA - sound.asm
; Paula audio DMA playback of raw 8-bit signed PCM samples.
;
; Four channels (AUD0–AUD3) map to the game sound effects:
;   Ch.0  — General SFX (quake, volcano, flood, swamp)
;   Ch.1  — Peep/combat sounds
;   Ch.2  — Terrain manipulation feedback
;   Ch.3  — Music / ambient (future)
;
; The original Populous Amiga uses raw IFF 8SVX samples.  Here we store
; sample addresses in a table and trigger DMA when a sound is requested.
;
; Paula period for a given frequency (PAL clock = 3546895 Hz):
;   period = 3546895 / frequency
; e.g.  8363 Hz → period ≈ 424  (middle-C equivalent)
; =============================================================================

        include "hardware.inc"
        include "data.inc"

        xdef    sound_init
        xdef    sound_play
        xdef    sound_stop_all
        xdef    sound_mute
        xdef    sound_unmute

; ---------------------------------------------------------------------------
; Sound IDs  (passed to sound_play in d0.b)
; ---------------------------------------------------------------------------
SFX_QUAKE       equ     0
SFX_VOLCANO     equ     1
SFX_FLOOD       equ     2
SFX_SWAMP       equ     3
SFX_SWAMPED     equ     4
SFX_KNIGHT      equ     5
SFX_COUNT       equ     6

; ---------------------------------------------------------------------------
; sound_init — set up Paula registers and DMA
; ---------------------------------------------------------------------------
sound_init:
        ; Silence all channels
        bsr     sound_stop_all

        ; Set volumes to 0
        move.w  #0,CUSTOM+AUD0VOL
        move.w  #0,CUSTOM+AUD1VOL
        move.w  #0,CUSTOM+AUD2VOL
        move.w  #0,CUSTOM+AUD3VOL

        clr.b   snd_muted
        rts

; ---------------------------------------------------------------------------
; sound_play  — play a sound effect
; In: d0.b = SFX_* id
; Trashes: d0/d1/a0/a1
; ---------------------------------------------------------------------------
sound_play:
        tst.b   snd_muted
        bne     .done

        and.w   #$00ff,d0
        cmp.b   #SFX_COUNT,d0
        bge     .done

        ; Look up sample address and parameters
        lea     sfx_table,a0
        mulu    #sfx_entry_size,d0
        add.w   d0,a0

        ; Check sample pointer is valid (non-null)
        move.l  sfx_addr(a0),d1
        beq     .done                   ; No sample data loaded

        ; Allocate to channel 0 (simple: always use ch.0 for now)
        ; A full implementation would pick the least-busy channel.

        ; Wait for any previous DMA on ch.0 to finish would be needed here
        ; for looping sounds.  For one-shot, just restart.

        ; Stop ch.0 DMA first
        move.w  #DMAF_AUD0,CUSTOM+DMACON ; Clear ch.0 DMA

        ; Load Paula ch.0 registers
        move.l  d1,CUSTOM+AUD0LCH       ; Sample pointer (high + low words)
        move.w  sfx_len(a0),CUSTOM+AUD0LEN  ; Length in words
        move.w  sfx_per(a0),CUSTOM+AUD0PER  ; Period
        move.w  #AUD_VOL_MAX,CUSTOM+AUD0VOL ; Full volume

        ; Start DMA for channel 0
        move.w  #DMAF_SETCLR|DMAF_AUD0,CUSTOM+DMACON

.done:  rts

; ---------------------------------------------------------------------------
; sound_stop_all — disable all audio DMA and silence channels
; ---------------------------------------------------------------------------
sound_stop_all:
        move.w  #DMAF_AUDIO,CUSTOM+DMACON   ; Clear all audio DMA bits
        move.w  #0,CUSTOM+AUD0VOL
        move.w  #0,CUSTOM+AUD1VOL
        move.w  #0,CUSTOM+AUD2VOL
        move.w  #0,CUSTOM+AUD3VOL
        rts

; ---------------------------------------------------------------------------
; sound_mute / sound_unmute
; ---------------------------------------------------------------------------
sound_mute:
        st      snd_muted               ; Set all bits (= $ff)
        bsr     sound_stop_all
        rts

sound_unmute:
        clr.b   snd_muted
        rts

; ---------------------------------------------------------------------------
; sound_load_sfx — register a sample in the sfx table
; In:  d0.b = SFX_* id
;      a0   = pointer to 8-bit signed PCM sample data in CHIP RAM
;      d1.w = length in bytes
;      d2.w = playback period (Paula period, see formula above)
; ---------------------------------------------------------------------------
        xdef    sound_load_sfx
sound_load_sfx:
        and.w   #$00ff,d0
        cmp.b   #SFX_COUNT,d0
        bge     .done

        lea     sfx_table,a1
        mulu    #sfx_entry_size,d0
        add.w   d0,a1

        move.l  a0,sfx_addr(a1)
        ; Length in words = ceil(byte_length / 2)
        add.w   #1,d1
        lsr.w   #1,d1
        move.w  d1,sfx_len(a1)
        move.w  d2,sfx_per(a1)
.done:  rts

; ---------------------------------------------------------------------------
; sfx_table — SFX descriptor entries
; ---------------------------------------------------------------------------
sfx_entry_size  equ     8               ; addr(4) + len(2) + per(2)
sfx_addr        equ     0
sfx_len         equ     4
sfx_per         equ     6

; Default PAL periods for nominal 8 kHz playback:
;   period = 3546895 / 8000 ≈ 443
SFX_DEFAULT_PERIOD  equ 443

        section data_c,data_c
sfx_table:
        ; SFX_QUAKE
        dc.l    0                       ; addr (filled by sound_load_sfx)
        dc.w    0                       ; len
        dc.w    SFX_DEFAULT_PERIOD
        ; SFX_VOLCANO
        dc.l    0
        dc.w    0
        dc.w    SFX_DEFAULT_PERIOD
        ; SFX_FLOOD
        dc.l    0
        dc.w    0
        dc.w    SFX_DEFAULT_PERIOD
        ; SFX_SWAMP
        dc.l    0
        dc.w    0
        dc.w    SFX_DEFAULT_PERIOD
        ; SFX_SWAMPED
        dc.l    0
        dc.w    0
        dc.w    SFX_DEFAULT_PERIOD
        ; SFX_KNIGHT
        dc.l    0
        dc.w    0
        dc.w    SFX_DEFAULT_PERIOD

snd_muted:  dc.b    0
            dc.b    0                   ; pad
