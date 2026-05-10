import random
import math

class AIPlayer:
    def __init__(self, game, team='foes'):
        self.game = game
        self.team = team
        
        # Paramètres de l'IA
        self.terrain_action_cooldown = 1.5  # Vitesse de réaction pour le terrain (secondes)
        self.terrain_timer = 0.0
        
        self.power_action_cooldown = 10.0  # Taux d'utilisation des pouvoirs (secondes)
        self.power_timer = 0.0
        
        self.command_cooldown = 15.0  # Changement de comportement des unités
        self.command_timer = 0.0

    def set_difficulty(self, reaction_speed=1.5, power_rate=10.0, command_rate=15.0):
        """Permet de configurer la difficulté de l'IA."""
        self.terrain_action_cooldown = reaction_speed
        self.power_action_cooldown = power_rate
        self.command_cooldown = command_rate

    def update(self, dt):
        self.terrain_timer += dt
        self.power_timer += dt
        self.command_timer += dt
        
        if self.terrain_timer >= self.terrain_action_cooldown:
            self.do_terrain_action()
            
        if self.power_timer >= self.power_action_cooldown:
            self.do_power_action()
            
        if self.command_timer >= self.command_cooldown:
            self.do_command_action()

    def do_terrain_action(self):
        self.terrain_timer = 0.0
        # 1. Identifier une zone où l'IA a besoin de terrain constructible
        # Pour simplifier, on cible autour des maisons ou des peeps de l'IA
        targets = []
        for house in self.game.game_map.houses:
            if not getattr(house, 'destroyed', False) and house.team == self.team:
                targets.append((house.r, house.c))
        
        for peep in self.game.peeps:
            if not peep.dead and peep.team == self.team:
                targets.append((int(peep.y), int(peep.x)))
                
        if not targets:
            return
            
        # Prendre une cible au hasard et regarder autour pour aplanir
        target_r, target_c = random.choice(targets)
        
        # Chercher une case voisine qui peut être nivelée
        best_diff = 100
        best_corner = None
        best_action = None # 'raise' or 'lower'
        
        for dr in range(-2, 3):
            for dc in range(-2, 3):
                r = target_r + dr
                c = target_c + dc
                if 0 <= r < self.game.game_map.grid_height and 0 <= c < self.game.game_map.grid_width:
                    # Estimer le besoin d'aplanir. On veut idéalement aplanir selon la surface moyenne
                    alt = self.game.game_map.get_corner_altitude(r, c)
                    # Évaluer la platitude locale
                    # Simplification: raise ou lower au hasard si on en a les moyens
                    if random.random() < 0.5:
                        cost = self.game.game_map.get_raise_cost(r, c)
                        if cost > 0 and self.game.power_jauge[self.team] >= cost:
                            best_corner = (r, c)
                            best_action = 'raise'
                            break
                    else:
                        cost = self.game.game_map.get_lower_cost(r, c)
                        if cost > 0 and self.game.power_jauge[self.team] >= cost:
                            best_corner = (r, c)
                            best_action = 'lower'
                            break

        if best_corner and best_action:
            r, c = best_corner
            cost = self.game.game_map.get_raise_cost(r, c) if best_action == 'raise' else self.game.game_map.get_lower_cost(r, c)
            if self.game.power_jauge[self.team] >= cost:
                self.game.power_jauge[self.team] -= cost
                if best_action == 'raise':
                    self.game.game_map.raise_corner(r, c)
                else:
                    self.game.game_map.lower_corner(r, c)

    def do_power_action(self):
        self.power_timer = 0.0
        # Utilisation des pouvoirs (do_papal, flood, volcano, quake, knight)
        actions = ['_do_quake', '_do_swamp', '_do_volcano', '_do_flood']
        
        # Filtrer en fonction du coût énergétique par rapport à la jauge max
        # On suppose que l'IA économise
        valid_actions = []
        for action in actions:
            cost = self.game.POWER_COSTS.get(action, 9999)
            if self.game.power_jauge[self.team] >= cost:
                valid_actions.append(action)
                
        if not valid_actions:
            return
            
        action = random.choice(valid_actions)
        
        # Cible aléatoire: trouver un bâtiment ou peep ennemi (allies)
        targets = []
        for house in self.game.game_map.houses:
            if not getattr(house, 'destroyed', False) and getattr(house, 'team', 'allies') != self.team:
                targets.append((house.r, house.c))
        for peep in self.game.peeps:
            if not getattr(peep, 'dead', True) and getattr(peep, 'team', 'allies') != self.team:
                targets.append((int(peep.y), int(peep.x)))
                
        if action in ['_do_quake', '_do_swamp', '_do_volcano']:
             if not targets:
                 return
             r, c = random.choice(targets)
             
             cost = self.game.POWER_COSTS.get(action, 9999)
             if self.game.power_jauge[self.team] >= cost:
                 self.game.power_jauge[self.team] -= cost
                 if action == '_do_quake':
                     self.game.quake_timer = 2.0
                     self.game.quake_target = (r, c)
                     self.game.play_sound('do_quake')
                     print(f"IA [{self.team}]: déclenche Tremblement de Terre en ({r}, {c})")
                 elif action == '_do_swamp':
                     self.game.game_map.do_swamp(r, c)
                     self.game.play_sound('swamp')
                     print(f"IA [{self.team}]: déclenche Marécage en ({r}, {c})")
                 elif action == '_do_volcano':
                     self.game.game_map.do_volcano(r, c)
                     self.game.play_sound('do_volcano')
                     print(f"IA [{self.team}]: déclenche Volcan en ({r}, {c})")
                     
        elif action == '_do_flood':
            cost = self.game.POWER_COSTS.get('_do_flood', 500)
            if self.game.power_jauge[self.team] >= cost:
                self.game.power_jauge[self.team] -= cost
                self.game.game_map.do_flood()
                self.game.play_sound('do_flood')
                print(f"IA [{self.team}]: déclenche Déluge !")

    def do_command_action(self):
        self.command_timer = 0.0
        # Choisir un comportement pour les peeps de l'IA
        # On va basculer entre _go_build, _go_assemble, _go_fight
        actions = ['_go_build', '_go_assemble', '_go_fight', '_go_papal']
        chosen = random.choices(
            actions,
            weights=[60, 20, 15, 5],
            k=1
        )[0]
        
        self.game.active_peep_command[self.team] = chosen
        if chosen == '_go_papal':
            self.game.active_peep_target[self.team] = self.game.papal_position[self.team]
        else:
            self.game.active_peep_target[self.team] = None
            
        print(f"IA [{self.team}]: change comportement pour {chosen}.")

        # Mise a jour des peeps existants
        for peep in self.game.peeps:
            if not peep.dead and peep.team == self.team:
                peep.set_command(self.game.active_peep_command[self.team], self.game.active_peep_target[self.team])
