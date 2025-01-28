-- sh_holster_deploy.lua"

AddCSLuaFile()
--
SWEP.CooldownHolster = 0.25
SWEP.HolsterSnd = {"homigrad/weapons/holster_rifle.mp3", 55, 100, 110}
SWEP.CooldownDeploy = 0.25
SWEP.DeploySnd = {"homigrad/weapons/draw_rifle.mp3", 65, 100, 110}
function SWEP:Step_HolsterDeploy(time)
	local time2 = self.holster
	if time2 and time2 < time then self:Holster_End() end
	time2 = self.deploy
	if time2 and time2 < time then self:Deploy_End() end
end

if SERVER then return end
net.Receive("hg wep deploy", function()
	local ent = net.ReadEntity()
	if not IsValid(ent) then return end
	if not ent.Deploy then return end
	ent:Deploy(net.ReadFloat())
end)

net.Receive("hg wep holster", function()
	local ent = net.ReadEntity()
	if not IsValid(ent) then return end
	ent:Holster(nil, net.ReadFloat())
end)

net.Receive("Switch Weapon", function() input.SelectWeapon(net.ReadEntity()) end)
function SWEP:Holster(wep, time)
	--if not time then return end
	self.holster = time
	self.deploy = nil
	--self:SetHold("pistol")
	--if self:IsClient() then DOF_Kill() end
	--return false
end

function SWEP:Holster_End()
end

function SWEP:Deploy(time)
	--self:SetHold("pistol")
	if not time then return end
	self.holster = nil
	self.deploy = time
	self:SetHold(self.HoldType)
	--if self:IsClient() then DOF_Start() end
end

function SWEP:Deploy_End()
	self.deploy = nil
end