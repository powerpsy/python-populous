import pygame
import random
import os
from settings import *
from game_map import GameMap
from peep import Peep
from house import House
from camera import Camera


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
        self.peeps = []
        self.running = True
        self.show_debug = True
        self.show_scanlines = False
        self.scanline_surface = None
        self._update_scanline_surface()

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
                peep.try_build_house()

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
            else:
                houses_to_keep.append(house)
                if house.can_spawn_peep():
                    new_peep = Peep(house.r, house.c, self.game_map)
                    new_peeps.append(new_peep)
        self.game_map.houses = houses_to_keep
        self.peeps.extend(new_peeps)

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
