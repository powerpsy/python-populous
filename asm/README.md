# Populous Amiga — 68000 Assembly Port

A faithful reimplementation of the Python/Pygame Populous clone, rewritten
in Motorola 68000 assembly for the Commodore Amiga (OCS/ECS chipset).

---

## Architecture Overview

```
asm/
├── hardware.inc   — Custom chip register equates (Agnus, Denise, Paula, CIA)
├── macros.inc     — Copper, blitter, VBL and utility macros
├── data.inc       — Data structure field offsets and game constants
├── populous.asm   — Main entry, OS save/restore, VBL ISR, game loop
├── gfx.asm        — Copper list, double-buffering, blitter tile copy
├── map.asm        — 64×64 terrain grid: raise/lower, flood/quake/volcano/swamp
├── peep.asm       — Unit AI (explore, build, assemble, fight, papal, drown)
├── house.asm      — Building lifecycle (hut → castle, spawn peeps)
├── sound.asm      — Paula DMA audio (4-channel, 8-bit PCM SFX)
├── input.asm      — CIA-A keyboard, JOY0DAT mouse, LMB/RMB
├── ai.asm         — Computer opponent (terrain, powers, commands)
└── Makefile       — vasm + vlink build system
```

---

## Hardware Used

| Chip   | Feature                        | Use in game                              |
|--------|-------------------------------|------------------------------------------|
| Agnus  | Blitter (DMA)                 | Tile & sprite cookie-cut copy            |
| Agnus  | Copper                        | Bitplane pointers, 32-colour palette     |
| Agnus  | Chip RAM DMA                  | Screen buffers, tile atlas in chip RAM   |
| Denise | 5-bitplane lores display      | 320×256, 32 simultaneous colours         |
| Denise | Hardware sprites              | (reserved for mouse cursor)              |
| Paula  | 4-channel audio DMA           | SFX: quake, volcano, flood, swamp        |
| CIA-A  | Serial Data Register          | Keyboard scan codes                      |
| CIA-A  | Port A bit 6                  | Left mouse button (active low)           |
| Custom | JOY0DAT quadrature counter    | Mouse X/Y movement                       |
| Custom | POTGOR bit 10                 | Right mouse button                       |

---

## Display: 320×256, 5 Bitplanes, 32 Colours

The game uses **non-interlaced PAL lores** mode:

```
BPLCON0 = $5200   ; 5 bitplanes, colour enable
DIWSTRT = $2c81   ; display window starts at line 44, pixel 129
DIWSTOP = $f4c1   ; ends at line 244, pixel 449
DDFSTRT = $0038   ; data fetch start
DDFSTOP = $00d0   ; data fetch stop
```

Two full framebuffers are allocated in **chip RAM** (51 200 bytes each).
The copper list bitplane pointers are patched on every VBL to flip between them,
giving flicker-free double buffering.

---

## Blitter: Tile & Sprite Rendering

Isometric tiles are 32×24 pixels (matching the original Amiga tileset PNG).
Each tile occupies **4 bytes per scanline per bitplane** in the source atlas.

The blitter is operated in **cookie-cut mode**:

```
BLTCON0 = $0dfc | (shift << 12)   ; D = (A & B) | (~A & C)
```

Where:
- **A** = transparency mask plane (pre-computed from the PNG alpha)
- **B** = source tile bitplane
- **C** = current screen contents (to preserve non-transparent pixels)
- **D** = destination screen (write-back)

Pixel shift (0–15) handles tiles at non-word-aligned X positions.

---

## Map / Terrain

The terrain is a 64×64 grid of altitude corners (0–7), stored as a flat byte
array `terrain_height[4096]`.  A parallel `terrain_flags[4096]` byte array
carries per-tile flags:

| Bit | Flag            | Meaning                          |
|-----|-----------------|----------------------------------|
| 0   | `TF_WATER`      | Tile is at water level (alt = 0) |
| 1   | `TF_SWAMP`      | Swamp (peeps drown slowly)       |
| 2   | `TF_ROCK`       | Volcanic rock (impassable)       |
| 3   | `TF_CONSTRUCTED`| Tile claimed by a building       |
| 4   | `TF_PAPAL_ALLY` | Ally papal magnet position       |
| 5   | `TF_PAPAL_FOE`  | Foe papal magnet position        |

### Isometric Projection

```
sx = (c - r) × TILE_HALF_W + MAP_OFFSET_X
sy = (c + r) × TILE_HALF_H + MAP_OFFSET_Y − alt × ALT_PIXEL_STEP
```

Matching Python `settings.py` constants (TILE_HALF_W=16, TILE_HALF_H=8).

### Divine Powers

| Power   | Cost  | Effect                                      |
|---------|-------|---------------------------------------------|
| Raise   | 5     | Raise one corner by 1 altitude unit         |
| Lower   | 3     | Lower one corner by 1 altitude unit         |
| Quake   | 100   | Randomly lower a 7×7 area                   |
| Volcano | 200   | Raise 3×3 area to ALT_MAX, set rock flag    |
| Swamp   | 50    | Convert tile to swamp, slight depression    |
| Flood   | 500   | Lower all terrain by 1 (water level rises)  |
| Knight  | 350   | Convert leader peep to knight               |
| War     | 300   | (reserve — auto-build flat terrain)         |
| Papal   | 50    | Place papal magnet at target tile           |

