import pygame
from settings import TILE_HALF_W, TILE_HALF_H, GRID_WIDTH, GRID_HEIGHT, MAP_OFFSET_X, MAP_OFFSET_Y

class Camera:
    def __init__(self):
        self.offset_x = 0.0
        self.offset_y = 0.0
        self.move_timer = 0.0
        self.move_delay = 0.15  # délai entre chaque "à-coup"

        # Viewport dimensions appoximatives pour limiter le scroll (630x426)
        self.vw = 630
        self.vh = 426

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
                # Limites de la caméra (Losange pour épouser la forme de la carte)
                # Calculées dynamiquement pour supporter l'agrandissement de la grille.
                # Base de référence pour une grille 20x20 : (left: 192, right: -320, top: -104, bottom: -360)
                width_diff = GRID_WIDTH - 20
                height_diff = GRID_HEIGHT - 20
                
                left_x = 192 + height_diff * TILE_HALF_W
                right_x = -320 - width_diff * TILE_HALF_W
                top_y = -104
                bottom_y = -360 - (width_diff + height_diff) * TILE_HALF_H
                
                cx = (left_x + right_x) / 2
                cy = (top_y + bottom_y) / 2
                dx_max = (left_x - right_x) / 2
                
                # 1. Clamp au rectangle englobant global
                self.offset_x = max(right_x, min(self.offset_x, left_x))
                self.offset_y = max(bottom_y, min(self.offset_y, top_y))
                
                # 2. Clamp parfait sur le périmètre du losange
                dx = abs(self.offset_x - cx)
                dy = abs(self.offset_y - cy)
                
                if dx + 2 * dy > dx_max:
                    allowed_dy = (dx_max - dx) / 2.0
                    if self.offset_y > cy:
                        self.offset_y = cy + allowed_dy
                    else:
                        self.offset_y = cy - allowed_dy
                
                self.move_timer = self.move_delay
