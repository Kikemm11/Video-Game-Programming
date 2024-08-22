BossWalkState = Class{__includes = BaseState}

function BossWalkState:init(boss, dungeon)
    self.boss = boss
    self.boss:changeAnimation('walk-down', dungeon)

    self.dungeon = dungeon

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function BossWalkState:update(dt)
    
    -- assume we didn't hit a wall
    self.bumped = false

    if self.boss.direction == 'left' then
        self.boss.x = self.boss.x - self.boss.walkSpeed * dt
        
        if self.boss.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
            self.boss.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.bumped = true
        end
    elseif self.boss.direction == 'right' then
        self.boss.x = self.boss.x + self.boss.walkSpeed * dt

        if self.boss.x + self.boss.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
            self.boss.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.boss.width
            self.bumped = true
        end
    elseif self.boss.direction == 'up' then
        self.boss.y = self.boss.y - self.boss.walkSpeed * dt

        if self.boss.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.boss.height / 2 then 
            self.boss.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.boss.height / 2
            self.bumped = true
        end
    elseif self.boss.direction == 'down' then
        self.boss.y = self.boss.y + self.boss.walkSpeed * dt

        local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE

        if self.boss.y + self.boss.height >= bottomEdge then
            self.boss.y = bottomEdge - self.boss.height
            self.bumped = true
        end
    end
end

function BossWalkState:processAI(params, dt)
    local room = params.room
    local directions = {'left', 'right', 'up', 'down'}


    if self.boss.paralized then
        self.boss:changeState('idle')

    elseif self.moveDuration == 0 or self.bumped then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.boss.direction = directions[math.random(#directions)]
        self.boss:changeAnimation('walk-' .. tostring(self.boss.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0
        self.moveDuration = math.random(5)
        self.boss.direction = directions[math.random(#directions)]
        self.boss:changeAnimation('walk-' .. tostring(self.boss.direction))
    end

    self.movementTimer = self.movementTimer + dt
end

function BossWalkState:render()
    local anim = self.boss.currentAnimation
    love.graphics.draw(TEXTURES[anim.texture], FRAMES[anim.texture][anim:getCurrentFrame()],
        math.floor(self.boss.x - self.boss.offsetX), math.floor(self.boss.y - self.boss.offsetY))
end