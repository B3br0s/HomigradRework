SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие - Ближний Бой"
SWEP.Spawnable = true
SWEP.PrintName = "Полицейская Дубинка"
SWEP.Instructions = "Дубинка, используемая полицейскими подразделениями"

SWEP.WorldModel = "models/drover/w_baton.mdl"

SWEP.HoldType = "melee"

SWEP.Primary.Sound = Sound( "Weapon_Knife.Single" )
SWEP.Primary.Damage = 28
SWEP.DamagePain = 5

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.8
SWEP.Primary.Force = 250
SWEP.DamageType = DMG_CLUB

SWEP.HitSound = "physics/body/body_medium_impact_soft7.wav"
SWEP.FlashHitSound = {"physics/flesh/flesh_strider_impact_bullet1.wav","physics/flesh/flesh_strider_impact_bullet2.wav","physics/flesh/flesh_strider_impact_bullet3.wav"}

SWEP.dwsItemPos = Vector(0,-5,2)
SWEP.dwsItemAng = Angle(-45,90,90)
SWEP.dwsItemFOV = -6