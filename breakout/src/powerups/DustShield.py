import random
from typing import TypeVar, Any, Tuple, Optional

import pygame

from gale.factory import Factory

import settings
from src.Ball import Ball
from src.Paddle import Paddle
from src.powerups.PowerUp import PowerUp



class DustShield(PowerUp):
    """
    Power-up to use a dust shield at the bottom of the window to make the ball bounce
    """

    def __init__(self, x: int, y: int) -> None:
        super().__init__(x, y, 4)
        
    def take(self, play_state: TypeVar("PlayState")) -> None:
        
        play_state.shield.active = True
        play_state.dust_shield_timer = 0
        
        for ball in play_state.balls:
            ball.shield = True
        self.active = False
        
        
class Shield:
    def __init__(self) -> None:
        self.x = 0
        self.y = settings.VIRTUAL_HEIGHT - settings.DUST_SHIELD_HEIGHT
        self.width = settings.DUST_SHIELD_WIDTH
        self.height = settings.DUST_SHIELD_HEIGHT

        self.texture = settings.TEXTURES["dust_shield"]
        self.frame = 0
        self.active = False


    def render(self, surface):
        
        if self.active:
            surface.blit(
                self.texture, (self.x, self.y), settings.FRAMES["dust_shield"][self.frame]
            )
        
        
