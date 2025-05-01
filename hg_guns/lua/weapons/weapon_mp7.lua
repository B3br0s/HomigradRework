SWEP.Base = "homigrad_base"
SWEP.PrintName = "MP7"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_smg_mp7.mdl"

SWEP.CorrectPos = Vector(-12,-4.5,6)
SWEP.CorrectAng = Angle(-2,6,0)
SWEP.HoldType = "smg"

SWEP.HolsterPos = Vector(-13,-1,8)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.BoltBone = nil
SWEP.BoltVec = nil
SWEP.TwoHands = true

SWEP.ZoomPos = Vector(3,0.35,-5.8)
SWEP.ZoomAng = Angle(0,5.5,0.1)
SWEP.AttPos = Vector(36.5,0.77,3.75)
SWEP.AttAng = Angle(-5.5,0.05,0)
SWEP.RecoilForce = 0.25

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 17.5
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Wait = 0.07
SWEP.Primary.Automatic = true
SWEP.Primary.Force = 15
SWEP.Primary.Sound = {"arccw_go/mp7/mp7_01.wav","arccw_go/mp7/mp7_02.wav","arccw_go/mp7/mp7_03.wav"}
SWEP.RecoilForce = 2

SWEP.IconPos = Vector(1.5,80,-4)
SWEP.IconAng = Angle(-20,0,0)

SWEP.ReloadSounds = {
    [0.5] = "arccw_go/mp7/mp7_clipout.wav",
    [1] = "arccw_go/mp7/mp7_clipin.wav",
    //[1.1] = "zcitysnd/sound/weapons/m4a1/handling/m4a1_hit.wav"
}

SWEP.ReloadSoundsEmpty = {
    [0.5] = "arccw_go/mp7/mp7_clipout.wav",
    [1] = "arccw_go/mp7/mp7_clipin.wav",
    //[1.1] = "zcitysnd/sound/weapons/m4a1/handling/m4a1_hit.wav",
    [1.2] = "arccw_go/mp7/mp7_slideforward.wav"
}