import pygame
import random
from settings import *

def darken_color(color, factor):
    return tuple(
        max(0, min(255, int(round(c * factor))))
        for c in color
    )

class GameMap:
    def __init__(self, grid_width, grid_height):
        self.grid_width = grid_width
        self.grid_height = grid_height
        self.corners = [
            [LAND_LEVEL_MIN for _ in range(grid_width + 1)]
            for _ in range(grid_height + 1)
        ]
        self.houses = []

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

    def world_to_screen(self, r, c, altitude, camera_offset_x=0, camera_offset_y=0):
        screen_x = MAP_OFFSET_X + (c - r) * TILE_ISO_WIDTH_HALF + camera_offset_x
        screen_y = MAP_OFFSET_Y + (c + r) * TILE_ISO_HEIGHT_HALF - altitude * ALTITUDE_PIXEL_STEP + camera_offset_y
        return int(screen_x), int(screen_y)

    def screen_to_nearest_corner(self, screen_x, screen_y, camera_offset_x=0, camera_offset_y=0):
        min_dist_sq = float('inf')
        best_r, best_c = -1, -1
        for r in range(self.grid_height + 1):
            for c in range(self.grid_width + 1):
                alt = self.get_corner_altitude(r, c)
                sx, sy = self.world_to_screen(r, c, alt, camera_offset_x, camera_offset_y)
                dist_sq = (screen_x - sx) ** 2 + (screen_y - sy) ** 2
                if dist_sq < min_dist_sq:
                    min_dist_sq = dist_sq
                    best_r, best_c = r, c
        return best_r, best_c

    def can_set_corner_altitude(self, r, c, new_alt):
        """Vérifie que tous les voisins immédiats resteront à une différence de hauteur <= 1."""
        for dr in [-1, 0, 1]:
            for dc in [-1, 0, 1]:
                if dr == 0 and dc == 0:
                    continue
                nr, nc = r + dr, c + dc
                if 0 <= nr <= self.grid_height and 0 <= nc <= self.grid_width:
                    neighbor_alt = self.get_corner_altitude(nr, nc)
                    if abs(new_alt - neighbor_alt) > 1:
                        return False
        return True

    def propagate_raise(self, r, c, visited=None):
        if visited is None:
            visited = set()
        if (r, c) in visited:
            return
        visited.add((r, c))
        current = self.get_corner_altitude(r, c)
        new_alt = current + 1
        changed = self.set_corner_altitude(r, c, new_alt)
        if not changed:
            return
        for dr in [-1, 0, 1]:
            for dc in [-1, 0, 1]:
                if dr == 0 and dc == 0:
                    continue
                nr, nc = r + dr, c + dc
                if 0 <= nr <= self.grid_height and 0 <= nc <= self.grid_width:
                    neighbor_alt = self.get_corner_altitude(nr, nc)
                    if new_alt - neighbor_alt > 1:
                        self.propagate_raise(nr, nc, visited)

    def propagate_lower(self, r, c, visited=None):
        if visited is None:
            visited = set()
        if (r, c) in visited:
            return
        visited.add((r, c))
        current = self.get_corner_altitude(r, c)
        new_alt = current - 1
        changed = self.set_corner_altitude(r, c, new_alt)
        if not changed:
            return
        for dr in [-1, 0, 1]:
            for dc in [-1, 0, 1]:
                if dr == 0 and dc == 0:
                    continue
                nr, nc = r + dr, c + dc
                if 0 <= nr <= self.grid_height and 0 <= nc <= self.grid_width:
                    neighbor_alt = self.get_corner_altitude(nr, nc)
                    if neighbor_alt - new_alt > 1:
                        self.propagate_lower(nr, nc, visited)

    def raise_corner(self, r, c):
        self.propagate_raise(r, c)

    def lower_corner(self, r, c):
        self.propagate_lower(r, c)

    def lerp_color(self, c1, c2, t):
        return (
            int(c1[0] + (c2[0] - c1[0]) * t),
            int(c1[1] + (c2[1] - c1[1]) * t),
            int(c1[2] + (c2[2] - c1[2]) * t),
        )

    def average_color(self, color1, color2):
        return tuple((c1 + c2) // 2 for c1, c2 in zip(color1, color2))

    def draw_tile(self, surface, r, c, camera_offset_x=0, camera_offset_y=0):
        alt = [
            self.get_corner_altitude(r, c),         # A
            self.get_corner_altitude(r, c + 1),     # B
            self.get_corner_altitude(r + 1, c + 1), # C
            self.get_corner_altitude(r + 1, c)      # D
        ]
        pts = [
            self.world_to_screen(r, c, alt[0], camera_offset_x, camera_offset_y),         # A
            self.world_to_screen(r, c + 1, alt[1], camera_offset_x, camera_offset_y),     # B
            self.world_to_screen(r + 1, c + 1, alt[2], camera_offset_x, camera_offset_y), # C
            self.world_to_screen(r + 1, c, alt[3], camera_offset_x, camera_offset_y)      # D
        ]
        colors = [TERRAIN_COLORS.get(a, DEFAULT_TERRAIN_COLOR_INFO)[1] for a in alt]

        # Cas 1 : tous identiques
        if alt[0] == alt[1] == alt[2] == alt[3]:
            pygame.draw.polygon(surface, colors[0], pts)
            pygame.draw.polygon(surface, (0, 0, 0), pts, 1)
            return

        # Cas 2 : un coin différent
        found = False
        for i in range(4):
            others = [alt[(i+1)%4], alt[(i+2)%4], alt[(i+3)%4]]
            if others[0] == others[1] == others[2] and alt[i] != others[0]:
                diff_idx = i
                maj = others[0]
                found = True
                break

        if found:
            tri1 = [diff_idx, (diff_idx+1)%4, (diff_idx-1)%4]
            tri2 = [(diff_idx+1)%4, (diff_idx+2)%4, (diff_idx-1)%4]

            # Triangle 1
            t1_alts = [alt[j] for j in tri1]
            t1_colors = [colors[j] for j in tri1]
            if t1_alts[0] == t1_alts[1] == t1_alts[2]:
                color_tri1 = t1_colors[0]
            else:
                min_alt = min(t1_alts)
                max_alt = max(t1_alts)
                color_tri1 = self.average_color(
                    TERRAIN_COLORS.get(min_alt, DEFAULT_TERRAIN_COLOR_INFO)[1],
                    TERRAIN_COLORS.get(max_alt, DEFAULT_TERRAIN_COLOR_INFO)[1]
                )
            pygame.draw.polygon(surface, color_tri1, [pts[j] for j in tri1])

            # Triangle 2
            t2_alts = [alt[j] for j in tri2]
            t2_colors = [colors[j] for j in tri2]
            if t2_alts[0] == t2_alts[1] == t2_alts[2]:
                color_tri2 = t2_colors[0]
            else:
                min_alt = min(t2_alts)
                max_alt = max(t2_alts)
                color_tri2 = self.average_color(
                    TERRAIN_COLORS.get(min_alt, DEFAULT_TERRAIN_COLOR_INFO)[1],
                    TERRAIN_COLORS.get(max_alt, DEFAULT_TERRAIN_COLOR_INFO)[1]
                )
            pygame.draw.polygon(surface, color_tri2, [pts[j] for j in tri2])

        # Cas 3 : deux paires (ex: 1122, 2211, 3443, 2332, etc.)
        else:
            levels = list(set(alt))
            interm = self.average_color(
                TERRAIN_COLORS.get(levels[0], DEFAULT_TERRAIN_COLOR_INFO)[1],
                TERRAIN_COLORS.get(levels[1], DEFAULT_TERRAIN_COLOR_INFO)[1]
            )
            pygame.draw.polygon(surface, interm, pts)

        # Optionnel : contour
        pygame.draw.polygon(surface, (0, 0, 0), pts, 1)

        # Dessin de la maison si présente
        for house in self.houses:
            if house.r == r and house.c == c:
                alt = self.get_corner_altitude(r, c)
                px, py = self.world_to_screen(r + 0.5, c + 0.5, alt, camera_offset_x, camera_offset_y)
                pygame.draw.rect(surface, (150, 75, 0), (px-6, py-12, 12, 12))  # base
                pygame.draw.polygon(surface, (200, 0, 0), [(px-6, py-12), (px+6, py-12), (px, py-20)])  # toit
                # Barre de vie de la maison
                bar_width = 16
                bar_height = 3
                life_ratio = min(1.0, house.life / 100)
                pygame.draw.rect(surface, (255, 0, 0), (px - bar_width//2, py - 18, bar_width, bar_height))
                pygame.draw.rect(surface, (0, 255, 0), (px - bar_width//2, py - 18, int(bar_width * life_ratio), bar_height))

    def draw(self, surface, camera_offset_x=0, camera_offset_y=0):
        for r in range(self.grid_height):
            for c in range(self.grid_width):
                self.draw_tile(surface, r, c, camera_offset_x, camera_offset_y)

    def randomize(self, min_level=0, max_level=7):
        # On commence par la première ligne
        self.corners[0][0] = random.randint(min_level, max_level)
        for c in range(1, self.grid_width + 1):
            prev = self.corners[0][c-1]
            self.corners[0][c] = max(min_level, min(max_level, prev + random.choice([-1, 0, 1])))
        # Puis chaque ligne suivante
        for r in range(1, self.grid_height + 1):
            # Premier coin de la ligne : voisin du dessus
            prev = self.corners[r-1][0]
            self.corners[r][0] = max(min_level, min(max_level, prev + random.choice([-1, 0, 1])))
            for c in range(1, self.grid_width + 1):
                # On prend la moyenne des voisins gauche et haut, puis on ajoute -1, 0 ou +1
                left = self.corners[r][c-1]
                up = self.corners[r-1][c]
                base = (left + up) // 2
                self.corners[r][c] = max(min_level, min(max_level, base + random.choice([-1, 0, 1])))

    def is_flat_and_buildable(self, r, c):
        # Vérifie que la case est plate et non niveau 0
        a = self.get_corner_altitude(r, c)
        b = self.get_corner_altitude(r, c+1)
        c_ = self.get_corner_altitude(r+1, c+1)
        d = self.get_corner_altitude(r+1, c)
        if a == b == c_ == d and a != 0:
            # Vérifie l'absence d'obstacle
            return not self.has_obstacle(r, c)
        return False

    def has_obstacle(self, r, c):
        # À compléter plus tard (arbre, sort, dépendance...)
        # Pour l’instant, on vérifie juste la présence d’un bâtiment
        return hasattr(self, "buildings") and (r, c) in self.buildings

    def add_house(self, r, c, life):
        house = House(r, c, life)
        house.game_map = self  # pour spawn_peep
        self.houses.append(house)

class House:
    # Dummy Peep class definition to avoid NameError
    class Peep:
        def __init__(self, r, c, game_map):
            self.r = r
            self.c = c
            self.game_map = game_map
    
    def __init__(self, r, c, life):
        self.r = r
        self.c = c
        self.life = life

    def update(self, dt):
        self.life += dt

    def can_spawn_peep(self):
        return self.life > 100

        def spawn_peep(self):
            self.life -= 50
            return Peep(self.r, self.c, self.game_map)
    
