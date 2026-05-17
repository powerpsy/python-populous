import pygame
import random
import math
import os
import json
from settings import *
from game_map import GameMap
from peep import Peep
from house import House
from camera import Camera
from minimap import Minimap
from ai_player import AIPlayer

class BitmapFont:
    def __init__(self, filepath, charset, char_w=6, char_h=5, space_x=1, space_y=1):
        if os.path.exists(filepath):
            self.sheet = pygame.image.load(filepath).convert_alpha()
        else:
            print(f"Warning: Font file not found at {filepath}")
            self.sheet = pygame.Surface((10, 10), pygame.SRCALPHA)
        self.chars = {}
        self.char_w = char_w
        self.char_h = char_h
        
        sheet_w, sheet_h = self.sheet.get_size()
        cols = (sheet_w + space_x) // (char_w + space_x)
        if cols == 0: cols = 1
        
        for i, char in enumerate(charset):
            col = i % cols
            row = i // cols
            x = col * (char_w + space_x)
            y = row * (char_h + space_y)
            
            if x + char_w <= sheet_w and y + char_h <= sheet_h:
                rect = pygame.Rect(x, y, char_w, char_h)
                surf = self.sheet.subsurface(rect).copy()
                self.chars[char.lower()] = surf
                self.chars[char.upper()] = surf
        self.chars[' '] = pygame.Surface((char_w, char_h), pygame.SRCALPHA)

    def render(self, text, color, scale):
        text_w = len(text) * (self.char_w + 1) - 1
        if text_w < 0: text_w = 0
        text_h = self.char_h
        
        surf = pygame.Surface((text_w, text_h), pygame.SRCALPHA)
        x_offset = 0
        for char in text:
            if char in self.chars:
                char_surf = self.chars[char].copy()
                # Multiply apply color
                # Create a uniform color surface and multiply it
                color_surf = pygame.Surface(char_surf.get_size(), pygame.SRCALPHA)
                color_surf.fill(color)
                char_surf.blit(color_surf, (0, 0), special_flags=pygame.BLEND_RGBA_MULT)
                
                surf.blit(char_surf, (x_offset, 0))
            x_offset += self.char_w + 1
            
        if scale > 1:
            surf = pygame.transform.scale(surf, (text_w * scale, text_h * scale))
        return surf

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
        # Ralliement papal pour chaque faction
        self.papal_position = {
            'allies': (GRID_HEIGHT // 2, GRID_WIDTH // 2),
            'foes': (GRID_HEIGHT // 2, GRID_WIDTH // 2)
        }
        self.shield_mode = False  # Mode blason/shield
        self.volcano_mode = False # Mode volcan
        # Blason pour chaque faction
        self.shield_target = {
            'allies': None,
            'foes': None
        }
        # Leader pour chaque faction
        self.leader_target = {
            'allies': None,
            'foes': None
        }

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
        self.show_debug = False
        self.show_scanlines = False
        
        # --- Chargement des sons ---
        self.sounds = {}
        for sfx_name in ["do_volcano", "do_flood", "do_quake", "swamp", "swamped"]:
            wav_path = os.path.join(SFX_DIR, f"{sfx_name}.wav")
            if pygame.mixer.get_init() and os.path.exists(wav_path):
                self.sounds[sfx_name] = pygame.mixer.Sound(wav_path)
        
        self.power_jauge = {'allies': 0.0, 'foes': 0.0}
        self.power_max = {'allies': 100.0, 'foes': 100.0}
        self.POWER_COSTS = {
            '_raise_terrain': 1,
            '_lower_terrain': 1,
            '_do_papal': 50,
            '_do_quake': 300,
            '_do_swamp': 200,
            '_do_knight': 350,
            '_do_volcano': 400,
            '_do_flood': 500,
            '_battle_over': 600,
            '_do_shield': 150,
        }
        
        self.view_who = None
        self._force_assemble_recompute = False
        self.view_type = None
        self.scanline_surface = None
        self._update_scanline_surface()
        # Commandes peeps actives par faction
        self.active_peep_command = {
            'allies': '_go_build',
            'foes': '_go_build'
        }
        self.active_peep_target = {
            'allies': (self.game_map.grid_height // 2, self.game_map.grid_width // 2),
            'foes': (self.game_map.grid_height // 2, self.game_map.grid_width // 2)
        }

        # --- Variables pour le tremblement de terre ---
        self.quake_timer = 0.0
        self.quake_shake_y = 0
        self.quake_target = None # (r, c)

        # Activer l'IA
        self.ai = AIPlayer(self, 'foes')
        self.ai.set_difficulty(reaction_speed=1.5, power_rate=15.0, command_rate=20.0)

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

        # Charger les options depuis settings (qui va lire options.json s'il existe)
        self.load_options()

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

    def load_options(self):
        config_path = os.path.join(BASE_DIR, "options.json")
        if os.path.exists(config_path):
            try:
                with open(config_path, "r") as f:
                    opts = json.load(f)
                    settings.GAME_OPTIONS.update(opts)
            except:
                pass

    def _get_peep_sprite_rect(self, peep, cam_r, cam_c, offset_y=0):
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
        sy += offset_y
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

    def _get_house_sprite_rect(self, house, cam_r, cam_c, offset_y=0):
        if house.building_type == 'castle':
            alt = self.game_map.get_corner_altitude(house.r, house.c)
            sx, sy = self.game_map.world_to_screen(house.r, house.c, alt, cam_r, cam_c)
            sy += offset_y
            return pygame.Rect(sx - TILE_WIDTH, sy - TILE_HEIGHT, TILE_WIDTH * 2, TILE_HEIGHT * 2)

        alt = self.game_map.get_corner_altitude(house.r, house.c)
        sx, sy = self.game_map.world_to_screen(house.r, house.c, alt, cam_r, cam_c)
        sy += offset_y
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

    def _draw_leader_marker(self, surface, target, target_type, team, cam_r, cam_c, offset_y=0):
        sprites = Peep.get_sprites()
        coord = (4, 8) if team == 'allies' else (4, 9)
        leader_sprite = sprites.get(coord)
        if leader_sprite is None:
            return

        if target_type == 'peep':
            rect = self._get_peep_sprite_rect(target, cam_r, cam_c, offset_y=offset_y)
            # à la même place que le shield
            x = rect.centerx - 1
            y = rect.centery - leader_sprite.get_height() // 2 + 2
            surface.blit(leader_sprite, (x, y))
            return

        if getattr(target, 'building_type', None) == 'castle':
            center_r = getattr(target, 'r', 0)
            center_c = getattr(target, 'c', 0)
            alt = self.game_map.get_corner_altitude(center_r, center_c)
            sx, sy = self.game_map.world_to_screen(center_r, center_c, alt, cam_r, cam_c)
            sy += offset_y
            # Simule un "rect" virtuel pour la case centrale
            rect = pygame.Rect(sx - TILE_HALF_W, sy, TILE_WIDTH, TILE_HEIGHT)
            x = rect.centerx - leader_sprite.get_width() // 2 + 11
            y = rect.top - leader_sprite.get_height() - 2 + 23
            surface.blit(leader_sprite, (x, y))
            return

        # Pour les maisons régulières
        rect = self._get_house_sprite_rect(target, cam_r, cam_c, offset_y=offset_y)
        x = rect.centerx - leader_sprite.get_width() // 2 + 11
        y = rect.top - leader_sprite.get_height() - 2 + 23
        surface.blit(leader_sprite, (x, y))

    def _draw_shield_marker(self, surface, target, target_type, cam_r, cam_c, offset_y=0):
        sprites = Peep.get_sprites()
        shield_sprite = sprites.get((8, 8))
        if shield_sprite is None:
            return

        if target_type == 'peep':
            rect = self._get_peep_sprite_rect(target, cam_r, cam_c, offset_y=offset_y)
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
            sy += offset_y
            # Simule un "rect" virtuel pour la case centrale
            rect = pygame.Rect(sx - TILE_HALF_W, sy, TILE_WIDTH, TILE_HEIGHT)
            x = rect.centerx - shield_sprite.get_width() // 2 + 11
            y = rect.top - shield_sprite.get_height() - 2 + 23
            surface.blit(shield_sprite, (x, y))
            return

        rect = self._get_house_sprite_rect(target, cam_r, cam_c, offset_y=offset_y)
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
        target = self.shield_target['allies']
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
        team = getattr(target, 'team', 'allies')
        colony_sprite = sprites.get((4, 9) if team == 'foes' else (4, 8))
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
            is_knight = getattr(target, 'is_knight', False)
            if is_knight:
                from peep import KNIGHT_FRAMES as frames_set
            elif team == 'foes':
                from peep import FOE_WALK_FRAMES as frames_set
            else:
                from peep import WALK_FRAMES as frames_set
            
            anim = frames_set.get(facing, frames_set['IDLE'])
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

    def play_sound(self, name):
        if name in self.sounds:
            self.sounds[name].play()

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
        if action != '_do_volcano':
            self.volcano_mode = False
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
        elif action == '_do_volcano':
            cost = self.POWER_COSTS['_do_volcano']
            if self.power_jauge['allies'] >= cost:
                self.power_jauge['allies'] -= cost
                # Le centre de la vue actuelle (8x8) est à cam.r + 4, cam.c + 4
                target_r = int(self.camera.r + 4)
                target_c = int(self.camera.c + 4)
                self.game_map.do_volcano(target_r, target_c)
                self.play_sound('do_volcano')
                print(f"Volcan lancé au centre de la vue ({target_r}, {target_c})")
                # On reste en raise_terrain après
                self._handle_ui_click('_raise_terrain', held=False)
            else:
                print("Pas assez de power pour volcan !")
        elif action == '_do_flood':
            cost = self.POWER_COSTS['_do_flood']
            if self.power_jauge['allies'] >= cost:
                self.power_jauge['allies'] -= cost
                self.game_map.do_flood()
                self.play_sound('do_flood')
                print("Flood lancé ! Toute la carte a baissé de 1.")
                # Retour au mode sélectionné
                self._handle_ui_click('_raise_terrain', held=False)
            else:
                print("Pas assez de power pour flood !")
        elif action == '_do_quake':
            cost = self.POWER_COSTS['_do_quake']
            if self.power_jauge['allies'] >= cost:
                self.power_jauge['allies'] -= cost
                # Déclenche l'effet visuel et le son
                self.quake_timer = 2.0
                self.quake_target = (int(self.camera.r + 4), int(self.camera.c + 4))
                self.play_sound('do_quake')
                print("Tremblement de terre lancé ! Secousse en cours...")
                # Retour au mode sélectionné
                self._handle_ui_click('_raise_terrain', held=False)
            else:
                print("Pas assez de power pour quake !")
        elif action == '_do_swamp':
            cost = self.POWER_COSTS['_do_swamp']
            if self.power_jauge['allies'] >= cost:
                self.power_jauge['allies'] -= cost
                target_r, target_c = int(self.camera.r + 4), int(self.camera.c + 4)
                self.game_map.do_swamp(target_r, target_c)
                self.play_sound('swamp')
                print(f"Marécage lancé au centre de la vue ({target_r}, {target_c})")
                # Retour au mode sélectionné
                self._handle_ui_click('_raise_terrain', held=False)
            else:
                print("Pas assez de power pour marécage !")
        elif action == '_do_knight':
            cost = self.POWER_COSTS['_do_knight']
            if self.power_jauge['allies'] >= cost:
                leader = self.leader_target['allies']
                if leader is not None and isinstance(leader, Peep):
                    self.power_jauge['allies'] -= cost
                    leader.is_knight = True
                    leader.is_leader = False
                    self.leader_target['allies'] = None
                    leader.set_command('_go_fight')
                    print("Un Peep leader est devenu un Chevalier !")
                else:
                    if leader is not None:
                        # Cas où le leader est un bâtiment, on ne le transforme pas directement. Peut-être faire sortir le peep ?
                        print("Le leader est dans un bâtiment. Impossible de le transformer en chevalier, attendez qu'il sorte.")
                    else:
                        print("Aucun leader allié à transformer en chevalier !")
                self._handle_ui_click('_raise_terrain', held=False)
            else:
                print("Pas assez de power pour do_knight !")
        elif action == '_find_papal':
            if self.papal_position['allies']:
                r, c = self.papal_position['allies']
                self.camera.center_on(r, c)
                print(f"Caméra centrée sur le papal ({r}, {c})")
        elif action == '_find_knight':
            knights = [p for p in self.peeps if not p.dead and p.team == 'allies' and getattr(p, 'is_knight', False)]
            if knights:
                self._last_knight_index = getattr(self, '_last_knight_index', -1) + 1
                if self._last_knight_index >= len(knights):
                    self._last_knight_index = 0
                target = knights[self._last_knight_index]
                self.camera.center_on(target.y, target.x)
                self.view_who = target
                self.view_type = 'peep'
                print(f"Caméra centrée sur le chevalier ({target.y}, {target.x})")
            else:
                print("Aucun chevalier allié trouvé.")
        elif action == '_find_shield':
            if self.shield_target['allies'] is not None:
                target = self.shield_target['allies']
                # La cible peut être un Peep (x, y) ou une House (r, c)
                r = getattr(target, 'y', getattr(target, 'r', None))
                c = getattr(target, 'x', getattr(target, 'c', None))
                if r is not None and c is not None:
                    self.camera.center_on(r, c)
                    # Forcer la vue sur l'unité
                    self.view_who = target
                    self.view_type = 'peep' if isinstance(target, Peep) else 'house'
                    print(f"Caméra centrée sur le shield ({r}, {c})")
        else:
            # Commandes de déplacement peep : activation exclusive
            if action in ['_go_build', '_go_assemble', '_go_papal', '_go_fight']:
                # Ne rien faire si la commande est déjà active
                if self.active_peep_command['allies'] == action and (
                    (action != '_go_papal') or (self.active_peep_target['allies'] == self.papal_position['allies'])
                ):
                    print(f"Commande {action} déjà active, aucune modification.")
                    return
                self.active_peep_command['allies'] = action
                if action == '_go_papal':
                    self.active_peep_target['allies'] = self.papal_position['allies']
                else:
                    self.active_peep_target['allies'] = None
                # Attribution des rôles et partenaires pour _go_assemble
                if action == '_go_assemble':
                    peeps = [p for p in self.peeps if not p.dead and p.team == 'allies']
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
                        if peep.team == 'allies':
                            peep.assemble_role = None
                            peep.assemble_partner = None
                for peep in self.peeps:
                    if not peep.dead and peep.team == 'allies':
                        peep.set_command(self.active_peep_command['allies'], self.active_peep_target['allies'])
                print(f"Commande {action} activée (persistante) pour tous les peeps alliés.")
            else:
                print(f"Pouvoir sélectionné (en attente d'implémentation) : {action}")

    def show_options_menu(self):
        import settings
        options_running = True
        # Definitions des options: [label_off, label_on, state, key]
        # state: False = off ('.'), True = on (':')
        menu_items = [
            ["water is harmful", "water is fatal", settings.GAME_OPTIONS.get("water_fatal", False), "water_fatal"],
            ["swamps shallow", "swamps botomless", settings.GAME_OPTIONS.get("swamps_bottomless", False), "swamps_bottomless"],
            ["can build", "cannot build", settings.GAME_OPTIONS.get("cannot_build", False), "cannot_build"],
            ["build up and down", "only build up", settings.GAME_OPTIONS.get("only_build_up", False), "only_build_up"],
            ["build near people", "build near towns", settings.GAME_OPTIONS.get("build_near_towns", True), "build_near_towns"],
            ["BACK TO MENU", "BACK TO MENU", False, None]
        ]
        
        selected = 0
        bg_snapshot = self.screen.copy()
        cx = self.screen.get_width() // 2
        cy = self.screen.get_height() // 2
        menu_w = 160 * self.display_scale
        menu_h = 130 * self.display_scale
        menu_rect = pygame.Rect(cx - menu_w // 2, cy - menu_h // 2, menu_w, menu_h)

        while options_running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    self.running = False
                    options_running = False
                elif event.type == pygame.KEYDOWN:
                    if event.key in (pygame.K_UP, pygame.K_w):
                        selected = (selected - 1) % len(menu_items)
                    elif event.key in (pygame.K_DOWN, pygame.K_s):
                        selected = (selected + 1) % len(menu_items)
                    elif event.key == pygame.K_ESCAPE:
                        options_running = False
                    elif event.key in (pygame.K_RETURN, pygame.K_SPACE):
                        if selected == len(menu_items) - 1: # Return
                            # Sauvegarder avant de partir
                            for item in menu_items:
                                if item[3] is not None:
                                    settings.GAME_OPTIONS[item[3]] = item[2]
                            config_path = os.path.join(BASE_DIR, "options.json")
                            try:
                                with open(config_path, "w") as f:
                                    json.dump(settings.GAME_OPTIONS, f)
                            except:
                                pass
                            options_running = False
                        else:
                            menu_items[selected][2] = not menu_items[selected][2]

            self.screen.blit(bg_snapshot, (0, 0))
            window_surface = pygame.Surface(self.screen.get_size(), pygame.SRCALPHA)
            # Augmentation de l'opacité (230 au lieu de 200 sur 255)
            pygame.draw.rect(window_surface, (102, 34, 0, 230), menu_rect)
            pygame.draw.rect(window_surface, (200, 150, 80, 255), menu_rect, 2 * self.display_scale)
            self.screen.blit(window_surface, (0, 0))

            title_surf = self.custom_font.render("OPTIONS", (255, 255, 255), self.display_scale)
            self.screen.blit(title_surf, (cx - title_surf.get_width() // 2, cy - menu_h // 2 + 10 * self.display_scale))

            for i, item in enumerate(menu_items):
                # Correction du déballage : on ignore la clé de sauvegarde
                label_off, label_on, state, key = item
                color = (255, 255, 0, 255) if i == selected else (200, 200, 200, 255)
                
                if i == len(menu_items) - 1:
                    display_text = label_off
                else:
                    prefix = ":" if state else "."
                    display_text = f"{prefix} {label_on if state else label_off}"
                
                text_surf = self.custom_font.render(display_text.lower(), color, self.display_scale)
                text_rect = text_surf.get_rect(midleft=(cx - menu_w // 2 + 10 * self.display_scale, cy - 25 * self.display_scale + i * 12 * self.display_scale))
                self.screen.blit(text_surf, text_rect)

            pygame.display.flip()
            self.clock.tick(60)

    def show_pause_menu(self):
        menu_running = True
        options = ["OPTIONS", "QUIT", "BACK TO GAME"]
        selected = 0
        
        # On capture l'écran actuel pour éviter que la transparence ne se superpose en boucle
        bg_snapshot = self.screen.copy()
        
        # Chargement de la police bitmap personnalisée
        if not hasattr(self, 'custom_font'):
            charset = "abcdefghijklmnopqrstuvwxyz1234567890!@#+-_()*%[].:"
            self.custom_font = BitmapFont(os.path.join(GFX_DIR, "font.png"), charset, 6, 5, 1, 1)
        
        def render_pixelated(text, color, scale):
            return self.custom_font.render(text, color, scale)
            
        while menu_running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    self.running = False
                    menu_running = False
                elif event.type == pygame.KEYDOWN:
                    if event.key in (pygame.K_UP, pygame.K_w):
                        selected = (selected - 1) % len(options)
                    elif event.key in (pygame.K_DOWN, pygame.K_s):
                        selected = (selected + 1) % len(options)
                    elif event.key == pygame.K_ESCAPE:
                        menu_running = False
                    elif event.key in (pygame.K_RETURN, pygame.K_SPACE):
                        if selected == 0: # Options
                            self.show_options_menu()
                        elif selected == 1: # Quit
                            self.running = False
                            menu_running = False
                        elif selected == 2: # Return
                            menu_running = False

            # Restaurer le fond du jeu
            self.screen.blit(bg_snapshot, (0, 0))

            # Dessiner la fenêtre semi-transparente
            window_surface = pygame.Surface(self.screen.get_size(), pygame.SRCALPHA)
            
            menu_w = 120 * self.display_scale
            menu_h = 100 * self.display_scale
            cx = self.screen.get_width() // 2
            cy = self.screen.get_height() // 2
            menu_rect = pygame.Rect(cx - menu_w // 2, cy - menu_h // 2, menu_w, menu_h)
            
            # Augmentation de l'opacité (230 au lieu de 200 sur 255)
            pygame.draw.rect(window_surface, (102, 34, 0, 230), menu_rect)
            # Bordure pour démarquer la fenêtre
            pygame.draw.rect(window_surface, (200, 150, 80, 255), menu_rect, 2 * self.display_scale)
            
            self.screen.blit(window_surface, (0, 0))

            # Dessiner les textes avec la technique de pixélisation
            title_surf = render_pixelated("MENU", (255, 255, 255), self.display_scale)
            self.screen.blit(title_surf, (cx - title_surf.get_width() // 2, cy - menu_h // 2 + 10 * self.display_scale))

            for i, opt in enumerate(options):
                color = (255, 255, 0, 255) if i == selected else (200, 200, 200, 255)
                text_surf = render_pixelated(opt, color, self.display_scale)
                text_rect = text_surf.get_rect(center=(cx, cy - 5 * self.display_scale + i * 15 * self.display_scale))
                self.screen.blit(text_surf, text_rect)

            pygame.display.flip()
            self.clock.tick(60)

    def events(self):
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    self.show_pause_menu()
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
                    self.game_map.swamps.clear()
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
                            if self.shield_target['allies'] is not None:
                                setattr(self.shield_target['allies'], 'has_shield', False)
                            
                            self.shield_target['allies'] = self.view_who
                            setattr(self.shield_target['allies'], 'has_shield', True)
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
                                if self.power_jauge['allies'] >= self.POWER_COSTS['_do_papal']:
                                    self.power_jauge['allies'] -= self.POWER_COSTS['_do_papal']
                                    # Place/déplace le papal (un seul possible) sur la case au nord-ouest (NW)
                                    self.papal_position['allies'] = (max(r - 1, 0), max(c - 1, 0))
                                    self.active_peep_target['allies'] = self.papal_position['allies']
                                    # Forcer la mise à jour des commandes pour tous les peeps alliés si on est déjà en mode _go_papal
                                    if self.active_peep_command['allies'] == '_go_papal':
                                        for peep in self.peeps:
                                            if not peep.dead and peep.team == 'allies':
                                                peep.set_command('_go_papal', self.papal_position['allies'])
                                    self.papal_mode = False  # Désactive le mode après un clic
                                else:
                                    print("Pas assez de power pour papal !")
                            elif event.button == 3:
                                # Annule le mode papal et revient à raise_terrain
                                self.papal_mode = False
                                self._handle_ui_click('_raise_terrain', held=False)
                            return
                        elif not self.papal_mode and not self.shield_mode and not self.volcano_mode:
                            if event.button == 1:
                                cost = self.game_map.get_raise_cost(r, c)
                                if cost > 0:
                                    if self.power_jauge['allies'] >= cost:
                                        self.power_jauge['allies'] -= cost
                                        self.game_map.raise_corner(r, c)
                                    else:
                                        print(f"Pas assez de power pour raise_terrain ! (coût: {cost})")
                            elif event.button == 3:
                                cost = self.game_map.get_lower_cost(r, c)
                                if cost > 0:
                                    if self.power_jauge['allies'] >= cost:
                                        self.power_jauge['allies'] -= cost
                                        self.game_map.lower_corner(r, c)
                                    else:
                                        print(f"Pas assez de power pour lower_terrain ! (coût: {cost})")
            elif event.type == pygame.MOUSEBUTTONUP:
                # Relâchement du clic : stop scroll continu
                self.dpad_held_direction = None

    def _spawn_peep_from_house(self, house, transfer_shield=True):
        team = getattr(house, 'team', 'allies')
        new_peep = Peep(house.r, house.c, self.game_map, team=team)
        new_peep.weapon_type = getattr(house, 'building_type', 'hut')
        new_peep.life = house.max_life
        
        if transfer_shield and (getattr(house, 'has_shield', False) or self.shield_target.get(team) == house):
            new_peep.has_shield = True
            house.has_shield = False
            self.shield_target[team] = new_peep
            if self.view_who == house:
                self.view_who = new_peep
                self.view_type = 'peep'

        if getattr(house, 'has_leader', False) or self.leader_target.get(team) == house:
            new_peep.is_leader = True
            house.has_leader = False
            self.leader_target[team] = new_peep
        
        if self.active_peep_command[team]:
            new_peep.set_command(self.active_peep_command[team], self.active_peep_target[team])
            if self.active_peep_command[team] == '_go_assemble':
                self._force_assemble_recompute = True
        else:
            # Les ennemis ou les alliés sans commande active spawn par défaut en mode build
            new_peep.set_command('_go_build')
                
        return new_peep

    def update(self, dt):
        import time
        # Mise à jour des jauges de pouvoir
        sum_growth = {'allies': 0, 'foes': 0}
        for house in self.game_map.houses:
            if not getattr(house, 'destroyed', False):
                team = getattr(house, 'team', 'allies')
                if team in sum_growth:
                    tier = house.TYPES.index(house.building_type) if house.building_type in house.TYPES else 0
                    max_tier = min(tier, len(house.GROWTH_SPEEDS) - 1)
                    sum_growth[team] += house.GROWTH_SPEEDS[max_tier]

        for team in ['allies', 'foes']:
            self.power_max[team] = 5 * sum_growth[team]
            power_raise = 1 + int(sum_growth[team] / 10)
            self.power_jauge[team] += power_raise * dt
            if self.power_jauge[team] > self.power_max[team]:
                self.power_jauge[team] = self.power_max[team]

        # Recalcul de l'assemblage si nécessaire (ex: après spawn d'un peep)
        if getattr(self, '_force_assemble_recompute', False) and self.active_peep_command['allies'] == '_go_assemble':
            self._force_assemble_recompute = False
            # On réutilise la logique de _go_assemble par proximité
            peeps = [p for p in self.peeps if not p.dead and p.team == 'allies']
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
                if not peep.dead and peep.team == 'allies':
                    peep.set_command(self.active_peep_command['allies'], self.active_peep_target['allies'])
                    
        # Update AI
        if getattr(self, 'ai', None):
            self.ai.update(dt)

        if self.dpad_held_direction:
            self.dpad_held_timer -= dt
            if self.dpad_held_timer <= 0.0:
                self.move_camera_direction(self.dpad_held_direction)
                self.dpad_held_timer = self.dpad_repeat_delay
                self.dpad_last_flash_time = time.time()

        # Mise à jour du tremblement de terre
        if getattr(self, 'quake_timer', 0) > 0:
            self.quake_timer -= dt
            # 10 fois pendant 2s => environ un cycle toutes le 0.2s
            # Mode binaire : une image en haut (0px), une image en bas (+8px)
            # On utilise le timer pour alterner brusquement
            if int(self.quake_timer * 10) % 2 == 0:
                self.quake_shake_y = 0
            else:
                self.quake_shake_y = -8
            
            if self.quake_timer <= 0:
                self.quake_timer = 0
                self.quake_shake_y = 0
                if self.quake_target:
                    self.game_map.do_quake(self.quake_target[0], self.quake_target[1])
                    self.quake_target = None

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
            peep_had_leader = getattr(peep, 'is_leader', False)
            peep.update(dt)

            if getattr(peep, 'just_swamped', False):
                self.play_sound('swamped')
                # Si l'option swamps_bottomless est False, le marécage disparaît après une victime
                if not settings.GAME_OPTIONS.get("swamps_bottomless", False):
                    swamp_pos = peep.just_swamped
                    if isinstance(swamp_pos, tuple) and swamp_pos in self.game_map.swamps:
                        self.game_map.swamps.remove(swamp_pos)
                peep.just_swamped = False
            
            # Si le peep est mort et avait le shield, on perd la cible ou on gère le transfert
            if peep.dead and peep_had_shield:
                # Si un partenaire est vivant et a récupéré le shield, shield_target sera mis à jour par peep.update via la fusion
                # Mais il faut s'assurer que self.shield_target pointe vers le survivant.
                # Cependant, peep.update() ne connaît pas self.shield_target.
                # On fait une vérification de sécurité ici :
                if self.shield_target[peep.team] == peep:
                    found_new = False
                    # On cherche si un peep vivant a maintenant le shield
                    for p in self.peeps:
                        if not p.dead and getattr(p, 'has_shield', False) and p.team == peep.team:
                            self.shield_target[peep.team] = p
                            found_new = True
                            break
                    if not found_new:
                        self.shield_target[peep.team] = None

            # Pareil pour le leader :
            if peep.dead and peep_had_leader:
                if self.leader_target[peep.team] == peep:
                    found_new = False
                    for p in self.peeps:
                        if not p.dead and getattr(p, 'is_leader', False) and p.team == peep.team:
                            self.leader_target[peep.team] = p
                            found_new = True
                            break
                    if not found_new:
                        # Si aucun peep n'a pris le leader par fusion, 
                        # on regarde si une maison vient de le recevoir.
                        for h in self.game_map.houses:
                            if getattr(h, 'has_leader', False) and h.team == peep.team:
                                self.leader_target[peep.team] = h
                                found_new = True
                                break
                        
                        if not found_new:
                            self.leader_target[peep.team] = None
                            # La mort n'est pas causée par l'entrée dans un bâtiment alliée, ni fusion
                            # On place le papal sur la case où le leader est mort
                            if not getattr(peep, 'in_house_leader', False) and not getattr(peep, 'merged_leader', False):
                                rr, cc = int(peep.y), int(peep.x)
                                self.papal_position[peep.team] = (rr, cc)
                                self.active_peep_target[peep.team] = self.papal_position[peep.team]
                                # Optionnel: Rediriger les peeps
                                if self.active_peep_command[peep.team] == '_go_papal':
                                    for p in self.peeps:
                                        if not p.dead and p.team == peep.team:
                                            p.set_command('_go_papal', self.papal_position[peep.team])

            if not peep.dead:
                # NOUVEAU : Devenir Leader au contact du point de ralliement papal
                if peep.state == Peep.STATE_PAPAL:
                    papal_pos = self.papal_position[peep.team]
                    if papal_pos is not None:
                        pr, pc = papal_pos
                        if int(peep.y) == pr and int(peep.x) == pc:
                            # Le premier peep qui entre en contact devient leader (s'il n'y a pas déjà de leader pour son équipe)
                            if self.leader_target[peep.team] is None:
                                peep.is_leader = True
                                self.leader_target[peep.team] = peep

                # NOUVEAU : Combat Peep vs Bâtiment adverse
                # Un peep en WANDER, FIGHT ou PAPAL qui touche un bâtiment adverse lance un combat
                if peep.state in ('wander', 'fight', 'papal'):
                    gr, gc = int(peep.y), int(peep.x)
                    for h in self.game_map.houses:
                        if not h.destroyed and (gr, gc) in h.occupied_tiles and h.team != peep.team:
                            # Combat : on simule un échange de vie
                            # On utilise une vitesse de combat (ex: 20 pts/sec)
                            combat_damage = dt * 20.0
                            
                            # Le bâtiment perd de la vie
                            h.life -= combat_damage
                            # Le peep perd de la vie proportionnellement (le bâtiment se défend avec sa puissance)
                            peep.life -= combat_damage * 0.5
                            
                            # Si le bâtiment arrive à 0, il est converti
                            if h.life <= 0:
                                h.team = peep.team
                                h.life = max(1.0, peep.life * 0.5) # Le bâtiment redémarre avec une fraction de la vie du conquérant
                                if peep_had_shield:
                                    h.has_shield = True
                                    self.shield_target[peep.team] = h
                                if peep_had_leader:
                                    h.has_leader = True
                                    peep.in_house_leader = True
                                    self.leader_target[peep.team] = h
                                peep.life = 0
                                peep.dead = True
                                peep.in_house = True
                                break # Le peep est entré/mort dans le bâtiment
                            
                            # Si le peep meurt avant, le bâtiment reste à l'ennemi avec sa vie actuelle
                            if peep.life <= 0:
                                peep.life = 0
                                peep.dead = True
                                break

                new_house = peep.try_build_house()
                if new_house is not None:
                    # Si le peep avait le shield, on le transfère à la nouvelle maison
                    if peep_had_shield:
                        new_house.has_shield = True
                        self.shield_target[peep.team] = new_house
                    
                    if peep_had_leader:
                        new_house.has_leader = True
                        peep.in_house_leader = True
                        self.leader_target[peep.team] = new_house
                    
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
        active_btn = self.active_peep_command['allies']
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
        offset_y = getattr(self, 'quake_shake_y', 0)

        # Terrain
        self.game_map.draw(self.internal_surface, cam_r, cam_c, offset_y=offset_y)

        # Maisons
        debug_font = pygame.font.SysFont("consolas", 14, bold=True) if self.show_debug else None
        self.game_map.draw_houses(self.internal_surface, cam_r, cam_c, show_debug=self.show_debug, debug_font=debug_font, offset_y=offset_y)
        
        # Dessiner le shield sur les maisons qui le possèdent
        for house in self.game_map.houses:
            if not getattr(house, 'destroyed', False) and getattr(house, 'has_shield', False):
                self._draw_shield_marker(self.internal_surface, house, 'house', cam_r, cam_c, offset_y=offset_y)
            if not getattr(house, 'destroyed', False) and getattr(house, 'has_leader', False):
                self._draw_leader_marker(self.internal_surface, house, 'house', house.team, cam_r, cam_c, offset_y=offset_y)

        start_r, end_r, start_c, end_c = self.game_map.get_visible_bounds(cam_r, cam_c)

        for peep in self.peeps:
            if peep.y < start_r or peep.y >= end_r or peep.x < start_c or peep.x >= end_c:
                continue
            peep.draw(self.internal_surface, cam_r, cam_c, show_debug=self.show_debug, debug_font=debug_font, offset_y=offset_y)
            # Affiche le shield automatique si le peep l'a (même s'il n'est pas sélectionné)
            if getattr(peep, 'has_shield', False):
                self._draw_shield_marker(self.internal_surface, peep, 'peep', cam_r, cam_c, offset_y=offset_y)
            if getattr(peep, 'is_leader', False):
                self._draw_leader_marker(self.internal_surface, peep, 'peep', peep.team, cam_r, cam_c, offset_y=offset_y)

        # --- Affichage du papal (tiles 5,0 ou 5,1) après maisons et peeps ---
        for team, pos in self.papal_position.items():
            if pos is not None:
                papal_coord = (5, 0) if team == 'allies' else (5, 1)
                papal_tile = self.game_map.tile_surfaces.get(papal_coord)
                if papal_tile:
                    r, c = pos
                    start_r, end_r, start_c, end_c = self.game_map.get_visible_bounds(cam_r, cam_c)
                    if start_r <= r < end_r and start_c <= c < end_c:
                        alt = self.game_map.get_corner_altitude(r, c)
                        sx, sy = self.game_map.world_to_screen(r, c, alt, cam_r, cam_c)
                        blit_x = sx - TILE_HALF_W
                        blit_y = sy + offset_y
                        self.internal_surface.blit(papal_tile, (blit_x, blit_y))

        if self.view_who is not None and self.view_type is not None:
            r = getattr(self.view_who, 'y', getattr(self.view_who, 'r', -1))
            c = getattr(self.view_who, 'x', getattr(self.view_who, 'c', -1))
            if start_r <= r < end_r and start_c <= c < end_c:
                # Outil de sélection : on utilise le shield comme curseur sur entité, mais on ne veut pas 
                # qu'il masque un sprite de leader. On trace le shield, puis le leader.
                self._draw_shield_marker(self.internal_surface, self.view_who, self.view_type, cam_r, cam_c, offset_y=offset_y)
                team = getattr(self.view_who, 'team', 'allies')
                if getattr(self.view_who, 'is_leader', getattr(self.view_who, 'has_leader', False)):
                    self._draw_leader_marker(self.internal_surface, self.view_who, self.view_type, team, cam_r, cam_c, offset_y=offset_y)

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

        self._draw_shield_panel(self.internal_surface)

        score_allies = 0
        score_foes = 0
        for peep in self.peeps:
            team = getattr(peep, 'team', 'allies')
            if team == 'allies': 
                score_allies += 1 
            else: 
                score_foes += 1
                
        for house in self.game_map.houses:
            team = getattr(house, 'team', 'allies')
            if team == 'allies':
                score_allies += 1
            else:
                score_foes += 1

        self._draw_bar(self.internal_surface, 258, 16, min((score_allies / 300.0) * 2.0, 2.0), (34,102,204))
        self._draw_bar(self.internal_surface, 314, 16, min((score_foes / 300.0) * 2.0, 2.0), (170,0,0))

        # Affichage du pointeur de powerjauge
        power_pointer = Peep.get_sprites().get((8, 9))
        if power_pointer:
            # Calcul du ratio de remplissage
            ratio = 0.0
            if self.power_max['allies'] > 0:
                ratio = min(1.0, self.power_jauge['allies'] / self.power_max['allies'])
            
            # Position isométrique le long du bord en haut à droite
            # Origine (power=0) : (base_size[0] // 2 + 16, 17)
            # On suit une logique iso 2:1 pour le déplacement
            base_px = self.base_size[0] // 2 + 16
            base_py = 17
            
            # Déplacement maximum de 126 pixels vers la droite
            # Avec un ratio iso 2:1, cela donne 63 pixels vers le bas
            max_dx = 126
            max_dy = 63
            
            px = base_px + (ratio * max_dx)
            py = base_py + (ratio * max_dy)
            
            self.internal_surface.blit(power_pointer, (px, py))

        # Curseur custom affiché partout, curseur système toujours masqué (DESSINÉ APRÈS la minimap et le blason)
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
                f"Houses: {len(self.game_map.houses)}",
                f"Powerjauge {int(self.power_jauge['allies'])} (allies) / {int(self.power_jauge['foes'])} (foes)"
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
