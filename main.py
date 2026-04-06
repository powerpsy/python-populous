import pygame
import random
from settings import *
from game_map import GameMap
from peep import Peep
from house import House
from camera import Camera


class Game:
    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        pygame.display.set_caption("Populous")
        self.clock = pygame.time.Clock()
        self.font = pygame.font.SysFont("consolas", 16)
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
                r, c = self.game_map.screen_to_nearest_corner(
                    mx, my, self.camera.offset_x, self.camera.offset_y
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
        self.screen.fill(BLACK)
        cam_x, cam_y = self.camera.offset_x, self.camera.offset_y

        # Terrain
        self.game_map.draw(self.screen, cam_x, cam_y)

        # Maisons
        self.game_map.draw_houses(self.screen, cam_x, cam_y)

        # Peeps
        for peep in self.peeps:
            peep.draw(self.screen, cam_x, cam_y)

        # Curseur sur le coin le plus proche
        mouse_x, mouse_y = pygame.mouse.get_pos()
        grid_r, grid_c = self.game_map.screen_to_nearest_corner(
            mouse_x, mouse_y, cam_x, cam_y
        )
        if 0 <= grid_r <= self.game_map.grid_height and 0 <= grid_c <= self.game_map.grid_width:
            alt = self.game_map.get_corner_altitude(grid_r, grid_c)
            px, py = self.game_map.world_to_screen(grid_r, grid_c, alt, cam_x, cam_y)
            pygame.draw.circle(self.screen, RED, (px, py + TILE_HALF_H - alt * 14), 3)

        self.draw_debug_info()
        pygame.display.flip()

    def draw_debug_info(self):
        mouse_x, mouse_y = pygame.mouse.get_pos()
        cam_x, cam_y = self.camera.offset_x, self.camera.offset_y
        grid_r, grid_c = self.game_map.screen_to_nearest_corner(
            mouse_x, mouse_y, cam_x, cam_y
        )
        alt = self.game_map.get_corner_altitude(grid_r, grid_c)
        alt_text = str(alt) if alt != -1 else "N/A"

        debug_texts = [
            f"FPS: {self.clock.get_fps():.1f}",
            f"Mouse: ({mouse_x}, {mouse_y})",
            f"Corner: ({grid_r}, {grid_c}) Alt: {alt_text}",
            f"Camera: ({int(cam_x)}, {int(cam_y)})",
            f"Peeps: {len(self.peeps)}",
            f"Houses: {len(self.game_map.houses)}"
        ]
        for i, text in enumerate(debug_texts):
            surf = self.font.render(text, True, WHITE)
            self.screen.blit(surf, (10, 10 + 18 * i))


if __name__ == '__main__':
    try:
        game = Game()
        game.run()
    except Exception as e:
        import traceback
        traceback.print_exc()
        input("Erreur. Appuyez sur Entrée pour quitter.")
