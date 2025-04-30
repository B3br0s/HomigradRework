SWEP.Base = "homigrad_base"
SWEP.PrintName = "Desert Eagle"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_pist_deagle.mdl"

SWEP.CorrectPos = Vector(-15.5,-3.5,4.7)
SWEP.CorrectAng = Angle(0,0,0)

SWEP.Primary.DefaultClip = 7
SWEP.Primary.ClipSize = 7
SWEP.Primary.Ammo = ".50 Action Express"

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "v_weapon.deagle_slide"
SWEP.BoltVec = Vector(0,0,-1.5)

SWEP.ZoomPos = Vector(-10,-5.6,-0.51)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(29,0.3485,2.98)
SWEP.AttAng = Angle(0.9,-0.3,0)

SWEP.Primary.Damage = 85
SWEP.Primary.Force = 200
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Sound = "arccw_go/deagle/deagle-1.wav"
SWEP.RecoilForce = 15

SWEP.IconPos = Vector(1,110,-6)
SWEP.IconAng = Angle(-20,0,0)

SWEP.ReloadSounds = {
    [0.55] = "arccw_go/deagle/de_clipout.wav",
    [0.75] = "arccw_go/deagle/de_clipin.wav",
}

SWEP.ReloadSoundsEmpty = {
    [0.55] = "arccw_go/deagle/de_clipout.wav",
    [0.75] = "arccw_go/deagle/de_clipin.wav",
    [1.25] = "arccw_go/deagle/de_slideback.wav",
    [1.25] = "arccw_go/deagle/de_slideforward.wav"
}