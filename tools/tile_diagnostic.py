"""
Diagnostic des tiles - Génère une image de référence avec les labels de mapping.
Affiche chaque tile avec sa position (row, col) et ce à quoi il est mappé.
Usage: python tile_diagnostic.py
"""


import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import pygame
from settings import *


def _format_slope_label(prefix, dA, dB, dC, dD):
    """Formate un label de pente avec le préfixe (SLOPE/LOW), le delta et les coins."""
    corners = ["NW", "NE", "SE", "SW"]
    deltas = [dA, dB, dC, dD]
    up = [c for c, d in zip(corners, deltas) if d]
    desc = f"{prefix} d({dA},{dB},{dC},{dD}) "
    if len(up) == 0:
        desc += "flat"
    elif len(up) == 1:
        desc += f"{up[0]}+"
    elif len(up) == 2:
        desc += f"{'+'.join(up)}+"
    elif len(up) == 3:
        down = [c for c, d in zip(corners, deltas) if not d]
        desc += f"{down[0]}-"
    return desc


def get_tile_label(row, col):
    """Retourne le label de mapping pour un tile donné."""
    labels = []

    if (row, col) == TILE_WATER:
        labels.append("WATER")
    if (row, col) == TILE_WATER_2:
        labels.append("WATER#2")
    if (row, col) == TILE_FLAT:
        labels.append("FLAT")

    # SLOPE_TILES
    for delta, pos in SLOPE_TILES.items():
        if pos == (row, col):
            dA, dB, dC, dD = delta
            desc = _format_slope_label("SLOPE", dA, dB, dC, dD)
            labels.append(desc)

    # SLOPE_TILES_LOW
    for delta, pos in SLOPE_TILES_LOW.items():
        if pos == (row, col):
            dA, dB, dC, dD = delta
            desc = _format_slope_label("LOW", dA, dB, dC, dD)
            labels.append(desc)

    # BUILDING_TILES
    for name, pos in BUILDING_TILES.items():
        if pos == (row, col):
            labels.append(f"BUILD:{name}")

    # CASTLE_9_TILES
    for name, pos in CASTLE_9_TILES.items():
        if pos == (row, col):
            labels.append(f"CASTLE9:{name}")

    # OBJECT_TILES
    for name, pos in OBJECT_TILES.items():
        if pos == (row, col):
            labels.append(f"OBJ:{name}")

    return labels if labels else ["(non mappé)"]


