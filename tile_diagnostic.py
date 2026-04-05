"""
Diagnostic des tiles - Génère une image de référence avec les labels de mapping.
Affiche chaque tile avec sa position (row, col) et ce à quoi il est mappé.
Usage: python tile_diagnostic.py
"""

import pygame
import sys
import os
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


def main():
    pygame.init()
    screen = pygame.display.set_mode((100, 100))  # Temp screen pour charger les images

    # Charger les tiles
    sheet = pygame.image.load(TILES_PATH).convert_alpha()

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
    ref_w, ref_h = TILE_WIDTH, TILE_HEIGHT
    tiles = {}
    for r in valid_rows:
        for c in valid_cols:
            x0, x1 = x_starts[c], x_ends[c]
            y0, y1 = y_starts[r], y_ends[r]
            tw, th = x1 - x0, y1 - y0
            sub = sheet.subsurface(pygame.Rect(x0, y0, tw, th)).copy()
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

    screen_w = num_cols * cell_w + spacing + 40
    screen_h = num_rows * cell_h + spacing + 40

    screen = pygame.display.set_mode((screen_w, screen_h))
    pygame.display.set_caption("Tile Diagnostic - Mappings actuels")

    font = pygame.font.SysFont("consolas", 11)
    font_pos = pygame.font.SysFont("consolas", 13, bold=True)

    bg_color = (30, 30, 30)
    screen.fill(bg_color)

    for ri, r in enumerate(valid_rows):
        for ci, c in enumerate(valid_cols):
            if (r, c) not in tiles:
                continue

            x = 20 + ci * cell_w
            y = 20 + ri * cell_h

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

    # Aussi afficher dans la console
    print("\n=== TILE DIAGNOSTIC ===\n")
    for r in valid_rows:
        for c in valid_cols:
            labels = get_tile_label(r, c)
            print(f"  ({r},{c}): {', '.join(labels)}")
        print()

    # Boucle d'événements
    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT or (event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE):
                running = False
        pygame.time.wait(50)

    pygame.quit()


if __name__ == "__main__":
    main()
