# Changelog

# Author(s)

- Iván Maldonado 28.205.234
- Juan Gómez 28.296.295



## New Features


### settings.py

- Add all the key properties
- Add the new texture and frames realted to the key object

### scr/Key.py

- Add Key class to manage the behavior of the Key object

### src/Player.py

- Add the get_collision_rect method

### src/states/game_states/PlayState.py

- Add the Key key and the bool key_active attributes



## Changes


### assets/tilemaps/level1.tmx

- Change the ground layer to define the new special block


### src/states/game_states/PlayState.py

- Update the update method to manage the logic related to the Key object when a condition is met (score >= 100)
- Update the render method to render the key when the previous condition is met


