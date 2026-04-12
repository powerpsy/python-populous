# Instructions Copilot - Python Populous

##Règles de conversation
**Concision** : Répondez de manière concise et directe. Évitez les explications longues ou les digressions.

## Règles d'Architecture et de Rendu
**Pas de paramètre de Scaling dynamique** : Le pixel art fonctionne à l'échelle (1:1). Il n'y a plus de variable d'échelle x1, x2...
**Séparation Logique / Rendu** : La logique du jeu (Positions `r, c`, pathfinding, construction) doit rester complètement indépendante de l'affichage.
