if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base 

SWEP.PrintName 				= "РПК"
SWEP.Instructions			= "Пулемёт под калибр 7,62х39"
SWEP.Category 				= "Оружие"
SWEP.IconkaInv = "vgui/weapon_csgo_ak47.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 45
SWEP.Primary.DefaultClip	= 45
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 45
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/rpk/rpk_fp.wav"
--SWEP.Primary.SoundFar = "ak74/ak74_dist.wav"
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/rpk' )
SWEP.BounceWeaponIcon = false
end
SWEP.Primary.Force = 240/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.08
SWEP.ReloadSound = ""
SWEP.TwoHands = true
SWEP.MagOut = "zcitysnd/sound/weapons/rpk/handling/rpk_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/rpk/handling/rpk_magin.wav"
SWEP.BoltIn = "zcitysnd/sound/weapons/rpk/handling/rpk_boltback.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/rpk/handling/rpk_boltrelease.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 1
SWEP.BoltInWait = 1.5
SWEP.BoltOutWait = 1.7
							
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

SWEP.ViewModel				= "models/pwb2/weapons/w_rpk.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_rpk.mdl"
end