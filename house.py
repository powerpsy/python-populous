


class House:
    # Matrice de vitesse de croissance (1 à 16 par seconde)
    GROWTH_SPEEDS = [1, 2, 3, 4, 5, 6, 8, 10, 12, 16]
    # Matrice de valeur max de santé pour spawn (16, 32, ..., 160)
    MAX_HEALTHS = [16 * (i + 1) for i in range(10)]
    # Types de bâtiments par ordre de puissance
    TYPES = ['hut', 'house_small', 'house_medium', 'castle_small',
             'castle_medium', 'castle_large', 'fortress_small',
             'fortress_medium', 'fortress_large', 'castle']

    def __init__(self, r, c, life=10):
        self.r = r
        self.c = c
        self.life = float(life)
        self.max_life = 16  # sera mis à jour dynamiquement
        self._pending_spawn = False
        self.building_type = 'hut'
        self.destroyed = False
        self.occupied_tiles = []

    def update(self, dt, game_map):
        # On vérifie d'abord si on est un Castle (Tier 9) ou si on peut le devenir
        # On utilise le flag is_castle=True pour voir si la zone 25 cases est plate
        score_castle, valid_tiles_castle = game_map.get_flat_area_score(self.r, self.c, current_house=self, is_castle=True)
        
        # Et on regarde aussi le score normal (16 cases)
        score_normal, valid_tiles_normal = game_map.get_flat_area_score(self.r, self.c, current_house=self, is_castle=False)

        if score_normal == -1: # Case d'habitation non constructible
            self.destroyed = True
            return

        # Détermination du Tier
        if score_castle >= 24:
            max_tier = len(self.TYPES) - 1
            valid_tiles = valid_tiles_castle
        else:
            thresholds = [0, 1, 3, 5, 7, 9, 11, 12, 14, 16]
            max_tier = 0
            for i, thresh in enumerate(thresholds):
                if score_normal >= thresh:
                    max_tier = i
            max_tier = min(len(self.TYPES) - 2, max_tier) # Bloqué sous le Castle si zone 5x5 pas parfaite
            valid_tiles = valid_tiles_normal

        # Vérifier d'abord s'il y a un conflit sur la case centrale (déjà géré par score=-1 mais sécurité)
        center_conflict = False
        for other in game_map.houses:
            if other != self and not getattr(other, 'destroyed', False):
                if (self.r, self.c) in getattr(other, 'occupied_tiles', []):
                    center_conflict = True
                    break
        
        if center_conflict:
            self.destroyed = True
            return

        # Filtrer les valid_tiles pour ignorer les cases revendiquées par n'importe quel voisin (concurrence territoriale)
        filtered_valid_tiles = []
        for t in valid_tiles:
            can_claim = True
            for other in game_map.houses:
                if other != self and not getattr(other, 'destroyed', False):
                    # Si l'autre est déjà là et possède la case, on ne peut pas la prendre
                    if t in getattr(other, 'occupied_tiles', []):
                        can_claim = False
                        break
            if can_claim:
                filtered_valid_tiles.append(t)

        self.occupied_tiles = filtered_valid_tiles
        score = len(self.occupied_tiles)

        # Recalcul du tier après filtrage territorial
        if max_tier == len(self.TYPES) - 1:
            if score < 24: # On a perdu du terrain (concurrence), on descend du rang Castle
                max_tier = len(self.TYPES) - 2
        
        if max_tier < len(self.TYPES) - 1:
            thresholds = [0, 1, 3, 5, 7, 9, 11, 12, 14, 16]
            max_tier = 0
            for i, thresh in enumerate(thresholds):
                if score >= thresh:
                    max_tier = i
            max_tier = min(len(self.TYPES) - 2, max_tier)

        self.building_type = self.TYPES[max_tier]
        
        # Nouvelle logique : croissance de la santé selon la matrice
        growth_speed = self.GROWTH_SPEEDS[max_tier]
        self.max_life = self.MAX_HEALTHS[max_tier]
        self.life += dt * growth_speed
        if self.life > self.max_life:
            self.life = self.max_life
            self._pending_spawn = True
        # Empêcher la vie de descendre sous 1 (jamais 0)
        if self.life < 1.0:
            self.life = 1.0

    def can_spawn_peep(self):
        if self._pending_spawn:
            self._pending_spawn = False
            return True
        return False
