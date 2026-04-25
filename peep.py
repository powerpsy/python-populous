import pygame
import numpy as np
import random
import math
from settings import *

SPRITE_EXTRACT_SIZE = 16  # Taille dans le spritesheet source


def load_sprite_surfaces():
    """Charge le sprite sheet et découpe les sprites 16x16 selon un format fixe (AmigaSprites)."""
    sheet_raw = pygame.image.load(SPRITES_PATH).convert()
    
    # Fond vert transparent Amiga
    sheet_raw.set_colorkey((0, 49, 0))
    sheet = sheet_raw.convert_alpha()

    start_x, start_y = 11, 10
    stride_x, stride_y = 20, 20
    
    x_starts = [start_x + i * stride_x for i in range(16)]
    y_starts = [start_y + j * stride_y for j in range(9)]
    
    sprites = {}
    for r, y0 in enumerate(y_starts):
        for c, x0 in enumerate(x_starts):
            try:
                sub = sheet.subsurface(pygame.Rect(x0, y0, SPRITE_EXTRACT_SIZE, SPRITE_EXTRACT_SIZE)).copy()
            except ValueError:
                continue

            # Supprimer le fond noir résiduel → transparent
            arr = pygame.surfarray.pixels3d(sub)
            alpha = pygame.surfarray.pixels_alpha(sub)
            mask = ((arr[:, :, 0] == 0) & (arr[:, :, 1] == 0) & (arr[:, :, 2] == 0))
            alpha[mask] = 0
            del arr, alpha  # libérer les locks surfarray

            sub = pygame.transform.scale(sub, (SPRITE_SIZE, SPRITE_SIZE))

            sprites[(r, c)] = sub

    return sprites


# Sprite sheet organisation (approximate from visual):
# Blue team faces different directions, row 0-1 walking,
# Red team faces different directions, row 2-3 walking,
# Row 4: fighting/special animations
# Row 5-7: more animations, items, effects
# Row 8: UI elements


# Directions en isométrique: 0=SE, 1=S, 2=SW, 3=W, 4=NW, 5=N, 6=NE, 7=E
# Simplified: we use row 0 columns for walk animation in a direction
WALK_FRAMES = {
    'N':      [(0,  0), (0,  1)],
    'NE':     [(0,  2), (0,  3)],
    'E':      [(0,  4), (0,  5)],
    'SE':     [(0,  6), (0,  7)],
    'S':      [(0,  8), (0,  9)],
    'SW':     [(0, 10), (0, 11)],
    'W':      [(0, 12), (0, 13)],
    'NW':     [(0, 14), (0, 15)],
    'IDLE':   [(0,  8), (0,  9)],
    'DROWN':  [(5,  8), (5,  9), (5, 10), (5, 11)],
}

# Export pour usage externe
PEEP_WALK_FRAMES = WALK_FRAMES


