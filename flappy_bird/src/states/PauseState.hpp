/*
    ISPPJ1 2024
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the declaration of the class CountDownBaseState.
*/

#pragma once
#include <string>
#include <src/Bird.hpp>
#include <src/World.hpp>
#include <src/states/BaseState.hpp>

class PauseState: public BaseState
{
public:
    PauseState(StateMachine* sm) noexcept;

    void enter(std::shared_ptr<World> _world = nullptr, std::shared_ptr<Bird> _bird = nullptr, std::string from_state = "") noexcept override;

    void handle_inputs(const sf::Event& event) noexcept override;

    void render(sf::RenderTarget& target) const noexcept override;

private:
    std::shared_ptr<World> world;
    std::shared_ptr<Bird> bird;
};
