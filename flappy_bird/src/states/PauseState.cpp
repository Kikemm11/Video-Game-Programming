/*
    ISPPJ1 2024
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the definition of the class CountDownBaseState.
*/

#include <Settings.hpp>
#include <src/text_utilities.hpp>
#include <src/states/StateMachine.hpp>
#include <src/states/PauseState.hpp>

PauseState::PauseState(StateMachine* sm) noexcept
    : BaseState{sm}
{

}

void PauseState::enter(std::shared_ptr<World> _world, std::shared_ptr<Bird> _bird, std::string from_state) noexcept
{
    world = _world;
    bird = _bird;
}


void PauseState::handle_inputs(const sf::Event& event) noexcept
{
    if (event.type == sf::Event::KeyPressed && event.key.code == sf::Keyboard::Space)
    {
        state_machine->change_state("playing", "pause", world, bird);
        return;
    }
}


void PauseState::render(sf::RenderTarget& target) const noexcept
{
    world->render(target);
    bird->render(target);
    render_text(target, Settings::VIRTUAL_WIDTH / 2, Settings::VIRTUAL_HEIGHT / 2, "PAUSE", Settings::HUGE_TEXT_SIZE, "font", sf::Color::White, true);
    render_text(target, 20, 10, "Score: " + std::to_string(world->score), Settings::FLAPPY_TEXT_SIZE, "flappy", sf::Color::White);
}