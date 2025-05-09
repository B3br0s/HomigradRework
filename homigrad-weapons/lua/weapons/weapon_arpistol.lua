SWEP.Base = "homigrad_base"
SWEP.PrintName = "Colt 9mm"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Пистолеты"
SWEP.WorldModel = "models/ar15/w_smg_635.mdl"

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(-4.1,-1,-1)

SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.HolsterPos = Vector(8,-8.7,-10)
SWEP.HolsterAng = Angle(0,-40,180)
SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.ZoomPos = Vector(0,0.502,8.05)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(-0.5,0.11,-0.15)
SWEP.AttAng = Angle(0,0.6,-0.63)
SWEP.MuzzlePos = Vector(24.5,-0.5,5.2)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 15
SWEP.Primary.ClipSize = 15
SWEP.Primary.Damage = 22.5
SWEP.Primary.Force = 5
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Wait = 0.25
SWEP.Primary.Sound = "pwb2/weapons/mac11/mac10-1.wav"
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.RecoilForce = 3.5

SWEP.IconPos = Vector(4.5,80,-5)
SWEP.IconAng = Angle(0,0,0)

SWEP.ReloadSounds = {
    [0.55] = "zcitysnd/sound/weapons/m9/handling/m9_magout.wav",
    [0.75] = "zcitysnd/sound/weapons/m9/handling/m9_magin.wav",
    [0.85] = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav"
}

SWEP.ReloadSoundsEmpty = {
    [0.55] = "zcitysnd/sound/weapons/m9/handling/m9_magout.wav",
    [0.75] = "zcitysnd/sound/weapons/m9/handling/m9_magin.wav",
    [0.85] = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav",
    [1.15] = "arccw_go/glock18/glock_sliderelease.wav"
}