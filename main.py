import pygame
import random
from settings import *
from game_map import GameMap
from peep import Peep
from camera import Camera

class Game:
    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        pygame.display.set_caption("Populous ISO")
        self.clock = pygame.time.Clock()
        self.font = pygame.font.SysFont("consolas", 16)
        self.camera = Camera(GRID_WIDTH, GRID_HEIGHT)
        self.game_map = GameMap(GRID_WIDTH, GRID_HEIGHT)
        self.game_map.randomize()
        self.peeps = []
        self.running = True

    def spawn_initial_peeps(self, count):
        for _ in range(count):
            # Correction: bornes correctes pour éviter index out of range
            r = random.randint(0, GRID_HEIGHT - 1)
            c = random.randint(0, GRID_WIDTH - 1)
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
            elif event.type == pygame.MOUSEBUTTONDOWN:
                mx, my = pygame.mouse.get_pos()
                r, c = self.game_map.screen_to_nearest_corner(
                    mx, my, self.camera.offset_x, self.camera.offset_y
                )
                if event.button == 1:  # clic gauche = monter
                    self.game_map.raise_corner(r, c)
                elif event.button == 3:  # clic droit = descendre
                    self.game_map.lower_corner(r, c)

    def update(self, dt):
        self.camera.update(dt)
        for peep in self.peeps:
            peep.update(dt)
            # Essayer de construire une maison
            if not peep.dead:
                peep.try_build_house()
        
        # Retirer les peeps morts
        self.peeps = [peep for peep in self.peeps if not peep.is_removable()]

        # Mise à jour des maisons et génération de nouveaux peeps
        new_peeps = []
        for house in self.game_map.houses:
            house.update(dt)
            if house.can_spawn_peep():
                # Créer un nouveau peep près de la maison
                new_peep = Peep(house.r, house.c, self.game_map)
                new_peeps.append(new_peep)
        self.peeps.extend(new_peeps)

    def draw(self):
        self.screen.fill((0, 0, 0))
        # Dessin de la carte avec les tuiles
        for r in range(self.game_map.grid_height):
            for c in range(self.game_map.grid_width):
                self.game_map.draw_tile(self.screen, r, c, self.camera.offset_x, self.camera.offset_y)
        
        # Dessin des maisons par-dessus les tuiles
        self.draw_houses()
        
        # Dessin des peeps
        for peep in self.peeps:
            peep.draw(self.screen, self.camera.offset_x, self.camera.offset_y)
        
        # Affichage du coin le plus proche de la souris
        mouse_x, mouse_y = pygame.mouse.get_pos()
        grid_r, grid_c = self.game_map.screen_to_nearest_corner(
            mouse_x, mouse_y, self.camera.offset_x, self.camera.offset_y
        )
        if 0 <= grid_r <= self.game_map.grid_height and 0 <= grid_c <= self.game_map.grid_width:
            alt = self.game_map.get_corner_altitude(grid_r, grid_c)
            px, py = self.game_map.world_to_screen(grid_r, grid_c, alt, self.camera.offset_x, self.camera.offset_y)
            pygame.draw.circle(self.screen, (255, 0, 0), (int(px), int(py)), 3)
        
        self.draw_debug_info()
        pygame.display.flip()

    def draw_houses(self):
        """Dessine toutes les maisons avec leurs barres de vie"""
        for house in self.game_map.houses:
            # Position de la maison à l'écran
            center_x, center_y = self.game_map.world_to_screen(
                house.r, house.c, 
                self.game_map.get_corner_altitude(house.r, house.c), 
                self.camera.offset_x, self.camera.offset_y
            )
            
            # Dessiner la maison (petit rectangle marron avec toit rouge)
            house_width = 20
            house_height = 20
            
            # Corps de la maison
            pygame.draw.rect(
                self.screen,
                BROWN,  # marron
                (center_x - house_width // 2, center_y - house_height // 2, house_width, house_height)
            )
            
            # Toit rouge
            pygame.draw.polygon(
                self.screen,
                RED,
                [
                    (center_x - house_width // 2, center_y - house_height // 2),
                    (center_x + house_width // 2, center_y - house_height // 2),
                    (center_x, center_y - house_height - 10)
                ]
            )
            
            # Barre de vie de la maison
            bar_width = 30
            bar_height = 4
            bar_x = center_x - bar_width // 2
            bar_y = center_y - house_height - 20
            
            # Fond de la barre (noir)
            pygame.draw.rect(self.screen, BLACK, (bar_x, bar_y, bar_width, bar_height))
            
            # Barre de vie (verte)
            life_ratio = house.life / house.max_life
            life_width = int(bar_width * life_ratio)
            pygame.draw.rect(self.screen, GREEN, (bar_x, bar_y, life_width, bar_height))

    def draw_debug_info(self):
        mouse_x, mouse_y = pygame.mouse.get_pos()
        grid_r, grid_c = self.game_map.screen_to_nearest_corner(
            mouse_x, mouse_y, self.camera.offset_x, self.camera.offset_y
        )
        alt = self.game_map.get_corner_altitude(grid_r, grid_c)
        alt_text = str(alt) if alt != -1 else "N/A"

        debug_texts = [
            f"FPS: {self.clock.get_fps():.1f}",
            f"Mouse: ({mouse_x}, {mouse_y})",
            f"Corner Clicked: ({grid_r}, {grid_c}) Alt: {alt_text}",
            f"Camera Offset: ({int(self.camera.offset_x)}, {int(self.camera.offset_y)})",
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
        input("Erreur détectée. Appuyez sur Entrée pour quitter.")