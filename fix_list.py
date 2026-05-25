import sys

with open('peep.py', 'r', encoding='utf-8') as f:
    lines = f.readlines()

out = []
skip = False
for line in lines:
    if 'print(f"COMBAT MAISON :' in line:
        skip = True
        out.append(line.replace('print(f"COMBAT MAISON', 'if self.state != Peep.STATE_BATTLE:\n                                self.state = Peep.STATE_BATTLE\n                                self.state_timer = 0.0\n                                self.battle_partner = h\n#'))
        continue
    
    if skip:
        if 'break' in line and 'h.dead' not in line:
            skip = False
            out.append(line)
        continue
    
    out.append(line)

with open('peep.py', 'w', encoding='utf-8') as f:
    f.writelines(out)
print('Done!')
