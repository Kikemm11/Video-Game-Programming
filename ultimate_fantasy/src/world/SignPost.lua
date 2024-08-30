SignPost = Class{}

function SignPost:init(x, y)
    self.x = x
    self.y = y
    self.width = 30
    self.height = 42
end


function SignPost:render()
    love.graphics.draw(TEXTURES['signpost'], FRAMES['signpost'][1],
        self.x, self.y)
end

function SignPost:giveInfo(party)

    self.party = party
    self.target = self.party:firstAlive()

    if self:collides(self.target) and self.target.direction == 'up' and (love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')) then
        stateStack:push(InfoMenuState(self.party))
    end

end

function SignPost:collides(target)
    local selfY, selfHeight = self.y, self.height
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end