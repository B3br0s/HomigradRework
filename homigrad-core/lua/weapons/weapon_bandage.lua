SWEP.Base = "med_base"
SWEP.PrintName = "Бинт"
SWEP.Category = "Медицина"
SWEP.Spawnable = true

SWEP.WorldModel = "models/bandage/bandage.mdl"

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true

SWEP.CorrectAng = Angle(0,90,0)
SWEP.CorrectPos = Vector(2.8,-0.4,2)
SWEP.CorrectScale = 0.8

SWEP.IconPos = Vector(18.5,90,-2.5)
SWEP.IconAng = Angle(30,0,-80)

function SWEP:Heal(ply)
    if !ply then
        ply = self:GetOwner()
    end
    if SERVER then
        if ply.bleed > 0 then
            ply.blood = math.Clamp(ply.blood + 25,0,5000)
        end
        ply.bleed = math.Clamp(ply.bleed - math.random(10,30),0,1000)
    end
end