Boss = Class{__includes = Entity}

function Boss:init(def)
    Entity.init(self, def)
    self.paralized = false
end

function Boss:update(dt)
    Entity.update(self, dt)
end

function Boss:collides(target)
    local selfY, selfHeight = self.y, self.height
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Boss:render()
    Entity.render(self)
    --love.graphics.setColor(love.math.colorFromBytes(255, 0, 255, 255))
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    --love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))
end