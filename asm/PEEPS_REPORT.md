# PEEPS_REPORT - Comportement des Habitants (Populous Amiga)

## 1. Perimetre
Ce rapport couvre les fonctions de la section "Peeps & Population" du code original, avec preuves ASM.

Sources:
- asm/populous_prg.asm
- asm/populous_prg.cnf

Fonctions cibles:
- _move_peeps
- _move_explorer
- _where_do_i_go
- _place_people
- _place_first_people
- _zero_population
- _join_forces

Fonctions de support directement impliquees:
- _move_magnet_peeps
- _set_frame
- _check_life
- _valid_move
- _set_town
- _set_battle, _join_battle, _do_battle
- _set_magnet_to

## 2. Index des symboles
Adresses symboliques (depuis asm/populous_prg.cnf):
- _move_peeps: $0004059A
- _move_explorer: $000413CA
- _where_do_i_go: $000416A0
- _join_forces: $000420B4
- _zero_population: $000421F4
- _place_people: $00043164
- _place_first_people: $000439BA

## 3. Structures et donnees observees

### 3.1 Table peeps et stride
Faits prouves:
- Les acces peeps utilisent massivement MULS #$0016, donc stride logique de 22 octets pour l'entite active.
  - Exemples: asm/populous_prg.asm:406f0, 41572, 420bc, 431ce.
- _no_peeps pilote la boucle active et la capacite globale.
  - Exemples: asm/populous_prg.asm:406ea, 43168.

Hypothese balisee:
- Il existe des tables paralleles (LAB_5301A, LAB_53020, etc.) indexees avec le meme stride 0x16; la representation logique d'un peep est probablement distribuee entre _peeps et ces tableaux auxiliaires.
Confiance: elevee.

### 3.2 Champs frequemment utilises
Faits prouves (offsets sur pointeur peep):
- +0: flags/etat (tests BTST bits 0..7, comparaisons de type 0x01, 0x02, 0x08).
  - Exemples: asm/populous_prg.asm:409a0, 4102c, 411c6, 41272.
- +1: owner/faction.
  - Exemples: asm/populous_prg.asm:40864, 413d4, 420e2.
- +2: sous-type/etat de deplacement (compare a 0x04, incremente).
  - Exemples: asm/populous_prg.asm:40efa, 40f06.
- +3: niveau arme/force (copie du max en fusion).
  - Exemples: asm/populous_prg.asm:421c0..421d2.
- +4: vie/energie (<=0 mort, cap fusion a 0x7d00).
  - Exemples: asm/populous_prg.asm:40856, 42132, 42208.
- +6: timer/frame local.
  - Exemples: asm/populous_prg.asm:4142e, 4122a.
- +8: position map (index tuile).
  - Exemples: asm/populous_prg.asm:41444, 4168e, 43218.
- +A: offset/mouvement courant (souvent ajoute/soustrait a +8).
  - Exemples: asm/populous_prg.asm:4144c, 41696, 4225c.
- +C: compteur de croissance/etat town.
  - Exemples: asm/populous_prg.asm:40a72, 40a98, 40cd6.
- +E: lien associe/alliage.
  - Exemples: asm/populous_prg.asm:420fa, 42116.
- +12: cible/position memoiree (reset si divergence).
  - Exemples: asm/populous_prg.asm:410ae..410d2.
- +14: marqueur auxiliaire de terrain/level.
  - Exemples: asm/populous_prg.asm:40c46, 40c7e.

## 4. Analyse complete des fonctions

### 4.1 _move_peeps
Role:
- Boucle maitresse d'update des peeps, avec preparation IA par faction, puis iteration peep par peep.

Faits prouves:
1) Init et phase par faction:
- Increment du tour: ADDQ.W #1,(_game_turn,A4). (asm/populous_prg.asm:405a6)
- Boucle sur 2 factions: CMPI.W #$0002. (asm/populous_prg.asm:405ea)
- Appels IA: _set_devil_magnet puis _devil_effect selon etat. (asm/populous_prg.asm:405c4, 405e0)

2) Normalisation compteurs population:
- Reinit de tableaux/counters good_pop/good_castles/good_towns/LAB_516C*. (asm/populous_prg.asm:405f6..406e0)

3) Parcours peeps actifs:
- Boucle via _no_peeps, test vie a +4. (asm/populous_prg.asm:40846..4085a)
- Si vie <= 0: suppression via _zero_population en fin de cycle. (asm/populous_prg.asm:412dc..412ea)

