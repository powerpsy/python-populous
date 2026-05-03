import pygame
import random
import math
import os
from settings import *
from game_map import GameMap
from peep import Peep
from house import House
from camera import Camera
from minimap import Minimap

class Game:
    def move_camera_direction(self, direction):
        # Déplace la caméra selon la direction
        self.camera.move_direction(direction)
    def __init__(self):
        # --- Scroll continu D-Pad ---
        self.dpad_held_direction = None
        self.dpad_held_timer = 0.0
        self.dpad_repeat_delay = 0.2  # secondes entre scrolls
        self.dpad_last_flash_time = 0.0  # timestamp du dernier scroll
        self.papal_mode = False
        self.papal_position = (GRID_HEIGHT // 2, GRID_WIDTH // 2)  # Un seul papal, centré au début
        self.shield_mode = False  # Mode blason/shield
        self.shield_target = None  # Entité actuellement "blasonnée"

        pygame.init()
        self.clock = pygame.time.Clock()
        self.font = pygame.font.SysFont("consolas", 16)

        # Charger l'interface pour déterminer la taille de l'écran
        ui_path = os.path.join(GFX_DIR, "AmigaUI.png")
        ui_raw = pygame.image.load(ui_path)
        # Initialisation des zones interactives de l'interface ---        
        self.base_size = ui_raw.get_size()
        self.display_scale = 3

        # Initialiser l'écran basé sur l'UI avec l'échelle d'affichage
        self.screen = pygame.display.set_mode((self.base_size[0] * self.display_scale, self.base_size[1] * self.display_scale))
        pygame.display.set_caption("Populous")

        self.ui_image = ui_raw.convert_alpha()
        self.internal_surface = pygame.Surface(self.base_size)
        self.internal_surface.blit(self.ui_image, (0, 0))

        # Dimensions de la zone de render (plein écran à l'échelle 1)
        self.view_rect = pygame.Rect(0, 0, self.ui_image.get_width(), self.ui_image.get_height())

        import settings
        import game_map
        import peep

        settings.SCREEN_WIDTH = self.ui_image.get_width()
        settings.SCREEN_HEIGHT = self.ui_image.get_height()
        # Coordonnées en dur pour la pointe de la zone diamant
        settings.MAP_OFFSET_X = 192
        settings.MAP_OFFSET_Y = 64
        
        for mod in (game_map, peep, settings):
            mod.SCREEN_WIDTH = settings.SCREEN_WIDTH
            mod.SCREEN_HEIGHT = settings.SCREEN_HEIGHT
            mod.MAP_OFFSET_X = settings.MAP_OFFSET_X
            mod.MAP_OFFSET_Y = settings.MAP_OFFSET_Y
            mod.TILE_WIDTH = TILE_WIDTH
            mod.TILE_HEIGHT = TILE_HEIGHT
            mod.TILE_HALF_W = TILE_HALF_W
            mod.TILE_HALF_H = TILE_HALF_H
            mod.SPRITE_SIZE = SPRITE_SIZE
            mod.ALTITUDE_PIXEL_STEP = ALTITUDE_PIXEL_STEP

        self.camera = Camera()
        self.game_map = GameMap(GRID_WIDTH, GRID_HEIGHT)
        self.game_map.randomize()
        self.minimap = Minimap(0, 0) # Position de la minimap

        # --- Chargement des sprites d'armes ---
        self.weapon_sprites = []
        weapons_path = os.path.join(GFX_DIR, "Weapons.png")
        if os.path.exists(weapons_path):
            sheet = pygame.image.load(weapons_path).convert_alpha()
            for i in range(10):
                rect = pygame.Rect(i * 16, 0, 16, 16)
                self.weapon_sprites.append(sheet.subsurface(rect))
        # Mapping type de bâtiment -> index sprite
        self.weapon_sprite_indices = {
            'hut': 0,
            'house_small': 1,
            'house_medium': 2,
            'castle_small': 3,
            'castle_medium': 4,
            'castle_large': 5,
            'fortress_small': 6,
            'fortress_medium': 7,
            'fortress_large': 8,
            'castle': 9,
        }
        self.peeps = []
        self.running = True
        self.show_debug = True
        self.show_scanlines = False
        self.view_who = None
        self._force_assemble_recompute = False
        self.view_type = None
        self.scanline_surface = None
        self._update_scanline_surface()
        # Commande peep active (par défaut _go_build)
        self.active_peep_command = '_go_build'
        self.active_peep_target = (self.game_map.grid_height // 2, self.game_map.grid_width // 2)

        # --- Initialisation des zones interactives de l'interface ---
        cx, cy = 64, 168 # Centre de base
        dx, dy = 16, 8   # Décalage isométrique
        hw, hh = 16, 8   # Taille isométrique pour les boutons
        
        # 5 lignes de 9 7 5 3 1 actions positionnées "en dur"
        # Initialisation du feedback bouton (sprite)
        self.last_button_click = None
        self.ui_buttons = {
            # --- Ligne 0 (9 actions) ---
            '_raise_terrain': {'c': (cx + dx*2, cy + dy*2), 'hw': hw, 'hh': hh}, # o OK

            '_do_volcano':    {'c': (cx - dx*3, cy - dy*3), 'hw': hw, 'hh': hh}, # j OK
            '_do_knight':     {'c': (cx - dx*2, cy - dy*2), 'hw': hw, 'hh': hh}, # k OK
            '_do_flood':      {'c': (cx - dx*3, cy - dy*5), 'hw': hw, 'hh': hh}, # a OK
            '_do_quake':      {'c': (cx - dx*1, cy - dy*3), 'hw': hw, 'hh': hh}, # c OK
            '_do_swamp':      {'c': (cx - dx*3, cy - dy*1), 'hw': hw, 'hh': hh}, # q OK
            '_do_papal':      {'c': (cx + dx*1, cy + dy*3), 'hw': hw, 'hh': hh}, # u OK
            '_do_shield':     {'c': (cx + dx*3, cy + dy*1), 'hw': hw, 'hh': hh}, # g OK

            '_find_battle':   {'c': (cx + dx*3, cy + dy*3), 'hw': hw, 'hh': hh}, # p OK
            '_find_shield':   {'c': (cx,        cy),        'hw': hw, 'hh': hh}, # m OK
            '_find_papal':    {'c': (cx + dx*4, cy + dy*2), 'hw': hw, 'hh': hh}, # h
            '_find_knight':   {'c': (cx + dx*5, cy + dy*3), 'hw': hw, 'hh': hh}, # i

            'W':              {'c': (cx - dx*2, cy),        'hw': hw, 'hh': hh}, # l OK
            'NW':             {'c': (cx - dx*1, cy - dy),   'hw': hw, 'hh': hh}, # d OK
            'N':              {'c': (cx,        cy - dy*2), 'hw': hw, 'hh': hh}, # e OK
            'NE':             {'c': (cx + dx*1, cy - dy*1), 'hw': hw, 'hh': hh}, # f OK
            'E':              {'c': (cx + dx*2, cy),        'hw': hw, 'hh': hh}, # n OK
            'SW':             {'c': (cx - dx*1, cy + dy*1), 'hw': hw, 'hh': hh}, # r OK
            'S':              {'c': (cx,        cy + dy*2), 'hw': hw, 'hh': hh}, # s OK
            'SE':             {'c': (cx + dx*1, cy + dy*1), 'hw': hw, 'hh': hh}, # t OK

            '_go_papal':      {'c': (cx - dx*3, cy + dy*1), 'hw': hw, 'hh': hh}, # v OK
            '_go_build':      {'c': (cx - dx*2, cy + dy*2), 'hw': hw, 'hh': hh}, # w OK
            '_go_assemble':   {'c': (cx - dx*1, cy + dy*3), 'hw': hw, 'hh': hh}, # x OK
            '_go_fight':      {'c': (cx - dx*3, cy + dy*3), 'hw': hw, 'hh': hh}, # y OK

            '_battle_over':   {'c': (cx - dx*2, cy - dy*4), 'hw': hw, 'hh': hh}, # b OK
        }

        # Commande par défaut au lancement
        self._handle_ui_click('_go_build', held=False)

        # --- Initialisation des sprites de boutons ---
        self.button_sprite_indices = {}
        self.button_sprites = []
        # Charger la spritesheet
        button_ui_path = os.path.join(GFX_DIR, "ButtonUI.png")
        if os.path.exists(button_ui_path):
            sheet = pygame.image.load(button_ui_path).convert_alpha()
            sheet_w, sheet_h = sheet.get_size()
            sprite_w, sprite_h = 34, 17
            for row in range(5):
                for col in range(5):
                    x = col * sprite_w
                    y = row * sprite_h
                    if x + sprite_w <= sheet_w and y + sprite_h <= sheet_h:
                        rect = pygame.Rect(x, y, sprite_w, sprite_h)
                        self.button_sprites.append(sheet.subsurface(rect))
        # Ordre des boutons pour l'indexation
        button_order = [
            '_do_flood', '_battle_over', '_do_quake', 'NW', 'N', 'NE', '_do_shield', '_find_papal', '_find_knight',
            '_do_volcano', '_do_knight', 'W', '_find_shield', 'E', '_raise_terrain', '_find_battle',
            '_do_swamp', 'SW', 'S', 'SE', '_do_papal', '_go_papal', '_go_build', '_go_assemble', '_go_fight'
        ]
        for idx, name in enumerate(button_order):
            self.button_sprite_indices[name] = idx 

    def _get_peep_sprite_rect(self, peep, cam_r, cam_c):
        gr, gc = int(peep.y), int(peep.x)
        fx = peep.x - gc
        fy = peep.y - gr
        if 0 <= gr < self.game_map.grid_height and 0 <= gc < self.game_map.grid_width:
            a_nw = self.game_map.get_corner_altitude(gr, gc)
            a_ne = self.game_map.get_corner_altitude(gr, gc + 1)
            a_sw = self.game_map.get_corner_altitude(gr + 1, gc)
            a_se = self.game_map.get_corner_altitude(gr + 1, gc + 1)
            alt = (1 - fx) * (1 - fy) * a_nw + fx * (1 - fy) * a_ne + (1 - fx) * fy * a_sw + fx * fy * a_se
        else:
            alt = 0

        sx, sy = self.game_map.world_to_screen(peep.y, peep.x, alt, cam_r, cam_c)
        ground_y = sy + TILE_HALF_H
        sprites = Peep.get_sprites()
        from peep import PEEP_WALK_FRAMES, FOE_WALK_FRAMES
        
        if getattr(peep, 'team', 'allies') == 'foes':
             anim = FOE_WALK_FRAMES.get(peep.facing, FOE_WALK_FRAMES['IDLE'])
        else:
             anim = PEEP_WALK_FRAMES.get(peep.facing, PEEP_WALK_FRAMES['IDLE'])
        
        # Gestion des états spéciaux pour le rectangle de collision UI
        from peep import BATTLE_FRAMES, VICTORY_ALLIE_BEFORE, VICTORY_ALLIE_MAIN, VICTORY_FOE_BEFORE, VICTORY_FOE_MAIN
        if peep.state == 'battle':
            anim = BATTLE_FRAMES
        elif peep.state == 'victory_before':
            anim = VICTORY_FOE_BEFORE if peep.team == 'foes' else VICTORY_ALLIE_BEFORE
        elif peep.state == 'victory_main':
            anim = VICTORY_FOE_MAIN if peep.team == 'foes' else VICTORY_ALLIE_MAIN
             
        key = anim[peep.anim_frame % len(anim)]
        sprite = sprites.get(key)
        if sprite is None:
            return pygame.Rect(sx - 4, ground_y - 8, 8, 8)
        sw, sh = sprite.get_size()
        return pygame.Rect(sx - sw // 2, ground_y - sh, sw, sh)

    def _get_house_sprite_rect(self, house, cam_r, cam_c):
        if house.building_type == 'castle':
            alt = self.game_map.get_corner_altitude(house.r, house.c)
            sx, sy = self.game_map.world_to_screen(house.r, house.c, alt, cam_r, cam_c)
            return pygame.Rect(sx - TILE_WIDTH, sy - TILE_HEIGHT, TILE_WIDTH * 2, TILE_HEIGHT * 2)

        alt = self.game_map.get_corner_altitude(house.r, house.c)
        sx, sy = self.game_map.world_to_screen(house.r, house.c, alt, cam_r, cam_c)
        tile_key = BUILDING_TILES.get(house.building_type, BUILDING_TILES['hut'])
        tile_surf = self.game_map.tile_surfaces.get(tile_key)
        if tile_surf is None:
            return pygame.Rect(sx - TILE_HALF_W, sy, TILE_WIDTH, TILE_HEIGHT)
        tw, th = tile_surf.get_size()
        return pygame.Rect(sx - TILE_HALF_W, sy, tw, th)

    def _select_view_target(self, mx, my):
        cam_r, cam_c = self.camera.r, self.camera.c
        best_target = None
        best_type = None
        best_dist = float('inf')

        for house in self.game_map.houses:
            if getattr(house, 'destroyed', False):
                continue
            rect = self._get_house_sprite_rect(house, cam_r, cam_c)
            if rect.collidepoint(mx, my):
                dx = mx - rect.centerx
                dy = my - rect.centery
                d2 = dx * dx + dy * dy
                if d2 < best_dist:
                    best_dist = d2
                    best_target = house
                    best_type = 'house'

        for peep in self.peeps:
            if peep.dead:
                continue
            rect = self._get_peep_sprite_rect(peep, cam_r, cam_c)
            if rect.collidepoint(mx, my):
                dx = mx - rect.centerx
                dy = my - rect.centery
                d2 = dx * dx + dy * dy
                if d2 < best_dist:
                    best_dist = d2
                    best_target = peep
                    best_type = 'peep'

        if best_target is not None:
            self.view_who = best_target
            self.view_type = best_type
            return True
        return False

    def _get_weapon_name(self, target, target_type):
        if target_type == 'house':
            by_type = {
                'hut': 'A',
                'house_small': 'B',
                'house_medium': 'C',
                'castle_small': 'D',
                'castle_medium': 'E',
                'castle_large': 'F',
                'fortress_small': 'G',
                'fortress_medium': 'H',
                'fortress_large': 'I',
                'castle': 'J',
            }
            return by_type.get(target.building_type, 'Aucune')

        life = float(getattr(target, 'life', 0.0))
        if life < 20:
            return 'Mains nues'
        if life < 40:
            return 'Baton'
        if life < 70:
            return 'Epee courte'
        if life < 100:
            return 'Epee'
        return 'Arc'

    def _draw_shield_marker(self, surface, target, target_type, cam_r, cam_c):
        sprites = Peep.get_sprites()
        shield_sprite = sprites.get((8, 8))
        if shield_sprite is None:
            return

        if target_type == 'peep':
            rect = self._get_peep_sprite_rect(target, cam_r, cam_c)
            # Sur le peep comme s'il le tenait (légèrement décalé)
            x = rect.centerx - 1
            y = rect.centery - shield_sprite.get_height() // 2 + 2
            surface.blit(shield_sprite, (x, y))
            return


        # Pour le château, placer le shield comme pour les autres bâtiments mais sur la case centrale (r, c)
        if getattr(target, 'building_type', None) == 'castle':
            center_r = getattr(target, 'r', 0)
            center_c = getattr(target, 'c', 0)
            alt = self.game_map.get_corner_altitude(center_r, center_c)
            sx, sy = self.game_map.world_to_screen(center_r, center_c, alt, cam_r, cam_c)
            # Simule un "rect" virtuel pour la case centrale
            rect = pygame.Rect(sx - TILE_HALF_W, sy, TILE_WIDTH, TILE_HEIGHT)
            x = rect.centerx - shield_sprite.get_width() // 2 + 11
            y = rect.top - shield_sprite.get_height() - 2 + 23
            surface.blit(shield_sprite, (x, y))
            return

        rect = self._get_house_sprite_rect(target, cam_r, cam_c)
        # Décalage générique pour les autres bâtiments
        x = rect.centerx - shield_sprite.get_width() // 2 + 11
        y = rect.top - shield_sprite.get_height() - 2 + 23
        surface.blit(shield_sprite, (x, y))

    def _draw_bar(self, surface, x, y, ratio, color):
        bar_w = 4
        bar_max_h = 16
        # Dessiner l'arrière-plan (santé max théorique)
        pygame.draw.rect(surface, (102, 102, 102), (x, y, bar_w, bar_max_h))
        
        # Dessiner la valeur actuelle
        h = int(ratio * bar_max_h)
        if h > 0:
            pygame.draw.rect(surface, color, (x, y + (bar_max_h - h), bar_w, h))

    def _draw_shield_panel(self, surface):
        # On utilise en priorité l'entité qui possède le shield, sinon la sélection courante
        target = self.shield_target
        target_type = None
        
        if target is not None:
            if isinstance(target, House):
                target_type = 'house'
            elif isinstance(target, Peep):
                target_type = 'peep'
        
        # Si pas de shield target, on se rabat sur la sélection de vue
        if target is None:
            target = self.view_who
            target_type = self.view_type

        if target is None or target_type is None:
            return

        sprites = Peep.get_sprites()

        # Coordonnées UI
        blason_tl = (271, 4)   # Colonie
        blason_tr = (287, 2)   # Arme
        blason_bl = (271, 23)  # Animation
        blason_br = (287, 19)  # Barres HP/NRG

        # 1. Colonie
        is_enemy = getattr(target, 'is_enemy', False)
        colony_sprite = sprites.get((4, 9) if is_enemy else (4, 8))
        if colony_sprite:
            surface.blit(colony_sprite, blason_tl)

        # 2. Arme
        weapon_type = getattr(target, 'building_type' if target_type == 'house' else 'weapon_type', 'hut')
        weapon_idx = self.weapon_sprite_indices.get(weapon_type)
        if weapon_idx is not None and 0 <= weapon_idx < len(self.weapon_sprites):
            surface.blit(self.weapon_sprites[weapon_idx], (blason_tr[0] + 2, blason_tr[1] + 1))
        else:
            weapon_name = self._get_weapon_name(target, target_type)
            w_text = self.font.render(weapon_name[0].upper() if weapon_name != 'Aucune' else 'N', True, (240, 240, 240))
            surface.blit(w_text, (blason_tr[0] + 6, blason_tr[1] + 2))

        # 3. Animation / Drapeau
        in_house = getattr(target, 'in_house', False)
        if target_type == 'house' or in_house:
            frame_idx = int(pygame.time.get_ticks() / 200) % 2
            flag_sprite = sprites.get((4, frame_idx))
            if flag_sprite:
                surface.blit(flag_sprite, (blason_bl[0] - 3, blason_bl[1]))
        else:
            facing = getattr(target, 'facing', 'IDLE')
            from peep import WALK_FRAMES
            anim = WALK_FRAMES.get(facing, WALK_FRAMES['IDLE'])
            peep_sprite = sprites.get(anim[getattr(target, 'anim_frame', 0) % len(anim)])
            if peep_sprite:
                surface.blit(peep_sprite, blason_bl)

        # 4. Barres (Y décalé de 4 pixels vers le bas)
        bar_y = blason_br[1] + 4
        rect1_x = blason_br[0] + 3
        rect2_x = blason_br[0] + 11
        
        if target_type == 'house':
            try:
                tier = House.TYPES.index(getattr(target, 'building_type', 'hut'))
            except:
                tier = 0
            # Barre de gauche (Jaune) : Niveau du building
            ratio_yellow = (tier + 1) / len(House.TYPES)
            # Barre de droite (Orange) : Santé du bâtiment (progression vers spawn)
            ratio_orange = getattr(target, 'life', 1.0) / getattr(target, 'max_life', 16.0)
            
            self._draw_bar(surface, rect1_x, bar_y, min(1.0, ratio_yellow), (255, 255, 0))
            self._draw_bar(surface, rect2_x, bar_y, min(1.0, ratio_orange), (255, 128, 0))
        else:
            # Peep : Santé de 0 à 999
            life = getattr(target, 'life', 0)
            hundreds = (life // 100) / 9.0  # 0-999 -> 0-9 centaines
            units = (life % 100) / 99.0     # 0-99 reste
            
            # Les deux barres sont oranges pour les peeps
            self._draw_bar(surface, rect1_x, bar_y, min(1.0, hundreds), (255, 128, 0))
            self._draw_bar(surface, rect2_x, bar_y, min(1.0, units), (255, 128, 0))

    def _update_scanline_surface(self):
        w, h = self.screen.get_size()
        self.scanline_surface = pygame.Surface((w, h), pygame.SRCALPHA)
        self.scanline_surface.fill((0, 0, 0, 0))
        for y in range(0, h, max(1, self.display_scale)):
            pygame.draw.line(self.scanline_surface, (0, 0, 0, 100), (0, y), (w, y), 1)

    def spawn_initial_peeps(self, count):
        # Spawn initial d'allies (bleus)
        for _ in range(count // 2):
            r = random.randint(0, GRID_HEIGHT - 1)
            c = random.randint(0, GRID_WIDTH - 1)
            # Ne pas spawn sur l'eau
            if self.game_map.get_corner_altitude(r, c) > 0:
                peep = Peep(r, c, self.game_map, team='allies')
                peep.set_command('_go_build')
                self.peeps.append(peep)

        # Spawn initial de foes (rouges)
        for _ in range(count // 2):
            r = random.randint(0, GRID_HEIGHT - 1)
            c = random.randint(0, GRID_WIDTH - 1)
            # Ne pas spawn sur l'eau
            if self.game_map.get_corner_altitude(r, c) > 0:
                peep = Peep(r, c, self.game_map, team='foes')
                peep.set_command('_go_build')
                self.peeps.append(peep)

    def run(self):
        pygame.mouse.set_visible(False)
        self.spawn_initial_peeps(10)
        while self.running:
            dt = self.clock.tick(60) / 1000.0
            self.events()
            self.update(dt)
            self.draw()

    def _handle_ui_click(self, action, held=False):
        import time
        self.last_button_click = (action, time.time())
        # Annule tout mode spécial si une autre action est sélectionnée
        if action != '_do_papal':
            self.papal_mode = False
        if action != '_do_shield':
            self.shield_mode = False
        if action in ['N', 'S', 'E', 'W', 'NW', 'NE', 'SW', 'SE']:
            if held:
                self.dpad_held_direction = action
                self.dpad_held_timer = 0.0  # scroll immédiat
                self.dpad_last_flash_time = time.time()
            self.move_camera_direction(action)
        elif action == '_do_papal':
            print("Mode papal activé")
            self.papal_mode = True
        elif action == '_do_shield':
            print("Mode shield activé")
            self.shield_mode = True
        elif action == '_find_papal':
            if self.papal_position:
                r, c = self.papal_position
                self.camera.center_on(r, c)
                print(f"Caméra centrée sur le papal ({r}, {c})")
        elif action == '_find_shield':
            if self.shield_target is not None:
                # La cible peut être un Peep (x, y) ou une House (r, c)
                r = getattr(self.shield_target, 'y', getattr(self.shield_target, 'r', None))
                c = getattr(self.shield_target, 'x', getattr(self.shield_target, 'c', None))
                if r is not None and c is not None:
                    self.camera.center_on(r, c)
                    # Forcer la vue sur l'unité
                    self.view_who = self.shield_target
                    self.view_type = 'peep' if isinstance(self.shield_target, Peep) else 'house'
                    print(f"Caméra centrée sur le shield ({r}, {c})")
        else:
            # Commandes de déplacement peep : activation exclusive
            if action in ['_go_build', '_go_assemble', '_go_papal', '_go_fight']:
                # Ne rien faire si la commande est déjà active
                if self.active_peep_command == action and (
                    (action != '_go_papal') or (self.active_peep_target == self.papal_position)
                ):
                    print(f"Commande {action} déjà active, aucune modification.")
                    return
                self.active_peep_command = action
                if action == '_go_papal':
                    self.active_peep_target = self.papal_position
                else:
                    self.active_peep_target = None
                # Attribution des rôles et partenaires pour _go_assemble
                if action == '_go_assemble':
                    peeps = [p for p in self.peeps if not p.dead]
                    # On apparie par proximité pour plus de réactivité
                    available = set(peeps)
                    while len(available) >= 2:
                        p1 = available.pop()
                        # Trouver le plus proche de p1
                        p2 = min(available, key=lambda p: math.hypot(p.x - p1.x, p.y - p1.y))
                        available.remove(p2)
                        
                        p1.assemble_role = 'receveur'
                        p1.assemble_partner = p2
                        p2.assemble_role = 'donneur'
                        p2.assemble_partner = p1
                    
                    if available:
                        p_last = available.pop()
                        p_last.assemble_role = 'receveur'
                        p_last.assemble_partner = None
                else:
                    for peep in self.peeps:
                        peep.assemble_role = None
                        peep.assemble_partner = None
                for peep in self.peeps:
                    if not peep.dead:
                        peep.set_command(self.active_peep_command, self.active_peep_target)
                print(f"Commande {action} activée (persistante) pour tous les peeps.")
            else:
                print(f"Pouvoir sélectionné (en attente d'implémentation) : {action}")

    def events(self):
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    self.running = False
                elif event.key == pygame.K_TAB:
                    self.display_scale = (self.display_scale % 4) + 1
                    self.screen = pygame.display.set_mode((self.base_size[0] * self.display_scale, self.base_size[1] * self.display_scale))
                    self._update_scanline_surface()
                elif event.key == pygame.K_F1:
                    self.peeps.clear()
                elif event.key == pygame.K_F2:
                    self.game_map.houses.clear()
                elif event.key == pygame.K_F3:
                    self.peeps.clear()
                    self.game_map.houses.clear()
                    self.game_map.randomize()
                    self.spawn_initial_peeps(10)
                elif event.key == pygame.K_F4:
                    self.game_map.set_all_altitude(1)
                elif event.key == pygame.K_F12:
                    self.show_scanlines = not self.show_scanlines
                elif event.unicode == '§':
                    self.show_debug = not self.show_debug
            elif event.type == pygame.MOUSEBUTTONDOWN:
                mx, my = pygame.mouse.get_pos()
                mx //= self.display_scale
                my //= self.display_scale
                # Check interaction minimap (si clic dessus, on ne fait pas d'autre action)
                if event.button == 1 and self.minimap.handle_click(mx, my, self.camera):
                    continue
                # Vérifier les clics sur l'interface graphique (boussole et pouvoirs)
                ui_clicked = False
                if event.button == 1:
                    for action, shape in self.ui_buttons.items():
                        bcx, bcy = shape['c']
                        bhw, bhh = shape['hw'], shape['hh']
                        # Test de collision point dans losange
                        if (abs(mx - bcx) / float(bhw) + abs(my - bcy) / float(bhh)) <= 1.0:
                            self._handle_ui_click(action, held=True)
                            ui_clicked = True
                            break
                if ui_clicked:
                    continue
                # Mode shield : clic gauche sur entité = appliquer le blason
                if self.shield_mode:
                    if event.button == 1:
                        if self._select_view_target(mx, my):
                            # Retirer le shield de l'ancienne cible si elle existe
                            if self.shield_target is not None:
                                setattr(self.shield_target, 'has_shield', False)
                            
                            self.shield_target = self.view_who
                            setattr(self.shield_target, 'has_shield', True)
                            self.shield_mode = False
                        return
                    elif event.button == 3:
                        # Annule le mode shield et revient à raise_terrain
                        self.shield_mode = False
                        self._handle_ui_click('_raise_terrain', held=False)
                        return
                # Clic droit sur entité: (désactivé, remplacé par _do_shield)
                # if event.button == 3 and self._select_view_target(mx, my):
                #     continue
                # Clics souris (on permet partout puisque le viewport est plein écran)
                if self.view_rect.collidepoint(mx, my):
                    vp_x = mx - self.view_rect.x
                    vp_y = my - self.view_rect.y
                    r, c = self.game_map.screen_to_nearest_corner(
                        vp_x, vp_y, self.camera.r, self.camera.c
                    )
                    # On vérifie qu'on clique bien sur la zone 8x8 visible de la caméra
                    start_r, end_r, start_c, end_c = self.game_map.get_visible_bounds(self.camera.r, self.camera.c)
                    if start_r <= r <= end_r and start_c <= c <= end_c:
                        if self.papal_mode:
                            if event.button == 1:
                                # Place/déplace le papal (un seul possible) sur la case au nord-ouest (NW)
                                self.papal_position = (max(r - 1, 0), max(c - 1, 0))
                                self.papal_mode = False  # Désactive le mode après un clic
                            elif event.button == 3:
                                # Annule le mode papal et revient à raise_terrain
                                self.papal_mode = False
                                self._handle_ui_click('_raise_terrain', held=False)
                            return
                        elif not self.papal_mode and not self.shield_mode:
                            if event.button == 1:
                                self.game_map.raise_corner(r, c)
                            elif event.button == 3:
                                self.game_map.lower_corner(r, c)
            elif event.type == pygame.MOUSEBUTTONUP:
                # Relâchement du clic : stop scroll continu
                self.dpad_held_direction = None

    def _spawn_peep_from_house(self, house, transfer_shield=True):
        team = getattr(house, 'team', 'allies')
        new_peep = Peep(house.r, house.c, self.game_map, team=team)
        new_peep.weapon_type = getattr(house, 'building_type', 'hut')
        new_peep.life = house.max_life
        
        if transfer_shield and (getattr(house, 'has_shield', False) or self.shield_target == house):
            new_peep.has_shield = True
            house.has_shield = False
            self.shield_target = new_peep
            if self.view_who == house:
                self.view_who = new_peep
                self.view_type = 'peep'
        
        if self.active_peep_command:
            new_peep.set_command(self.active_peep_command, self.active_peep_target)
            if self.active_peep_command == '_go_assemble':
                self._force_assemble_recompute = True
                
        return new_peep

    def update(self, dt):
        import time
        # Recalcul de l'assemblage si nécessaire (ex: après spawn d'un peep)
        if getattr(self, '_force_assemble_recompute', False) and self.active_peep_command == '_go_assemble':
            self._force_assemble_recompute = False
            # On réutilise la logique de _go_assemble par proximité
            peeps = [p for p in self.peeps if not p.dead]
            available = set(peeps)
            while len(available) >= 2:
                p1 = available.pop()
                p2 = min(available, key=lambda p: math.hypot(p.x - p1.x, p.y - p1.y))
                available.remove(p2)
                p1.assemble_role, p1.assemble_partner = 'receveur', p2
                p2.assemble_role, p2.assemble_partner = 'donneur', p1
            if available:
                p_last = available.pop()
                p_last.assemble_role, p_last.assemble_partner = 'receveur', None
            
            # Mettre à jour les commandes des nouveaux peeps
            for peep in self.peeps:
                if not peep.dead:
                    peep.set_command(self.active_peep_command, self.active_peep_target)

        # Scroll continu D-Pad UI
        if self.dpad_held_direction:
            self.dpad_held_timer -= dt
            if self.dpad_held_timer <= 0.0:
                self.move_camera_direction(self.dpad_held_direction)
                self.dpad_held_timer = self.dpad_repeat_delay
                self.dpad_last_flash_time = time.time()

        self.camera.update(dt)

        # Appairage de combat (magnet, comme go_assemble) - fait ici car on a accès à self.peeps
        COMBAT_STATES = ('battle', 'wait_for_enemy', 'charge_enemy', 'victory_before', 'victory_main')
        allies_free = [p for p in self.peeps if not p.dead and p.team == 'allies' and p.state not in COMBAT_STATES]
        foes_free   = [p for p in self.peeps if not p.dead and p.team == 'foes'   and p.state not in COMBAT_STATES]
        for a in allies_free:
            if not foes_free:
                break
            closest_foe = min(foes_free, key=lambda f: math.hypot(f.x - a.x, f.y - a.y))
            dist = math.hypot(closest_foe.x - a.x, closest_foe.y - a.y)
            if dist < 4.0:
                a.state = 'charge_enemy'
                a.battle_partner = closest_foe
                closest_foe.state = 'wait_for_enemy'
                closest_foe.battle_partner = a
                closest_foe.move_progress = 1.0
                foes_free.remove(closest_foe)

        self.game_map.update(dt)
        for peep in self.peeps:
            peep_had_shield = getattr(peep, 'has_shield', False)
            peep.update(dt)
            
            # Si le peep est mort et avait le shield, on perd la cible ou on gère le transfert
            if peep.dead and peep_had_shield:
                # Si un partenaire est vivant et a récupéré le shield, shield_target sera mis à jour par peep.update via la fusion
                # Mais il faut s'assurer que self.shield_target pointe vers le survivant.
                # Cependant, peep.update() ne connaît pas self.shield_target.
                # On fait une vérification de sécurité ici :
                if self.shield_target == peep:
                    found_new = False
                    # On cherche si un peep vivant a maintenant le shield
                    for p in self.peeps:
                        if not p.dead and getattr(p, 'has_shield', False):
                            self.shield_target = p
                            found_new = True
                            break
                    if not found_new:
                        self.shield_target = None

            if not peep.dead:
                new_house = peep.try_build_house()
                if new_house is not None:
                    # Si le peep avait le shield, on le transfère à la nouvelle maison
                    if peep_had_shield:
                        new_house.has_shield = True
                        self.shield_target = new_house
                    
                    if self.view_type == 'peep' and self.view_who == peep:
                        self.view_who = new_house
                        self.view_type = 'house'
        # Ajout des peeps excédentaires générés lors de la construction
        if hasattr(self.game_map, '_pending_peep'):
            self.peeps.extend(self.game_map._pending_peep)
            self.game_map._pending_peep.clear()

        self.peeps = [p for p in self.peeps if not p.is_removable()]

        # Maisons : update et spawn de peeps
        new_peeps = []
        houses_to_keep = []
        for house in self.game_map.houses:
            house.update(dt, self.game_map)
            
            if getattr(house, 'destroyed', False):
                # Récupération d'un peep lors de la destruction
                p = self._spawn_peep_from_house(house)
                p.life = house.life # Garde la vie actuelle si destruction
                new_peeps.append(p)
            else:
                houses_to_keep.append(house)
                if house.can_spawn_peep():
                    new_peeps.append(self._spawn_peep_from_house(house))
                    house.life = 1.0
                    
        self.game_map.houses = houses_to_keep
        self.peeps.extend(new_peeps)

        # Garder la sélection valide si la cible existe encore.
        if self.view_type == 'peep' and self.view_who not in self.peeps:
            self.view_who = None
            self.view_type = None
        elif self.view_type == 'house' and self.view_who not in self.game_map.houses:
            self.view_who = None
            self.view_type = None



    def draw(self):
        # Nettoyage de la surface interne pour éviter les traînées : restaurer le fond AmigaUI
        self.internal_surface.blit(self.ui_image, (0, 0))

        # Affichage permanent du bouton actif (_go_build, _go_assemble, _go_papal, _go_fight)
        active_btn = self.active_peep_command
        idx = self.button_sprite_indices.get(active_btn)
        if idx is not None and idx < len(self.button_sprites):
            shape = self.ui_buttons.get(active_btn)
            if shape:
                bcx, bcy = shape['c']
                sprite = self.button_sprites[idx]
                sw, sh = sprite.get_size()
                pos = (int(bcx - sw // 2) + 1, int(bcy - sh // 2))
                self.internal_surface.blit(sprite, pos)

        cam_r, cam_c = self.camera.r, self.camera.c

        # Terrain
        self.game_map.draw(self.internal_surface, cam_r, cam_c)

        # Maisons
        debug_font = pygame.font.SysFont("consolas", 14, bold=True) if self.show_debug else None
        self.game_map.draw_houses(self.internal_surface, cam_r, cam_c, show_debug=self.show_debug, debug_font=debug_font)
        
        # Dessiner le shield sur les maisons qui le possèdent
        for house in self.game_map.houses:
            if not getattr(house, 'destroyed', False) and getattr(house, 'has_shield', False):
                self._draw_shield_marker(self.internal_surface, house, 'house', cam_r, cam_c)

        start_r, end_r, start_c, end_c = self.game_map.get_visible_bounds(cam_r, cam_c)

        for peep in self.peeps:
            if peep.y < start_r or peep.y >= end_r or peep.x < start_c or peep.x >= end_c:
                continue
            peep.draw(self.internal_surface, cam_r, cam_c, show_debug=self.show_debug, debug_font=debug_font)
            # Affiche le shield automatique si le peep l'a (même s'il n'est pas sélectionné)
            if getattr(peep, 'has_shield', False):
                self._draw_shield_marker(self.internal_surface, peep, 'peep', cam_r, cam_c)

        # --- Affichage du papal (tile 5,0) après maisons et peeps ---
        papal_tile = self.game_map.tile_surfaces.get((5, 0))
        if papal_tile and self.papal_position is not None:
            r, c = self.papal_position
            start_r, end_r, start_c, end_c = self.game_map.get_visible_bounds(cam_r, cam_c)
            if start_r <= r < end_r and start_c <= c < end_c:
                alt = self.game_map.get_corner_altitude(r, c)
                sx, sy = self.game_map.world_to_screen(r, c, alt, cam_r, cam_c)
                blit_x = sx - TILE_HALF_W
                blit_y = sy
                self.internal_surface.blit(papal_tile, (blit_x, blit_y))

        if self.view_who is not None and self.view_type is not None:
            r = getattr(self.view_who, 'y', getattr(self.view_who, 'r', -1))
            c = getattr(self.view_who, 'x', getattr(self.view_who, 'c', -1))
            if start_r <= r < end_r and start_c <= c < end_c:
                self._draw_shield_marker(self.internal_surface, self.view_who, self.view_type, cam_r, cam_c)

        mouse_x, mouse_y = pygame.mouse.get_pos()
        mouse_x //= self.display_scale
        mouse_y //= self.display_scale

        if self.view_rect.collidepoint(mouse_x, mouse_y):
            vp_x = mouse_x - self.view_rect.x
            vp_y = mouse_y - self.view_rect.y
            grid_r, grid_c = self.game_map.screen_to_nearest_corner(
                vp_x, vp_y, cam_r, cam_c
            )
            if start_r <= grid_r <= end_r and start_c <= grid_c <= end_c:
                alt = self.game_map.get_corner_altitude(grid_r, grid_c)
                px, py = self.game_map.world_to_screen(grid_r, grid_c, alt, cam_r, cam_c)
                sprites = Peep.get_sprites()
                pointer_sprite = sprites.get((8, 11))
                if pointer_sprite:
                    sprite_rect = pointer_sprite.get_rect(center=(px + 5, py + TILE_HALF_H + 4))
                    self.internal_surface.blit(pointer_sprite, sprite_rect)
                else:
                    pygame.draw.circle(self.internal_surface, RED, (px, py + TILE_HALF_H), 3)


        self.minimap.draw(self.internal_surface, self.game_map, self.camera, self.peeps)

        # Curseur custom affiché partout, curseur système toujours masqué (DESSINÉ APRÈS la minimap)
        sprites = Peep.get_sprites()
        mx, my = pygame.mouse.get_pos()
        mx_screen = mx // self.display_scale
        my_screen = my // self.display_scale
        pygame.mouse.set_visible(False)
        if self.papal_mode:
            papal_cursor = sprites.get((4, 14))
            if papal_cursor:
                sprite_rect = papal_cursor.get_rect(topleft=(mx_screen, my_screen))
                self.internal_surface.blit(papal_cursor, sprite_rect)
        elif self.shield_mode:
            shield_cursor = sprites.get((8, 8))
            if shield_cursor:
                sprite_rect = shield_cursor.get_rect(topleft=(mx_screen, my_screen))
                self.internal_surface.blit(shield_cursor, sprite_rect)
        else:
            # Curseur par défaut (4,12) partout
            default_cursor = sprites.get((4, 12))
            if default_cursor:
                sprite_rect = default_cursor.get_rect(topleft=(mx_screen, my_screen))
                self.internal_surface.blit(default_cursor, sprite_rect)

        self._draw_shield_panel(self.internal_surface)

        # Suppression de l'affichage des cases violettes (debug UI)
        
        # Scale internal surface to display window size
        scaled_surface = pygame.transform.scale(self.internal_surface, self.screen.get_size())
        self.screen.blit(scaled_surface, (0, 0))

        # Affichage debug en surimpression FINALE (directement sur self.screen)
        if self.show_debug:
            mouse_x, mouse_y = pygame.mouse.get_pos()
            mouse_x //= self.display_scale
            mouse_y //= self.display_scale
            cam_r, cam_c = self.camera.r, self.camera.c

            alt_text = "N/A"
            grid_r, grid_c = -1, -1
            if self.view_rect.collidepoint(mouse_x, mouse_y):
                vp_x = mouse_x - self.view_rect.x
                vp_y = mouse_y - self.view_rect.y
                grid_r, grid_c = self.game_map.screen_to_nearest_corner(
                    vp_x, vp_y, cam_r, cam_c
                )
                alt = self.game_map.get_corner_altitude(grid_r, grid_c)
                if alt != -1:
                    alt_text = str(alt)

            debug_texts = [
                f"FPS: {self.clock.get_fps():.1f}",
                f"Scale: x{self.display_scale}",
                f"Mouse: ({mouse_x}, {mouse_y})",
                f"Corner: ({grid_r}, {grid_c}) Alt: {alt_text}",
                f"Camera R/C: ({cam_r:.2f}, {cam_c:.2f})",
                f"Peeps: {len(self.peeps)}",
                f"Houses: {len(self.game_map.houses)}"
            ]
            bold_font = pygame.font.SysFont("consolas", 16, bold=True)
            for i, text in enumerate(debug_texts):
                surf = bold_font.render(text, True, WHITE)
                self.screen.blit(surf, (10, 10 + 18 * i))

        if self.show_scanlines and self.scanline_surface:
            self.screen.blit(self.scanline_surface, (0, 0))

        pygame.display.flip()

if __name__ == '__main__':
    try:
        game = Game()
        game.run()
    except Exception as e:
        import traceback
        traceback.print_exc()
        input("Erreur. Appuyez sur Entrée pour quitter.")
