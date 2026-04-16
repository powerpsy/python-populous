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
    def __init__(self):
        pygame.init()
        self.clock = pygame.time.Clock()
        self.font = pygame.font.SysFont("consolas", 16)
        
        # Charger l'interface pour déterminer la taille de l'écran
        ui_path = os.path.join(GFX_DIR, "AmigaUI.png")
        ui_raw = pygame.image.load(ui_path)
        
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
        self.peeps = []
        self.running = True
        self.show_debug = False
        self.show_scanlines = False
        self.view_who = None
        self.view_type = None
        self.scanline_surface = None
        self._update_scanline_surface()

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
        frames = {
            'N': [(0, 0), (0, 1)],
            'NE': [(0, 2), (0, 3)],
            'E': [(0, 4), (0, 5)],
            'SE': [(0, 6), (0, 7)],
            'S': [(0, 8), (0, 9)],
            'SW': [(0, 10), (0, 11)],
            'W': [(0, 12), (0, 13)],
            'NW': [(0, 14), (0, 15)],
            'IDLE': [(0, 8), (0, 9)],
            'DROWN': [(5, 8), (5, 9), (5, 10), (5, 11)],
        }
        anim = frames.get(peep.facing, frames['IDLE'])
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
        blason_tl = (271, 4)   # Top-Left (Colonie) : décalé de 5px droite, 7px haut
        blason_tr = (287, 2)   # Top-Right (Arme) : décalé de 5px gauche, 7px haut
        blason_bl = (271, 23)  # Bottom-Left (Sprite/Animation) : inchangé
        blason_br = (287, 19)  # Bottom-Right (Energie) : décalé 3px gauche, 7px haut

        # 1. Colonie bleue (4,8) ou rouge (4,9) -> pour l'instant prenons la bleue
        colony_sprite = sprites.get((4, 8))
        if self.view_type == 'peep' and getattr(self.view_who, 'is_enemy', False):
            colony_sprite = sprites.get((4, 9))
        if colony_sprite:
            surface.blit(colony_sprite, blason_tl)

        # 2. Arme représentée par une lettre
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
            frames = {
                'N': [(0, 0), (0, 1)],
                'NE': [(0, 2), (0, 3)],
                'E': [(0, 4), (0, 5)],
                'SE': [(0, 6), (0, 7)],
                'S': [(0, 8), (0, 9)],
                'SW': [(0, 10), (0, 11)],
                'W': [(0, 12), (0, 13)],
                'NW': [(0, 14), (0, 15)],
                'IDLE': [(0, 8), (0, 9)],
                'DROWN': [(5, 8), (5, 9), (5, 10), (5, 11)],
            }
            facing = getattr(self.view_who, 'facing', 'IDLE')
            anim = frames.get(facing, frames['IDLE'])
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
        
        # 1er rectangle : jaune (centaines)
        bar1_h = int(bar_max_h * ratio_yellow)
        rect1_x = blason_br[0] + 4
        bar1_y = blason_br[1] + 2 + (bar_max_h - bar1_h)
        if bar1_h > 0:
            pygame.draw.rect(surface, (255, 220, 0), (rect1_x, bar1_y, bar_w, bar1_h))

        # 2ème rectangle : orange (unités)
        bar2_h = int(bar_max_h * ratio_orange)
        rect2_x = blason_br[0] + 12
        bar2_y = blason_br[1] + 2 + (bar_max_h - bar2_h)
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
        self.spawn_initial_peeps(10)
        while self.running:
            dt = self.clock.tick(60) / 1000.0
            self.events()
            self.update(dt)
            self.draw()

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

                # Clic droit sur entité: active le shield (peep ou bâtiment)
                if event.button == 3 and self._select_view_target(mx, my):
                    continue

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
                        if event.button == 1:
                            self.game_map.raise_corner(r, c)
                        elif event.button == 3:
                            self.game_map.lower_corner(r, c)

    def update(self, dt):
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
                new_peeps.append(new_peep)
                if self.view_type == 'house' and self.view_who == house:
                    self.view_who = new_peep
                    self.view_type = 'peep'
            else:
                houses_to_keep.append(house)
                if house.can_spawn_peep():
                    new_peep = Peep(house.r, house.c, self.game_map)
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

        cam_r, cam_c = self.camera.r, self.camera.c

        # Terrain
        self.game_map.draw(self.internal_surface, cam_r, cam_c)

        # Maisons
        self.game_map.draw_houses(self.internal_surface, cam_r, cam_c)

        # Peeps
        start_r, end_r, start_c, end_c = self.game_map.get_visible_bounds(cam_r, cam_c)

        for peep in self.peeps:
            if peep.y < start_r or peep.y >= end_r or peep.x < start_c or peep.x >= end_c:
                continue
            peep.draw(self.internal_surface, cam_r, cam_c)

        if self.view_who is not None and self.view_type is not None:
            self._draw_shield_marker(self.internal_surface, self.view_who, self.view_type, cam_r, cam_c)

        # Curseur sur le coin le plus proche
        mouse_x, mouse_y = pygame.mouse.get_pos()
        mouse_x //= self.display_scale
        mouse_y //= self.display_scale

        if self.view_rect.collidepoint(mouse_x, mouse_y):
            vp_x = mouse_x - self.view_rect.x
            vp_y = mouse_y - self.view_rect.y
            
            grid_r, grid_c = self.game_map.screen_to_nearest_corner(
                vp_x, vp_y, cam_r, cam_c
            )
            
            # Afficher le pointeur uniquement s'il est dans la zone visible 8x8 de la caméra
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

        if self.show_debug:
            self.draw_debug_info()
        
        # Scale internal surface to display window size
        scaled_surface = pygame.transform.scale(self.internal_surface, self.screen.get_size())
        self.screen.blit(scaled_surface, (0, 0))
        
        if self.show_scanlines and self.scanline_surface:
            self.screen.blit(self.scanline_surface, (0, 0))
        
        pygame.display.flip()

    def draw_debug_info(self):
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
        for i, text in enumerate(debug_texts):
            surf = self.font.render(text, True, WHITE)
            self.internal_surface.blit(surf, (10, 10 + 18 * i))


if __name__ == '__main__':
    try:
        game = Game()
        game.run()
    except Exception as e:
        import traceback
        traceback.print_exc()
        input("Erreur. Appuyez sur Entrée pour quitter.")
