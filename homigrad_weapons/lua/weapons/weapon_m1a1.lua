if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "Scorpion vz. 68"
SWEP.Instructions			= ""
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone = 0.006
SWEP.Primary.Damage = 1.7 * 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/mil_mp5a4/mp5_fire_01.wav"
SWEP.Primary.Force = 70/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.05
SWEP.ReloadSound = ""
SWEP.TwoHands = true
SWEP.MagOut = "zcitysnd/sound/weapons/m45/handling/m45_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/m45/handling/m45_maghit.wav"
SWEP.BoltIn = "zcitysnd/sound/weapons/m45/handling/m45_boltrelease.wav"
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
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_vz61.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_vz61.mdl"

SWEP.vbwPos = Vector(-2,-3.7,-8)
SWEP.vbwAng = Angle(10,-30,0)
SWEP.addAng = Angle(2.3,-0.25,0)
SWEP.addPos = Vector(0,0,0)
end