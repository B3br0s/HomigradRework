SWEP.Base = "homigrad_base"
SWEP.PrintName = "MP7"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Пистолеты-Пулемёты"
SWEP.WorldModel = "models/weapons/arccw_go/v_smg_mp7.mdl"

SWEP.CorrectPos = Vector(-8.5,-6.8,9)
SWEP.CorrectAng = Angle(0,2,0)
SWEP.HoldType = "smg"

SWEP.HolsterPos = Vector(-13,-1,8)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.BoltBone = nil
SWEP.BoltVec = nil
SWEP.TwoHands = true
SWEP.Bodygroups = {[1] = 0,[2]=0,[3]=0,[4]=0,[5]=1}

SWEP.ZoomPos = Vector(9,-5.27,-0.95)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(0,-0.015,0)
SWEP.AttAng = Angle(0,0.8,0.2)
SWEP.MuzzlePos = Vector(22.5,5.15,-4)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 17.5
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Wait = 0.07
SWEP.Primary.Automatic = true
SWEP.Primary.Force = 15
SWEP.Primary.Sound = "pwb2/weapons/usptactical/usp_unsil-1.wav"
SWEP.RecoilForce = 0.25

SWEP.IconPos = Vector(0,80,-4)
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