ArrowFactory = Class{}

function ArrowFactory:init(direction, room)

    self.direction = direction
    self.room = room
end

function ArrowFactory:create()
    

    if self.direction == 'up' then
        self.arrow = GameObject(GAME_OBJECT_DEFS['vertical-arrow'], self.room.player.x + self.room.player.width, self.room.player.y + (self.room.player.height / 2))
        self.arrow.state = 'up'
    elseif self.direction == 'down' then 
        self.arrow = GameObject(GAME_OBJECT_DEFS['vertical-arrow'], self.room.player.x + self.room.player.width, self.room.player.y + (self.room.player.height / 2))
        self.arrow.state = 'down'
    elseif self.direction == 'right' then 
        self.arrow = GameObject(GAME_OBJECT_DEFS['horizontal-arrow'], self.room.player.x + self.room.player.width, self.room.player.y + (self.room.player.height / 2))
        self.arrow.state = 'right'
    else 
        self.arrow = GameObject(GAME_OBJECT_DEFS['horizontal-arrow'], self.room.player.x - 15, self.room.player.y + (self.room.player.height / 2))
        self.arrow.state = 'left'
    
    end

    table.insert(self.room.objects, self.arrow)
    table.insert(self.room.projectiles, Projectile(self.arrow, self.arrow.state))
    
end
