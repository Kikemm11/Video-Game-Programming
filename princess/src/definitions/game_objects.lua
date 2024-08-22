--[[
    ISPPJ1 2024
    Study Case: The Legend of the Princess (ARPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by Alejandro Mujica (alejandro.j.mujic4@gmail.com) for teaching purpose.

    This file contains the definition for game objects.
]]
GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 16,
        width = 16,
        height = 16,
        solid = true,
        consumable = false,
        defaultState = 'default',
        takeable = true,
        states = {
            ['default'] = {
                frame = 16
            }
        }
    },
    -- definition of heart as a consumable object type
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        consumable = true,
        defaultState = 'default',
        states = {
            ['default'] = {
                frame = 5
            }
        },
        onConsume = function(player)
            player:heal(2)
            SOUNDS['heart-taken']:play()
        end
    },
    ['chest'] = {
        type = 'chest',
        texture = 'chest',
        frame = 1,
        width = 32,
        height = 32,
        open = false,
        solid = true,
        consumable = false,
        defaultState = 'close',
        states = {
            ['close'] = {
                frame = 1
            },
            ['open'] = {
                frame = 2
            }
        },
    },
    ['bow'] = {
        type = 'bow',
        texture = 'bow',
        frame = 1,
        width = 20,
        height = 20,
        solid = false,
        consumable = true,
        defaultState = 'default',
        states = {
            ['default'] = {
                frame = 1
            }
        },
        onConsume = function(player)
            player.activeBow = true
            SOUNDS['heart-taken']:play()
        end
    },
    ['horizontal-arrow'] = {
        type = 'horizontal-arrow',
        texture = 'horizontal-arrow',
        frame = 1,
        width = 10,
        height = 5,
        solid = true,
        consumable = false,
        defaultState = 'left',
        states = {
            ['left'] = {
                frame = 1
            },
            ['right'] = {
                frame = 2
            }
        }
    },
    ['vertical-arrow'] = {
        type = 'vertical-arrow',
        texture = 'vertical-arrow',
        frame = 1,
        width = 5,
        height = 10,
        solid = true,
        consumable = false,
        defaultState = 'up',
        states = {
            ['up'] = {
                frame = 1
            },
            ['down'] = {
                frame = 2
            }
        }
    }
}
