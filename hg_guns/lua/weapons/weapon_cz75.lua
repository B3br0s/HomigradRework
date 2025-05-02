SWEP.Base = "homigrad_base"
SWEP.PrintName = "CZ75"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_pist_cz75.mdl"

SWEP.CorrectPos = Vector(-14.5,-2.5,4.3)
SWEP.CorrectAng = Angle(0,3,0)

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "v_weapon.cz_slide"
SWEP.BoltVec = Vector(0,0,-1.5)

SWEP.ZoomPos = Vector(-5,-4.25,-1)
SWEP.ZoomAng = Angle(0,2.8,0.15)
SWEP.AttPos = Vector(27.5,0.28,3.6)
SWEP.AttAng = Angle(-2.75,0.1,0)

SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 12
SWEP.Primary.ClipSize = 12
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 5
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Wait = 0.09
SWEP.Primary.Sound = {"arccw_go/cz75a/cz75_01.wav","arccw_go/cz75a/cz75_02.wav","arccw_go/cz75a/cz75_03.wav"}
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.RecoilForce = 0.5

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