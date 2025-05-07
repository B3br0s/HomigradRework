SWEP.Base = "homigrad_base"
SWEP.PrintName = "Desert Eagle"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_pist_deagle.mdl"

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(-13,-5.25,5)

SWEP.Primary.DefaultClip = 7
SWEP.Primary.ClipSize = 7
SWEP.Primary.Ammo = ".50 Action Express"

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "v_weapon.deagle_slide"
SWEP.BoltVec = Vector(0,0,-1.5)

SWEP.ZoomPos = Vector(3,-3.74,0.06)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(0,0.04,-0.4)
SWEP.AttAng = Angle(0,0.7,0)
SWEP.MuzzlePos = Vector(23.5,3.85,-1.4)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.Primary.Damage = 85
SWEP.Primary.Force = 200
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Wait = 0.2
SWEP.Primary.Sound = "arccw_go/deagle/deagle-1.wav"
SWEP.RecoilForce = 13

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