if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "L85A1"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Автоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/mp40/mp40_fp.wav"
SWEP.Primary.Force = 240/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.1
SWEP.ReloadSound = ""
SWEP.TwoHands = true
SWEP.MagOut = "csgo/weapons/aug/aug_clipout.wav"
SWEP.MagIn = "csgo/weapons/aug/aug_clipin.wav"
SWEP.BoltIn = "csgo/weapons/aug/aug_boltrelease.wav"
SWEP.BoltOut = "csgo/weapons/aug/aug_boltpull.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.9
SWEP.BoltInWait = 1.4
SWEP.BoltOutWait = 1.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "smg"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_l85a1.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_l85a1.mdl"

SWEP.vbwPos = Vector(12,-2.7,-12)
SWEP.vbwAng = Angle(5,-30,0)

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(-0.4,0,0)
end