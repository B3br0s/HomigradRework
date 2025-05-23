SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Author = "Homigrad"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/tfa_nmrih/v_me_fubar.mdl"
SWEP.WorldModel = "models/weapons/tfa_nmrih/w_me_crowbar.mdl"

SWEP.HoldAng = Angle(190,20,10)
SWEP.HoldPos = Vector(3,1,3)

SWEP.AnimAng = Angle(0,0,0)
SWEP.AnimPos = Vector(-13,0,0)

SWEP.ModelScale = 1.2

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Rarity = 4

SWEP.AnimWait = 2
SWEP.AttackTime = 0.3
SWEP.AttackAng = Angle(0,0,50)
SWEP.AttackWait = 0.6
SWEP.AttackDist = 80
SWEP.AttackDamage = 45
SWEP.AttackType = DMG_CLUB
SWEP.NoLHand = false

SWEP.IconAng = Angle(90,0,90)
SWEP.IconPos = Vector(95,-1.5,-1)

SWEP.AttackHitFlesh = "physics/body/body_medium_impact_hard1.wav"
SWEP.AttackHit = {"physics/metal/metal_barrel_impact_hard1.wav","physics/metal/metal_barrel_impact_hard2.wav"}
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