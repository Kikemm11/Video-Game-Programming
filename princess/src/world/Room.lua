--[[
    ISPPJ1 2024
    Study Case: The Legend of the Princess (ARPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by Alejandro Mujica (alejandro.j.mujic4@gmail.com) for teaching purpose.

    This file contains the class Room.
]]
Room = Class{}

function Room:init(player)
    -- reference to player for collisions, etc.
    self.player = player

    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self:generateWallsAndFloors()
    

    if self.player.activeBow and math.random(10) == 1 then

        self.activeBoss = true

        self.entities = {}
        self.objects = {}

        self.doorways = {}
        local direction = self.player.direction
        if direction == 'up' then direction = 'bottom'
        elseif direction == 'down' then direction = 'top' 
        elseif direction == 'left' then direction = 'right' 
        else  direction = 'left' end
        table.insert(self.doorways, Doorway(direction, false, self))

        self:generateBoss()

        -- fireballs
        self.fireballs = {}

        SOUNDS['dungeon-music']:stop()
        SOUNDS['boss-fight']:setLooping(true)
        SOUNDS['boss-fight']:play()

    else

        self.activeBoss = false 

        -- entities in the room
        self.entities = {}
        self:generateEntities()

        -- game objects in the room
        self.objects = {}
        self:generateObjects()

        -- doorways that lead to other dungeon rooms
        
        self.doorways = {}
        table.insert(self.doorways, Doorway('top', false, self))
        table.insert(self.doorways, Doorway('bottom', false, self))
        table.insert(self.doorways, Doorway('left', false, self))
        table.insert(self.doorways, Doorway('right', false, self))

    end

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0

    -- projectiles
    self.projectiles = {}

    
end

function Room:update(dt)
    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.player:update(dt)

    if self.boss then

        if self.boss.health <= 0 then
            self.boss.dead = true            
        elseif not self.boss.dead then
            self.boss:processAI({room = self}, dt)
            self.boss:update(dt)
        end

        if not self.boss.dead and self.player:collides(self.boss) and not self.player.invulnerable and not self.boss.paralized then
            SOUNDS['hit-player']:play()
            self.player:damage(2)
            self.player:goInvulnerable(1.5)

            if self.player.health <= 0 then
                stateMachine:change('game-over')
            end
        end
    end

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]

        -- remove entity from the table if health is <= 0
        if entity.health <= 0 then
            entity.dead = true
            -- chance to drop a heart
            if not entity.dropped and math.random(10) == 1 then
                table.insert(self.objects, GameObject(GAME_OBJECT_DEFS['heart'], entity.x, entity.y))
            end
            -- whether the entity dropped or not, it is assumed that it dropped
            entity.dropped = true
        elseif not entity.dead then
            entity:processAI({room = self}, dt)
            entity:update(dt)
        end

        -- collision between the player and entities in the room
        if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
            SOUNDS['hit-player']:play()
            self.player:damage(1)
            self.player:goInvulnerable(1.5)

            if self.player.health == 0 then
                stateMachine:change('game-over')
            end
        end
    end

    for k, object in pairs(self.objects) do
        object:update(dt)

        if object.used then
            table.remove(self.objects, k)
        end

        -- trigger collision callback on object
        if self.player:collides(object) then
            object:onCollide()

            if object.solid and not object.taken then
                local playerY = self.player.y + self.player.height / 2
                local playerHeight = self.player.height - self.player.height / 2
                local playerRight = self.player.x + self.player.width
                local playerBottom = playerY + playerHeight
                
                if self.player.direction == 'left' and not (playerY >= (object.y + object.height)) and not (playerBottom <= object.y) then
                    self.player.x = object.x + object.width
                elseif self.player.direction == 'right' and not (playerY >= (object.y + object.height)) and not (playerBottom <= object.y) then 
                    self.player.x = object.x - self.player.width
                elseif self.player.direction == 'down' and not (self.player.x >= (object.x + object.width)) and not (playerRight <= object.x) then
                    self.player.y = object.y - self.player.height
                elseif self.player.direction == 'up' and not (self.player.x >= (object.x + object.width)) and not (playerRight <= object.x) then
                    self.player.y = object.y + object.height - self.player.height/2
                end
            end

            if object.consumable then
                object.onConsume(self.player, object)
                table.remove(self.objects, k)
            end

        end
    end

    for k, projectile in pairs(self.projectiles) do
        projectile:update(dt)

        -- check collision with entities
        for e, entity in pairs(self.entities) do
            if projectile.dead then
                break
            end

            if not entity.dead and projectile:collides(entity) then
                entity:damage(1)
                SOUNDS['hit-enemy']:play()
                projectile.dead = true
                projectile.obj.used = true
            end
        end

        if self.boss and not self.boss.dead and projectile:collides(self.boss) then
            self.boss:damage(1)
            SOUNDS['hit-enemy']:play()
            projectile.dead = true
            projectile.obj.used = true
            self.boss.paralized = true
        end

        if projectile.dead then
            table.remove(self.projectiles, k)
        end
    end

    if self.boss then
        for k, fireball in pairs(self.fireballs) do
            fireball:update(dt)
    
            if  not fireball.dead and not self.player.invulnerable and fireball:collides(self.player) then
                SOUNDS['hit-player']:play()
                self.player:damage(1)
                self.player:goInvulnerable(1.5)
                fireball.dead = true
                if self.player.health <= 0 then
                    stateMachine:change('game-over')
                end 
            end
    
            if fireball.dead then
                table.remove(self.fireballs, k)
            end
        end

    end


