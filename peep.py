import pygame
import numpy as np
import random
import math
from settings import *

SPRITE_EXTRACT_SIZE = 16  # Taille dans le spritesheet source


def load_sprite_surfaces():
    """Charge le sprite sheet, découpe les sprites 16x16 et les redimensionne en 32x32.

    Détecte les cadres noirs (1px) entourant chaque sprite.
    Fond gris (102,102,102) entre les cadres, fond vert foncé (0,51,0) à l'intérieur.
    """
    from PIL import Image as PILImage

    img = PILImage.open(SPRITES_PATH).convert("RGBA")
    data = np.array(img)
    h, w = data.shape[:2]

    # Trouver les rangées de frames via la colonne x=1 (bordure gauche)
    frame_rows = []
    in_black = False
    y_start = 0
    for y in range(h):
        is_blk = data[y, 1, 0] < 10 and data[y, 1, 1] < 10 and data[y, 1, 2] < 10
        if is_blk and not in_black:
            y_start = y
            in_black = True
        elif not is_blk and in_black:
            frame_rows.append((y_start, y - 1))
            in_black = False
    if in_black:
        frame_rows.append((y_start, h - 1))

    sheet = pygame.image.load(SPRITES_PATH).convert_alpha()
    sprites = {}
    for fr_idx, (y_top, y_bot) in enumerate(frame_rows):
        content_y0 = y_top + 1
        content_h = min(y_bot - 1 - content_y0 + 1, SPRITE_EXTRACT_SIZE)

        # Colonnes entièrement noires dans cette rangée = bordures verticales
        full_black_cols = []
        for x in range(w):
            region = data[y_top:y_bot + 1, x, :3]
            if np.all(region < 10):
                full_black_cols.append(x)

        if not full_black_cols:
            continue
        groups = [[full_black_cols[0]]]
        for c in full_black_cols[1:]:
            if c == groups[-1][-1] + 1:
                groups[-1].append(c)
            else:
                groups.append([c])
        col_groups = [(g[0], g[-1]) for g in groups]

        col_idx = 0
        for i in range(len(col_groups) - 1):
            cx_start = col_groups[i][-1] + 1
            cx_end = col_groups[i + 1][0] - 1
            cw = cx_end - cx_start + 1
            if cw < 3:
                continue

            # Centrer si > 16px
            if cw > SPRITE_EXTRACT_SIZE:
                offset = (cw - SPRITE_EXTRACT_SIZE) // 2
                cx_start += offset
                cw = SPRITE_EXTRACT_SIZE

            sw = min(cw, SPRITE_EXTRACT_SIZE)
            sh = min(content_h, SPRITE_EXTRACT_SIZE)
            sub = sheet.subsurface(pygame.Rect(cx_start, content_y0, sw, sh)).copy()

            # Padder à 16x16 si nécessaire
            if sw < SPRITE_EXTRACT_SIZE or sh < SPRITE_EXTRACT_SIZE:
                padded = pygame.Surface((SPRITE_EXTRACT_SIZE, SPRITE_EXTRACT_SIZE), pygame.SRCALPHA)
                padded.blit(sub, (0, 0))
                sub = padded

            # Supprimer le fond vert foncé (0,51,0) et noir → transparent
            arr = pygame.surfarray.pixels3d(sub)   # (w, h, 3)
            alpha = pygame.surfarray.pixels_alpha(sub)  # (w, h)
            mask = (
                ((arr[:, :, 0] < 20) & (arr[:, :, 1] < 70) & (arr[:, :, 2] < 20)) |
                ((arr[:, :, 0] == 0) & (arr[:, :, 1] == 0) & (arr[:, :, 2] == 0))
            )
            alpha[mask] = 0
            del arr, alpha  # libérer les locks surfarray

            # Redimensionner 16→32 (nearest neighbor pour pixel art net)
            sub = pygame.transform.scale(sub, (SPRITE_SIZE, SPRITE_SIZE))

            sprites[(fr_idx, col_idx)] = sub
            col_idx += 1

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
    'SE': [(0, 0), (0, 1)],
    'SW': [(0, 2), (0, 3)],
    'NW': [(0, 4), (0, 5)],
    'NE': [(0, 6), (0, 7)],
}


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
        self.facing = 'SE'

    def update(self, dt):
        if self.dead:
            self.death_timer += dt
            return

        self.anim_timer += dt
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
        gr, gc = int(new_y), int(new_x)
        if 0 <= gr < self.game_map.grid_height and 0 <= gc < self.game_map.grid_width:
            alt = self.game_map.get_corner_altitude(gr, gc)
            if alt > 0:
                self.x = new_x
                self.y = new_y

        # Mettre à jour la direction visuelle
        if abs(dx) > abs(dy):
            if dx > 0:
                self.facing = 'SE' if dy > 0 else 'NE'
            else:
                self.facing = 'SW' if dy > 0 else 'NW'
        else:
            if dy > 0:
                self.facing = 'SE' if dx > 0 else 'SW'
            else:
                self.facing = 'NE' if dx > 0 else 'NW'

        # Construction
        self.build_timer += dt

    def try_build_house(self):
        if self.build_timer < 5.0:
            return
        self.build_timer = 0.0
        gr, gc = int(self.y), int(self.x)
        if self.game_map.is_flat_and_buildable(gr, gc):
            from house import House
            house = House(gr, gc)
            self.game_map.add_house(house)

    def draw(self, surface, cam_x=0, cam_y=0):
        gr, gc = int(self.y), int(self.x)
        if 0 <= gr < self.game_map.grid_height and 0 <= gc < self.game_map.grid_width:
            alt = self.game_map.get_corner_altitude(gr, gc)
        else:
            alt = 0

        sx, sy = self.game_map.world_to_screen(self.y, self.x, alt, cam_x, cam_y)

        sprites = self.get_sprites()
        frames = WALK_FRAMES.get(self.facing, WALK_FRAMES['SE'])
        frame_key = frames[self.anim_frame % len(frames)]
        sprite = sprites.get(frame_key)

        if sprite is not None:
            # Centrer le sprite sur la position
            sw, sh = sprite.get_size()
            blit_x = sx - sw // 2
            blit_y = sy - sh
            if self.dead:
                # Teinter en rouge pour les morts
                tinted = sprite.copy()
                tinted.fill((255, 0, 0, 100), special_flags=pygame.BLEND_RGBA_MULT)
                surface.blit(tinted, (blit_x, blit_y))
            else:
                surface.blit(sprite, (blit_x, blit_y))
        else:
            # Fallback : petit cercle
            pygame.draw.circle(surface, (255, 220, 120), (sx, sy), 3)

    def is_removable(self):
        return self.dead and self.death_timer > 3.0
