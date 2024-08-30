InfoMenuState = Class{__includes = BaseState}

function InfoMenuState:init(party)
    self.party = party
    
    self.infoMenu = Menu {
        x = VIRTUAL_WIDTH/2 - 75,
        y = VIRTUAL_HEIGHT/2 - 40,
        width = 150,
        height = 80,
        items = {
            {
                text = 'Party Info',
                onSelect = function()
                    stateStack:pop()
                    stateStack:push(PartyInfoMenuState(self.party, false))
                end
            },
            {
                text = 'Heal Party',
                onSelect = function()
                    stateStack:pop()
                    stateStack:push(HealPartyMenuState(self.party))

                end
            }
        }
    }
end

function InfoMenuState:update(dt)
    self.infoMenu:update(dt)
end

function InfoMenuState:render()
    self.infoMenu:render()
end