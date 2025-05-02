SWEP.Base = "homigrad_base"
SWEP.PrintName = "M9"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_pist_m9.mdl"

SWEP.CorrectPos = Vector(-15.5,-2.5,4.8)
SWEP.CorrectAng = Angle(0,0,0)

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "v_weapon.HKP2000_Slide"
SWEP.BoltVec = Vector(0,0,-1.5)

SWEP.ZoomPos = Vector(-10,-5.6,-0.65)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(28,0.33,3.7)
SWEP.AttAng = Angle(0.5,0,0)

SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipSize = 20
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 15
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Wait = 0.1
SWEP.Primary.Sound = {"arccw_go/elite/elites_01.wav","arccw_go/elite/elites_02.wav"}
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.RecoilForce = 2
SWEP.TwoHands = true

SWEP.IconPos = Vector(1,110,-5)
SWEP.IconAng = Angle(-20,0,0)

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