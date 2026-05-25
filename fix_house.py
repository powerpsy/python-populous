import re

with open('peep.py', 'r', encoding='utf-8') as f:
    c = f.read()

# We need to find the block:
#                # NOUVEAU : Si on arrive sur une tuile avec un bâtiment ALLIÉ, on rentre dedans
#                # Condition : état WANDER et on n'est pas sur l'eau
#                if self.state == Peep.STATE_WANDER and not getattr(self, 'is_knight', False):
#                    gr, gc = int(self.y), int(self.x)
#                    for h in self.game_map.houses:
#                        if not h.destroyed and (gr, gc) in h.occupied_tiles:
#                            if h.team == self.team:
#                                # Entrer dans le bÃ¢timent : on ajoute notre vie au bÃ¢timent (sans perte)
#                                h.life += self.life
#                                # On transfère le shield si on l'a
#                                if self.has_shield:
#                                    h.has_shield = True
#                                if self.is_leader:
#                                    h.has_leader = True
#                                    self.in_house_leader = True
#                                self.life = 0
#                                self.dead = True
#                                self.in_house = True
#                                break
#            else:
#                # Interpolation linéaire


# To be safer, process line by line or find exact match
lines = c.split('\n')
start_idx = -1
end_idx = -1
for i, l in enumerate(lines):
    if \"NOUVEAU : Si on arrive sur une tuile avec un b\" in l:
        start_idx = i
        break

if start_idx != -1:
    for i in range(start_idx, len(lines)):
        if \"# Interpolation l\" in lines[i]:
            end_idx = i - 1
            break

if start_idx != -1 and end_idx != -1:
    old_lines = lines[start_idx:end_idx]
    new_lines = '''                # NOUVEAU : Interaction au contact d'un batiment
                gr, gc = int(self.y), int(self.x)
                for h in self.game_map.houses:
                    if not h.destroyed and (gr, gc) in h.occupied_tiles:
                        if h.team == self.team:
                            if self.state == Peep.STATE_WANDER and not getattr(self, 'is_knight', False):
                                h.life += self.life
                                if self.has_shield:
                                    h.has_shield = True
                                if getattr(self, 'is_leader', False):
                                    h.has_leader = True
                                    self.in_house_leader = True
                                self.life = 0
                                self.dead = True
                                self.in_house = True
                                break
                        else:
                            # Attaque d'un batiment ennemi
                            if not getattr(self, 'is_knight', False): # Only non-knights can attack with their raw life? Knights too? Let's say all.
                                # Knight can attack.
                                pass
                            print(f"COMBAT MAISON : Peep({self.team}, vie={self.life}) vs Maison({h.team}, vie={h.life})")
                            if self.life > h.life:
                                self.life -= h.life
                                h.life = 0
                                h.destroyed = True
                                self.state_timer = 0
                            else:
                                h.life -= self.life
                                self.life = 0
                                self.dead = True
                            break'''.split('\n')
    
    # insert
    lines = lines[:start_idx] + new_lines + lines[end_idx:]
    with open('peep.py', 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    print('Replaced')
else:
    print('Indices not found:', start_idx, end_idx)
