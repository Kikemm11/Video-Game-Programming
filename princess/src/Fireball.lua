local FIREBALL_SPEED = 150

Fireball = Class{}

function Fireball:init(obj, x, y)
    self.obj = obj
    self.target_x = x
    self.target_y = y
    self.distance = 0
    self.dead = false


    -- Calculate the direction vector from the object's position to the target

    local dx = self.target_x - self.obj.x
    local dy = self.target_y - self.obj.y

    -- Normalize the direction vector

    local magnitude = math.sqrt(dx * dx + dy * dy)
    self.dir_x = dx / magnitude
    self.dir_y = dy / magnitude

end

function Fireball:update(dt)
    if self.dead then
        return
    end

    self.obj.x = self.obj.x + self.dir_x * FIREBALL_SPEED * dt
    self.obj.y = self.obj.y + self.dir_y * FIREBALL_SPEED * dt

    local topEdge = MAP_RENDER_OFFSET_Y + TILE_SIZE
    local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE
    local leftEdge = MAP_RENDER_OFFSET_X + TILE_SIZE
    local rightEdge = VIRTUAL_WIDTH - TILE_SIZE * 2


    if self.obj.y <= topEdge - self.obj.height / 2 then
        self.dead = true
    elseif self.obj.y + self.obj.height >= bottomEdge then
        self.dead = true
    elseif self.obj.x <= leftEdge then
        self.dead = true
    elseif self.obj.x + self.obj.width >= rightEdge then
        self.dead = true
    end

    if self.dead then
        SOUNDS['pot-wall']:play()
        return
    end

end

function Fireball:render()
    self.obj:render(0, 0)
end

function Fireball:collides(target)
    return not (self.obj.x + self.obj.width < target.x or self.obj.x > target.x + target.width or
                self.obj.y + self.obj.height < target.y or self.obj.y > target.y + target.height)
end
