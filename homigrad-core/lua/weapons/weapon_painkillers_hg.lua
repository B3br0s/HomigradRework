SWEP.Base = "med_base"
SWEP.PrintName = "Болеутоляющие"
SWEP.Category = "Медицина"
SWEP.Spawnable = true

SWEP.WorldModel = "models/w_models/weapons/w_eq_painpills.mdl"

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(0,0,0)
SWEP.CorrectScale = 1

SWEP.IconPos = Vector(20.5,110,-5)
SWEP.IconAng = Angle(0,-90,40)

SWEP.HealSound = "zcity/healing/bloodbag_start_0.wav"
SWEP.HealSoundEnd = "zcity/healing/tablets_close_3.wav"

function SWEP:Heal(ply)
    if !ply then
        ply = self:GetOwner()
    end
    if SERVER then
        ply.painlosing = math.Clamp(ply.painlosing + math.random(2,3),1,10)
    end
end

function SWEP:Initialize()
    hg.Weapons[self] = true
    self:SetHoldType(self.HoldType)

    self.Uses = 4
end

function SWEP:Step_Anim()
    local ply = self:GetOwner()

    if self:IsAttacking(ply) then
        hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-50,0),1,0.125)
        hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(10,-20,0),1,0.125)
        hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(60,-20,-20),1,0.125)
    elseif self:IsSAttacking(ply) then
        hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-40,0),1,0.075)
        hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(10,25,0),1,0.125)
        hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(-30,0,10),1,0.075)   
    else
        hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-40,0),1,0.075)
        hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(20,-10,0),1,0.075)
        hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(0,0,10),1,0.075)   
        self.LastUse = CurTime() + 0.5
    end
end