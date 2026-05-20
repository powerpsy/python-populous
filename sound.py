import pygame
import os
from settings import *

class Sound():

    def __init__(self):

        self.MUTED = False
        self.sounds = {}
        for sfx_name in ["do_volcano", "do_flood", "do_quake", "swamp", "swamped"]:
            wav_path = os.path.join(SFX_DIR, f"{sfx_name}.wav")
            if pygame.mixer.get_init() and os.path.exists(wav_path):
                self.sounds[sfx_name] = pygame.mixer.Sound(wav_path)

    def play_sound(self, name):
        if (self.MUTED == False) and (name in self.sounds):
            self.sounds[name].play()

    def mute(self, state):
        self.MUTED = state

        