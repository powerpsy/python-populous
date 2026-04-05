"""
Sprite Viewer - Visualise les sprites 32x32 extraits de Sprites.PNG
Détecte les cadres noirs (1px) entourant chaque sprite, fond gris entre les cadres.
Contrôles :
  Flèches / WASD : déplacer la vue
  +/- : changer l'espacement entre sprites
  Molette : zoom
  R : reset vue
  Clic : affiche les infos du sprite cliqué dans la console
  Échap : quitter
"""

import pygame
import numpy as np
from PIL import Image
import sys
import os

SPRITE_EXTRACT_SIZE = 16  # Taille dans le spritesheet source
SPRITE_SIZE = 32           # Taille de sortie (×2)


def extract_sprites(image_path):
    """Extrait tous les sprites délimités par des cadres noirs (1px), les redimensionne en 32x32.

    Structure du spritesheet :
    - Fond gris (102,102,102) entre les cadres
    - Cadre noir (0,0,0) de 1px autour de chaque sprite
    - Fond vert foncé (0,51,0) à l'intérieur pour la transparence
    - Sprites de 16x16 pixels dans la source, redimensionnés en 32x32

    Détection : on trouve les colonnes/lignes entièrement noires dans chaque
    rangée de frames, puis on identifie les zones de contenu entre les bordures.
    Les zones > 16px sont centrées/croppées à 16px, les zones < 16px sont paddées.
    """
    img = Image.open(image_path).convert("RGBA")
    data = np.array(img)
    h, w = data.shape[:2]

    # Étape 1: Trouver les rangées de frames via la colonne x=1
    # (bordure gauche la plus à gauche = colonne entièrement noire dans les frames)
    # On cherche les zones noires continues sur la colonne x=1
    frame_rows = []  # liste de (y_top, y_bot) pour chaque rangée de frames
    in_black = False
    y_start = 0
    for y in range(h):
        is_blk = data[y, 1, 0] < 10 and data[y, 1, 1] < 10 and data[y, 1, 2] < 10
        if is_blk and not in_black:
            y_start = y
            in_black = True
        elif not is_blk and in_black:
            frame_rows.append((y_start, y - 1))
            in_black = False
    if in_black:
        frame_rows.append((y_start, h - 1))

    # Étape 2: Pour chaque rangée de frames, trouver les colonnes entièrement noires
    # pour déterminer les bordures verticales
    sprites = []
    for fr_idx, (y_top, y_bot) in enumerate(frame_rows):
        content_y0 = y_top + 1
        content_y1 = y_bot - 1
        content_h = content_y1 - content_y0 + 1

        # Trouver les colonnes entièrement noires dans cette rangée
        full_black_cols = []
        for x in range(w):
            region = data[y_top:y_bot + 1, x, :3]
            if np.all(region < 10):
                full_black_cols.append(x)

        # Grouper les colonnes noires consécutives
        if not full_black_cols:
            continue
        groups = [[full_black_cols[0]]]
        for c in full_black_cols[1:]:
            if c == groups[-1][-1] + 1:
                groups[-1].append(c)
            else:
                groups.append([c])
        col_groups = [(g[0], g[-1]) for g in groups]

        # Extraire les sprites entre bordures consécutives
        sprite_row = []
        for i in range(len(col_groups) - 1):
            cx_start = col_groups[i][-1] + 1  # après la bordure gauche
            cx_end = col_groups[i + 1][0] - 1  # avant la bordure droite
            cw = cx_end - cx_start + 1
            if cw < 3:
                continue  # gap gris/trop petit, ignorer

            # Cropper/padder à SPRITE_EXTRACT_SIZE en largeur
            if cw > SPRITE_EXTRACT_SIZE:
                # Centrer: prendre les 16px centraux
                offset = (cw - SPRITE_EXTRACT_SIZE) // 2
                cx_start += offset
                cw = SPRITE_EXTRACT_SIZE
            crop_x0 = cx_start
            crop_y0 = content_y0

            sprite_img = img.crop((crop_x0, crop_y0,
                                   crop_x0 + min(cw, SPRITE_EXTRACT_SIZE),
                                   crop_y0 + min(content_h, SPRITE_EXTRACT_SIZE))).copy()

            # Padder à 16x16 si nécessaire
            if sprite_img.size[0] < SPRITE_EXTRACT_SIZE or sprite_img.size[1] < SPRITE_EXTRACT_SIZE:
                padded = Image.new("RGBA", (SPRITE_EXTRACT_SIZE, SPRITE_EXTRACT_SIZE), (0, 0, 0, 0))
                padded.paste(sprite_img, (0, 0))
                sprite_img = padded

            # Supprimer le fond vert foncé (0,51,0) et noir pur → transparent
            sprite_data = np.array(sprite_img)
            mask = (
                ((sprite_data[:, :, 0] < 20) & (sprite_data[:, :, 1] < 70) & (sprite_data[:, :, 2] < 20)) |
                ((sprite_data[:, :, 0] == 0) & (sprite_data[:, :, 1] == 0) & (sprite_data[:, :, 2] == 0))
            )
            sprite_data[mask, 3] = 0
            sprite_img = Image.fromarray(sprite_data)

            # Redimensionner 16→32 (nearest neighbor pour garder le pixel art net)
            sprite_img = sprite_img.resize((SPRITE_SIZE, SPRITE_SIZE), Image.NEAREST)

            sprite_row.append(sprite_img)
        sprites.append(sprite_row)

    return sprites



def pil_to_pygame(pil_image):
    """Convertit une image PIL RGBA en surface Pygame."""
    mode = pil_image.mode
    size = pil_image.size
    data = pil_image.tobytes()
    return pygame.image.fromstring(data, size, mode)


