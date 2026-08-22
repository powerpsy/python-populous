"""
sound.py – Gestion des effets sonores (portage ASM Amiga).
Dépend de pygame.mixer uniquement.
"""

import os
import pygame
from settings import SFX_DIR

# Noms des effets sonores disponibles
_SFX_NAMES = [
    "do_volcano",
    "do_flood",
    "do_quake",
    "swamp",
    "swamped",
]


class Sound:
    """Charge et joue les effets sonores depuis data/sfx/."""

    def __init__(self):
        self.muted  = False
        self.sounds: dict[str, pygame.mixer.Sound] = {}
        if not pygame.mixer.get_init():
            return
        for name in _SFX_NAMES:
            path = os.path.join(SFX_DIR, f"{name}.wav")
            if os.path.exists(path):
                try:
                    self.sounds[name] = pygame.mixer.Sound(path)
                except Exception:
                    pass

    def play(self, name: str) -> None:
        if not self.muted and name in self.sounds:
            self.sounds[name].play()

    def set_muted(self, state: bool) -> None:
        self.muted = state
        if state:
            pygame.mixer.stop()
