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
SWEP.ZoomAng = Angle(0,6,0)
SWEP.AttPos = Vector(44,0.85,8.7)
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
    local ply = self:GetOwner()
	if self.BoltBone != nil and IsValid(self.worldModel) then
		local bone = self.worldModel:LookupBone(self.BoltBone)

		self.animmul = easedLerp(0.45,self.animmul,self.PumpTarg)

		self.worldModel:ManipulateBonePosition(bone,self.BoltVec * self.animmul)
	end

    if ply:GetNWBool("suiciding") then
        return
    end

    self.Pump = easedLerp(0.55,self.Pump,self.PumpTarg)

    if self.Pump > 0.1 then
        local p1,a1 = ply:GetBoneMatrix(11):GetTranslation(),ply:GetBoneMatrix(11):GetAngles()
        a1:RotateAroundAxis(a1:Up(),-10)
        a1:RotateAroundAxis(a1:Right(),-5)
        self.shitang = a1
    end

    local PumpAngs = Angle(-50,-30,0)

    if self:IsPistolHoldType() then
        if self:IsSprinting() and !self:IsSighted() then
            hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(0,0,0),1,0.4)
            hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,0),1,0.4)
            hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(-5,0,-60),1,0.4)
        else
            hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(0,0,0),1,0.4)
            hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,0),1,0.4)
            hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(0,0,0),1,0.4)
        end
    else
        if self:IsSprinting() and !self:IsSighted() then
            hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(0,0,0),1,0.3)
            hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,-30),1,0.3)
            hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(-5,0,-30),1,0.3)
        else
            hg.bone.Set(ply,"r_forearm",Vector(0,0,0),PumpAngs * self.Pump,1,0.3)
            hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,0),1,0.3)
            hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(0,0,0),1,0.3)
        end
    end
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