# =============================================================================
# POPULOUS AMIGA - Makefile
# Build system for the Amiga 68000 assembly port.
#
# Requires:
#   vasm  — Motorola 68000 assembler  (https://sun.hasenbraten.de/vasm/)
#           Use the "Motorola" syntax variant: vasmm68k_mot
#   vlink — Linker                    (https://sun.hasenbraten.de/vlink/)
#
# Cross-compilation from Linux/macOS/Windows is fully supported.
# To run the result: use FS-UAE, WinUAE, or transfer to real hardware.
# =============================================================================

# --- Tools ---
ASM     = vasmm68k_mot
LINK    = vlink

# --- Assembler flags ---
# -Fhunk        : output Amiga Hunk format object files
# -m68000       : target 68000 (compatible with all Amiga models)
# -opt-allbra   : optimise all branch instructions to short form
# -nowarn=62    : suppress "label redefined" in macros
ASMFLAGS = -Fhunk -m68000 -opt-allbra -nowarn=62 -I.

# --- Linker flags ---
# -bamigahunk   : output AmigaOS Hunk executable
# -x            : strip debug symbols from output
LDFLAGS  = -bamigahunk -x

# --- Output ---
TARGET  = populous

# --- Sources (order matters for linking) ---
SRCS    = populous.asm \
          gfx.asm      \
          map.asm      \
          peep.asm     \
          house.asm    \
          sound.asm    \
          input.asm    \
          ai.asm

OBJS    = $(SRCS:.asm=.o)

# --- Default target ---
all: $(TARGET)

# --- Link ---
$(TARGET): $(OBJS)
	$(LINK) $(LDFLAGS) $(OBJS) -o $@
	@echo "Build complete: $(TARGET)"

# --- Assemble each source ---
%.o: %.asm hardware.inc macros.inc data.inc
	$(ASM) $(ASMFLAGS) $< -o $@

# --- Clean ---
clean:
	rm -f $(OBJS) $(TARGET)

# --- Run in emulator (FS-UAE, adjust path as needed) ---
run: $(TARGET)
	fs-uae --hard-drive-0=. --chip-memory=2048 --fast-memory=8192 \
	       --cpu=68000 --pal-ntsc=pal -- populous

# --- Disassemble for debugging ---
dis: $(TARGET)
	objdump -D -m m68k-amiga $(TARGET) | less

.PHONY: all clean run dis
