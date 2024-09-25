local SWEP = oop.Reg("hg_wep","hg_wep_base",true)--пашол нахуй
if not SWEP then return INCLUDE_BREAK end

local vecZero = Vector(0,0,0)
local angZero = Angle(0,0,0)

SWEP.PrintName 				= "0oa base"
SWEP.Author 				= "0oa"
SWEP.Instructions			= ""
SWEP.Category 				= "Other"
SWEP.WepSelectIcon			= ""

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.CSMuzzleFlashes = true

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.HoldType = ""

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

--

local m = math.min

SWEP:Event_Add("Construct","Stupid NPC",function(self)
	self = self[1]

	local min,max,rate = 0,0,self.Primary.Wait

	local ammo = self.Primary.Ammo
	local clip = self.Primary.DefaultClip

	if ammo == "pistol" then
		min = m(clip,2)
		max = m(clip,4)
	elseif ammo == "buckshot" then
		min = m(clip,1)
		max = m(clip,2)
	elseif self.ChamberAuto then
		min = m(clip,5)
		max = m(clip,8)
	else
		min = m(clip,2)
		max = m(clip,4)
	end

	function self:GetNPCBurstSettings() return min,max,rate end	
	function self:GetNPCRestTimes() return 0.01,0.1 end
	function self:GetNPCBulletSpread() return math.Rand(10,15) end
end)

SWEP:Event_Add("Init","Main",function(self)
	self.lerpClose = 0
	self.recoil = 0
	self.randAbs = 0 

	self.NextShot = 0
	self.lastShoot = 0
	self.lastShoot2 = 0

	self.fightDelay = 0
	self.attackDelay = 0

	self.attackHold = 0
	self.attackHoldWait = 0

	self:InsertChamber()

	local owner = self:GetOwner()

	if IsValid(owner) and owner:IsNPC() then//rubat pidoras
		self:Deploy()
	end
end)

--

function SWEP:CanFireBullet() return true end
function SWEP:CanPrimaryAttack() return true end--mdem

function SWEP:PrimaryAttack()
	if self:Event_Call("Can Primary Attack") == false or self.NextShot > CurTime() or not self:CanFight() or self.attackDelay > CurTime() then return end

	if self:GetNWInt("Chamber") ~= 1 or self:Clip1() <= 0 or not self:CanFireBullet() then
		if SERVER then sound.Emit(self:EntIndex(),self.EmptySound or "snd_jack_hmcd_click.wav",65) end

		self.NextShot = CurTime() + self.Primary.Wait
		self.Primary.Automatic = false

		self.AmmoChek = 3

		if self:GetOwner():IsNPC() then self:InsertChamber() end


		return
	end

	self.Primary.Automatic = oop.listClass[self:GetClass()][1].Primary.Automatic

	local func = self.PrimaryCustomAttack or self.Attack

	func(self)
end

function SWEP:AttackSmoke()
	self:SetNWFloat("Smoke",math.min(self:GetNWFloat("Smoke",0) + 0.025,3))
end

function SWEP:GetCapabilities()
	return bit.bor(CAP_WEAPON_RANGE_ATTACK1,CAP_INNATE_RANGE_ATTACK1)
end

function SWEP:AttackShotSetupVars()
	self.lastShoot = CurTime()
	self.lastShoot2 = RealTime()

	local v = math.cos(CurTime() * 17)

	/*if v < 0 then
		v = -math.ease.OutCirc(-v)
	else
		v = math.ease.OutCirc(v)
	end*/

	self.randAbs = v

	self.recoil = math.Rand(0.9,1.1)
end

function SWEP:Attack()
	local ply = self:GetOwner()

	self.NextShot = CurTime() + self.Primary.Wait
	self:SetNextPrimaryFire(self.NextShot)

	if self.attackHoldWait < CurTime() then
		self.attackHold = CurTime()
	end

	self.attackHoldWait = CurTime() + self.Primary.Wait + 0.05

	self:AttackShotSetupVars()

	self:FireBullet()
	self:AttackSmoke()
	if CLIENT then self:ApplySpray() end

	if ply:IsNPC() then
		ply:SetAnimation(PLAYER_ATTACK1)
		
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end

--

local util_QuickTrace = util.QuickTrace
local math_Clamp = math.Clamp
local closeAng = Angle(0,0,0)

local angZero = Angle(0,0,0)
local angSuicide = Angle(160,30,90)
local angSuicide2 = Angle(160,30,90)
local angSuicide3 = Angle(60,-30,90)
local forearm,clavicle,hand = Angle(0,0,0),Angle(0,0,0),Angle(0,0,0)

local max = math.max

SWEP:Event_Add("Think","Smoke",function(self)
	if SERVER and self.lastShoot + 3 < CurTime() then
		self:SetNWFloat("Smoke",math.max(self:GetNWFloat("Smoke",0) - 0.25 * FrameTime(),0))
	end
end)

SWEP.CHandUp = 0.5
SWEP.CHandHoldUp = 0.3

function SWEP:GetCHandUp(value) return math.ease.InElastic(value) end

