#include <src/game_mode/GameModeHard.hpp>
#include <Settings.hpp>

void GameModeHard::move_bird_x(std::shared_ptr<Bird> bird, float dt) noexcept
{
    bird->move(dt);
}

void GameModeHard::close_log_pairs(std::shared_ptr<World> world, float dt) noexcept
{
    world->update_closing_logs(dt);
}

void GameModeHard::update_power_up(std::shared_ptr<World> world, std::shared_ptr<Bird> bird, float dt) noexcept
{
    world->update_power_up(dt, bird);
}
