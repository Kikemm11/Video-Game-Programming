/*
    ISPPJ1 2024
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the definition of the class LogPair.
*/

#include <Settings.hpp>
#include <src/LogPair.hpp>

float getRandomLogsGap() {
    static std::random_device rd;  
    static std::mt19937 gen(rd());

    static std::uniform_real_distribution<float> dist(Settings::MIN_LOGS_GAP, Settings::MAX_LOGS_GAP);

    return dist(gen);
}


LogPair::LogPair(float _x, float _y) noexcept
    : x{_x}, y{_y},
      top{x, y + Settings::LOG_HEIGHT, true},
      bottom{x, y + getRandomLogsGap() + Settings::LOG_HEIGHT, false}
{

}

bool LogPair::collides(const sf::FloatRect& rect) const noexcept
{
    return top.get_collision_rect().intersects(rect) || bottom.get_collision_rect().intersects(rect);
}

void LogPair::update(float dt) noexcept
{
    x += -Settings::MAIN_SCROLL_SPEED * dt;

    top.update(x);
    bottom.update(x);
}

void LogPair::render(sf::RenderTarget& target) const noexcept
{
    top.render(target);
    bottom.render(target);
}

bool LogPair::is_out_of_game() const noexcept
{
    return x < -Settings::LOG_WIDTH;
}

bool LogPair::update_scored(const sf::FloatRect& rect) noexcept
{
    if (scored)
    {
        return false;
    }

    if (rect.left > x + Settings::LOG_WIDTH)
    {
        scored = true;
        return true;
    }

    return false;
}

void LogPair::reset(float _x, float _y) noexcept
{
    x = _x;
    y = _y;
    scored = false;
}

void LogPair::set_close() noexcept
{
    close = true;
}

bool LogPair::get_close() noexcept
{
    return close;
}

void LogPair::close_gap() noexcept
{
    top.set_y(y + Settings::LOG_HEIGHT + Settings::LOGS_GAP/2);
    bottom.set_y(y + Settings::LOGS_GAP + Settings::LOG_HEIGHT - Settings::LOGS_GAP/2);
    Settings::sounds["crash"].play();
    currently_closed = true;
}

void LogPair::open_gap() noexcept
{
    top.set_y(y + Settings::LOG_HEIGHT);
    bottom.set_y(y + Settings::LOGS_GAP + Settings::LOG_HEIGHT);
    currently_closed = false;
}

bool LogPair::get_currently_closed() noexcept
{
    return currently_closed;
}
