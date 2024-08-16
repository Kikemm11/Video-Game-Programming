from typing import TypeVar, Any

from gale.input_handler import InputData
import pygame
import settings


class Key():
    
    def __init__(self) -> None:
        
        self.x = settings.KEY_X
        self.y = settings.KEY_Y
        self.width = settings.KEY_WIDTH
        self.height = settings.KEY_HEIGHT
        self.vy = 0
        self.texture = settings.TEXTURES["key"]
        self.frame = settings.FRAMES["key"][0]
        self.consumable = False
        self.grabbed = False
        
    
    def get_collision_rect(self) -> pygame.Rect:
        return pygame.Rect(self.x, self.y, self.width, self.height)
    
    def collides(self, another: Any) -> bool:
        return self.get_collision_rect().colliderect(another.get_collision_rect())
    
    def update(self, dt: float) -> None:
        self.y += self.vy * dt
    
    def render(self, surface: pygame.Surface) -> None:
        surface.blit(self.texture, (self.x, self.y), self.frame)