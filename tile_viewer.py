"""
Tile Viewer - Visualise et sépare les tiles de Tiles.PNG
Détecte automatiquement les lignes de grille rouges.
Contrôles :
  Flèches / WASD : déplacer la vue
  +/- : changer l'espacement entre tiles
  Molette : zoom
  R : reset vue
  Clic : affiche les infos du tile cliqué dans la console
  Échap : quitter
"""

import pygame
import numpy as np
from PIL import Image
import sys
import os

# --- Détection automatique des lignes de grille rouges ---

def detect_red_lines(image_path, threshold_ratio=0.3, r_min=150, g_max=80, b_max=80):
    """Détecte les lignes de grille rouges (horizontales et verticales) dans l'image."""
    img = Image.open(image_path).convert("RGBA")
    data = np.array(img)
    h, w = data.shape[:2]

    # Lignes verticales : colonnes avec beaucoup de pixels rouges
    v_lines = []
    for x in range(w):
        col = data[:, x, :3]
        red_count = np.sum((col[:, 0] > r_min) & (col[:, 1] < g_max) & (col[:, 2] < b_max))
        if red_count > h * threshold_ratio:
            v_lines.append(x)

    # Lignes horizontales : lignes avec beaucoup de pixels rouges
    h_lines = []
    for y in range(h):
        row = data[y, :, :3]
        red_count = np.sum((row[:, 0] > r_min) & (row[:, 1] < g_max) & (row[:, 2] < b_max))
        if red_count > w * threshold_ratio:
            h_lines.append(y)

    # Grouper les positions proches, retourne (début, fin) de chaque groupe
    def group(positions, gap=3):
        if not positions:
            return []
        groups = [[positions[0]]]
        for p in positions[1:]:
            if p - groups[-1][-1] <= gap:
                groups[-1].append(p)
            else:
                groups.append([p])
        # Retourne (premier pixel, dernier pixel) de chaque ligne rouge
        return [(g[0], g[-1]) for g in groups]

    return group(v_lines), group(h_lines), img.size


def extract_tiles(image_path):
    """Extrait les tiles entre les lignes de grille rouges."""
    v_lines, h_lines, (img_w, img_h) = detect_red_lines(image_path)

    # Construire les bornes des cellules
    # Chaque cellule va de juste après la fin d'une ligne rouge
    # jusqu'à juste avant le début de la ligne rouge suivante
    x_bounds = [0] + [end + 1 for (_, end) in v_lines]
    x_ends = [start for (start, _) in v_lines] + [img_w]

    y_bounds = [0] + [end + 1 for (_, end) in h_lines]
    y_ends = [start for (start, _) in h_lines] + [img_h]

    img = Image.open(image_path).convert("RGBA")

    # Déterminer la taille de référence à partir de la première cellule
    ref_w = x_ends[0] - x_bounds[0]
    ref_h = y_ends[0] - y_bounds[0]

    tiles = []
    for row in range(len(y_bounds)):
        tile_row = []
        for col in range(len(x_bounds)):
            x0, x1 = x_bounds[col], x_ends[col]
            y0, y1 = y_bounds[row], y_ends[row]
            tw, th = x1 - x0, y1 - y0
            if tw < 5 or th < 5:
                tile_row.append(None)
                continue
            # Si le tile est plus petit que la référence (bord d'image tronqué),
            # on le padde avec des pixels transparents pour garder une taille uniforme
            tile_img = img.crop((x0, y0, x1, y1))
            if tw < ref_w or th < ref_h:
                padded = Image.new("RGBA", (ref_w, ref_h), (0, 0, 0, 0))
                padded.paste(tile_img, (0, 0))
                tile_img = padded
            tile_row.append(tile_img)
        tiles.append(tile_row)

    return tiles, v_lines, h_lines


def pil_to_pygame(pil_image):
    """Convertit une image PIL RGBA en surface Pygame."""
    mode = pil_image.mode
    size = pil_image.size
    data = pil_image.tobytes()
    return pygame.image.fromstring(data, size, mode)


