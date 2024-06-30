#include <Settings.hpp>
#include <src/PowerUp.hpp>

#include <src/text_utilities.hpp>
#include <cmath>

PowerUp::PowerUp(float _x, float _y) noexcept
    : x{_x}, y{_y}, width{Settings::POWER_UP_WIDTH}, height{Settings::POWER_UP_HEIGHT}, vy{Settings::POWER_UP_VY}, sprite{Settings::textures["powerup"]}
{
    sprite.setPosition(x, y);
}


sf::FloatRect PowerUp::get_collision_rect() const noexcept
{
    return sf::FloatRect{x, y, width, height};
}

void PowerUp::update(float dt, std::shared_ptr<Bird> bird) noexcept
{   
    ghost_bird_timer += dt;

    ghost_bird_counter = static_cast<int>(Settings::TIME_DURING_GHOST_BIRD) - static_cast<int>(ghost_bird_timer);

    x += -Settings::MAIN_SCROLL_SPEED * dt;
    y += vy * dt;

    auto bird_collision_rect = bird->get_collision_rect();
    auto power_up_collision_rect = this->get_collision_rect();

    if ( power_up_collision_rect.top <= 0 || power_up_collision_rect.top + Settings::POWER_UP_HEIGHT >= Settings::VIRTUAL_HEIGHT)
    {
        vy *= -1;
        y += vy * dt;
    }
    

    if (power_up_collision_rect.intersects(bird_collision_rect))
    {
        y = -Settings::POWER_UP_HEIGHT;
        x = -Settings::POWER_UP_WIDTH;
        powerup_on = true;

        bird->set_ghost_bird(true);
        bird->set_sprite(Settings::textures["ghost_bird"]);
        ghost_bird_timer = 0.f;

        Settings::music.pause();
        Settings::ghost_music.setLoop(true);
        Settings::ghost_music.play();
    }

    if (bird->get_ghost_bird() && ghost_bird_timer >= Settings::TIME_DURING_GHOST_BIRD)
    {
        powerup_on = false;

        bird->set_ghost_bird(false);
        bird->set_sprite(Settings::textures["bird"]);

        Settings::ghost_music.pause();
        Settings::music.play();
    }
    
    
    sprite.setPosition(x, y);  
    
}


void PowerUp::render(sf::RenderTarget& target) const noexcept
{
    target.draw(sprite);

    if (powerup_on)
    {
        render_text(target, 20, 40, "Ghost time: " + std::to_string(ghost_bird_counter), 15, "flappy", sf::Color::White);
    }
    
}