-- weapon_m4super.lua"

SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Benelli M4 Super 90"
SWEP.Author = "Benelli Armi S.p.A."
SWEP.Instructions = "Полуавтоматический дробовик под калибр 12/70"
SWEP.Category = "Оружие - Дробовики"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/pwb2/weapons/w_m4super90.mdl"

SWEP.WepSelectIcon2 = Material("pwb2/vgui/weapons/m4super90.png")
SWEP.IconOverride = "entities/weapon_pwb2_m4super90.png"

SWEP.weaponInvCategory = 1
SWEP.ShellEject = "ShotgunShellEject"
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 16
SWEP.Primary.Spread = Vector(0.05, 0.05, 0.05)
SWEP.Primary.Force = 8
SWEP.Primary.Sound = {"toz_shotgun/toz_fp.wav", 80, 70, 75}
SWEP.Primary.Wait = 0.2
SWEP.NumBullet = 8
SWEP.DeploySnd = {"homigrad/weapons/draw_hmg.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/hmg_holster.mp3", 55, 100, 110}
SWEP.AmmoTypes = {
	[1] = {"12/70 gauge", Vector(0.05, 0.05, 0.05), 16, 3, 8, false, 1},
	[2] = {"12/70 beanbag", Vector(0.005, 0.005, 0.005), 16, 8, 1, true, 2},
}

SWEP.HoldType = "ar2"
SWEP.ReloadHold = "pistol"
SWEP.ZoomPos = Vector(-1.45, 0.36, 33)
SWEP.RHandPos = Vector(-5, -2, 0)
SWEP.LHandPos = Vector(7, -2, -2)
SWEP.SprayRand = {Angle(-0.2, -0.4, 0), Angle(-0.4, 0.4, 0)}
SWEP.Ergonomics = 0.9
SWEP.AnimShootMul = 3
SWEP.AnimShootHandMul = 160
SWEP.AnimStart_Draw = 0
SWEP.AnimStart_Insert = 0
SWEP.AnimInsert = 0.1
SWEP.AnimDraw = 0.1
SWEP.Penetration = 7
SWEP.ReloadTime = 0.75
SWEP.AnimInsert = 0.1
SWEP.AnimDraw = 0.3
SWEP.ReloadDrawTime = 0.1
SWEP.ReloadDrawCooldown = 0.5
SWEP.ReloadInsertTime = 0.1
SWEP.ReloadInsertCooldown = 0.25
SWEP.ReloadInsertCooldownFire = 0.1
SWEP.lengthSub = 20
SWEP.handsAng = Angle(-1, 1, 0)
function SWEP:GetAnimPos_Insert(time)
	local animpos1 = math.Clamp(self.AnimStart_Insert + self.AnimInsert - time, 0, self.AnimInsert) / self.AnimInsert
	return animpos1
end

function SWEP:GetAnimPos_Draw(time)
	local animpos1 = math.Clamp(self.AnimStart_Draw + self.AnimDraw - time, 0, self.AnimDraw) / self.AnimDraw
	return animpos1
end

function SWEP:ChangeCameraPassive(value)
	if self.reload then return 1 end
	return value
end

function SWEP:InitializePost()
	self.AnimStart_Insert = 0
	self.AnimStart_Draw = 0
end

function SWEP:CanPrimaryAttack()
	return not (self:GetAnimPos_Draw(CurTime()) > 0)
end

SWEP.reloadCoolDown = 0
if SERVER then
	util.AddNetworkString("hgwep draw")
	function SWEP:Reload(time)
		if not self:CanUse() then return end
		if self.reloadCoolDown > CurTime() then return end
		if self.reload or 0 > CurTime() then return end

		if self.drawBullet == false then
			self.AnimStart_Draw = CurTime()
			self:Draw()
			if CLIENT and LocalPlayer() == self:GetOwner() then ViewPunch(AngleRand(0, -10)) end
			net.Start("hgwep draw")
			net.WriteEntity(self)
			net.WriteBool(self.drawBullet)
			net.Broadcast()
			self:GetOwner():EmitSound("weapons/shotgun/shotgun_cock.wav", 65)
			self.reloadCoolDown = CurTime() + self.ReloadDrawCooldown
			return
		end

		if self:GetAnimPos_Draw(CurTime()) > 0 then return end
		if not self:CanReload() then return end
		--self:GetOwner():SetPlaybackRate(1)
		self.LastReload = CurTime()
		self:ReloadStart()
		self:ReloadStartPost()
		self.reload = self.LastReload + self.ReloadTime
		self.dwr_reverbDisable = true
		net.Start("hgwep reload")
		net.WriteEntity(self)
		net.WriteFloat(self.LastReload)
		net.Broadcast()
	end
else
	function SWEP:Reload(time)
		if not time then return end
		self.LastReload = time
		self:ReloadStart()
		self:ReloadStartPost()
		self.reload = time + self.ReloadTime
		self.dwr_reverbDisable = true
	end

	function SWEP:ReloadStart()
		--print(self:SelectWeightedSequence(ACT_HL2MP_GESTURE_RELOAD_PISTOL))
		--self:GetOwner():SetPlaybackRate(1)
		self:SetHold(self.ReloadHold or self.HoldType)
		self:GetOwner():SetAnimation(PLAYER_RELOAD)
	end

	net.Receive("hgwep draw", function()
		local self = net.ReadEntity()
		local drawBullet = net.ReadBool()
		self.AnimStart_Draw = CurTime()
		if self.Draw then self:Draw() end
		self.drawBullet = drawBullet
	end)
end

function SWEP:ReloadEnd()
	local owner = self:GetOwner()
	--owner:SetPlaybackRate(-1)
	self:InsertAmmo(1)
	self.ReloadNext = CurTime() + self.ReloadCooldown
	if SERVER then
		if not self.drawBullet then
			self.AnimStart_Draw = CurTime()
			self:Draw()
			net.Start("hgwep draw")
			net.WriteEntity(self)
			net.WriteBool(self.drawBullet)
			net.Broadcast()
			self:GetOwner():EmitSound("weapons/shotgun/shotgun_cock.wav")
		end
	end
end

--[[
function SWEP:ReloadDrawEnd()
	self.reloadDrawing = nil
	self.ReloadNext = CurTime() + self.ReloadDrawCooldown
	self:Draw()
end

function SWEP:ReloadAmmoEnd()
	self.ReloadNext = CurTime()  + self.ReloadInsertCooldown
	self:InsertAmmo(1)
	self.Primary.NextFire = CurTime() + self.ReloadInsertCooldownFire
end
--]]
function SWEP:PrimaryShootPost()
	self.ReloadNext = CurTime() + 0.5
end

function SWEP:AnimationPost()
	local animpos1 = self:GetAnimPos_Draw(CurTime())
	if animpos1 > 0 then
		local sin = 1 - animpos1
		if sin >= 0.5 then
			sin = 1 - sin
		else
			sin = sin * 2.5
		end

		self:BoneSetAdd(1, "l_clavicle", Vector(sin * -15, sin * -5, sin * -10), Angle(0, 0, 0))
	end
end

SWEP.UseCustomWorldModel = true
SWEP.WorldPos = Vector(5, -1, 0)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.DistSound = "toz_shotgun/toz_dist.wav"
if SERVER then
	util.AddNetworkString("hgwep reload")
end
if SERVER then return end
net.Receive("hgwep reload", function()
	local self = net.ReadEntity()
	local time = net.ReadFloat()
	if self.Reload then self:Reload(time) end
end)