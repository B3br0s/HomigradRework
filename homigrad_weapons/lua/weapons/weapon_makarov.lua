if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Макаров"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Травматический пистолет под калибр 9х18 Rubber"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "pwb/sprites/glock17"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9x18 Rubber"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 5
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "m9/m9_tp.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 90/3
SWEP.ReloadTime = 2
SWEP.RubberBullets = true
SWEP.ShootWait = 0.12

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
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/insurgency/w_makarov.mdl"
SWEP.WorldModel				= "models/weapons/insurgency/w_makarov.mdl"

SWEP.dwsPos = Vector(13,13,5)
SWEP.dwsItemPos = Vector(10,-1,-2)

SWEP.addAng = Angle(1,0,0)
SWEP.addPos = Vector(0,0,0)
--SWEP.vbwPos = Vector(7,-10,-6)
end