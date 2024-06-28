/*
    ISPPJ1 2024
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the definition of the class TitleScreenState.
*/

#pragma once

#include <src/World.hpp>
#include <src/states/BaseState.hpp>
#include <src/game_mode/GameMode.hpp>
#include <src/game_mode/GameModeNormal.hpp>
#include <src/game_mode/GameModeHard.hpp>

class TitleScreenState: public BaseState
{
public:
    TitleScreenState(StateMachine* sm) noexcept;

    void handle_inputs(const sf::Event& event) noexcept override;

    void update(float dt) noexcept override;

    void render(sf::RenderTarget& target) const noexcept override;

private:
    std::shared_ptr<World> world;
    std::shared_ptr<GameMode> normal{std::make_shared<GameModeNormal>()};
    std::shared_ptr<GameMode> hard{std::make_shared<GameModeHard>()};
};
