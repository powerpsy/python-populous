import pygame
import random
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
        self.view_type = None
        self.scanline_surface = None
        self._update_scanline_surface()

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
        from peep import PEEP_WALK_FRAMES
        anim = PEEP_WALK_FRAMES.get(peep.facing, PEEP_WALK_FRAMES['IDLE'])
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

    def _draw_shield_panel(self, surface):
        if self.view_who is None or self.view_type is None:
            return

        sprites = Peep.get_sprites()

        # Coordonnées déduites des 4 parties du blason (en haut à droite, UI commence à x=256)
        blason_tl = (271, 4)   # Top-Left (Colonie)
        blason_tr = (287, 2)   # Top-Right (Arme)
        blason_bl = (271, 23)  # Bottom-Left (Sprite/Animation)
        blason_br = (287, 19)  # Bottom-Right (Energie)

        # 1. Colonie bleue (4,8) ou rouge (4,9) -> pour l'instant prenons la bleue
        colony_sprite = sprites.get((4, 8))
        if self.view_type == 'peep' and getattr(self.view_who, 'is_enemy', False):
            colony_sprite = sprites.get((4, 9))
        if colony_sprite:
            surface.blit(colony_sprite, blason_tl)

        # 2. Arme représentée par un sprite
        weapon_idx = None
        if self.view_type == 'house':
            weapon_idx = self.weapon_sprite_indices.get(getattr(self.view_who, 'building_type', ''), None)
        elif self.view_type == 'peep':
            weapon_idx = self.weapon_sprite_indices.get(getattr(self.view_who, 'weapon_type', ''), None)
        if weapon_idx is not None and 0 <= weapon_idx < len(self.weapon_sprites):
            sprite = self.weapon_sprites[weapon_idx]
            # Centrer le sprite dans le quart haut-droit
            x = blason_tr[0] + 2
            y = blason_tr[1] + 1
            surface.blit(sprite, (x, y))
        else:
            # Fallback : lettre grise
            weapon = self._get_weapon_name(self.view_who, self.view_type)
            weapon_letter = 'N' # None
            if weapon != 'Aucune':
                weapon_letter = weapon[0].upper()
            w_text = self.font.render(weapon_letter, True, (240, 240, 240))
            surface.blit(w_text, (blason_tr[0] + 6, blason_tr[1] + 2))

        # 3. Sprite du peep animé, ou drapeau animé pour un bâtiment
        show_flag = (self.view_type == 'house')
        # Si c'était un peep en cours de construction (in_house = True ou similaire), on montre aussi le drapeau
        if self.view_type == 'peep' and getattr(self.view_who, 'in_house', False):
            show_flag = True

        if not show_flag:
            from peep import PEEP_WALK_FRAMES
            facing = getattr(self.view_who, 'facing', 'IDLE')
            anim = PEEP_WALK_FRAMES.get(facing, PEEP_WALK_FRAMES['IDLE'])
            frame_idx = getattr(self.view_who, 'anim_frame', 0) % len(anim)
            peep_idx = anim[frame_idx]
            peep_sprite = sprites.get(peep_idx)
            if peep_sprite:
                # On centre dans le quart bas-gauche
                surface.blit(peep_sprite, blason_bl)
        else:
            # Bâtiment ou peep en construction : drapeau animé (4,0 et 4,1)
            frame_idx = int(pygame.time.get_ticks() / 200) % 2
            flag_sprite = sprites.get((4, frame_idx))
            if flag_sprite:
                # Décaler le drapeau de 3px vers la gauche pour les bâtiments
                blason_flag = (blason_bl[0] - 3, blason_bl[1])
                surface.blit(flag_sprite, blason_flag)

        # 4. Énergie sous forme de 2 rectangles verticaux
        life = float(getattr(self.view_who, 'life', 0.0))
        
        # Barre de gauche (les centaines de vies en jaune)
        hundreds = int(life // 100)
        # Limite visuelle des centaines à 10 pour ne pas déborder (0 à 10)
        max_hundreds = 10.0
        ratio_yellow = min(1.0, max(0.0, hundreds / max_hundreds))
        
        # Barre de droite (les unités de vies en orange)
        units = life % 100
        ratio_orange = min(1.0, max(0.0, units / 99.0))

        bar_w = 4
        bar_max_h = 16
        
        # Fond gris pour les deux jauges
        rect1_x = blason_br[0] + 3
        rect2_x = blason_br[0] + 11
        bar_bg_y = blason_br[1] + 3
        pygame.draw.rect(surface, (102, 102, 102), (rect1_x, bar_bg_y, bar_w, bar_max_h))
        pygame.draw.rect(surface, (102, 102, 102), (rect2_x, bar_bg_y, bar_w, bar_max_h))

        # 1er rectangle : jaune (centaines)
        bar1_h = int(bar_max_h * ratio_yellow)
        bar1_y = bar_bg_y + (bar_max_h - bar1_h)
        if bar1_h > 0:
            pygame.draw.rect(surface, (255, 220, 0), (rect1_x, bar1_y, bar_w, bar1_h))

        # 2ème rectangle : orange (unités)
        bar2_h = int(bar_max_h * ratio_orange)
        bar2_y = bar_bg_y + (bar_max_h - bar2_h)
        if bar2_h > 0:
            pygame.draw.rect(surface, (255, 140, 0), (rect2_x, bar2_y, bar_w, bar2_h))

    def _update_scanline_surface(self):
        w, h = self.screen.get_size()
        self.scanline_surface = pygame.Surface((w, h), pygame.SRCALPHA)
        self.scanline_surface.fill((0, 0, 0, 0))
        for y in range(0, h, max(1, self.display_scale)):
            pygame.draw.line(self.scanline_surface, (0, 0, 0, 100), (0, y), (w, y), 1)

    def spawn_initial_peeps(self, count):
        for _ in range(count):
            r = random.randint(0, GRID_HEIGHT - 1)
            c = random.randint(0, GRID_WIDTH - 1)
            # Ne pas spawn sur l'eau
            if self.game_map.get_corner_altitude(r, c) > 0:
                self.peeps.append(Peep(r, c, self.game_map))

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
                            self.shield_target = self.view_who
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

    def update(self, dt):
        import time
        # Scroll continu D-Pad UI
        if self.dpad_held_direction:
            self.dpad_held_timer -= dt
            if self.dpad_held_timer <= 0.0:
                self.move_camera_direction(self.dpad_held_direction)
                self.dpad_held_timer = self.dpad_repeat_delay
                self.dpad_last_flash_time = time.time()

        self.camera.update(dt)
        self.game_map.update(dt)
        for peep in self.peeps:
            peep.update(dt)
            if not peep.dead:
                new_house = peep.try_build_house()
                if new_house is not None and self.view_type == 'peep' and self.view_who == peep:
                    self.view_who = new_house
                    self.view_type = 'house'

        self.peeps = [p for p in self.peeps if not p.is_removable()]

        # Maisons : update et spawn de peeps
        new_peeps = []
        houses_to_keep = []
        for house in self.game_map.houses:
            house.update(dt, self.game_map)
            if getattr(house, 'destroyed', False):
                # Le terrain n'est plus plat, on détruit la maison et récupère un peep
                new_peep = Peep(house.r, house.c, self.game_map)
                new_peep.life = house.life
                # Donne l'arme du bâtiment détruit
                new_peep.weapon_type = getattr(house, 'building_type', 'hut')
                new_peeps.append(new_peep)
                if self.view_type == 'house' and self.view_who == house:
                    self.view_who = new_peep
                    self.view_type = 'peep'
            else:
                houses_to_keep.append(house)
                if house.can_spawn_peep():
                    new_peep = Peep(house.r, house.c, self.game_map)
                    # Donne l'arme du bâtiment au peep qui sort
                    new_peep.weapon_type = getattr(house, 'building_type', 'hut')
                    new_peeps.append(new_peep)
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

        self.internal_surface.fill(BLACK)
        self.internal_surface.blit(self.ui_image, (0, 0))

        # (Tout le rendu visuel est ici)
        # ...existing code...

        # Affichage du sprite du bouton cliqué si besoin
        import time
        if self.last_button_click is not None:
            action, t0 = self.last_button_click
            show_dpad = False
            # Clignotement si scroll continu D-Pad
            if self.dpad_held_direction == action:
                elapsed = time.time() - self.dpad_last_flash_time
                if elapsed < 0.15:
                    show_dpad = True
                elif elapsed < self.dpad_repeat_delay:
                    show_dpad = False
                else:
                    show_dpad = True  # sécurité, devrait être relancé par update()
            else:
                # Affichage normal (clic unique)
                if (time.time() - t0) < self.dpad_repeat_delay:
                    show_dpad = True
            if show_dpad:
                # Mapping ISO pour l'affichage du sprite du dpad
                dpad_iso_map = {
                    'N': 'NW',
                    'NE': 'N',
                    'E': 'NE',
                    'SE': 'E',
                    'S': 'SE',
                    'SW': 'S',
                    'W': 'SW',
                    'NW': 'W',
                }
                action_affiche = dpad_iso_map.get(action, action)
                idx = self.button_sprite_indices.get(action_affiche)
                if idx is not None and idx < len(self.button_sprites):
                    # Afficher le sprite à la position du bouton
                    shape = self.ui_buttons.get(action)
                    if shape:
                        bcx, bcy = shape['c']
                        sprite = self.button_sprites[idx]
                        sw, sh = sprite.get_size()
                        pos = (int(bcx - sw // 2) + 1, int(bcy - sh // 2))
                        self.internal_surface.blit(sprite, pos)

        cam_r, cam_c = self.camera.r, self.camera.c

        # Terrain
        self.game_map.draw(self.internal_surface, cam_r, cam_c)

        # --- Affichage du papal (tile 5,0) en surimpression ---
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

        # Maisons
        self.game_map.draw_houses(self.internal_surface, cam_r, cam_c)

                                # (no longer manage mouse visibility here)
        start_r, end_r, start_c, end_c = self.game_map.get_visible_bounds(cam_r, cam_c)

        for peep in self.peeps:
            if peep.y < start_r or peep.y >= end_r or peep.x < start_c or peep.x >= end_c:
                continue
            peep.draw(self.internal_surface, cam_r, cam_c)

        if self.view_who is not None and self.view_type is not None:
            # Vérifie si l'entité est bien dans la zone 8x8 visible de la caméra
            r = getattr(self.view_who, 'y', getattr(self.view_who, 'r', -1))
            c = getattr(self.view_who, 'x', getattr(self.view_who, 'c', -1))
            if start_r <= r < end_r and start_c <= c < end_c:
                self._draw_shield_marker(self.internal_surface, self.view_who, self.view_type, cam_r, cam_c)

        # Curseur sur le coin le plus proche (étoile limitée au terrain)
        mouse_x, mouse_y = pygame.mouse.get_pos()
        mouse_x //= self.display_scale
        mouse_y //= self.display_scale

        # Affiche la petite étoile uniquement si la souris est sur le terrain
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

        # Affiche le sprite de remplacement de la souris (papal, shield, etc) partout sur l'écran
        sprites = Peep.get_sprites()
        mx, my = pygame.mouse.get_pos()
        mx //= self.display_scale
        my //= self.display_scale
        if self.papal_mode:
            papal_cursor = sprites.get((4, 14))
            if papal_cursor:
                sprite_rect = papal_cursor.get_rect(topleft=(mx, my))
                self.internal_surface.blit(papal_cursor, sprite_rect)
        elif self.shield_mode:
            shield_cursor = sprites.get((8, 8))
            if shield_cursor:
                sprite_rect = shield_cursor.get_rect(topleft=(mx, my))
                self.internal_surface.blit(shield_cursor, sprite_rect)
        else:
            # Curseur par défaut (4,12) partout
            default_cursor = sprites.get((4, 12))
            if default_cursor:
                sprite_rect = default_cursor.get_rect(topleft=(mx, my))
                self.internal_surface.blit(default_cursor, sprite_rect)

        self.minimap.draw(self.internal_surface, self.game_map, self.camera, self.peeps)

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
