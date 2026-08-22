"""
main.py – Point d'entrée du portage Python v2 de Populous.

Architecture (séparation logique / rendu) :
    GameState  → toute la logique (terrain, peeps, maisons, IA)
    Renderer   → tout l'affichage pygame
    main loop  → orchestre les deux, gère les événements pygame

Lancement :
    cd python_v2/
    python main.py
"""

import os
import sys
import pygame

# S'assurer que le répertoire courant est python_v2/
_dir = os.path.dirname(os.path.abspath(__file__))
if _dir not in sys.path:
    sys.path.insert(0, _dir)

from game_state import GameState
from camera     import Camera
from sound      import Sound
from renderer   import Renderer
from settings   import GRID_WIDTH, GRID_HEIGHT

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

FPS = 60
INITIAL_PEEPS = 8
DEFAULT_SEED  = 42


# ---------------------------------------------------------------------------
# Conversion touches pygame → dict caméra
# ---------------------------------------------------------------------------

def _build_keys_dict(pressed) -> dict:
    return {
        'left':  pressed[pygame.K_LEFT]  or pressed[pygame.K_a],
        'right': pressed[pygame.K_RIGHT] or pressed[pygame.K_d],
        'up':    pressed[pygame.K_UP]    or pressed[pygame.K_w],
        'down':  pressed[pygame.K_DOWN]  or pressed[pygame.K_s],
    }


# ---------------------------------------------------------------------------
# Boucle de jeu principale
# ---------------------------------------------------------------------------

def game_loop(gs: GameState, renderer: Renderer, camera: Camera, sound: Sound) -> str | None:
    """
    Lance la boucle de jeu.
    Retourne 'quit', 'menu', ou None.
    """
    clock = pygame.time.Clock()

    # Hit-test des boutons UI (coordonnées dans l'espace interne)
    cx, cy = 64, 168
    cx2, cy2 = 256, 184
    dx, dy = 16, 8
    hw, hh = 16, 8

    ui_buttons: dict[str, dict] = {
        '_raise_terrain': {'c': (cx + dx*2, cy + dy*2)},
        '_lower_terrain': {'c': (cx - dx*2, cy - dy*2)},
        '_do_volcano':    {'c': (cx - dx*3, cy - dy*3)},
        '_do_knight':     {'c': (cx - dx*2, cy - dy*2)},
        '_do_flood':      {'c': (cx - dx*3, cy - dy*5)},
        '_do_quake':      {'c': (cx - dx*1, cy - dy*3)},
        '_do_swamp':      {'c': (cx - dx*3, cy - dy*1)},
        '_do_papal':      {'c': (cx + dx*1, cy + dy*3)},
        '_do_shield':     {'c': (cx + dx*3, cy + dy*1)},
        '_find_battle':   {'c': (cx + dx*3, cy + dy*3)},
        '_find_shield':   {'c': (cx,        cy        )},
        '_find_papal':    {'c': (cx + dx*4, cy + dy*2)},
        '_find_knight':   {'c': (cx + dx*5, cy + dy*3)},
        'W':  {'c': (cx - dx*2, cy        )},
        'NW': {'c': (cx - dx*1, cy - dy  )},
        'N':  {'c': (cx,        cy - dy*2)},
        'NE': {'c': (cx + dx*1, cy - dy  )},
        'E':  {'c': (cx + dx*2, cy        )},
        'SW': {'c': (cx - dx*1, cy + dy  )},
        'S':  {'c': (cx,        cy + dy*2)},
        'SE': {'c': (cx + dx*1, cy + dy  )},
        '_go_papal':    {'c': (cx - dx*3, cy + dy*1)},
        '_go_build':    {'c': (cx - dx*2, cy + dy*2)},
        '_go_assemble': {'c': (cx - dx*1, cy + dy*3)},
        '_go_fight':    {'c': (cx - dx*3, cy + dy*3)},
        '_battle_over': {'c': (cx - dx*2, cy - dy*4)},
    }

    active_command = '_go_build'

    def _hit_button(mx_int: int, my_int: int) -> str | None:
        for name, info in ui_buttons.items():
            bx, by = info['c']
            if abs(mx_int - bx) <= hw and abs(my_int - by) <= hh:
                return name
        return None

    def _update_active_command(cmd: str) -> None:
        nonlocal active_command
        active_command = cmd

    running = True
    while running:
        dt = clock.tick(FPS) / 1000.0

        # --- Événements ---
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                return 'quit'

            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    return 'menu'
                if event.key == pygame.K_F1:
                    pass  # toggle debug (à implémenter)

            if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                # Diviser la position souris par scale pour obtenir l'espace interne
                s = renderer.scale
                mx_int = event.pos[0] // s
                my_int = event.pos[1] // s

                btn = _hit_button(mx_int, my_int)
                if btn:
                    renderer.set_pressed_button(btn)
                    _handle_button(btn, gs, camera, sound, mx_int, my_int,
                                   _update_active_command,
                                   active_command)
                    if btn in ('_go_build', '_go_fight', '_go_assemble', '_go_papal'):
                        active_command = btn
                    elif btn in ('N', 'S', 'E', 'W', 'NE', 'NW', 'SE', 'SW'):
                        camera.move_direction(btn)
                else:
                    # Clic sur la carte → modifier le terrain
                    r, c = gs.game_map.screen_to_nearest_corner(
                        mx_int, my_int, camera.r, camera.c)
                    if active_command in ('_raise_terrain', '_lower_terrain'):
                        if active_command == '_raise_terrain':
                            gs.raise_terrain(r, c)
                        else:
                            gs.lower_terrain(r, c)

        # --- Mise à jour de la caméra ---
        keys = _build_keys_dict(pygame.key.get_pressed())
        camera.update(dt, keys)

        # --- Mise à jour logique ---
        gs.update(dt)

        # --- Rendu ---
        renderer.render(gs, camera, dt, active_command=active_command)

        # --- Fin de partie ---
        if gs.is_battle_over and gs.battle_over_timer > 1.0:
            _wait_game_over(gs, renderer)
            return 'menu'

    return None


