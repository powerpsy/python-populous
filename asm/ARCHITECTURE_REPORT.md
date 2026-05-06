# Architecture et Mécaniques de Populous (1989) - Analyse du Code Source Amiga

Ce document détaille les routines clés identifiées dans le code assembleur d'origine (fichiers `.asm` et `.cnf`). Il sert de référence historique et technique pour comprendre comment Peter Molyneux et Bullfrog ont structuré le jeu, et comment transposer ces mécaniques dans un remake moderne en Python.

## 1. Moteur de Terrain et Modélisation (Map & Sculpt)
La gestion de la carte isométrique repose sur une grille d'altitudes où chaque vertice est modifiable.
*   **`_make_map`, `_clear_map`, `_make_alt`, `_make_level`** : Ces fonctions génèrent la carte initiale. Le monde est généré de manière procédurale à partir d'un "seed" (paysage de la Genèse). Elles initialisent la matrice des altitudes et la remplissent de terre ou d'eau.
*   **`_raise_point`, `_lower_point` (et wrappers `_do_raise...`)** : La mécanique cœur du gameplay. Lorsqu'un joueur clique, l'altitude d'un point est modifiée de ±1. L'algorithme vérifie ensuite récursivement les 8 points voisins. Si la différence d'altitude dépasse 1 (règle des pentes douces d'un cran maximum), les points voisins sont également ajustés en cascade ("propagate" effect).
*   **`_sculpt`, `_mod_map`, `_draw_map`, `_zoom_map`** : Le moteur de rendu. L'Amiga manquait de puissance pour tout redessiner à chaque frame : `_mod_map` gère une technique de 'Dirty Region' pour ne rafraîchir que les tuiles nouvellement modifiées. `_zoom_map` ajuste le rendu pour basculer la vue en livre ouvert typique (macro vs micro).

## 2. Comportement des Habitants (Peeps & Population)
Les personnages ("Peeps") échappent au contrôle direct du joueur. Leur IA repose sur des machines à états finis.
*   **`_move_peeps`, `_move_explorer`** : Boucle de déplacement. Un "explorer" est un Peep itinérant qui arpente l'environnement à la recherche de terrains plats pour y fonder une colonie.
*   **`_where_do_i_go`** : Système de Pathfinding. L'algorithme n'utilise pas de 'A-star' pour des raisons de performance, mais "renifle" le gradient d'altitude des 8 tuiles adjacentes. Le Peep choisit la pente la plus prometteuse (descendre vers des plaines pour construire, ou s'orienter vers l'aimant papal pour le leader).
*   **`_place_people`, `_place_first_people`, `_zero_population`** : Gestion du spawn/mort des entités. `_zero_population` fait table rase en purgeant toutes les métadonnées (souvent appelé lors du décret final 'Armageddon').
*   **`_join_forces`** : Algorithme de fusion. Lorsqu'un Peep croise la route d'un allié, ils fusionnent en une seule entité. Leurs scores individuels de vie et de discipline martiale sont cumulés, engendrant un guerrier redoutable.

## 3. Logique de Construction & d'Urbanisme (Towns & Buildings)
La croissance démographique s'aligne rigoureusement sur le degré d'aplatissement du terrain.
*   **`_set_town`** : Routine maîtresse. Quand un Peep s'arrête sur une zone plate valide, elle scanne le périmètre et calcule un "score de liberté". Ce score dicte l'abstraction graphique et hiérarchique du bâtiment généré (allant d'une tente = ID 0 jusqu'à la forteresse = ID max).
*   **`_one_block_flat`** : Fonction de validation bas niveau (`get_flat_area_score` dans notre remake Python). Elle promène des curseurs sur la matrice pour affirmer que tous les coins requis pour un monument géant sont stritement alignés à la même élévation.
*   **`_ok_to_build`** : Sécurité binaire : La zone n'abrite-t-elle pas déjà de la roche (`_make_woods_rocks`), un marais empoisonné, ou bien les fondations d'un bastion ennemi ?

## 4. Combats, Puissance et Armement
L'évolution armée et technique du peuple n'est dictée que par l'expérience et le mana condensé de sa civilisation.
*   **`_do_battle`, `_set_battle`, `_join_battle`, `_battle_over`** : Un combat pur et invisible. Quand un combattant s'incruste sur un opposant, une équation confronte leurs compteurs de force (`_join_forces`) et leurs armes, incluant du hasard. Le vainqueur ampute la faction vaincue et absorbe parfois ses bâtisses.
*   **`_score`** : Moniteur continu (entier de 2 ou 4 octets) de la prospérité d'une faction.
*   **`_weapons_order` / `_weapons_add`** : Matrices de Lookup. `_weapons_add` alloue d'opulents montants d'XP (Score) aux joueurs construisant d'immenses châteaux. Dès ce cap passé, `_weapons_order` apparie l'expérience à une "classe d'arme" visualisée (mains nues -> bâton -> épinglettes -> épée lourde -> arc).
*   **`_show_the_shield`** : Pique le statut interne d'arme du bataillon courant et réactualise l'armoirie à l'écran, le blason UI donnant foi au rendement militaire immédiat.
*   **`_do_knight`** : Palingénésie ultime. Pompant une très ample retenue d'expérience, elle sacralise le Leader sous cuirasse divine, le rendant autonome, surpuissant et pyromane vis à vis de l'ennemi jusqu'à désintégration terminale.

## 5. Pouvoirs Divins (God Powers & AI)
L'usage de la Mana gagnée via la ferveur des cultistes et son pendant robotisé.
*   **`_do_flood`, `_do_quake`, `_do_volcano`, `_do_swamp`** : Miracles altérant inopinément le globe. `_do_volcano` force l'érection violente d'une grille de points géocentrés, tout en inondant les abords du sprite 'Roche/Lave'.
*   **`_do_magnet`, `_set_magnet_to`, `_move_magnet_peeps`** : Comportement de la Croix Ankh. La dépose de ce totem invalide l'habituel pathfinding. Le vecteur calculé par `_where_do_i_go` est vampirisé et forcé de tirer l'entièreté de la croisade amie vers la cible spatiale `_set_magnet_to`.
*   **`_devil_effect`, `_do_computer_effect`** : Intelligence Artificielle. Molyneux lui fait dérouler exactement les mêmes directives UI qu'au joueur humain : elle "clic" numériquement les collines adverses pour en tirer ses propres plaines (`_sculpt`), tout en bridant chronométriquement sa frénésie destructrice sur votre mana via `_move_mana`.

## 6. Interface, UI et Boucle de Jeu
Le cadre matériel et réseau du code de l'ère 16 bit.
*   **`_main`, `_setup_display`, `_animate`** : Amorce de l'environnement graphique de l'Amiga. `_animate` régule la boucle principale alignée sur les balayages verticaux du tube cathodique (Le VBlank) en prévenant les déchirements des animations (50 fps/60 fps).
*   **`_start_game`, `_end_game`, `_won_conquest`, `_game_options`** : Orchestration des menus et états terminaux.
*   **`_save_load`, `_try_serial`, `_two_players`** : Exploits réseaux asynchrones via ports série RS-232 (link-câble à l'ancienne). Les connexions 1989 de 9600 bauds peinaient trop pour synchroniser tout le volume de la carte ; le modèle d'architecture Populous ne propage sur le fil `_serial_message` que la position différentielle (X/Y) et l'impulsion (raise/lower/miracle) qu'actionne le collègue !
