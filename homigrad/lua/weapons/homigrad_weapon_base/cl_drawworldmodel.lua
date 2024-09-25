local SWEP = oop.Get("hg_wep")
if not SWEP then return end

function SWEP:DrawSetupSkin(gun)
    gun:SetSubMaterial(0,self:GetNWString("skin"))
	gun:SetSubMaterial(1,self:GetNWString("skin"))

    self:DrawSetupSkinPost(gun)
end

function SWEP:DrawSetupSkinPost() end

local mat_muzzle = Material("particle/muzzle_flame_01")

SWEP.MuzzleSprites = {}

function SWEP:DrawMuzzle(gun)
	local pos,ang = self:GetMuzzlePos(gun)

	local time = RealTime()

	render.SetMaterial(mat_muzzle)

	local tbl = self.MuzzleSprites

	for part in pairs(tbl) do
		local s = part.s

		render.DrawSprite(pos:Clone():Add(part.pos),s,s,part.color)

		if part.dietime < time then tbl[part] = nil end
	end
end

function SWEP:DrawWorld()//вызывается когда объект появляется на экране (мир)
    local owner = self:GetOwner()

	local gun
	
    if IsValid(owner) then
		local fakeGun = self:HasFake()
		
		if fakeGun then
			gun = fakeGun
		elseif self.EnableTransformModel then
            gun = self:InitWorldModel()

            local Pos,Ang = self:GetTransformWorldModel()
            if not Pos then return end--;c;;cc
            
            gun:SetRenderOrigin(Pos)
            gun:SetRenderAngles(Ang)
        end
    else
        gun = self:InitWorldModel()
        
        gun:SetRenderOrigin(self:GetPos():Add(self.wmVectorDrop:Clone():Rotate(self:GetAngles())))
        gun:SetRenderAngles(self:GetAngles())
    end

    self:Render(gun)
end

function SWEP:Render(gun)
    self:DrawSetupSkin(gun)
    gun:DrawModel()

    if IsValid(self) and EyePos():Distance(gun:GetPos()) <= 500 then self:DrawSmoke(gun) end
	
	self:DrawMuzzle(gun)

    self:DrawWorldModelPost(gun)
end

function SWEP:DrawWorldModelPost(gun) end

local white = Color(255,255,160)
local mat = Material("mat_jack_gmod_shinesprite")
local random,Rand = math.random,math.Rand

local cos = math.cos

function SWEP:DrawSmoke(gun)
	local Time = RealTime()
	if (self.delaySmoke or 0) > Time then return end
	self.delaySmoke = Time + 1 / 24

	local smoke = math.min(self:GetNWFloat("Smoke",0),3) / 3
	local k = math.max((self.lastShoot + 1 - CurTime()),0)

	smoke = smoke * (1 - k)
	if smoke <= 0 then return end

	local pos,ang = self:GetMuzzlePos(gun)
	local dir = Vector(1,0,0):Rotate(ang)

	local emitter = ParticleEmitter(pos)

	local part = emitter:Add(mat,pos:Add(Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
	if part then
		part:SetDieTime(Rand(1,2))

		local p = random(35,65)
		part:SetColor(p,p,p)

		part:SetStartAlpha(Rand(15,25) * smoke)
		part:SetEndAlpha(0)

		part:SetStartSize(Rand(3,4))
		part:SetStartLength(Rand(4,8))
		part:SetEndLength(Rand(12,15))
		part:SetEndSize(Rand(8,14))

		part:SetVelocity(Vector(0.01,0,Rand(12,22)):Rotate(Angle(0,cos(Time * 3 + self:EntIndex()) * 7,0)):Add(Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
	end

	emitter:Finish()
end