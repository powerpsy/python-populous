import pygame
import settings

class Camera:
    def __init__(self):
        self.move_timer = 0.0
        self.move_delay = 0.15  # délai entre chaque "à-coup"

        # Viewport dimensions appoximatives pour limiter le scroll (630x426)
        self.vw = 630
        self.vh = 426
        
        # Position initiale validée (u_cam=-1312, v_cam=1184 correspond au centre environ)
        u_init = -1312
        v_init = 1184
        self.offset_x = (u_init + v_init) / 2
        self.offset_y = (u_init - v_init) / 4


    def update(self, dt):
        keys = pygame.key.get_pressed()
        self.move_timer -= dt
        
        if self.move_timer <= 0:
            moved = False
            
            # Déplacement par à-coup de la taille d'une tile
            if keys[pygame.K_LEFT] or keys[pygame.K_a]:
                self.offset_x += settings.TILE_HALF_W * 2
                moved = True
            elif keys[pygame.K_RIGHT] or keys[pygame.K_d]:
                self.offset_x -= settings.TILE_HALF_W * 2
                moved = True
                
            if keys[pygame.K_UP] or keys[pygame.K_w]:
                self.offset_y += settings.TILE_HALF_H * 2
                moved = True
            elif keys[pygame.K_DOWN] or keys[pygame.K_s]:
                self.offset_y -= settings.TILE_HALF_H * 2
                moved = True
                
            if moved:
               
                u_cam = self.offset_x + 2 * self.offset_y
                v_cam = self.offset_x - 2 * self.offset_y
                
                # Clamp strict dans le parallélogramme isométrique
                u_cam = max(-2080, min(u_cam, -544))
                v_cam = max(288, min(v_cam, 2080))
                
                self.offset_x = (u_cam + v_cam) / 2
                self.offset_y = (u_cam - v_cam) / 4
                
                self.move_timer = self.move_delay
