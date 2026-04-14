import pygame
import sys
import os

# On importe les éléments du jeu
from settings import *
from game_map import GameMap
from house import House
from peep import Peep

class PositioningTest:
    def __init__(self):
        pygame.init()
        # Résolution pour l'outil de test
        self.screen_width = 1000
        self.screen_height = 600
        self.screen = pygame.display.set_mode((self.screen_width, self.screen_height))
        pygame.display.set_caption("Outil de Test d'Alignement - Populous")
        self.clock = pygame.time.Clock()
        self.font = pygame.font.SysFont("consolas", 18)

        self.buildings = House.TYPES
        self.selected_idx = 0
        self.buttons = []

        # Initialisation du layout des boutons
        self.setup_ui()

        # On initialise une GameMap réduite pour le test (assez grande pour les marges)
        self.game_map = GameMap(15, 15)
        self.peep = None

        self.spawn_scene()

    def setup_ui(self):
        self.buttons = []
        start_y = 50
        for i, b_type in enumerate(self.buildings):
            rect = pygame.Rect(10, start_y + i * 35, 200, 30)
            self.buttons.append((rect, b_type, i))

    def spawn_scene(self):
        """Créer le terrain plat nécessaire et instancie bâtiment et peep pour tester l'alignement"""
        # Terrain naturel de base (altitude 1)
        self.game_map.set_all_altitude(1)
        self.game_map.houses.clear()

        # On choisit un point d'ancrage
        h_r, h_c = 4, 4

        # Paliers de score sur les 24 cases adjacentes
        thresholds = [0, 1, 2, 5, 8, 11, 14, 19, 22, 24]
        required_score = thresholds[self.selected_idx]
        
        # La plateforme centrale (bâtiment) est toujours construite
        self.game_map.corners[h_r][h_c] = 2
        self.game_map.corners[h_r][h_c+1] = 2
        self.game_map.corners[h_r+1][h_c+1] = 2
        self.game_map.corners[h_r+1][h_c] = 2

        # Ordre d'expansion du terrain (jusqu'à 24 tuiles adjacentes pour un 5x5 centré sur le bâtiment)
        offsets = [(dr, dc) for dr in range(-2, 3) for dc in range(-2, 3) if not (dr == 0 and dc == 0)]
        # Tri par distance du centre pour avoir une expansion concentrique naturelle
        offsets.sort(key=lambda p: p[0]**2 + p[1]**2)
        
        for i in range(required_score):
            dr, dc = offsets[i]
            tr = h_r + dr
            tc = h_c + dc
            # On monte les coins à l'altitude 2 pour créer un plateau plat à cet endroit
            self.game_map.corners[tr][tc] = 2
            self.game_map.corners[tr][tc+1] = 2
            self.game_map.corners[tr+1][tc+1] = 2
            self.game_map.corners[tr+1][tc] = 2

        # Ajout du bâtiment
        house = House(h_r, h_c)
        # On force un premier update pour calculer son terrain occupé
        # (et définir un cycle de vie initial correspondant à selected_idx)
        house.life = thresholds[self.selected_idx] * 15.0 if self.selected_idx > 0 else 10.0
        house.update(0.1, self.game_map)
        house.building_type = self.buildings[self.selected_idx]
        self.game_map.houses.append(house)

        # On simule un peep sur ou juste devant le bâtiment
        self.peep = Peep(h_r, h_c, self.game_map)
        
        # Optionnel: on fige un peu les coordonnées du Peep pour qu'il soit bien centré sur sa tuile
        self.peep.x = h_c + 0.5
        self.peep.y = h_r + 0.5
        self.peep.direction = 0

    def handle_click(self, pos):
        for rect, b_type, idx in self.buttons:
            if rect.collidepoint(pos):
                self.selected_idx = idx
                self.spawn_scene()
                return

    def run(self):
        running = True
        while running:
            # Même sans mouvement, on peut faire tick pour certaines animations si besoin
            dt = self.clock.tick(60) / 1000.0

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.MOUSEBUTTONDOWN:
                    if event.button == 1:
                        self.handle_click(event.pos)

            # 1) Dessiner la map sur une surface hors-écran (pour pouvoir zoomer)
            map_surface = pygame.Surface((SCREEN_WIDTH, SCREEN_HEIGHT))
            map_surface.fill((40, 40, 40))
            
            cam_r, cam_c = 0, 0
            
            self.game_map.draw(map_surface, cam_r, cam_c)
            self.game_map.draw_houses(map_surface, cam_r, cam_c)
            if self.peep:
                self.peep.draw(map_surface, cam_r, cam_c)

            # Extraire une vue centrée sur le bâtiment, pour zoomer (x3)
            sx, sy = self.game_map.world_to_screen(4, 4, 2, cam_r, cam_c)
            view_w, view_h = 260, 200  # Zone capturée, 260x3 = 780 (largeur reste d'écran), 200x3 = 600
            view_rect = pygame.Rect(sx - view_w // 2, sy - view_h // 2, view_w, view_h)
            view_rect.clamp_ip(map_surface.get_rect())
            
            sub = map_surface.subsurface(view_rect)
            scaled_sub = pygame.transform.scale(sub, (view_rect.width * 3, view_rect.height * 3))
            
            # Application sur l'écran (fond noir)
            self.screen.fill((20, 20, 20))
            # On place la carte zoomée à droite de l'UI (largeur UI ~220)
            self.screen.blit(scaled_sub, (220, 0))

            # 2) Dessiner l'UI (fond pour les boutons afin de les garder lisibles)
            pygame.draw.rect(self.screen, (20, 20, 20), (0, 0, 220, self.screen_height))
            title = self.font.render("Bâtiments", True, WHITE)
            self.screen.blit(title, (10, 10))

            for rect, b_type, idx in self.buttons:
                color = (100, 150, 100) if idx == self.selected_idx else (80, 80, 80)
                pygame.draw.rect(self.screen, color, rect)
                pygame.draw.rect(self.screen, WHITE, rect, 1)
                text = self.font.render(b_type, True, WHITE)
                self.screen.blit(text, (rect.x + 5, rect.y + 5))

            # Instructions complémentaires
            thresholds = [0, 1, 2, 5, 8, 11, 14, 19, 22, 24]
            required_score = thresholds[self.selected_idx]
            info_text1 = self.font.render(f"Maison à (4, 4) - Alt 2 (score terrain: {required_score}/24)", True, WHITE)
            info_text2 = self.font.render(f"Peep à (4.5, 4.5)   ", True, WHITE)
            self.screen.blit(info_text1, (250, 10))
            self.screen.blit(info_text2, (250, 30))

            pygame.display.flip()

        pygame.quit()

if __name__ == '__main__':
    app = PositioningTest()
    app.run()
