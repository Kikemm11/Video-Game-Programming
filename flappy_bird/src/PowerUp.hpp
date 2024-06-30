#pragma once

#include <SFML/Graphics.hpp>

#include <src/Bird.hpp>

class PowerUp
{
public:

    PowerUp(float _x, float _y) noexcept;

    sf::FloatRect get_collision_rect() const noexcept;

    void update(float dt, std::shared_ptr<Bird> bird) noexcept;

    void render(sf::RenderTarget& target) const noexcept;


private:
    float x;
    float y;
    float width;
    float height;
    float vy;
    float ghost_bird_timer{0.f};
    bool powerup_on{false};
    int ghost_bird_counter;
    sf::Sprite sprite;
};