SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие - Ближний Бой"
SWEP.Spawnable = true
SWEP.PrintName = "Лопата"
SWEP.Instructions = "Ручной шанцевый инструмент, используемый преимущественно для работы (копание, расчистка, перенос и так далее) с грунтом."

SWEP.WorldModel = "models/weapons/me_spade/w_me_spade.mdl"

SWEP.Primary.Damage = 25
SWEP.DamagePain = 25
SWEP.DamageBleed = 30

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.1
SWEP.Primary.Force = 180

SWEP.DrawSound = "weapons/melee/holster_in_light.wav"
SWEP.HitSound = "physics/metal/metal_sheet_impact_hard7.wav"
SWEP.FlashHitSound = "snd_jack_hmcd_axehit.wav"
SWEP.ShouldDecal = true
SWEP.HoldType = "melee2"
SWEP.DamageType = DMG_SLASH

SWEP.sndTwroh = {"weapons/melee/swing_heavy_blunt_01.wav","weapons/melee/swing_heavy_blunt_02.wav","weapons/melee/swing_heavy_blunt_03.wav"}

SWEP.dwsItemPos = Vector(0,3,0)
SWEP.dwsItemAng = Angle(90 + 45,0,90)
SWEP.dwsItemFOV = 2

SWEP.IconPos = Vector(16.5,50,-6)
SWEP.IconAng = Angle(-120,0,90)
SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""