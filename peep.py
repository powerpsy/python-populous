import pygame
import random
import math
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
        self.build_timer = 0.0  # Timer pour la construction

    def get_triangle_info(self, x, y):
        # Trouve la case (r, c) contenant (x, y)
        c = int(x)
        r = int(y)
        if not (0 <= r < self.game_map.grid_height and 0 <= c < self.game_map.grid_width):
            return None, None, None
        
        # Coordonnées locales dans la case
        fx = x - c
        fy = y - r
        
        # Retourne les infos de base
        return r, c, (fx, fy)

    def can_move_to(self, x, y):
        # Vérification simple des limites
        if x < 0 or x >= self.game_map.grid_width or y < 0 or y >= self.game_map.grid_height:
            return False
        return True

    def try_move(self, dt):
        if self.move_timer <= 0:
            # Nouveau mouvement
            speed = 0.5
            dx = math.cos(self.direction) * speed * dt
            dy = math.sin(self.direction) * speed * dt
            
            new_x = self.x + dx
            new_y = self.y + dy
            
            if self.can_move_to(new_x, new_y):
                self.x = new_x
                self.y = new_y
            else:
                # Change de direction si bloqué
                self.direction = random.uniform(0, 2 * math.pi)
            
            self.move_timer = 0.5  # Délai avant le prochain mouvement
        else:
            self.move_timer -= dt

    def update(self, dt):
        if self.dead:
            self.death_timer += dt
            return
        
        # Mouvement
        self.try_move(dt)
        
        # Changement de direction occasionnel
        self.dir_timer += dt
        if self.dir_timer > 2.0:
            self.direction = random.uniform(0, 2 * math.pi)
            self.dir_timer = 0.0
        
        # Timer de construction
        self.build_timer += dt

    def is_removable(self):
        return self.dead and self.death_timer > 2.0

    def draw(self, surface, offset_x, offset_y):
        if self.dead:
            return
        
        # Position écran du peep
        alt = self.get_interpolated_altitude(self.x, self.y)
        screen_x, screen_y = self.game_map.world_to_screen(
            self.y, self.x, alt, offset_x, offset_y
        )
        
        # Dessiner le peep (petit cercle)
        pygame.draw.circle(surface, PEEP_COLOR, (int(screen_x), int(screen_y)), 3)

    def get_interpolated_altitude(self, x, y):
        # Altitude interpolée simple
        r, c = int(y), int(x)
        if 0 <= r < self.game_map.grid_height and 0 <= c < self.game_map.grid_width:
            return self.game_map.get_corner_altitude(r, c)
        return 0

    def try_build_house(self):
        """Essaie de construire une maison si les conditions sont remplies"""
        # Ne peut construire que toutes les 5 secondes
        if self.build_timer < 5.0:
            return False
        
        # Position actuelle du peep
        current_r = int(self.y)
        current_c = int(self.x)
        
        # Vérifier si on est dans les limites
        if not (0 <= current_r < self.game_map.grid_height and 0 <= current_c < self.game_map.grid_width):
            return False
        
        # Vérifier si la case est plate (tous les coins à la même altitude)
        alt_tl = self.game_map.get_corner_altitude(current_r, current_c)
        alt_tr = self.game_map.get_corner_altitude(current_r, current_c + 1)
        alt_bl = self.game_map.get_corner_altitude(current_r + 1, current_c)
        alt_br = self.game_map.get_corner_altitude(current_r + 1, current_c + 1)
        
        # Vérifier que tous les coins sont à la même altitude (case plate)
        if not (alt_tl == alt_tr == alt_bl == alt_br):
            return False
        
        # Vérifier qu'il n'y a pas déjà une maison ici
        for house in self.game_map.houses:
            if house.r == current_r and house.c == current_c:
                return False
        
        # Vérifier que c'est au niveau de la terre (pas dans l'eau)
        if alt_tl < LAND_LEVEL_MIN:
            return False
        
        # Construire la maison
        from game_map import House
        new_house = House(current_r, current_c)
        self.game_map.houses.append(new_house)
        
        # Reset du timer
        self.build_timer = 0.0
        
        print(f"Peep a construit une maison en ({current_r}, {current_c})")
        return True