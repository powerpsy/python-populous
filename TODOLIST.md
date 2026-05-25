TODO ----------------------------------------------------------------------------------------------

* v3 implement option "build possibility"
* v3 implement option "build direction"
* v3 implement option "build near town/people"
* v2 Update powerjauge with a non linear progression linked to the POWER_COST matrix
* v2 Add god power: war
* v4 Add sound to actions/powers/combat
* v5 Add a map generator (using a simple "key" to generate x/y peeps in different locations and different terrain typologies) --> simulate reproducible random maps as in the original game
* v5 Add a home page and game mode/password selection
* v5 Add a gameover page
* v2 update battle outcome with weapon + ramdomness
* v2 Add trees + logic to remove
* v9+ Add internet multiplayer
* v9+ Change map scale displayed from 8x8 to 16x16 and 32x32
* v2 buildings distance needs to be reviewed + some new buildings diminish existing buildings
* v2 peeps are not allowed to walk through rocks

DONE ----------------------------------------------------------------------------------------------
v0.1.0
26. Added god power: quake
25. Added god power: flood
01. Add a game window and the ability to scroll to the edges of the terrain
02. Add the star sprite for terrain control
03. Manage peeps 1: Add two energy bars above (one yellow, one orange), 1 yellow pixel = one full orange bar
04. Manage peeps 2: Correct peep animations in each direction
05. Correct edge effect: Add dirt to the edges of the terrain: avoid black (flat surfaces can be stacked to fill black spaces)
06. Manage buildings 5: Display buildings in the background first
07. Use AmigaSprites
08. Use the AmigaUI
09. Rework the mechanism for displaying the map above the background
10. Refactor the map and height control
11. Adjust mouse movement and the Isometric transformation (distance detection)
12. Manage buildings 1: Demolish a building if the terrain is not flat.
13. Manage buildings 4: Each building has a population growth rate. A list of population output frequencies and energy growth rates is required.
14. Manage buildings 2: Evaluate if there is sufficient space for a building.
15. Create a minimap
16. Relocate screen using minimap
17. Manage buildings 3: Setting up the castle
18. take into account multi key (map scrolling in 8 directions possible)
19. Added powers buttons + emboss when clicking
v0.1.4
20. Added pointer logic for various actions (terrain, papal, shield)
21. Add the ? option Display "shield" for information
22. Place a papal magnet case
23. Add weapon system
24. Moving in cardinal direction shall move 1 block instead of 2
25. Correct drowning animation (use 4 sprites)
v0.1.5
26. Peep life is not changing on the display (shield)
27. house health bar (yellow as a function of level, increasing orange as a function of life)
28. Modify health bar with a border
29. Peep behavior _go_build
30. Peep behavior _go_papal
31. Implement peeps moving system "_move_peeps" "_move_explorer" "_where_do_i_go"
v0.1.6
32. Implemented randomness in movement when looking for new terrain to build
33. reduced building distance to 1 tile between all buildings but castle (2 tiles distance)
v0.1.7
34. Refactored peep code for displacement and building
35. Refactored building code to mimic the shape as in the original game
36. Manage buildings 5: if castle can be built it "delocates" buildings around
v0.1.8
37. Peep behavior case: assemble - peeps are standing with no movement (idle animation)
38. building placement refinement: peeps should be able to place more buildings up to the ability to transform into castle if enough space / ability to remove neighbours without destroying castles (highest priority)
v0.1.9
39. Shield behaviour reviewed: it now goes from peep to building and from building to peep, also is kept when fusioning peeps.
40. Display correction of health in the shield (building and peep)
41. Added the <find_papal> function
42. Added the <find_shield> function
43. Drowning peeps were able to move when drowning (actually they were swimming !) now they stay in place.
v0.2.0
44. Create foes
45. Update minimap with allies/foes colours
46. Create battles
v0.2.1
47. Mouse sprite is drawn behing the shield sprites. shall be the opposite.
48. Castle drawing on terrain edges: the castle is always drawn as a full unit, even if it shall not be seen partially out of the 8x8 map
49. Added peep behavior case: go_fight
50. Define god power costs, max power jauge and accumulation term
51. Add power jauge
v0.2.2
52. Add god power: volcano
53. Add rocks + logic to remove in water
54. Added rocks logic to prevent building & influence zone
55. Add god power: flood
56. Add god power: quake
57. Add god power: swamps
v0.2.3
58. review go_papal & go_assemble to allow only one faction to change behaviour (all peeps went go_papal if selected !)
v0.3.0
59. Create god foe (the computer plays the game against you)
v0.3.1
60. Added menu (OPTIONS/QUIT/RETURN), added populous type fonts
61. Added options, same as original game (not implemented yet)
v0.3.2
62. Create leader when getting papal (carries the cross / evil sign)
63. Add god power: knight
64. Allow shield to be held by allies, knights foes. It is showing the correct player and the correct papal side.
v0.3.3
65. Implemented "find_knight"
66. Implemented "water fatality" option
67. Implemented  "swamps depth" option
v0.3.4
68. Peeps drowning can not "wait" for a battle anymore
v0.3.5
69. Reviewed peeps movement (all together the same direction is not good !)
70. Reviewed the go_build, go_fight and go_assemble, knight can't fuse with peeps anymore
71. Added homepage