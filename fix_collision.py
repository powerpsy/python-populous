# -*- coding: utf-8 -*-
import re

with open('peep.py', 'r', encoding='utf-8') as f:
    c = f.read()

old_block = r'''                        else:
                            # Attaque du b.timent ennemi.
                            print\(f"COMBAT MAISON : Peep\(\{self.team\}, vie=\{self.life\}\) vs Maison\(\{h.team\}, vie=\{h.life\}\)"\)
                            if self.life > h.life:
                                # Le peep gagne et d.truit la maison
                                self.life -= h.life
                                h.life = 0
                                h.destroyed = True
                                # On gagne du momentum de combat pour continuer
                                self.state_timer = 0
                            else:
                                # La maison gagne et boit la vie du peep
                                h.life -= self.life
                                self.life = 0
                                self.dead = True
                            break'''

new_block = '''                        else:
                            # Attaque du batiment ennemi !
                            if self.state != Peep.STATE_BATTLE:
                                self.state = Peep.STATE_BATTLE
                                self.state_timer = 0.0
                                self.battle_partner = h
                            break'''

c = re.sub(old_block, new_block, c)

with open('peep.py', 'w', encoding='utf-8') as f:
    f.write(c)
print('Replaced collision with House')
