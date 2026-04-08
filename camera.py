import pygame
from settings import TILE_HALF_W, TILE_HALF_H

class Camera:
    def __init__(self):
        self.offset_x = 0.0
        self.offset_y = 0.0
        self.move_timer = 0.0
        self.move_delay = 0.15  # délai entre chaque "à-coup"

    def update(self, dt):
        keys = pygame.key.get_pressed()
        self.move_timer -= dt
        
        if self.move_timer <= 0:
            moved = False
            # Déplacement par à-coup de la taille d'une tile
            if keys[pygame.K_LEFT] or keys[pygame.K_a]:
                self.offset_x += TILE_HALF_W * 2
                moved = True
            elif keys[pygame.K_RIGHT] or keys[pygame.K_d]:
                self.offset_x -= TILE_HALF_W * 2
                moved = True
                
            # Les Y sont indépendants pour permettre les diagonales
            if keys[pygame.K_UP] or keys[pygame.K_w]:
                self.offset_y += TILE_HALF_H * 2
                moved = True
            elif keys[pygame.K_DOWN] or keys[pygame.K_s]:
                self.offset_y -= TILE_HALF_H * 2
                moved = True
                
            if moved:
                self.move_timer = self.move_delay
