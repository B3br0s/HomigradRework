SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Author = "Homigrad"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/tfa_nmrih/v_me_hatchet.mdl"
SWEP.WorldModel = "models/weapons/tfa_nmrih/w_me_hatchet.mdl"

SWEP.HoldAng = Angle(0,0,180)
SWEP.HoldPos = Vector(3.8,1.5,-5)

SWEP.AnimAng = Angle(-10,0,0)
SWEP.AnimPos = Vector(-12,0,-5)

SWEP.ModelScale = 1.2

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Rarity = 4
SWEP.HoldType = "melee"
SWEP.AnimWait = 1.25
SWEP.AttackTime = 0.2
SWEP.AttackAng = Angle(0,-20,0)
SWEP.AttackWait = 0.4
SWEP.AttackDist = 70
SWEP.AttackDamage = 25
SWEP.AttackType = DMG_SLASH
SWEP.NoLHand = true

SWEP.IconAng = Angle(90,0,-90)
SWEP.IconPos = Vector(65,0,1.25)

SWEP.Animations = {
	["idle"] = {
        Source = "Idle",
    },
	["draw"] = {
        Source = "Draw",
        MinProgress = 0.5,
        Time = 0.5
    },
    ["attack"] = {
        Source = "Attack_Quick",
        MinProgress = 0.5,
        Time = 1.5
    },
}