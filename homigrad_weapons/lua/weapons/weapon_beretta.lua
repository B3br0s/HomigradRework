if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "M9 Beretta"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Пистолет под калибр 9х19"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "pwb/sprites/m9"
SWEP.IconkaInv = "vgui/weapon_csgo_elite.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/m9' )
SWEP.BounceWeaponIcon = false
end
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/hndg_beretta92fs/beretta92_fire1.wav"
--SWEP.Primary.SoundFar = "m45/m45_dist.wav"
SWEP.Primary.Force = 65/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.12
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
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_m9.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_m9.mdl"

SWEP.vbwPos = Vector(8,-9,-8)

SWEP.addPos = Vector(0,0,-0.9)
SWEP.addAng = Angle(0.3,0,0)
end