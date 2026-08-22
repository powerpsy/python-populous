"""
renderer.py – Module de rendu Populous v2 (portage ASM Amiga).
TOUTE la logique pygame est ici ; les modules de logique n'ont pas de dépendance pygame.

Responsabilités :
    • Chargement des ressources graphiques (tileset, sprites, UI)
    • Rendu du terrain isométrique
    • Rendu des bâtiments et des peeps
    • Rendu de l'interface (UI Amiga, barres de mana, boutons)
    • Rendu de la minimap
    • Rendu des menus et écrans de fin
"""

from __future__ import annotations

import os
import math
import pygame

from settings import (
    SCREEN_WIDTH, SCREEN_HEIGHT, DISPLAY_SCALE,
    TILE_W, TILE_H, TILE_HALF_W, TILE_HALF_H,
    MAP_OFFSET_X, MAP_OFFSET_Y,
    GRID_WIDTH, GRID_HEIGHT,
    TILES_PATH, SPRITES_PATH, UI_PATH, BUTTON_UI_PATH,
    WEAPONS_PATH, FONT_PATH, WELCOME_PATH, GFX_DIR,
    BUILDING_TILES, CASTLE_9_TILES, OBJECT_TILES,
    TILE_WATER, TILE_WATER_2, TILE_FLAT, TILE_SWAMP,
)
from peep_logic import (
    Peep,
    PEEP_WALK_FRAMES, FOE_WALK_FRAMES, KNIGHT_FRAMES,
    BATTLE_FRAMES,
    VICTORY_ALLIE_BEFORE, VICTORY_ALLIE_MAIN,
    VICTORY_FOE_BEFORE,  VICTORY_FOE_MAIN,
)
from house_logic import HOUSE_TYPES, MAX_HEALTHS


# ---------------------------------------------------------------------------
# Chargement des ressources graphiques
# ---------------------------------------------------------------------------

def _load_tiles() -> dict[tuple[int, int], pygame.Surface]:
    """Découpe le tileset Amiga en surfaces 32×24."""
    sheet = pygame.image.load(TILES_PATH).convert()
    sheet.set_colorkey((0, 49, 0))
    sheet = sheet.convert_alpha()

    tw, th = 32, 24
    x_starts = [12 + i * 35 for i in range(9)]
    y_starts = [10 + j * 27 for j in range(8)]

    tiles: dict[tuple[int, int], pygame.Surface] = {}
    for row, y0 in enumerate(y_starts):
        for col, x0 in enumerate(x_starts):
            if row == 7 and col > 4:
                continue
            try:
                sub = sheet.subsurface(pygame.Rect(x0, y0, tw, th)).copy()
            except ValueError:
                continue
            tiles[(row, col)] = sub
    return tiles


def _load_sprites() -> dict[tuple[int, int], pygame.Surface]:
    """Découpe le spritesheet Amiga en surfaces 16×16."""
    sheet = pygame.image.load(SPRITES_PATH).convert()
    sheet.set_colorkey((0, 49, 0))
    sheet = sheet.convert_alpha()

    src_size = 16
    start_x, start_y, stride = 11, 10, 20
    x_starts = [start_x + i * stride for i in range(16)]
    y_starts = [start_y + j * stride for j in range(9)]

    sprites: dict[tuple[int, int], pygame.Surface] = {}
    for row, y0 in enumerate(y_starts):
        for col, x0 in enumerate(x_starts):
            try:
                sub = sheet.subsurface(pygame.Rect(x0, y0, src_size, src_size)).copy()
            except ValueError:
                continue
            # Fond noir → transparent
            arr   = pygame.surfarray.pixels3d(sub)
            alpha = pygame.surfarray.pixels_alpha(sub)
            mask  = (arr[:, :, 0] == 0) & (arr[:, :, 1] == 0) & (arr[:, :, 2] == 0)
            alpha[mask] = 0
            del arr, alpha
            sprites[(row, col)] = sub
    return sprites


