import pygame
import random
from settings import *


def load_tile_surfaces():
    """Charge le tileset et découpe chaque tile en surface pygame."""
    sheet = pygame.image.load(TILES_PATH).convert_alpha()

    x_starts = [0] + [e + 1 for _, e in TILES_V_LINES]
    x_ends = [s for s, _ in TILES_V_LINES] + [sheet.get_width()]
    y_starts = [0] + [e + 1 for _, e in TILES_H_LINES]
    y_ends = [s for s, _ in TILES_H_LINES] + [sheet.get_height()]

    ref_w = x_ends[0] - x_starts[0]
    ref_h = y_ends[0] - y_starts[0]

    tiles = {}
    for row in range(len(y_starts)):
        for col in range(len(x_starts)):
            x0, x1 = x_starts[col], x_ends[col]
            y0, y1 = y_starts[row], y_ends[row]
            tw, th = x1 - x0, y1 - y0
            if tw < 5 or th < 5:
                continue
            sub = sheet.subsurface(pygame.Rect(x0, y0, tw, th)).copy()
            if tw < ref_w or th < ref_h:
                padded = pygame.Surface((ref_w, ref_h), pygame.SRCALPHA)
                padded.blit(sub, (0, 0))
                sub = padded
            tiles[(row, col)] = sub
    return tiles


