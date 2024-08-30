HealCharacterState = Class{__includes = BaseState}

function HealCharacterState:init(character, prevHP)
    self.character = character
    self.prevHP = prevHP
    
    self.statsMenu = Menu {
        x = VIRTUAL_WIDTH/2 - 100,
        y = VIRTUAL_HEIGHT/2 - 90,
        width = 200,
        height = 50,
        showCursor = false,
        font = FONTS['medium'],
        items = {
            {
                text = self.character.name,
                onSelect = function()
                    stateStack:pop()
                end
            },
            {
                text = 'HP: ' .. self.prevHP .. ' + ' .. '15 HP = ' .. self.character.HP,
                onSelect = function()
                    stateStack:pop()
                end
            },
        }
    }
end

function HealCharacterState:update(dt)
    self.statsMenu:update(dt)
end

function HealCharacterState:render()
    self.statsMenu:render()
end