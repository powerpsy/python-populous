# CONSTRUCTION_REPORT - Regles de Construction (Populous Amiga)

## 1) Perimetre et methode
Ce document isole les regles de construction des villes/batiments dans le code original.

Sources principales:
- `asm/populous_prg.asm`
- `asm/populous_prg.cnf`

Routines analysees:
- `_set_town` (coeur pose/croissance)
- `_valid_move` (validation d'occupation + bornes)
- `_check_life` (score local de constructibilite)
- `_one_block_flat` (verification de platitude locale)
- `_offset_vector` (masque de voisinage scanne)
- `_big_city` (table de conversion visuelle des types de ville)

## 2) Pipeline de decision (fait prouve)
Ordre fonctionnel observe:
1. Un peep/explorer arrive sur une case candidate.
2. `_check_life` calcule un score local sur un voisinage (`_offset_vector`) et rejette certains conflits.
3. `_set_town` applique la logique de pose ou de croissance selon son mode (`param` en pile, offset `($C,A5)`).
4. `_valid_move` filtre chaque offset scanne (hors-carte, roche, occupation non vide).
5. Si conditions satisfaites, `_map_blk` et `_map_bk2` sont modifies (marquage terrain/ville).

Preuves clefs:
- Appels `_set_town` dans le flux gameplay: `asm/populous_prg.asm:40a64`, `asm/populous_prg.asm:41642`, `asm/populous_prg.asm:42230`, `asm/populous_prg.asm:42a9c`.
- Label `_set_town`: `asm/populous_prg.asm:5865`.

## 3) Regle d'espace necessaire entre batiments

### 3.1 Ce que le code impose exactement (fait prouve)
Le code ne montre pas de test de distance euclidienne explicite du type "distance >= N" entre deux centres de ville.
A la place, il applique une contrainte d'espace via un balayage discret d'offsets autour de la position candidate:
- Base de balayage: `_offset_vector` (`asm/populous_prg.asm:24274`).
- Validation offset par offset: appel a `___valid_move` dans `_set_town` (`asm/populous_prg.asm:5882`, `asm/populous_prg.asm:5912`, `asm/populous_prg.asm:5952`, `asm/populous_prg.asm:5990`, `asm/populous_prg.asm:6021`).

`_valid_move` retourne:
- `D0 = 1` si hors bornes (`< 0` ou `>= 0x1000`) ou debordement de colonne (`x` hors `0..63`).
- `D0 = 2` si case rocher (`map_blk == 0x2f`).
- `D0 = 0` si case occupee par autre chose que vide/rocher.
- `D0 = 3` si case vide (`map_blk == 0x00`).

Preuve: bloc `_valid_move` `asm/populous_prg.asm:20912` a `asm/populous_prg.asm:20954`.

Interpretation operationnelle:
- Deux batiments ne peuvent pas pousser "trop pres" si les offsets critiques autour du centre tombent sur des cases deja occupees/non autorisees.
- L'interdiction est donc topologique (masque d'offsets + etat de grille), pas radiale continue.

### 3.2 Portee creation vs croissance (fait prouve)
Dans `_set_town`, les boucles n'ont pas la meme borne:
- `CMP.W #$0019,D4` (25 offsets) pour les parcours creation/initialisation.
- `CMP.W #$0011,D4` (17 offsets) pour les parcours de croissance/upgrade.

Preuves:
- `asm/populous_prg.asm:5904`, `asm/populous_prg.asm:5978`, `asm/populous_prg.asm:6012` (borne 0x0019)
- `asm/populous_prg.asm:5937`, `asm/populous_prg.asm:6043` (borne 0x0011)

Conclusion precise:
- Le "buffer" spatial est plus large dans les passes a 25 offsets que dans les passes a 17 offsets.
- Donc la croissance peut devenir plus dense localement que certaines phases de creation.

## 4) Regle de construction terrain (platitude, obstacles, occupation)

### 4.1 Platitude locale
`_one_block_flat` evalue les 4 coins d'une cellule via `_alt` (indexation en pas 0x41), somme les 4 hauteurs, puis traite ce resultat.

Preuves:
- Label: `asm/populous_prg.asm:9148`
- Adresse de stride: `MULS #$0041` (`asm/populous_prg.asm:9179`, `asm/populous_prg.asm:9185`, `asm/populous_prg.asm:9193`, `asm/populous_prg.asm:9203`)
- Test clef: `CMPI.W #$0001,(-8,A5)` (`asm/populous_prg.asm:9211`)
- Sinon division: `DIVS #$0004` (`asm/populous_prg.asm:9217`)

Important:
- Le test direct contre `1` est atypique pour une simple egalite de 4 hauteurs et depend du format interne des altitudes dans ce build.
- Ce document le traite comme critere interne de "bloc conforme" tel que code, sans le simplifier abusivement.

### 4.2 Obstacles et occupation
`_valid_move` bloque explicitement:
- Hors limites de carte (`0..0x0fff` + borne colonne `0..63`)
- Roche (`map_blk == 0x2f`)
- Toute case non vide (retour `0`, donc non valide pour les branches qui attendent autre chose)

