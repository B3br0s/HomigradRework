if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base 

SWEP.PrintName 				= "ПКМ"
SWEP.Instructions			= "Пулемёт под калибр 7,62х54"
SWEP.Category 				= "Оружие"
SWEP.IconkaInv = "vgui/pineapple.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x54 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 130
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/pkm' )
SWEP.BounceWeaponIcon = false
end
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/fnfal/fnfal_fp.wav"
SWEP.Primary.SoundFar = "ak74/ak74_dist.wav"
SWEP.MagModel = "models/gredwitch/kord/kord_mag.mdl"
SWEP.Primary.Force = 240/3
SWEP.ReloadTime = 4
SWEP.ShootWait = 0.115
SWEP.ReloadSound = ""
SWEP.TwoHands = true
SWEP.MagOut = "zcitysnd/sound/weapons/m249/handling/m249_beltalign.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/m249/handling/m249_beltpullout.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/m249/handling/m249_boltback.wav"
SWEP.BoltIn = "zcitysnd/sound/weapons/m249/handling/m249_boltrelease.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 2.5
SWEP.BoltOutWait = 3.5
SWEP.BoltInWait = 3.7
SWEP.Baraban = true
							
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.addPos = Vector(0,3,0)
SWEP.addAng = Angle(0,0,0)

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

------------------------------------------

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(0.5,math.Rand(-0.5,0.5),0)
end

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb2/weapons/w_pkm.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_pkm.mdl"
end