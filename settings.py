import os

# === Écran ===
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

# === Couleurs ===
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (200, 0, 0)
GREEN = (0, 180, 0)
BLUE = (0, 0, 200)
GRAY = (128, 128, 128)
BROWN = (139, 69, 19)

# === Grille ===
GRID_WIDTH = 20
GRID_HEIGHT = 20

# === Altitude ===
ALTITUDE_MIN = 0
ALTITUDE_MAX = 7
ALTITUDE_PIXEL_STEP = 1

# === Tile isométrique (depuis Tiles.PNG) ===
TILE_WIDTH = 65     # largeur d'un tile dans le spritesheet
TILE_HEIGHT = 48    # hauteur d'un tile dans le spritesheet
TILE_HALF_W = TILE_WIDTH // 2   # 32
TILE_HALF_H = 16  # valeur ajustée visuellement

# === Offsets pour centrer la carte ===
MAP_OFFSET_X = SCREEN_WIDTH // 2
MAP_OFFSET_Y = 100

# === Chemins ===
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
TILES_PATH = os.path.join(BASE_DIR, "Tiles.PNG")
SPRITES_PATH = os.path.join(BASE_DIR, "Sprites.PNG")

# === Tiles spritesheet grid (lignes rouges dans Tiles.PNG) ===
TILES_V_LINES = [(65,66),(132,133),(199,200),(266,267),(333,334),(400,401),(467,468),(534,535),(601,602)]
TILES_H_LINES = [(48,49),(98,99),(148,149),(198,199),(248,249),(298,299),(348,349)]

# === Sprites ===
SPRITE_SIZE = 32

# === Mapping des tiles terrain ===
# Les coins d'une case : A=top(NW), B=right(NE), C=bottom(SE), D=left(SW)
# Clé = (delta_A, delta_B, delta_C, delta_D) par rapport à l'altitude min
# Tiles pentes pour altitude >= 2
# Clé = (delta_NW, delta_NE, delta_SE, delta_SW) par rapport à l'altitude min
SLOPE_TILES = {
    (1, 0, 0, 0): (0, 1),   # NW
    (0, 1, 0, 0): (0, 2),   # NE
    (1, 1, 0, 0): (0, 3),   # NW+NE
    (0, 0, 1, 0): (0, 4),   # SE
    (1, 0, 1, 0): (0, 5),   # NW+SE
    (0, 1, 1, 0): (0, 6),   # NE+SE
    (1, 1, 1, 0): (0, 7),   # NW+NE+SE (SW abaissé)
    (0, 0, 0, 1): (0, 8),   # SW
    (1, 0, 0, 1): (1, 0),   # NW+SW
    (0, 1, 0, 1): (1, 1),   # NE+SW
    (1, 1, 0, 1): (1, 2),   # NW+NE+SW (SE abaissé)
    (0, 0, 1, 1): (1, 3),   # SE+SW
    (1, 0, 1, 1): (1, 4),   # NW+SE+SW (NE abaissé)
    (0, 1, 1, 1): (1, 5),   # NE+SE+SW (NW abaissé)
}

TILE_WATER = (0, 0)
TILE_WATER_2 = (1, 7)       # 2e frame d'animation de l'eau
TILE_FLAT = (1, 6)

# Tiles pentes pour altitude basse (= 1, juste au-dessus de l'eau)
# Même ordre de deltas que SLOPE_TILES, de (1,8) à (3,3)
SLOPE_TILES_LOW = {
    (1, 0, 0, 0): (1, 8),
    (0, 1, 0, 0): (2, 0),
    (1, 1, 0, 0): (2, 1),
    (0, 0, 1, 0): (2, 2),
    (1, 0, 1, 0): (2, 3),
    (0, 1, 1, 0): (2, 4),
    (1, 1, 1, 0): (2, 5),
    (0, 0, 0, 1): (2, 6),
    (1, 0, 0, 1): (2, 7),
    (0, 1, 0, 1): (2, 8),
    (1, 1, 0, 1): (3, 0),
    (0, 0, 1, 1): (3, 1),
    (1, 0, 1, 1): (3, 2),
    (0, 1, 1, 1): (3, 3),
}

# === Tiles bâtiments (de (3,6) à (4,4)) ===
BUILDING_TILES = {
    'hut': (3, 6),
    'house_small': (3, 7),
    'house_medium': (3, 8),
    'castle_small': (4, 0),
    'castle_medium': (4, 1),
    'castle_large': (4, 2),
    'fortress_small': (4, 3),
    'fortress_medium': (4, 4),
}

# === Château 3x3 (tiles (4,5) à (4,8)) ===
# Disposition sur 9 cases :
#   (4,5)(4,8)(4,5)
#   (4,7)(4,6)(4,7)
#   (4,5)(4,8)(4,5)
CASTLE_9_TILES = {
    'corner': (4, 5),
    'center': (4, 6),
    'side_lr': (4, 7),   # côtés gauche/droite
    'side_tb': (4, 8),   # côtés haut/bas
}

# === Tiles objets (ligne 5) ===
OBJECT_TILES = {
    'volcano': (5, 0),
    'cross': (5, 1),
    'mountain_small': (5, 2),
    'mountain_large': (5, 3),
    'tree_small': (5, 4),
    'tree_medium': (5, 5),
    'tree_large': (5, 6),
    'bush': (5, 7),
}

# === Peep ===
PEEP_SPEED = 30.0