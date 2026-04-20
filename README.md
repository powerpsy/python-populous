TODO ----------------------------------------------------------------------------------------------

* Peep life is not changing on the display (shield)
* house health bar (yellow as a function of level, increasing green as a function of peep)
* peep health bar (orange 10, orange 1) --> (yellow,orange 10)
* Peep behavior case: build
* Peep behavior case: gather
* Peep behavior case: fight
* Modify health bar with a border
* Place a papal magnet case
* Add weapon system
* Add sound to actions/powers/combat
* Create enemies
* Moving in cardinal direction shall move 1 block instead of 2
* Add a home page and game mode/password selection
* Add a gameover page
* Correct drowning animation (use 4 sprites)
* Create battles
* Add the ? option Display "shield" for information
* Implement peeps moving system "_move_peeps" "_move_explorer" "_where_do_i_go"
* Add trees & rocks + logic to remove

DONE ----------------------------------------------------------------------------------------------

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