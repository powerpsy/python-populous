import sys

with open('peep.py', 'r', encoding='utf-8') as f:
    lines = f.readlines()

in_func = False
for i, line in enumerate(lines):
    if 'def _choose_next_tile' in line:
        in_func = True
    if in_func:
        print(f"{i}: {line.rstrip()}")
        if 'elif self.state in' in line:
            break