end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
function Room:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            
            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
    local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    for i = 1, 10 do
        local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
            
            width = 16,
            height = 16,

            health = 1
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end

end


function Room:generateBoss()

    local boss_x = 0
    local boss_y = 0

    if self.player.direction == 'up' then 
        boss_x = MAP_RENDER_OFFSET_X + VIRTUAL_WIDTH / 2 - 21
        boss_y = MAP_RENDER_OFFSET_Y + TILE_SIZE
    elseif self.player.direction == 'down' then
            boss_x = MAP_RENDER_OFFSET_X + VIRTUAL_WIDTH / 2 - 21
            boss_y = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 42
    elseif self.player.direction == 'left' then
            boss_x = MAP_RENDER_OFFSET_X + TILE_SIZE
            boss_y = MAP_RENDER_OFFSET_Y + VIRTUAL_HEIGHT / 2 - 21
    else
            boss_x = VIRTUAL_WIDTH - TILE_SIZE * 2 - 42
            boss_y = MAP_RENDER_OFFSET_Y + VIRTUAL_HEIGHT / 2 - 21
    end

    self.boss = Boss {
        animations = ENTITY_DEFS['dragon'].animations,
        walkSpeed = ENTITY_DEFS['dragon'].walkSpeed,
        
        x = boss_x,
        y = boss_y,
        
        width = 42,
        height = 42,

        health = 100,
    }

    self.boss.stateMachine = StateMachine {
        ['walk'] = function() return BossWalkState(self.boss) end,
        ['idle'] = function() return BossIdleState(self.boss) end
    }

    self.boss:changeState('walk')

end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()
    table.insert(self.objects, GameObject(
        GAME_OBJECT_DEFS['switch'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    ))

    -- get a reference to the switch
    local switch = self.objects[1]

    -- define a function for the switch that will open all doors in the room
    switch.onCollide = function()
        if switch.state == 'unpressed' then
            switch.state = 'pressed'
            
            -- open every door in the room if we press the switch
            for k, doorway in pairs(self.doorways) do
                doorway.open = true
            end
        end
    end

    if math.random(10) == 1 then

        table.insert(self.objects, GameObject(
            GAME_OBJECT_DEFS['chest'],
            math.random(MAP_RENDER_OFFSET_X + TILE_SIZE * 2,
                        VIRTUAL_WIDTH - TILE_SIZE * 3 - 32),
            math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE * 2,
                        VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE * 2 - 32)
        ))

        local chest = self.objects[2]

        chest.open = false

        chest.onCollide = function() 

            if  chest.state == 'close' and chest.open then
                chest.state = 'open'
                SOUNDS['chest-open']:play()
                chest.open = true

                local tableLength = #self.objects
                
                table.insert(self.objects, GameObject(
                    GAME_OBJECT_DEFS['bow'], chest.x + 5, chest.y + 2))
                
                local bow = self.objects[tableLength+1]

                local bowNextX = bow.y - 2*bow.height

                if bow.y - 2*bow.height <= MAP_RENDER_OFFSET_Y then 
                    bowNextX = MAP_RENDER_OFFSET_Y + bow.height/2
                end

                Timer.tween(1, {
                    [bow] = {x = bow.x, y = bowNextX },
                    }):finish(function()
                        SOUNDS['bow-reward']:play()
                    end)
            end
        end
    end
    
    for y = 2, self.height -1 do
        for x = 2, self.width - 1 do
            -- change to spawn a pot
            if math.random(20) == 1 then
                table.insert(self.objects, GameObject(
                    GAME_OBJECT_DEFS['pot'], x*16, y*16
                ))
            end
        end
    end
end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(TEXTURES['tiles'], FRAMES['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.objects) do
        object:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    if self.boss then 

        for k, fireball in pairs(self.fireballs) do
            fireball:render() 
        end
    end

    -- stencil out the door arches so it looks like the player is going through
    love.graphics.stencil(function()
        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE * 2,
            TILE_SIZE * 2 + 6, TILE_SIZE * 3)
        
        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - 6,
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE * 2, TILE_SIZE * 2 + 6, TILE_SIZE * 3)
        
        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
        
        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)

    if self.player then
        self.player:render()
    end

    if self.boss and not self.boss.dead then
        self.boss:render()
    end

    for k, projectile in pairs(self.projectiles) do
        projectile:render()
    end

    love.graphics.setStencilTest()
end
