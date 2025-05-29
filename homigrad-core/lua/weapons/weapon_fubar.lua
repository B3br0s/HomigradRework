SWEP.Base = "weapon_melee"
SWEP.Category = "Ближний Бой"
SWEP.Author = "Homigrad"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/tfa_nmrih/v_me_fubar.mdl"
SWEP.WorldModel = "models/weapons/tfa_nmrih/w_me_fubar.mdl"

SWEP.HoldAng = Angle(180,180,-8)
SWEP.HoldPos = Vector(0.45,-1.5,9)

SWEP.AnimAng = Angle(0,0,0)
SWEP.AnimPos = Vector(-13,0,0)

SWEP.IconAng = Angle(90,0,90)
SWEP.IconPos = Vector(120,5.25,7)

SWEP.ModelScale = 1

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Rarity = 4

SWEP.AnimWait = 2
SWEP.AttackTime = 0.2
SWEP.AttackAng = Angle(0,0,50)
SWEP.AttackWait = 0.6
SWEP.AttackDist = 80
SWEP.AttackDamage = 65
SWEP.AttackType = DMG_CLUB
SWEP.NoLHand = false

SWEP.AttackHitFlesh = {"weapons/melee/flesh_impact_blunt_01.wav","weapons/melee/flesh_impact_blunt_02.wav","weapons/melee/flesh_impact_blunt_05.wav","weapons/melee/flesh_impact_blunt_03.wav"}
SWEP.AttackHit = {"physics/metal/metal_sheet_impact_hard2.wav","physics/metal/metal_sheet_impact_hard6.wav"}
SWEP.DeploySnd = "physics/metal/weapon_impact_soft1.wav"

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
        Time = 2
    },
}