if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Five-Seven"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Бронебойный пистолет. Пробьёт даже дыру в твоей жопе."
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "entities/weapon_insurgencymakarov.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "5.7×28 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 20
SWEP.RubberBullets = false
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "csgo/weapons/fiveseven/fiveseven_01.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 0.1
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.12
SWEP.MagOut = "zcitysnd/sound/weapons/m9/handling/m9_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/m1911/handling/m1911_boltrelease.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 1.5
SWEP.BoltOutWait = 2

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

SWEP.ViewModel				= "models/csgo/weapons/w_pist_fiveseven.mdl"
SWEP.WorldModel				= "models/csgo/weapons/w_pist_fiveseven.mdl"

SWEP.vbwPos = Vector(0,0,0)
SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(0.4,0,0)
SWEP.AimPosition = Vector(3.85,10,1.45)
SWEP.AimAngle = Angle(0,0,0)
end