def main():
    image_path = os.path.join(os.path.dirname(__file__), "Sprites.PNG")
    if not os.path.exists(image_path):
        print(f"Fichier introuvable : {image_path}")
        sys.exit(1)

    print("Extraction des sprites (16→32)...")
    sprites = extract_sprites(image_path)

    num_rows = len(sprites)
    num_cols = max(len(row) for row in sprites) if sprites else 0

    # Collecter les sprites valides
    valid_sprites = []
    for r, row in enumerate(sprites):
        for c, sprite in enumerate(row):
            valid_sprites.append((r, c, sprite))

    print(f"Grille détectée : {num_cols} colonnes x {num_rows} lignes")
    print(f"Sprites : {len(valid_sprites)} (tous {SPRITE_SIZE}x{SPRITE_SIZE}, fond supprimé)")

    # --- Pygame viewer ---
    pygame.init()
    screen_w, screen_h = 1280, 720
    screen = pygame.display.set_mode((screen_w, screen_h), pygame.RESIZABLE)
    pygame.display.set_caption("Sprite Viewer - Sprites.PNG")
    clock = pygame.time.Clock()
    font = pygame.font.SysFont("consolas", 12)
    font_big = pygame.font.SysFont("consolas", 16)

    def rebuild_surfaces():
        nonlocal pg_sprites
        pg_sprites = []
        for r, c, sprite in valid_sprites:
            surf = pil_to_pygame(sprite)
            pg_sprites.append((r, c, sprite.size[0], sprite.size[1], surf))

    pg_sprites = []
    rebuild_surfaces()

    # Paramètres vue
    spacing = 8
    offset_x = 20
    offset_y = 60
    cam_x, cam_y = 0.0, 0.0
    zoom = 4.0  # Plus gros zoom par défaut car sprites sont petits
    dragging = False
    drag_start = (0, 0)
    cam_drag_start = (0.0, 0.0)

    bg_color = (40, 40, 40)
    grid_color = (80, 80, 80)
    highlight_color = (255, 255, 0)
    selected_sprite = None

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
                    zoom = 4.0
                    spacing = 8

            elif event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 1:
                    dragging = True
                    drag_start = event.pos
                    cam_drag_start = (cam_x, cam_y)
                elif event.button == 4:
                    zoom = min(16.0, zoom * 1.15)
                elif event.button == 5:
                    zoom = max(0.5, zoom / 1.15)
            elif event.type == pygame.MOUSEBUTTONUP:
                if event.button == 1:
                    if dragging:
                        dx = abs(event.pos[0] - drag_start[0])
                        dy = abs(event.pos[1] - drag_start[1])
                        if dx < 5 and dy < 5:
                            mx, my = event.pos
                            selected_sprite = None
                            for r, c, tw, th, surf in pg_sprites:
                                draw_x = offset_x + c * (tw * zoom + spacing) + cam_x
                                draw_y = offset_y + r * (th * zoom + spacing) + cam_y
                                rect = pygame.Rect(draw_x, draw_y, tw * zoom, th * zoom)
                                if rect.collidepoint(mx, my):
                                    selected_sprite = (r, c, tw, th)
                                    print(f"Sprite sélectionné : ligne={r}, colonne={c}, taille={tw}x{th}")
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

        for r, c, tw, th, surf in pg_sprites:
            draw_x = offset_x + c * (tw * zoom + spacing) + cam_x
            draw_y = offset_y + r * (th * zoom + spacing) + cam_y

            if draw_x + tw * zoom < 0 or draw_x > screen_w:
                continue
            if draw_y + th * zoom < 0 or draw_y > screen_h:
                continue

            scaled = pygame.transform.scale(surf, (int(tw * zoom), int(th * zoom)))

            # Damier de transparence
            checker_size = max(4, int(8 * zoom))
            for cy in range(0, int(th * zoom), checker_size):
                for cx in range(0, int(tw * zoom), checker_size):
                    color = (60, 60, 60) if (cx // checker_size + cy // checker_size) % 2 == 0 else (90, 90, 90)
                    pygame.draw.rect(screen, color,
                                     (draw_x + cx, draw_y + cy,
                                      min(checker_size, int(tw * zoom) - cx),
                                      min(checker_size, int(th * zoom) - cy)))

            screen.blit(scaled, (draw_x, draw_y))

            border_color = highlight_color if (selected_sprite and selected_sprite[0] == r and selected_sprite[1] == c) else grid_color
            border_width = 2 if (selected_sprite and selected_sprite[0] == r and selected_sprite[1] == c) else 1
            pygame.draw.rect(screen, border_color,
                             (draw_x - 1, draw_y - 1, int(tw * zoom) + 2, int(th * zoom) + 2), border_width)

            label = font.render(f"{r},{c}", True, (200, 200, 200))
            screen.blit(label, (draw_x + 2, draw_y + 2))

        # Barre d'info
        info_texts = [
            f"Grille: {num_cols}x{num_rows}  |  Sprites: {len(valid_sprites)}  |  Espacement: {spacing}  |  Zoom: {zoom:.1f}x",
            f"Contrôles: Flèches/WASD=déplacer  +/-=espacement  Molette=zoom  R=reset  B=toggle fond  Clic=sélectionner  Échap=quitter",
        ]
        if selected_sprite:
            r, c, tw, th = selected_sprite
            info_texts.append(f"Sélection: sprite[{r}][{c}]  taille={tw}x{th}")

        for i, text in enumerate(info_texts):
            surf = font_big.render(text, True, (255, 255, 255))
            screen.blit(surf, (10, 5 + i * 18))

        pygame.display.flip()
        clock.tick(60)

    pygame.quit()


if __name__ == "__main__":
    main()
