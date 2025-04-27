SWEP.Base = "homigrad_base"
SWEP.PrintName = "Remington 870"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/zcity/w_shot_m3juper90.mdl"

SWEP.CorrectPos = Vector(-2,1,-0.5)
SWEP.CorrectAng = Angle(0,6,0)

SWEP.HolsterPos = Vector(5,-8,-5)
SWEP.HolsterAng = Angle(0,-25,180)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.HoldType = "ar2"
SWEP.BoltBone = "Slide"
SWEP.BoltVec = Vector(0,0,-3.2)
SWEP.BoltManual = true
SWEP.NumBullet = 8
SWEP.IsShotgun = true
SWEP.Pumped = true
SWEP.TwoHands = true

SWEP.ZoomPos = Vector(-2,-0.8,-5.45)
SWEP.ZoomAng = Angle(0,4,0)
SWEP.AttPos = Vector(46,0.85,5.3)
SWEP.AttAng = Angle(-4,-0.1,0)

SWEP.IconPos = Vector(10,30,-6.5)
SWEP.IconAng = Angle(-15,0,0)

SWEP.Primary.Damage = 15
SWEP.Primary.Force = 60
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/shtg_berettasv10/beretta_fire_01.wav"
SWEP.Pump = 0
SWEP.PumpEnd = false
SWEP.PumpTarg = 0

local function easedLerp(fraction, from, to)
	return LerpFT(math.ease.InSine(fraction), from, to)
end

function SWEP:PostAnim()
	if self.BoltBone != nil and IsValid(self.worldModel) then
		local bone = self.worldModel:LookupBone(self.BoltBone)

		self.animmul = easedLerp(0.45,self.animmul,self.PumpTarg)

		self.worldModel:ManipulateBonePosition(bone,self.BoltVec * self.animmul)
	end

    self.Pump = easedLerp(0.45,self.Pump,self.PumpTarg)

    local PumpAngs = Angle(-10,30,-30)

    local ply = self:GetOwner()

    local hand_index = ply:LookupBone("ValveBiped.Bip01_R_Hand")
	local forearm_index = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
	local clavicle_index = ply:LookupBone("ValveBiped.Bip01_R_Clavicle")


	local attPos, attAng = self:GetTrace()
	local matrix = ply:GetBoneMatrix(hand_index)
	if not matrix then return end
	local plyang = ply:EyeAngles()
	plyang:RotateAroundAxis(plyang:Forward(),0)

	local _,newAng = LocalToWorld(vector_origin,self.localAng or angle_zero,vector_origin,plyang)
	local ang = newAng
    if CLIENT and self:GetOwner() == LocalPlayer() then
		ang:Add(Angle(-(self.Primary.Force / 4.5) * Recoil,0,0))
	end
    ang:Add(PumpAngs * self.Pump)
	ang:RotateAroundAxis(ang:Forward(),180)
	if not self:IsSprinting() then
	matrix:SetAngles(ang)
	end

	local lpos, lang = ply:SetBoneMatrix2(hand_index, matrix, false)
end

function SWEP:Reload()
    if !self.Pumped and self.PumpTarg == 0 then
        self.PumpTarg = 1
        self.PumpEnd = false
        if SERVER then
            sound.Play("zcitysnd/sound/weapons/ak47/handling/ak47_boltback.wav",self:GetPos(),70,100,1,0)
        end
        timer.Simple(0.1,function()
            if SERVER then
                sound.Play("zcitysnd/sound/weapons/ak47/handling/ak47_boltrelease.wav",self:GetPos(),70,100,1,0)
            end
            self.PumpTarg = 0
            self.Pumped = true
            self.NextShoot = CurTime() + 0.3
            timer.Simple(0.5,function()
                self.PumpEnd = true
            end)
        end)
    elseif self.Pumped and self.PumpTarg == 0 and self.PumpEnd then
        self:ReloadFunc()
    end

    if SERVER then
        net.Start("hg reload")
        net.WriteEntity(self)
        net.Broadcast()
    end
end

function SWEP:CanShoot()
    return (!self.Reloading and !self.Inspecting and self:Clip1() > 0 and self.Pumped and !self:IsSprinting())
end

function SWEP:PrimaryAdd()
    self.Pumped = false
end

local function easedLerp(fraction, from, to)
	return LerpFT(math.ease.InSine(fraction), from, to)
end