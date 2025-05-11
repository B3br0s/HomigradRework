SWEP.Base = "med_base"
SWEP.PrintName = "Аптечка"
SWEP.Category = "Медицина"
SWEP.Spawnable = true

SWEP.WorldModel = "models/w_models/weapons/w_eq_medkit.mdl"

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true

SWEP.CorrectAng = Angle(90,0,0)
SWEP.CorrectPos = Vector(0.9,-4.7,2.2)
SWEP.CorrectScale = 0.8

SWEP.HealSounds = {
    "zcity/healing/bandage_loop_0.wav",
    "zcity/healing/bandage_loop_1.wav",
    "zcity/healing/bandage_loop_2.wav",
    "zcity/healing/bandage_loop_3.wav",
    "zcity/healing/cleanwound_loop_0.wav",
    "zcity/healing/cleanwound_loop_1.wav",
    "zcity/healing/cleanwound_loop_2.wav",
    "zcity/healing/cleanwound_loop_3.wav",
    "zcity/healing/disinfectant_loop_0.wav",
    "zcity/healing/disinfectant_loop_1.wav",
    "zcity/healing/disinfectant_loop_2.wav",
    "zcity/healing/disinfectant_loop_3.wav",
}
SWEP.HealSound = "zcity/healing/morphine_spear_2.wav"
SWEP.HealSoundEnd = "zcity/healing/bandage_end_0.wav"

function SWEP:Heal(ply)
    if !ply then
        ply = self:GetOwner()
    end
    self.HealSound = table.Random(self.HealSounds)
    if SERVER then
        ply.blood = math.Clamp(ply.blood + 75,0,5000)
        ply:SetHealth(math.Clamp(ply:Health() + math.random(5,15),0,ply:GetMaxHealth()))
        ply.bleed = math.Clamp(ply.bleed - math.random(12,20),0,1000)
        ply.painlosing = ply.painlosing + 0.5
    end
end

function SWEP:Initialize()
    hg.Weapons[self] = true
    self:SetHoldType(self.HoldType)

    self.Uses = math.random(6,8)
end