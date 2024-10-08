--[[
    ISPPV1 2024
    Study Case: Ultimate Fantasy (RPG)

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This class contains the class BattleEntity.
]]
BattleEntity = Class{__includes = Entity}

function BattleEntity:init(def)
    Entity.init(self, def)
    self.class = def.class

    self.actions = def.actions

    self.level = def.level or 1
 
    self.dead = def.dead

    self.baseHP = def.baseHP
    self.baseAttack = def.baseAttack
    self.baseDefense = def.baseDefense
    self.baseMagic = def.baseMagic
    
    self.HP = self.baseHP
    self.attack = self.baseAttack
    self.defense = self.baseDefense
    self.magic = self.baseMagic
    
    self.currentHP = self.HP

    self.maxRestTime = def.maxRestTime
    self.currentRestTime = 0
    self.completeRest = false
end

function BattleEntity:damage(amount)
    self.currentHP = self.currentHP - amount
    if self.currentHP <= 0 then
        self.dead = true
    end
end

function BattleEntity:heal(amount)
    if not self.dead then
        self.currentHP = math.min(self.HP, self.currentHP + amount)
    end
end

function BattleEntity:computeAttack()
    return math.floor(math.random()/2*self.attack + math.random()/4*self.magic)
end

function BattleEntity:computeDefense()
    return math.floor(math.random()/4*self.defense + math.random()/8*self.magic)
end

function BattleEntity:computeHealing()
    return math.floor(math.random()*2*self.magic)
end

function BattleEntity:updateRestTime(dt, battleState)

    if self.currentRestTime >= self.maxRestTime then
        self.completeRest = true
        self.currentRestTime = 0
        Timer.tween(0.5, {
            [battleState.restBars[self.name]] = {value = self.currentRestTime}
        })
    else
        self.currentRestTime =  self.currentRestTime + dt
        --self.completeRest = false
        Timer.tween(0.5, {
            [battleState.restBars[self.name]] = {value = self.currentRestTime}
        })
    end

end
