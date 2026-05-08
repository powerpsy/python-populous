import pygame
import random
from settings import *


def load_tile_surfaces():
    """Charge le tileset et découpe chaque tile en surface pygame."""
    sheet_raw = pygame.image.load(TILES_PATH).convert()
    sheet_raw.set_colorkey((0, 49, 0))  # Transparence pour le fond vert des tiles Amiga
    sheet = sheet_raw.convert_alpha()

    # Découpage du nouveau format AmigaTiles (32x24 pixels, décalage x=12 y=10)
    tile_w = 32
    tile_h = 24
    
    x_starts = [12 + i * 35 for i in range(9)]
    x_ends = [x + tile_w for x in x_starts]
    
    y_starts = [10 + i * 27 for i in range(8)]
    y_ends = [y + tile_h for y in y_starts]

    ref_w = tile_w
    ref_h = tile_h

    tiles = {}
    for row in range(len(y_starts)):
        for col in range(len(x_starts)):
            # Gérer le cas de la dernière ligne restreinte sur les AmigaTiles (seulement 5 tiles)
            if row == 7 and col > 4:
                continue
                
            x0, x1 = x_starts[col], x_ends[col]
            y0, y1 = y_starts[row], y_ends[row]
            tw, th = x1 - x0, y1 - y0
            try:
                sub = sheet.subsurface(pygame.Rect(x0, y0, tw, th)).copy()
            except ValueError:
                continue
                
            if tw < ref_w or th < ref_h:
                padded = pygame.Surface((ref_w, ref_h), pygame.SRCALPHA)
                padded.blit(sub, (0, 0))
                sub = padded
                
            # No scaling
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
        self.rocks = {}  # { (r, c): tile_key }
        self.swamps = set() # { (r, c) }
        self.tile_surfaces = load_tile_surfaces()
        self.water_timer = 0.0
        self.water_frame = 0
        self.flag_frame = 0

    def get_corner_altitude(self, r, c):
        if 0 <= r <= self.grid_height and 0 <= c <= self.grid_width:
            return self.corners[r][c]
        return -1

    def set_corner_altitude(self, r, c, value):
        if 0 <= r <= self.grid_height and 0 <= c <= self.grid_width:
            clamped = max(ALTITUDE_MIN, min(value, ALTITUDE_MAX))
            if self.corners[r][c] != clamped:
                self.corners[r][c] = clamped
                # Le terrain a changé, les marécages adjacents disparaissent
                for dr in [-1, 0]:
                    for dc in [-1, 0]:
                        nr, nc = r + dr, c + dc
                        if (nr, nc) in self.swamps:
                            self.swamps.remove((nr, nc))
                return True
        return False

    def world_to_screen(self, r, c, altitude, cam_r=0, cam_c=0):
        local_r = r - cam_r
        local_c = c - cam_c
        sx = MAP_OFFSET_X + (local_c - local_r) * TILE_HALF_W
        elev = altitude * TILE_HALF_H  # Incrément strict de 8 pixels par niveau
        sy = MAP_OFFSET_Y + (local_c + local_r) * TILE_HALF_H - elev
        return int(sx), int(sy)

    def screen_to_nearest_corner(self, sx, sy, cam_r=0, cam_c=0):
        best_r, best_c = 0, 0
        min_dist = float("inf")
        start_r = max(0, int(cam_r) - 2)
        end_r = min(self.grid_height + 1, int(cam_r) + 12)
        start_c = max(0, int(cam_c) - 2)
        end_c = min(self.grid_width + 1, int(cam_c) + 12)
        
        for r in range(start_r, end_r):
            for c in range(start_c, end_c):
                alt = self.get_corner_altitude(r, c)
                px, py = self.world_to_screen(r, c, alt, cam_r, cam_c)
                
                # Le centre de gravité visuel de l'intersection de la grille isométrique
                # est décalé vers le bas de TILE_HALF_H (8 pixels) par rapport au top
                target_y = py + TILE_HALF_H
                
                # Prendre en compte le ratio isométrique (2:1) pour la forme de la zone de clic
                d = (sx - px) ** 2 + ((sy - target_y) * 2) ** 2
                
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
        self.update_rocks_water()

    def lower_corner(self, r, c):
        self.propagate_lower(r, c)
        self.update_rocks_water()

    def do_flood(self):
        """Baisse l'altitude de TOUS les coins de la carte de 1 niveau."""
        for r in range(self.grid_height + 1):
            for c in range(self.grid_width + 1):
                self.corners[r][c] = max(ALTITUDE_MIN, self.corners[r][c] - 1)
        self.update_rocks_water()

    def do_quake(self, center_r, center_c):
        """Effectue les dégâts physiques du tremblement de terre : baisse 20-30 cases et en monte 0-10 au hasard."""
        # Abaissement (20-30 cases)
        lower_count = random.randint(20, 30)
        for _ in range(lower_count):
            rr = center_r + random.randint(-4, 3)
            rc = center_c + random.randint(-4, 3)
            self.lower_corner(rr, rc)
        
        # Élévation (0-10 cases)
        raise_count = random.randint(0, 10)
        for _ in range(raise_count):
            rr = center_r + random.randint(-4, 3)
            rc = center_c + random.randint(-4, 3)
            self.raise_corner(rr, rc)
            
        self.update_rocks_water()

    def do_swamp(self, center_r, center_c):
        """Ajoute 20-30 cases swamp sur la map 12x12 centrée."""
        count = random.randint(20, 30)
        for _ in range(count):
            # Zone 12x12 centrée (centré sur 8x8 visible, donc décalage de -2 à +9 approx)
            # Pour simplifier on fait un gros random autour du centre
            rr = center_r + random.randint(-6, 5)
            rc = center_c + random.randint(-6, 5)
            if 0 <= rr < self.grid_height and 0 <= rc < self.grid_width:
                # Tester si c'est une case plate (pas de l'eau)
                a = self.get_corner_altitude(rr, rc)
                b = self.get_corner_altitude(rr, rc + 1)
                c = self.get_corner_altitude(rr + 1, rc + 1)
                d = self.get_corner_altitude(rr + 1, rc)
                if a == b == c == d and a > 0:
                    self.swamps.add((rr, rc))
        
    def update_rocks_water(self):
        """Vérifie tous les rochers existants et les supprime si la case est submergée."""
        to_remove = []
        for (r, c) in self.rocks.keys():
            if self.is_water(r, c):
                to_remove.append((r, c))
        for rc in to_remove:
            del self.rocks[rc]
            
    def is_water(self, r, c):
        return self.get_tile_key(r, c) in (TILE_WATER, TILE_WATER_2)

    def do_volcano(self, r, c):
        """
        Crée une montagne à la position (r, c).
        Le terrain monte de 5 immédiatement puis les 9 cases du centre sont randomisées à +/-1.
        Ajoute également 10-30 rochers dans la zone 8x8 autour du sommet.
        """
        # 1. Monter de 5 niveaux avec propagation
        for _ in range(5):
            self.raise_corner(r, c)
            
        # 2. Randomisation des 9 cases (3x3) du centre
        for dr in range(-1, 2):
            for dc in range(-1, 2):
                nr, nc = r + dr, c + dc
                if 0 <= nr <= self.grid_height and 0 <= nc <= self.grid_width:
                    offset = random.choice([-1, 0, 1])
                    if offset == 1:
                        self.raise_corner(nr, nc)
                    elif offset == -1:
                        self.lower_corner(nr, nc)

        # 3. Ajout de 10-30 rochers dans la zone 8x8 autour
        num_volcano_rocks = random.randint(10, 30)
        rock_tiles = [(5, 2), (5, 3), (5, 4)]
        for _ in range(num_volcano_rocks):
            # Zone 8x8 centrée (donc -4 à +3 autour de r, c)
            rr = r + random.randint(-4, 3)
            rc = c + random.randint(-4, 3)
            if 0 <= rr < self.grid_height and 0 <= rc < self.grid_width:
                # On ne place de rochers que s'il n'y a pas d'eau (le volcan crée de la terre)
                if not self.is_water(rr, rc):
                    self.rocks[(rr, rc)] = random.choice(rock_tiles)

    def get_raise_cost(self, r, c):
        backup = [row[:] for row in self.corners]
        visited = set()
        changed = []
        def prop(curr_r, curr_c):
            if (curr_r, curr_c) in visited:
                return
            visited.add((curr_r, curr_c))
            current = self.get_corner_altitude(curr_r, curr_c)
            new_alt = current + 1
            if self.set_corner_altitude(curr_r, curr_c, new_alt):
                changed.append((curr_r, curr_c))
                for dr in [-1, 0, 1]:
                    for dc in [-1, 0, 1]:
                        if dr == 0 and dc == 0:
                            continue
                        nr, nc = curr_r + dr, curr_c + dc
                        if 0 <= nr <= self.grid_height and 0 <= nc <= self.grid_width:
                            if new_alt - self.get_corner_altitude(nr, nc) > 1:
                                prop(nr, nc)
        prop(r, c)
        self.corners = backup
        return len(changed)

    def get_lower_cost(self, r, c):
        backup = [row[:] for row in self.corners]
        visited = set()
        changed = []
        def prop(curr_r, curr_c):
            if (curr_r, curr_c) in visited:
                return
            visited.add((curr_r, curr_c))
            current = self.get_corner_altitude(curr_r, curr_c)
            new_alt = current - 1
            if self.set_corner_altitude(curr_r, curr_c, new_alt):
                changed.append((curr_r, curr_c))
                for dr in [-1, 0, 1]:
                    for dc in [-1, 0, 1]:
                        if dr == 0 and dc == 0:
                            continue
                        nr, nc = curr_r + dr, curr_c + dc
                        if 0 <= nr <= self.grid_height and 0 <= nc <= self.grid_width:
                            if self.get_corner_altitude(nr, nc) - new_alt > 1:
                                prop(nr, nc)
        prop(r, c)
        self.corners = backup
        return len(changed)

    def update(self, dt):
        """Met à jour les animations (eau)."""
        self.water_timer += dt
        if self.water_timer >= 0.5:
            self.water_timer -= 0.5
            self.water_frame = 1 - self.water_frame
            self.flag_frame = 1 - self.flag_frame
        self.water_timer += dt
        if self.water_timer >= 0.5:
            self.water_timer -= 0.5
            self.water_frame = 1 - self.water_frame
            self.flag_frame = 1 - self.flag_frame

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

        tile = tile_map.get(d, TILE_FLAT)

        if (r, c) in self.swamps:
            return TILE_SWAMP

        if tile == TILE_FLAT:
            for h in self.houses:
                if (r, c) in getattr(h, 'occupied_tiles', []):
                    if getattr(h, 'team', 'allies') == 'foes':
                        return TILE_CONSTRUCTED_FOES
                    return TILE_CONSTRUCTED_ALLIES
        return tile

    def draw_tile(self, surface, r, c, cam_r=0, cam_c=0, offset_y=0):
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
        sx, sy = self.world_to_screen(r, c, min_alt, cam_r, cam_c)
        sy += offset_y
        blit_x = sx - TILE_HALF_W
        if tile_key in (TILE_FLAT, TILE_CONSTRUCTED_ALLIES, TILE_CONSTRUCTED_FOES, TILE_SWAMP):
            blit_y = sy + TILE_HALF_H  # Décale de 8 pixels vers le bas pour les tiles plates
        else:
            blit_y = sy

        # Remplir les faces latérales visibles avec des copies empilées de TILE_FLAT
        # gap = distance en pixels entre blit_y et le niveau de sol de référence (alt=0)
        _, sy0 = self.world_to_screen(r, c, 0, cam_r, cam_c)
        gap = sy0 - blit_y
        n_copies = gap // TILE_HALF_H
        if n_copies > 0:
            flat_surf = self.tile_surfaces.get(TILE_FLAT)
            if flat_surf is not None:
                for k in range(n_copies, 0, -1):  # du bas vers le haut
                    surface.blit(flat_surf, (blit_x, blit_y + k * TILE_HALF_H))

        surface.blit(tile_surf, (blit_x, blit_y))

        # Dessiner le rocher s'il y en a un sur cette case
        rock = self.rocks.get((r, c))
        if rock:
            rock_surf = self.tile_surfaces.get(rock)
            if rock_surf:
                # Calcul de l'altitude du rocher
                # Si la tile est plate (1, 6) ou construite, on monte le rocher d'un niveau (8px)
                rock_blit_y = blit_y
                if tile_key in (TILE_FLAT, TILE_CONSTRUCTED_ALLIES, TILE_CONSTRUCTED_FOES, TILE_SWAMP):
                    rock_blit_y -= TILE_HALF_H
                
                # Les rochers sont des sprites qui se placent sur le tile
                surface.blit(rock_surf, (blit_x, rock_blit_y))

    def screen_to_grid(self, sx, sy, cam_r=0, cam_c=0):
        import settings
        X = sx - settings.MAP_OFFSET_X
        Y = sy - settings.MAP_OFFSET_Y
        
        U = X / settings.TILE_HALF_W
        V = Y / settings.TILE_HALF_H
        
        local_c = (U + V) / 2
        local_r = (V - U) / 2
        return int(local_r + cam_r), int(local_c + cam_c)

    def get_visible_bounds(self, cam_r, cam_c):
        start_r = int(cam_r)
        start_c = int(cam_c)
        end_r = min(self.grid_height, start_r + 8)
        end_c = min(self.grid_width, start_c + 8)
        return start_r, end_r, start_c, end_c

    def draw(self, surface, cam_r=0, cam_c=0, offset_y=0):
        start_r = int(cam_r)
        start_c = int(cam_c)
        end_r = min(self.grid_height, start_r + 8)
        end_c = min(self.grid_width, start_c + 8)

        for r in range(start_r, end_r):
            for c in range(start_c, end_c):
                self.draw_tile(surface, r, c, cam_r, cam_c, offset_y=offset_y)

    def get_flat_area_score(self, r, c, current_house=None, is_castle=False):
        # Ne pas construire sur un marécage
        if (r, c) in self.swamps:
            return -1, []
            
        # Retourne le score basé sur la zone d'influence et la liste des tuiles valid_tiles
        a = self.get_corner_altitude(r, c)
        b = self.get_corner_altitude(r, c + 1)
        c_ = self.get_corner_altitude(r + 1, c + 1)
        d = self.get_corner_altitude(r + 1, c)

        if not (a == b == c_ == d and a > 0):
            return -1, []
            
        base_alt = a
        valid_tiles = []
        
        if is_castle:
            # Pour un château, on prend les 24 tuiles autour (carré 5x5 complet, sans le centre)
            influence_mask = [
                (1, 1, 1, 1, 1),
                (1, 1, 1, 1, 1),
                (1, 1, 0, 1, 1),
                (1, 1, 1, 1, 1),
                (1, 1, 1, 1, 1)
            ]
        else:
            # Pour les autres, masque spécifique de 16 tuiles
            influence_mask = [
                (1, 0, 1, 0, 1),
                (0, 1, 1, 1, 0),
                (1, 1, 0, 1, 1),
                (0, 1, 1, 1, 0),
                (1, 0, 1, 0, 1)
            ]

        # Parcours du voisinage 5x5
        for dr in range(-2, 3):
            for dc in range(-2, 3):
                if dr == 0 and dc == 0:
                    continue
                
                # Vérifier si la case est dans la zone d'influence (les '1')
                if influence_mask[dr + 2][dc + 2] == 0:
                    continue
                
                nr, nc = r + dr, c + dc
                if 0 <= nr < self.grid_height and 0 <= nc < self.grid_width:
                    # Un rocher ou un marécage empêche la tuile d'être comptée dans l'influence/construction
                    if (nr, nc) in self.rocks or (nr, nc) in self.swamps:
                        continue
                        
                    na = self.get_corner_altitude(nr, nc)
                    nb = self.get_corner_altitude(nr, nc + 1)
                    nc_ = self.get_corner_altitude(nr + 1, nc + 1)
                    nd = self.get_corner_altitude(nr + 1, nc)
                    # La tuile doit être plate (coins égaux) et au-dessus de l'eau (>0)
                    if na == nb == nc_ == nd and na > 0:
                        valid_tiles.append((nr, nc))
                    
        return len(valid_tiles), valid_tiles

    def draw_houses(self, surface, cam_r=0, cam_c=0, show_debug=False, debug_font=None, offset_y=0):
        start_r = int(cam_r)
        start_c = int(cam_c)
        end_r = min(self.grid_height, start_r + 8)
        end_c = min(self.grid_width, start_c + 8)

        from peep import Peep
        peep_sprites = Peep.get_sprites()

        for house in sorted(self.houses, key=lambda h: h.r + h.c):
            if house.building_type == 'castle':
                min_r, max_r = house.r - 1, house.r + 1
                min_c, max_c = house.c - 1, house.c + 1
            else:
                min_r, max_r = house.r, house.r
                min_c, max_c = house.c, house.c

            if max_r < start_r or min_r >= end_r or max_c < start_c or min_c >= end_c:
                continue
            
            # Sélection du drapeau d'équipe (Allies 4.0/4.1, Foes 4.2/4.3)
            if getattr(house, 'team', 'allies') == 'foes':
                flag_surf = peep_sprites.get((4, 2 + self.flag_frame))
            else:
                flag_surf = peep_sprites.get((4, self.flag_frame))

            if house.building_type == 'castle':
                from settings import CASTLE_9_TILES
                offsets = [
                    (0, 0, CASTLE_9_TILES['center']), (-1, -1, CASTLE_9_TILES['corner']),     (-1, 0, CASTLE_9_TILES['side_tb']),     (-1, 1, CASTLE_9_TILES['corner']),
                    (0, -1, CASTLE_9_TILES['side_lr']),            (0, 1, CASTLE_9_TILES['side_lr']),
                    (1, -1, CASTLE_9_TILES['corner']),      (1, 0, CASTLE_9_TILES['side_tb']),      (1, 1, CASTLE_9_TILES['corner'])
                ]
                offsets.sort(key=lambda x: (house.r + x[0]) + (house.c + x[1]))
                for dr, dc, tile_key in offsets:
                    nr, nc = house.r + dr, house.c + dc
                    if 0 <= nr < self.grid_height and 0 <= nc < self.grid_width:
                        if start_r <= nr < end_r and start_c <= nc < end_c:
                            alt = self.get_corner_altitude(nr, nc)
                            tile_surf = self.tile_surfaces.get(tile_key)
                            if tile_surf is not None:
                                sx, sy = self.world_to_screen(nr, nc, alt, cam_r, cam_c)
                                sy += offset_y
                                surface.blit(tile_surf, (sx - TILE_HALF_W, sy))
                if flag_surf is not None and start_r <= house.r < end_r and start_c <= house.c < end_c:
                    sx, sy = self.world_to_screen(house.r, house.c, self.get_corner_altitude(house.r, house.c), cam_r, cam_c)
                    sy += offset_y
                    surface.blit(flag_surf, (sx, sy))
                # Affichage debug vie château (centre)
                if show_debug and debug_font is not None and start_r <= house.r < end_r and start_c <= house.c < end_c:
                    sx, sy = self.world_to_screen(house.r, house.c, self.get_corner_altitude(house.r, house.c), cam_r, cam_c)
                    sy += offset_y
                    # Bleu (0,255,255) pour alliés, Violet (255,0,255) pour foes
                    color = (255, 0, 255) if getattr(house, 'team', 'allies') == 'foes' else (0, 255, 255)
                    life_text = debug_font.render(f"{int(house.life)}", True, color)
                    text_x = sx - life_text.get_width() // 2
                    text_y = sy - 24
                    surface.blit(life_text, (text_x, text_y))
                continue

            alt = self.get_corner_altitude(house.r, house.c)
            tile_key = BUILDING_TILES.get(house.building_type, BUILDING_TILES["hut"])
            tile_surf = self.tile_surfaces.get(tile_key)
            if tile_surf is None:
                continue
            sx, sy = self.world_to_screen(house.r, house.c, alt, cam_r, cam_c)
            sy += offset_y
            blit_x = sx - TILE_HALF_W
            blit_y = sy
            surface.blit(tile_surf, (blit_x, blit_y))

            # Drapeau d'équipe animé (sprites 4,0 et 4,1)
            if flag_surf is not None:
                flag_x = blit_x + TILE_HALF_W
                flag_y = blit_y
                surface.blit(flag_surf, (flag_x, flag_y))

            # Affichage debug vie bâtiment
            if show_debug and debug_font is not None:
                # Bleu (0,255,255) pour alliés, Violet (255,0,255) pour foes
                color = (255, 0, 255) if getattr(house, 'team', 'allies') == 'foes' else (0, 255, 255)
                life_text = debug_font.render(f"{int(house.life)}", True, color)
                text_x = sx - life_text.get_width() // 2
                text_y = blit_y - 24
                surface.blit(life_text, (text_x, text_y))

    def _enforce_height_constraints(self):
        """Passe de lissage : garantit que tous les voisins à 8 directions diffèrent de max 1."""
        changed = True
        while changed:
            changed = False
            for r in range(self.grid_height + 1):
                for c in range(self.grid_width + 1):
                    for dr, dc in [(0,1),(0,-1),(1,0),(-1,0),(1,1),(1,-1),(-1,1),(-1,-1)]:
                        nr, nc = r + dr, c + dc
                        if 0 <= nr <= self.grid_height and 0 <= nc <= self.grid_width:
                            if self.corners[r][c] - self.corners[nr][nc] > 1:
                                self.corners[r][c] = self.corners[nr][nc] + 1
                                changed = True

    def set_all_altitude(self, value):
        for r in range(self.grid_height + 1):
            for c in range(self.grid_width + 1):
                self.corners[r][c] = value

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
                lo = max(min_level, left - 1, up - 1)
                hi = min(max_level, left + 1, up + 1)
                base = max(lo, min(hi, (left + up) // 2 + random.choice([-1, 0, 1])))
                self.corners[r][c] = base
        self._enforce_height_constraints()

        # Génération des rochers
        self.rocks.clear()
        rock_tiles = [(5, 2), (5, 3), (5, 4)]
        # 100 +/- 100 rochers
        num_rocks = 100 + random.randint(-50, 50)
        for _ in range(num_rocks):
            rr = random.randint(0, self.grid_height - 1)
            rc = random.randint(0, self.grid_width - 1)
            if not self.is_water(rr, rc):
                self.rocks[(rr, rc)] = random.choice(rock_tiles)

    def is_flat_and_buildable(self, r, c):
        if r < 0 or c < 0 or r >= self.grid_height or c >= self.grid_width:
            return False
        # Un rocher empêche la construction
        if (r, c) in self.rocks:
            return False
        a = self.get_corner_altitude(r, c)
        b = self.get_corner_altitude(r, c + 1)
        c_ = self.get_corner_altitude(r + 1, c + 1)
        d = self.get_corner_altitude(r + 1, c)
        if a == b == c_ == d and a > 0:
            # Vérifier qu'aucune maison ne réclame déjà cette tuile
            for h in self.houses:
                if (r, c) in getattr(h, 'occupied_tiles', []):
                    return False
            return True
        return False

    def is_flat_and_buildable_any_alt(self, r, c):
        """Identique à is_flat_and_buildable mais ne nécessite pas une altitude spécifique."""
        if r < 0 or c < 0 or r >= self.grid_height or c >= self.grid_width:
            return False
        # Un rocher empêche l'influence/construction
        if (r, c) in self.rocks:
            return False
        a = self.get_corner_altitude(r, c)
        b = self.get_corner_altitude(r, c + 1)
        c_ = self.get_corner_altitude(r + 1, c + 1)
        d = self.get_corner_altitude(r + 1, c)
        if a == b == c_ == d and a > 0:
            for h in self.houses:
                if (r, c) in getattr(h, 'occupied_tiles', []):
                    return False
            return True
        return False

    def _get_construction_offsets(self, scan_size=25):
        """Offsets de voisinage discrets autour du centre, triés du plus proche au plus lointain."""
        offsets = [
            (dr, dc)
            for dr in range(-2, 3)
            for dc in range(-2, 3)
            if not (dr == 0 and dc == 0)
        ]
        offsets.sort(key=lambda p: p[0] * p[0] + p[1] * p[1])
        return offsets[: max(0, min(scan_size, len(offsets)))]

    def can_place_house_initial(self, r, c):
        """Validation de pose initiale: espace 1 tuile entre bâtiments, 2 pour castle."""
        if not self.is_flat_and_buildable(r, c):
            return False

        # On utilise les nouvelles fonctions de scoring robustes
        score_castle, _ = self.get_flat_area_score(r, c, is_castle=True)
        score_normal, _ = self.get_flat_area_score(r, c, is_castle=False)
        
        from house import House
        if score_castle >= 24:
            is_castle = True
        else:
            is_castle = False
        
        # Distance minimale obligatoire
        # dist est la distance de Chebyshev (max(abs(dr), abs(dc)))
        for h in self.houses:
            if getattr(h, 'destroyed', False):
                continue
            
            dist = max(abs(h.r - r), abs(h.c - c))
            h_is_castle = (h.building_type == 'castle')

            # Un castle (centre r,c) influence un carré 5x5 (r-2..r+2, c-2..c+2).
            # Pour qu'un nouveau bâtiment ne vole AUCUNE case à un château existant,
            # il doit être à une distance de Chebyshev >= 3.
            # Cependant, l'utilisateur demande explicitement :
            # 1. Aucun bâtiment à moins de 3 cases du centre d'un château (donc dist >= 4).
            # 2. Deux châteaux ne peuvent pas être à moins de 4 cases (car ils se voleraient des tuiles mutuellement).
            
            if h_is_castle or is_castle:
                # Si l'un des deux est un château, distance de sécurité accrue
                if dist < 4:
                    return False
            else:
                # Entre deux maisons normales, distance de 2 (une case vide)
                if dist < 2:
                    return False
        return True

    def add_house(self, house):
        self.houses.append(house)

