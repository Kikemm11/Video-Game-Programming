/*
    ISPPJ1 2024
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the declaration of the class LogPair.
*/

#pragma once

#include <src/Bird.hpp>
#include <src/Log.hpp>

class LogPair
{
public:
    LogPair(float _x, float _y) noexcept;

    bool collides(const sf::FloatRect& rect) const noexcept;

    void update(float dt) noexcept;

    void render(sf::RenderTarget& target) const noexcept;

    bool is_out_of_game() const noexcept;

    bool update_scored(const sf::FloatRect& rect) noexcept;

    void reset(float _x, float _y) noexcept;

    void set_close() noexcept;

    bool get_close() noexcept;

    void close_gap() noexcept;

    void open_gap() noexcept;

    bool get_currently_closed() noexcept;

private:
    float x;
    float y;
    Log top;
    Log bottom;
    bool close{false};
    bool currently_closed{false};
    bool scored{false};
};