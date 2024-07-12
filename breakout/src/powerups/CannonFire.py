import random
from typing import TypeVar, Any, Tuple, Optional

import pygame

from gale.factory import Factory

import settings
from src.Ball import Ball
from src.Paddle import Paddle
from src.powerups.PowerUp import PowerUp



class CannonFire(PowerUp):
    """
    Power-up to shot fire balls from two cannons at both sides of the paddle.
    """

    def __init__(self, x: int, y: int) -> None:
        super().__init__(x, y, 3)
        
    def take(self, play_state: TypeVar("PlayState")) -> None:
        paddle = play_state.paddle
        paddle.get_cannons()
        play_state.cannon_fire_timer = 0
        self.active = False
        
        
class Bullet:
    def __init__(self, x: int, y: int) -> None:
        self.x = x
        self.y = y
        self.width = settings.BULLET_WIDTH_HEIGHT
        self.height = settings.BULLET_WIDTH_HEIGHT
        self.vy = settings.BULLET_SPEED

        self.texture = settings.TEXTURES["bullet"]
        self.frame = 0
        self.active = True

    def get_collision_rect(self) -> pygame.Rect:
        return pygame.Rect(self.x, self.y, self.width, self.height)

    
    def collides(self, another: Any) -> bool:
        return self.get_collision_rect().colliderect(another.get_collision_rect())


    def update(self, dt: float) -> None:
        
        if self.active:
            self.y += self.vy * dt

    def render(self, surface):
        
        if self.active:
            surface.blit(
                self.texture, (self.x, self.y), settings.FRAMES["bullet"][self.frame]
            )
        
        
class BulletPair:
    def __init__(self, paddle: Paddle) -> None:
        self.left_bullet = Bullet(paddle.x - settings.BULLET_WIDTH_HEIGHT, paddle.y - settings.BULLET_WIDTH_HEIGHT)
        self.right_bullet = Bullet(paddle.x + paddle.width, paddle.y - settings.BULLET_WIDTH_HEIGHT)
        settings.SOUNDS["shot"].play()
        
        
    def solve_world_boundaries(self) -> None:
        
        l_r = self.left_bullet.get_collision_rect()
        r_r = self.right_bullet.get_collision_rect()
        
        if l_r.bottom <= 0:
            self.left_bullet.active = False
        
        if r_r.bottom <= 0:
            self.right_bullet.active = False

    def update(self, dt: float) -> None:
        
            self.left_bullet.update(dt)
            self.right_bullet.update(dt)

    def render(self, surface):
        
            self.left_bullet.render(surface)
            self.right_bullet.render(surface)