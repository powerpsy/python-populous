# SHIELD_REPORT - Analyse de la fonction "shield" (Populous Amiga)

## 1. Objet du rapport

Ce rapport documente les routines ASM qui permettent de:
- selectionner une entite sous le curseur,
- afficher le panneau "shield" (icones + barres),
- lire l'etat courant (vie, arme, etat de combat),
- maintenir une selection valide quand les peeps sont deplaces/fusionnes/supprimes.

Fichiers analyses:
- [asm/populous_prg.asm](asm/populous_prg.asm)
- [asm/populous_prg.cnf](asm/populous_prg.cnf)

## 2. Fonctions trouvees (preuve directe)

Fonctions centrales:
- `_interogate` a l'adresse $0003FFC2 ([asm/populous_prg.asm](asm/populous_prg.asm#L2719)).
- `_show_the_shield` a l'adresse $0004003A ([asm/populous_prg.asm](asm/populous_prg.asm#L2769)).
- `_set_temp_view` a l'adresse $000404AC ([asm/populous_prg.asm](asm/populous_prg.asm#L3151)).

Appels dans la boucle de jeu:
- Appel du rendu shield a chaque frame: `JSR (_show_the_shield,PC)` ([asm/populous_prg.asm](asm/populous_prg.asm#L761)).
- Appel de l'interrogation souris en mode normal: `JSR (_interogate,PC)` ([asm/populous_prg.asm](asm/populous_prg.asm#L974)).

Variables globales associees:
- `_view_timer`, `_old_view_who`, `_view_who` ([asm/populous_prg.asm](asm/populous_prg.asm#L25394)).
- `_weapons_order`, `_weapons_add` ([asm/populous_prg.asm](asm/populous_prg.asm#L25460)).

## 3. Selection de la cible (_interogate)

Routine: [asm/populous_prg.asm](asm/populous_prg.asm#L2719)

Comportement reconstitue:
1. Parcourt le buffer `_sprite` avec index D4 jusqu'a `_no_sprites`.
2. Teste si la souris est dans une hitbox autour du sprite:
- X entre `sprite.x` et `sprite.x + 0x0c`.
- Y entre `sprite.y` et `sprite.y + 0x08`.
3. Ne fait la selection que si `_mode == 1`.
4. Si clic gauche seul: appel `_set_temp_view(sprite[+6])`.
5. Si clic droit: selection persistante immediate:
- `_view_timer = 0`
- `_view_who = sprite[+6]`

Details click temporaire:
- `_set_temp_view` sauvegarde l'ancienne cible dans `_old_view_who` si pas de timer actif.
- Puis force `_view_timer = 10` et applique la nouvelle cible.
- Quand le timer expire, retour automatique vers `_old_view_who`.

Preuves:
- logique hitbox et mode/clic: [asm/populous_prg.asm](asm/populous_prg.asm#L2719)
- restoration timer dans la boucle: [asm/populous_prg.asm](asm/populous_prg.asm#L740)
- implementation de `_set_temp_view`: [asm/populous_prg.asm](asm/populous_prg.asm#L3151)

## 4. Rendu du panneau shield (_show_the_shield)

Routine: [asm/populous_prg.asm](asm/populous_prg.asm#L2769)

### 4.1 Resolution de l'entite cible

- Si `_view_who == 0`: sortie immediate.
- Sinon index peep = `_view_who - 1`.
- Adresse peep = `_peeps + index * 0x16`.
- Si `peep[+4] <= 0` (vie nulle): `_view_who` est efface.

Preuve: [asm/populous_prg.asm](asm/populous_prg.asm#L2769)

### 4.2 Affichage faction + arme

- Icône faction dessinee avec `peep[+1]` via `___draw_icon`.
- Arme determinee par recherche de correspondance de `peep[+3]` dans `_weapons_order`.
- Si trouvee (D4 < 11), dessine l'icône d'arme (index `D4+1`).

Preuves:
- draw icone faction: [asm/populous_prg.asm](asm/populous_prg.asm#L2794)
- lookup `_weapons_order`: [asm/populous_prg.asm](asm/populous_prg.asm#L2804)
- draw icone arme: [asm/populous_prg.asm](asm/populous_prg.asm#L2821)

### 4.3 Cas combat (bit flag #3)

Si `BTST #3,(A2)` est vrai:
- Affiche sprite de combat.
- Recupere l'adversaire via `peep[+6]`.
- Calcule 2 ratios de vie sur 16 crans:
- `barA = lifeA * 16 / (lifeA + lifeB)`
- `barB = lifeB * 16 / (lifeA + lifeB)`
- Dessine 2 barres (`___draw_bar`) avec couleurs distinctes.

Preuves:
- branche combat + draw sprite: [asm/populous_prg.asm](asm/populous_prg.asm#L2823)
- calculs ratios: [asm/populous_prg.asm](asm/populous_prg.asm#L2865)
- draw bars combat: [asm/populous_prg.asm](asm/populous_prg.asm#L2877)

### 4.4 Cas type 1 (branche speciale avec check_life)

Si `CMPI.B #$01,(A2)`:
- Appel `___check_life(peep[+1], peep[+8])`.
- Si retour 0, force a 1.
- Si retour == `0x0bea`, barre pleine.
- Sinon barre = `score * 16 / 0x0131`.
- Deuxieme barre derivee de `peep[+4] / score`, bornee a [0..16].

Preuves:
- appel check_life: [asm/populous_prg.asm](asm/populous_prg.asm#L2906)
- seuil 0x0bea + formule 0x0131: [asm/populous_prg.asm](asm/populous_prg.asm#L2914)
- clamp [0..16] et draw: [asm/populous_prg.asm](asm/populous_prg.asm#L2940)

### 4.5 Cas general

Sinon:
- Choix d'un sprite d'etat selon flags/type/direction (plusieurs branches).
- Affiche des barres derivees de `peep[+4]`:
- si vie > 0x1000: division par 0x0400,
- sinon division par 0x0100 puis sous-decoupage.

Preuves:
- selection sprite d'etat: [asm/populous_prg.asm](asm/populous_prg.asm#L2966)
- draw sprite final: [asm/populous_prg.asm](asm/populous_prg.asm#L3037)
- draw bars vie: [asm/populous_prg.asm](asm/populous_prg.asm#L3051)

## 5. Ce que montre exactement le "shield"

Faits certains (confirmes ASM):
- Le panneau est indexe par `_view_who`.
- `_view_who` est converti en pointeur dans `_peeps` (stride 0x16).
- Le panneau affiche au minimum:
- l'appartenance/faction,
- une classe d'arme (via `_weapons_order` et la valeur peep[+3]),
- des barres de vie/etat (format dependant de la branche).

## 6. Et pour les batiments ?

Conclusion technique:
- Je ne vois pas de routine "shield" dediee batiment dans cette chaine.
- La chaine `_interogate -> _show_the_shield` lit toujours une entree `_peeps`.
- Donc cette UI "shield" est d'abord peep-centrique (ou unite liee a la table peeps).

Ce qui existe cote urbanisme:
- `_check_life`, `_set_town`, `_one_block_flat` pilotent score/validite de construction,
- mais pas de preuve directe ici d'une selection batiment autonome affichant "vie + arme" comme un peep.

References:
- selection via sprite + id cible: [asm/populous_prg.asm](asm/populous_prg.asm#L2719)
- dereferencement cible dans `_peeps`: [asm/populous_prg.asm](asm/populous_prg.asm#L2769)
- check_life en logique peep/town: [asm/populous_prg.asm](asm/populous_prg.asm#L20958)

## 7. Cohabitation avec les mutations de peeps

Le code maintient `_view_who` coherent quand les index peeps changent:
- remap apres compactage/decalage: [asm/populous_prg.asm](asm/populous_prg.asm#L3931)
- remap dans routines de bataille/fusion: [asm/populous_prg.asm](asm/populous_prg.asm#L6547)
- reset si peep supprime: [asm/populous_prg.asm](asm/populous_prg.asm#L5712)

Cela confirme que "shield" suit un index peep vivant, pas un bloc map statique.

## 8. Resume operationnel pour le remake Python

Pour reproduire le comportement original:
1. Conserver un `view_who` (id unite), avec mode temporaire (`view_timer`, `old_view_who`) et mode persistant.
2. Selectionner par hit-test sur sprites ecran (pas par tuile brute).
3. Sur rendu HUD:
- lire faction/type/vie depuis l'entite cible,
- mapper arme via une table ordonnee de seuils (`weapons_order`),
- adapter les barres selon l'etat (combat, type 1, general).
4. Invalider automatiquement la selection si l'entite meurt/disparait.
5. Remapper `view_who` si les listes d'entites sont compactees.
