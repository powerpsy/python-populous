# Rapport d'Architecture : La Minimap (Radar) dans Populous (Amiga)

L'étude du code assembleur `populous_prg.asm` et des symboles associés (via le désassembleur IRA) permet de reconstituer avec précision le fonctionnement de la minimap (aussi appelée "radar") dans le jeu original.

## 1. Moteur de Rendu : `_draw_map`
La fonction clé en charge d'afficher la minimap s'appelle `_draw_map` (située autour de l'adresse `$3F1E0`). Contrairement à la vue isométrique en plein écran, la minimap affiche le relief et les informations d'une zone via de simples pixels sur une surface 2D, tout en conservant l'allure inclinée du losange caractéristique de Populous.

### Boucle de balayage
La routine boucle sur les matrices bidimensionnelles de la couche principale `_map_blk` pour lire l'état de chaque tuile (case).

```assembly
    LEA     (_map_blk,A4),A0       ; Charge le pointeur du bloc de la carte
    MOVE.B  (0,A0,D0.W),D1         ; Récupère la donnée terrain/unité pour la tuile
    LEA     (_map_colour,A4),A0    ; Charge la palette de couleurs de la minimap
    MOVE.B  (0,A0,D1.L),D0         ; Obtient la couleur correspondante (eau, herbe, lave...)
```

### Projection Isométrique vers Écran 2D
La minimap doit afficher un univers isométrique (grille carrée tournée à 45°). Le code convertit les coordonnées tuiles (`x` et `y`, figurés par les registres `D4` et `D5`) en pixels-écrans selon une formule d'addition et de soustraction :

```assembly
    ; --- Calcul Y (Axe vertical) ---
    MOVE.W  D4,D0
    ADD.W   D5,D0
    ASR.W   #1,D0     ; Y = (X_tuile + Y_tuile) / 2

    ; --- Calcul X (Axe horizontal) ---
    MOVE.W  D4,D0
    ADD.W   #$0040,D0 ; 64 (0x40 - Largeur de la map)
    SUB.W   D5,D0     ; X = (X_tuile + 64) - Y_tuile
```
Cette méthode dessinait le losange directement sur l'image en fond `_back_scr` en écrivant pixel par pixel (`JSR ___pixel`). C'est l'essence du radar Populous : les 64x64 cases créent donc sur le radar un losange faisant 128 pixels de diagonale horizontale (X), et 64 pixels de hauteur (Y).

## 2. Interaction du clic : `_zoom_map`
Lorsque le joueur cliquait sur la minimap, la caméra de la vue isométrique principale devait se "téléporter" immédiatement à l'endroit cliqué. Cela déclenchait la routine `_zoom_map` (à l'adresse `$3F2F6`).

### Transformation Inverse (Écran vers Caméra)
Les données `_mousex` et `_mousey` capturées sont transformées pour devenir le décalage de la caméra de jeu, contrôlé par les variables `_xoff` et `_yoff`.

```assembly
    MOVE.W  (_mousex,A4),D0 
    ASR.W   #1,D0            ; D0 = mousex / 2
    SUB.W   #$0020,D0        ; Soustrait 32 (la moitié de la diagonale radar)
```
Le point cliqué est rescalé à la taille des coordonnées de tuiles de la map (64x64). Le programme doit s'assurer que la caméra ne dépasse pas les bords du monde.

### Bornes de la Map (Limitation)
La vue principale du joueur couvre typiquement un bloc de 8x8 tuiles à la fois. Par conséquent, les pointeurs de la caméra `_xoff` et `_yoff` ne peuvent pas atteindre 64, sous peine de rendre un "hors limite". 

```assembly
    CMPI.W  #$0038,D0        ; Contôle strict: est-ce plus grand que 56 (0x38) ?
    BGT.S   .clamp_max       ; Si oui on bloque
    CMPI.W  #0,D0            ; Est-ce plus petit que 0 ?
    BLT.S   .clamp_min       ; Si oui on bloque
```

L'algorithme bride le décalage de la caméra à `56`. Ainsi, le point le plus en bas à droite qu'on puisse observer correspond à la tile 56 + la taille de la fente d'observation de 8 = case 64 ! La caméra épouse ainsi parfaitement la géométrie du monde.

## Résumé du fonctionnement :
1. **Rendu** : Chaque case (sur les 4096 / `64x64`) est calculée. On lui attribue une couleur selon son relief avec la palette radar `_map_colour`. Sa coordonnée X/Y à l'écran est une conversion mathématique isométrique qui génère un pixel tracé à la main via `___pixel`.
2. **Interaction** : Le clic souris compense le ratio 2:1 du losange isométrique (via des décalages bitt-shifting `ASR.W`) pour retrouver les index de tableau correspondants, en se cantonnant à une valeur maximale de 56 pour garder l'écran d'observation en sécurité sur la carte (taille 64).