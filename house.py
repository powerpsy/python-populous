class House:
    # Types de bâtiments par ordre de puissance
    TYPES = ['hut', 'house_small', 'house_medium', 'castle_small',
             'castle_medium', 'castle_large', 'fortress_small',
             'fortress_medium', 'fortress_large']

    def __init__(self, r, c, life=10):
        self.r = r
        self.c = c
        self.life = life
        self.max_life = 100
        self.spawn_timer = 0.0
        self.spawn_interval = 10.0  # secondes entre chaque spawn
        self._pending_spawn = False
        # Type de bâtiment basé sur la vie
        self.building_type = 'hut'

    def update(self, dt):
        self.life = min(self.life + dt * 2, self.max_life)
        self.spawn_timer += dt
        if self.spawn_timer >= self.spawn_interval:
            self.spawn_timer -= self.spawn_interval
            self._pending_spawn = True

        # Évolution du type de bâtiment
        ratio = self.life / self.max_life
        idx = min(int(ratio * len(self.TYPES)), len(self.TYPES) - 1)
        self.building_type = self.TYPES[idx]

    def can_spawn_peep(self):
        if self._pending_spawn:
            self._pending_spawn = False
            return True
        return False
