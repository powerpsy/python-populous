# Populous Python v2

Portage Python du jeu Populous basé sur les sources Amiga, avec séparation stricte
entre la logique de jeu et le rendu graphique.

## Structure

```
python_v2/
├── main.py          # Point d'entrée, boucle de jeu
├── game_state.py    # Orchestrateur logique (aucun pygame)
├── map_logic.py     # Terrain isométrique (aucun pygame)
├── house_logic.py   # Bâtiments (aucun pygame)
├── peep_logic.py    # Personnages / unités (aucun pygame)
├── ai_player.py     # Intelligence artificielle (aucun pygame)
├── camera.py        # Caméra (aucun pygame)
├── renderer.py      # Tout le rendu pygame (séparé de la logique)
├── sound.py         # Effets sonores pygame.mixer
├── settings.py      # Constantes et chemins vers data/
└── requirements.txt
```

## Principe d'architecture

La logique du jeu (positions `r, c`, pathfinding, construction, IA) est **totalement
indépendante** de l'affichage. Seuls `renderer.py`, `sound.py` et `main.py` importent
pygame.

## Lancement

```bash
cd python_v2/
pip install -r requirements.txt
python main.py
```

## Ressources

Le jeu utilise les fichiers graphiques et sonores du répertoire `data/` :

- `data/gfx/AmigaTiles1.PNG`   – tileset terrain
- `data/gfx/AmigaSprites1.PNG` – sprites peeps
- `data/gfx/AmigaUI.png`       – interface utilisateur
- `data/gfx/ButtonUI.png`      – boutons UI
- `data/gfx/Weapons.png`       – icônes d'armes
- `data/gfx/font.png`          – police bitmap
- `data/sfx/*.wav`             – effets sonores

## Contrôles

| Touche         | Action                          |
|----------------|---------------------------------|
| Flèches / WASD | Déplacer la caméra              |
| Clic gauche    | Interagir (terrain / boutons)   |
| ESC            | Menu principal                  |
| ENTER (menu)   | Démarrer une partie             |
