HealPartyMenuState = Class{__includes = BaseState}

function HealPartyMenuState:init(party)
    self.party = party
    
    self.healPartyMenu = Menu {
        x = VIRTUAL_WIDTH/2 - 135,
        y = VIRTUAL_HEIGHT/2 - 40,
        width = 270,
        height = 80,
        items = {
            {
                text = 'Select character (+15 HP)',
                onSelect = function()
                    stateStack:pop()
                    stateStack:push(PartyInfoMenuState(self.party, true))
                end
            },
            {
                text = 'Global Heal (+5 HP each)',
                onSelect = function()
                    
                    local stats = {}

                    for k, c in pairs(self.party.characters) do
                        if not c.dead then
                            table.insert(stats, {character = c, prevHP = c.HP})
                            c.HP = c.HP + 5
                        end
                    end

                    stateStack:pop()
                    stateStack:push(GlobalHealState(stats))
                end
            }
        }
    }
end

function HealPartyMenuState:update(dt)
    self.healPartyMenu:update(dt)
end

function HealPartyMenuState:render()
    self.healPartyMenu:render()
end