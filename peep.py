import pygame
import math
import random
from settings import *
from game_map import darken_color

class Peep:
    def __init__(self, grid_r, grid_c, game_map):
        self.x = grid_c + 0.5
        self.y = grid_r + 0.5
        self.game_map = game_map
        self.life = 50
        self.dead = False
        self.death_timer = 0.0
        self.move_timer = 0.0
        self.dir_timer = 0.0
        self.direction = random.uniform(0, 2 * math.pi)

    def get_triangle_info(self, x, y):
        # Trouve la case (r, c) contenant (x, y)
        c = int(x)
        r = int(y)
        if not (0 <= r < self.game_map.grid_height and 0 <= c < self.game_map.grid_width):
            return None
        # Coordonnées locales dans la case
        fx = x - c
        fy = y - r
        # Sommets de la case
        altA = self.game_map.get_corner_altitude(r, c)
        altB = self.game_map.get_corner_altitude(r, c + 1)
        altC = self.game_map.get_corner_altitude(r + 1, c + 1)
        altD = self.game_map.get_corner_altitude(r + 1, c)
        # Détermine le triangle (ABC ou ACD)
        if fx + fy <= 1:
            # Triangle ABC
            triangle = (altA, altB, altC)
        else:
            # Triangle ACD
            triangle = (altA, altC, altD)
        return triangle

    def can_move_to(self, x, y):
        triangle = self.get_triangle_info(x, y)
        if triangle is None:
            return False
        # Refuse si le triangle est 000
        return not (triangle[0] == 0 and triangle[1] == 0 and triangle[2] == 0)

    def try_move(self, dt):
        # Essaye de bouger dans la direction actuelle
        speed = 1.5  # pixels/sec
        dx = math.cos(self.direction) * speed * dt
        dy = math.sin(self.direction) * speed * dt
        new_x = self.x + dx
        new_y = self.y + dy
        if self.can_move_to(new_x, new_y):
            self.x = new_x
            self.y = new_y
            return True
        return False

    def update(self, dt):
        if not self.dead:
            self.life -= dt
            if self.life <= 0:
                self.life = 0
                self.dead = True
                self.death_timer = 0.0
            else:
                self.dir_timer += dt
                moved = self.try_move(dt)
                if self.dir_timer > 1.0:
                    self.dir_timer = 0.0
                    if random.random() < 0.5 or not moved:
                        # 50% de chance de changer de direction, ou obligé si bloqué
                        self.direction = random.uniform(0, 2 * math.pi)
        else:
            self.death_timer += dt

    def is_removable(self):
        return self.dead and self.death_timer > 1.0

    def draw(self, surface, offset_x, offset_y):
        z = self.get_interpolated_altitude(self.x, self.y)
        px, py = self.game_map.world_to_screen(self.y, self.x, z, offset_x, offset_y)
        color = (0, 0, 0) if self.dead else (255, 255, 255)
        pygame.draw.circle(surface, color, (int(px), int(py)), 4)
        if not self.dead:
            bar_width = 16
            bar_height = 3
            life_ratio = max(0, self.life / 50)
            pygame.draw.rect(surface, (255, 0, 0), (px - bar_width//2, py - 10, bar_width, bar_height))
            pygame.draw.rect(surface, (0, 255, 0), (px - bar_width//2, py - 10, int(bar_width * life_ratio), bar_height))

    def get_interpolated_altitude(self, x, y):
        c = int(x)
        r = int(y)
        fx = x - c
        fy = y - r
        altA = self.game_map.get_corner_altitude(r, c)
        altB = self.game_map.get_corner_altitude(r, c + 1)
        altC = self.game_map.get_corner_altitude(r + 1, c + 1)
        altD = self.game_map.get_corner_altitude(r + 1, c)
        if fx + fy <= 1:
            # Triangle ABC
            wA = 1 - fx - fy
            wB = fx
            wC = fy
            return wA * altA + wB * altB + wC * altC
        else:
            # Triangle ACD
            wA = 1 - (1 - fx) - (1 - fy)
            wC = 1 - fx
            wD = 1 - fy
            return wA * altA + wC * altC + wD * altD

    def try_build_house(self):
        r, c = int(self.y), int(self.x)
        if self.game_map.is_flat_and_buildable(r, c):
            self.game_map.add_house(r, c, self.life)
            self.life = 0
            self.dead = True
            self.death_timer = 9999  # Pour suppression immédiate
            return True
        return False