# Changelog

# Author(s)

- Iván Maldonado 28.205.234
- Juan Gómez 28.296.295



## New Features

### settings.lua

- Add chest, bow, horizontal-arrow, vertical-arrow, dragon and fireball textures
- Add chest-open, bow-reward and boss-fight sounds

### src/definitions/entity.lua

- Add dragon entity definition

### src/definitions/game_objects.lua

- Add chest, bow, horizontal-arrow, vertical-arrow and fireball obkects definitions

### src/GameObject.lua

- Add bool open and bool used attributes

### src/ArrowFactory.lua

- Add the class ArrowFactory and all its logic to generate arrows as projectiles when needed

### src/Player.lua 

- Add bool activeBow attribute 

### src/Boss.lua

- Add the class Boss to manage the logic of the boss and its behavior
- Add the trhowFireball method when the boss tries to attack the player

### src/Fireball.lua

- Add the class Fireball which acts like the Projectile one to manage the behavior of the fire balls 

### src/world/Room.lua

- Add bool activeBoss, Boss boss, table fireballs attribute
- Add the generateBoss method to crerate a boss when necessary

### src/states/boss/BossIddleState.lua

- Add the class BossIddleState which manage the logic when the boss is paralized by the player arrows

### src/states/boss/BossWalkState.lua

- Add the class BossWalkState wich manage the logic when the boss is moving




## Changes


### src/states/game/PlayState.lua

- Update the exit method to check if there is a boss fight scene to stop the correct music

### src/world/Room.lua 

- Update the init method to recognize wheter it is necessary to generate the boss scene or not 

- Update the update method to check if there is a boss then manage all its logic and also take in count the fireballs table and update them 

- Update the generateObjects method to generate a chest with a 10% of probabililties each time

- Update the render method to take in count wheter the boss exists or not to render all the things involved in the boss fight

### src/states/player/PlayerIdleState.lua

- Update the update method to check if the player is in front the chest to set its open attribute to true when the player press the enter key

- Update the update method to check wheter the player has pressed the f key to shoot arrows

### src/states/player/PlayerWalkState.lua

- Update the update method to check wheter the player has pressed the f key to shoot arrows

### src/states/player/PlayerSwingSwordState.lua

- Check if there is a boss and able the player to attack them with the sword only when it is paralized