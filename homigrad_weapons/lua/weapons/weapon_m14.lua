if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "TMP"
SWEP.Instructions			= ""
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.IconkaInv = "vgui/weapon_pwb_tmp.png"

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone = 0
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/tmp' )
SWEP.BounceWeaponIcon = false
end
SWEP.Primary.Damage = 1.7 * 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/galil/galil_suppressed_tp.wav"
--SWEP.Primary.SoundFar = "weapons/m14/m14_dist.wav"
SWEP.Primary.Force = 270/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.06
SWEP.ReloadSound = ""
SWEP.TwoHands = true
SWEP.Supressed = true
SWEP.Efect = "PhyscannonImpact"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.MagOut = "zcitysnd/sound/weapons/m14/handling/m14_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/m14/handling/m14_magin.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/m14/handling/m14_boltrelease.wav"
SWEP.BoltIn = "zcitysnd/sound/weapons/m14/handling/m14_boltback.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.9
SWEP.BoltOutWait = 1.35 
SWEP.BoltInWait = 1.13

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

SWEP.ViewModel				= "models/pwb/weapons/w_tmp.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_tmp.mdl"

SWEP.addAng = Angle( 1.8, 0.9, 0 )
SWEP.addPos = Vector(0,0,0)
SWEP.vbwPos = Vector(12,-1.7,-12)
SWEP.vbwAng = Angle(10,-30,0)
end