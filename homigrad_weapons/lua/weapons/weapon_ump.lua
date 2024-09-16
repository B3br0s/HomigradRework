if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "IMI Micro Uzi"
SWEP.Instructions			= "Настоящий гэнгста носит только УЗИ!"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 25
SWEP.Primary.DefaultClip	= 25
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 30
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/smg_mac10/mac10_fire_01.wav"
SWEP.Primary.SoundFar = "weapons/ump45/ump45_dist.wav"
SWEP.Primary.Force = 85/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.05
SWEP.TwoHands = false
SWEP.MagOut = "zcitysnd/sound/weapons/m45/handling/m45_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/m45/handling/m45_maghit.wav"
SWEP.BoltIn = "zcitysnd/sound/weapons/m249/handling/m249_boltback.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 1.5
SWEP.BoltInWait = 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_uzi.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_uzi.mdl"

SWEP.vbwPos = Vector(-2,-4,-4)
SWEP.addAng = Angle( 7, -0.5, 0 )
SWEP.addPos = Vector(0,0,0)
end