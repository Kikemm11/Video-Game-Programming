# Changelog

# Author(s)

- Iván Maldonado 28.205.234
- Juan Gómez 28.296.295

## New Features:

### /assets/textures && /assets/sounds

- Add the .png files related to the left and rigth cannon and the bullet
- Add the .wav file related to the shot sound effect 

### /settings

- Add the textures and frames related to the left and right cannon and the bullet
- Add the shot sound
- Add variables to the dimensions and velocity of the new objects
- Add the KEY_f to the input_handler

### /src/powerups

- Add the CannonFire.py file which contains all the logic related to it in the classes CannonFire, Bullet and BulletPair

### /src/Paddle.py

- Add new bool attribute cannons to manage the CannonFire powerup presence
- Add the methods get_cannos and leave_cannons to update the cannons attribute

### /src/states/PlayState.py

- Add the new BulletPair list attribute bullets to storage the active bullets
- Add the float attribute cannon_fire_timer to manage the limit time for the CannonFire powerup to be active
 


## Changes:

### /src/Paddle.py

- Change the render method to check if there is presence of cannons to render them

### /src/states/PlayState.py

- Change the update method to keep track of the active bullets and update them, solve brick collisions and the powerup limit time
- Change the render method to render the bullets in case they exists and they are still active
- Change the on_input method to shot the bullets in case the powerup is still active

 