def load_and_draw_tiles(screen, image_name, args):
    font = pygame.font.SysFont("consolas", 11)
    font_pos = pygame.font.SysFont("consolas", 13, bold=True)
    font_btn = pygame.font.SysFont("consolas", 14, bold=True)
    
    sheet_path = os.path.join(GFX_DIR, image_name) if not os.path.isabs(image_name) else image_name
    if not os.path.exists(sheet_path):
        print(f"Erreur : {sheet_path} introuvable.")
        return screen, []

    sheet_raw = pygame.image.load(sheet_path).convert()
    if "AmigaTiles" in image_name:
        sheet_raw.set_colorkey((0, 49, 0))  # Fond vert transparent
    sheet = sheet_raw.convert_alpha()

    # Génération automatique de la grille si on utilise une image différente
    if "AmigaTiles" in image_name:
        args.tile_width = 32
        args.tile_height = 24
        
        x_starts = [12 + i * 35 for i in range(9)]
        x_ends = [x + args.tile_width for x in x_starts]
        
        y_starts = [10 + i * 27 for i in range(8)]
        y_ends = [y + args.tile_height for y in y_starts]

    elif image_name != TILES_PATH:
        w_img, h_img = sheet.get_size()
        x_starts = []
        x_ends = []
        x = 0
        while x + args.tile_width <= w_img:
            x_starts.append(x)
            x_ends.append(x + args.tile_width)
            x += args.tile_width + args.margin_x
            
        y_starts = []
        y_ends = []
        y = 0
        while y + args.tile_height <= h_img:
            y_starts.append(y)
            y_ends.append(y + args.tile_height)
            y += args.tile_height + args.margin_y
            
    else:
        # Configuration legacy pour le tileset Populous originel
        x_starts = [0] + [e + 1 for _, e in TILES_V_LINES]
        x_ends = [s for s, _ in TILES_V_LINES] + [sheet.get_width()]
        y_starts = [0] + [e + 1 for _, e in TILES_H_LINES]
        y_ends = [s for s, _ in TILES_H_LINES] + [sheet.get_height()]

    # Filtrer les colonnes/lignes trop petites
    valid_cols = [c for c in range(len(x_starts)) if x_ends[c] - x_starts[c] > 5]
    valid_rows = [r for r in range(len(y_starts)) if y_ends[r] - y_starts[r] > 5]

    num_cols = len(valid_cols)
    num_rows = len(valid_rows)

    # Extraire les tiles
    ref_w, ref_h = args.tile_width if image_name != TILES_PATH else TILE_WIDTH, args.tile_height if image_name != TILES_PATH else TILE_HEIGHT
    tiles = {}
    for r in valid_rows:
        for c in valid_cols:
            # Gérer le cas de la dernière ligne restreinte sur les AmigaTiles (seulement 5 tiles)
            if "AmigaTiles" in image_name and r == 7 and c > 4:
                continue
                
            x0, x1 = x_starts[c], x_ends[c]
            y0, y1 = y_starts[r], y_ends[r]
            tw, th = x1 - x0, y1 - y0
            try:
                sub = sheet.subsurface(pygame.Rect(x0, y0, tw, th)).copy()
            except ValueError:
                continue
            if tw < ref_w or th < ref_h:
                padded = pygame.Surface((ref_w, ref_h), pygame.SRCALPHA)
                padded.blit(sub, (0, 0))
                sub = padded
            tiles[(r, c)] = sub

    # Paramètres d'affichage
    zoom = 2.0
    tile_disp_w = int(ref_w * zoom)
    tile_disp_h = int(ref_h * zoom)
    label_h = 50
    spacing = 6
    cell_w = tile_disp_w + spacing
    cell_h = tile_disp_h + label_h + spacing

    top_margin = 60
    screen_w = max(800, num_cols * cell_w + spacing + 40)
    screen_h = num_rows * cell_h + spacing + 40 + top_margin

    if screen.get_size() != (screen_w, screen_h):
        screen = pygame.display.set_mode((screen_w, screen_h))

    pygame.display.set_caption(f"Tile Diagnostic - {image_name}")

    bg_color = (30, 30, 30)
    screen.fill(bg_color)
    
    # Dessiner les boutons
    btn_names = ["AmigaTiles1.PNG", "AmigaTiles2.PNG", "AmigaTiles3.PNG", "AmigaTiles4.PNG"]
    buttons = []
    bx = 20
    for bname in btn_names:
        color = (100, 200, 100) if bname == image_name else (80, 80, 80)
        surf = font_btn.render(bname, True, (255, 255, 255))
        rect = pygame.Rect(bx, 15, surf.get_width() + 20, 30)
        pygame.draw.rect(screen, color, rect, border_radius=5)
        screen.blit(surf, (bx + 10, 22))
        buttons.append((rect, bname))
        bx += rect.width + 10

    for ri, r in enumerate(valid_rows):
        for ci, c in enumerate(valid_cols):
            if (r, c) not in tiles:
                continue

            x = 20 + ci * cell_w
            y = top_margin + 20 + ri * cell_h

            # Damier de fond
            checker = 8
            for cy2 in range(0, tile_disp_h, checker):
                for cx2 in range(0, tile_disp_w, checker):
                    color = (50, 50, 50) if (cx2 // checker + cy2 // checker) % 2 == 0 else (70, 70, 70)
                    pygame.draw.rect(screen, color, (x + cx2, y + cy2,
                                                      min(checker, tile_disp_w - cx2),
                                                      min(checker, tile_disp_h - cy2)))

            # Tile
            scaled = pygame.transform.scale(tiles[(r, c)], (tile_disp_w, tile_disp_h))
            screen.blit(scaled, (x, y))

            # Bordure
            pygame.draw.rect(screen, (100, 100, 100), (x - 1, y - 1, tile_disp_w + 2, tile_disp_h + 2), 1)

            # Position
            pos_surf = font_pos.render(f"({r},{c})", True, (255, 255, 100))
            screen.blit(pos_surf, (x + 2, y + tile_disp_h + 2))

            # Labels de mapping
            labels = get_tile_label(r, c)
            for li, label in enumerate(labels):
                color = (100, 255, 100) if "(non mappé)" not in label else (255, 80, 80)
                label_surf = font.render(label, True, color)
                screen.blit(label_surf, (x + 2, y + tile_disp_h + 16 + li * 13))

    pygame.display.flip()
    return screen, buttons

def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--image", default="AmigaTiles1.PNG", help="Fichier d'image par défaut")
    parser.add_argument("--tile-width", type=int, default=32, help="Largeur d'un tile")
    parser.add_argument("--tile-height", type=int, default=24, help="Hauteur d'un tile")
    parser.add_argument("--margin-x", type=int, default=1, help="Marge horizontale entre tiles")
    parser.add_argument("--margin-y", type=int, default=1, help="Marge verticale entre tiles")
    args = parser.parse_args()

    pygame.init()
    screen = pygame.display.set_mode((800, 600))
    current_image = args.image
    
    screen, buttons = load_and_draw_tiles(screen, current_image, args)

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT or (event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE):
                running = False
            elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                mx, my = event.pos
                for rect, bname in buttons:
                    if rect.collidepoint(mx, my) and bname != current_image:
                        current_image = bname
                        screen, buttons = load_and_draw_tiles(screen, current_image, args)
                        break
        pygame.time.wait(50)

    pygame.quit()


if __name__ == "__main__":
    main()
