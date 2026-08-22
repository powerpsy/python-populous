"""
ai_player.py – Intelligence artificielle de l'adversaire (portage ASM Amiga).
Aucune dépendance pygame.
"""

from __future__ import annotations

import random


class AIPlayer:
    """
    Le joueur adverse (dieu rouge) qui joue automatiquement.
    Pilote le terrain, les pouvoirs et les commandes de ses peeps.
    """

    def __init__(self, game_state, team: str = 'foes'):
        self.game   = game_state
        self.team   = team

        # Intervalles entre actions (secondes)
        self.terrain_cooldown = 1.5
        self.power_cooldown   = 10.0
        self.command_cooldown = 15.0

        self._terrain_timer = 0.0
        self._power_timer   = 0.0
        self._command_timer = 0.0

    # ------------------------------------------------------------------
    # Configuration de la difficulté
    # ------------------------------------------------------------------

    def set_difficulty(self, reaction_speed: int = 5, command_rate: int = 5) -> None:
        """
        Configure la difficulté.
        reaction_speed : 0 (lent, 3 s) → 15 (rapide, 0.33 s)
        command_rate   : 0 (jamais)    → 15 (toutes les 5 s)
        """
        if reaction_speed <= 0:
            self.terrain_cooldown = 3.0
        else:
            self.terrain_cooldown = max(0.333, 3.0 - reaction_speed * 0.1778)

        if command_rate <= 0:
            self.command_cooldown = 999_999.0
        elif command_rate == 1:
            self.command_cooldown = 120.0
        else:
            self.command_cooldown = max(5.0, 120.0 - (command_rate - 1) * 8.214)

    # ------------------------------------------------------------------
    # Boucle de mise à jour
    # ------------------------------------------------------------------

    def update(self, dt: float) -> None:
        if getattr(self.game, 'is_battle_over', False):
            return

        self._terrain_timer += dt
        self._power_timer   += dt
        self._command_timer += dt

        if self._terrain_timer >= self.terrain_cooldown:
            self._terrain_timer = 0.0
            self._do_terrain_action()

        if self._power_timer >= self.power_cooldown:
            self._power_timer = 0.0
            self._do_power_action()

        if self._command_timer >= self.command_cooldown:
            self._command_timer = 0.0
            self._do_command_action()

    # ------------------------------------------------------------------
    # Actions terrain
    # ------------------------------------------------------------------

    def _do_terrain_action(self) -> None:
        """Aplanit une zone autour des maisons ou peeps adverses."""
        targets = []
        for h in self.game.game_map.houses:
            if not getattr(h, 'destroyed', False) and h.team == self.team:
                targets.append((h.r, h.c))
        for p in self.game.peeps:
            if not p.dead and p.team == self.team:
                targets.append((int(p.y), int(p.x)))

        if not targets:
            return

        r, c = random.choice(targets)
        game_map = self.game.game_map

        # Cherche à aplanir autour
        for dr in range(-2, 3):
            for dc in range(-2, 3):
                nr, nc = r + dr, c + dc
                if not (0 <= nr <= game_map.grid_height and 0 <= nc <= game_map.grid_width):
                    continue
                ref = game_map.get_corner(r, c)
                cur = game_map.get_corner(nr, nc)
                if cur == 0:
                    continue
                if cur < ref:
                    game_map.raise_corner(nr, nc)
                elif cur > ref:
                    game_map.lower_corner(nr, nc)

    # ------------------------------------------------------------------
    # Pouvoirs divins
    # ------------------------------------------------------------------

    def _do_power_action(self) -> None:
        """Utilise un pouvoir aléatoire si la jauge le permet."""
        game = self.game
        jauge = game.power_jauge.get(self.team, 0.0)
        if jauge < 20.0:
            return

        # Cible : centre de masse des alliés ennemis
        enemy_team = 'allies' if self.team == 'foes' else 'foes'
        enemies = [p for p in game.peeps if not p.dead and p.team == enemy_team]
        if not enemies:
            return

        target_r = int(sum(p.y for p in enemies) / len(enemies))
        target_c = int(sum(p.x for p in enemies) / len(enemies))

        # Choisir un pouvoir
        if jauge >= 100.0 and random.random() < 0.2:
            game._do_volcano(target_r, target_c, team=self.team)
        elif jauge >= 50.0 and random.random() < 0.3:
            game._do_quake(target_r, target_c, team=self.team)
        else:
            game._do_swamp(target_r, target_c, team=self.team)

    # ------------------------------------------------------------------
    # Commandes de peeps
    # ------------------------------------------------------------------

    def _do_command_action(self) -> None:
        """Change la commande des peeps adverses."""
        game      = self.game
        my_peeps  = [p for p in game.peeps if not p.dead and p.team == self.team]
        if not my_peeps:
            return

        enemy_team = 'allies' if self.team == 'foes' else 'foes'
        enemies    = [p for p in game.peeps if not p.dead and p.team == enemy_team]

        if enemies and random.random() < 0.4:
            # Attaque
            for p in my_peeps:
                p.set_command('_go_fight')
            game.active_peep_command[self.team] = '_go_fight'
        else:
            # Construction
            for p in my_peeps:
                p.set_command('_go_build')
            game.active_peep_command[self.team] = '_go_build'
