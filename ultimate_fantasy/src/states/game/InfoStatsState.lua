InfoStatsState = Class{__includes = BaseState}

function InfoStatsState:init(character)
    self.character = character
    
    self.level = self.character.level
    self.exp = self.character.currentExp
    self.hp = self.character.HP
    self.magicLvl = self.character.magicIV
    self.attack = self.character.attack
    self.defense = self.character.defense
    
    self.statsMenu = Menu {
        x = VIRTUAL_WIDTH/2 - 75,
        y = VIRTUAL_HEIGHT/2 - 90,
        width = 150,
        height = 180,
        showCursor = false,
        font = FONTS['medium'],
        items = {
            {
                text = 'Level: ' .. self.level,
                onSelect = function()
                    stateStack:pop()
                end
            },
            {
                text = 'Exp: ' .. self.exp,
                onSelect = function()
                    stateStack:pop()
                end
            },
            {
                text = 'HP: ' .. self.hp,
                onSelect = function()
                    stateStack:pop()
                end
            },
            {
                text = 'Magic: ' .. self.magicLvl,
                onSelect = function()
                    stateStack:pop()
                end
            },
            {
                text = 'Attack: ' .. self.attack,
                onSelect = function()
                    stateStack:pop()
                end
            },
            {
                text = 'Defense: ' .. self.defense,
                onSelect = function()
                    stateStack:pop()
                end
            }
        }
    }
end

function InfoStatsState:update(dt)
    self.statsMenu:update(dt)
end

function InfoStatsState:render()
    self.statsMenu:render()
end