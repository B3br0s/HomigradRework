if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "P99"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Пистолет под калибр 9х19"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "pwb/sprites/p99"
SWEP.IconkaInv = "vgui/weapon_pwb_p99.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 15
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/p99' )
SWEP.BounceWeaponIcon = false
end
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/hndg_mkiii/mkiii_fire_01.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 80/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.12
SWEP.MagOut = "zcitysnd/sound/weapons/m1911/handling/m1911_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/m1911/handling/m1911_maghit.wav"
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

SWEP.ViewModel				= "models/pwb/weapons/w_p99.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_p99.mdl"

SWEP.dwsPos = Vector(15,15,5)
SWEP.dwsItemPos = Vector(10,-1,-3)

SWEP.vbwPos = Vector(8,-9,-8)

SWEP.addAng = Angle(0.4,-0.2,0)
SWEP.addPos = Vector(0.1,0,-0.9)
end