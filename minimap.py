import pygame
from settings import GRID_WIDTH, GRID_HEIGHT, BLACK, WHITE, RED, GREEN, BLUE

class Minimap:
    def __init__(self, x=10, y=10):
        # Position of the minimap on the screen
        self.x = x
        self.y = y
        self.width = GRID_WIDTH + GRID_HEIGHT  # Losange width = 64 + 64 = 128
        self.height = (GRID_WIDTH + GRID_HEIGHT) // 2  # Losange height = 64
        self.rect = pygame.Rect(self.x, self.y, self.width, self.height)

    def draw(self, surface, game_map, camera, peeps=None):
        if peeps is None:
            peeps = []
        
        # Effet de clignotement basé sur le temps (cycle de 0.5 seconde)
        blink = (pygame.time.get_ticks() % 500) > 250
        
        # --- Rendu de la minimap (Moteur _draw_map) ---
        # "Le code convertit les coordonnÃ©es tuiles (X, Y) en pixels-Ã©crans selon une formule : 
        # Y = (X_tuile + Y_tuile) / 2
        # X = (X_tuile + 64) - Y_tuile"

        for r in range(GRID_HEIGHT):
            for c in range(GRID_WIDTH):
                a0 = game_map.get_corner_altitude(r, c)
                a1 = game_map.get_corner_altitude(r, c + 1)
                a2 = game_map.get_corner_altitude(r + 1, c + 1)
                a3 = game_map.get_corner_altitude(r + 1, c)
                
                # Vérifier si c'est de l'eau (tous les coins à 0 ou presque)
                if a0 == 0 and a1 == 0 and a2 == 0 and a3 == 0:
                    color = (0, 0, 200) # Bleu pour l'eau
                else:
                    # Calcul du relief (pente) en comparant les altitudes opposées
                    # La lumière vient généralement du haut/gauche dans les jeux isométriques
                    slope = (a2 - a0) + (a1 - a3)
                    
                    if slope > 0:
                        color = (120, 200, 0)  # Vert clair (Pente éclairée)
                    elif slope < 0:
                        color = (0, 90, 0)     # Vert foncé (Pente ombragée)
                    else:
                        color = (0, 150, 0)    # Vert moyen (Plat)
                
                # Projection isométrique minimale (64 de décalage X de base, moité pour Y)
                px = self.x + c + 64 - r
                py = self.y + (c + r) // 2
                
                # Dessiner le pixel (___pixel)
                surface.set_at((px, py), color)

        # Dessiner les maisons (blanc clignotant, disparait/transparent sinon)
        if blink:
            for house in game_map.houses:
                r, c = house.r, house.c
                px = self.x + c + 64 - r
                py = self.y + (c + r) // 2
                surface.set_at((px, py), WHITE)

        # Dessiner les peeps (bleu clignotant)
        if blink:
            for peep in peeps:
                r_int, c_int = int(peep.y), int(peep.x)
                if 0 <= r_int < GRID_HEIGHT and 0 <= c_int < GRID_WIDTH:
                    px = self.x + c_int + 64 - r_int
                    py = self.y + (c_int + r_int) // 2
                    surface.set_at((px, py), BLUE)

        # Dessiner le losange / focus de la caméra (vue de 8x8 tuiles)
        r_cam = int(camera.r)
        c_cam = int(camera.c)
        s = 8  # taille de la vue couverte
        
        p1 = (self.x + c_cam + 64 - r_cam, self.y + (c_cam + r_cam) // 2)                         # Haut
        p2 = (self.x + (c_cam + s) + 64 - r_cam, self.y + ((c_cam + s) + r_cam) // 2)             # Droite
        p3 = (self.x + (c_cam + s) + 64 - (r_cam + s), self.y + ((c_cam + s) + (r_cam + s)) // 2) # Bas
        p4 = (self.x + c_cam + 64 - (r_cam + s), self.y + (c_cam + (r_cam + s)) // 2)             # Gauche
        
        pygame.draw.polygon(surface, WHITE, [p1, p2, p3, p4], 1)

    def handle_click(self, mouse_x, mouse_y, camera):
        # Vérifie si le clic est dans le bounding box de la minimap
        if self.rect.collidepoint(mouse_x, mouse_y):
            # --- Interaction du clic (_zoom_map) ---
            # "Transformation Inverse : D0 = mousex / 2, Soustrait 32"
            
            # Position relative dans le losange
            rel_x = mouse_x - self.x
            rel_y = mouse_y - self.y
            
            # Formule mathématique pure pour inverser l'isométrique pixel 2D -> Tuiles
            # Y_pixel = (c + r) / 2 => c + r = 2 * Y_pixel
            # X_pixel = (c + 64) - r => c - r = X_pixel - 64
            # => 2c = 2 * Y_pixel + X_pixel - 64 => c = Y_pixel + (X_pixel - 64) / 2
            # => 2r = 2 * Y_pixel - (X_pixel - 64) => r = Y_pixel - (X_pixel - 64) / 2
            
            c = rel_y + (rel_x - 64) / 2
            r = rel_y - (rel_x - 64) / 2
            
            # Excentrer de 4 tuiles (moitié de la vue 8x8) pour centrer le clic
            c -= 4
            r -= 4
            
            # "La vue principale du joueur couvre un bloc de 8x8... bride le décalage à 56"
            # clamp entries
            c = max(0, min(56, int(c)))
            r = max(0, min(56, int(r)))
            
            # Mise à jour de la caméra
            camera.c = float(c)
            camera.r = float(r)
            return True
        return False
