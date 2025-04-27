SWEP.Base = "wep_food_base"
SWEP.PrintName = "Энергетик"
SWEP.Category = "Еда"
SWEP.Spawnable = true

SWEP.WorldModel = "models/jorddrink/mongcan1a.mdl"

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true

SWEP.Regens = 10
SWEP.BiteSounds = false

function SWEP:Eat()
    local ply = self:GetOwner()
    if SERVER then
        ply.hunger = ply.hunger + self.Regens
        ply.adrenaline = ply.adrenaline + 0.25
    end
end