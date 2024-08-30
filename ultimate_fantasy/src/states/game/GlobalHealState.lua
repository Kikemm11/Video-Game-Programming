GlobalHealState = Class{__includes = BaseState}

function GlobalHealState:init(stats)
    self.stats = stats
    self.items = {}

    for k, stat in pairs(stats) do
        local character = stat['character']
        table.insert(self.items, {
                                    text = character.name .. ': ' .. stat['prevHP'] .. ' + 5 HP = ' .. character.HP,
                                    onSelect = function()
                                        stateStack:pop()
                                    end
                                }
        )
    end
    
    self.statsMenu = Menu {
        x = VIRTUAL_WIDTH/2 - 125,
        y = VIRTUAL_HEIGHT/2 - 90,
        width = 250,
        height = 180,
        showCursor = false,
        font = FONTS['medium'],
        items = self.items
    }
end

function GlobalHealState:update(dt)
    self.statsMenu:update(dt)
end

function GlobalHealState:render()
    self.statsMenu:render()
end