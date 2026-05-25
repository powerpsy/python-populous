import re

with open('peep.py', 'r', encoding='utf-8') as f:
    c = f.read()

old_block = r'''        # NOUVEAU : En mode PAPAL (ou tout autre mode sauf WANDER/BUILD), on ne construit pas
        if self.state != self.STATE_BUILD and self.state != self.STATE_WANDER:
            return None'''

new_block = '''        # NOUVEAU : La priorité est toujours de construire (sauf en PAPAL, BATTLE ou VICTORY)
        if self.state in (self.STATE_PAPAL, self.STATE_BATTLE, self.STATE_VICTORY_BEFORE, self.STATE_VICTORY_MAIN):
            return None'''

if old_block in c:
    c = c.replace(old_block, new_block)
    with open('peep.py', 'w', encoding='utf-8') as f:
        f.write(c)
    print('Replaced try_build_house guard')
else:
    print('old_block not found in try_build_house')
