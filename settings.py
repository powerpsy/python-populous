import pygame

# Couleurs
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (200, 0, 0)
GREEN = (0, 180, 0)
BLUE = (0, 0, 200)
GRAY = (128, 128, 128)
LIGHT_GRAY = (200, 200, 200)
DARK_GREEN = (0, 100, 0)
BROWN = (139, 69, 19)

# Paramètres de la grille
GRID_WIDTH = 20
GRID_HEIGHT = 20

# Paramètres de la tuile isométrique
TILE_ISO_WIDTH = 64
TILE_ISO_HEIGHT = 32
TILE_ISO_WIDTH_HALF = TILE_ISO_WIDTH // 2
TILE_ISO_HEIGHT_HALF = TILE_ISO_HEIGHT // 2

# Décalage de la carte à l'écran
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
MAP_OFFSET_X = 400
MAP_OFFSET_Y = 100

ALTITUDE_PIXEL_STEP = 8
LAND_LEVEL_MIN = 0
WATER_LEVEL = -2
MOUNTAIN_LEVEL_MIN = 6

PEEP_COLOR = (255, 220, 120)

ALTITUDE_MIN = 0
ALTITUDE_MAX = 7

TERRAIN_COLORS = {
    0: ((0, 0, 120), (0, 0, 200), 0.8),      # Eau
    1: ((40, 80, 40), (60, 120, 60), 1.0),   # Herbe sombre
    2: ((60, 100, 40), (80, 140, 60), 1.1),
    3: ((100, 140, 60), (140, 200, 80), 1.2),
    4: ((160, 180, 80), (200, 240, 120), 1.3),
    5: ((200, 220, 120), (240, 255, 180), 1.4),
    6: ((240, 240, 120), (255, 255, 200), 1.5), # Jaune clair
    7: ((180, 140, 80), (220, 180, 120), 1.6),  # Brun léger
}
DEFAULT_TERRAIN_COLOR_INFO = ((60, 100, 40), (80, 140, 60), 1.0)