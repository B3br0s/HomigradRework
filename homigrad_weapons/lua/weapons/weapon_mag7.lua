if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base 

SWEP.PrintName 				= "MAG-7"
SWEP.Instructions			= ""
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12/70 gauge"
SWEP.Primary.Cone = 0.3
SWEP.Primary.Damage = 1.7 * 5
SWEP.Primary.Spread = 2
SWEP.Primary.Sound = "csgo/weapons/mag7/mag7_01.wav"
SWEP.Primary.SoundFar = "weapons/mini14/mini14_dist.wav"
SWEP.Primary.Force = 25
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.8
SWEP.ReloadSound = "csgo/weapons/mag7/mag7_clipin.wav"
SWEP.NumBullet = 32
SWEP.Sight = true
SWEP.TwoHands = true
							
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"
SWEP.Shotgun = true

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/csgo/weapons/w_shot_mag7.mdl"
SWEP.WorldModel				= "models/csgo/weapons/w_shot_mag7.mdl"

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(5,math.Rand(-2,2),0)
end

SWEP.vbwPos = Vector(4,-3.2,-6)
SWEP.vbwAng = Angle(7.5,-30,0)

SWEP.addAng = Angle(0.5,0.1,0)
SWEP.addPos = Vector(0,0,0)

SWEP.CLR_Scope = 0.05
SWEP.CLR = 0.025
end