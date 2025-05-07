SWEP.Base = "homigrad_base"
SWEP.PrintName = "M4A1"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_rif_m4a1.mdl"

SWEP.CorrectPos = Vector(-11.5,-5.9,7.6)
SWEP.CorrectAng = Angle(-2,2,0)
SWEP.HoldType = "ar2"

SWEP.HolsterPos = Vector(-13,-1,8)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.BoltBone = nil
SWEP.BoltVec = nil
SWEP.TwoHands = true

SWEP.ZoomPos = Vector(10,-5.23,-0.6)
SWEP.ZoomAng = Angle(0,2,0)
SWEP.AttPos = Vector(-2,0,0)
SWEP.AttAng = Angle(0,0.75,0)

SWEP.MuzzlePos = Vector(36,5.1,-3)
SWEP.MuzzleAng = Angle(0,0,0)
SWEP.RecoilForce = 1.25

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 17.5
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Wait = 0.09
SWEP.Primary.Automatic = true
SWEP.Primary.ReloadTime = 1.2
SWEP.Primary.ReloadTimeEnd = 1.3
SWEP.Primary.Force = 35
SWEP.Primary.Sound = "pwb2/weapons/m4a1/ru-556 fire unsilenced.wav"

SWEP.IconPos = Vector(1.5,50,-4)
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