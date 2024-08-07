"""
ISPPJ1 2024
Study Case: Breakout

Author: Alejandro Mujica
alejandro.j.mujic4@gmail.com

This file contains the game settings that include the association of the
inputs with an their ids, constants of values to set up the game, sounds,
textures, frames, and fonts.
"""

from pathlib import Path

import pygame

from gale import input_handler
from gale.frames import generate_frames

from src.utilities.frames import (
    generate_paddle_frames,
    generate_ball_frames,
    generate_brick_frames,
    generate_powerups_frames,
)

input_handler.InputHandler.set_keyboard_action(input_handler.KEY_ESCAPE, "quit")
input_handler.InputHandler.set_keyboard_action(input_handler.KEY_RETURN, "enter")
input_handler.InputHandler.set_keyboard_action(input_handler.KEY_UP, "move_up")
input_handler.InputHandler.set_keyboard_action(input_handler.KEY_RIGHT, "move_right")
input_handler.InputHandler.set_keyboard_action(input_handler.KEY_DOWN, "move_down")
input_handler.InputHandler.set_keyboard_action(input_handler.KEY_LEFT, "move_left")
input_handler.InputHandler.set_keyboard_action(input_handler.KEY_f, "shot")
input_handler.InputHandler.set_keyboard_action(input_handler.KEY_SPACE, "pause")

# Size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

# Size we are trying to emulate
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

NUM_HIGHSCORES = 10

# Num points base to recover a live
LIVE_POINTS_BASE = 2000

PADDLE_GROW_UP_POINTS = 200

POWERUP_SPEED = 50

# Bullet properties
BULLET_WIDTH_HEIGHT = 12
BULLET_SPEED = -100  

# Cannons properties
CANNON_WIDTH = 16
CANNON_HEIGHT = 20

# CannonFire time

CANNON_FIRE = 15

# Dust shield properties

DUST_SHIELD_WIDTH = 432
DUST_SHIELD_HEIGHT = 21
DUST_SHIELD = 15

STICKY_TIME = 3

BASE_DIR = Path(__file__).parent

pygame.mixer.init()

SOUNDS = {
    "paddle_hit": pygame.mixer.Sound(BASE_DIR / "assets" / "sounds" / "paddle_hit.wav"),
    "selected": pygame.mixer.Sound(BASE_DIR / "assets" / "sounds" / "selected.wav"),
    "brick_hit_1": pygame.mixer.Sound(
        BASE_DIR / "assets" / "sounds" / "brick_hit_1.wav"
    ),
    "brick_hit_2": pygame.mixer.Sound(
        BASE_DIR / "assets" / "sounds" / "brick_hit_2.wav"
    ),
    "wall_hit": pygame.mixer.Sound(BASE_DIR / "assets" / "sounds" / "wall_hit.wav"),
    "hurt": pygame.mixer.Sound(BASE_DIR / "assets" / "sounds" / "hurt.wav"),
    "level_complete": pygame.mixer.Sound(
        BASE_DIR / "assets" / "sounds" / "level_complete.wav"
    ),
    "high_score": pygame.mixer.Sound(BASE_DIR / "assets" / "sounds" / "high_score.wav"),
    "life": pygame.mixer.Sound(BASE_DIR / "assets" / "sounds" / "life.wav"),
    "grow_up": pygame.mixer.Sound(BASE_DIR / "assets" / "sounds" / "grow_up.wav"),
    "pause": pygame.mixer.Sound(BASE_DIR / "assets" / "sounds" / "pause.wav"),
    "shot": pygame.mixer.Sound(BASE_DIR / "assets" / "sounds" / "shot.wav"),
}

TEXTURES = {
    "background": pygame.image.load(
        BASE_DIR / "assets" / "textures" / "background.png"
    ),
    "spritesheet": pygame.image.load(BASE_DIR / "assets" / "textures" / "breakout.png"),
    "hearts": pygame.image.load(BASE_DIR / "assets" / "textures" / "hearts.png"),
    "arrows": pygame.image.load(BASE_DIR / "assets" / "textures" / "arrows.png"),
    "cannon_left": pygame.image.load(BASE_DIR / "assets" / "textures" / "cannon_left.png"),
    "cannon_right": pygame.image.load(BASE_DIR / "assets" / "textures" / "cannon_right.png"),
    "bullet": pygame.image.load(BASE_DIR / "assets" / "textures" / "bullet.png"),
    "dust_shield": pygame.image.load(BASE_DIR / "assets" / "textures" / "dust_shield.png"),
}

FRAMES = {
    "paddles": generate_paddle_frames(),
    "balls": generate_ball_frames(),
    "bricks": generate_brick_frames(TEXTURES["spritesheet"]),
    "hearts": generate_frames(TEXTURES["hearts"], 10, 9),
    "arrows": generate_frames(TEXTURES["arrows"], 24, 24),
    "powerups": generate_powerups_frames(),
    "cannon_left": generate_frames(TEXTURES["cannon_left"], CANNON_WIDTH, CANNON_HEIGHT),
    "cannon_right": generate_frames(TEXTURES["cannon_right"], CANNON_WIDTH, CANNON_HEIGHT),
    "bullet": generate_frames(TEXTURES["bullet"], BULLET_WIDTH_HEIGHT, BULLET_WIDTH_HEIGHT),
    "dust_shield": generate_frames(TEXTURES["dust_shield"], DUST_SHIELD_WIDTH, DUST_SHIELD_HEIGHT),
}

pygame.font.init()

FONTS = {
    "tiny": pygame.font.Font(BASE_DIR / "assets" / "fonts" / "font.ttf", 6),
    "small": pygame.font.Font(BASE_DIR / "assets" / "fonts" / "font.ttf", 8),
    "medium": pygame.font.Font(BASE_DIR / "assets" / "fonts" / "font.ttf", 12),
    "large": pygame.font.Font(BASE_DIR / "assets" / "fonts" / "font.ttf", 24),
}
