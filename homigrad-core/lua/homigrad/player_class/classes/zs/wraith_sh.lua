local CLASS = player.RegClass("wraith")
function CLASS.Off(self)
	if CLIENT then return end
	self.isZombie = nil
end

function CLASS.On(self)
	if CLIENT then return end
	self:SetHealth(200)
	self:SetMaxHealth(200)
	self:SetArmor(0)
	self:Give("weapon_zombie_wraith")
	self.isZombie = true
	self:EmitSound("npc/zombie/zombie_alert"..math.random(1,3)..".wav")
	self:SetModel("models/player/charple.mdl")
end

function CLASS.PlayerDeath(self)
	self:SetPlayerClass()
end

function CLASS.Think(self)
	self.bleed = 0
    self.pain = 0
    self:SelectWeapon("weapon_zombie_wraith")
    self.blood = 5000
	self.stamina = 100
    self:SetHealth(math.Clamp(self:Health() + 0.025,0,self:GetMaxHealth()))
end