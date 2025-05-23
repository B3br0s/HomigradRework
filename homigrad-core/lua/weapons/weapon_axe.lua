SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие: Ближний Бой" // HERE IS JOHNY
SWEP.Author = "Homigrad"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/tfa_nmrih/v_me_bat_metal.mdl"
SWEP.WorldModel = "models/props/CS_militia/axe.mdl"

SWEP.HoldAng = Angle(3,-20,-94)
SWEP.HoldPos = Vector(4.25,0.6,8)

SWEP.AnimAng = Angle(0,0,-40)
SWEP.AnimPos = Vector(-10,0,0)

SWEP.IconAng = Angle(90,0,180)
SWEP.IconPos = Vector(110,0,0)

SWEP.ModelScale = 1

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Rarity = 4

SWEP.AnimWait = 2
SWEP.AttackTime = 0.4
SWEP.AttackAng = Angle(0,-30,30)
SWEP.AttackWait = 0.25
SWEP.AttackDist = 100
SWEP.AttackDamage = 85
SWEP.AttackType = DMG_SLASH
SWEP.NoLHand = false
SWEP.LHand = true

SWEP.HoldType = "melee"

SWEP.AttackHitFlesh = "snd_jack_hmcd_axehit.wav"
SWEP.AttackHit = "weapons/melee/rifle_swing_hit_world.wav"
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
        Time = 1.5
    },
}