---

## Peep AI States

```
PEEP_STATE_EXPLORE  (0)  — Random wander; default on spawn
PEEP_STATE_BUILD    (1)  — Seek flat terrain, request building placement
PEEP_STATE_ASSEMBLE (2)  — Move toward nearest same-team peep for fusion
PEEP_STATE_FIGHT    (3)  — Seek nearest enemy peep, engage in combat
PEEP_STATE_PAPAL    (4)  — Move toward papal magnet position
```

**Fusion**: two non-knight same-team peeps on the same tile merge (energy sum, max 255).  
**Combat**: enemy peeps within Manhattan distance 1 trade energy loss (random).  
**Drowning**: peep on a water tile loses 2 energy per tick; dies at 0.

---

## Building Lifecycle

Buildings progress through 10 tiers as the flat area around them grows:

| Tier | Type           | Min score | Max life | Growth/tick |
|------|----------------|-----------|----------|-------------|
| 0    | Hut            | 0         | 16       | 1           |
| 1    | House Small    | 1         | 32       | 2           |
| 2    | House Medium   | 3         | 48       | 3           |
| 3    | Castle Small   | 5         | 64       | 4           |
| 4    | Castle Medium  | 7         | 80       | 5           |
| 5    | Castle Large   | 9         | 96       | 6           |
| 6    | Fortress Small | 11        | 112      | 8           |
| 7    | Fortress Medium| 12        | 128      | 10          |
| 8    | Fortress Large | 14        | 144      | 12          |
| 9    | Grand Castle   | ≥24 (5×5) | 160      | 16          |

When `life` reaches `max_life`, a new peep spawns adjacent to the building and
`life` resets to 0.

---

## Sound

Paula DMA audio is used for all SFX.  Samples must be **8-bit signed PCM**,
loaded into **chip RAM**.

```
Paula period = 3 546 895 / frequency   (PAL clock)
```

e.g. for 8 kHz playback: period ≈ 443.

The original Populous Amiga SFX can be extracted from the game disk using
`ripsfx` or `amitools` and converted with `sox`:

```bash
sox input.8svx -r 8000 -b 8 -e signed-integer output.raw
```

Then load with `sound_load_sfx` before starting the game.

---

## Building

### Prerequisites

```bash
# macOS (Homebrew)
brew install vasm vlink

# Linux (Debian/Ubuntu)
sudo apt-get install vasm vlink

# Or build from source:
# https://sun.hasenbraten.de/vasm/
# https://sun.hasenbraten.de/vlink/
```

### Compile & Link

```bash
cd asm/
make
```

Output: `populous` (AmigaOS Hunk executable).

### Run in Emulator

```bash
make run   # requires FS-UAE in PATH
```

Or open `populous` in WinUAE / FS-UAE as a program to run from a virtual hard drive.

---

## Differences from the Python Version

| Feature              | Python (Pygame)          | Assembly (Amiga)              |
|----------------------|--------------------------|-------------------------------|
| Resolution           | 1280×720                 | 320×256 PAL                   |
| Colours              | True colour              | 32 (5 bitplanes)              |
| Tile size            | 32×24 px                 | 32×24 px (same atlas)         |
| Scrolling            | Camera follows tiles     | Camera tile-offset + copper   |
| Rendering            | SDL blit                 | Blitter cookie-cut            |
| Audio                | pygame.mixer             | Paula DMA (4 channels)        |
| AI update rate       | Proportional to fps      | 50 Hz VBL ticks               |
| Peep count           | Unlimited (Python list)  | Max 128 (static chip RAM)     |
| Building count       | Unlimited                | Max 64 (static chip RAM)      |

---

## Tile / Sprite Data Conversion

The assembler code expects tiles and sprites already converted from PNG to
**interleaved planar format** in chip RAM.  A companion Python tool
(`tools/png_to_planar.py` — to be implemented) handles this conversion at
build time and outputs raw binary files that the loader (`populous.asm`)
copies into chip RAM on startup.

Format:
```
plane0_row0[TILE_ATLAS_BWIDTH bytes], plane1_row0, ..., plane4_row0,
plane0_row1, plane1_row1, ..., plane4_row1,
...
mask_row0[TILE_ATLAS_BWIDTH bytes], mask_row1, ...
```

---

## Known Limitations / Future Work

- [ ] Slope tile selection (currently always draws flat tile)
- [ ] Hardware sprites for the mouse cursor
- [ ] Bitmap font rendering for text UI
- [ ] End-game video playback (AGA version: HAM8 Copper-driven video)
- [ ] Joystick support (JOY1DAT)
- [ ] Multi-player via serial link (CIA-B UART)
- [ ] PNG→planar conversion tool
- [ ] CD32 joypad support (via CIA-A PRA gamepad reading)
