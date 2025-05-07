do return end
SWEP.Base = "weapon_r870"
SWEP.PrintName = "MAG-7"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_shot_mag7.mdl"

SWEP.CorrectPos = Vector(-20.4,-5.5,10)
SWEP.CorrectAng = Angle(0,0,0)
SWEP.HoldType = "ar2"

SWEP.HolsterPos = Vector(-13,-1,8)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.BoltBone = "v_weapon.pump"
SWEP.BoltVec = Vector(0,0,-2)

SWEP.ZoomPos = Vector(-6.5,-3.115,-6.63)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(39,0.8,4.9)
SWEP.AttAng = Angle(0,0,0)

SWEP.IsShotgun = false
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Damage = 17.5
SWEP.Primary.Wait = 0.09
SWEP.Primary.ReloadTimeEnd = 1.5
SWEP.Primary.Automatic = false
SWEP.Primary.Force = 45
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/shtg_mossberg500/m500_fire_01.wav"
SWEP.RecoilForce = 15

SWEP.IconPos = Vector(-7,50,-4)
SWEP.IconAng = Angle(-20,0,0)

SWEP.ReloadSounds = {
    [0.5] = "arccw_go/mag7/mag7_clipout.wav",
    [0.8] = "arccw_go/mag7/mag7_clipin.wav",
    //[1.1] = "zcitysnd/sound/weapons/m4a1/handling/m4a1_hit.wav"
}

SWEP.ReloadSoundsEmpty = {
    [0.5] = "arccw_go/mag7/mag7_clipout.wav",
    [0.8] = "arccw_go/mag7/mag7_clipin.wav",
    [1.3] = "arccw_go/mag7/mag7_pump_back.wav",
    [1.5] = "arccw_go/mag7/mag7_pump_forward.wav",
}