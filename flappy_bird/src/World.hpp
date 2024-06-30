/*
    ISPPJ1 2024
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the declaration of the class World.
*/

#pragma once

#include <list>
#include <memory>
#include <random>

#include <SFML/Graphics.hpp>

#include <src/Factory.hpp>
#include <src/LogPair.hpp>
#include <src/PowerUp.hpp>

class World
{
public:
    World(bool _generate_logs = false) noexcept;

    World(const World& world) = delete;

    World& operator = (World) = delete;

    void reset(bool _generate_logs) noexcept;

    bool collides(const sf::FloatRect& rect) const noexcept;

    bool update_scored(const sf::FloatRect& rect) noexcept;

    void update(float dt) noexcept;

    void render(sf::RenderTarget& target) const noexcept;

    void update_closing_logs(float dt) noexcept;

    void update_power_up(float dt, std::shared_ptr<Bird> bird) noexcept;

    void set_power_up_on_screen(bool _set_power_up_on_screen) noexcept;

    int score{0};
private:
    bool generate_logs;

    sf::Sprite background;
    sf::Sprite ground;

    float background_x{0.f};
    float ground_x{0.f};

    Factory<LogPair> log_factory;

    std::shared_ptr<PowerUp> power_up;

    std::list<std::shared_ptr<LogPair>> logs;

    std::mt19937 rng;

    std::random_device rd;
    std::mt19937 spawn_rng{(rd())};

    float logs_spawn_timer{0.f};
    float time_to_close_logs{Settings::TIME_TO_CLOSE_LOGS};
    float logs_close_timer{0.f};
    float logs_closed_timer{0.f};
    float power_up_timer{0.f};
    bool power_up_on_screen{false};
    float last_log_y{0.f}; 
};
