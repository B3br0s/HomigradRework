AddCSLuaFile()
-- THX 123d_255
if SERVER then
	util.AddNetworkString("muzzlenormalizator")
	net.Receive("muzzlenormalizator", function(STROKI, debil)
		local pos = net.ReadVector()
       	local weaponxd = net.ReadEntity()
    	local ang = net.ReadAngle()

        if not debil == weaponxd:GetOwner() then 
        else
        	weaponxd:Setmuzzlepos(pos) 
        	weaponxd:Setmuzzleang(ang)
        end
	end)
end
local surface_hardness = {
	[MAT_METAL] = 0.9,
	[MAT_COMPUTER] = 0.9,
	[MAT_VENT] = 0.9,
	[MAT_GRATE] = 0.9,
	[MAT_FLESH] = 0.5,
	[MAT_ALIENFLESH] = 0.3,
	[MAT_SAND] = 0.1,
	[MAT_DIRT] = 0.9,
	[74] = 0.1,
	[85] = 0.2,
	[MAT_WOOD] = 0.5,
	[MAT_FOLIAGE] = 0.5,
	[MAT_CONCRETE] = 0.9,
	[MAT_TILE] = 0.8,
	[MAT_SLOSH] = 0.05,
	[MAT_PLASTIC] = 0.3,
	[MAT_GLASS] = 0.6,
}

local player_GetAll = player.GetAll
local function BulletEffects(tr, self)
end

if SERVER then
	hook.Add("PlayerPostThink", "sexdfgfgf", function(ply)
		local wep = ply:GetActiveWeapon()
		if not wep or !IsValid(wep) then return end
	end)
	util.AddNetworkString("bullet_fell")
	util.AddNetworkString("tobullet")
	util.AddNetworkString("blood particle")
	BulletEffects = function(tr, self)
		net.Start("bullet_fell")
		net.WriteTable(tr)
		net.WriteEntity(self)
		net.Broadcast()
	end
end

local function BloodTr(att, tr, dmgInfo)
	--util.Decal("Impact.Flesh",tr.HitPos + tr.HitNormal,tr.HitPos - tr.HitNormal)
	if SERVER then
		net.Start("blood particle")
		net.WriteVector(tr.StartPos)
		net.WriteVector((tr.HitPos - tr.StartPos):GetNormalized() * dmgInfo:GetDamage() * 2 + VectorRand(-50, 50))
		net.Broadcast()
	end
end

local function callbackBullet(self, tr, ply, fleshPen)
	self = self.fakeOwner or self
	local dir, hitNormal, hitPos = tr.Normal, tr.HitNormal, tr.HitPos
	if SERVER then BulletEffects(tr, self) end
	local hardness = surface_hardness[tr.MatType] or 0.5
	local ApproachAngle = -math.deg(math.asin(hitNormal:DotProduct(dir)))
	local MaxRicAngle = 60 * hardness
	-- all the way through
	if ApproachAngle > MaxRicAngle * 1.2 then
		local Pen = (self.Penetration or 5) * 3 or self.Primary.Damage
		local MaxDist, SearchPos, SearchDist, Penetrated = Pen / hardness * 0.15 * 5, hitPos, 5, false
		while not Penetrated and SearchDist < MaxDist do
			SearchPos = hitPos + dir * SearchDist
			local PeneTrace = util.QuickTrace(SearchPos, -dir * SearchDist)
			if not PeneTrace.StartSolid and PeneTrace.Hit then
				Penetrated = true
			else
				SearchDist = SearchDist + 5
			end
		end

		if Penetrated then
			self:FireBullets({
				Attacker = self:GetOwner(),
				Damage = 1,
				Force = 0,
				Num = 1,
				Tracer = 0,
				TracerName = "",
				Dir = -dir,
				Spread = Vector(0, 0, 0),
				Src = SearchPos + dir
			})

			if fleshPen then
				local effectdata = EffectData()
				effectdata:SetOrigin(SearchPos - dir * 4)
				effectdata:SetMagnitude(1)
				effectdata:SetFlags(1)
				effectdata:SetNormal(dir)
				effectdata:SetScale(3)
				util.Effect("bloodspray",effectdata)
			end
			self:FireBullets({
				Attacker = self:GetOwner(),
				Damage = self.Primary.Damage * 0.65,
				Force = self.Primary.Damage / 15,
				Num = 1,
				Tracer = 0,
				TracerName = "",
				Dir = dir,
				Spread = Vector(0, 0, 0),
				Src = SearchPos + dir,
				Callback = nil
			})
		end
	elseif ApproachAngle < MaxRicAngle * .2 then
		-- ping whiiiizzzz
		sound.Play("snd_jack_hmcd_ricochet_" .. math.random(1, 2) .. ".wav", hitPos, 75, math.random(90, 100))
		local NewVec = dir:Angle()
		NewVec:RotateAroundAxis(hitNormal, 180)
		NewVec = NewVec:Forward()
		self:FireBullets({
			Attacker = self:GetOwner(),
			Damage = (self.Primary.Damage or 1) * .85,
			Force = (self.Primary.Damage or 1) / 15,
			Num = 1,
			Tracer = 0,
			TracerName = "",
			Dir = -NewVec,
			Spread = Vector(0, 0, 0),
			Src = hitPos + hitNormal
		})
	end
