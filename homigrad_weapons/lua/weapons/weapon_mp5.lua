if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base 

SWEP.PrintName 				= "HK MP5a3"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Пистолет-пулемёт под калибр 9х19"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.MagModel = "models/csgo/weapons/w_pist_tec9_mag.mdl"
SWEP.Primary.Damage = 1.7 * 30
SWEP.Primary.Spread = 5
SWEP.Primary.Sound = "zcitysnd/sound/weapons/mp5k/mp5k_fp.wav"
SWEP.Primary.SoundFar = "mp5k/mp5k_dist.wav"
SWEP.Primary.Force = 85/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.06
SWEP.TwoHands = true
SWEP.MagOut = "zcitysnd/sound/weapons/mp40/handling/mp40_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/mp40/handling/mp40_magin.wav"
SWEP.BoltIn = "zcitysnd/sound/weapons/mp5k/handling/mp5k_boltback.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/mp5k/handling/mp5k_boltrelease.wav"
SWEP.Baraban = true
SWEP.MagOutWait = 0.5
SWEP.MagInWait = 1.5
SWEP.BoltInWait = 0.2
SWEP.BoltOutWait = 1.9
							
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb2/weapons/w_mp5a3.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_mp5a3.mdl"

SWEP.vbwPos = Vector(-4,-3.7,2)
SWEP.vbwAng = Angle(2,-30,0)

SWEP.addAng = Angle(0,0,0)
end