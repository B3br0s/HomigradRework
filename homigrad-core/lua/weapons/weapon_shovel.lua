SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Author = "Homigrad"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/tfa_nmrih/v_me_fubar.mdl"
SWEP.WorldModel = "models/props_junk/Shovel01a.mdl"

SWEP.HoldAng = Angle(-3,180,10)
SWEP.HoldPos = Vector(4.3,2,-3)

SWEP.AnimAng = Angle(0,0,0)
SWEP.AnimPos = Vector(-13,0,0)

SWEP.IconAng = Angle(0,0,90)
SWEP.IconPos = Vector(200,0,0)

SWEP.ModelScale = 1

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Rarity = 4

SWEP.AnimWait = 2
SWEP.AttackTime = 0.2
SWEP.AttackAng = Angle(0,0,60)
SWEP.AttackWait = 0.6
SWEP.AttackDist = 140
SWEP.AttackDamage = 55
SWEP.AttackType = DMG_CLUB
SWEP.NoLHand = false

SWEP.AttackHitFlesh = "Flesh.ImpactHard"
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