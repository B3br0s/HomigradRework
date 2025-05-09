SWEP.Base = "homigrad_base"
SWEP.PrintName = "Glock 17"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Пистолеты"
SWEP.WorldModel = "models/weapons/arccw_go/v_pist_glock.mdl"

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(-13,-4.25,5)

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "v_weapon.glock_slide"
SWEP.BoltVec = Vector(0,0,-1.5)

SWEP.ZoomPos = Vector(3,-2.82,-1.25)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(0,-0.03,0)
SWEP.AttAng = Angle(0,0.85,0)
SWEP.MuzzlePos = Vector(23.5,2.85,-2)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.Primary.Damage = 25
SWEP.Primary.Force = 25
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Sound = "arccw_go/glock18/glock18-1.wav"
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.RecoilForce = 3

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