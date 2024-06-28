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

### Bird

- Add vx attribute 
- Add move method to update the x attribute of the bird based on the vx attribute and the dt parameter 
- Add set_vx_direction method to update the vx attribute within a right or left direction in the screen 


### World

- Add logs_close_timer attribute as a timer to generate a logpair that has the ability to crash 
- Add logs_closed_timer attribute as a timer to close or open the logpair within certain amount of time
- Add update_closing_logs method to update all the logpairs which are able to crash using the timer above

### Logpair

- Add close attribute to mark those logpairs which are able to crash 
- Add currently_closed attribute to know wheter a logpair is currently closed or open
- Add a getter and a setter for the close attribute
- Add close_gap and open_gap method to update the y values of the top and bottom logs of the log pair to crash or not
- Add a getter for the currently_close attribute

### Log 

- Add a setter for the y attribute of the logs

### Settings

- Add constants: BIRD_X_SPEED, TIME_TO_CLOSE_LOGS, TIME_CLOSED_LOGS
- Load the "crash" sound


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
