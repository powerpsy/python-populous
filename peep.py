import pygame
import numpy as np
import random
import math
from settings import *

SPRITE_EXTRACT_SIZE = 16  # Taille dans le spritesheet source


def load_sprite_surfaces():
    """Charge le sprite sheet et découpe les sprites 16x16 selon un format fixe (AmigaSprites)."""
    sheet_raw = pygame.image.load(SPRITES_PATH).convert()
    
    # Fond vert transparent Amiga
    sheet_raw.set_colorkey((0, 49, 0))
    sheet = sheet_raw.convert_alpha()

    start_x, start_y = 11, 10
    stride_x, stride_y = 20, 20
    
    x_starts = [start_x + i * stride_x for i in range(16)]
    y_starts = [start_y + j * stride_y for j in range(9)]
    
    sprites = {}
    for r, y0 in enumerate(y_starts):
        for c, x0 in enumerate(x_starts):
            try:
                sub = sheet.subsurface(pygame.Rect(x0, y0, SPRITE_EXTRACT_SIZE, SPRITE_EXTRACT_SIZE)).copy()
            except ValueError:
                continue

            # Supprimer le fond noir résiduel → transparent
            arr = pygame.surfarray.pixels3d(sub)
            alpha = pygame.surfarray.pixels_alpha(sub)
            mask = ((arr[:, :, 0] == 0) & (arr[:, :, 1] == 0) & (arr[:, :, 2] == 0))
            alpha[mask] = 0
            del arr, alpha  # libérer les locks surfarray

            sub = pygame.transform.scale(sub, (SPRITE_SIZE, SPRITE_SIZE))

            sprites[(r, c)] = sub

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
    'N':      [(0,  0), (0,  1)],
    'NE':     [(0,  2), (0,  3)],
    'E':      [(0,  4), (0,  5)],
    'SE':     [(0,  6), (0,  7)],
    'S':      [(0,  8), (0,  9)],
    'SW':     [(0, 10), (0, 11)],
    'W':      [(0, 12), (0, 13)],
    'NW':     [(0, 14), (0, 15)],
    'IDLE':   [(0,  8), (0,  9)],
    'WAIT':   [(6,  0), (6,  1)],
    'DROWN':  [(5,  8), (5,  9), (5, 10), (5, 11)],
}

# directions: (1,0) à (1,15)
# drowning: (5,12) à (5,15)
# waiting: (6,2) et (6,3)
FOE_WALK_FRAMES = {
    'N':      [(1,  0), (1,  1)],
    'NE':     [(1,  2), (1,  3)],
    'E':      [(1,  4), (1,  5)],
    'SE':     [(1,  6), (1,  7)],
    'S':      [(1,  8), (1,  9)],
    'SW':     [(1, 10), (1, 11)],
    'W':      [(1, 12), (1, 13)],
    'NW':     [(1, 14), (1, 15)],
    'IDLE':   [(1,  8), (1,  9)],
    'WAIT':   [(6,  2), (6,  3)],
    'DROWN':  [(5, 12), (5, 13), (5, 14), (5, 15)],
}

BATTLE_FRAMES = [(4, 4), (4, 5), (4, 6), (4, 7)]
VICTORY_ALLIE_BEFORE = [(0, 8), (0, 9)] # Petite animation sur place 0.2s
VICTORY_ALLIE_MAIN = [(5, 0), (5, 1), (5, 2), (5, 3)] # Anim victoire 0.5s
VICTORY_FOE_BEFORE = [(1, 8), (1, 9)]
VICTORY_FOE_MAIN = [(5, 4), (5, 5), (5, 6), (5, 7)]

KNIGHT_FRAMES = {
    'N':      [(2,  0), (2,  1)],
    'NE':     [(2,  2), (2,  3)],
    'E':      [(2,  4), (2,  5)],
    'SE':     [(2,  6), (2,  7)],
    'S':      [(2,  8), (2,  9)],
    'SW':     [(2, 10), (2, 11)],
    'W':      [(2, 12), (2, 13)],
    'NW':     [(2, 14), (2, 15)],
    'IDLE':   [(2,  8), (2,  9)],
    'WAIT':   [(7,  8), (7,  9)],
    'DROWN':  [(6,  8), (6,  9), (6, 10), (6, 11)],
}

BATTLE_KNIGHT_FOE = [(7, 12), (7, 13), (7, 14), (7, 15)]
BATTLE_KNIGHT_KNIGHT = [(8, 4), (8, 5), (8, 6), (8, 7)]
VICTORY_KNIGHT = [(7, 0), (7, 1), (7, 2), (7, 3)]

# Export pour usage externe
PEEP_WALK_FRAMES = WALK_FRAMES