def main():
    image_path = os.path.join(os.path.dirname(__file__), "Tiles.PNG")
    if not os.path.exists(image_path):
        print(f"Fichier introuvable : {image_path}")
        sys.exit(1)

    print("Extraction des tiles...")
    tiles, v_lines, h_lines = extract_tiles(image_path)

    num_rows = len(tiles)
    num_cols = max(len(row) for row in tiles)

    # Filtrer les tiles None et les trop petits
    valid_tiles = []
    for r, row in enumerate(tiles):
        for c, tile in enumerate(row):
            if tile is not None and tile.size[0] > 5 and tile.size[1] > 5:
                valid_tiles.append((r, c, tile))

    print(f"Lignes rouges verticales : {v_lines}")
    print(f"Lignes rouges horizontales : {h_lines}")
    print(f"Grille détectée : {num_cols} colonnes x {num_rows} lignes")
    print(f"Tiles valides : {len(valid_tiles)}")

    # --- Pygame viewer ---
    pygame.init()
    screen_w, screen_h = 1280, 720
    screen = pygame.display.set_mode((screen_w, screen_h), pygame.RESIZABLE)
    pygame.display.set_caption("Tile Viewer - Tiles.PNG")
    clock = pygame.time.Clock()
    font = pygame.font.SysFont("consolas", 12)
    font_big = pygame.font.SysFont("consolas", 16)

    # Convertir en surfaces pygame
    pg_tiles = []
    for r, c, tile in valid_tiles:
        surf = pil_to_pygame(tile)
        pg_tiles.append((r, c, tile.size[0], tile.size[1], surf))

    # Paramètres vue
    spacing = 8       # espacement entre tiles
    offset_x = 20     # marge gauche
    offset_y = 60     # marge haute (pour le texte d'info)
    cam_x, cam_y = 0.0, 0.0
    zoom = 2.0
    dragging = False
    drag_start = (0, 0)
    cam_drag_start = (0.0, 0.0)

    bg_color = (40, 40, 40)
    grid_color = (80, 80, 80)
    highlight_color = (255, 255, 0)
    selected_tile = None

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
                elif event.key in (pygame.K_PLUS, pygame.K_KP_PLUS, pygame.K_EQUALS):
                    spacing += 2
                elif event.key in (pygame.K_MINUS, pygame.K_KP_MINUS):
                    spacing = max(0, spacing - 2)
                elif event.key == pygame.K_r:
                    cam_x, cam_y = 0.0, 0.0
                    zoom = 2.0
                    spacing = 8
            elif event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 1:
                    dragging = True
                    drag_start = event.pos
                    cam_drag_start = (cam_x, cam_y)
                elif event.button == 4:  # molette haut
                    zoom = min(8.0, zoom * 1.15)
                elif event.button == 5:  # molette bas
                    zoom = max(0.5, zoom / 1.15)
                elif event.button == 3:  # clic droit
                    pass
            elif event.type == pygame.MOUSEBUTTONUP:
                if event.button == 1:
                    if dragging:
                        # Si pas de drag significatif, c'est un clic
                        dx = abs(event.pos[0] - drag_start[0])
                        dy = abs(event.pos[1] - drag_start[1])
                        if dx < 5 and dy < 5:
                            # Déterminer quel tile a été cliqué
                            mx, my = event.pos
                            selected_tile = None
                            for r, c, tw, th, surf in pg_tiles:
                                draw_x = offset_x + c * (tw * zoom + spacing) + cam_x
                                draw_y = offset_y + r * (th * zoom + spacing) + cam_y
                                rect = pygame.Rect(draw_x, draw_y, tw * zoom, th * zoom)
                                if rect.collidepoint(mx, my):
                                    selected_tile = (r, c, tw, th)
                                    print(f"Tile sélectionné : ligne={r}, colonne={c}, taille={tw}x{th}")
                                    break
                    dragging = False
            elif event.type == pygame.MOUSEMOTION:
                if dragging:
                    dx = event.pos[0] - drag_start[0]
                    dy = event.pos[1] - drag_start[1]
                    cam_x = cam_drag_start[0] + dx
                    cam_y = cam_drag_start[1] + dy
            elif event.type == pygame.VIDEORESIZE:
                screen_w, screen_h = event.w, event.h
                screen = pygame.display.set_mode((screen_w, screen_h), pygame.RESIZABLE)

        # Déplacement clavier
        keys = pygame.key.get_pressed()
        move_speed = 5
        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            cam_x += move_speed
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            cam_x -= move_speed
        if keys[pygame.K_UP] or keys[pygame.K_w]:
            cam_y += move_speed
        if keys[pygame.K_DOWN] or keys[pygame.K_s]:
            cam_y -= move_speed

        # --- Dessin ---
        screen.fill(bg_color)

        # Dessiner les tiles
        for r, c, tw, th, surf in pg_tiles:
            draw_x = offset_x + c * (tw * zoom + spacing) + cam_x
            draw_y = offset_y + r * (th * zoom + spacing) + cam_y

            # Culling : ne pas dessiner hors écran
            if draw_x + tw * zoom < 0 or draw_x > screen_w:
                continue
            if draw_y + th * zoom < 0 or draw_y > screen_h:
                continue

            scaled = pygame.transform.scale(surf, (int(tw * zoom), int(th * zoom)))

            # Damier de fond pour transparence
            checker_size = max(4, int(8 * zoom))
            for cy in range(0, int(th * zoom), checker_size):
                for cx in range(0, int(tw * zoom), checker_size):
                    color = (60, 60, 60) if (cx // checker_size + cy // checker_size) % 2 == 0 else (90, 90, 90)
                    pygame.draw.rect(screen, color,
                                     (draw_x + cx, draw_y + cy,
                                      min(checker_size, int(tw * zoom) - cx),
                                      min(checker_size, int(th * zoom) - cy)))

            screen.blit(scaled, (draw_x, draw_y))

            # Bordure
            border_color = highlight_color if (selected_tile and selected_tile[0] == r and selected_tile[1] == c) else grid_color
            border_width = 2 if (selected_tile and selected_tile[0] == r and selected_tile[1] == c) else 1
            pygame.draw.rect(screen, border_color,
                             (draw_x - 1, draw_y - 1, int(tw * zoom) + 2, int(th * zoom) + 2), border_width)

            # Label (row, col)
            label = font.render(f"{r},{c}", True, (200, 200, 200))
            screen.blit(label, (draw_x + 2, draw_y + 2))

        # Barre d'info en haut
        info_texts = [
            f"Grille: {num_cols}x{num_rows}  |  Tiles: {len(valid_tiles)}  |  Espacement: {spacing}  |  Zoom: {zoom:.1f}x",
            f"Contrôles: Flèches/WASD=déplacer  +/-=espacement  Molette=zoom  R=reset  Clic=sélectionner  Échap=quitter",
        ]
        if selected_tile:
            r, c, tw, th = selected_tile
            info_texts.append(f"Sélection: tile[{r}][{c}]  taille={tw}x{th}")

        for i, text in enumerate(info_texts):
            surf = font_big.render(text, True, (255, 255, 255))
            screen.blit(surf, (10, 5 + i * 18))

        pygame.display.flip()
        clock.tick(60)

    pygame.quit()


if __name__ == "__main__":
    main()
