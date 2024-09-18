if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "GALIL-SAR"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Автоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "pwb2/vgui/weapons/ace23"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 35
SWEP.Primary.DefaultClip	= 35
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/mil_m16a4/m16_fire_01.wav"
SWEP.Primary.SoundFar = "m16a4/m16a4_dist.wav"
SWEP.Primary.Force = 240/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
SWEP.ReloadSound = ""
SWEP.TwoHands = true
SWEP.MagOut = "zcitysnd/sound/weapons/galil/handling/galil_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/galil/handling/galil_magin.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/galil/handling/galil_boltrelease.wav"
SWEP.BoltIn = "zcitysnd/sound/weapons/galil/handling/galil_boltback.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.9
SWEP.BoltOutWait = 1.55 
SWEP.BoltInWait = 1.35

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

SWEP.ViewModel				= "models/pwb2/weapons/w_ace23.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_ace23.mdl"

SWEP.vbwPos = Vector(-4,-4,2)
SWEP.vbwAng = Angle(10,-20,0)

SWEP.addAng = Angle(1.7,0.1,0)
end