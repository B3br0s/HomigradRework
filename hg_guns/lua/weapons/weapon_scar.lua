SWEP.Base = "homigrad_base"
SWEP.PrintName = "SCAR"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_rif_scar.mdl"

SWEP.CorrectPos = Vector(-13.5,-4,8)
SWEP.CorrectAng = Angle(-2,0,0)
SWEP.HoldType = "ar2"

SWEP.HolsterPos = Vector(-13,-1,8)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.BoltBone = nil
SWEP.BoltVec = nil
SWEP.TwoHands = true

SWEP.ZoomPos = Vector(-2,0.49,-6.48)
SWEP.ZoomAng = Angle(0,0.45,-0.81)
SWEP.AttPos = Vector(46.5,1.55,3.7)
SWEP.AttAng = Angle(-1.5,-0.7,0)
SWEP.RecoilForce = 1.5

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 35
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Wait = 0.09
SWEP.Primary.Automatic = true
SWEP.Primary.Force = 35
SWEP.Primary.Sound = "pwb/weapons/hk416/shoot.wav"

SWEP.IconPos = Vector(-3.5,50,-4)
SWEP.IconAng = Angle(-20,0,0)

SWEP.ReloadSounds = {
    [0.5] = "zcitysnd/sound/weapons/m4a1/handling/m4a1_magout.wav",
    [0.8] = "zcitysnd/sound/weapons/m4a1/handling/m4a1_magin.wav",
    //[1.1] = "zcitysnd/sound/weapons/m4a1/handling/m4a1_hit.wav"
}

SWEP.ReloadSoundsEmpty = {
    [0.5] = "zcitysnd/sound/weapons/m4a1/handling/m4a1_magout.wav",
    [0.8] = "zcitysnd/sound/weapons/m4a1/handling/m4a1_magin.wav",
    //[1.1] = "zcitysnd/sound/weapons/m4a1/handling/m4a1_hit.wav",
    [1.2] = "arccw_go/m4a1/m4a1_silencer_boltback.wav"
}