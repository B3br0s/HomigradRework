if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "Test"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Револьвер под калибр .44 Remington Magnum"
SWEP.Category 				= "Other"

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
SWEP.Baraban = true
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.08
SWEP.MagOut = "csgo/weapons/revolver/revolver_clipout.wav"
SWEP.MagIn = "csgo/weapons/revolver/revolver_clipin.wav"
SWEP.BoltOut = "csgo/weapons/revolver/revolver_siderelease.wav"
SWEP.BoltIn = "csgo/weapons/revolver/revolver_sideback.wav"
SWEP.MagOutWait = 0.6
SWEP.MagInWait = 1.5
SWEP.BoltInWait = 2
SWEP.BoltOutWait = 0.3
SWEP.revolver = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.SubMaterial = {
    [1] = "null",
    [2] = "null"
}
------------------------------------------
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/csgo/weapons/v_pist_revolver.mdl"
SWEP.WorldModel				= "models/csgo/weapons/v_pist_revolver.mdl"

SWEP.vbwPos = Vector(-4,-4.2,1)
SWEP.vbwAng = Angle(7,-30,0)
end