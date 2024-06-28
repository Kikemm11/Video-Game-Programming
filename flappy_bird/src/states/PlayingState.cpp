/*
    ISPPJ1 2024
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the definition of the class PlayingBaseState.
*/

#include <Settings.hpp>
#include <src/text_utilities.hpp>
#include <src/states/StateMachine.hpp>
#include <src/game_mode/GameMode.hpp>
#include <src/game_mode/GameModeNormal.hpp>
#include <src/game_mode/GameModeHard.hpp>
#include <src/states/PlayingState.hpp>

PlayingState::PlayingState(StateMachine* sm) noexcept
    : BaseState{sm}
{

}

void PlayingState::enter(std::shared_ptr<World> _world, std::shared_ptr<Bird> _bird, std::string from_state, std::shared_ptr<GameMode> _game_mode) noexcept
{
    world = _world;
    game_mode = _game_mode;
    
    if (from_state != "pause")
    {
        world->reset(true);
    }
    
    if (from_state == "pause")
    {
        score = world->score;
    }
  
    if (_bird == nullptr)
    {
        bird = std::make_shared<Bird>(
            Settings::VIRTUAL_WIDTH / 2 - Settings::BIRD_WIDTH / 2, Settings::VIRTUAL_HEIGHT / 2 - Settings::BIRD_HEIGHT / 2,
            Settings::BIRD_WIDTH, Settings::BIRD_HEIGHT
        );
    }
    else
    {
        bird = _bird;

        if (from_state != "pause")
    {
        bird->reset(Settings::VIRTUAL_WIDTH / 2 - Settings::BIRD_WIDTH / 2, Settings::VIRTUAL_HEIGHT / 2 - Settings::BIRD_HEIGHT / 2);
    }
        
    }
}

void PlayingState::handle_inputs(const sf::Event& event) noexcept
{
    if (event.type == sf::Event::MouseButtonPressed && event.mouseButton.button == sf::Mouse::Left)
    {
        bird->jump();
    }
    if (event.key.code == sf::Keyboard::D)
    {
        bird->set_vx_direction(1.f);
    }
    if (event.key.code == sf::Keyboard::S)
    {
        bird->set_vx_direction(-1.f);
    }
    if (event.key.code == sf::Keyboard::Space)
    {
        state_machine->change_state("pause", "playing", world, bird, game_mode);
        return;
    }
    
}

void PlayingState::update(float dt) noexcept
{
    bird->update(dt);
    world->update(dt);

    game_mode->move_bird_x(bird, dt);
    game_mode->close_log_pairs(world, dt);

    if (world->collides(bird->get_collision_rect()))
    {
        Settings::sounds["explosion"].play();
        Settings::sounds["hurt"].play();
        state_machine->change_state("count_down", "playing", world, bird, game_mode);
        return;
    }

    if (world->update_scored(bird->get_collision_rect()))
    {
        ++score;
        world->score = score;
        Settings::sounds["score"].play();
    }
}

void PlayingState::render(sf::RenderTarget& target) const noexcept
{
    world->render(target);
    bird->render(target);
    render_text(target, 20, 10, "Score: " + std::to_string(score), Settings::FLAPPY_TEXT_SIZE, "flappy", sf::Color::White);
}