class GameMap:
    def __init__(self, grid_width, grid_height):
        self.grid_width = grid_width
        self.grid_height = grid_height
        self.corners = [
            [0 for _ in range(grid_width + 1)]
            for _ in range(grid_height + 1)
        ]
        self.houses = []
        self.tile_surfaces = load_tile_surfaces()
        self.water_timer = 0.0
        self.water_frame = 0

    def get_corner_altitude(self, r, c):
        if 0 <= r <= self.grid_height and 0 <= c <= self.grid_width:
            return self.corners[r][c]
        return -1

    def set_corner_altitude(self, r, c, value):
        if 0 <= r <= self.grid_height and 0 <= c <= self.grid_width:
            clamped = max(ALTITUDE_MIN, min(value, ALTITUDE_MAX))
            if self.corners[r][c] != clamped:
                self.corners[r][c] = clamped
                return True
        return False

    def world_to_screen(self, r, c, altitude, cam_x=0, cam_y=0):
        sx = MAP_OFFSET_X + (c - r) * TILE_HALF_W + cam_x
        sy = MAP_OFFSET_Y + (c + r) * TILE_HALF_H - altitude * ALTITUDE_PIXEL_STEP + cam_y
        return int(sx), int(sy)

    def screen_to_nearest_corner(self, sx, sy, cam_x=0, cam_y=0):
        best_r, best_c = 0, 0
        min_dist = float("inf")
        for r in range(self.grid_height + 1):
            for c in range(self.grid_width + 1):
                alt = self.get_corner_altitude(r, c)
                px, py = self.world_to_screen(r, c, alt, cam_x, cam_y)
                d = (sx - px) ** 2 + (sy - py) ** 2
                if d < min_dist:
                    min_dist = d
                    best_r, best_c = r, c
        return best_r, best_c

    def propagate_raise(self, r, c, visited=None):
        if visited is None:
            visited = set()
        if (r, c) in visited:
            return
        visited.add((r, c))
        current = self.get_corner_altitude(r, c)
        new_alt = current + 1
        if not self.set_corner_altitude(r, c, new_alt):
            return
        for dr in [-1, 0, 1]:
            for dc in [-1, 0, 1]:
                if dr == 0 and dc == 0:
                    continue
                nr, nc = r + dr, c + dc
                if 0 <= nr <= self.grid_height and 0 <= nc <= self.grid_width:
                    if new_alt - self.get_corner_altitude(nr, nc) > 1:
                        self.propagate_raise(nr, nc, visited)

    def propagate_lower(self, r, c, visited=None):
        if visited is None:
            visited = set()
        if (r, c) in visited:
            return
        visited.add((r, c))
        current = self.get_corner_altitude(r, c)
        new_alt = current - 1
        if not self.set_corner_altitude(r, c, new_alt):
            return
        for dr in [-1, 0, 1]:
            for dc in [-1, 0, 1]:
                if dr == 0 and dc == 0:
                    continue
                nr, nc = r + dr, c + dc
                if 0 <= nr <= self.grid_height and 0 <= nc <= self.grid_width:
                    if self.get_corner_altitude(nr, nc) - new_alt > 1:
                        self.propagate_lower(nr, nc, visited)

    def raise_corner(self, r, c):
        self.propagate_raise(r, c)

    def lower_corner(self, r, c):
        self.propagate_lower(r, c)

    def update(self, dt):
        """Met à jour les animations (eau)."""
        self.water_timer += dt
        if self.water_timer >= 0.5:
            self.water_timer -= 0.5
            self.water_frame = 1 - self.water_frame

    def get_tile_key(self, r, c):
        a0 = self.get_corner_altitude(r, c)
        a1 = self.get_corner_altitude(r, c + 1)
        a2 = self.get_corner_altitude(r + 1, c + 1)
        a3 = self.get_corner_altitude(r + 1, c)
        min_alt = min(a0, a1, a2, a3)

        if a0 == a1 == a2 == a3 == 0:
            return TILE_WATER if self.water_frame == 0 else TILE_WATER_2

        d = (
            min(1, a0 - min_alt),
            min(1, a1 - min_alt),
            min(1, a2 - min_alt),
            min(1, a3 - min_alt),
        )

        if min_alt == 0:
            tile_map = SLOPE_TILES_LOW
        else:
            tile_map = SLOPE_TILES

        return tile_map.get(d, TILE_FLAT)

    def draw_tile(self, surface, r, c, cam_x=0, cam_y=0):
        a0 = self.get_corner_altitude(r, c)
        a1 = self.get_corner_altitude(r, c + 1)
        a2 = self.get_corner_altitude(r + 1, c + 1)
        a3 = self.get_corner_altitude(r + 1, c)
        min_alt = min(a0, a1, a2, a3)

        tile_key = self.get_tile_key(r, c)
        tile_surf = self.tile_surfaces.get(tile_key)
        if tile_surf is None:
            return

        # Le point world_to_screen(r, c, alt) donne le coin NW (sommet haut du losange)
        # Le tile doit être positionné pour que le sommet haut du losange soit centré horizontalement
        sx, sy = self.world_to_screen(r, c, min_alt, cam_x, cam_y)
        blit_x = sx - TILE_HALF_W
        blit_y = sy
        surface.blit(tile_surf, (blit_x, blit_y))

    def draw(self, surface, cam_x=0, cam_y=0):
        for r in range(self.grid_height):
            for c in range(self.grid_width):
                self.draw_tile(surface, r, c, cam_x, cam_y)

    def draw_houses(self, surface, cam_x=0, cam_y=0):
        for house in self.houses:
            alt = self.get_corner_altitude(house.r, house.c)
            tile_key = BUILDING_TILES.get(house.building_type, BUILDING_TILES["hut"])
            tile_surf = self.tile_surfaces.get(tile_key)
            if tile_surf is None:
                continue
            sx, sy = self.world_to_screen(house.r, house.c, alt, cam_x, cam_y)
            blit_x = sx - TILE_HALF_W
            blit_y = sy - TILE_HALF_H
            surface.blit(tile_surf, (blit_x, blit_y))

    def randomize(self, min_level=0, max_level=7):
        self.corners[0][0] = random.randint(min_level, max_level)
        for c in range(1, self.grid_width + 1):
            prev = self.corners[0][c - 1]
            self.corners[0][c] = max(min_level, min(max_level, prev + random.choice([-1, 0, 1])))
        for r in range(1, self.grid_height + 1):
            prev = self.corners[r - 1][0]
            self.corners[r][0] = max(min_level, min(max_level, prev + random.choice([-1, 0, 1])))
            for c in range(1, self.grid_width + 1):
                left = self.corners[r][c - 1]
                up = self.corners[r - 1][c]
                base = (left + up) // 2
                self.corners[r][c] = max(min_level, min(max_level, base + random.choice([-1, 0, 1])))

    def is_flat_and_buildable(self, r, c):
        if r < 0 or c < 0 or r >= self.grid_height or c >= self.grid_width:
            return False
        a = self.get_corner_altitude(r, c)
        b = self.get_corner_altitude(r, c + 1)
        c_ = self.get_corner_altitude(r + 1, c + 1)
        d = self.get_corner_altitude(r + 1, c)
        if a == b == c_ == d and a > 0:
            return not any(h.r == r and h.c == c for h in self.houses)
        return False

    def add_house(self, house):
        self.houses.append(house)