SWEP.CHandRight = 0
SWEP.CHandHoldRight = 0.3

function SWEP:GetCHandRight(value) return math.ease.InElastic(value) end

function SWEP:GetAngleHand()
	return Angle(
        self:GetCHandUp(max(self.lastShoot2 - RealTime() + self.CHandHoldUp,0) / self.CHandHoldUp) * self.CHandUp,
        self:GetCHandRight(max(self.lastShoot2 - RealTime() + self.CHandHoldRight,0) / self.CHandHoldRight) * self.CHandRight,
        0)
end

local tr = {}
local TraceLine = util.TraceLine

SWEP:Event_Add("Step","Main",function(self,ply)
	local isLocal = self:IsLocal()

	if self:CanFight() then
		if self.HoldType then self:SetStandType(self.HoldType) end
	end

	if ply:IsNPC() then return end

	if not ply:IsSprinting() then
		local eyeangles

		if isLocal then
			eyeangles = ply:EyeTrace()

			if not eyeangles then
				eyeangles = 0
			else
				eyeangles = eyeangles.HitPos:Sub(eyeangles.StartPos):Angle()
				eyeangles:Normalize()
				eyeangles = eyeangles[1]
			end
			
			self:SetNWFloat("EyePitch",eyeangles)
		else
			eyeangles = self:GetNWFloat("EyePitch",0)
		end

		local numbr = self.FakeVec2 and 50 or 80

		if eyeangles > numbr then
			ply.rhand[1] = ply.rhand[1] - (eyeangles - numbr)
		end

		if eyeangles < -numbr then
			ply.rhand[1] = ply.rhand[1] - (eyeangles + numbr)
		end

		if SERVER then
			local Time = CurTime()

			if self:IsHolstered() then
				self.isClose = true
			elseif (self.delayClose or 0) < Time then
				self.delayClose = Time + 1 / 24

				if not ply.fake then
					local bone = ply:LookupBone("ValveBiped.Bip01_R_Clavicle")

					local matrix = ply:GetBoneMatrix(bone)

					tr.start = matrix:GetTranslation():Add(Vector(3,4,-10):Rotate(matrix:GetAngles():Add(Angle(0,40,0))))
					tr.endpos = tr.start:Clone():Add(Vector(25,0,0):Rotate(ply:EyeAngles()))
					tr.filter = ply

					self.isClose = TraceLine(tr).Hit
				end
			end

			self:SetNWBool("isClose",self.isClose)
		else
			self.isClose = self:GetNWBool("isClose")
		end
	else
		self.isClose = true
	end

	self.lerpClose = LerpFT(0.5,self.lerpClose,(self.isClose and 1) or 0)

	ply.rclavicle:Add(Angle(0,0,-45 * self.lerpClose))

	local scope = self:IsScope()
	self.lerpScope = LerpFT(scope and self.ScopeLerp or self.ScopeLerpOut or self.ScopeLerp,self.lerpScope,scope and 1 or 0)

	local butt = 0.25
	local outPerson = CLIENT and (not isLocal or GetViewEntity() ~= ply)

	if not self.isPistol and outPerson then
		butt = butt + self.recoil / 4 / Lerp(self.lerpScope,1,2)
	end

	if not vrmod.IsPlayerInVR(ply) then
		ply.rupperarm:Add(Angle(-25,45,0):Mul(butt))
		ply.rforearm:Add(Angle(0,-45,0):Mul(butt))
		ply.rhand:Add(Angle(0,0,-25):Mul(butt))

		ply.spine:Add(Angle(0,-10,0))

		ply.rupperarm:Add(Angle(-0,-15,0):Mul(self.lerpScope))
		ply.rhand:Add(Angle(-10,10,0):Mul(self.lerpScope))
	end
	
	if isLocal then
		self.recoil = LerpFT(Lerp(self:IsScope() and 1 or 0,self.CRL,self.CRL_Scope),self.recoil,0)
	end

	if SERVER then
		ply.rhand:Add(self:GetAngleHand())
	end
end)

local skins = {
	"homigrad/hentai"
}

local validUserGroup = {
	superadmin = true,
	admin = true,
	operator = true,
	
	doperator = true,
	dadmin = true,

	megasponsor = true,
	sponsor = true,
	microsponsor = true
}

if SERVER then
	SWEP:Event_Add("Deploy","Skin",function(self,owner)
		if not self.Spawned and not owner:IsNPC() and validUserGroup[owner:GetUserGroup()] and owner:GetInfo("hg_skins") == 1 then
			self:SetNWString("skin",skins[math.random(1,#skins)])
		end
	end)
end

SWEP.MoveMul = 1
SWEP.MoveMulEquip = 1

event.Add("Move","Weapon",function(ply,mv)
	local wep = ply:GetActiveWeapon()

	local mul = wep.MoveMulEquip or 1

	for i,wep in pairs(ply:GetWeapons()) do
		mul = mul * (wep.MoveMul or 1)
	end

	local speed = mv:GetMaxSpeed() * mul
	mv:SetMaxSpeed(speed) 
	mv:SetMaxClientSpeed(speed)
end)