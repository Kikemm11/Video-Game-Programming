/*
    ISPPJ1 2024
    Study Case: Flappy Bird

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the declaration of Settings that contains constants
    to set up the game and methods to load multimedia files.
*/

#pragma once

#include <filesystem>
#include <string>
#include <unordered_map>

namespace fs = std::filesystem;

#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>

struct Settings
{
    static const fs::path ASSETS_PATH;
    static const fs::path TEXTURES_PATH;
    static const fs::path SOUNDS_PATH;
    static const fs::path FONTS_PATH;

    static constexpr int WINDOW_WIDTH{1280};
    static constexpr int WINDOW_HEIGHT{720};
    static constexpr int VIRTUAL_WIDTH{512};
    static constexpr int VIRTUAL_HEIGHT{288};
    static constexpr float BIRD_WIDTH{39.f};
    static constexpr float BIRD_HEIGHT{28.f};
    static constexpr float LOG_WIDTH{70.f};
    static constexpr float LOG_HEIGHT{288.f};
    static constexpr float POWER_UP_WIDTH{39.f};
    static constexpr float POWER_UP_HEIGHT{39.f};
    static constexpr float LOGS_GAP{90.f};
    static constexpr float GROUND_HEIGHT{16.f};
    static constexpr float BACKGROUND_LOOPING_POINT{1157.f};
    static constexpr float MAIN_SCROLL_SPEED{100.f};
    static constexpr float BACK_SCROLL_SPEED{50.f}; // MAIN_SCROLL_SPEED / 2
    static constexpr float GRAVITY{980.f};
    static constexpr float JUMP_TAKEOFF_SPEED{GRAVITY / 6.f};
    static constexpr float BIRD_X_SPEED{120.f};
    static constexpr float TIME_TO_SPAWN_LOGS{1.5f};
    static constexpr float TIME_TO_CLOSE_LOGS{5.f};
    static constexpr float TIME_CLOSED_LOGS{2.5f};
    static constexpr float TIME_TO_POWER_UP{15.f};
    static constexpr float TIME_DURING_GHOST_BIRD{7.f};
    static constexpr float POWER_UP_VY{150.f};
    static constexpr int MEDIUM_TEXT_SIZE{18};
    static constexpr int HUGE_TEXT_SIZE{56};
    static constexpr int FLAPPY_TEXT_SIZE{28};

    static constexpr float MIN_LOGS_GAP{76.f};
    static constexpr float MAX_LOGS_GAP{90.f};

    static constexpr float MAX_TIME_TO_SPAWN_LOGS{8.5f};
    static constexpr float MIN_TIME_TO_SPAWN_LOGS{1.f};
    

    static std::unordered_map<std::string, sf::Texture> textures;
    static std::unordered_map<std::string, sf::SoundBuffer> sound_buffers;
    static std::unordered_map<std::string, sf::Sound> sounds;
    static std::unordered_map<std::string, sf::Font> fonts;

    static sf::Music music;
    static sf::Music ghost_music;

    static void init();

    static void load_textures();

    static void load_sounds();

    static void load_fonts();
};
