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

        dr, dc = 0, 0

        # Somme des directions pour autoriser les combinaisons (8 directions possibles).
        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            dr += 1
            dc -= 1
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            dr -= 1
            dc += 1
        if keys[pygame.K_UP] or keys[pygame.K_w]:
            dr -= 1
            dc -= 1
        if keys[pygame.K_DOWN] or keys[pygame.K_s]:
            dr += 1
            dc += 1

        # Normalise le déplacement à une case par tick, même avec deux touches.
        if dr > 0:
            dr = 1
        elif dr < 0:
            dr = -1

        if dc > 0:
            dc = 1
        elif dc < 0:
            dc = -1

        moved = (dr != 0 or dc != 0)
            
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
