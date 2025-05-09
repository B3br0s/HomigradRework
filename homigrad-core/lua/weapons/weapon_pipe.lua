SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Spawnable = true
SWEP.PrintName = "Труба"

SWEP.WorldModel = "models/props_canal/mattpipe.mdl"

SWEP.HoldType = "melee"

SWEP.Primary.Sound = Sound( "Weapon_Knife.Single" )
SWEP.Primary.Damage = 28
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.1
SWEP.Primary.Force = 400
SWEP.DamageType = DMG_CLUB

SWEP.HitSound = "physics/metal/metal_canister_impact_hard2.wav"
SWEP.FlashHitSound = {"physics/flesh/flesh_strider_impact_bullet1.wav","physics/flesh/flesh_strider_impact_bullet2.wav","physics/flesh/flesh_strider_impact_bullet3.wav"}

SWEP.dwsItemPos = Vector(-0.5,0,2)
SWEP.dwsItemAng = Angle(-45,0,180)
SWEP.dwsItemFOV = -2

SWEP.IconPos = Vector(17,50,-6)
SWEP.IconAng = Angle(-120,0,0)
SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""