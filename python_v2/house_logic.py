"""
house_logic.py – Logique pure des bâtiments Populous (portage ASM Amiga).
Aucune dépendance pygame.

Hiérarchie des bâtiments (Tier 0–9) :
    0 hut  1 house_small  2 house_medium
    3 castle_small  4 castle_medium  5 castle_large
    6 fortress_small  7 fortress_medium  8 fortress_large
    9 castle  (grand château 5×5)
"""

from __future__ import annotations


HOUSE_TYPES = [
    'hut', 'house_small', 'house_medium',
    'castle_small', 'castle_medium', 'castle_large',
    'fortress_small', 'fortress_medium', 'fortress_large',
    'castle',
]

# Vitesse de croissance par tier (points de vie / seconde)
GROWTH_SPEEDS = [1, 2, 3, 4, 5, 6, 8, 10, 12, 16]

# Vie max par tier (seuil de spawn)
MAX_HEALTHS = [16 * (i + 1) for i in range(10)]

# Seuils de cases planes pour chaque tier (hors castle 5×5)
TIER_THRESHOLDS = [0, 1, 3, 5, 7, 9, 11, 12, 14, 16]


class House:
    """Un bâtiment Populous posé sur la case (r, c)."""

    TYPES        = HOUSE_TYPES
    GROWTH_SPEEDS = GROWTH_SPEEDS
    MAX_HEALTHS   = MAX_HEALTHS

    def __init__(self, r: int, c: int, life: float = 10.0, team: str = 'allies'):
        self.r    = r
        self.c    = c
        self.life = float(life)
        self.team = team

        self.max_life       = 16.0
        self.building_type  = 'hut'
        self.destroyed      = False
        self.occupied_tiles: list[tuple[int, int]] = []
        self.has_shield     = False
        self.has_leader     = False
        self._pending_spawn = False

    # ------------------------------------------------------------------
    # Mise à jour (appelée chaque frame par GameState)
    # ------------------------------------------------------------------

    def update(self, dt: float, game_map) -> None:
        """Met à jour la croissance et le tier du bâtiment."""
        score_castle, valid_castle = game_map.get_flat_area_score(
            self.r, self.c, current_house=self, is_castle=True)
        score_normal, valid_normal = game_map.get_flat_area_score(
            self.r, self.c, current_house=self, is_castle=False)

        # Case non constructible → destruction
        if score_normal == -1:
            self.destroyed = True
            return

        # Tier potentiel
        if score_castle >= 24:
            potential_tier  = len(HOUSE_TYPES) - 1
            potential_tiles = valid_castle
        else:
            potential_tier = 0
            for i, thresh in enumerate(TIER_THRESHOLDS):
                if score_normal >= thresh:
                    potential_tier = i
            potential_tier  = min(len(HOUSE_TYPES) - 2, potential_tier)
            potential_tiles = valid_normal

        # Conflit sur la case centrale
        for other in game_map.houses:
            if other is self or getattr(other, 'destroyed', False):
                continue
            if (self.r, self.c) in getattr(other, 'occupied_tiles', []):
                self.destroyed = True
                return

        # Filtrer les cases déjà revendiquées
        filtered = []
        for t in potential_tiles:
            claimed = False
            for other in game_map.houses:
                if other is self or getattr(other, 'destroyed', False):
                    continue
                if t in getattr(other, 'occupied_tiles', []):
                    claimed = True
                    break
            if not claimed:
                filtered.append(t)

        # Le château garde ses cases tant que le terrain est plat
        if self.building_type == 'castle' and potential_tier == len(HOUSE_TYPES) - 1:
            pass
        else:
            self.occupied_tiles = filtered

        score     = len(self.occupied_tiles)
        max_tier  = potential_tier

        # Recalcul après filtrage
        if max_tier < len(HOUSE_TYPES) - 1:
            recalc_tier = 0
            for i, thresh in enumerate(TIER_THRESHOLDS):
                if score >= thresh:
                    recalc_tier = i
            max_tier = min(max_tier, min(len(HOUSE_TYPES) - 2, recalc_tier))

        # Rétrograder si nécessaire
        try:
            current_tier = HOUSE_TYPES.index(self.building_type)
        except ValueError:
            current_tier = 0

        if current_tier > max_tier:
            self.building_type = HOUSE_TYPES[max_tier]
            self.life          = min(self.life, MAX_HEALTHS[max_tier])

        # Croissance
        final_tier       = HOUSE_TYPES.index(self.building_type)
        growth           = GROWTH_SPEEDS[min(final_tier, len(GROWTH_SPEEDS) - 1)]
        self.max_life    = MAX_HEALTHS[final_tier]
        self.life        = min(self.life + growth * dt, self.max_life)

        # Promotion au tier supérieur
        if self.life >= self.max_life and final_tier < max_tier:
            next_tier          = final_tier + 1
            self.building_type = HOUSE_TYPES[next_tier]
            self.max_life      = MAX_HEALTHS[next_tier]

        # Spawn d'un peep
        if self.life >= self.max_life:
            self._pending_spawn = True

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------

    @property
    def tier(self) -> int:
        try:
            return HOUSE_TYPES.index(self.building_type)
        except ValueError:
            return 0
