"""
game_state.py – Orchestrateur central du jeu Populous v2 (portage ASM Amiga).
Aucune dépendance pygame : ce module contient uniquement la logique de jeu.

Responsabilités :
    • Génération / chargement d'un monde
    • Mise à jour de toutes les entités (terrain, maisons, peeps, IA)
    • Gestion des pouvoirs divins
    • Comptage des populations et détection de fin de partie
"""

from __future__ import annotations

import random

from settings import (
    GRID_WIDTH, GRID_HEIGHT,
    GAME_OPTIONS,
)
from map_logic    import MapLogic
from house_logic  import House
from peep_logic   import Peep
from ai_player    import AIPlayer


# Coûts en mana des pouvoirs divins
POWER_COSTS: dict[str, float] = {
    '_raise_terrain': 1.0,
    '_lower_terrain': 1.0,
    '_do_papal':     10.0,
    '_do_quake':    100.0,
    '_do_swamp':    100.0,
    '_do_knight':   100.0,
    '_do_volcano':  100.0,
    '_do_flood':    100.0,
    '_battle_over': 100.0,
    '_do_shield':     0.0,
}

# Accumulation de mana par seconde (par peep vivant de l'équipe)
MANA_PER_PEEP_SEC  = 0.3
MANA_PER_HOUSE_SEC = 0.5
MANA_MAX           = 200.0


