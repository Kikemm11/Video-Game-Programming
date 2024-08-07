"""
ISPPJ1 2024
Study Case: Breakout

Author: Alejandro Mujica
alejandro.j.mujic4@gmail.com

This file contains the class Paddle.
"""

import pygame

import settings


class Paddle:
    def __init__(self, x: int, y: int) -> None:
        self.x = x
        self.y = y
        self.width = 64
        self.height = 16

        # By default, the blue paddle
        self.skin = 0

        # By default, the 64-pixels-width paddle.
        self.size = 1

        self.texture = settings.TEXTURES["spritesheet"]
        self.frames = settings.FRAMES["paddles"]

        # The paddle only move horizontally
        self.vx = 0
        
        # Active canons
        self.cannons = False

    def resize(self, size: int) -> None:
        self.size = size
        self.width = (self.size + 1) * 32

    def dec_size(self):
        self.resize(max(0, self.size - 1))

    def inc_size(self):
        self.resize(min(3, self.size + 1))

    def get_collision_rect(self) -> pygame.Rect:
        
        if self.cannons:
            return pygame.Rect(self.x - settings.CANNON_WIDTH, self.y, self.width + (2*settings.CANNON_WIDTH), self.height)
    
        return pygame.Rect(self.x, self.y, self.width, self.height)
      
    def get_cannons(self) -> None:
        self.cannons = True
    
    def leave_cannons(self) -> None:
        self.cannons = False
        
    def update(self, dt: float) -> None:
        next_x = self.x + self.vx * dt

        if self.vx < 0:
            self.x = max(0, next_x)
        else:
            self.x = min(settings.VIRTUAL_WIDTH - self.width, next_x)

    def render(self, surface: pygame.Surface) -> None:
        surface.blit(self.texture, (self.x, self.y), self.frames[self.skin][self.size])
        
        if self.cannons:
            surface.blit(settings.TEXTURES["cannon_left"], (self.x - settings.CANNON_WIDTH, self.y-4), settings.FRAMES["cannon_left"][0])
            surface.blit(settings.TEXTURES["cannon_right"], (self.x + self.width, self.y-4), settings.FRAMES["cannon_right"][0])
