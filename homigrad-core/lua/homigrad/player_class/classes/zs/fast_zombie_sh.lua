local CLASS = player.RegClass("fast_zombie")
function CLASS.Off(self)
	if CLIENT then return end
	self.isZombie = nil
end

function CLASS.On(self)
	if CLIENT then return end
	self:SetHealth(150)
	self:SetMaxHealth(150)
	self:SetArmor(150)
	self:Give("weapon_zombie_fast")
	self.isZombie = true
	self:EmitSound("npc/zombie/zombie_alert"..math.random(1,3)..".wav")
	self:SetModel("models/player/zombie_fast.mdl")
end

function CLASS.PlayerDeath(self)
	self:SetPlayerClass()
end

function CLASS.Think(self)
	self.bleed = 0
    self.pain = 0
    self:SelectWeapon("weapon_zombie_fast")
    self.blood = 5000
	self.stamina = 100
	self:SetWalkSpeed(350)
	self:SetRunSpeed(450)
	self:SetJumpPower(700)
    self:SetHealth(math.Clamp(self:Health() + 0.025,0,self:GetMaxHealth()))
end