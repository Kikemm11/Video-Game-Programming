# Changelog

# Author(s)

- Iván Maldonado 28.205.234
- Juan Gómez 28.296.295

## New Features


### /game_mode and /states

- Add PauseState.hpp and PauseState.cpp at /states to adapt the new state to the game, its behavior and transitions
- Create abstract class GameMode and GameModeNormal / GameModeHard to manage the behavior or rules of the game within the selected game mode.
- Add move_bird_x method logic at GameModeHard to allow the bird to also move on x axis
- Add close_log_pairs method logic at GameModeHard to close and open some logs following certain criteria
- Add update_power_up method logic at GameModeHard to update the state of the powerup 

### Bird

- Add vx attribute 
- Add ghost_bird attribute
- Add move method to update the x attribute of the bird based on the vx attribute and the dt parameter 
- Add set_vx_direction method to update the vx attribute within a right or left direction in the screen 
- Add setter and getter methods to the ghost_bird attribute
- Add setter method to update the value of sprite attribute


### World

- Add logs_close_timer attribute as a timer to generate a logpair that has the ability to crash 
- Add logs_closed_timer attribute as a timer to close or open the logpair within certain amount of time
- Add power_up_on_screen attribute to know wheter the ghost bird timer is rendered or not
- Add update_closing_logs method to update all the logpairs which are able to crash using the timer above
- Add set_power_up_on_screen method to update the value of the powerup_on_screen 
- Add update_power_up method

### Logpair

- Add close attribute to mark those logpairs which are able to crash 
- Add currently_closed attribute to know wheter a logpair is currently closed or open
- Add a getter and a setter for the close attribute
- Add close_gap and open_gap method to update the y values of the top and bottom logs of the log pair to crash or not
- Add a getter for the currently_close attribute

### Log 

- Add a setter for the y attribute of the logs

### Settings

- Add constants: BIRD_X_SPEED, TIME_TO_CLOSE_LOGS, TIME_CLOSED_LOGS, TIME_TO_POWER_UP, TIME_DURING_GHOST_BIRD, POWER_UP_VY
- Load the "crash" sound and the ghost_bird sound
- Load the powerup texture and the ghost_bird texture

### PowerUp 

- Add PowerUp class and all its logic to allow the bird become a ghost and avoid collisions with logs


## Changes


## Game

- Update the state_machine attribute including pause state

## Statemachine

- Update the change_state method to allow a from_state parameter to know what was the state before and a game_mode parameter to know the player choice

## BaseState

- Update the enter method to also allow the same parameters above

## TitleScreenState

- Update the render method to show the player two options of Game Mode
- Update the handle_inputs method to identify which option did the player choose

## PlayingState

- Update the enter method to always initialize the game_mode value and handle the other values in case the last state was "pause"
- Update the handle_inputs method to keep track of the bird movement and a possible game pause
- Update the update method to execute the GameMode methods following the player choice

## LogPair

- Update the update method to set randomly some pairlogs with the close attribute true (Crash)

