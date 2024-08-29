if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "R8"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Револьвер под калибр .44 Remington Magnum"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".44 Remington Magnum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 70
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "csgo/weapons/revolver/revolver-1_01.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 90/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.08

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

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(5,math.Rand(-1,1),0)
end

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/csgo/weapons/w_pist_revolver.mdl"
SWEP.WorldModel				= "models/csgo/weapons/w_pist_revolver.mdl"

SWEP.vbwPos = Vector(8.5,-10,-8)

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(-1.1,0,0)
end