class Peep:
    _sprites = None

    @classmethod
    def get_sprites(cls):
        if cls._sprites is None:
            cls._sprites = load_sprite_surfaces()
        return cls._sprites

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
        self.build_timer = 0.0
        self.anim_timer = 0.0
        self.anim_frame = 0
        self.facing = 'IDLE'
        self.is_moving = False
        self.energy_yellow = 0   # barres jaunes restantes
        self.energy_orange = 1.0  # fraction de la barre orange courante (0→1)
        self.in_house = False
        self.weapon_type = 'hut' # Arme de départ : arme 0 (hut)

    def update(self, dt):
        if self.dead:
            self.death_timer += dt
            return

        # Perte de vie : 1 point par seconde
        self.life -= dt * 1.0
        if self.life <= 0:
            self.life = 0
            self.dead = True
            return

        self.anim_timer += dt

        # Détecter si le peep est sur une tile eau (les 4 coins de la tile à 0)
        gr_cur, gc_cur = int(self.y), int(self.x)
        if (0 <= gr_cur < self.game_map.grid_height and 0 <= gc_cur < self.game_map.grid_width):
            a0 = self.game_map.get_corner_altitude(gr_cur,     gc_cur)
            a1 = self.game_map.get_corner_altitude(gr_cur,     gc_cur + 1)
            a2 = self.game_map.get_corner_altitude(gr_cur + 1, gc_cur + 1)
            a3 = self.game_map.get_corner_altitude(gr_cur + 1, gc_cur)
            on_water = (a0 == 0 and a1 == 0 and a2 == 0 and a3 == 0)
        else:
            on_water = False

        # Animation :
        if on_water:
            # Animation loop simple sur 4 frames (5,8 à 5,11)
            if not hasattr(self, '_drown_anim_idx'):
                self._drown_anim_idx = 0
            if self.anim_timer > 0.18:
                self.anim_timer -= 0.18
                self._drown_anim_idx = (self._drown_anim_idx + 1) % 4
            self.anim_frame = self._drown_anim_idx
        else:
            if self.anim_timer > 0.3:
                self.anim_timer -= 0.3
                self.anim_frame = (self.anim_frame + 1) % 2

        # Change de direction de temps en temps
        self.dir_timer += dt
        if self.dir_timer > 2.0 + random.random() * 3.0:
            self.dir_timer = 0.0
            self.direction = random.uniform(0, 2 * math.pi)

        # Déplacement
        speed = PEEP_SPEED * dt / 64.0  # Normaliser par rapport à la taille du tile
        dx = math.cos(self.direction) * speed
        dy = math.sin(self.direction) * speed

        new_x = self.x + dx
        new_y = self.y + dy

        # Rester dans les limites
        new_x = max(0.1, min(self.game_map.grid_width - 0.1, new_x))
        new_y = max(0.1, min(self.game_map.grid_height - 0.1, new_y))

        # Vérifier que la destination n'est pas de l'eau
        old_x, old_y = self.x, self.y
        gr, gc = int(new_y), int(new_x)
        if 0 <= gr < self.game_map.grid_height and 0 <= gc < self.game_map.grid_width:
            alt = self.game_map.get_corner_altitude(gr, gc)
            if alt > 0:
                self.x = new_x
                self.y = new_y

        self.is_moving = (self.x != old_x or self.y != old_y)

        # Détecter si le peep est sur une tile eau (les 4 coins de la tile à 0)
        gr_cur, gc_cur = int(self.y), int(self.x)
        if (0 <= gr_cur < self.game_map.grid_height and 0 <= gc_cur < self.game_map.grid_width):
            a0 = self.game_map.get_corner_altitude(gr_cur,     gc_cur)
            a1 = self.game_map.get_corner_altitude(gr_cur,     gc_cur + 1)
            a2 = self.game_map.get_corner_altitude(gr_cur + 1, gc_cur + 1)
            a3 = self.game_map.get_corner_altitude(gr_cur + 1, gc_cur)
            on_water = (a0 == 0 and a1 == 0 and a2 == 0 and a3 == 0)
        else:
            on_water = False

        # Mettre à jour la direction visuelle (8 directions)
        if on_water:
            self.facing = 'DROWN'
        elif self.is_moving:
            # Projeter le déplacement grille vers l'espace écran isométrique
            # world_to_screen: sx = (c-r)*TILE_HALF_W, sy = (c+r)*TILE_HALF_H
            # dx = déplacement en c, dy = déplacement en r
            screen_dx = (dx - dy) * TILE_HALF_W
            screen_dy = (dx + dy) * TILE_HALF_H
            angle = math.degrees(math.atan2(screen_dy, screen_dx)) % 360
            dirs = ['E', 'SE', 'S', 'SW', 'W', 'NW', 'N', 'NE']
            self.facing = dirs[int((angle + 22.5) / 45) % 8]
        else:
            self.facing = 'IDLE'

        # Construction
        self.build_timer += dt

    def try_build_house(self):
        if self.build_timer < 5.0:
            return None

        gr, gc = int(self.y), int(self.x)
        if self.game_map.can_place_house_initial(gr, gc):
            self.build_timer = 0.0
            from house import House
            # On détermine la vie max du bâtiment
            from house import House
            max_life = House.MAX_HEALTHS[0]  # hut par défaut
            # On estime le type de bâtiment selon le terrain
            score, valid_tiles = self.game_map.get_flat_area_score(gr, gc, current_house=None)
            thresholds = [0, 1, 2, 5, 8, 11, 14, 19, 22, 24]
            max_tier = 0
            for i, thresh in enumerate(thresholds):
                if score >= thresh:
                    max_tier = i
            max_tier = min(len(House.TYPES) - 1, max_tier)
            max_life = House.MAX_HEALTHS[max_tier]

            # Si le peep a plus de vie que la vie max du bâtiment, on génère un peep avec l'excédent
            excess_life = self.life - max_life
            house = House(gr, gc, life=min(self.life, max_life))
            self.game_map.add_house(house)
            self.in_house = True
            self.life = 0
            self.dead = True

            if excess_life > 0:
                # Cherche une case adjacente libre pour le peep excédentaire
                offsets = [(-1,0),(1,0),(0,-1),(0,1),(-1,-1),(-1,1),(1,-1),(1,1)]
                for dr, dc in offsets:
                    nr, nc = gr + dr, gc + dc
                    if 0 <= nr < self.game_map.grid_height and 0 <= nc < self.game_map.grid_width:
                        # On vérifie que la case n'est pas de l'eau et pas déjà occupée par une maison
                        alt = self.game_map.get_corner_altitude(nr, nc)
                        occupied = any((nr, nc) in getattr(h, 'occupied_tiles', []) for h in self.game_map.houses)
                        if alt > 0 and not occupied:
                            from peep import Peep
                            new_peep = Peep(nr, nc, self.game_map)
                            new_peep.life = excess_life
                            self.game_map._pending_peep = getattr(self.game_map, '_pending_peep', [])
                            self.game_map._pending_peep.append(new_peep)
                            break
            return house
        return None

    def draw(self, surface, cam_x=0, cam_y=0, show_debug=False, debug_font=None):
        gr, gc = int(self.y), int(self.x)
        fx = self.x - gc  # fraction horizontale dans la tile
        fy = self.y - gr  # fraction verticale dans la tile

        # Interpolation bilinéaire de l'altitude selon la position dans la tile
        if (0 <= gr < self.game_map.grid_height and 0 <= gc < self.game_map.grid_width):
            a_nw = self.game_map.get_corner_altitude(gr,     gc)
            a_ne = self.game_map.get_corner_altitude(gr,     gc + 1)
            a_sw = self.game_map.get_corner_altitude(gr + 1, gc)
            a_se = self.game_map.get_corner_altitude(gr + 1, gc + 1)
            alt = (1 - fx) * (1 - fy) * a_nw + fx * (1 - fy) * a_ne \
                + (1 - fx) * fy       * a_sw + fx * fy       * a_se
        else:
            alt = 0

        sx, sy = self.game_map.world_to_screen(self.y, self.x, alt, cam_x, cam_y)
        # Sol visuel : la coordonnée sy intègre déjà l'altitude (alt * 8)
        ground_y = sy + TILE_HALF_H

        sprites = self.get_sprites()
        frames = WALK_FRAMES.get(self.facing, WALK_FRAMES['IDLE'])
        if self.facing == 'DROWN':
            # Animation pingpong sur 4 frames
            anim_len = 4
            # self.anim_frame est déjà l'indice pingpong (0,1,2,3,2,1...)
            frame_key = (5, 8 + self.anim_frame)
        else:
            anim_len = len(frames)
            frame_key = frames[self.anim_frame % anim_len]
        sprite = sprites.get(frame_key)

        if sprite is not None:
            # Centrer le sprite sur la position
            sw, sh = sprite.get_size()
            blit_x = sx - sw // 2
            blit_y = ground_y - sh
            if self.dead:
                # Teinter en rouge pour les morts
                tinted = sprite.copy()
                tinted.fill((255, 0, 0, 100), special_flags=pygame.BLEND_RGBA_MULT)
                surface.blit(tinted, (blit_x, blit_y))
            else:
                surface.blit(sprite, (blit_x, blit_y))
            # Affichage debug de la vie
            if show_debug and debug_font is not None:
                life_text = debug_font.render(f"{int(self.life)}", True, (255,255,0) if not self.dead else (255,0,0))
                text_x = sx - life_text.get_width() // 2
                text_y = blit_y - 16
                surface.blit(life_text, (text_x, text_y))
        else:
            # Fallback : petit cercle
            pygame.draw.circle(surface, (255, 220, 120), (sx, ground_y), 3)
            if show_debug and debug_font is not None:
                life_text = debug_font.render(f"{int(self.life)}", True, (255,255,0))
                text_x = sx - life_text.get_width() // 2
                text_y = ground_y - 24
                surface.blit(life_text, (text_x, text_y))

    def is_removable(self):
        if self.in_house:
            return True
        return self.dead and self.death_timer > 3.0