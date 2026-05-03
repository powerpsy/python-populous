


class House:
    # Matrice de vitesse de croissance (1 à 16 par seconde)
    GROWTH_SPEEDS = [1, 2, 3, 4, 5, 6, 8, 10, 12, 16]
    # Matrice de valeur max de santé pour spawn (16, 32, ..., 160)
    MAX_HEALTHS = [16 * (i + 1) for i in range(10)]
    # Types de bâtiments par ordre de puissance
    TYPES = ['hut', 'house_small', 'house_medium', 'castle_small',
             'castle_medium', 'castle_large', 'fortress_small',
             'fortress_medium', 'fortress_large', 'castle']

    def __init__(self, r, c, life=10, team='allies'):
        self.r = r
        self.c = c
        self.life = float(life)
        self.team = team
        self.max_life = 16  # sera mis à jour dynamiquement
        self._pending_spawn = False
        self.building_type = 'hut'
        self.destroyed = False
        self.occupied_tiles = []
        self.has_shield = False

    def update(self, dt, game_map):
        # On vérifie d'abord si on est un Castle (Tier 9) ou si on peut le devenir
        # On utilise le flag is_castle=True pour voir si la zone 25 cases est plate
        score_castle, valid_tiles_castle = game_map.get_flat_area_score(self.r, self.c, current_house=self, is_castle=True)
        
        # Et on regarde aussi le score normal (16 cases)
        score_normal, valid_tiles_normal = game_map.get_flat_area_score(self.r, self.c, current_house=self, is_castle=False)

        if score_normal == -1: # Case d'habitation non constructible
            self.destroyed = True
            return

        # Détermination du Tier potentiel (avant filtrage territorial)
        if score_castle >= 24:
            potential_tier = len(self.TYPES) - 1
            potential_valid_tiles = valid_tiles_castle
        else:
            thresholds = [0, 1, 3, 5, 7, 9, 11, 12, 14, 16]
            potential_tier = 0
            for i, thresh in enumerate(thresholds):
                if score_normal >= thresh:
                    potential_tier = i
            potential_tier = min(len(self.TYPES) - 2, potential_tier) # Bloqué sous le Castle si zone 5x5 pas parfaite
            potential_valid_tiles = valid_tiles_normal

        # Vérifier d'abord s'il y a un conflit sur la case centrale (déjà géré par score=-1 mais sécurité)
        center_conflict = False
        for other in game_map.houses:
            if other != self and not getattr(other, 'destroyed', False):
                # Si l'autre existe déjà physiquement (pas juste planifié) et possède la case
                if (self.r, self.c) in getattr(other, 'occupied_tiles', []):
                    center_conflict = True
                    break
        
        if center_conflict:
            self.destroyed = True
            return

        # Filtrer les potential_valid_tiles pour ignorer les cases revendiquées par n'importe quel voisin (concurrence territoriale)
        filtered_valid_tiles = []
        for t in potential_valid_tiles:
            can_claim = True
            for other in game_map.houses:
                if other != self and not getattr(other, 'destroyed', False):
                    # RÈGLE DE PRIORITÉ : L'ancien bâtiment (déjà présent sur la map)
                    # a la priorité absolue sur ses tuiles.
                    # Un nouveau bâtiment ne peut JAMAIS voler une tuile déjà possédée par un autre.
                    if t in getattr(other, 'occupied_tiles', []):
                        can_claim = False
                        break
            if can_claim:
                filtered_valid_tiles.append(t)

        # PROTECTION DES CHÂTEAUX : Si on est un bâtiment existant et qu'on était un château,
        # on ne met à jour nos tuiles QUE si le terrain change (plus de cases valides théoriques).
        # On ne doit pas réduire notre territoire juste parce qu'un nouveau voisin essaie de le revendiquer.
        if self.building_type == 'castle' and potential_tier == len(self.TYPES) - 1:
            # On ne change rien à nos tuiles occupées si le terrain environnant est toujours plat
            # Cela empêche l'effet de "tremblote" ou de réduction lors de la construction d'un voisin.
            pass
        else:
            self.occupied_tiles = filtered_valid_tiles
        
        score = len(self.occupied_tiles)

        # Application du Tier final basé sur le terrain réel occupé
        max_tier = potential_tier

        # Recalcul du tier après filtrage territorial
        if max_tier == len(self.TYPES) - 1:
            # Un Castle une fois établi ne devrait pas être réduit par la simple proximité 
            # d'un nouveau bâtiment.
            # On ne dégrade le Castle que si son terrain est physiquement détruit (altitude)
            # ou si le score chute drastiquement sous un seuil critique (ex: 24 tuiles),
            # mais pas à cause d'une maison qui s'installe à la limite de sa zone d'influence.
            if score < 24: 
                max_tier = len(self.TYPES) - 2
        
        # Pour les bâtiments non-Castle, le tier peut fluctuer selon l'espace disponible
        elif max_tier < len(self.TYPES) - 1:
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
