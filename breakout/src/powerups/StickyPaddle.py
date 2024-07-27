from typing import TypeVar


import pygame

from gale.factory import Factory

import settings
from src.Ball import Ball
from src.Paddle import Paddle
from src.powerups.PowerUp import PowerUp


class StickyPaddle(PowerUp):
    
    
    def __init__(self, x: int, y: int) -> None:
        super().__init__(x, y, 7)

    def take(self, play_state: TypeVar("PlayState")) -> None:
        play_state.sticky.active = True
        play_state.sticky_timer = 0

        self.active = False

class Sticky:
    def __init__(self) -> None:
        self.active = False