def _load_button_sprites() -> list[pygame.Surface]:
    if not os.path.exists(BUTTON_UI_PATH):
        return []
    sheet = pygame.image.load(BUTTON_UI_PATH).convert_alpha()
    sw, sh = 34, 17
    buttons = []
    for row in range(7):
        for col in range(5):
            x, y = col * sw, row * sh
            try:
                buttons.append(sheet.subsurface(pygame.Rect(x, y, sw, sh)).copy())
            except ValueError:
                pass
    return buttons


def _load_weapons() -> list[pygame.Surface]:
    if not os.path.exists(WEAPONS_PATH):
        return []
    sheet = pygame.image.load(WEAPONS_PATH).convert_alpha()
    return [sheet.subsurface(pygame.Rect(i * 16, 0, 16, 16)).copy() for i in range(10)]


# ---------------------------------------------------------------------------
# Police bitmap (ASCII 6×5)
# ---------------------------------------------------------------------------

_FONT_CHARSET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-:/ "


class BitmapFont:
    def __init__(self, path: str, charset: str = _FONT_CHARSET,
                 char_w: int = 6, char_h: int = 5):
        self.char_w = char_w
        self.char_h = char_h
        self.chars: dict[str, pygame.Surface] = {}
        if not os.path.exists(path):
            return
        sheet    = pygame.image.load(path).convert_alpha()
        sw       = sheet.get_width()
        cols     = max(1, (sw + 1) // (char_w + 1))
        for i, ch in enumerate(charset):
            x = (i % cols) * (char_w + 1)
            y = (i // cols) * (char_h + 1)
            try:
                surf = sheet.subsurface(pygame.Rect(x, y, char_w, char_h)).copy()
                self.chars[ch.upper()] = surf
                self.chars[ch.lower()] = surf
            except ValueError:
                pass
        self.chars[' '] = pygame.Surface((char_w, char_h), pygame.SRCALPHA)

    def render(self, text: str, color=(255, 255, 255), scale: int = 1) -> pygame.Surface:
        w = max(0, len(text) * (self.char_w + 1) - 1)
        surf = pygame.Surface((w, self.char_h), pygame.SRCALPHA)
        x = 0
        for ch in text:
            if ch in self.chars:
                cs = self.chars[ch].copy()
                cs.fill(color, special_flags=pygame.BLEND_RGBA_MULT)
                surf.blit(cs, (x, 0))
            x += self.char_w + 1
        if scale > 1:
            surf = pygame.transform.scale(surf, (w * scale, self.char_h * scale))
        return surf


# ---------------------------------------------------------------------------
# Renderer principal
# ---------------------------------------------------------------------------

# Ordre des boutons UI (identique à l'ASM Amiga)
_BUTTON_ORDER = [
    '_do_flood', '_battle_over', '_do_quake', 'N', 'NE', 'E', '_do_shield',
    '_find_papal', '_find_knight', '_do_volcano', '_do_knight', 'NW',
    '_find_shield', 'SE', '_raise_terrain', '_find_battle', '_do_swamp',
    'W', 'SW', 'S', '_do_papal', '_go_papal', '_go_build', '_go_assemble',
    '_go_fight', 'x_FX', 'x_Music', 'x_Pause', 'x_Balance', 'x_World', 'x_Tel',
]

_WEAPON_IDX = {
    'hut': 0, 'house_small': 1, 'house_medium': 2,
    'castle_small': 3, 'castle_medium': 4, 'castle_large': 5,
    'fortress_small': 6, 'fortress_medium': 7, 'fortress_large': 8,
    'castle': 9,
}


class Renderer:
    """
    Gère tout l'affichage.
    Instanciée une seule fois après pygame.init().
    """

    def __init__(self):
        # Charger l'UI pour obtenir la taille de l'écran interne
        ui_raw = pygame.image.load(UI_PATH)
        base_w, base_h = ui_raw.get_size()

        self.base_w = base_w
        self.base_h = base_h
        self.scale  = DISPLAY_SCALE

        self.screen = pygame.display.set_mode(
            (base_w * self.scale, base_h * self.scale)
        )
        pygame.display.set_caption("Populous v2")

        # Surface interne (résolution native Amiga)
        self.internal = pygame.Surface((base_w, base_h))
        self.ui_image = ui_raw.convert_alpha()

        # Ressources
        self.tiles   = _load_tiles()
        self.sprites = _load_sprites()
        Peep.set_sprites(self.sprites)

        self.button_sprites = _load_button_sprites()
        self.button_idx: dict[str, int] = {
            name: i for i, name in enumerate(_BUTTON_ORDER)
        }
        self.weapon_sprites = _load_weapons()

        self.font_bmp = BitmapFont(FONT_PATH)
        self.font_sys = pygame.font.SysFont("consolas", 12)

        # Bienvenue
        self.welcome_surf: pygame.Surface | None = None
        if os.path.exists(WELCOME_PATH):
            self.welcome_surf = pygame.image.load(WELCOME_PATH).convert()

        # Animation eau
        self._water_timer = 0.0
        self._water_frame = 0

        # Bouton actuellement pressé (feedback visuel)
        self._pressed_button: str | None = None
        self._pressed_timer: float = 0.0

        # Scanlines
        self._scanlines = self._make_scanlines()

    # ------------------------------------------------------------------
    # Écrans spéciaux
    # ------------------------------------------------------------------

    def draw_welcome(self) -> None:
        if self.welcome_surf:
            scaled = pygame.transform.scale(
                self.welcome_surf,
                (self.base_w * self.scale, self.base_h * self.scale),
            )
            self.screen.blit(scaled, (0, 0))
        else:
            self.screen.fill((30, 10, 0))
            t = self.font_sys.render("POPULOUS v2 – Press ENTER", True, (255, 200, 50))
            self.screen.blit(t, (20, self.base_h * self.scale // 2))
        pygame.display.flip()

    # ------------------------------------------------------------------
    # Frame principale
    # ------------------------------------------------------------------

    def render(self, gs, camera, dt: float,
               active_command: str = '_go_build',
               ui_state: dict | None = None) -> None:
        """
        Rend une frame complète.
        gs       – GameState
        camera   – Camera
        dt       – delta-temps (secondes)
        active_command – commande peep sélectionnée (pour highlight UI)
        ui_state – état des boutons de l'interface (dict optionnel)
        """
        self._water_timer += dt
        if self._water_timer >= 0.4:
            self._water_timer = 0.0
            self._water_frame ^= 1

        if self._pressed_timer > 0:
            self._pressed_timer -= dt
            if self._pressed_timer <= 0:
                self._pressed_button = None

        # Fond UI
        self.internal.blit(self.ui_image, (0, 0))

        cam_r, cam_c = camera.r, camera.c

        # Tremblement si quake actif
        quake_dy = 0
        if gs._quake_timer > 0:
            quake_dy = int(math.sin(gs._quake_timer * 30) * 2)

        # Terrain
        self._draw_terrain(self.internal, gs.game_map, cam_r, cam_c, quake_dy)

        # Bâtiments
        self._draw_houses(self.internal, gs.game_map.houses, gs.game_map, cam_r, cam_c, quake_dy)

        # Peeps
        self._draw_peeps(self.internal, gs.peeps, cam_r, cam_c, quake_dy)

        # Minimap
        self._draw_minimap(self.internal, gs.game_map, cam_r, cam_c, gs.peeps)

        # Jauges de mana
        self._draw_power_gauge(self.internal, gs.power_jauge, gs.power_max)

        # Boutons UI
        self._draw_buttons(self.internal, active_command, ui_state)

        # Mise à l'échelle vers l'écran
        scaled = pygame.transform.scale(
            self.internal,
            (self.base_w * self.scale, self.base_h * self.scale),
        )
        self.screen.blit(scaled, (0, 0))

        # Scanlines (optionnel)
        # self.screen.blit(self._scanlines, (0, 0))

        # Curseur personnalisé
        self._draw_cursor()

        pygame.display.flip()

    # ------------------------------------------------------------------
    # Terrain
    # ------------------------------------------------------------------

    def _draw_terrain(self, surf, game_map, cam_r, cam_c, offset_y=0):
        start_r = max(0,                int(cam_r) - 1)
        end_r   = min(game_map.grid_height, int(cam_r) + 12)
        start_c = max(0,                int(cam_c) - 1)
        end_c   = min(game_map.grid_width,  int(cam_c) + 12)

        for r in range(start_r, end_r):
            for c in range(start_c, end_c):
                a_nw = game_map.get_corner(r,     c    )
                a_ne = game_map.get_corner(r,     c + 1)
                a_se = game_map.get_corner(r + 1, c + 1)
                a_sw = game_map.get_corner(r + 1, c    )
                avg  = (a_nw + a_ne + a_se + a_sw) / 4.0

                sx, sy = game_map.world_to_screen(r, c, avg, cam_r, cam_c)
                sy += offset_y

                tile_key = game_map.get_tile_key(r, c)

                # Animation eau
                if tile_key == TILE_WATER and self._water_frame == 1:
                    tile_key = TILE_WATER_2

                tile = self.tiles.get(tile_key) or self.tiles.get(TILE_FLAT)
                if tile:
                    surf.blit(tile, (sx - TILE_HALF_W, sy))

                # Rocher
                if (r, c) in game_map.rocks:
                    rock_tile = self.tiles.get(OBJECT_TILES.get('mountain_small', TILE_FLAT))
                    if rock_tile:
                        surf.blit(rock_tile, (sx - TILE_HALF_W, sy - TILE_H // 2))

    # ------------------------------------------------------------------
    # Bâtiments
    # ------------------------------------------------------------------

    def _draw_houses(self, surf, houses, game_map, cam_r, cam_c, offset_y=0):
        for h in sorted(houses, key=lambda h: h.r + h.c):
            if h.destroyed:
                continue
            alt = game_map.get_corner(h.r, h.c)
            sx, sy = game_map.world_to_screen(h.r, h.c, alt, cam_r, cam_c)
            sy += offset_y

            if h.building_type == 'castle':
                self._draw_castle(surf, h, sx, sy)
            else:
                tile_key = BUILDING_TILES.get(h.building_type, BUILDING_TILES['hut'])
                tile = self.tiles.get(tile_key)
                if tile:
                    surf.blit(tile, (sx - TILE_HALF_W, sy - TILE_H // 2))
                # Barre de santé
                self._draw_house_bar(surf, h, sx, sy)

    def _draw_castle(self, surf, h, sx, sy):
        center_tile = self.tiles.get(CASTLE_9_TILES['center'])
        if center_tile:
            surf.blit(center_tile, (sx - TILE_W, sy - TILE_H))

    def _draw_house_bar(self, surf, h, sx, sy):
        bar_w, bar_h = 12, 2
        bx = sx - bar_w // 2
        by = sy - TILE_H - 4
        ratio = min(1.0, h.life / max(1.0, h.max_life))
        pygame.draw.rect(surf, (60, 60, 60), (bx, by, bar_w, bar_h))
        pygame.draw.rect(surf, (255, 160, 0), (bx, by, int(bar_w * ratio), bar_h))

    # ------------------------------------------------------------------
    # Peeps
    # ------------------------------------------------------------------

    def _draw_peeps(self, surf, peeps, cam_r, cam_c, offset_y=0):
        for p in sorted(peeps, key=lambda p: p.y + p.x):
            if p.dead:
                continue
            r_i, c_i = int(p.y), int(p.x)
            fx, fy   = p.x - c_i, p.y - r_i

            # Interpolation bilinéaire de l'altitude
            a_nw = p.game_map.get_corner(r_i,     c_i    )
            a_ne = p.game_map.get_corner(r_i,     c_i + 1)
            a_sw = p.game_map.get_corner(r_i + 1, c_i    )
            a_se = p.game_map.get_corner(r_i + 1, c_i + 1)
            alt  = ((1 - fx) * (1 - fy) * a_nw
                    + fx * (1 - fy) * a_ne
                    + (1 - fx) * fy * a_sw
                    + fx * fy * a_se)

            sx, sy = p.game_map.world_to_screen(p.y, p.x, alt, cam_r, cam_c)
            sy += offset_y
            ground_y = sy + TILE_HALF_H

            sprite = self._get_peep_sprite(p)
            if sprite:
                sw, sh = sprite.get_size()
                surf.blit(sprite, (sx - sw // 2, ground_y - sh))
                # Barre de vie
                self._draw_peep_bar(surf, p, sx, ground_y - sh - 4)

            # Marqueur blason
            if p.has_shield:
                shield_sp = self.sprites.get((8, 8))
                if shield_sp:
                    surf.blit(shield_sp, (sx - 1, ground_y - 20))

    def _get_peep_sprite(self, p: Peep) -> pygame.Surface | None:
        if p.state == 'battle':
            frames = BATTLE_FRAMES
        elif p.state == 'victory_before':
            frames = VICTORY_FOE_BEFORE if p.team == 'foes' else VICTORY_ALLIE_BEFORE
        elif p.state == 'victory_main':
            frames = VICTORY_FOE_MAIN if p.team == 'foes' else VICTORY_ALLIE_MAIN
        elif p.is_knight:
            frames = KNIGHT_FRAMES.get(p.facing, KNIGHT_FRAMES['IDLE'])
        elif p.team == 'foes':
            frames = FOE_WALK_FRAMES.get(p.facing, FOE_WALK_FRAMES['IDLE'])
        else:
            frames = PEEP_WALK_FRAMES.get(p.facing, PEEP_WALK_FRAMES['IDLE'])

        key = frames[p.anim_frame % len(frames)]
        return self.sprites.get(key)

    def _draw_peep_bar(self, surf, p: Peep, sx: int, sy: int):
        bar_w, bar_h = 8, 1
        bx = sx - bar_w // 2
        ratio = min(1.0, p.life / 999.0)
        pygame.draw.rect(surf, (60, 60, 60), (bx, sy, bar_w, bar_h))
        pygame.draw.rect(surf, (255, 200, 0), (bx, sy, int(bar_w * ratio), bar_h))

    # ------------------------------------------------------------------
    # Minimap
    # ------------------------------------------------------------------

    def _draw_minimap(self, surf, game_map, cam_r, cam_c, peeps):
        ox, oy = 0, 0  # Position de la minimap dans l'UI
        blink = (pygame.time.get_ticks() % 500) > 250

        for r in range(GRID_HEIGHT):
            for c in range(GRID_WIDTH):
                a0 = game_map.get_corner(r,     c    )
                a1 = game_map.get_corner(r,     c + 1)
                a2 = game_map.get_corner(r + 1, c + 1)
                a3 = game_map.get_corner(r + 1, c    )

                if a0 == 0 and a1 == 0 and a2 == 0 and a3 == 0:
                    color = (0, 0, 200)
                else:
                    slope = (a2 - a0) + (a1 - a3)
                    if slope > 0:
                        color = (120, 200, 0)
                    elif slope < 0:
                        color = (0, 90, 0)
                    else:
                        color = (0, 150, 0)

                px = ox + c + 64 - r
                py = oy + (c + r) // 2
                if 0 <= px < surf.get_width() and 0 <= py < surf.get_height():
                    surf.set_at((px, py), color)

        if blink:
            for h in game_map.houses:
                if h.destroyed:
                    continue
                px = ox + h.c + 64 - h.r
                py = oy + (h.c + h.r) // 2
                color = (255, 255, 255) if h.team == 'allies' else (100, 100, 100)
                if 0 <= px < surf.get_width() and 0 <= py < surf.get_height():
                    surf.set_at((px, py), color)

            for p in peeps:
                if p.dead:
                    continue
                r, c = int(p.y), int(p.x)
                px = ox + c + 64 - r
                py = oy + (c + r) // 2
                color = (0, 100, 255) if p.team == 'allies' else (200, 0, 0)
                if 0 <= px < surf.get_width() and 0 <= py < surf.get_height():
                    surf.set_at((px, py), color)

        # Cadre caméra
        for dr in range(9):
            for dc in range(9):
                r = int(cam_r) + dr
                c = int(cam_c) + dc
                px = ox + c + 64 - r
                py = oy + (c + r) // 2
                if 0 <= px < surf.get_width() and 0 <= py < surf.get_height():
                    surf.set_at((px, py), (255, 255, 0))

    # ------------------------------------------------------------------
    # Jauges de mana
    # ------------------------------------------------------------------

    def _draw_power_gauge(self, surf, jauge, jauge_max):
        # Jauge alliés (gauche)
        ratio_a = min(1.0, jauge.get('allies', 0) / max(1.0, jauge_max.get('allies', 100)))
        # Jauge foes (droite)
        ratio_f = min(1.0, jauge.get('foes',   0) / max(1.0, jauge_max.get('foes',   100)))

        bar_h_max = 40
        bx_a = 315
        bx_f = 320
        by   = 170

        pygame.draw.rect(surf, (60, 30, 0), (bx_a, by, 3, bar_h_max))
        pygame.draw.rect(surf, (255, 255, 0), (bx_a, by + int(bar_h_max * (1 - ratio_a)), 3, int(bar_h_max * ratio_a)))

        pygame.draw.rect(surf, (60, 10, 0), (bx_f, by, 3, bar_h_max))
        pygame.draw.rect(surf, (255, 0, 0), (bx_f, by + int(bar_h_max * (1 - ratio_f)), 3, int(bar_h_max * ratio_f)))

    # ------------------------------------------------------------------
    # Boutons
    # ------------------------------------------------------------------

    def _draw_buttons(self, surf, active_command: str, ui_state):
        # Surbrillance du bouton actif
        if self._pressed_button and self._pressed_button in self.button_idx:
            idx = self.button_idx[self._pressed_button]
            if idx < len(self.button_sprites):
                # Légère teinte blanche pour indiquer le clic (rendu simplifié)
                pass  # Le sprite de bouton contient déjà l'état pressé

    def set_pressed_button(self, name: str) -> None:
        self._pressed_button = name
        self._pressed_timer  = 0.15

    # ------------------------------------------------------------------
    # Curseur
    # ------------------------------------------------------------------

    def _draw_cursor(self):
        pygame.mouse.set_visible(False)
        mx, my = pygame.mouse.get_pos()
        sp = self.sprites.get((4, 12))
        if sp:
            scaled = pygame.transform.scale(
                sp,
                (sp.get_width() * self.scale, sp.get_height() * self.scale),
            )
            self.screen.blit(scaled, (mx, my))

    # ------------------------------------------------------------------
    # Scanlines
    # ------------------------------------------------------------------

    def _make_scanlines(self) -> pygame.Surface:
        w = self.base_w * self.scale
        h = self.base_h * self.scale
        surf = pygame.Surface((w, h), pygame.SRCALPHA)
        for y in range(0, h, self.scale):
            pygame.draw.line(surf, (0, 0, 0, 80), (0, y), (w, y), 1)
        return surf

    # ------------------------------------------------------------------
    # Écran de fin
    # ------------------------------------------------------------------

    def draw_game_over(self, winner: str | None, stats: dict) -> None:
        self.screen.fill((20, 10, 0))
        w = self.base_w * self.scale
        h = self.base_h * self.scale

        if winner == 'allies':
            msg = "VICTORY !"
            color = (100, 200, 255)
        elif winner == 'foes':
            msg = "DEFEAT !"
            color = (255, 60, 60)
        else:
            msg = "DRAW"
            color = (200, 200, 200)

        surf = self.font_sys.render(msg, True, color)
        self.screen.blit(surf, (w // 2 - surf.get_width() // 2, h // 3))

        y = h // 2
        for line in (
            f"Allies pop: {stats.get('allies_pop', 0)}",
            f"Foes pop: {stats.get('foes_pop', 0)}",
            f"Allies houses: {stats.get('allies_houses', 0)}",
            f"Foes houses: {stats.get('foes_houses', 0)}",
            "",
            "Press ENTER to continue",
        ):
            s = self.font_sys.render(line, True, (230, 200, 150))
            self.screen.blit(s, (w // 2 - s.get_width() // 2, y))
            y += 20
        pygame.display.flip()


# ---------------------------------------------------------------------------
# Utilitaire projection
# ---------------------------------------------------------------------------

def _iso(r: float, c: float, alt: float, cam_r: float, cam_c: float) -> tuple[int, int]:
    lr = r - cam_r
    lc = c - cam_c
    sx = MAP_OFFSET_X + (lc - lr) * TILE_HALF_W
    sy = MAP_OFFSET_Y + (lc + lr) * TILE_HALF_H - alt * TILE_HALF_H
    return int(sx), int(sy)
