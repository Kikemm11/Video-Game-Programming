PartyInfoMenuState = Class{__includes = BaseState}

function PartyInfoMenuState:init(party, heal)
    self.party = party
    self.heal = heal
    self.items = {}

    for k, c in pairs(self.party.characters) do
        if not c.dead then

            table.insert(self.items, {
                            text = c.name,
                            onSelect = function()
                                stateStack:pop()
                                if not self.heal then
                                    stateStack:push(InfoStatsState(c))
                                else
                                    local prevHP = c.HP 
                                    c.HP = c.HP + 15
                                    stateStack:push(HealCharacterState(c, prevHP))
                                end
                            end
                                }
            )
        end
    end
    
    self.partyInfo = Menu {
        x = VIRTUAL_WIDTH/2 - 60,
        y = VIRTUAL_HEIGHT/2 - 100,
        width = 120,
        height = 200,
        items = self.items
    }
end

function PartyInfoMenuState:update(dt)
    self.partyInfo:update(dt)
end

function PartyInfoMenuState:render()
    self.partyInfo:render()
end