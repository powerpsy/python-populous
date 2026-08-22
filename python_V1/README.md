# Python Populous

A **Populous** (Amiga) clone developed in Python using Pygame. This project aims to recreate the core mechanics of the original game: terrain manipulation, colony building, and divine management of "Peeps".

## 🚀 Current Features

- **Isometric engine**: Faithful rendering to the Amiga aesthetic.
- **Terrain manipulation**: Raise or lower the ground to create buildable areas.
- **Construction logic**: Peeps automatically build huts, houses, or castles based on terrain flatness.
- **Peep behaviour**: Wandering, building, and fusion behaviors to increase their strength.
- **Divine Commands**
    Go assemble Merge your Peeps to create stronger units
    Go Build    Encourage colonization
    Go Papal    Go to papal
    Go Fight    look for fight against foes **not implemented yet**
- **Divine Powers**
    Mountain    **not implemented yet**
    Quake       **not implemented yet**
    Swamps      **not implemented yet**
    Flood       **not implemented yet**
    War         **not implemented yet**
    Knight      **not implemented yet**

## 🛠️ Installation

1. install Python 3.10+
2. Install dependencies:
    ```bash
    pip install -r requirements.txt
    ```

## 🎮 How to Play

Launch the game:
    ```bash
    python populous.py
    ```

- **Left Click**: Raise terrain.
- **Right Click**: Lower terrain.
- **UI Buttons**: Use the icons on the right to switch modes (Build, Fusion, etc.).
- **F1**    remove peeps in the map
- **F2**    remove buildings in the map
- **F3**    generate new random map
- **F4**    level all terrain to height 1
- **F12**   scanline display
- **§**     DEBUG messages and display
- **TAB**   zoom x1 x2 x3 x4

## 🧰 Diagnostic Tools

The `tools/` folder contains several utility scripts:
- `map_viewer.py`: Map visualizer at different scales.
- `sprite_diagnostic.py`: Spritesheet analyzer.
- `house_diagnostic.py`: Terrain detection algorithm tester for houses.

## 📝 Architecture

The project follows a strict separation between game logic and rendering:
- `game_map.py`: Grid and altitude management.
- `peep.py`: AI and unit lifecycle.
- `house.py`: Territory logic and building evolution.
- `populous.py`: Main loop and input handling.
