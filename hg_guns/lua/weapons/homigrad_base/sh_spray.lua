AddCSLuaFile()

function SWEP:Initialize_Spray()
	self.EyeSpray = Angle(0, 0, 0)
	self.SprayI = 0
	self.dmgStack = 0
end

SWEP.SpreadMulZoom = 1.5
SWEP.SpreadMul = 2
SWEP.CrouchMul = 0.75
SWEP.EyeSprayVel = Angle(0,50,0)
SWEP.RecoilWay = 0
SWEP.sprayI = 0
SWEP.Recoil = Angle(0,0,0)
SWEP.Spray = {}
SWEP.rec = 0
for i = 1, 150 do
	SWEP.Spray[i] = Angle(-0.02 - math.cos(i) * 0.01, math.cos(i * i) * 0.01, 0)
end

SWEP.SprayRand = {Angle(0, 0, 0), Angle(0, 0, 0)}
SWEP.addSprayMul = 1
local cos, sin, math_max, math_min = math.cos, math.sin, math.max, math.min
function SWEP:GetPrimaryMul()
	local owner = self:GetOwner()
	local mul = ((0.5) + math_max(self.Primary.Force / 110 - 1, 0)) * (owner.Crouching and owner:Crouching() and self.CrouchMul or 1) * (self.attachments and self.attachments.barrel and self.attachments.barrel[1] ~= "empty" and 0.75 or 1)
	self:ApplyForce(mul)
	mul = (mul or 0) * (self.Supressor and 0.75 or 1)
	return mul
end

SWEP.sprayAngles = Angle(0,0,0)

SWEP.weaponSway = Angle(0,0,0)

function SWEP:PrimarySpread()
	self.lastShoot = SysTime()
	
	local owner = self:GetOwner()
	local mul = self:GetPrimaryMul()
	self.dmgStack = self.dmgStack + self.Primary.Damage
	self.RecoilWay = math.random(-1,1)
	self.sprayI = self.sprayI + 0.05
	local sprayI = self.sprayI
	if self.RecoilWay == 0 then
		self.RecoilWay = 1
	end

	if CLIENT and (owner == LocalPlayer()) or (CLIENT and not LocalPlayer():Alive() and owner == LocalPlayer():GetNWEntity("spect",NULL) and LocalPlayer():GetNWInt("viewmode",0) == 1) then
		
		local force = self.Primary.Damage / 15 * self.addSprayMul * (self.NumBullet or 1) * math.min(sprayI / 30,1) + (self.Primary.Force / self.Primary.Force / 32)
		
		self.Recoil = Angle(-force * 2,(math.random(-self.SprayI / 256,self.SprayI / 256)) * self.RecoilWay,0)
		local angRand = self.Recoil
		--angRand[1] = -math.abs(angRand[1])
		angRand[3] = 0
		local spray = angRand
		--spray = spray + AngleRand(self.SprayRand[1], self.SprayRand[2]) * self.addSprayMul
		
		local angrand2 = Angle(-force, force,0)
		local angrand3 = angRand

		local sprayAng = spray * 8 + angrand3 * (1.5) * self.addSprayMul * (self.Primary.Force / 25)
		sprayAng[3] = 0
		
		self.rec = LerpAngleFT(1,owner:EyeAngles(),owner:EyeAngles() + sprayAng)

		owner:SetEyeAngles(self.rec)
		Viewpunch(angRand)

		local sprayvel = spray * mul * math.max(sprayI / self:GetMaxClip1(), 0.5) * self.addSprayMul * (self.cameraShakeMul or 1)

		self:ApplyEyeSpray(angRand)
		self:ApplyEyeSprayVel(angRand)
		self:AnimApply_RecoilCameraZoom()
	end
end

function SWEP:ApplyForce(mul)
	local fakeGun = self:GetNWEntity("fakeGun")
	mul = mul * self.Primary.Damage / 60 * (self.NumBullet or 1)
	if IsValid(fakeGun) then
		if SERVER then
			local owner = self:GetOwner()
			local ent = hg.GetCurrentCharacter(owner)
			local fakeGunObj = fakeGun:GetPhysicsObject()

			if ent ~= owner then
				ent:GetPhysicsObjectNum(self.LHandPos and 6 or 6):ApplyForceOffset(owner:EyeAngles():Forward() * -50,fakeGunObj:GetPos())
			end

		end
		return true
	end
end

--if CLIENT then
local angZero = Angle(0, 0, 0)
function SWEP:ApplyEyeSprayVel(value)
	self.EyeSprayVel = self.EyeSprayVel + value * 0.2
	self:ApplyEyeSpray(self.EyeSprayVel)
	--self.AdditionalAng = self.AdditionalAng + Angle(-math.Rand(self.EyeSprayVel[1] * 1 ,self.EyeSprayVel[1] * 2),math.Rand(self.EyeSprayVel[2] * 2 ,self.EyeSprayVel[2] * 5),-self.EyeSprayVel[2] * 10)
	--self.AdditionalPos[1] = self.AdditionalPos[1] + self.EyeSprayVel[1] * 15
end

function SWEP:Step_SprayVel(dtime)
	self.EyeSprayVel = self.EyeSprayVel or Angle(0, 0, 0)
	self.EyeSprayVel = self.EyeSprayVel - self.EyeSprayVel * hg.lerpFrameTime2(0.15,dtime)--self.EyeSpray * 0.04
	self:ApplyEyeSpray(self.EyeSprayVel)
end

function SWEP:ApplyEyeSpray(value)
	if CLIENT and self:GetOwner() ~= LocalPlayer() then return end
	value[1] = math.Clamp(value[1] * 1.5,0,80)
	value[2] = value[2] * self.RecoilWay
	self.EyeSpray = self.EyeSpray + value * 0.001 // * 0.2 * (FrameTime() / engine.TickInterval())
end

function SWEP:Step_Spray(time,dtime)
	if self.NextShoot + 0.3 < time then self.SprayI = 0 end
	if self.NextShoot + 1 < time then self.dmgStack = 0 end
	self.Recoil[1] = LerpFT(0.3,self.Recoil[1],0)
	if self.Recoil[1] >= 20 then
		self.Recoil[1] = 20
	end
	self.sprayI = LerpFT(0.1,self.sprayI,0)
	if SERVER then return end
	local eyeSpray = self.EyeSpray
	self:GetOwner():SetEyeAngles(self:GetOwner():EyeAngles() + eyeSpray)
	eyeSpray:Set(LerpAngleFT(0.1,eyeSpray,Angle(0,0,0)))
end

--[[else
	function SWEP:ApplyEyeSpray(value) end
	function SWEP:ApplyEyeSprayVel(value) end
end--]]
SWEP.ZoomFOV = 20
function SWEP:AdjustMouseSensitivity()
	--return self:IsZoom() and self:HasAttachment("sight") and (math.min(self.ZoomFOV / 10, 0.5) or 0.5) or 1
end