Dans `_set_town`, on trouve aussi des tests sur `_map_bk2`:
- `CMPI.B #$2a,(0,A0,D0.W)` autour du centre pour choisir certaines branches de traitement.

Preuves:
- Test `0x2a`: `asm/populous_prg.asm:5876`, `asm/populous_prg.asm:5984`.
- Marquage terrain constructible: `MOVE.B #$0f` dans `_map_blk` (`asm/populous_prg.asm:5908`, `asm/populous_prg.asm:5988`).

## 5) Details de `_set_town` par mode

### 5.1 Mode parametre non nul (`TST.W ($C,A5)` puis non-BEQ)
Bloc demarre a `asm/populous_prg.asm:5876`.
Cas observes:
- Si `_map_bk2[centre] == 0x2a`: boucle 25 offsets (`LAB_4246E`).
- Sinon: boucle 17 offsets (`LAB_424C2`).

Actions typiques:
- Nettoyage partiel `_map_bk2` (`CLR.B`) sur offsets passes.
- Si `_map_blk[offset]` correspond au type attendu du peep (`peep_type + 0x1f`), alors marquage `0x0f`.

### 5.2 Mode parametre nul (branche `LAB_42528`)
Bloc demarre a `asm/populous_prg.asm:5929`.
Cas observes:
- Si `($C,A0) == 0x2a`, conversion via table `_big_city` pour une partie des offsets (`D4 < 9`).
- Sinon sous-cas avec test `_map_bk2[centre] == 0x2a`, puis phases 25 offsets + 17 offsets.

Actions typiques:
- Conversion de type ville via `_big_city` (`asm/populous_prg.asm:5963`).
- Promotion `_map_blk[offset]` si case en `0x0f` (`asm/populous_prg.asm:5968` a `asm/populous_prg.asm:5974`, et `asm/populous_prg.asm:6004` a `asm/populous_prg.asm:6010`).

## 6) Tables et constantes numeriques liees a la construction

Constantes directement pertinentes:
- `0x0019` (25 offsets) - bornes de boucles de scan.
- `0x0011` (17 offsets) - bornes de boucles de scan reduit.
- `0x2f` - roche dans `_map_blk` (blocage `_valid_move`).
- `0x2a` - etat special `_map_bk2` qui reroute des branches `_set_town`.
- `0x0f` - marquage "flat/constructible/intermediaire" dans `_map_blk`.
- `0x0041` - stride de grille altitude.
- `0x1000` - limite index carte.
- `0x003f` - masque/borne colonne.

References:
- `_offset_vector`: `asm/populous_prg.asm:24274`
- `_big_city`: `asm/populous_prg.asm:24284`
- symbols: `asm/populous_prg.cnf:226`, `asm/populous_prg.cnf:250`, `asm/populous_prg.cnf:373`, `asm/populous_prg.cnf:374`, `asm/populous_prg.cnf:689`, `asm/populous_prg.cnf:692`.

## 7) Hypotheses balisees (avec niveau de confiance)

### H1 - Interdiction de proximite exprimee par masque d'offsets
Hypothese:
- La regle "on ne construit pas trop pres" est encodee via `_offset_vector` + filtres `_valid_move`, plutot que par une distance geometrique explicite.

Confiance: Elevee.
Justification:
- Pas de comparaison distance radiale explicite trouvee dans la chaine `_check_life` -> `_set_town` -> `_valid_move`.
- Plusieurs boucles de scan a bornes fixes (17/25) pilotent le voisinage admissible.

### H2 - Les differents sous-cas de `_set_town` distinguent creation et croissance
Hypothese:
- Les branches selon `($C,A5)` et tests `_map_bk2 == 0x2a` representent differents etats de pose initiale/croissance.

Confiance: Moyenne a elevee.
Justification:
- La structure de code et les effets (clear/marquage/promotion) sont coherents avec un cycle de creation puis evolution.
- Nommage binaire interne partiellement opaque sans symboles metier complets.

## 8) Mapping recommande pour le remake Python (sans modification code)
Objectif: transposer la logique originale sans inventer une metrique de distance absente du code.

Recommandations:
1. Representer la contrainte de proximite avec un masque d'offsets (voisinage discret), pas une distance Manhattan/Euclidienne fixe.
2. Distinguer deux portees de scan (equivalent 25 et 17 positions) selon etat de construction.
3. Conserver des codes d'etat de cellule separant "vide", "roche", "plateforme constructible", "ville".
4. Faire de la validation d'occupation un gate unique (equivalent `_valid_move`) reutilise par pose et upgrade.

## 9) Resume executable
- Le jeu original interdit surtout la construction "trop proche" par echec des offsets de voisinage lors de `_set_town`, pas par rayon explicite.
- Le voisinage est asymetrique/ordonne via `_offset_vector`.
- Deux tailles de balayage existent (25 et 17), ce qui change la densite urbaine autorisee selon la phase.
- Les verrous principaux sont: bornes carte, rochers (`0x2f`), occupation non vide, et etats speciaux `_map_bk2` (`0x2a`).
