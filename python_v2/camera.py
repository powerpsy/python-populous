"""
camera.py – Gestion de la caméra isométrique (portage ASM Amiga).
Aucune dépendance pygame : la caméra est un état logique (r, c).
"""

from settings import GRID_WIDTH, GRID_HEIGHT

_DIRECTIONS: dict[str, tuple[float, float]] = {
    'N':  (-1.0, -1.0),
    'NE': (-1.0,  0.0),
    'E':  ( 0.0,  1.0),
    'SE': ( 1.0,  1.0),
    'S':  ( 1.0,  0.0),
    'SW': ( 1.0, -1.0),
    'W':  ( 0.0, -1.0),
    'NW': (-1.0, -1.0),
}


class Camera:
    """Position logique de la caméra (coin supérieur-gauche de la zone visible)."""

    VIEW_ROWS = 8
    VIEW_COLS = 8

    def __init__(self):
        self.r = float(GRID_HEIGHT // 2 - self.VIEW_ROWS // 2)
        self.c = float(GRID_WIDTH  // 2 - self.VIEW_COLS // 2)
        self._move_cooldown = 0.0

    def move_direction(self, direction: str, step: float = 1.0) -> None:
        if direction in _DIRECTIONS:
            dr, dc = _DIRECTIONS[direction]
            self.move(dr * step, dc * step)

    def move(self, dr: float, dc: float) -> None:
        self.r += dr
        self.c += dc
        self._clip()

    def center_on(self, r: float, c: float) -> None:
        self.r = float(int(r) - self.VIEW_ROWS // 2)
        self.c = float(int(c) - self.VIEW_COLS // 2)
        self._clip()

    def _clip(self) -> None:
        self.r = max(0.0, min(self.r, float(GRID_HEIGHT - self.VIEW_ROWS)))
        self.c = max(0.0, min(self.c, float(GRID_WIDTH  - self.VIEW_COLS)))

    def update(self, dt: float, keys: dict) -> str | None:
        """
        Met à jour la caméra depuis un dictionnaire de touches pressées.
        `keys` est un dict {str_key: bool} — indépendant de pygame.
        Retourne la direction de déplacement ou None.
        """
        self._move_cooldown -= dt
        if self._move_cooldown > 0:
            return None

        direction = None
        left  = keys.get('left',  False) or keys.get('a', False)
        right = keys.get('right', False) or keys.get('d', False)
        up    = keys.get('up',    False) or keys.get('w', False)
        down  = keys.get('down',  False) or keys.get('s', False)

        if left:
            direction = 'NW' if up else ('SW' if down else 'W')
        elif right:
            direction = 'NE' if up else ('SE' if down else 'E')
        elif up:
            direction = 'N'
        elif down:
            direction = 'S'

        if direction:
            self.move_direction(direction)
            self._move_cooldown = 0.15
        return direction
