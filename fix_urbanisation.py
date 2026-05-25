import sys

with open('peep.py', 'r', encoding='utf-8') as f:
    c = f.read()

old_code = '''    def _choose_next_tile(self):
        """Choix de la prochaine tuile selon l'état du peep, avec floodfill local et retour possible sur ancienne case."""
        r0, c0 = int(self.y), int(self.x)

        if self.state == Peep.STATE_BUILD:
            # go_build : exploration pour trouver de nouvelles opportunités
            directions = [(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)]
            
            # --- Scan local pour opportunité immédiate d'urbanisation ---
            # Si on détecte du terrain plat VIERGE à côté, on interrompt le voyage.
            # Si on détecte du terrain plat VIERGE à côté, on interrompt le voyage.
            best_local_score = -1
            best_local_tile = None
            
            for dr, dc in directions:
                nr, nc = r0 + dr, c0 + dc
                if 0 <= nr < self.game_map.grid_height and 0 <= nc < self.game_map.grid_width:
                    if self.game_map.get_corner_altitude(nr, nc) > 0 and (nr, nc) not in self.path_history:
                        score, _ = self.game_map.get_flat_area_score(nr, nc, current_house=None)
                        if score > 5: # Seuil d'intérêt : s'il y a au moins un peu de plat
                            # Vérifier si c'est déjà trop proche d'une maison
                            too_close = False
                            for h in self.game_map.houses:
                                if max(abs(h.r - nr), abs(h.c - nc)) < 3: # Distance Chebyshev
                                    too_close = True
                                    break
                            if not too_close and score > best_local_score:
                                best_local_score = score
                                best_local_tile = (nr, nc)
            
            if best_local_tile:
                # On réinitialise un momentum court vers cette opportunité
                self.momentum_dir = (best_local_tile[0] - r0, best_local_tile[1] - c0)
                self.momentum_steps = 2
                return best_local_tile'''

new_code = '''    def _choose_next_tile(self):
        """Choix de la prochaine tuile selon l'état du peep, avec floodfill local et retour possible sur ancienne case."""
        r0, c0 = int(self.y), int(self.x)

        # -- PRIORITÉ ABSOLUE : Urbanisation --
        # Même en train de se battre ou de se rassembler, si on croise un bon terrain, on y va pour construire !
        if self.state in (Peep.STATE_BUILD, Peep.STATE_WANDER, Peep.STATE_ASSEMBLE, Peep.STATE_FIGHT, Peep.STATE_CHARGE_ENEMY):
            directions = [(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)]
            best_local_score = -1
            best_local_tile = None
            
            for dr, dc in directions:
                nr, nc = r0 + dr, c0 + dc
                if 0 <= nr < self.game_map.grid_height and 0 <= nc < self.game_map.grid_width:
                    if self.game_map.get_corner_altitude(nr, nc) > 0 and (nr, nc) not in self.path_history:
                        score, _ = self.game_map.get_flat_area_score(nr, nc, current_house=None)
                        if score > 5: # Seuil d'intérêt : s'il y a au moins un peu de plat
                            # Vérifier si c'est déjà trop proche d'une maison
                            too_close = False
                            for h in self.game_map.houses:
                                if max(abs(h.r - nr), abs(h.c - nc)) < 3: # Distance Chebyshev
                                    too_close = True
                                    break
                            if not too_close and score > best_local_score:
                                best_local_score = score
                                best_local_tile = (nr, nc)
            
            if best_local_tile:
                self.momentum_dir = (best_local_tile[0] - r0, best_local_tile[1] - c0)
                self.momentum_steps = 2
                return best_local_tile

        # -- SUITE DE LA LOGIQUE DE DÉPLACEMENT --
        if self.state == Peep.STATE_BUILD:
            directions = [(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)]'''

if old_code in c:
    c = c.replace(old_code, new_code)
    with open('peep.py', 'w', encoding='utf-8') as f:
        f.write(c)
    print('Replaced chunk in _choose_next_tile')
else:
    print('Chunk not found!')
