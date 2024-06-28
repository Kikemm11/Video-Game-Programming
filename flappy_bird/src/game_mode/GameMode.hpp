#pragma once

#include <memory>
#include <SFML/Graphics.hpp>

class World;
class Bird;
class Log;
class LogPair;

class GameMode
{
public:

    virtual void move_bird_x(std::shared_ptr<Bird> bird, float dt) noexcept = 0 ;

    virtual void close_log_pairs(std::shared_ptr<World> world, float dt) noexcept = 0 ;
};