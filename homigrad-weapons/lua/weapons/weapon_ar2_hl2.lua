SWEP.Base = "homigrad_base"
SWEP.PrintName = "AR2"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Half-Life"
SWEP.WorldModel = "models/sirgibs/hl2/weapons/ar2.mdl"

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(-0.8,-1,5)

SWEP.HolsterPos = Vector(0,-17,-6)
SWEP.HolsterAng = Angle(0,90,-90)
SWEP.BoltBone = "Bolt1"
SWEP.HoldType = "ar2"
SWEP.BoltVec = Vector(0,0,3.5)
SWEP.BoltLock = false

SWEP.ZoomPos = Vector(-3,0.021,2.5)
SWEP.ZoomAng = Angle(0,0.2,0)
SWEP.AttPos = Vector(0,-0.03,0)
SWEP.AttAng = Angle(0,0.1,0)
SWEP.MuzzlePos = Vector(20,0,0)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 15
SWEP.Primary.ReloadTime = 1.35
SWEP.Primary.Wait = 0.09
SWEP.Primary.Sound = {"weapons/ar2/fire1.wav","weapons/ar2/fire2.wav","weapons/ar2/fire3.wav"}
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.RecoilForce = 1
SWEP.TwoHands = true
SWEP.MuzzleColor = Color(0,174,255)

SWEP.IconPos = Vector(9,40,-5)
SWEP.IconAng = Angle(-20,0,0)

SWEP.Reload1 = "weapons/ar2/ar2_magout.wav"
SWEP.Reload2 = "weapons/ar2/ar2_magin.wav"
SWEP.Reload3 = "weapons/ar2/ar2_rotate.wav"
SWEP.Reload4 = "weapons/ar2/ar2_push.wav"

SWEP.Attachments = {
    ['sight'] = hg.Attachments.holo1,
}

SWEP.AttachmentPos = {
    ['sight'] = Vector(6,0,2.1),
}