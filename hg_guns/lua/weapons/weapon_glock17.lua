SWEP.Base = "homigrad_base"
SWEP.PrintName = "Glock 17"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_pist_glock.mdl"

SWEP.CorrectPos = Vector(-15.5,-2.5,5.3)
SWEP.CorrectAng = Angle(0,0,0)

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "v_weapon.glock_slide"
SWEP.BoltVec = Vector(0,0,-1.5)

SWEP.ZoomPos = Vector(-10,-5.57,-0.81)
SWEP.AttPos = Vector(26,0.34,3.3)
SWEP.AttAng = Angle(0,0,0)

SWEP.Primary.Damage = 25
SWEP.Primary.Force = 25
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Sound = "arccw_go/glock18/glock18-1.wav"
SWEP.Primary.Ammo = "9x19 mm Parabellum"

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