-- sh_reload.lua"

AddCSLuaFile()
--
function SWEP:Initialize_Reload()
	self.LastReload = 0
end

SWEP.dwr_customVolume = 1
SWEP.OpenBolt = true
function SWEP:CanReload()
	if self:LastShootTime() + 0.1 > CurTime() then return end
	if self.ReloadNext or not self:CanUse() or self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) == 0 or self:Clip1() >= self:GetMaxClip1() + (self.drawBullet and self.OpenBolt and 1 or 0) then --shit
		return
	end
	return true
end

function SWEP:InsertAmmo(need)
	local owner = self:GetOwner()
	local primaryAmmo = self:GetPrimaryAmmoType()
	local primaryAmmoCount = owner:GetAmmoCount(primaryAmmo)
	need = need or self:GetMaxClip1() - self:Clip1()
	need = math.min(primaryAmmoCount, need)
	need = math.min(need, self:GetMaxClip1())
	self:SetClip1(self:Clip1() + need)
	owner:SetAmmo(primaryAmmoCount - need, primaryAmmo)
end

SWEP.ReloadCooldown = 0.1
local math_min = math.min
function SWEP:ReloadEnd()
	self:InsertAmmo(self:GetMaxClip1() - self:Clip1() + (self.drawBullet ~= nil and self.OpenBolt and 1 or 0))
	self.ReloadNext = CurTime() + self.ReloadCooldown
	self:Draw()
end

function SWEP:Step_Reload(time)
	if self:KeyDown(IN_WALK) and self:KeyDown(IN_RELOAD) then
		self.checkingammo = true
	else
		self.checkingammo = false
	end

	local time2 = self.reload
	if time2 and time2 < time then
		self.reload = nil
		self:ReloadEnd()
	end

	time2 = self.ReloadNext
	if time2 and time2 < time then
		self.ReloadNext = nil
		self.dwr_reverbDisable = nil
	end
end

function SWEP:ReloadStartPost()
end

function SWEP:Reload(time)

	if self:KeyDown(IN_WALK) then return end
	if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then return end
	if self:GetMaxClip1() < self:Clip1() then return end
	if self.reload or 0 > CurTime() then return end

	self.LastReload = CurTime()
	self:ReloadStart()
	self:ReloadStartPost()
	self.reload = CurTime() + self.ReloadTime
	self.dwr_reverbDisable = true
end

function SWEP:ReloadStart()
	self:SetHold(self.ReloadHold or self.HoldType)
	self:GetOwner():SetAnimation(PLAYER_RELOAD)
end