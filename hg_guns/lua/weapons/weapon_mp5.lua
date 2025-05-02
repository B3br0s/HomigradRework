SWEP.Base = "homigrad_base"
SWEP.PrintName = "MP5"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_smg_mp5.mdl"

SWEP.CorrectPos = Vector(-16.5,-4,8)
SWEP.CorrectAng = Angle(0,2,0)

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.ZoomPos = Vector(-4,0.323,-7.75)
SWEP.ZoomAng = Angle(0,1.45,0.02)
SWEP.AttPos = Vector(36,1.25,5.3)
SWEP.AttAng = Angle(-1.5,0,0)

SWEP.Primary.DefaultClip = 25
SWEP.Primary.ClipSize = 25
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 15
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Sound = "arccw_go/mp5/mp5_unsil.wav"
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.HoldType = "ar2"
SWEP.Primary.Automatic = true
SWEP.Primary.Wait = 0.07
SWEP.TwoHands = true
SWEP.RecoilForce = 2

SWEP.IconPos = Vector(-2,60,-5)
SWEP.IconAng = Angle(-20,0,0)

SWEP.ReloadSounds = {
    [0.55] = "arccw_go/mp5/mp5_clipout.wav",
    [0.75] = "arccw_go/mp5/mp5_clipin.wav",
    [0.85] = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav"
}

SWEP.ReloadSoundsEmpty = {
    [0.55] = "arccw_go/mp5/mp5_clipout.wav",
    [0.75] = "arccw_go/mp5/mp5_clipin.wav",
    [0.85] = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav",
    [1.15] = "arccw_go/mp5/mp5_slideforward.wav"
}