4) Branches etat:
- bit4 actif: branche combat/usure + _set_frame. (asm/populous_prg.asm:40894..40992)
- bit0 builder: appel _set_town(1) dans certains cas. (asm/populous_prg.asm:409a0..409ae)
- type 0x01: logique de croissance/score via _check_life puis _set_town. (asm/populous_prg.asm:409fe..40fce)
- type 0x02: logique explorer, _one_block_flat, _move_explorer. (asm/populous_prg.asm:40fd2..411bc)
- bits 5/6 (masque 0x60): animation/etat transitoire avec _set_frame. (asm/populous_prg.asm:411c6..41262)
- bit3 combat: _do_battle si type 0x08. (asm/populous_prg.asm:41264..41286)

5) Gestion ownership map_who:
- Ecrit owner+1 dans map_who sur la case occupee si vide. (asm/populous_prg.asm:40ae6..40b02, 41600..4161c)

6) Croissance, split et caps:
- Seuil fort de score: 0x0bea. (asm/populous_prg.asm:40a78)
- Formule de compteur: life_score*10/0x0131 + 0x20. (asm/populous_prg.asm:40aa8..40ab6)
- Si condition de sur-vie depassee, tentative de split peep et scan jusqu'a 0x00d0. (asm/populous_prg.asm:40da4..40f22)

### 4.2 _move_explorer
Role:
- Deplacement d'un peep explorateur, soit magnetique, soit pathfinding normal.

Faits prouves:
- Si magnet actif pour faction et contraintes remplies, appel _move_magnet_peeps, sinon _where_do_i_go. (asm/populous_prg.asm:413da..41410)
- Code echec path = 0x03e7: pose bit6 + timer (6)=7. (asm/populous_prg.asm:4141a..4142e)
- Nettoyage ownership precedent map_who selon position courante/offset. (asm/populous_prg.asm:41450..41476)
- Detection d'entite presente sur destination:
  - ally -> _join_forces
  - enemy -> _set_battle
  - cible deja en bataille -> _join_battle
  (asm/populous_prg.asm:4158e..415d8)
- Si immobile et conditions OK: _set_frame puis _set_town(0). (asm/populous_prg.asm:41620..41642)

### 4.3 _where_do_i_go
Role:
- Selection d'un offset de deplacement en evaluant voisinage via _offset_vector et _valid_move.

Faits prouves:
- Valeur initiale de cout: 0x270f. (asm/populous_prg.asm:416a8)
- Boucle directionnelle modulee par random au premier passage. (asm/populous_prg.asm:416d6..416e8)
- Nombre d'iterations externes: compare a 9. (asm/populous_prg.asm:41944)
- Validation mouvement: appel _valid_move pour offsets. (asm/populous_prg.asm:41718, 41794)
- Critere sur map_blk == 0x0f pour une branche cle. (asm/populous_prg.asm:41740)
- Appel _check_life pour D5=0 (branche principale). (asm/populous_prg.asm:41752..4176c)
- Scan secondaire D6 de 9 a 0x11 avec seuil altitude map_bk2 dans ]0x20, 0x2c].
  - CMPI.W #$0020 / #$002c. (asm/populous_prg.asm:417be, 417c6)

Hypothese balisee:
- Strategie = heuristique locale sur offsets (gradient/occupation), pas recherche globale type A*.
Confiance: elevee.

### 4.4 _join_forces
Role:
- Fusion de deux peeps (alliance), conservation du plus fort, suppression du doublon.

Faits prouves:
- Resolution des deux pointeurs via index*0x16. (asm/populous_prg.asm:420bc, 420ce)
- Si peep source a lien +E, tentative de transfert vers cible. (asm/populous_prg.asm:420fa..42116)
- Vie totale cappee a 0x7d00. (asm/populous_prg.asm:42132..4213e)
- Mise a jour _magnet et _view_who si index concerne. (asm/populous_prg.asm:42156..4218c)
- Niveau arme max conserve sur offset +3. (asm/populous_prg.asm:421c0..421d2)
- Source videe (vie=0), cible nettoyee de certains flags et timer. (asm/populous_prg.asm:421d8..421ec)

### 4.5 _zero_population
Role:
- Suppression canonique d'un peep et nettoyage des traces map/magnet.

Faits prouves:
- Vie remise a 0. (asm/populous_prg.asm:42208)
- Si flag builder bit0, appel _set_town(1) avant nettoyage. (asm/populous_prg.asm:42224..42230)
- Effacement map_who sur case principale et derivee (8 - A). (asm/populous_prg.asm:42236..4227e)
- Si le peep etait ancre magnet, reset _magnet et appel _set_magnet_to. (asm/populous_prg.asm:42282..422ba)

### 4.6 _place_people
Role:
- Allocation/initialisation d'un peep individuel.

