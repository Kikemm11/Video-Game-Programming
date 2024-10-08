"""
ISPPJ1 2024
Study Case: Match-3

Author: Alejandro Mujica
alejandro.j.mujic4@gmail.com

This file contains the class PlayState.
"""

from typing import Dict, Any, List

import pygame

from gale.input_handler import InputData
from gale.state import BaseState
from gale.text import render_text
from gale.timer import Timer

import settings

from src.Board import Board


class PlayState(BaseState):
    def enter(self, **enter_params: Dict[str, Any]) -> None:
        self.level = enter_params["level"]
        self.board = enter_params["board"]
        self.score = enter_params["score"]

        # Position in the grid which we are highlighting
        self.board_highlight_i1 = -1
        self.board_highlight_j1 = -1
        self.board_highlight_i2 = -1
        self.board_highlight_j2 = -1

        self.highlighted_tile = False

        self.active = True
        self.tile_clicked = False
        
        self.tile1 = None
        self.tile2 = None
                
        self.shuffle = False

        self.timer = settings.LEVEL_TIME

        self.goal_score = self.level * 1.25 * 1000
    

        # A surface that supports alpha to highlight a selected tile
        self.tile_alpha_surface = pygame.Surface(
            (settings.TILE_SIZE, settings.TILE_SIZE), pygame.SRCALPHA
        )
        pygame.draw.rect(
            self.tile_alpha_surface,
            (255, 255, 255, 96),
            pygame.Rect(0, 0, settings.TILE_SIZE, settings.TILE_SIZE),
            border_radius=7,
        )

        # A surface that supports alpha to draw behind the text.
        self.text_alpha_surface = pygame.Surface((212, 136), pygame.SRCALPHA)
        pygame.draw.rect(
            self.text_alpha_surface, (56, 56, 56, 234), pygame.Rect(0, 0, 212, 136)
        )

        def decrement_timer():
            self.timer -= 1

            # Play warning sound on timer if we get low
            if self.timer <= 5:
                settings.SOUNDS["clock"].play()

        Timer.every(1, decrement_timer)
        
        
        board_tiles = [tile for row in self.board.tiles for tile in row]
        possible_matches = self.board.calculate_board_matches(board_tiles)
        
        if not possible_matches:
            self.shuffle = True

    def update(self, _: float) -> None:
        if self.timer <= 0:
            Timer.clear()
            settings.SOUNDS["game-over"].play()
            self.state_machine.change("game-over", score=self.score)

        if self.score >= self.goal_score:
            Timer.clear()
            settings.SOUNDS["next-level"].play()
            self.state_machine.change("begin", level=self.level + 1, score=self.score)
    
        if self.shuffle:
            self.shuffle = False
            settings.SOUNDS["shuffle"].stop()
            settings.SOUNDS["shuffle"].play()
            self.board = Board(settings.VIRTUAL_WIDTH - 272, 16)
            
              

    def render(self, surface: pygame.Surface) -> None:
        
        self.board.render(surface)
        
        
        if self.highlighted_tile:
            x = self.highlighted_j1 * settings.TILE_SIZE + self.board.x
            y = self.highlighted_i1 * settings.TILE_SIZE + self.board.y
            surface.blit(self.tile_alpha_surface, (x, y))

        surface.blit(self.text_alpha_surface, (16, 16))
        render_text(
            surface,
            f"Level: {self.level}",
            settings.FONTS["medium"],
            30,
            24,
            (99, 155, 255),
            shadowed=True,
        )
        render_text(
            surface,
            f"Score: {self.score}",
            settings.FONTS["medium"],
            30,
            52,
            (99, 155, 255),
            shadowed=True,
        )
        render_text(
            surface,
            f"Goal: {self.goal_score}",
            settings.FONTS["medium"],
            30,
            80,
            (99, 155, 255),
            shadowed=True,
        )
        render_text(
            surface,
            f"Timer: {self.timer}",
            settings.FONTS["medium"],
            30,
            108,
            (99, 155, 255),
            shadowed=True,
        )

    def on_input(self, input_id: str, input_data: InputData) -> None:
        
        if not self.active:
            return

        if input_id in ["mouse_motion_up","mouse_motion_down","mouse_motion_left", "mouse_motion_right"] and self.tile_clicked:
            
            pos_x, pos_y = input_data.position
            pos_x = pos_x * settings.VIRTUAL_WIDTH // settings.WINDOW_WIDTH
            pos_y = pos_y * settings.VIRTUAL_HEIGHT // settings.WINDOW_HEIGHT
            i = (pos_y - self.board.y) // settings.TILE_SIZE
            j = (pos_x - self.board.x) // settings.TILE_SIZE
            
            if 0 <= i < settings.BOARD_HEIGHT and 0 <= j < settings.BOARD_WIDTH:
                
                if pos_x != self.tile1.x and pos_y != self.tile1.y:
                    
                    self.tile2 = self.board.tiles[i][j]
                    
                    di = abs(self.tile2.i - self.tile1.i)
                    dj = abs(self.tile2.j - self.tile1.j)
                    
                    if di <= 1 and dj <= 1 and di != dj:
                    
                        self.active = False
                        
                        def arrive():
                                
                            (
                                self.board.tiles[self.tile1.i][self.tile1.j],
                                self.board.tiles[self.tile2.i][self.tile2.j],
                            ) = (
                                self.board.tiles[self.tile2.i][self.tile2.j],
                                self.board.tiles[self.tile1.i][self.tile1.j],
                            )
                            self.tile1.i, self.tile1.j, self.tile2.i, self.tile2.j = (
                                self.tile2.i,
                                self.tile2.j,
                                self.tile1.i,
                                self.tile1.j,
                            )
                            self.__calculate_matches([self.tile1, self.tile2])
                        
                
                        Timer.tween(
                            0.75,
                            [
                                (self.tile1, {"x": self.tile2.x, "y": self.tile2.y}),
                                (self.tile2, {"x": self.tile1.x, "y": self.tile1.y}),

                            ],
                            on_finish=arrive,
                        )
                        
                        self.tile_clicked = False
                        self.highlighted_tile = False
            else:
                self.highlighted_tile = False
                    
                    

        if input_id == "click" and input_data.pressed:
          
            pos_x, pos_y = input_data.position
            pos_x = pos_x * settings.VIRTUAL_WIDTH // settings.WINDOW_WIDTH
            pos_y = pos_y * settings.VIRTUAL_HEIGHT // settings.WINDOW_HEIGHT
            i = (pos_y - self.board.y) // settings.TILE_SIZE
            j = (pos_x - self.board.x) // settings.TILE_SIZE
            if 0 <= i < settings.BOARD_HEIGHT and 0 <= j < settings.BOARD_WIDTH:
                if not self.highlighted_tile:
                    self.highlighted_tile = True
                    self.tile_clicked = True
                    self.highlighted_i1 = i
                    self.highlighted_j1 = j
                    
                    self.tile1 = self.board.tiles[self.highlighted_i1][
                            self.highlighted_j1
                        ]
                    self.tile1_x = self.tile1.x
                    self.tile1_y = self.tile1.y
                    
                    
                    if self.tile1.match_4:
                        
                        horizontal_neighbors = []
                        vertical_neighbors = []
                        
                        for j in range(0,8):
                            if j != self.tile1.j:
                                horizontal_neighbors.append(self.board.tiles[self.tile1.i][j])
                                self.board.tiles[self.tile1.i][j].variety = 1
                        
                        for i in range(0,8):
                            if i != self.tile1.i:
                                vertical_neighbors.append(self.board.tiles[i][self.tile1.j])
                                self.board.tiles[i][self.tile1.j].variety = 1
                                
                        self.board.matches.append(horizontal_neighbors)
                        self.board.matches.append(vertical_neighbors)
                        self.board.matches.append([self.tile1])
                        
                        settings.SOUNDS["match_4"].stop()
                        settings.SOUNDS["match_4"].play()
                        
                        for match in self.board.matches:
                            self.score += len(match) * 2
                        
                        self.board.remove_matches()
                        
                        falling_tiles = self.board.get_falling_tiles()

                        Timer.tween(
                            0.25,
                            falling_tiles,
                            on_finish=lambda: self.__calculate_matches(
                                [item[0] for item in falling_tiles],
                                falling_tiles=True
                            ),
                        )
                        
                        self.highlighted_tile = False
                        self.tile_clicked = False
                        
                         
                    if self.tile1.match_5:
                        
                        same_color = []
                        board_tiles = [tile for row in self.board.tiles for tile in row]
                        
                        for tile in board_tiles:
                            if tile.color == self.tile1.color:
                                same_color.append(tile)
                                
                        self.board.matches.append(same_color)
                        
                        settings.SOUNDS["match_5"].stop()
                        settings.SOUNDS["match_5"].play()
                        
                        for match in self.board.matches:
                            self.score += len(match) * 2
                            
                        
                        self.board.remove_matches()
                        
                        falling_tiles = self.board.get_falling_tiles()

                        Timer.tween(
                            0.25,
                            falling_tiles,
                            on_finish=lambda: self.__calculate_matches(
                                [item[0] for item in falling_tiles],
                                falling_tiles=True
                            ),
                        )
                        
                        self.highlighted_tile = False
                        self.tile_clicked = False
                              
                else:
                    self.highlighted_tile = False
                    
                
            
            
                    
                    

    def __calculate_matches(self, tiles: List, **params: Dict[str, Any]) -> None:
        matches = self.board.calculate_matches_for(tiles)

        if matches is None:
            self.active = True
            
            if not params.get('falling_tiles'):
            
                settings.SOUNDS["wrong"].stop()
                settings.SOUNDS["wrong"].play()
            
            def reverse():
                (
                    self.board.tiles[self.tile1.i][self.tile1.j],
                    self.board.tiles[self.tile2.i][self.tile2.j],
                ) = (
                    self.board.tiles[self.tile2.i][self.tile2.j],
                    self.board.tiles[self.tile1.i][self.tile1.j],
                )
                self.tile1.i, self.tile1.j, self.tile2.i, self.tile2.j = (
                    self.tile2.i,
                    self.tile2.j,
                    self.tile1.i,
                    self.tile1.j,
                )
                
                
            if not params.get('falling_tiles'):
            
                Timer.tween(
                    0.25,
                    [
                        (self.tile1, {"x": self.tile2.x, "y": self.tile2.y}),
                        (self.tile2, {"x": self.tile1.x, "y": self.tile1.y}),
                    ],
                    on_finish=reverse,
                )
                
            return

        settings.SOUNDS["match"].stop()
        settings.SOUNDS["match"].play()

        for match in matches:
            self.score += len(match) * 50
            
            if len(match) == 4:
                self.tile1.match_4 = True
                self.tile1.variety = 1
                for tile in match:
                    if tile == self.tile1:
                        match.remove(tile)
                        
            if len(match) >= 5:
                self.tile1.match_5 = True
                self.tile1.variety = 5
                for tile in match:
                    if tile == self.tile1:
                        match.remove(tile)
            
        self.board.remove_matches()

        falling_tiles = self.board.get_falling_tiles()

        Timer.tween(
            0.25,
            falling_tiles,
            on_finish=lambda: self.__calculate_matches(
                [item[0] for item in falling_tiles],
                falling_tiles=True
            ),
        )
          
        board_tiles = [tile for row in self.board.tiles for tile in row]
        possible_matches = self.board.calculate_board_matches(board_tiles)
        
        if not possible_matches:
            self.shuffle = True
        