class Peep:
    _sprites = None

    @classmethod
    def get_sprites(cls):
        if cls._sprites is None:
            cls._sprites = load_sprite_surfaces()
        return cls._sprites

    # États possibles pour la machine à états
    STATE_WANDER = 'wander'
    STATE_BUILD = 'build'
    STATE_ASSEMBLE = 'assemble'
    STATE_PAPAL = 'papal'
    STATE_FIGHT = 'fight'
    STATE_WAIT_FOR_ENEMY = 'wait_for_enemy'
    STATE_CHARGE_ENEMY = 'charge_enemy'
    STATE_BATTLE = 'battle'
    STATE_VICTORY_BEFORE = 'victory_before'
    STATE_VICTORY_MAIN = 'victory_main'

    def __init__(self, grid_r, grid_c, game_map, team='allies'):
        self.x = grid_c + 0.5
        self.y = grid_r + 0.5
        self.game_map = game_map
        self.team = team
        self.life = 50
        self.dead = False
        self.death_timer = 0.0
        self.move_timer = 0.0
        self.dir_timer = 0.0
        self.direction = random.uniform(0, 2 * math.pi)
        self.build_timer = 0.0
        self.anim_timer = 0.0
        self.anim_frame = 0
        self.facing = 'IDLE'
        self.is_moving = False
        self.energy_yellow = 0   # barres jaunes restantes
        self.energy_orange = 1.0  # fraction de la barre orange courante (0→1)
        self.in_house = False
        self.weapon_type = 'hut' # Arme de départ : arme 0 (hut)
        # Momentum pour l'exploration (direction préférée)
        self.momentum_dir = random.choice([(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)])
        self.momentum_steps = random.randint(3, 8)
        # Machine à états
        self.state = Peep.STATE_WANDER
        self.state_target = None  # (r, c) ou None
        self.state_timer = 0.0
        # Mouvement tuile à tuile
        self.tile_from = (int(self.y), int(self.x))
        self.tile_to = (int(self.y), int(self.x))
        self.move_progress = 1.0  # 1.0 = sur la tuile cible
        # Historique des positions pour éviter les oscillations
        self.path_history = [(int(self.y), int(self.x))] * 4
        self.just_swamped = False
        # Pour l'assemble par paire
        self.assemble_role = None  # 'donneur', 'receveur', ou None
        self.assemble_partner = None  # référence vers le partenaire
        self.has_shield = False
        self.is_leader = False
        self.is_knight = False
        self.merged_leader = False
        self.in_house_leader = False
        self.battle_partner = None

    def set_command(self, command, target=None):
        """Change l'état du peep selon la commande reçue."""
        if getattr(self, 'is_knight', False):
            # Un chevalier reste imperturbablement en mode _go_fight
            command = '_go_fight'
            target = None
        
        # On réinitialise le timer de build lors d'un changement de commande pour ne pas build instantanément
        self.build_timer = 0.0
        
        if command == '_go_build':
            self.state = Peep.STATE_BUILD
            self.state_target = None
            self.assemble_role = None
            self.assemble_partner = None
        elif command == '_go_assemble':
            self.state = Peep.STATE_ASSEMBLE
            self.state_target = target
            # Attribution des rôles par paire (doit être fait sur tous les peeps)
            if hasattr(self.game_map, 'peeps'):
                peeps = [p for p in self.game_map.peeps if not p.dead and p.team == self.team]
                peeps.sort(key=lambda p: id(p))
                for i, p in enumerate(peeps):
                    p.assemble_role = 'receveur' if i % 2 == 0 else 'donneur'
                    # Associer le partenaire
                    if i % 2 == 0 and i + 1 < len(peeps):
                        p.assemble_partner = peeps[i + 1]
                        peeps[i + 1].assemble_partner = p
                    elif i % 2 == 1:
                        # Le donneur a déjà reçu son partenaire
                        continue
                    else:
                        # Dernier peep sans paire
                        p.assemble_partner = None
        elif command == '_go_papal':
            self.state = Peep.STATE_PAPAL
            self.state_target = target
            self.assemble_role = None
            self.assemble_partner = None
        elif command == '_go_fight':
            self.state = Peep.STATE_FIGHT
            self.state_target = target
            self.assemble_role = None
            self.assemble_partner = None
            # Logique d'appairage pour le combat uniquement pour l'équipe ALLIÉE
            # NOTE: On ne force plus Peep.STATE_CHARGE_ENEMY ici pour tous les alliés,
            # car si un allié n'a pas d'ennemi à portée raisonnable, il s'arrête.
            # On laisse le mode STATE_FIGHT gérer la recherche de cibles globales.
        else:
            self.state = Peep.STATE_WANDER
            self.state_target = None
            self.assemble_role = None
            self.assemble_partner = None
        self.state_timer = 0.0

    def _choose_next_tile(self):
        """Choix de la prochaine tuile selon l'état du peep, avec floodfill local et retour possible sur ancienne case."""
        r0, c0 = int(self.y), int(self.x)

        if self.state == Peep.STATE_BUILD:
            # go_build : exploration pour trouver de nouvelles opportunités
            directions = [(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)]
            
            # --- Scan local pour opportunité immédiate d'urbanisation ---
            # Si on détecte du terrain plat VIERGE à côté, on interrompt le voyage.
            # Si on détecte du terrain plat VIERGE à côté, on interrompt le voyage.
            best_local_score = -1
            best_local_tile = None
            
            for dr, dc in directions:
                nr, nc = r0 + dr, c0 + dc
                if 0 <= nr < self.game_map.grid_height and 0 <= nc < self.game_map.grid_width:
                    if self.game_map.get_corner_altitude(nr, nc) > 0 and (nr, nc) not in self.path_history:
                        score, _ = self.game_map.get_flat_area_score(nr, nc, current_house=None)
                        if score > 5: # Seuil d'intérêt : s'il y a au moins un peu de plat
                            # Vérifier si c'est déjà trop proche d'une maison
                            too_close = False
                            for h in self.game_map.houses:
                                if max(abs(h.r - nr), abs(h.c - nc)) < 3: # Distance Chebyshev
                                    too_close = True
                                    break
                            if not too_close and score > best_local_score:
                                best_local_score = score
                                best_local_tile = (nr, nc)
            
            if best_local_tile:
                # On réinitialise un momentum court vers cette opportunité
                self.momentum_dir = (best_local_tile[0] - r0, best_local_tile[1] - c0)
                self.momentum_steps = 2
                return best_local_tile

            # Filtrage des cases valides
            valid = []
            for dr, dc in directions:
                nr, nc = r0 + dr, c0 + dc
                if 0 <= nr < self.game_map.grid_height and 0 <= nc < self.game_map.grid_width:
                    alt = self.game_map.get_corner_altitude(nr, nc)
                    if alt > 0:
                        valid.append((nr, nc))
            
            if not valid:
                return (r0, c0)

            # Gestion du momentum ( Exploration Forcée )
            target_r, target_c = r0 + self.momentum_dir[0], c0 + self.momentum_dir[1]
            
            # Si le momentum nous mène vers une case valide et qu'on a encore des steps
            if (target_r, target_c) in valid and self.momentum_steps > 0:
                self.momentum_steps -= 1
                return (target_r, target_c)
            else:
                # Changer de direction de momentum
                # On augmente les pas du momentum pour forcer le voyage longue distance (5 à 15 pas)
                self.momentum_steps = random.randint(5, 15)
                
                # On filtre l'historique récent pour éviter les oscillations
                exploratory = [v for v in valid if v not in self.path_history]
                
                if not exploratory:
                    exploratory = [v for v in valid if v != (r0, c0)] or valid
                
                # Biais stratégique : on combine le score de platitude avec un "sens de l'espace"
                # On préfère aller vers des cases qui ne sont pas DÉJÀ occupées par des maisons
                scored_exploratory = []
                for v in exploratory:
                    score, _ = self.game_map.get_flat_area_score(v[0], v[1], current_house=None)
                    
                    # Bonus d'exploration : si la case est loin des maisons existantes, on augmente le poids
                    house_proximity_penalty = 0
                    for h in self.game_map.houses:
                        dist = max(abs(h.r - v[0]), abs(h.c - v[1]))
                        if dist < 4:
                            house_proximity_penalty += 5
                    
                    weight = max(1, (score + 10) - house_proximity_penalty)
                    scored_exploratory.extend([v] * weight)
                
                next_tile = random.choice(scored_exploratory)
                self.momentum_dir = (next_tile[0] - r0, next_tile[1] - c0)
                return next_tile

        elif self.state in (Peep.STATE_ASSEMBLE, Peep.STATE_PAPAL, Peep.STATE_FIGHT, Peep.STATE_CHARGE_ENEMY, Peep.STATE_WAIT_FOR_ENEMY):
            # magnet logic
            if self.state == Peep.STATE_WAIT_FOR_ENEMY:
                return (r0, c0)

            if self.state == Peep.STATE_CHARGE_ENEMY and self.battle_partner:
                tr, tc = int(self.battle_partner.y), int(self.battle_partner.x)
            elif self.state == Peep.STATE_ASSEMBLE and self.assemble_partner and not self.assemble_partner.dead:
                # Si on est le RECEVEUR, on s'arrête pour attendre le DONNEUR
                if self.assemble_role == 'receveur':
                    return (r0, c0)
                
                # Sinon on est le DONNEUR, on se dirige vers le partenaire.
                tr, tc = int(self.assemble_partner.y), int(self.assemble_partner.x)
            elif self.state == Peep.STATE_FIGHT:
                # magnet to enemy peep OR enemy house
                target = None
                min_dist = float('inf')
                if hasattr(self.game_map, 'peeps'):
                    # Chercher le peep ennemi le plus proche
                    for other in self.game_map.peeps:
                        if not other.dead and other.team != self.team:
                            dist = math.hypot(other.x - self.x, other.y - self.y)
                            if dist < min_dist:
                                min_dist = dist
                                target = (int(other.y), int(other.x))
                    
                    # Chercher aussi le bâtiment ennemi le plus proche
                    for house in self.game_map.houses:
                        if not house.destroyed and house.team != self.team:
                            # Distance au centre du bâtiment
                            dist = math.hypot(house.c + 0.5 - self.x, house.r + 0.5 - self.y)
                            if dist < min_dist:
                                min_dist = dist
                                target = (house.r, house.c)
                
                if target:
                    tr, tc = target
                else:
                    # NOUVEAU : Si aucun ennemi n'est trouvé, on se comporte comme en mode WANDER/BUILD
                    # On repasse temporairement l'état à BUILD pour réutiliser sa logique de mouvement
                    old_state = self.state
                    self.state = Peep.STATE_BUILD
                    next_tile = self._choose_next_tile()
                    self.state = old_state
                    return next_tile
            else:
                tr, tc = self.state_target if self.state_target else (r0, c0)

            # --- CORRECTION PATHFINDING MAGNÉTIQUE ---
            # Si on est déjà à côté de la cible, on y va directement (pour ASSEMBLE, CHARGE, FIGHT, PAPAL)
            if abs(tr - r0) <= 1 and abs(tc - c0) <= 1:
                return (tr, tc)

            # Recherche de la meilleure direction (plus proche de la cible)
            directions = [(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)]
            best_dist = float('inf')
            best_tile = (r0, c0)
            
            for dr, dc in directions:
                nr, nc = r0 + dr, c0 + dc
                if 0 <= nr < self.game_map.grid_height and 0 <= nc < self.game_map.grid_width:
                    alt = self.game_map.get_corner_altitude(nr, nc)
                    if alt > 0:
                        dist = math.hypot(nc - tc, nr - tr)
                        if dist < best_dist:
                            best_dist = dist
                            best_tile = (nr, nc)
            return best_tile

        else:
            # WANDER (Promenade)
            directions = [(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)]
            valid = [(r0+dr, c0+dc) for dr, dc in directions 
                     if 0 <= r0+dr < self.game_map.grid_height 
                     and 0 <= c0+dc < self.game_map.grid_width 
                     and self.game_map.get_corner_altitude(r0+dr, c0+dc) > 0]
            
            if not valid:
                return (r0, c0)

            # En WANDER ou BUILD, on autorise la traversée des zones d'influence
            # pour éviter que les peeps ne soient piégés et puissent coloniser plus loin.
            candidates = valid

            # Même logique de momentum en WANDER pour explorer la carte globalement
            target_r, target_c = r0 + self.momentum_dir[0], c0 + self.momentum_dir[1]
            if (target_r, target_c) in candidates and self.momentum_steps > 0:
                self.momentum_steps -= 1
                return (target_r, target_c)
            else:
                self.momentum_steps = random.randint(5, 15)
                # On filtre l'historique récent pour forcer l'exploration
                exploratory = [v for v in candidates if v not in self.path_history]
                if not exploratory:
                    exploratory = [v for v in candidates if v != (r0, c0)] or candidates
                
                next_tile = random.choice(exploratory)
                self.momentum_dir = (next_tile[0] - r0, next_tile[1] - c0)
                return next_tile

    def _update_state(self, dt):
        """Met à jour l'état selon la machine à états et agit en conséquence."""
        if self.move_progress < 1.0:
            return  # En déplacement, rien à faire

        # Gestion des états de bataille et victoire
        if self.state == Peep.STATE_BATTLE:
            self.state_timer += dt
            # Diminution rapide de la santé
            # On perd par exemple 50 points de vie par seconde en bataille
            self.life -= dt * 50.0
            
            # Vérifier si la bataille est finie
            if self.life <= 0:
                self.life = 0
                self.dead = True
                if self.battle_partner and not self.battle_partner.dead:
                    # Le partenaire gagne
                    self.battle_partner.state = Peep.STATE_VICTORY_BEFORE
                    self.battle_partner.state_timer = 0.0
                return

            if self.battle_partner and (self.battle_partner.dead or self.battle_partner.in_house):
                # Le partenaire est mort ou a disparu, on gagne
                self.state = Peep.STATE_VICTORY_BEFORE
                self.state_timer = 0.0
                return
            return # En bataille, on ne fait rien d'autre

        elif self.state == Peep.STATE_VICTORY_BEFORE:
            self.state_timer += dt
            if self.state_timer >= 0.2:
                self.state = Peep.STATE_VICTORY_MAIN
                self.state_timer = 0.0
            return

        elif self.state == Peep.STATE_VICTORY_MAIN:
            self.state_timer += dt
            if self.state_timer >= 0.5:
                # Retour au wander après la victoire
                self.state = Peep.STATE_WANDER
                self.state_timer = 0.0
                self.battle_partner = None
            return

        # Le mouvement est terminé (move_progress >= 1.0)
        # On enregistre la position actuelle dans l'historique pour éviter les oscillations
        current_pos = (int(self.y), int(self.x))
        if not self.path_history or self.path_history[0] != current_pos:
            self.path_history.insert(0, current_pos)
            if len(self.path_history) > 4:
                self.path_history.pop()

        elif self.state == Peep.STATE_ASSEMBLE:
            if self.assemble_partner and not self.assemble_partner.dead:
                # Si on est très proches, on fusionne immédiatement
                # On utilise la distance euclidienne car on veut une capture "au vol"
                dist = math.hypot(self.assemble_partner.x - self.x, self.assemble_partner.y - self.y)
                
                # Tolérance augmentée à 0.6 pour que la fusion se produise dès que les sprites se touchent
                if dist < 0.6:
                    # Le donneur fusionne dans le receveur
                    if self.assemble_role == 'donneur':
                        self.assemble_partner.life = min(0x7D00, self.assemble_partner.life + self.life)
                        # Transfert du shield au receveur si l'un des deux l'avait
                        if self.has_shield or getattr(self.assemble_partner, 'has_shield', False):
                            self.assemble_partner.has_shield = True
                            self.has_shield = False # UNICITÉ : le donneur perd son shield
                        if getattr(self, 'is_leader', False) or getattr(self.assemble_partner, 'is_leader', False):
                            self.assemble_partner.is_leader = True
                            self.merged_leader = getattr(self, 'is_leader', False)
                            self.is_leader = False
                        self.life = 0
                        self.dead = True
                        # Si le partenaire était aussi donneur (cas rare de réassignation), on force le rôle
                        self.assemble_partner.assemble_role = 'receveur'
                        return 
                else:
                    # Si on est encore loin, on continue à se diriger vers lui
                    pass
            else:
                # Partenaire perdu ou mort, on repasse en WANDER
                self.state = Peep.STATE_WANDER
                self.assemble_partner = None
                self.assemble_role = None
            if hasattr(self.game_map, 'peeps'):
                for other in self.game_map.peeps:
                    if other is not self and not other.dead:
                        if int(other.x) == int(self.x) and int(other.y) == int(self.y):
                            self.life += other.life * 0.2
                            other.life = 0
                            other.dead = True
                            break

        self.tile_from = (int(self.y), int(self.x))
        self.tile_to = self._choose_next_tile()
        
        # Correction : Si on commence à attendre sur une tuile d'eau, on force le naufrage immédiatement
        # en ne permettant plus de mouvement (move_progress reste à 1.0)
        gr_cur, gc_cur = int(self.y), int(self.x)
        if (0 <= gr_cur < self.game_map.grid_height and 0 <= gc_cur < self.game_map.grid_width):
            a0 = self.game_map.get_corner_altitude(gr_cur,     gc_cur)
            a1 = self.game_map.get_corner_altitude(gr_cur,     gc_cur + 1)
            a2 = self.game_map.get_corner_altitude(gr_cur + 1, gc_cur + 1)
            a3 = self.game_map.get_corner_altitude(gr_cur + 1, gc_cur)
            if a0 == 0 and a1 == 0 and a2 == 0 and a3 == 0:
                self.tile_to = (gr_cur, gc_cur)

        self.move_progress = 0.0 if self.tile_to != self.tile_from else 1.0


    def update(self, dt):
        # Gestion de la machine à états
        if self.dead:
            self.death_timer += dt
            return

        # Vérification du contact de combat (déclenché depuis populous.py)
        if self.state == Peep.STATE_CHARGE_ENEMY:
            if self.battle_partner and not self.battle_partner.dead:
                dist = math.hypot(self.battle_partner.x - self.x, self.battle_partner.y - self.y)
                
                # Dynamic Wait: Si l'allié est proche (ex: < 2 cases), on demande à l'ennemi d'attendre
                if dist < 2.0 and self.battle_partner.state not in (Peep.STATE_BATTLE, Peep.STATE_VICTORY_BEFORE, Peep.STATE_VICTORY_MAIN, Peep.STATE_WAIT_FOR_ENEMY):
                    self.battle_partner.state = Peep.STATE_WAIT_FOR_ENEMY
                    self.battle_partner.battle_partner = self
                    self.battle_partner.move_progress = 1.0

                if dist < 0.6:
                    self.state = Peep.STATE_BATTLE
                    self.state_timer = 0.0
                    self.move_progress = 1.0
                    self.battle_partner.state = Peep.STATE_BATTLE
                    self.battle_partner.state_timer = 0.0
                    self.battle_partner.move_progress = 1.0
            else:
                self.state = Peep.STATE_WANDER
                self.battle_partner = None

        # Détecter si le peep est sur une tile eau (les 4 coins de la tile à 0)
        gr_cur, gc_cur = int(self.y), int(self.x)
        if (0 <= gr_cur < self.game_map.grid_height and 0 <= gc_cur < self.game_map.grid_width):
            a0 = self.game_map.get_corner_altitude(gr_cur,     gc_cur)
            a1 = self.game_map.get_corner_altitude(gr_cur,     gc_cur + 1)
            a2 = self.game_map.get_corner_altitude(gr_cur + 1, gc_cur + 1)
            a3 = self.game_map.get_corner_altitude(gr_cur + 1, gc_cur)
            on_water = (a0 == 0 and a1 == 0 and a2 == 0 and a3 == 0)
            
            # --- DÉTECTION SWAMP ---
            if (gr_cur, gc_cur) in self.game_map.swamps and not self.dead:
                self.dead = True
                self.death_timer = 0
                self.just_swamped = True
                return
        else:
            on_water = False

        # Perte de vie : 1 point par seconde (plus rapide dans l'eau ?)
        # Si on est dans l'eau (on_water), on meurt beaucoup plus vite (noyade active)
        self.life -= dt * (25.0 if on_water else 1.0)
        if self.life <= 0:
            self.life = 0
            self.dead = True
            return

        self.anim_timer += dt

        # Mouvement tuile à tuile
        if on_water:
            # Si on coule, on ne bouge plus et on annule tout mouvement en cours
            self.move_progress = 1.0
            self.tile_to = self.tile_from = (gr_cur, gc_cur)
        elif self.move_progress < 1.0:
            speed = PEEP_SPEED * dt / 64.0
            self.move_progress += speed
            if self.move_progress >= 1.0:
                self.move_progress = 1.0
                self.x = self.tile_to[1] + 0.5
                self.y = self.tile_to[0] + 0.5
                
                # NOUVEAU : Si on arrive sur une tuile avec un bâtiment ALLIÉ, on rentre dedans
                # Condition : état WANDER et on n'est pas sur l'eau
                if self.state == Peep.STATE_WANDER:
                    gr, gc = int(self.y), int(self.x)
                    for h in self.game_map.houses:
                        if not h.destroyed and (gr, gc) in h.occupied_tiles:
                            if h.team == self.team:
                                # Entrer dans le bâtiment : on ajoute notre vie au bâtiment
                                h.life = min(h.max_life, h.life + self.life)
                                # On transfère le shield si on l'a
                                if self.has_shield:
                                    h.has_shield = True
                                if self.is_leader:
                                    h.has_leader = True
                                    self.in_house_leader = True
                                self.life = 0
                                self.dead = True
                                self.in_house = True
                                break
                
                # NOUVEAU : Fusion immédiate avec les alliés sur la même case lors du mouvement
                # (Sauf si on est déjà en train de mourir ou en bataille)
                if not self.dead and self.state not in (Peep.STATE_BATTLE, Peep.STATE_VICTORY_BEFORE, Peep.STATE_VICTORY_MAIN):
                    gr, gc = int(self.y), int(self.x)
                    if hasattr(self.game_map, 'peeps'):
                        for other in self.game_map.peeps:
                            if other is not self and not other.dead and other.team == self.team:
                                # Si sur la même case et que l'un des deux accepte la fusion (préférence pour le plus fort garde la vie)
                                if int(other.y) == gr and int(other.x) == gc:
                                    # Détermination de qui donne et qui reçoit
                                    donor = None
                                    receiver = None
                                    
                                    # Le leader est prioritaire pour recevoir
                                    if self.is_leader and not other.is_leader:
                                        donor = other
                                        receiver = self
                                    elif other.is_leader and not self.is_leader:
                                        donor = self
                                        receiver = other
                                    else:
                                        # Sinon, résolution par ID pour éviter les fusions annulées
                                        if id(self) < id(other):
                                            donor = self
                                            receiver = other

                                    # On n'applique la fusion que depuis le point de vue du donneur
                                    if donor is self:
                                        receiver.life = min(0x7D00, receiver.life + self.life)
                                        if self.has_shield:
                                            receiver.has_shield = True
                                        if self.is_leader:
                                            receiver.is_leader = True
                                            self.merged_leader = True
                                        self.life = 0
                                        self.dead = True
                                        break
            else:
                # Interpolation linéaire
                y0, x0 = self.tile_from
                y1, x1 = self.tile_to
                self.x = x0 + 0.5 + (x1 - x0) * self.move_progress
                self.y = y0 + 0.5 + (y1 - y0) * self.move_progress
        else:
            self._update_state(dt)

        # Détecter si le peep est sur une tile eau (les 4 coins de la tile à 0)
        gr_cur, gc_cur = int(self.y), int(self.x)
        if (0 <= gr_cur < self.game_map.grid_height and 0 <= gc_cur < self.game_map.grid_width):
            a0 = self.game_map.get_corner_altitude(gr_cur,     gc_cur)
            a1 = self.game_map.get_corner_altitude(gr_cur,     gc_cur + 1)
            a2 = self.game_map.get_corner_altitude(gr_cur + 1, gc_cur + 1)
            a3 = self.game_map.get_corner_altitude(gr_cur + 1, gc_cur)
            on_water = (a0 == 0 and a1 == 0 and a2 == 0 and a3 == 0)
        else:
            on_water = False

        # Animation :
        if on_water:
            if not hasattr(self, '_drown_anim_idx'):
                self._drown_anim_idx = 0
            if self.anim_timer > 0.18:
                self.anim_timer -= 0.18
                self._drown_anim_idx = (self._drown_anim_idx + 1) % 4
            self.anim_frame = self._drown_anim_idx
        elif self.state == Peep.STATE_BATTLE:
            if self.anim_timer > 0.1:
                self.anim_timer -= 0.1
                self.anim_frame = (self.anim_frame + 1) % 4
        elif self.state == Peep.STATE_VICTORY_BEFORE:
            if self.anim_timer > 0.1:
                self.anim_timer -= 0.1
                self.anim_frame = (self.anim_frame + 1) % 2
        elif self.state == Peep.STATE_VICTORY_MAIN:
            if self.anim_timer > 0.125: # 0.5s / 4 frames
                self.anim_timer -= 0.125
                self.anim_frame = (self.anim_frame + 1) % 4
        elif self.state == Peep.STATE_WAIT_FOR_ENEMY:
            if self.anim_timer > 0.3:
                self.anim_timer -= 0.3
                self.anim_frame = (self.anim_frame + 1) % 2
        else:
            if self.anim_timer > 0.3:
                self.anim_timer -= 0.3
                self.anim_frame = (self.anim_frame + 1) % 2

        # Mettre à jour la direction visuelle (8 directions)
        if on_water:
            self.facing = 'DROWN'
        elif self.move_progress < 1.0:
            # Direction du mouvement
            y0, x0 = self.tile_from
            y1, x1 = self.tile_to
            dx = x1 - x0
            dy = y1 - y0
            screen_dx = (dx - dy) * TILE_HALF_W
            screen_dy = (dx + dy) * TILE_HALF_H
            angle = math.degrees(math.atan2(screen_dy, screen_dx)) % 360
            dirs = ['E', 'SE', 'S', 'SW', 'W', 'NW', 'N', 'NE']
            self.facing = dirs[int((angle + 22.5) / 45) % 8]
        else:
            if self.state == Peep.STATE_ASSEMBLE and self.assemble_role == 'receveur':
                self.facing = 'WAIT'
            else:
                self.facing = 'IDLE'

        # Construction
        self.build_timer += dt

    def try_build_house(self):
        # NOUVEAU : En mode PAPAL (ou tout autre mode sauf WANDER/BUILD), on ne construit pas
        if self.state != self.STATE_BUILD and self.state != self.STATE_WANDER:
            return None

        # On réduit le timer de build pour plus de réactivité si on est sur une bonne case
        gr, gc = int(self.y), int(self.x)
        score_normal, _ = self.game_map.get_flat_area_score(gr, gc, current_house=None, is_castle=False)
        
        # Si on est sur une case constructible, on build plus vite (2s au lieu de 5s)
        effective_build_limit = 2.0 if score_normal >= 0 else 5.0
        
        if self.build_timer < effective_build_limit:
            return None

        # gr, gc = int(self.y), int(self.x) # déjà fait plus haut
        
        # 1. On regarde d'abord si on peut faire un Castle (besoin de la zone d'influence complète 5x5)
        is_castle_potential, valid_tiles_castle = self.game_map.get_flat_area_score(gr, gc, current_house=None, is_castle=True)
        # 2. On regarde pour les maisons normales (zone influence 16 cases)
        score_normal, valid_tiles_normal = self.game_map.get_flat_area_score(gr, gc, current_house=None, is_castle=False)
        
        house_present = any((gr, gc) in getattr(h, 'occupied_tiles', [(h.r, h.c)]) for h in self.game_map.houses)
        
        from house import House
        thresholds = [0, 1, 3, 5, 7, 9, 11, 12, 14, 16]
        
        if is_castle_potential >= 24: # Score 24 = toutes les cases du 5x5 sont valides
            max_tier = len(House.TYPES) - 1
            valid_tiles = valid_tiles_castle
            score = 24
        else:
            max_tier = 0
            for i, thresh in enumerate(thresholds):
                if score_normal >= thresh:
                    max_tier = i
            valid_tiles = valid_tiles_normal
            score = score_normal

        max_tier = min(len(House.TYPES) - 1, max_tier)
        building_type = House.TYPES[max_tier]
        # Affichage debug
        # print(f"[DEBUG] Peep({gr},{gc}) flat score={score}, valid_tiles={len(valid_tiles)}, house_present={int(house_present)}, life={int(self.life)}, BUILT '{building_type if self.game_map.can_place_house_initial(gr, gc) else ''}'")
        if self.game_map.can_place_house_initial(gr, gc):
            self.build_timer = 0.0
            max_life = House.MAX_HEALTHS[max_tier]
            house = House(gr, gc, life=min(self.life, max_life), team=self.team)
            
            # Correction BUG : On initialise le building_type AVANT de l'ajouter à la map
            # car l'ajout déclenche parfois des vérifications de voisinage
            house.building_type = building_type
            # On initialise les tuiles d'influence immédiatement pour éviter que les voisins
            # ne voient une liste vide au premier tick
            house.occupied_tiles = valid_tiles
            
            self.game_map.add_house(house)
            self.in_house = True
            
            # Transfert du shield au bâtiment si le peep l'avait
            if self.has_shield:
                # Nous n'avons pas accès direct à game_state ici pour changer shield_target,
                # mais le flag has_shield sur le peep servira d'indicateur pour populous.py
                pass

            self.life = 0
            self.dead = True
            # Si le peep a plus de vie que la vie max du bâtiment, on génère un peep avec l'excédent
            excess_life = self.life - max_life
            if excess_life > 0:
                offsets = [(-1,0),(1,0),(0,-1),(0,1),(-1,-1),(-1,1),(1,-1),(1,1)]
                for dr, dc in offsets:
                    nr, nc = gr + dr, gc + dc
                    if 0 <= nr < self.game_map.grid_height and 0 <= nc < self.game_map.grid_width:
                        alt = self.game_map.get_corner_altitude(nr, nc)
                        occupied = any((nr, nc) in getattr(h, 'occupied_tiles', []) for h in self.game_map.houses)
                        if alt > 0 and not occupied:
                            from peep import Peep
                            new_peep = Peep(nr, nc, self.game_map, team=self.team)
                            new_peep.life = excess_life
                            self.game_map._pending_peep = getattr(self.game_map, '_pending_peep', [])
                            self.game_map._pending_peep.append(new_peep)
                            break
            return house
        return None

    def draw(self, surface, cam_x=0, cam_y=0, show_debug=False, debug_font=None, offset_y=0):
        gr, gc = int(self.y), int(self.x)
        fx = self.x - gc  # fraction horizontale dans la tile
        fy = self.y - gr  # fraction verticale dans la tile

        # Interpolation bilinéaire de l'altitude selon la position dans la tile
        if (0 <= gr < self.game_map.grid_height and 0 <= gc < self.game_map.grid_width):
            a_nw = self.game_map.get_corner_altitude(gr,     gc)
            a_ne = self.game_map.get_corner_altitude(gr,     gc + 1)
            a_sw = self.game_map.get_corner_altitude(gr + 1, gc)
            a_se = self.game_map.get_corner_altitude(gr + 1, gc + 1)
            alt = (1 - fx) * (1 - fy) * a_nw + fx * (1 - fy) * a_ne \
                + (1 - fx) * fy       * a_sw + fx * fy       * a_se
        else:
            alt = 0

        sx, sy = self.game_map.world_to_screen(self.y, self.x, alt, cam_x, cam_y)
        sy += offset_y
        # Sol visuel : la coordonnée sy intègre déjà l'altitude (alt * 8)
        ground_y = sy + TILE_HALF_H

        sprites = self.get_sprites()
        
        is_knight = getattr(self, 'is_knight', False)
        
        # Sélection du set d'animations selon l'équipe
        if is_knight:
             frames_set = KNIGHT_FRAMES
             victory_before = VICTORY_KNIGHT
             victory_main = VICTORY_KNIGHT
        elif self.team == 'foes':
             frames_set = FOE_WALK_FRAMES
             victory_before = VICTORY_FOE_BEFORE
             victory_main = VICTORY_FOE_MAIN
        else:
             frames_set = WALK_FRAMES
             victory_before = VICTORY_ALLIE_BEFORE
             victory_main = VICTORY_ALLIE_MAIN

        if self.state == Peep.STATE_BATTLE:
            # Pour la bataille, seul l'allié affiche l'animation globale
            if self.team == 'allies':
                if is_knight:
                    if getattr(self.battle_partner, 'is_knight', False):
                        frames = BATTLE_KNIGHT_KNIGHT
                    else:
                        frames = BATTLE_KNIGHT_FOE
                else:
                    frames = BATTLE_FRAMES
            else:
                return # Le foe est caché car fusionné dans le sprite de l'allié
        elif self.state == Peep.STATE_VICTORY_BEFORE:
            frames = victory_before
        elif self.state == Peep.STATE_VICTORY_MAIN:
            frames = victory_main
        elif self.state == Peep.STATE_WAIT_FOR_ENEMY:
            frames = frames_set['WAIT']
        else:
            frames = frames_set.get(self.facing, frames_set['IDLE'])
        
        if self.facing == 'DROWN':
            # Animation sur les frames DROWN spécifiées dans le dictionnaire
            anim_len = len(frames)
            frame_key = frames[self.anim_frame % anim_len]
        else:
            anim_len = len(frames)
            frame_key = frames[self.anim_frame % anim_len]
            
        sprite = sprites.get(frame_key)

        if sprite is not None:
            # Centrer le sprite sur la position
            sw, sh = sprite.get_size()
            blit_x = sx - sw // 2
            blit_y = ground_y - sh
            if self.dead:
                # Teinter en rouge pour les morts
                tinted = sprite.copy()
                tinted.fill((255, 0, 0, 100), special_flags=pygame.BLEND_RGBA_MULT)
                surface.blit(tinted, (blit_x, blit_y))
            else:
                surface.blit(sprite, (blit_x, blit_y))
            # Affichage debug de la vie
            if show_debug and debug_font is not None:
                # Jaune (255,255,0) pour alliés, Rouge (255,0,0) pour foes
                # On ignore l'ancien fallback rouge pour les morts ici car la demande est basée sur la couleur d'équipe
                color = (255, 0, 0) if self.team == 'foes' else (255, 255, 0)
                life_text = debug_font.render(f"{int(self.life)}", True, color)
                text_x = sx - life_text.get_width() // 2
                text_y = blit_y - 16
                surface.blit(life_text, (text_x, text_y))
        else:
            # Fallback : petit cercle
            pygame.draw.circle(surface, (255, 220, 120), (sx, ground_y), 3)
            if show_debug and debug_font is not None:
                color = (255, 0, 0) if self.team == 'foes' else (255, 255, 0)
                life_text = debug_font.render(f"{int(self.life)}", True, color)
                text_x = sx - life_text.get_width() // 2
                text_y = ground_y - 24
                surface.blit(life_text, (text_x, text_y))

    def is_removable(self):
        if self.in_house:
            return True
        return self.dead and self.death_timer > 3.0