import pygame


class Camera:
    def __init__(self):
        self.offset_x = 0.0
        self.offset_y = 0.0
        self.speed = 300  # pixels par seconde

    def update(self, dt):
        keys = pygame.key.get_pressed()
        move = self.speed * dt

        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            self.offset_x += move
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            self.offset_x -= move
        if keys[pygame.K_UP] or keys[pygame.K_w]:
            self.offset_y += move
        if keys[pygame.K_DOWN] or keys[pygame.K_s]:
            self.offset_y -= move
