SWEP.Base = "hg_medbase"

SWEP.PrintName = "Ключ Карта 4 Уровня"
SWEP.Author = "HG:R"
SWEP.Category = "Ключ-Карты"
SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true
SWEP.Uses = 0
SWEP.Skin = 3
SWEP.KeyCardClass = 4

SWEP.CorrectPosX =     4
SWEP.CorrectPosY =     4
SWEP.CorrectPosZ =     -4

SWEP.CorrectAngPitch = 95
SWEP.CorrectAngYaw =   0
SWEP.CorrectAngRoll =  40

SWEP.CorrectSize = 0.7

SWEP.WorldModel = "models/vinrax/props/keycard.mdl"

function SWEP:Initialize()
    self:SetHoldType("slam")
end

function SWEP:Think()
    self:SetHoldType("slam")
end

function SWEP:Heal()

end

function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()

end

function SWEP:DrawHUD()

end