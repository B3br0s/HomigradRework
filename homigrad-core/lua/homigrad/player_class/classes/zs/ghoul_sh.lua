local CLASS = player.RegClass("ghoul")
function CLASS.Off(self)
	if CLIENT then return end
	self.isZombie = nil
end

function CLASS.On(self)
	if CLIENT then return end
	self:SetHealth(150)
	self:SetMaxHealth(150)
	self:SetArmor(0)
	self:Give("weapon_zombie_ghoul")
	self.isZombie = true
	self:EmitSound("npc/zombie/zombie_alert"..math.random(1,3)..".wav")
	self:SetModel("models/player/corpse1.mdl")
end

function CLASS.PlayerDeath(self)
	self:SetPlayerClass()
end

function CLASS.Think(self)
	self.bleed = 0
    self.pain = 0
    self:SelectWeapon("weapon_zombie_ghoul")
    self.blood = 5000
	self.stamina = 100
    self:SetHealth(math.Clamp(self:Health() + 0.025,0,self:GetMaxHealth()))
end