def _handle_button(
    btn: str, gs: GameState, camera: Camera, sound: Sound,
    mx: int, my: int,
    set_cmd,
    active_command: str,
) -> None:
    """Traite le clic sur un bouton de l'interface."""
    r, c = gs.game_map.screen_to_nearest_corner(mx, my, camera.r, camera.c)

    if btn == '_raise_terrain':
        set_cmd('_raise_terrain')
    elif btn == '_lower_terrain':
        set_cmd('_lower_terrain')
    elif btn == '_do_quake':
        if gs._do_quake(r, c):
            sound.play('do_quake')
    elif btn == '_do_flood':
        if gs._do_flood():
            sound.play('do_flood')
    elif btn == '_do_volcano':
        if gs._do_volcano(r, c):
            sound.play('do_volcano')
    elif btn == '_do_swamp':
        if gs._do_swamp(r, c):
            sound.play('swamp')
    elif btn == '_do_knight':
        gs._do_knight(r, c)
    elif btn == '_do_papal':
        gs._do_papal(r, c)
    elif btn == '_battle_over':
        gs._battle_over('allies')
    elif btn in ('_go_build', '_go_fight', '_go_assemble', '_go_papal'):
        gs.set_peep_command(btn, team='allies')
        set_cmd(btn)
    elif btn in ('_find_battle', '_find_shield', '_find_papal', '_find_knight'):
        # Centrer la caméra sur la première unité correspondante
        for p in gs.peeps:
            if not p.dead and p.team == 'allies':
                camera.center_on(p.y, p.x)
                break


def _wait_game_over(gs: GameState, renderer: Renderer) -> None:
    """Affiche l'écran de fin de partie jusqu'à ENTER."""
    stats = {
        'allies_pop':    gs.population.get('allies', 0),
        'foes_pop':      gs.population.get('foes',   0),
        'allies_houses': gs.house_count.get('allies', 0),
        'foes_houses':   gs.house_count.get('foes',   0),
    }
    renderer.draw_game_over(gs.battle_winner, stats)
    waiting = True
    while waiting:
        for ev in pygame.event.get():
            if ev.type == pygame.QUIT:
                waiting = False
            if ev.type == pygame.KEYDOWN and ev.key in (pygame.K_RETURN, pygame.K_ESCAPE):
                waiting = False
        pygame.time.wait(50)


# ---------------------------------------------------------------------------
# Menu principal
# ---------------------------------------------------------------------------

def main_menu(renderer: Renderer) -> tuple[str, int | None]:
    """
    Affiche le menu d'accueil.
    Retourne ('play', seed) ou ('quit', None).
    """
    renderer.draw_welcome()
    waiting = True
    while waiting:
        for ev in pygame.event.get():
            if ev.type == pygame.QUIT:
                return 'quit', None
            if ev.type == pygame.KEYDOWN:
                if ev.key == pygame.K_RETURN:
                    return 'play', DEFAULT_SEED
                if ev.key == pygame.K_ESCAPE:
                    return 'quit', None
        pygame.time.wait(16)
    return 'quit', None


# ---------------------------------------------------------------------------
# Point d'entrée
# ---------------------------------------------------------------------------

def main() -> None:
    pygame.init()
    pygame.mixer.init(frequency=22050, size=-16, channels=2, buffer=512)

    renderer = Renderer()
    sound    = Sound()

    action = 'menu'
    seed   = DEFAULT_SEED

    while action != 'quit':
        action, seed = main_menu(renderer)
        if action == 'quit':
            break

        gs     = GameState(world_seed=seed)
        gs.new_game(seed=seed, initial_peeps=INITIAL_PEEPS)
        camera = Camera()
        camera.center_on(GRID_HEIGHT // 2, GRID_WIDTH // 2)

        result = game_loop(gs, renderer, camera, sound)
        if result == 'quit':
            action = 'quit'
        else:
            action = 'menu'

    pygame.quit()
    sys.exit(0)


if __name__ == '__main__':
    main()
