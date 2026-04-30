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
    'DROWN':  [(5,  8), (5,  9), (5, 10), (5, 11)],
}

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

    def __init__(self, grid_r, grid_c, game_map):
        self.x = grid_c + 0.5
        self.y = grid_r + 0.5
        self.game_map = game_map
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
        # Machine à états
        self.state = Peep.STATE_WANDER
        self.state_target = None  # (r, c) ou None
        self.state_timer = 0.0
        # Mouvement tuile à tuile
        self.tile_from = (int(self.y), int(self.x))
        self.tile_to = (int(self.y), int(self.x))
        self.move_progress = 1.0  # 1.0 = sur la tuile cible
        # Pour l'assemble par paire
        self.assemble_role = None  # 'donneur', 'receveur', ou None
        self.assemble_partner = None  # référence vers le partenaire

    def set_command(self, command, target=None):
        """Change l'état du peep selon la commande reçue."""
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
                peeps = [p for p in self.game_map.peeps if not p.dead]
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
        else:
            self.state = Peep.STATE_WANDER
            self.state_target = None
            self.assemble_role = None
            self.assemble_partner = None
        self.state_timer = 0.0

    def _choose_next_tile(self):
        """Choix de la prochaine tuile selon l'état du peep, avec floodfill local et retour possible sur ancienne case."""
        r0, c0 = int(self.y), int(self.x)

        # Pour _go_build, chercher une tuile constructible dans un voisinage élargi
        if self.state == Peep.STATE_ASSEMBLE:
            # Fusion par paire : le donneur va vers son receveur
            if self.assemble_role == 'donneur' and self.assemble_partner is not None and not self.assemble_partner.dead:
                pr, pc = int(self.assemble_partner.y), int(self.assemble_partner.x)
                self.state_target = (pr, pc)
            else:
                self.state_target = None
                return (r0, c0)

        # Pour _go_papal, _go_assemble, _go_fight : comportement cible (inchangé)
        # Générer toutes les positions dans un carré 5x5 autour du peep (sauf la case centrale)
        positions = [(dr, dc) for dr in range(-2, 3) for dc in range(-2, 3) if not (dr == 0 and dc == 0)]
        random.shuffle(positions)
        best_score = -float('inf')
        best_tile = None
        for dr, dc in positions:
            nr, nc = r0 + dr, c0 + dc
            if 0 <= nr < self.game_map.grid_height and 0 <= nc < self.game_map.grid_width:
                alt = self.game_map.get_corner_altitude(nr, nc)
                score = alt
                if self.state_target:
                    dist_now = math.hypot(c0 - self.state_target[1], r0 - self.state_target[0])
                    dist_next = math.hypot(nc - self.state_target[1], nr - self.state_target[0])
                    score += (dist_now - dist_next) * 2.0
                if alt > 0 and score > best_score:
                    best_score = score
                    best_tile = (nr, nc)
        return best_tile if best_tile is not None else (r0, c0)

    def _update_state(self, dt):
        """Met à jour l'état selon la machine à états et agit en conséquence."""
        # Les actions ne sont évaluées que quand le peep atteint le centre de la tuile cible
        if self.move_progress < 1.0:
            return  # En déplacement, rien à faire

        # _go_build : tente de construire
        if self.state == Peep.STATE_BUILD:
            # Tente de construire sur la tuile actuelle
            self.try_build_house()
            # Cherche une tuile constructible adjacente
            self.tile_from = (int(self.y), int(self.x))
            self.tile_to = self._choose_next_tile()
            self.move_progress = 0.0 if self.tile_to != self.tile_from else 1.0
        # _go_assemble : fusion
        elif self.state == Peep.STATE_ASSEMBLE:
            # Fusionner si un autre peep vivant est sur la même tuile (même case entière)
            if hasattr(self.game_map, 'peeps'):
                for other in self.game_map.peeps:
                    if other is not self and not other.dead:
                        # Fusion si sur la même tuile (même case entière)
                        if int(other.x) == int(self.x) and int(other.y) == int(self.y):
                            self.life += other.life
                            other.life = 0
                            other.dead = True
                            break
            self.tile_from = (int(self.y), int(self.x))
            self.tile_to = self._choose_next_tile()
            self.move_progress = 0.0 if self.tile_to != self.tile_from else 1.0
        # _go_papal : converge vers la cible
        elif self.state == Peep.STATE_PAPAL:
            self.tile_from = (int(self.y), int(self.x))
            self.tile_to = self._choose_next_tile()
            self.move_progress = 0.0 if self.tile_to != self.tile_from else 1.0
        # _go_fight : combat
        elif self.state == Peep.STATE_FIGHT:
            found_enemy = False
            if hasattr(self.game_map, 'peeps'):
                for other in self.game_map.peeps:
                    if other is not self and not other.dead:
                        if (int(other.x), int(other.y)) == (int(self.x), int(self.y)):
                            self.life += other.life * 0.2
                            other.life = 0
                            other.dead = True
                            found_enemy = True
                            break
            self.tile_from = (int(self.y), int(self.x))
            self.tile_to = self._choose_next_tile()
            self.move_progress = 0.0 if self.tile_to != self.tile_from else 1.0
        else:
            # En mode wander, le peep choisit une case valide au hasard parmi toutes les voisines
            self.state_target = None
            directions = [
                (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)
            ]
            r0, c0 = int(self.y), int(self.x)
            valid_tiles = []
            for dr, dc in directions:
                nr, nc = r0 + dr, c0 + dc
                if 0 <= nr < self.game_map.grid_height and 0 <= nc < self.game_map.grid_width:
                    alt = self.game_map.get_corner_altitude(nr, nc)
                    if alt > 0:
                        valid_tiles.append((nr, nc))
            if valid_tiles:
                nr, nc = random.choice(valid_tiles)
                self.tile_from = (r0, c0)
                self.tile_to = (nr, nc)
                self.move_progress = 0.0
            else:
                self.tile_from = (r0, c0)
                self.tile_to = (r0, c0)
                self.move_progress = 1.0


    def update(self, dt):
        # Gestion de la machine à états
        if self.dead:
            self.death_timer += dt
            return

        # Perte de vie : 1 point par seconde
        self.life -= dt * 1.0
        if self.life <= 0:
            self.life = 0
            self.dead = True
            return

        self.anim_timer += dt

        # Mouvement tuile à tuile
        if self.move_progress < 1.0:
            speed = PEEP_SPEED * dt / 64.0
            self.move_progress += speed
            if self.move_progress >= 1.0:
                self.move_progress = 1.0
                self.x = self.tile_to[1] + 0.5
                self.y = self.tile_to[0] + 0.5
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
            self.facing = 'IDLE'

        # Construction
        self.build_timer += dt

    def try_build_house(self):
        if self.build_timer < 5.0:
            return None

        gr, gc = int(self.y), int(self.x)
        score, valid_tiles = self.game_map.get_flat_area_score(gr, gc, current_house=None)
        # Vérifie la présence d'une maison sur la case
        house_present = any((gr, gc) in getattr(h, 'occupied_tiles', [(h.r, h.c)]) for h in self.game_map.houses)
        # Calcul du type de bâtiment
        from house import House
        thresholds = [0, 1, 2, 5, 8, 11, 14, 19, 22, 24]
        max_tier = 0
        for i, thresh in enumerate(thresholds):
            if score >= thresh:
                max_tier = i
        max_tier = min(len(House.TYPES) - 1, max_tier)
        building_type = House.TYPES[max_tier]
        # Affichage debug
        print(f"[DEBUG] Peep({gr},{gc}) flat score={score}, valid_tiles={len(valid_tiles)}, house_present={int(house_present)}, life={int(self.life)}, BUILT '{building_type if self.game_map.can_place_house_initial(gr, gc) else ''}'")
        if self.game_map.can_place_house_initial(gr, gc):
            self.build_timer = 0.0
            max_life = House.MAX_HEALTHS[max_tier]
            house = House(gr, gc, life=min(self.life, max_life))
            self.game_map.add_house(house)
            self.in_house = True
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
                            new_peep = Peep(nr, nc, self.game_map)
                            new_peep.life = excess_life
                            self.game_map._pending_peep = getattr(self.game_map, '_pending_peep', [])
                            self.game_map._pending_peep.append(new_peep)
                            break
            return house
        return None

    def draw(self, surface, cam_x=0, cam_y=0, show_debug=False, debug_font=None):
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
        # Sol visuel : la coordonnée sy intègre déjà l'altitude (alt * 8)
        ground_y = sy + TILE_HALF_H

        sprites = self.get_sprites()
        frames = WALK_FRAMES.get(self.facing, WALK_FRAMES['IDLE'])
        if self.facing == 'DROWN':
            # Animation pingpong sur 4 frames
            anim_len = 4
            # self.anim_frame est déjà l'indice pingpong (0,1,2,3,2,1...)
            frame_key = (5, 8 + self.anim_frame)
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
                life_text = debug_font.render(f"{int(self.life)}", True, (255,255,0) if not self.dead else (255,0,0))
                text_x = sx - life_text.get_width() // 2
                text_y = blit_y - 16
                surface.blit(life_text, (text_x, text_y))
        else:
            # Fallback : petit cercle
            pygame.draw.circle(surface, (255, 220, 120), (sx, ground_y), 3)
            if show_debug and debug_font is not None:
                life_text = debug_font.render(f"{int(self.life)}", True, (255,255,0))
                text_x = sx - life_text.get_width() // 2
                text_y = ground_y - 24
                surface.blit(life_text, (text_x, text_y))

    def is_removable(self):
        if self.in_house:
            return True
        return self.dead and self.death_timer > 3.0