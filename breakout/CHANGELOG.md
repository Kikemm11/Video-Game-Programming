# Changelog

# Author(s)

- Iván Maldonado 28.205.234
- Juan Gómez 28.296.295

## New Features:

### /assets/textures && /assets/sounds

- Add the .png files related to the left and rigth cannon, the bullet and the dust shield
- Add the .wav file related to the shot sound effect 

### /settings

- Add the textures and frames related to the left and right cannon and the bullet
- Add the shot sound
- Add variables to the dimensions and velocity of the new objects
- Add the KEY_f to the input_handler

### /src/powerups

- Add the CannonFire.py file which contains all the logic related to it in the classes CannonFire, Bullet and BulletPair
- Add the DustShield.py file wich contains all the logic related to it in the classes DustShield and Shield
- Add the StickyPaddle.py file wich contains all the logic related to it in the classes StickyPaddle and Sticky

### /src/Paddle.py

- Add new bool attribute cannons to manage the CannonFire powerup presence
- Add the methods get_cannos and leave_cannons to update the cannons attribute

### /src/Ball.py

- Add new bool attribute shield to manage the DustShield powerup presence

### /src/states/PlayState.py

- Add the new BulletPair list attribute bullets to storage the active bullets
- Add the float attribute cannon_fire_timer to manage the limit time for the CannonFire powerup to be active
- Add the new Shield shield attribute to storage an instance of a shield object 
- Add the float attribute dust_shield_timer to manage the limit time for the DustShield powerup to be active
- Add the stick_balls list, to count how many balls are stick to the paddle
 


## Changes:

### /src/Paddle.py

- Change the render method to check if there is presence of cannons to render them

### /src/Ball.py

- Change the solve_world_booundaries method to correct the position of the ball and make it "bounce" with the floor only if the DustShield powerup is active

### /src/states/PlayState.py

- Change the update method to keep track of the active bullets and update them, solve brick collisions and the powerup limit time
- Change the update method to keep track of the powerup limit time and deactivate it 
- Change the render method to render the bullets in case they exists and they are still active
- Change the render method to render the shield if necessary
- Change the on_input method to shot the bullets in case the powerup is still active
  

 