class GameState:
    """
    État complet d'une partie Populous.
    Totalement indépendant de l'affichage.
    """

    def __init__(self, world_seed: int | None = None):
        self.world_seed = world_seed

        # Terrain
        self.game_map = MapLogic(GRID_WIDTH, GRID_HEIGHT)

        # Entités
        self.peeps:  list[Peep]  = []
        self.houses: list[House] = []

        # Référence croisée (map_logic accède aux maisons/peeps)
        self.game_map.houses = self.houses
        self.game_map.peeps  = self.peeps

        # Commandes actives par faction
        self.active_peep_command: dict[str, str] = {
            'allies': '_go_build',
            'foes':   '_go_build',
        }

        # Positions papales par faction
        self.papal_position: dict[str, tuple[int, int]] = {
            'allies': (GRID_HEIGHT // 2, GRID_WIDTH // 2),
            'foes':   (GRID_HEIGHT // 2, GRID_WIDTH // 2),
        }

        # Cibles blason par faction
        self.shield_target: dict[str, object | None] = {
            'allies': None,
            'foes':   None,
        }
        self.leader_target: dict[str, object | None] = {
            'allies': None,
            'foes':   None,
        }

        # Jauges de mana
        self.power_jauge: dict[str, float] = {'allies': 0.0, 'foes': 0.0}
        self.power_max:   dict[str, float] = {'allies': MANA_MAX, 'foes': MANA_MAX}

        # Fin de partie
        self.is_battle_over  = False
        self.battle_winner: str | None = None
        self.battle_over_timer = 0.0

        # Tremblements de terre en cours
        self._quake_timer     = 0.0
        self._quake_target: tuple[int, int] | None = None

        # IA
        self.ai = AIPlayer(self, 'foes')
        self.ai.set_difficulty(reaction_speed=5, command_rate=5)

    # ------------------------------------------------------------------
    # Initialisation d'une partie
    # ------------------------------------------------------------------

    def new_game(self, seed: int | None = None, initial_peeps: int = 8) -> None:
        """Génère un nouveau monde et place les peeps initiaux."""
        self.world_seed = seed
        self.game_map.generate(seed)

        self.peeps.clear()
        self.houses.clear()
        self.power_jauge = {'allies': 0.0, 'foes': 0.0}
        self.is_battle_over   = False
        self.battle_winner    = None
        self.battle_over_timer = 0.0

        self._spawn_initial_peeps(initial_peeps)

    def _spawn_initial_peeps(self, count: int) -> None:
        rng = random.Random(self.world_seed)

        def _try_spawn(team: str) -> None:
            for _ in range(200):
                r = rng.randint(0, GRID_HEIGHT - 1)
                c = rng.randint(0, GRID_WIDTH  - 1)
                if self.game_map.get_corner(r, c) > 0:
                    p = Peep(r, c, self.game_map, team=team)
                    p.set_command('_go_build')
                    self.peeps.append(p)
                    return

        for _ in range(count // 2):
            _try_spawn('allies')
        for _ in range(count // 2):
            _try_spawn('foes')

    # ------------------------------------------------------------------
    # Boucle de mise à jour
    # ------------------------------------------------------------------

    def update(self, dt: float) -> None:
        if self.is_battle_over:
            self.battle_over_timer += dt
            return

        self._update_mana(dt)
        self._update_houses(dt)
        self._update_peeps(dt)
        self._spawn_from_houses()
        self._check_battle_over()
        self.ai.update(dt)

        # Tremblement de terre en cours
        if self._quake_timer > 0:
            self._quake_timer -= dt

    def _update_mana(self, dt: float) -> None:
        for team in ('allies', 'foes'):
            n_peeps  = sum(1 for p in self.peeps  if not p.dead  and p.team == team)
            n_houses = sum(1 for h in self.houses if not h.destroyed and h.team == team)
            gain = (n_peeps * MANA_PER_PEEP_SEC + n_houses * MANA_PER_HOUSE_SEC) * dt
            self.power_jauge[team] = min(
                self.power_jauge[team] + gain,
                self.power_max[team],
            )

    def _update_houses(self, dt: float) -> None:
        for h in self.houses:
            if not h.destroyed:
                h.update(dt, self.game_map)
        self.houses[:] = [h for h in self.houses if not h.destroyed]

    def _update_peeps(self, dt: float) -> None:
        for p in self.peeps:
            p.update(dt, self.peeps, self.papal_position, self.game_map)
        self.peeps[:] = [p for p in self.peeps if not p.dead]

    def _spawn_from_houses(self) -> None:
        new_peeps = []
        for h in self.houses:
            if h._pending_spawn:
                h._pending_spawn = False
                h.life = 0.0
                p = Peep(h.r, h.c, self.game_map, team=h.team)
                p.set_command(self.active_peep_command.get(h.team, '_go_build'))
                new_peeps.append(p)
        self.peeps.extend(new_peeps)

    def _check_battle_over(self) -> None:
        allies_alive = sum(1 for p in self.peeps if not p.dead and p.team == 'allies')
        foes_alive   = sum(1 for p in self.peeps if not p.dead and p.team == 'foes')
        allies_houses = sum(1 for h in self.houses if not h.destroyed and h.team == 'allies')
        foes_houses   = sum(1 for h in self.houses if not h.destroyed and h.team == 'foes')

        if allies_alive == 0 and allies_houses == 0:
            self.is_battle_over = True
            self.battle_winner  = 'foes'
        elif foes_alive == 0 and foes_houses == 0:
            self.is_battle_over = True
            self.battle_winner  = 'allies'

    # ------------------------------------------------------------------
    # Pouvoirs divins (utilisables par les deux factions)
    # ------------------------------------------------------------------

    def _spend_mana(self, action: str, team: str) -> bool:
        cost = POWER_COSTS.get(action, 0.0)
        if self.power_jauge.get(team, 0.0) < cost:
            return False
        self.power_jauge[team] -= cost
        return True

    def raise_terrain(self, r: int, c: int, team: str = 'allies') -> bool:
        if not self._spend_mana('_raise_terrain', team):
            return False
        return self.game_map.raise_corner(r, c)

    def lower_terrain(self, r: int, c: int, team: str = 'allies') -> bool:
        if not self._spend_mana('_lower_terrain', team):
            return False
        return self.game_map.lower_corner(r, c)

    def _do_quake(self, r: int, c: int, team: str = 'allies') -> bool:
        if not self._spend_mana('_do_quake', team):
            return False
        self.game_map.do_quake(r, c)
        self._quake_timer  = 1.5
        self._quake_target = (r, c)
        return True

    def _do_flood(self, team: str = 'allies') -> bool:
        if not self._spend_mana('_do_flood', team):
            return False
        self.game_map.do_flood()
        return True

    def _do_volcano(self, r: int, c: int, team: str = 'allies') -> bool:
        if not self._spend_mana('_do_volcano', team):
            return False
        self.game_map.do_volcano(r, c)
        return True

    def _do_swamp(self, r: int, c: int, team: str = 'allies') -> bool:
        if not self._spend_mana('_do_swamp', team):
            return False
        self.game_map.do_swamp(r, c)
        return True

    def _do_knight(self, r: int, c: int, team: str = 'allies') -> bool:
        if not self._spend_mana('_do_knight', team):
            return False
        knight = Peep(r, c, self.game_map, team=team, is_knight=True)
        knight.set_command('_go_fight')
        self.peeps.append(knight)
        return True

    def _do_papal(self, r: int, c: int, team: str = 'allies') -> bool:
        if not self._spend_mana('_do_papal', team):
            return False
        self.papal_position[team] = (r, c)
        for p in self.peeps:
            if not p.dead and p.team == team:
                p.set_command('_go_papal', target=(r, c))
        return True

    def _do_shield(self, target, team: str = 'allies') -> bool:
        self.shield_target[team] = target
        if target is not None:
            target.has_shield = True
        return True

    def _battle_over(self, team: str = 'allies') -> bool:
        if not self._spend_mana('_battle_over', team):
            return False
        self.is_battle_over = True
        self.battle_winner  = team
        return True

    # ------------------------------------------------------------------
    # Commandes de peeps
    # ------------------------------------------------------------------

    def set_peep_command(self, command: str, team: str = 'allies', target=None) -> None:
        self.active_peep_command[team] = command
        if target is not None:
            self.active_peep_target_pos = target
        for p in self.peeps:
            if not p.dead and p.team == team:
                p.set_command(command, target=target)

    # ------------------------------------------------------------------
    # Statistiques
    # ------------------------------------------------------------------

    @property
    def population(self) -> dict[str, int]:
        return {
            'allies': sum(1 for p in self.peeps  if not p.dead  and p.team == 'allies'),
            'foes':   sum(1 for p in self.peeps  if not p.dead  and p.team == 'foes'),
        }

    @property
    def house_count(self) -> dict[str, int]:
        return {
            'allies': sum(1 for h in self.houses if not h.destroyed and h.team == 'allies'),
            'foes':   sum(1 for h in self.houses if not h.destroyed and h.team == 'foes'),
        }
