/*
    ISPPJ1 2024
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the declaration of the class Bird.
*/

#pragma once

#include <SFML/Graphics.hpp>

class Bird
{
public:
    Bird(float _x, float _y, float w, float h) noexcept;

    Bird(const Bird&) = delete;

    Bird& operator = (Bird) = delete;

    void reset(float _x, float _y) noexcept;

    sf::FloatRect get_collision_rect() const noexcept;

    void jump() noexcept;

    void move(float dt) noexcept;

    void set_vx_direction(int direction) noexcept;

    void set_ghost_bird(bool _ghost_bird) noexcept;

    void set_sprite(const sf::Texture& _sprite) noexcept;

    bool get_ghost_bird() noexcept;

    void update(float dt) noexcept;

    void render(sf::RenderTarget& target) const noexcept;

private:
    float x;
    float y;
    float width;
    float height;
    float vy;
    float vx;
    sf::Sprite sprite;
    bool jumping{false};
    bool ghost_bird{false};
};
