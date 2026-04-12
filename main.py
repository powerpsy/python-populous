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
        settings.MAP_OFFSET_X = 191
        settings.MAP_OFFSET_Y = 72
        
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

        
        # Punch a transparent hole in the UI ONLY in the central diamond (flood fill)
        arr = pygame.surfarray.pixels3d(self.ui_image)
        alpha = pygame.surfarray.pixels_alpha(self.ui_image)
        self.transparent_mask = pygame.surfarray.array_alpha(self.ui_image) # To keep original alpha before we edit it
        
        start_x, start_y = 160, 100
        stack = [(start_x, start_y)]
        w, h = self.ui_image.get_size()
        
        while stack:
            x, y = stack.pop()
            if alpha[x, y] == 0:
                continue
            if arr[x, y, 0] <= 10 and arr[x, y, 1] <= 10 and arr[x, y, 2] <= 10:
                alpha[x, y] = 0
                self.transparent_mask[x, y] = 0
                if x + 1 < w: stack.append((x+1, y))
                if x - 1 >= 0: stack.append((x-1, y))
                if y + 1 < h: stack.append((x, y+1))
                if y - 1 >= 0: stack.append((x, y-1))

        del arr
        del alpha

        self.viewport_surface = pygame.Surface(self.view_rect.size, pygame.SRCALPHA)

        self.camera = Camera()
        self.game_map = GameMap(GRID_WIDTH, GRID_HEIGHT)
        self.game_map.randomize()
        self.peeps = []
        self.running = True

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
            elif event.type == pygame.MOUSEBUTTONDOWN:
                mx, my = pygame.mouse.get_pos()
                mx //= self.display_scale
                my //= self.display_scale
                
                # Clics souris (on permet partout puisque le viewport est plein écran)
                if self.view_rect.collidepoint(mx, my):
                    vp_x = mx - self.view_rect.x
                    vp_y = my - self.view_rect.y
                    
                    r, c = self.game_map.screen_to_nearest_corner(
                        vp_x, vp_y, self.camera.offset_x, self.camera.offset_y
                    )
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
        for house in self.game_map.houses:
            house.update(dt)
            if house.can_spawn_peep():
                new_peep = Peep(house.r, house.c, self.game_map)
                new_peeps.append(new_peep)
        self.peeps.extend(new_peeps)

    def draw(self):
        self.internal_surface.fill(BLACK)
        self.internal_surface.blit(self.ui_image, (0, 0))
        self.viewport_surface.fill((0, 0, 0, 0))

        cam_x, cam_y = self.camera.offset_x, self.camera.offset_y

        # Terrain
        self.game_map.draw(self.viewport_surface, cam_x, cam_y)

        # Maisons
        self.game_map.draw_houses(self.viewport_surface, cam_x, cam_y)

        # Peeps
        start_r, end_r, start_c, end_c = self.game_map.get_visible_bounds(cam_x, cam_y)

        for peep in self.peeps:
            if peep.y < start_r or peep.y >= end_r or peep.x < start_c or peep.x >= end_c:
                continue
            peep.draw(self.viewport_surface, cam_x, cam_y)

        # Curseur sur le coin le plus proche
        mouse_x, mouse_y = pygame.mouse.get_pos()
        mouse_x //= self.display_scale
        mouse_y //= self.display_scale

        if self.view_rect.collidepoint(mouse_x, mouse_y):
            vp_x = mouse_x - self.view_rect.x
            vp_y = mouse_y - self.view_rect.y
            
            grid_r, grid_c = self.game_map.screen_to_nearest_corner(
                vp_x, vp_y, cam_x, cam_y
            )
            if 0 <= grid_r <= self.game_map.grid_height and 0 <= grid_c <= self.game_map.grid_width:
                alt = self.game_map.get_corner_altitude(grid_r, grid_c)
                px, py = self.game_map.world_to_screen(grid_r, grid_c, alt, cam_x, cam_y)
                
                sprites = Peep.get_sprites()
                pointer_sprite = sprites.get((8, 11))
                if pointer_sprite:
                    sprite_rect = pointer_sprite.get_rect(center=(px + 5, py + TILE_HALF_H - alt * 14 + 4))
                    self.viewport_surface.blit(pointer_sprite, sprite_rect)
                else:
                    pygame.draw.circle(self.viewport_surface, RED, (px, py + TILE_HALF_H - alt * 14), 3)

        # Blit the viewport on screen (over the UI)
        self.internal_surface.blit(self.viewport_surface, self.view_rect.topleft)

        self.draw_debug_info()
        
        # Scale internal surface to display window size
        scaled_surface = pygame.transform.scale(self.internal_surface, self.screen.get_size())
        self.screen.blit(scaled_surface, (0, 0))
        
        pygame.display.flip()

    def draw_debug_info(self):
        mouse_x, mouse_y = pygame.mouse.get_pos()
        mouse_x //= self.display_scale
        mouse_y //= self.display_scale

        cam_x, cam_y = self.camera.offset_x, self.camera.offset_y
        
        alt_text = "N/A"
        grid_r, grid_c = -1, -1
        if self.view_rect.collidepoint(mouse_x, mouse_y):
            vp_x = mouse_x - self.view_rect.x
            vp_y = mouse_y - self.view_rect.y
            grid_r, grid_c = self.game_map.screen_to_nearest_corner(
                vp_x, vp_y, cam_x, cam_y
            )
            alt = self.game_map.get_corner_altitude(grid_r, grid_c)
            if alt != -1:
                alt_text = str(alt)

        debug_texts = [
            f"FPS: {self.clock.get_fps():.1f}",
            f"Scale: x{self.display_scale}",
            f"Mouse: ({mouse_x}, {mouse_y})",
            f"Corner: ({grid_r}, {grid_c}) Alt: {alt_text}",
            f"Camera: ({int(cam_x)}, {int(cam_y)})",
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
