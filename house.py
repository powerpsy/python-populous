class House:
    def __init__(self, address, num_rooms):
        self.address = address
        self.num_rooms = num_rooms
        self.peeps = []  # Liste pour stocker les peeps de la maison

    def spawn_peep(self):
        # Implémentez ici la logique de création d'un peep
        pass

    def __str__(self):
        return f"House({self.address}, {self.num_rooms} rooms)"