local SWEP = oop.Get("hg_wep")
if not SWEP then return end

--1 есть
--0 нету

function SWEP:InsertChamber(force)
	if self:GetNWInt("Chamber",0) == 1 then return end
	
	self:RemoveChamber()

	if force or self:Clip1() > 0 then
		self:SetNWInt("Chamber",1)

		return true
	end
end

function SWEP:RemoveChamber(firce)
	if self:GetNWInt("Chamber",0) == 0 then return end
	self:SetNWInt("Chamber",0)

	if SERVER then
		self:RejectShell(self.Shell)
	end
end

function SWEP:SetClipPos(value)
	local bone = self.BoltBone
	if not bone then return end
	
	local gun = self:GetGun()

	local bone = gun:LookupBone(bone)
	if not bone then return end
	
	gun:ManipulateBonePosition(bone,Vector(-value * (self.BoltMulY or 0),-value * (self.BoltMulX or 0),-value * (self.BoltMul or 1)),false)
end

SWEP:Event_Add("Think","Chamber",function(self)
	local bone = self.BoltBone

	if self.ChamberAuto and bone then
		local value = math.Clamp((self.lastShoot2 + 0.1 - RealTime()) / 0.1,0,1)
		if self.BoltEmpty and self:Clip1() == 0 then value = 1 end

		self:SetClipPos(value)
	end
end)

--

function SWEP:GetRejectShell(gun)
	local att = gun:GetAttachment(gun:LookupAttachment("ejectbrass")) or gun:GetAttachment(gun:LookupAttachment("shell")) or gun:GetAttachment(gun:LookupAttachment(2))
	local pos,ang

	if not att then
		pos,ang = gun:GetPos(),gun:GetAngles()
	else
		pos,ang = att.Pos,att.Ang
	end

	return pos,ang
end

local hg_best_shells

if SERVER then
	util.AddNetworkString("Shell")
else
	net.Receive("Shell",function()
		local wep = net.ReadEntity()
		if not IsValid(wep) or not wep.RejectShell then return end--rubat pidor wtf

		wep:RejectShell(wep.Shell)
	end)

	cvars.CreateOption("hg_best_shells","1",function(value) hg_best_shells = tonumber(value) end,"-1","1")
end

local list = {
	["EjectBrass_556"] = "models/weapons/shells/shell_sniperrifle.mdl",
	["ShotgunShellEject"] = "models/weapons/shells/shell_shotgun.mdl"
}

function SWEP:RejectShell(shell)
	if not shell then return end

	if SERVER then
		net.Start("Shell")
		net.WriteEntity(self)
		net.SendPVS(self:GetPos())
		
		return
	else
		if hg_best_shells == -1 then return end
		if hg_best_shells == 0 and self:GetOwner() ~= LocalPlayer() then return end
	end

	local gun,isFake = self:GetGun()
	local pos,ang = self:GetRejectShell(gun)

	if self.EjectAng then ang:Rotate(self.EjectAng) end

	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetAngles(ang)
	effectdata:SetEntity(self)
	effectdata:SetFlags(25)

	util.Effect(shell,effectdata,true,true)

	//if SERVER then DropProp(pos,ang:RotateAroundAxis(ang:Right(),90),list[shell] or "models/weapons/shells/shell_sniperrifle.mdl",0.5,ang:Right():Mul(125 * math.Rand(0.9,1.1))) end
end