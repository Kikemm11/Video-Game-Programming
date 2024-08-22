BossIdleState = Class{__includes = BaseState}

function BossIdleState:init(boss, dungeon)
    self.boss = boss
    self.dungeon = dungeon

    self.boss:changeAnimation('idle-' .. self.boss.direction)

    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0

end

function BossIdleState:processAI(params, dt)

    -- Manage the idle state when the boss has been paralized by an arrow
    if self.boss.paralized and self.waitTimer == 0 then
        self.waitDuration = 3.5
        self.waitTimer = self.waitTimer + dt

    else  
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.boss:changeState('walk')
            self.boss.paralized = false
        end

    end
end

function BossIdleState:render()
    local anim = self.boss.currentAnimation
    love.graphics.draw(TEXTURES[anim.texture], FRAMES[anim.texture][anim:getCurrentFrame()],
        math.floor(self.boss.x - self.boss.offsetX), math.floor(self.boss.y - self.boss.offsetY))
end