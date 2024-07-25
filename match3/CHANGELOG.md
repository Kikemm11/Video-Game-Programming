# Changelog

# Author(s)

- Iván Maldonado 28.205.234
- Juan Gómez 28.296.295



## New Features

### Setings.py

- Add shuffle.wav and wrong.wav sound effects
- Add new input handler mouse_motion_left

### src/Board.py

- Add calculate_board_matches method to verify if it's any possible match in the board

### src/states/Playstate.py

- Add bool tile_clicked and bool shuffle attributes to keep track if one tile has been clicked and if a board suffle is needed respectively

- Add Tile tile1 and Tile tile2 attributes to represent the two tiles about to change in every move

- Add a check for possible matches in the __calculate_matches method every move to set the shuffle attribute to True   



## Changes

### src/Board.py 

- Update the calculate_matches_for method to accept a **params attribute to manage its logic
- Update the calculate_matches_for method to clear the collected matches when there is a 'all' parameter in order to return all the matches for the shuffle logic without deleting the actual matches

### src/states/Playstate.py

- Update the on_input method to turn the two tiles about to change into self attributes
- Update the __calculate_matches method to reverse with a Tween the move if there is no match
- Update the update method to check if the shuffle attribute is True to do the shuffling 



