#pragma once

#include <src/game_mode/GameMode.hpp>
#include <Settings.hpp>
#include <src/Bird.hpp>
#include <src/World.hpp>

class GameModeNormal: public GameMode 
{   
public: 


    void move_bird_x(std::shared_ptr<Bird> bird, float dt) noexcept override;

    void close_log_pairs(std::shared_ptr<World> world, float dt) noexcept override;

};