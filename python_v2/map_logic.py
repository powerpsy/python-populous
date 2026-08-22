"""
map_logic.py – Logique pure du terrain isométrique de Populous (portage ASM Amiga).
Aucune dépendance pygame : ce module est utilisable sans affichage.

Le terrain est une grille de (GRID_HEIGHT+1) × (GRID_WIDTH+1) coins (corners).
Chaque case (r, c) est définie par ses quatre coins :
    NW = (r,   c  )  NE = (r,   c+1)
    SW = (r+1, c  )  SE = (r+1, c+1)
"""

import random
from settings import (
    GRID_WIDTH, GRID_HEIGHT,
    ALTITUDE_MIN, ALTITUDE_MAX,
    TILE_HALF_W, TILE_HALF_H,
    MAP_OFFSET_X, MAP_OFFSET_Y,
    SLOPE_TILES, SLOPE_TILES_LOW,
    TILE_WATER, TILE_FLAT, TILE_SWAMP,
    GAME_OPTIONS,
)


class MapLogic:
    """État pur du terrain : altitudes, marécages, rochers."""

    def __init__(self, grid_width: int = GRID_WIDTH, grid_height: int = GRID_HEIGHT):
        self.grid_width  = grid_width
        self.grid_height = grid_height

        # Tableau des altitudes (corners) – liste de listes d'entiers
        self.corners: list[list[int]] = [
            [0] * (grid_width + 1)
            for _ in range(grid_height + 1)
        ]

        # Ensembles d'objets positionnés sur les cases
        self.rocks:  dict[tuple[int, int], str] = {}   # (r, c) -> tile_key
        self.swamps: set[tuple[int, int]]        = set()

        # Référence aux maisons (peuplée par GameState)
        self.houses: list = []
        self.peeps:  list = []

        # Statistiques
        self.stats: dict = {'battles_won': {'allies': 0, 'foes': 0}}

    # ------------------------------------------------------------------
    # Accès aux altitudes
    # ------------------------------------------------------------------

    def get_corner(self, r: int, c: int) -> int:
        """Retourne l'altitude du coin (r, c), ou -1 si hors-grille."""
        if 0 <= r <= self.grid_height and 0 <= c <= self.grid_width:
            return self.corners[r][c]
        return -1

    def set_corner(self, r: int, c: int, value: int) -> bool:
        """
        Définit l'altitude d'un coin.
        Supprime les marécages adjacents si le terrain change.
        Retourne True si la valeur a changé.
        """
        if not (0 <= r <= self.grid_height and 0 <= c <= self.grid_width):
            return False
        clamped = max(ALTITUDE_MIN, min(value, ALTITUDE_MAX))
        if self.corners[r][c] == clamped:
            return False
        self.corners[r][c] = clamped
        # Les marécages adjacents disparaissent quand le terrain change
        for dr in (-1, 0):
            for dc in (-1, 0):
                self.swamps.discard((r + dr, c + dc))
        return True

    # ------------------------------------------------------------------
    # Conversions coordonnées
    # ------------------------------------------------------------------

    def world_to_screen(
        self,
        r: float, c: float,
        altitude: float,
        cam_r: float = 0.0,
        cam_c: float = 0.0,
    ) -> tuple[int, int]:
        """Projection isométrique (r, c, altitude) → (sx, sy) écran interne."""
        lr = r - cam_r
        lc = c - cam_c
        sx = MAP_OFFSET_X + (lc - lr) * TILE_HALF_W
        sy = MAP_OFFSET_Y + (lc + lr) * TILE_HALF_H - altitude * TILE_HALF_H
        return int(sx), int(sy)

    def screen_to_nearest_corner(
        self,
        sx: int, sy: int,
        cam_r: float = 0.0,
        cam_c: float = 0.0,
    ) -> tuple[int, int]:
        """Trouve le coin de grille le plus proche du point écran (sx, sy)."""
        best_r, best_c = 0, 0
        best_dist = float("inf")
        start_r = max(0, int(cam_r) - 2)
        end_r   = min(self.grid_height + 1, int(cam_r) + 14)
        start_c = max(0, int(cam_c) - 2)
        end_c   = min(self.grid_width  + 1, int(cam_c) + 14)

        for r in range(start_r, end_r):
            for c in range(start_c, end_c):
                alt = self.corners[r][c]
                px, py = self.world_to_screen(r, c, alt, cam_r, cam_c)
                d = (px - sx) ** 2 + (py - sy) ** 2
                if d < best_dist:
                    best_dist = d
                    best_r, best_c = r, c
        return best_r, best_c

    # ------------------------------------------------------------------
    # Calcul de la tile à afficher pour une case (r, c)
    # ------------------------------------------------------------------

    def get_tile_key(self, r: int, c: int) -> tuple[int, int]:
        """
        Retourne la clé (row, col) du tileset à utiliser pour la case (r, c).
        Logique directement issue de l'ASM Amiga :
          - eau si tous les coins sont à 0
          - pente basse si l'un des coins vaut 1 (proche de l'eau)
          - pente haute sinon
          - plat si différences nulles
        """
        a_nw = self.get_corner(r,     c    )
        a_ne = self.get_corner(r,     c + 1)
        a_se = self.get_corner(r + 1, c + 1)
        a_sw = self.get_corner(r + 1, c    )

        if a_nw < 0:
            return TILE_FLAT

        # Eau
        if a_nw == 0 and a_ne == 0 and a_se == 0 and a_sw == 0:
            return TILE_WATER

        # Marécage
        if (r, c) in self.swamps:
            return TILE_SWAMP

        min_alt = min(a_nw, a_ne, a_se, a_sw)
        max_alt = max(a_nw, a_ne, a_se, a_sw)

        if max_alt == min_alt:
            return TILE_FLAT

        delta = (
            a_nw - min_alt,
            a_ne - min_alt,
            a_se - min_alt,
            a_sw - min_alt,
        )
        # Normalise à 0/1 pour le lookup
        norm = tuple(min(1, d) for d in delta)

        if min_alt <= 1:
            tile = SLOPE_TILES_LOW.get(norm)
        else:
            tile = SLOPE_TILES.get(norm)

        return tile if tile is not None else TILE_FLAT

    # ------------------------------------------------------------------
    # Opérations terrain (pouvoirs divins)
    # ------------------------------------------------------------------

    def raise_corner(self, r: int, c: int) -> bool:
        return self.set_corner(r, c, self.get_corner(r, c) + 1)

    def lower_corner(self, r: int, c: int) -> bool:
        return self.set_corner(r, c, self.get_corner(r, c) - 1)

    def do_quake(self, center_r: int, center_c: int, radius: int = 5):
        """Tremblement de terre autour de (center_r, center_c)."""
        for dr in range(-radius, radius + 1):
            for dc in range(-radius, radius + 1):
                r, c = center_r + dr, center_c + dc
                if 0 <= r <= self.grid_height and 0 <= c <= self.grid_width:
                    if random.random() < 0.5:
                        self.lower_corner(r, c)

    def do_flood(self, amount: int = 1):
        """Inondation globale : abaisse tous les coins non-eau de `amount`."""
        for r in range(self.grid_height + 1):
            for c in range(self.grid_width + 1):
                if self.corners[r][c] > 0:
                    self.corners[r][c] = max(0, self.corners[r][c] - amount)

    def do_volcano(self, center_r: int, center_c: int):
        """Volcan : élève un coin et place un rocher."""
        self.raise_corner(center_r, center_c)
        self.raise_corner(center_r, center_c)
        self.rocks[(center_r, center_c)] = 'volcano'

    def do_swamp(self, center_r: int, center_c: int, radius: int = 3):
        """Place des marécages autour du centre."""
        for dr in range(-radius, radius + 1):
            for dc in range(-radius, radius + 1):
                r, c = center_r + dr, center_c + dc
                if 0 <= r < self.grid_height and 0 <= c < self.grid_width:
                    a_nw = self.get_corner(r,     c    )
                    a_ne = self.get_corner(r,     c + 1)
                    a_se = self.get_corner(r + 1, c + 1)
                    a_sw = self.get_corner(r + 1, c    )
                    if a_nw > 0 and a_ne > 0 and a_se > 0 and a_sw > 0:
                        self.swamps.add((r, c))

    # ------------------------------------------------------------------
    # Score de zone plate (utilisé par house_logic)
    # ------------------------------------------------------------------

    def get_flat_area_score(
        self,
        r: int, c: int,
        current_house=None,
        is_castle: bool = False,
    ) -> tuple[int, list]:
        """
        Retourne (score, liste_de_cases_valides).
        score == -1 si la case centrale est non constructible.
        """
        size = 5 if is_castle else 4

        # Vérifier la case centrale
        a0 = self.get_corner(r,     c    )
        a1 = self.get_corner(r,     c + 1)
        a2 = self.get_corner(r + 1, c + 1)
        a3 = self.get_corner(r + 1, c    )

        if a0 <= 0 or a1 <= 0 or a2 <= 0 or a3 <= 0:
            return -1, []
        if (r, c) in self.swamps or (r, c) in self.rocks:
            return -1, []

        # Vérifier les conflits avec d'autres maisons
        for h in self.houses:
            if h is current_house:
                continue
            if getattr(h, 'destroyed', False):
                continue
            if h.r == r and h.c == c:
                return -1, []

        valid_tiles = []
        half = size // 2
        ref_alt = a0

        for dr in range(-half, half + 1):
            for dc in range(-half, half + 1):
                tr, tc = r + dr, c + dc
                if not (0 <= tr < self.grid_height and 0 <= tc < self.grid_width):
                    continue
                ta = [
                    self.get_corner(tr,     tc    ),
                    self.get_corner(tr,     tc + 1),
                    self.get_corner(tr + 1, tc + 1),
                    self.get_corner(tr + 1, tc    ),
                ]
                if any(a != ref_alt for a in ta):
                    continue
                if any(a <= 0 for a in ta):
                    continue
                if (tr, tc) in self.swamps or (tr, tc) in self.rocks:
                    continue
                valid_tiles.append((tr, tc))

        return len(valid_tiles), valid_tiles

    # ------------------------------------------------------------------
    # Génération de terrain (seed)
    # ------------------------------------------------------------------

    def generate(self, seed: int | None = None):
        """Génère un terrain aléatoire reproductible depuis `seed`."""
        rng = random.Random(seed)

        # Remettre tout à 0
        for r in range(self.grid_height + 1):
            for c in range(self.grid_width + 1):
                self.corners[r][c] = 0

        # Îlots centraux
        center_r = self.grid_height // 2
        center_c = self.grid_width  // 2
        island_radius = 22

        for r in range(self.grid_height + 1):
            for c in range(self.grid_width + 1):
                dr = r - center_r
                dc = c - center_c
                dist = (dr ** 2 + dc ** 2) ** 0.5
                if dist < island_radius:
                    base = max(1, int((island_radius - dist) / 4))
                    self.corners[r][c] = min(base + rng.randint(0, 1), ALTITUDE_MAX)

        # Passes de lissage
        for _ in range(3):
            self._smooth_pass()

        self.rocks.clear()
        self.swamps.clear()

    def _smooth_pass(self):
        """Passe de lissage diamond-square simplifié."""
        new = [[self.corners[r][c] for c in range(self.grid_width + 1)]
               for r in range(self.grid_height + 1)]
        for r in range(1, self.grid_height):
            for c in range(1, self.grid_width):
                neighbors = [
                    self.corners[r - 1][c],
                    self.corners[r + 1][c],
                    self.corners[r][c - 1],
                    self.corners[r][c + 1],
                ]
                avg = sum(neighbors) // 4
                new[r][c] = (self.corners[r][c] + avg) // 2
        self.corners = new
