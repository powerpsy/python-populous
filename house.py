class House:
    # Types de bâtiments par ordre de puissance
    TYPES = ['hut', 'house_small', 'house_medium', 'castle_small',
             'castle_medium', 'castle_large', 'fortress_small',
             'fortress_medium', 'fortress_large']

    def __init__(self, r, c, life=10):
        self.r = r
        self.c = c
        self.life = float(life)
        self.max_life = 100
        self.spawn_timer = 0.0
        self.spawn_interval = 10.0  # secondes entre chaque spawn
        self._pending_spawn = False
        self.building_type = 'hut'
        self.destroyed = False
        self.occupied_tiles = []

    def update(self, dt, game_map):
        score, valid_tiles = game_map.get_flat_area_score(self.r, self.c, current_house=self)
        if score == -1:
            self.destroyed = True
            return

        # Nouveaux paliers de score sur les 24 cases adjacentes :
        # bat 1: 0, 2: 1-3, 3: 4-6, 4: 7-9, 5: 10-12, 6: 13-16, 7: 17-19, 8: 20-23, 9: 24
        thresholds = [0, 1, 4, 7, 10, 13, 17, 20, 24]
        
        max_tier = 0
        for i, thresh in enumerate(thresholds):
            if score >= thresh:
                max_tier = i
        
        max_tier = min(len(self.TYPES) - 1, max_tier)
        
        # Le bâtiment prend immédiatement la taille maximale disponible
        current_tier = max_tier
        
        # Le niveau max de vie dépend de ce tier max
        self.max_life = (max_tier + 1) * 15.0
        
        # La vie rejoint aussi le max pour éviter que des destructions ne laissent des peeps trop faibles
        if self.life < self.max_life:
            self.life += dt * 3  # La vie (l'énergie des peeps générés) continue de monter avec le temps
        elif self.life > self.max_life:
            self.life -= dt * 5

        # Empêcher la vie de descendre sous un minimum tant qu'il a 1 bloc
        if self.life < 10.0:
            self.life = 10.0

        self.spawn_timer += dt
        if self.spawn_timer >= self.spawn_interval:
            self.spawn_timer -= self.spawn_interval
            self._pending_spawn = True

        self.building_type = self.TYPES[current_tier]

        # Territoire réclamé correspond au niveau ACTUEL (current_tier) du bâtiment
        required_tiles = thresholds[current_tier]
        desired_tiles = [(self.r, self.c)] + valid_tiles[:required_tiles]

        # RECHERCHE DE CONFLIT D'URBANISME : Les bâtiments se disputent le territoire.
        # Si une autre maison revendique une case qu'on souhaite aussi prendre...
        for other in game_map.houses:
            if other != self and not getattr(other, 'destroyed', False):
                other_occupied = getattr(other, 'occupied_tiles', [])
                if any(t in desired_tiles for t in other_occupied):
                    # CONFLIT ! Le plus faible ou nouveau est détruit.
                    if self.life <= other.life:
                        self.destroyed = True
                        return
                    else:
                        other.destroyed = True

        self.occupied_tiles = desired_tiles

    def can_spawn_peep(self):
        if self._pending_spawn:
            self._pending_spawn = False
            return True
        return False
