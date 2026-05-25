import re

with open('peep.py', 'r', encoding='utf-8') as f:
    c = f.read()

old_battle = r'''        # Gestion des états de bataille et victoire
        if self.state == Peep.STATE_BATTLE:
            self.state_timer \+= dt
            # Diminution rapide de la santé
            # On perd par exemple 50 points de vie par seconde en bataille
            self.life -= dt \* 50.0
            
            # Vérifier si la bataille est finie
            if self.life <= 0:
                self.life = 0
                self.dead = True
                if self.battle_partner and not self.battle_partner.dead:
                    # Le partenaire gagne
                    self.battle_partner.state = Peep.STATE_VICTORY_BEFORE
                    self.battle_partner.state_timer = 0.0
                return

            if self.battle_partner and \(self.battle_partner.dead or self.battle_partner.in_house\):
                # Le partenaire est mort ou a disparu, on gagne
                self.state = Peep.STATE_VICTORY_BEFORE
                self.state_timer = 0.0
                return
            return # En bataille, on ne fait rien d'autre'''

new_battle = '''        # Gestion des états de bataille et victoire
        if self.state == Peep.STATE_BATTLE:
            self.state_timer += dt
            # Diminution rapide de la santé
            # On perd par exemple 50 points de vie par seconde en bataille
            self.life -= dt * 50.0
            
            # Infliger des dégâts au bâtiment si c'est une maison
            is_house = not hasattr(self.battle_partner, 'state')
            if is_house and self.battle_partner:
                self.battle_partner.life -= dt * 50.0
                if self.battle_partner.life <= 0:
                    self.battle_partner.life = 0
                    self.battle_partner.destroyed = True
            
            # Vérifier si la bataille est finie
            if self.life <= 0:
                self.life = 0
                self.dead = True
                if self.battle_partner and not getattr(self.battle_partner, 'dead', False) and not getattr(self.battle_partner, 'destroyed', False):
                    # Le partenaire gagne
                    if hasattr(self.battle_partner, 'state'):
                        self.battle_partner.state = Peep.STATE_VICTORY_BEFORE
                        self.battle_partner.state_timer = 0.0
                return

            if self.battle_partner and (getattr(self.battle_partner, 'dead', False) or getattr(self.battle_partner, 'destroyed', False) or getattr(self.battle_partner, 'in_house', False)):
                # Le partenaire est mort ou a disparu, on gagne
                self.state = Peep.STATE_VICTORY_BEFORE
                self.state_timer = 0.0
                return
            return # En bataille, on ne fait rien d'autre'''

c = re.sub(old_battle, new_battle, c)

with open('peep.py', 'w', encoding='utf-8') as f:
    f.write(c)
print('Replaced Battle state')
