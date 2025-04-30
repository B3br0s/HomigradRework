SWEP.Base = "homigrad_base"
SWEP.PrintName = "AK47"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_rif_ak47.mdl"

SWEP.CorrectPos = Vector(-11.5,-4.05,7.6)
SWEP.CorrectAng = Angle(-2,0,0)
SWEP.HoldType = "ar2"

SWEP.HolsterPos = Vector(-13,-1,8)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.BoltBone = "v_weapon.AK47_bolt"
SWEP.BoltVec = Vector(0,0,-3)
SWEP.BoltLock = false
SWEP.TwoHands = true

SWEP.ZoomPos = Vector(-2,0.4,-7)
SWEP.AttPos = Vector(46,1,4.25)
SWEP.AttAng = Angle(0,0,0)

SWEP.Primary.ClipSize = 30
SWEP.Primary.Ammo = "7.62x39 mm"
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 17.5
SWEP.Primary.Wait = 0.09
SWEP.Primary.ReloadTimeEnd = 1.2
SWEP.Primary.Automatic = true
SWEP.Primary.Force = 125
SWEP.Primary.Sound = "arccw_go/ak47/ak47-1.wav"
SWEP.RecoilForce = 2.5

SWEP.IconPos = Vector(-0.5,50,-4)
SWEP.IconAng = Angle(-20,0,0)

SWEP.ReloadSounds = {
    [0.5] = "arccw_go/ak47/ak47_clipout.wav",
    [0.8] = "arccw_go/ak47/ak47_clipin.wav",
    //[1.1] = "zcitysnd/sound/weapons/m4a1/handling/m4a1_hit.wav"
}

SWEP.ReloadSoundsEmpty = {
    [0.5] = "arccw_go/ak47/ak47_clipout.wav",
    [0.8] = "arccw_go/ak47/ak47_clipin.wav",
    [1.2] = "arccw_go/ak47/ak47_boltpull.wav",
}