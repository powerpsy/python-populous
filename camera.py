import pygame
from settings import *

class Camera:
    def __init__(self, map_pixel_width, map_pixel_height):
        self.offset_x = 0
        self.offset_y = 0
        self.speed = 300 # pixels par seconde

    def update(self, dt):
        keys = pygame.key.get_pressed()
        move_dist = self.speed * dt

        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            self.offset_x += move_dist
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            self.offset_x -= move_dist
        if keys[pygame.K_UP] or keys[pygame.K_w]:
            self.offset_y += move_dist
        if keys[pygame.K_DOWN] or keys[pygame.K_s]:
            self.offset_y -= move_dist