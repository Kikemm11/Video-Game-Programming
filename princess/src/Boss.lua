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

function Boss:trhowFireball(room)
    self.room = room

    if self.direction == 'up' then
        x = self.x + self.width / 2
        y = self.y
    elseif self.direction == 'down' then
        x = self.x + self.width / 2
        y = self.y + self.height
    elseif self.direction == 'left' then
        x = self.x
        y = self.y + self.height / 2
    else
        x = self.x + self.width
        y = self.y + self.height / 2
    end

    local fireball = GameObject(GAME_OBJECT_DEFS['fireball'], x, y)
    table.insert(self.room.fireballs, Fireball(fireball, self.room.player.x, self.room.player.y))
    
end