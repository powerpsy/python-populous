import pygame
import settings

class Camera:
    def __init__(self):
        self.move_timer = 0.0
        # Position logique de la caméra en coordonnées de grille (r, c)
        # Correspond au coin supérieur de la zone 8x8 affichée
        self.r = float(settings.GRID_HEIGHT // 2 - 4)
        self.c = float(settings.GRID_WIDTH // 2 - 4)

    def move_direction(self, direction):
        # Déplace la caméra selon la direction
        directions = {
            'NE':  (-1.0, 0.0),
            'E': (-1.0, 1.0),
            'SE':  (0.0, 1.0),
            'S': (1.0, 1.0),
            'SW':  (1.0, 0.0),
            'W': (1.0, -1.0),
            'NW':  (0.0, -1.0),
            'N': (-1.0, -1.0),
        }
        if direction in directions:
            dr, dc = directions[direction]
            self.move(dr, dc)

    def move(self, dr, dc):
        self.r += float(dr)
        self.c += float(dc)
        # Limites strictes basées sur la grille
        max_r = float(settings.GRID_HEIGHT - 8)
        max_c = float(settings.GRID_WIDTH - 8)
        self.r = max(0.0, min(self.r, max_r))
        self.c = max(0.0, min(self.c, max_c))

    def update(self, dt):
        keys = pygame.key.get_pressed()
        self.move_timer -= dt
        if self.move_timer > 0:
            return

        # Mapping touches -> direction
        direction = None
        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            if keys[pygame.K_UP] or keys[pygame.K_w]:
                direction = 'NW'
            elif keys[pygame.K_DOWN] or keys[pygame.K_s]:
                direction = 'SW'
            else:
                direction = 'W'
        elif keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            if keys[pygame.K_UP] or keys[pygame.K_w]:
                direction = 'NE'
            elif keys[pygame.K_DOWN] or keys[pygame.K_s]:
                direction = 'SE'
            else:
                direction = 'E'
        elif keys[pygame.K_UP] or keys[pygame.K_w]:
            direction = 'N'
        elif keys[pygame.K_DOWN] or keys[pygame.K_s]:
            direction = 'S'

        if direction:
            self.move_direction(direction)
            self.move_timer = 0.15  # Délai entre deux déplacements (en secondes)
