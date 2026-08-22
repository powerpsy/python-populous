"""
settings.py – Configuration globale du portage Python v2 de Populous.
Aucune dépendance pygame : ce module est importable sans affichage.
"""

import os
import sys

# ---------------------------------------------------------------------------
# Chemins de base
# ---------------------------------------------------------------------------
if getattr(sys, 'frozen', False):
    _BASE_DIR = sys._MEIPASS
else:
    _BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Répertoire racine du projet (parent de python_v2/)
PROJECT_DIR = os.path.dirname(_BASE_DIR)

GFX_DIR = os.path.join(PROJECT_DIR, "data", "gfx")
SFX_DIR = os.path.join(PROJECT_DIR, "data", "sfx")

# ---------------------------------------------------------------------------
# Écran (résolution interne avant mise à l'échelle)
# ---------------------------------------------------------------------------
SCREEN_WIDTH  = 320
SCREEN_HEIGHT = 200
DISPLAY_SCALE = 3          # Facteur d'agrandissement pour l'affichage final

# ---------------------------------------------------------------------------
# Grille terrain
# ---------------------------------------------------------------------------
GRID_WIDTH  = 64
GRID_HEIGHT = 64

# ---------------------------------------------------------------------------
# Altitude
# ---------------------------------------------------------------------------
ALTITUDE_MIN = 0
ALTITUDE_MAX = 7

# ---------------------------------------------------------------------------
# Tile isométrique (pixels dans l'espace interne)
# ---------------------------------------------------------------------------
TILE_W      = 32   # largeur d'un losange
TILE_H      = 24   # hauteur d'un losange
TILE_HALF_W = 16
TILE_HALF_H = 8

# Point d'ancrage de la carte sur l'écran interne (pointe supérieure du losange)
MAP_OFFSET_X = 192
MAP_OFFSET_Y = 64

# ---------------------------------------------------------------------------
# Sprite peep
# ---------------------------------------------------------------------------
SPRITE_SIZE = 16   # taille d'affichage d'un sprite peep (px)

# ---------------------------------------------------------------------------
# Chemins des ressources graphiques
# ---------------------------------------------------------------------------
TILES_PATH         = os.path.join(GFX_DIR, "AmigaTiles1.PNG")
SPRITES_PATH       = os.path.join(GFX_DIR, "AmigaSprites1.PNG")
UI_PATH            = os.path.join(GFX_DIR, "AmigaUI.png")
BUTTON_UI_PATH     = os.path.join(GFX_DIR, "ButtonUI.png")
WEAPONS_PATH       = os.path.join(GFX_DIR, "Weapons.png")
FONT_PATH          = os.path.join(GFX_DIR, "font.png")
WELCOME_PATH       = os.path.join(GFX_DIR, "welcome512.png")

# ---------------------------------------------------------------------------
# Mapping des tiles terrain (ASM Amiga : même logique de lookup)
# Clé = (delta_NW, delta_NE, delta_SE, delta_SW) par rapport à l'altitude min
# Valeur = (row, col) dans le tileset
# ---------------------------------------------------------------------------
SLOPE_TILES = {
    (1, 0, 0, 0): (0, 1),
    (0, 1, 0, 0): (0, 2),
    (1, 1, 0, 0): (0, 3),
    (0, 0, 1, 0): (0, 4),
    (1, 0, 1, 0): (0, 5),
    (0, 1, 1, 0): (0, 6),
    (1, 1, 1, 0): (0, 7),
    (0, 0, 0, 1): (0, 8),
    (1, 0, 0, 1): (1, 0),
    (0, 1, 0, 1): (1, 1),
    (1, 1, 0, 1): (1, 2),
    (0, 0, 1, 1): (1, 3),
    (1, 0, 1, 1): (1, 4),
    (0, 1, 1, 1): (1, 5),
}

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

TILE_WATER   = (0, 0)
TILE_WATER_2 = (1, 7)
TILE_FLAT    = (1, 6)
TILE_SWAMP   = (5, 8)

BUILDING_TILES = {
    'hut':            (3, 6),
    'house_small':    (3, 7),
    'house_medium':   (3, 8),
    'castle_small':   (4, 0),
    'castle_medium':  (4, 1),
    'castle_large':   (4, 2),
    'fortress_small': (4, 3),
    'fortress_medium':(4, 4),
    'fortress_large': (4, 5),
}

CASTLE_9_TILES = {
    'corner':  (4, 5),
    'center':  (4, 6),
    'side_lr': (4, 7),
    'side_tb': (4, 8),
}

OBJECT_TILES = {
    'volcano':        (5, 0),
    'cross':          (5, 1),
    'mountain_small': (5, 2),
    'mountain_large': (5, 3),
    'tree_small':     (5, 4),
    'tree_medium':    (5, 5),
    'tree_large':     (5, 6),
    'bush':           (5, 7),
}

# ---------------------------------------------------------------------------
# Options de jeu (éventuellement surchargées depuis options.json)
# ---------------------------------------------------------------------------
GAME_OPTIONS = {
    "water_fatal":      False,
    "swamps_bottomless": False,
    "cannot_build":     False,
    "only_build_up":    False,
    "build_near_towns": True,
}

# ---------------------------------------------------------------------------
# Vitesse des peeps (cases/seconde)
# ---------------------------------------------------------------------------
PEEP_SPEED = 2.0
