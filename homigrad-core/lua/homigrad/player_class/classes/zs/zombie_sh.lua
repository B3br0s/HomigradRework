local CLASS = player.RegClass("zombie")
function CLASS.Off(self)
	if CLIENT then return end
	self.isZombie = nil
end

function CLASS.On(self)
	if CLIENT then return end
	self:SetHealth(300)
	self:SetMaxHealth(300)
	self:SetArmor(50)
	self:Give("weapon_zombie")
	self.isZombie = true
	self:EmitSound("npc/zombie/zombie_alert"..math.random(1,3)..".wav")
end

function CLASS.PlayerDeath(self)
	self:SetPlayerClass()
end

function CLASS.Think(self)
	self.bleed = 0
    self.pain = 0
    self:SelectWeapon("weapon_zombie")
    self.blood = 5000
	self.stamina = 100
    self:SetHealth(math.Clamp(self:Health() + 0.025,0,self:GetMaxHealth()))
end