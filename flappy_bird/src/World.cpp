/*
    ISPPJ1 2024
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the definition of the class World.
*/

#include <Settings.hpp>
#include <src/World.hpp>

#include <random>

World::World(bool _generate_logs) noexcept
    : generate_logs{_generate_logs}, background{Settings::textures["background"]}, ground{Settings::textures["ground"]},
      logs{}, rng{std::default_random_engine{}()}
{
    ground.setPosition(0, Settings::VIRTUAL_HEIGHT - Settings::GROUND_HEIGHT);
    std::uniform_int_distribution<int> dist(0, 80);
    last_log_y = -Settings::LOG_HEIGHT + dist(rng) + 20;
    
}

void World::reset(bool _generate_logs) noexcept
{
    generate_logs = _generate_logs;
    for (auto log_pair: logs)
    {
        log_factory.remove(log_pair);
    }
    logs.clear();
}

bool World::collides(const sf::FloatRect& rect) const noexcept
{
    if (rect.top + rect.height >= Settings::VIRTUAL_HEIGHT)
    {
        return true;
    }
    
    for (auto log_pair: logs)
    {
        if (log_pair->collides(rect))
        {
            return true;
        }
    }

    return false;
}

bool World::update_scored(const sf::FloatRect& rect) noexcept
{
    for (auto log_pair: logs)
    {
        if (log_pair->update_scored(rect))
        {
            return true;
        }
    }

    return false;
}

float get_Random_Logs_Space() {
    static std::default_random_engine rd;  
    static std::mt19937 gen(rd());

    static std::uniform_real_distribution<float> dist(Settings::MIN_TIME_TO_SPAWN_LOGS, Settings::MAX_TIME_TO_SPAWN_LOGS);

    return dist(gen);
}

void World::update(float dt) noexcept
{
    if (generate_logs)
    {
        logs_spawn_timer += dt;

        logs_close_timer += dt;

        if (logs_spawn_timer >= get_Random_Logs_Space())
        {
            logs_spawn_timer = 0.f;

            std::uniform_int_distribution<int> dist{-20, 20};
            float y = std::max(-Settings::LOG_HEIGHT + 10, std::min(last_log_y + dist(rng), Settings::VIRTUAL_HEIGHT + 90 - Settings::LOG_HEIGHT));

            last_log_y = y;

            auto log_pair = log_factory.create(Settings::VIRTUAL_WIDTH, y);


            if (logs_close_timer >= time_to_close_logs)
            {
                log_pair->set_close();

                std::uniform_int_distribution<int> dist(1, 15);
                time_to_close_logs = dist(spawn_rng);
                logs_close_timer = 0.f;
            }
    

            logs.push_back(log_pair);
        }
    }

    background_x += -Settings::BACK_SCROLL_SPEED * dt;

    if (background_x <= -Settings::BACKGROUND_LOOPING_POINT)
    {
        background_x = 0;
    }

    background.setPosition(background_x, 0);

    ground_x += -Settings::MAIN_SCROLL_SPEED * dt;

    if (ground_x <= -Settings::VIRTUAL_WIDTH)
    {
        ground_x = 0;
    }

    ground.setPosition(ground_x, Settings::VIRTUAL_HEIGHT - Settings::GROUND_HEIGHT);

    for (auto it = logs.begin(); it != logs.end(); )
    {
        if ((*it)->is_out_of_game())
        {
            auto log_pair = *it;
            log_factory.remove(log_pair);
            it = logs.erase(it);
            
        }
        else
        {
            (*it)->update(dt);
            ++it;
        }
    }
}

void World::render(sf::RenderTarget& target) const noexcept
{
    target.draw(background);

    for (const auto& log_pair: logs)
    {
        log_pair->render(target);
    }

    target.draw(ground);

    if (power_up_on_screen)
    {
        power_up->render(target);
    }
}

void World::update_closing_logs(float dt) noexcept
{
    logs_closed_timer += dt;
    
    if (!logs.empty())
    {
        for (auto it = logs.begin(); it != logs.end(); ++it)
        { 

        if ((*it)->get_close() && !(*it)->get_currently_closed() && logs_closed_timer >= Settings::TIME_CLOSED_LOGS)
        {
            (*it)->close_gap();
            logs_closed_timer = 0.f;
            
        }
        else if((*it)->get_close() && logs_closed_timer >= Settings::TIME_CLOSED_LOGS)
        {
            (*it)->open_gap(); 
            logs_closed_timer = 0.f;    
        }
        }

    }
}


 void World::set_power_up_on_screen(bool _set_power_up_on_screen) noexcept
 {
    power_up_on_screen = _set_power_up_on_screen;
 }


void World::update_power_up(float dt, std::shared_ptr<Bird> bird) noexcept
{
    power_up_timer += dt;

    if (power_up_timer >= Settings::TIME_TO_POWER_UP && !bird->get_ghost_bird())
    {
        power_up = std::make_shared<PowerUp>(Settings::VIRTUAL_WIDTH, Settings::VIRTUAL_HEIGHT/2);
        power_up_timer = 0.f;
        power_up_on_screen = true;
    }
    
    if (power_up_on_screen)
    {
       power_up->update(dt, bird);
    }
           
}
