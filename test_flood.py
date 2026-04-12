import pygame, time
pygame.init()
pygame.display.set_mode((1,1), pygame.HIDDEN)
ui_image = pygame.image.load('UI.png').convert_alpha()

t0 = time.time()
arr = pygame.surfarray.pixels3d(ui_image)
alpha = pygame.surfarray.pixels_alpha(ui_image)

start_x, start_y = 160, 100
stack = [(start_x, start_y)]
w, h = ui_image.get_size()

while stack:
    x, y = stack.pop()
    if alpha[x, y] == 0:
        continue
    if arr[x, y, 0] <= 10 and arr[x, y, 1] <= 10 and arr[x, y, 2] <= 10:
        alpha[x, y] = 0
        if x + 1 < w: stack.append((x+1, y))
        if x - 1 >= 0: stack.append((x-1, y))
        if y + 1 < h: stack.append((x, y+1))
        if y - 1 >= 0: stack.append((x, y-1))

del arr
del alpha
print('Time:', time.time() - t0)
pygame.image.save(ui_image, 'test_ui.png')
