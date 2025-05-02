SWEP.Base = "homigrad_base"
SWEP.PrintName = "MP9"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_smg_mp9.mdl"

SWEP.CorrectPos = Vector(-13.9,-3.5,6.5)
SWEP.CorrectAng = Angle(0,2,0)

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.ZoomPos = Vector(-6,-1.18,-4.8)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(38,1.28,5.34)
SWEP.AttAng = Angle(-1.7,0,0)

SWEP.Bodygroups = {[1] = 2,[2]=1,[3]=2,[4]=1,[5]=2}


SWEP.Primary.DefaultClip = 25
SWEP.Primary.ClipSize = 25
SWEP.Primary.Damage = 12
SWEP.Primary.Force = 15
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Wait = 0.07
SWEP.Primary.Sound = {"arccw_go/mp9/mp9_01.wav","arccw_go/mp9/mp9_02.wav","arccw_go/mp9/mp9_03.wav"}
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.TwoHands = true
SWEP.RecoilForce = 2
SWEP.HoldType = "ar2"
SWEP.Primary.Automatic = true

SWEP.IconPos = Vector(-2.5,90,-5)
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