end

local function bulletHit(ply, tr, dmgInfo)
	local fleshPen = false
	if tr.MatType == MAT_FLESH then
		util.Decal("Impact.Flesh", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		fleshPen = true
	end

	local inflictor = ply:GetActiveWeapon()
	callbackBullet(inflictor, tr, ply, fleshPen)
end

local bullet = {}
local empty = {}
local vecCone = Vector(0, 0, 0)
local cone, att, att2, owner, primary, ang
local math_Rand, math_random = math.Rand, math.random
local gun
function SWEP:GetWeaponEntity()
	gun = self:GetNWEntity("fakeGun")
	return IsValid(gun) and gun or self.worldModel or self
end

SWEP.attPos = Vector(0, 0, 0)
SWEP.attAng = Angle(0, 0, 0)
local gun
local vecZero = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local attTbl = {
	Pos = vecZero,
	Ang = angZero
}

function SWEP:GetMuzzleAtt(ent, trueAtt, supressorAdd)
	gun = ent or self:GetWeaponEntity()
	if not IsValid(gun) then return attTbl end
	local att = gun:GetAttachment(gun:LookupAttachment("muzzle"))
	local att = att ~= nil and att or gun:GetAttachment(gun:LookupAttachment("muzzle_flash"))
	--local att = gun:GetAttachment(gun:LookupAttachment("muzzle"))
	--local att = att!=nil and att or gun:GetAttachment(gun:LookupAttachment("muzzle_flash"))
	local attPos = self.attPos
	local attAng = self.attAng
	if not att then
		local angHuy = gun:GetAngles()
		angHuy:RotateAroundAxis(angHuy:Forward(), 90)
		angHuy:Add(attAng)
		local posHuy = gun:GetPos()
		posHuy:Add(angHuy:Up() * attPos[1] + angHuy:Right() * attPos[2] + angHuy:Forward() * attPos[3])
		if supressorAdd and self:HasAttachment("barrel", "supressor") then posHuy:Add(angHuy:Forward() * 5) end
		attTbl.Pos = posHuy
		attTbl.Ang = angHuy
		return attTbl
	end

	if trueAtt then
		local pos, ang = att.Pos, att.Ang
		local pos, ang = LocalToWorld(attPos, attAng, pos, ang)
		att.Pos = pos
		att.Ang = ang
		--ang:Add(attAng)
		if supressorAdd and self:HasAttachment("barrel", "supressor") then pos:Add(ang:Forward() * 5) end
		--pos:Add(ang:Up() * attPos[1] + ang:Right() * attPos[2] + ang:Forward() * attPos[3])
	end
	return att
end

local tr = {}
local att
local util_TraceLine = util.TraceLine
function SWEP:GetHitPos()
	att = self:GetMuzzleAtt(nil, true)
	if not att then return end
	--local quicktr = util.QuickTrace(att.Pos,-att.Ang:Forward() * 60,self:GetOwner())
	--tr.start = quicktr.HitPos
	tr.start = att.Pos - att.Ang:Forward() * 60
	tr.endpos = att.Pos + att.Ang:Forward() * 8000
	tr.filter = {self:GetOwner(), self, self:GetNWEntity("fakeGun"), self:GetOwner().FakeRagdoll}
	return util_TraceLine(tr).HitPos
end

function SWEP:GetTrace()
	att = self:GetMuzzleAtt(nil, true)
	if not att then return end
	local owner = self:GetOwner()
	tr.start = att.Pos - att.Ang:Forward() * 60
	tr.endpos = att.Pos + att.Ang:Forward() * 8000
	tr.filter = {gun, not owner.suiciding and owner or nil}
	return util_TraceLine(tr)
end

SWEP.ShellEject = "EjectBrass_556"
local vecZero = Vector(0, 0, 0)
local image_distort = "sprites/heatwave"

function SWEP:FireBullet()
	if CLIENT then
		FovAdd = (FovAdd and FovAdd - 8 or -8)
	end
	local gun = self:GetWeaponEntity()
	local att = self:GetMuzzleAtt(gun, true)
	local pos, ang = self:Getmuzzlepos(), self:Getmuzzleang()
	local owner = self:GetOwner()
	local fakeGun = self:GetNWEntity("fakeGun")
	local tr = util.TraceLine({
		start = pos - ang:Forward() * ((owner.FakeRagdoll or owner.suiciding) and 0 or 60),
		endpos = pos,
		filter = {gun, not owner.suiciding and self:GetOwner() or nil},
		mask = MASK_SHOT,
		collisiongroup = COLLISION_GROUP_NONE
	})
	pos = tr.HitPos
	local primary = self.Primary
	owner:LagCompensation(true)
	bullet.Num = self.NumBullet
	bullet.Src = pos
	bullet.Dir = ang:Forward()--owner.suiciding and -(pos - owner:GetAttachment(owner:LookupAttachment("eyes")).Pos):GetNormalized() or ang:Forward()
	local cone = self.Primary.Cone
	vecCone[1] = cone
	vecCone[2] = cone
	bullet.Spread = vecCone
	bullet.Force = 5
	bullet.Damage = primary.Damage or 25
	bullet.Spread = self.Primary.Spread or 0
	bullet.AmmoType = primary.Ammo
	bullet.Attacker = owner
	bullet.IgnoreEntity = not owner.suiciding and owner or nil
	bullet.Callback = bulletHit
	bullet.Damage = bullet.Damage * (self.Supressor and 0.9 or 1)
	if SERVER then
		local tr = self:GetTrace()
	end
	--for i=1,(self.NumBullet or 1) do
	if IsValid(fakeGun) then fakeGun:SetOwner() end
	--if SERVER then
	gun:FireBullets(bullet)
	--end
	if IsValid(fakeGun) then fakeGun:SetOwner(owner.FakeRagdoll) end
	--end
	owner:LagCompensation(false)
	if CLIENT then
		local mul = self.MuzzleMul or 1
		mul = mul * (self.Supressor and 0.25 or 1)
		if mul > 0 then
			local effectdata = EffectData()
			effectdata:SetOrigin(att.Pos + (self.Supressor and (att.Ang:Forward() * 15) or vecZero))
			effectdata:SetAngles(ang)
			effectdata:SetScale(mul)
			if not self.Supressor then util.Effect("MuzzleEffect", effectdata) end
			local emitter = ParticleEmitter(pos)
			local particle = emitter:Add(image_distort, pos)
			if particle then
				particle:SetVelocity((ang:Forward() * 25) + 1.05 * owner:GetVelocity())
				particle:SetLifeTime(0)
				particle:SetDieTime(math.Rand(0.1, 0.2))
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(7, 10))
				particle:SetEndSize(0)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-2, 2))
				particle:SetAirResistance(5)
				particle:SetGravity(Vector(0, 0, 40))
				particle:SetColor(255, 255, 255)
			end

			local dlight = DynamicLight(gun:EntIndex())
			dlight.pos = att.Pos
			dlight.r = math_random(245, 255)
			dlight.g = math_random(245, 255)
			dlight.b = math_random(150, 200)
			dlight.brightness = math_Rand(7, 8)
			dlight.Decay = 1000
			dlight.Size = math_Rand(60, 75) * mul
			dlight.DieTime = CurTime() + 1 / 60
		end
	end
end

function SWEP:RejectShell(shell)
	if not shell then return end
	local gun = self:GetWeaponEntity()
	if not IsValid(gun) then return end
	local att = gun:GetAttachment(gun:LookupAttachment("ejectbrass")) or gun:GetAttachment(gun:LookupAttachment("shell"))
	local pos, ang
	if not att then
		pos, ang = gun:GetPos(), gun:GetAngles()
	else
		pos, ang = att.Pos, att.Ang
	end

	if gun == self:GetNWEntity("fakeGun") then shell = shell ~= "ShotgunShellEject" and "ShellEject" or "ShotgunShellEject" end
	if self.EjectAng then ang:Add(self.EjectAng) end
	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetAngles(ang)
	effectdata:SetFlags(25)
	util.Effect(shell, effectdata)
end