import pygame
import settings

class Camera:
    def __init__(self):
        self.move_timer = 0.0
        
        # Position logique de la caméra en coordonnées de grille (r, c)
        # Correspond au coin supérieur de la zone 8x8 affichée
        self.r = float(settings.GRID_HEIGHT // 2 - 4)
        self.c = float(settings.GRID_WIDTH // 2 - 4)

    def update(self, dt):
        keys = pygame.key.get_pressed()
        
        self.move_timer -= dt
        if self.move_timer > 0:
            return

        moved = False
        dr, dc = 0, 0
        
        # Mouvement strictement par case entière
        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            dr, dc = 1, -1
            moved = True
        elif keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            dr, dc = -1, 1
            moved = True
        elif keys[pygame.K_UP] or keys[pygame.K_w]:
            dr, dc = -1, -1
            moved = True
        elif keys[pygame.K_DOWN] or keys[pygame.K_s]:
            dr, dc = 1, 1
            moved = True
            
        if moved:
            self.r += float(dr)
            self.c += float(dc)
            
            # Limites strictes basées sur la grille
            # La zone affichée fait 8x8 tuiles, on bloque pour ne jamais voir hors-carte
            max_r = float(settings.GRID_HEIGHT - 8)
            max_c = float(settings.GRID_WIDTH - 8)
            
            self.r = max(0.0, min(self.r, max_r))
            self.c = max(0.0, min(self.c, max_c))
            
            self.move_timer = 0.15  # Délai entre deux déplacements (en secondes)
