"""
peep_logic.py – Logique pure des personnages Populous (portage ASM Amiga).
Aucune dépendance pygame.

État d'un peep (identique à l'original Amiga) :
    _go_build    → cherche à construire / améliorer un bâtiment
    _go_fight    → cherche un ennemi à combattre
    _go_assemble → se rallie au point papal
    _go_papal    → déplace vers la position papale
    battle       → en combat
    victory_before / victory_main → animation de victoire
    drown        → se noie
    idle         → attend

Directions isométriques (8) : N NE E SE S SW W NW
"""

from __future__ import annotations

import math
import random
from settings import (
    GRID_WIDTH, GRID_HEIGHT,
    ALTITUDE_MIN,
    PEEP_SPEED,
    GAME_OPTIONS,
)

# ---------------------------------------------------------------------------
# Constantes d'animation (coordonnées dans le spritesheet)
# ---------------------------------------------------------------------------

PEEP_WALK_FRAMES: dict[str, list[tuple[int, int]]] = {
    'N':    [(0,  0), (0,  1)],
    'NE':   [(0,  2), (0,  3)],
    'E':    [(0,  4), (0,  5)],
    'SE':   [(0,  6), (0,  7)],
    'S':    [(0,  8), (0,  9)],
    'SW':   [(0, 10), (0, 11)],
    'W':    [(0, 12), (0, 13)],
    'NW':   [(0, 14), (0, 15)],
    'IDLE': [(0,  8), (0,  9)],
    'WAIT': [(6,  0), (6,  1)],
    'DROWN':[(5,  8), (5,  9), (5, 10), (5, 11)],
}

FOE_WALK_FRAMES: dict[str, list[tuple[int, int]]] = {
    'N':    [(1,  0), (1,  1)],
    'NE':   [(1,  2), (1,  3)],
    'E':    [(1,  4), (1,  5)],
    'SE':   [(1,  6), (1,  7)],
    'S':    [(1,  8), (1,  9)],
    'SW':   [(1, 10), (1, 11)],
    'W':    [(1, 12), (1, 13)],
    'NW':   [(1, 14), (1, 15)],
    'IDLE': [(1,  8), (1,  9)],
    'WAIT': [(6,  2), (6,  3)],
    'DROWN':[(5, 12), (5, 13), (5, 14), (5, 15)],
}

BATTLE_FRAMES:         list[tuple[int, int]] = [(4, 4), (4, 5), (4, 6), (4, 7)]
VICTORY_ALLIE_BEFORE:  list[tuple[int, int]] = [(0, 8), (0, 9)]
VICTORY_ALLIE_MAIN:    list[tuple[int, int]] = [(5, 0), (5, 1), (5, 2), (5, 3)]
VICTORY_FOE_BEFORE:    list[tuple[int, int]] = [(1, 8), (1, 9)]
VICTORY_FOE_MAIN:      list[tuple[int, int]] = [(5, 4), (5, 5), (5, 6), (5, 7)]

KNIGHT_FRAMES: dict[str, list[tuple[int, int]]] = {
    'N':    [(2,  0), (2,  1)],
    'NE':   [(2,  2), (2,  3)],
    'E':    [(2,  4), (2,  5)],
    'SE':   [(2,  6), (2,  7)],
    'S':    [(2,  8), (2,  9)],
    'SW':   [(2, 10), (2, 11)],
    'W':    [(2, 12), (2, 13)],
    'NW':   [(2, 14), (2, 15)],
    'IDLE': [(2,  8), (2,  9)],
    'WAIT': [(6,  4), (6,  5)],
    'DROWN':[(5, 12), (5, 13), (5, 14), (5, 15)],
}

# Vitesse de combat (dommages / seconde)
BATTLE_DPS = 20.0
ANIM_FPS   = 4.0   # frames d'animation par seconde

# Directions en vecteurs (dr, dc)
DIRECTIONS_8 = {
    'N':  (-1, -1),
    'NE': (-1,  0),
    'E':  ( 0,  1),
    'SE': ( 1,  1),
    'S':  ( 1,  0),
    'SW': ( 1, -1),
    'W':  ( 0, -1),
    'NW': (-1, -1),
}

