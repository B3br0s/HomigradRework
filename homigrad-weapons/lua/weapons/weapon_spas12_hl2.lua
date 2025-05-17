SWEP.Base = "weapon_xm1014"
SWEP.PrintName = "SPAS-12"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Half-Life"
SWEP.WorldModel = "models/sirgibs/hl2/weapons/shotgun.mdl"

SWEP.CorrectAng = Angle(0,5,0)
SWEP.CorrectPos = Vector(3,-0.5,-0.5)

SWEP.HolsterPos = Vector(0,-17,-6)
SWEP.HolsterAng = Angle(0,90,-90)
SWEP.HolsterBone = "valvebiped.bip01_pelvis"
SWEP.BoltBone = "Bolt"
SWEP.HoldType = "ar2"
SWEP.BoltVec = Vector(0,0,-1.5)

SWEP.ZoomPos = Vector(-5,0.045,5.4)
SWEP.ZoomAng = Angle(0,2.6,0)
SWEP.AttPos = Vector(0,0,0)
SWEP.AttAng = Angle(0,0,0)
SWEP.MuzzlePos = Vector(33.5,0,3)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.Primary.DefaultClip = 8
SWEP.Primary.ClipSize = 8
SWEP.Primary.Force = 15
SWEP.Primary.Wait = 0.1
SWEP.Primary.Sound = "weapons/shotgun/shotgun_fire.wav"
SWEP.RecoilForce = 10

SWEP.IconPos = Vector(4,40,-5)
SWEP.IconAng = Angle(0,0,0)

SWEP.Weight = 2.25

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