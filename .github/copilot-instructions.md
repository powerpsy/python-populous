# Instructions Copilot - Python Populous

##Règles de conversation
**Concision** : Répondez de manière concise et directe. Évitez les explications longues ou les digressions.

## Règles d'Architecture et de Rendu
**Scaling Dynamique (Modulable)** : Le jeu doit toujours supporter un changement d'échelle dynamique (ex: `SCALE = 1, 2, 3, 4`). La variable `SCALE` est définie dans `settings.py`.
**Multiplicateur Global** : Toutes les dimensions (tailles des sprites, dimensions des tiles, offsets isométriques, vitesses de curseur) doivent systématiquement être multipliées par `SCALE`.
**Aucun Pixel Magique** : Ne jamais écrire de coordonnées, de largeurs temporelles ou de pixels en dur dans la logique de rendu (ex: pas de `+ 15` ou de `32x32` fixe, utiliser `= 15 * SCALE` ou `32 * SCALE`).
**Séparation Logique / Rendu** : La logique du jeu (Positions `r, c`, pathfinding, construction) doit rester complètement indépendante de l'échelle graphique. L'échelle ne s'applique qu'au moment du rendu à l'écran (fonction `world_to_screen` et `draw`).
