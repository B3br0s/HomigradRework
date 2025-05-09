SWEP.Base = "homigrad_base"
SWEP.PrintName = "FNP-45"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Пистолеты"
SWEP.WorldModel = "models/weapons/zcity/w_fnp45.mdl"

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(12.5,-0.6,-3.2)

SWEP.HolsterPos = Vector(-1,9,-9.5)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "Slide"
SWEP.BoltVec = Vector(-1,0,0.15)
SWEP.BoltLock = true

SWEP.ZoomPos = Vector(-18,1.02,-0.05)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(-2.5,1.7,-0.45)
SWEP.AttAng = Angle(0,0,0)
SWEP.MuzzlePos = Vector(-4.5,1.7,-0.45)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 9
SWEP.Primary.ClipSize = 9
SWEP.Primary.Damage = 20
SWEP.Primary.Force = 5
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Wait = 0.15
SWEP.Primary.Sound = "pwb/weapons/fnp45/shoot.wav"
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.RecoilForce = 5.5

SWEP.IconPos = Vector(26,100,-7.25)
SWEP.IconAng = Angle(0,0,0)

SWEP.ReloadSounds = {
    [0.55] = "pwb/weapons/fnp45/clipout.wav",
    [0.85] = "pwb/weapons/fnp45/clipin.wav"
}

SWEP.ReloadSoundsEmpty = {
    [0.55] = "pwb/weapons/fnp45/clipout.wav",
    [0.85] = "pwb/weapons/fnp45/clipin.wav",
    [1.15] = "pwb/weapons/fnp45/sliderelease.wav"
}