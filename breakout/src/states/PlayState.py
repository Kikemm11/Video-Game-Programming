"""
ISPPJ1 2024
Study Case: Breakout

Author: Alejandro Mujica
alejandro.j.mujic4@gmail.com

This file contains the class to define the Play state.
"""

import random

import pygame

from gale.factory import AbstractFactory
from gale.state import BaseState
from gale.input_handler import InputData
from gale.text import render_text
from random import randint


import settings
import src.powerups

from src.powerups.CannonFire import CannonFire, Bullet, BulletPair
from src.powerups.DustShield import Shield
from src.powerups.StickyPaddle import Sticky


class PlayState(BaseState):
    def enter(self, **params: dict):
        self.level = params["level"]
        self.score = params["score"]
        self.lives = params["lives"]
        self.paddle = params["paddle"]
        self.balls = params["balls"]
        self.brickset = params["brickset"]
        self.live_factor = params["live_factor"]
        self.points_to_next_live = params["points_to_next_live"]
        self.stuck_balls = []
        self.points_to_next_grow_up = (
            self.score
            + settings.PADDLE_GROW_UP_POINTS * (self.paddle.size + 1) * self.level
        )
        self.powerups = params.get("powerups", [])
        
        self.bullets = params.get("bullets", [])
        self.cannon_fire_timer = 0
        
        self.shield = params.get("shield", Shield())
        self.dust_shield_timer = 0

        self.sticky = params.get("sticky", Sticky())
        self.sticky_timer = 0

        if not params.get("resume", False):
            self.balls[0].vx = random.randint(-80, 80)
            self.balls[0].vy = random.randint(-170, -100)
            settings.SOUNDS["paddle_hit"].play()

        self.powerups_abstract_factory = AbstractFactory("src.powerups")

    def update(self, dt: float) -> None:
        self.paddle.update(dt)
        self.cannon_fire_timer += dt
        self.dust_shield_timer += dt
        self.sticky_timer += dt

        for boll in self.stuck_balls:
            boll[0].x = self.paddle.x - boll[1] 
        
        
        for ball in self.balls:
            ball.update(dt)
            ball.solve_world_boundaries()

            # Check collision with the paddle
            if ball.collides(self.paddle):
                
                if self.sticky.active:
                    
                    self.stuck_balls.append([ball, (self.paddle.x - ball.x)])
                    
                    for boll in self.stuck_balls:
                        boll[0].vx = 0
                        boll[0].vy = 0
                    
                else:
                    settings.SOUNDS["paddle_hit"].stop()
                    settings.SOUNDS["paddle_hit"].play()
                    ball.rebound(self.paddle)
                    ball.push(self.paddle)

            # Check collision with brickset
            if not ball.collides(self.brickset):
                continue

            brick = self.brickset.get_colliding_brick(ball.get_collision_rect())

            if brick is None:
                continue

            brick.hit()
            self.score += brick.score()
            ball.rebound(brick)

            # Check earn life
            if self.score >= self.points_to_next_live:
                settings.SOUNDS["life"].play()
                self.lives = min(3, self.lives + 1)
                self.live_factor += 0.5
                self.points_to_next_live += settings.LIVE_POINTS_BASE * self.live_factor

            # Check growing up of the paddle
            if self.score >= self.points_to_next_grow_up:
                settings.SOUNDS["grow_up"].play()
                self.points_to_next_grow_up += (
                    settings.PADDLE_GROW_UP_POINTS * (self.paddle.size + 1) * self.level
                )
                self.paddle.inc_size()

            # Chance to generate two more balls
            if random.random() < 0.1:
                r = brick.get_collision_rect()
                self.powerups.append(
                    self.powerups_abstract_factory.get_factory("TwoMoreBall").create(
                        r.centerx - 8, r.centery - 8
                    )
                )
                
            # Chance to generate cannon fire
                if random.random() < 0.075:
                    r = brick.get_collision_rect()
                    self.powerups.append(
                        self.powerups_abstract_factory.get_factory("CannonFire").create(
                            r.centerx - 8, r.centery - 8
                        )
                    )
                    
            # Chance to generate dust shield
            if random.random() < 0.075:
                r = brick.get_collision_rect()
                self.powerups.append(
                    self.powerups_abstract_factory.get_factory("DustShield").create(
                        r.centerx - 8, r.centery - 8
                    )
                )

            if random.random() < 0.50:
                r = brick.get_collision_rect()
                self.powerups.append(
                    self.powerups_abstract_factory.get_factory("StickyPaddle").create(
                        r.centerx - 8, r.centery - 8
                    )
                )

        # Removing all balls that are not in play
        self.balls = [ball for ball in self.balls if ball.active]

        self.brickset.update(dt)

        if not self.balls:
            self.lives -= 1
            if self.lives == 0:
                self.state_machine.change("game_over", score=self.score)
            else:
                self.paddle.dec_size()
                self.state_machine.change(
                    "serve",
                    level=self.level,
                    score=self.score,
                    lives=self.lives,
                    paddle=self.paddle,
                    brickset=self.brickset,
                    points_to_next_live=self.points_to_next_live,
                    live_factor=self.live_factor,
                )

        # Update powerups
        for powerup in self.powerups:
            powerup.update(dt)

            if powerup.collides(self.paddle):
                powerup.take(self)

        # Remove powerups that are not in play
        self.powerups = [p for p in self.powerups if p.active]

        # Check victory
        if self.brickset.size == 1 and next(
            (True for _, b in self.brickset.bricks.items() if b.broken), False
        ):
            self.state_machine.change(
                "victory",
                lives=self.lives,
                level=self.level,
                score=self.score,
                paddle=self.paddle,
                balls=self.balls,
                points_to_next_live=self.points_to_next_live,
                live_factor=self.live_factor,
            )
        

        for bullet in self.bullets:
            
            bullet.update(dt)
            bullet.solve_world_boundaries()
            
            # Check collision with brickset
            
            if not bullet.left_bullet.collides(self.brickset) and bullet.right_bullet.collides(self.brickset) :
                continue
            
            bricks = []
            
            if bullet.left_bullet.collides(self.brickset) and bullet.left_bullet.active:
                brick = self.brickset.get_colliding_brick(bullet.left_bullet.get_collision_rect())
                bricks.append(brick)
                bullet.left_bullet.active = brick == None 
                
            if bullet.right_bullet.collides(self.brickset) and bullet.right_bullet.active:
                brick = self.brickset.get_colliding_brick(bullet.right_bullet.get_collision_rect())
                bricks.append(brick)
                bullet.right_bullet.active = brick == None 

            for brick in bricks:
                
                if brick is None:
                    continue
                    
                brick.hit()
                self.score += brick.score()
                ball.rebound(brick)

                # Check earn life
                if self.score >= self.points_to_next_live:
                    settings.SOUNDS["life"].play()
                    self.lives = min(3, self.lives + 1)
                    self.live_factor += 0.5
                    self.points_to_next_live += settings.LIVE_POINTS_BASE * self.live_factor

                # Check growing up of the paddle
                if self.score >= self.points_to_next_grow_up:
                    settings.SOUNDS["grow_up"].play()
                    self.points_to_next_grow_up += (
                        settings.PADDLE_GROW_UP_POINTS * (self.paddle.size + 1) * self.level
                    )
                    self.paddle.inc_size()

                # Chance to generate two more balls
                if random.random() < 0.1:
                    r = brick.get_collision_rect()
                    self.powerups.append(
                        self.powerups_abstract_factory.get_factory("TwoMoreBall").create(
                            r.centerx - 8, r.centery - 8
                        )
                    )
                
                # Chance to generate cannon fire
                if random.random() < 0.075:
                    r = brick.get_collision_rect()
                    self.powerups.append(
                        self.powerups_abstract_factory.get_factory("CannonFire").create(
                            r.centerx - 8, r.centery - 8
                        )
                    )
                    
                # Chance to generate dust shield
                if random.random() < 0.075:
                    r = brick.get_collision_rect()
                    self.powerups.append(
                        self.powerups_abstract_factory.get_factory("DustShield").create(
                            r.centerx - 8, r.centery - 8
                        )
                    )

                # Chance to generate sticky paddle
                if random.random() < 0.50:
                    r = brick.get_collision_rect()
                    self.powerups.append(
                        self.powerups_abstract_factory.get_factory("StickyPaddle").create(
                            r.centerx - 8, r.centery - 8
                        )
                    )

                    
                    
        self.bullets= [bullet for bullet in self.bullets if bullet.left_bullet.active or bullet.right_bullet.active]           
                    
        if self.paddle.cannons and self.cannon_fire_timer >= settings.CANNON_FIRE:
            self.paddle.leave_cannons()
            
        if self.shield.active and self.dust_shield_timer >= settings.DUST_SHIELD:
            
            self.shield.active = False
            
            for ball in self.balls:
                ball.shield = False

        if self.sticky.active and self.sticky_timer >= settings.STICKY_TIME:
            for boll in self.stuck_balls:
                boll[0].vx = randint(-80, 80)
                boll[0].vy = randint(-170, -100)
                #boll[0].x = self.paddle.x 
            self.stuck_balls = []
            self.sticky.active = False
            

    def render(self, surface: pygame.Surface) -> None:
        heart_x = settings.VIRTUAL_WIDTH - 120

        i = 0
        # Draw filled hearts
        while i < self.lives:
            surface.blit(
                settings.TEXTURES["hearts"], (heart_x, 5), settings.FRAMES["hearts"][0]
            )
            heart_x += 11
            i += 1

        # Draw empty hearts
        while i < 3:
            surface.blit(
                settings.TEXTURES["hearts"], (heart_x, 5), settings.FRAMES["hearts"][1]
            )
            heart_x += 11
            i += 1

        render_text(
            surface,
            f"Score: {self.score}",
            settings.FONTS["tiny"],
            settings.VIRTUAL_WIDTH - 80,
            5,
            (255, 255, 255),
        )

        self.brickset.render(surface)
        
        self.shield.render(surface)

        self.paddle.render(surface)
        
        for bullet in self.bullets:
            bullet.render(surface)
            
        

        for ball in self.balls:
            ball.render(surface)

        for powerup in self.powerups:
            powerup.render(surface)

    def on_input(self, input_id: str, input_data: InputData) -> None:
        if input_id == "move_left":
            if input_data.pressed:
                self.paddle.vx = -settings.PADDLE_SPEED
            elif input_data.released and self.paddle.vx < 0:
                self.paddle.vx = 0
        elif input_id == "move_right":
            if input_data.pressed:
                self.paddle.vx = settings.PADDLE_SPEED
            elif input_data.released and self.paddle.vx > 0:
                self.paddle.vx = 0
        elif input_id == "pause" and input_data.pressed:
            self.state_machine.change(
                "pause",
                level=self.level,
                score=self.score,
                lives=self.lives,
                paddle=self.paddle,
                balls=self.balls,
                brickset=self.brickset,
                points_to_next_live=self.points_to_next_live,
                live_factor=self.live_factor,
                powerups=self.powerups,
                bullets=self.bullets,
                shield=self.shield,
                sticky = self.sticky
            )
        elif input_id == "shot" and self.paddle.cannons:
            if self.bullets == []:
                self.bullets.append(BulletPair(self.paddle))
        elif input_id == "shot" and self.sticky.active:
            if self.stuck_balls:
                for ball in self.stuck_balls:
                    ball[0].vx = randint(-80, 80)
                    ball[0].vy = randint(-170, -100)
                self.stuck_balls = []
                self.sticky.active = False
            
            