# Cache partagé des sprites (initialisé par le renderer)
_sprites_cache: dict | None = None


class Peep:
    """Un personnage Populous."""

    _sprites: dict | None = None   # partagé entre toutes les instances

    def __init__(
        self,
        r: float, c: float,
        game_map,
        team: str = 'allies',
        is_knight: bool = False,
    ):
        self.y = float(r)   # position en grille (y = ligne)
        self.x = float(c)   # position en grille (x = colonne)
        self.game_map = game_map
        self.team     = team
        self.is_knight = is_knight

        self.life: float = 50.0 if not is_knight else 500.0
        self.dead: bool  = False
        self.in_house: bool = False

        self.facing:     str = 'S'
        self.state:      str = '_go_build'
        self.command:    str = '_go_build'
        self.anim_frame: int = 0
        self.anim_timer: float = 0.0

        self.target_r: float | None = None
        self.target_c: float | None = None
        self.battle_target: 'Peep | None' = None

        self.has_shield: bool = False
        self.has_leader: bool = False

        self.weapon_type: str = 'unarmed'

        self.victory_timer: float = 0.0
        self.drown_timer:   float = 0.0

    # ------------------------------------------------------------------
    # API externe
    # ------------------------------------------------------------------

    @classmethod
    def get_sprites(cls) -> dict:
        return cls._sprites or {}

    @classmethod
    def set_sprites(cls, sprites: dict) -> None:
        cls._sprites = sprites

    def set_command(self, command: str, target=None) -> None:
        self.command = command
        if self.state not in ('battle', 'drown', 'victory_before', 'victory_main'):
            self.state = command
        if target is not None:
            self.target_r, self.target_c = float(target[0]), float(target[1])

    # ------------------------------------------------------------------
    # Mise à jour logique
    # ------------------------------------------------------------------

    def update(self, dt: float, peeps: list, papal_pos: dict, game_map) -> None:
        if self.dead:
            return

        # Noyade
        if self._is_drowning(game_map):
            self._handle_drown(dt, game_map)
            return

        # Animation
        self.anim_timer += dt
        if self.anim_timer >= 1.0 / ANIM_FPS:
            self.anim_timer = 0.0
            self.anim_frame += 1

        # Mise à jour de l'arme
        self._update_weapon()

        # Machine à états
        if self.state == 'battle':
            self._update_battle(dt, peeps)
        elif self.state == 'victory_before':
            self._update_victory_before(dt)
        elif self.state == 'victory_main':
            self._update_victory_main(dt)
        elif self.state in ('_go_build', '_go_fight', '_go_assemble', '_go_papal'):
            self._update_move(dt, peeps, papal_pos, game_map)

    # ------------------------------------------------------------------
    # Sous-états
    # ------------------------------------------------------------------

    def _is_drowning(self, game_map) -> bool:
        r, c = int(self.y), int(self.x)
        if not (0 <= r < game_map.grid_height and 0 <= c < game_map.grid_width):
            return False
        corners = [
            game_map.get_corner(r,     c    ),
            game_map.get_corner(r,     c + 1),
            game_map.get_corner(r + 1, c + 1),
            game_map.get_corner(r + 1, c    ),
        ]
        all_zero = all(a == 0 for a in corners)
        in_swamp = (r, c) in game_map.swamps
        return all_zero or (in_swamp and GAME_OPTIONS.get('swamps_bottomless', False))

    def _handle_drown(self, dt: float, game_map) -> None:
        self.state = 'drown'
        self.drown_timer += dt
        if self.drown_timer > 2.0:
            self.dead = True

    def _update_battle(self, dt: float, peeps: list) -> None:
        if self.battle_target is None or self.battle_target.dead:
            self.battle_target = None
            self.state = self.command
            return

        dist = math.hypot(self.x - self.battle_target.x, self.y - self.battle_target.y)
        if dist > 1.5:
            self._move_toward(self.battle_target.y, self.battle_target.x, dt)
            return

        # Combat
        dmg = BATTLE_DPS * dt
        self.battle_target.life -= dmg
        self.life -= dmg * 0.5
        if self.battle_target.life <= 0:
            self.battle_target.dead = True
            self.battle_target = None
            self.state = 'victory_before'
            self.victory_timer = 0.0
            return
        if self.life <= 0:
            self.dead = True

    def _update_victory_before(self, dt: float) -> None:
        self.victory_timer += dt
        if self.victory_timer >= 0.2:
            self.state = 'victory_main'
            self.victory_timer = 0.0

    def _update_victory_main(self, dt: float) -> None:
        self.victory_timer += dt
        if self.victory_timer >= 0.5:
            self.state = self.command
            self.victory_timer = 0.0

    def _update_move(
        self,
        dt: float,
        peeps: list,
        papal_pos: dict,
        game_map,
    ) -> None:
        if self.state == '_go_build':
            self._move_to_build(dt, game_map)
        elif self.state == '_go_fight':
            self._move_to_fight(dt, peeps, game_map)
        elif self.state in ('_go_assemble', '_go_papal'):
            pos = papal_pos.get(self.team, (GRID_HEIGHT // 2, GRID_WIDTH // 2))
            self._move_toward(pos[0], pos[1], dt)
            # Fusion de peeps allies proches
            self._try_fuse(peeps)

    def _move_to_build(self, dt: float, game_map) -> None:
        """Cherche un bon endroit pour construire."""
        if self.target_r is None or self._reached_target():
            self._pick_build_target(game_map)
        if self.target_r is not None:
            self._move_toward(self.target_r, self.target_c, dt)

    def _move_to_fight(self, dt: float, peeps: list, game_map) -> None:
        """Cherche un ennemi."""
        enemy_team = 'foes' if self.team == 'allies' else 'allies'
        nearest = None
        best_d  = float('inf')
        for p in peeps:
            if p.dead or p.team != enemy_team:
                continue
            d = math.hypot(self.x - p.x, self.y - p.y)
            if d < best_d:
                best_d  = d
                nearest = p

        if nearest is None:
            return

        if best_d <= 1.5:
            self.state          = 'battle'
            self.battle_target  = nearest
        else:
            self._move_toward(nearest.y, nearest.x, dt)

    def _pick_build_target(self, game_map) -> None:
        """Choisit une destination de construction aléatoire."""
        r = int(self.y) + random.randint(-4, 4)
        c = int(self.x) + random.randint(-4, 4)
        r = max(0, min(r, GRID_HEIGHT - 1))
        c = max(0, min(c, GRID_WIDTH  - 1))
        self.target_r = float(r)
        self.target_c = float(c)

    def _reached_target(self) -> bool:
        if self.target_r is None:
            return True
        return math.hypot(self.x - self.target_c, self.y - self.target_r) < 0.3

    def _move_toward(self, tr: float, tc: float, dt: float) -> None:
        dr = tr - self.y
        dc = tc - self.x
        dist = math.hypot(dc, dr)
        if dist < 0.01:
            return

        speed = PEEP_SPEED if self.is_knight else (PEEP_SPEED * 0.6)
        step  = min(speed * dt, dist)
        self.y += dr / dist * step
        self.x += dc / dist * step

        self.y = max(0.0, min(self.y, float(GRID_HEIGHT - 1)))
        self.x = max(0.0, min(self.x, float(GRID_WIDTH  - 1)))

        self.facing = self._direction_from(dr, dc)

    def _direction_from(self, dr: float, dc: float) -> str:
        angle = math.degrees(math.atan2(dc, -dr)) % 360
        dirs  = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW']
        idx   = int((angle + 22.5) / 45) % 8
        return dirs[idx]

    def _try_fuse(self, peeps: list) -> None:
        """Fusionne ce peep avec un allié proche (augmente la vie)."""
        if self.is_knight:
            return
        for other in peeps:
            if other is self or other.dead or other.team != self.team:
                continue
            if other.is_knight:
                continue
            d = math.hypot(self.x - other.x, self.y - other.y)
            if d < 0.5:
                self.life  = min(999.0, self.life + other.life)
                other.dead = True
                break

    def _update_weapon(self) -> None:
        if   self.life >= 100: self.weapon_type = 'arc'
        elif self.life >= 70:  self.weapon_type = 'sword'
        elif self.life >= 40:  self.weapon_type = 'short_sword'
        elif self.life >= 20:  self.weapon_type = 'stick'
        else:                  self.weapon_type = 'unarmed'