Faits prouves:
- Garde-fou capacite: _no_peeps < 0x00d0. (asm/populous_prg.asm:43168)
- Si parametre magnet actif, peut forcer un remplacement via ___zero_population. (asm/populous_prg.asm:43174..431bc)
- Sinon alloue nouvel index et incremente _no_peeps. (asm/populous_prg.asm:431be..431c6)
- Initialise tables peep auxiliaires (LAB_5301A, 53018, 5301C, etc.) et _peeps entry.
  - type initial: byte 0 = 0x02. (asm/populous_prg.asm:43242)
  - write owner map_who avec index+1. (asm/populous_prg.asm:4321c..43220)
- Appel _set_frame en fin d'init. (asm/populous_prg.asm:432ca)

### 4.7 _place_first_people
Role:
- Placement initial de population pour joueur puis adversaire.

Faits prouves:
- Selection du nombre initial selon conquest/serial/options. (asm/populous_prg.asm:439be..439fe, 43aca..43b0a)
- Bonus score: +10 par peep place. (asm/populous_prg.asm:43a08, 43b16)
- Plusieurs passes de balayage de map_blk/map_who:
  - recherche de 0x0f d'abord.
  - fallback sur tuiles non nulles et libres owner.
  (asm/populous_prg.asm:43a12..43ac8, 43b20..43bd2)
- Appelle _place_people pour chaque spawn.

## 5. Constantes et seuils numeriques (Peeps)
- 0x00d0: cap population (place_people, scans de split). 
  - asm/populous_prg.asm:43168, 40f18.
- 0x0016: stride index peep logique.
  - asm/populous_prg.asm:406f0, 420bc, 431ce.
- 0x002e: stride de tableaux faction/stats annexes.
  - asm/populous_prg.asm:405b2, 40b46.
- 0x03e7: code echec pathfinding.
  - asm/populous_prg.asm:4141a.
- 0x0007: timer stop apres blocage explorateur.
  - asm/populous_prg.asm:4142e.
- 0x7d00: cap vie fusion.
  - asm/populous_prg.asm:42132.
- 0x0bea: seuil haut check_life pour branche croissance.
  - asm/populous_prg.asm:40a78.
- 0x0131 et 0x20: formule de normalisation compteur.
  - asm/populous_prg.asm:40aae, 40ab2.
- 0x0020..0x002c: fenetre altitude map_bk2 utilisee en selection de direction secondaire.
  - asm/populous_prg.asm:417be, 417c6.
- 0x0f: tile plat/constructible dans map_blk (utilise dans pathing/spawn initial).
  - asm/populous_prg.asm:41740, 43a20, 43b2e.

## 6. Table rapide des appels inter-fonctions
- _move_peeps -> _set_devil_magnet, _devil_effect, _set_frame, _check_life, _set_town, _move_explorer, _one_block_flat, _do_battle, _zero_population.
- _move_explorer -> _move_magnet_peeps | _where_do_i_go, puis _join_forces/_join_battle/_set_battle.
- _where_do_i_go -> _valid_move, _check_life, consultation _offset_vector/_map_blk/_map_bk2/_map_who.
- _place_first_people -> _place_people.
- _place_people -> ___zero_population (cas magnet), _set_frame.

## 7. Ambiguites et hypotheses balisees
1) Sens exact de certains bits de flag (byte +0) selon tous les etats.
- Fait: bits 0..7 sont testes/modifies dans plusieurs branches.
- Hypothese: mapping fin bit->etat peut varier selon phase (combat, freeze, leader, etc.).
Confiance: moyenne.

2) Nature exacte des tableaux LAB_5301*.
- Fait: indexes en stride 0x16 et manipules avec _peeps.
- Hypothese: metadonnees runtime (cooldowns, lock, destination, etc.).
Confiance: moyenne a elevee.

3) Interpretation fonctionnelle de _stats (valeurs 1,2,4,5).
- Fait: ecriture de ces codes dans les branches de mouvement/ordre utilisateur.
- Hypothese: machine a etats de haut niveau (idle/explorer/action speciale).
Confiance: moyenne.

## 8. Implications directes pour le remplacement dans le remake Python
Pour la prochaine etape (remplacer les fonctions actuelles):
1) Introduire une machine a etats peep explicite (flags + type + timers), au lieu d'un seul flux lineaire.
2) Centraliser la gestion ownership de tuiles (equivalent map_who) a chaque deplacement.
3) Reproduire les caps/seuils constants: 0x00d0, 0x03e7, 0x7d00, 0x0bea, 0x0131/0x20.
4) Implementer la fusion _join_forces comme primitive dediee (pas seulement collision naive).
5) Faire du pathing par offsets discrets (offset_vector) avec filtres _valid_move/_check_life.

---

Ce document est volontairement strict sur les faits traces dans l'ASM, et distingue les interpretations lorsque la semantique metier n'est pas explicite dans les symboles.