SWEP.Base = "homigrad_base"
SWEP.PrintName = "SMG-1"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Half-Life"
SWEP.WorldModel = "models/sirgibs/hl2/weapons/smg1.mdl"

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(6.3,-1.5,2)
SWEP.HoldType = "smg"

SWEP.HolsterPos = Vector(0,-17,-6)
SWEP.HolsterAng = Angle(0,90,-90)
SWEP.BoltBone = nil
SWEP.BoltVec = nil
SWEP.TwoHands = true
SWEP.Bodygroups = {[1] = 0,[2]=0,[3]=1,[4]=0,[5]=0}

SWEP.ZoomPos = Vector(-10,0.24,5.55)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(-2,0.15,0.2)
SWEP.AttAng = Angle(0,0.18,0)
SWEP.MuzzlePos = Vector(10,0,4.5)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 35
SWEP.Primary.Damage = 17.5
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Wait = 0.07
SWEP.Primary.Automatic = true
SWEP.Primary.Force = 15
SWEP.ReloadTime = 1.35
SWEP.Primary.Sound = {"weapons/smg1/smg1_fire1.wav","weapons/smg1/smg1_fire2.wav","weapons/smg1/smg1_fire3.wav"}
SWEP.RecoilForce = 0.25

SWEP.IconPos = Vector(16,80,-4)
SWEP.IconAng = Angle(0,0,0)

SWEP.Reload1 = "weapons/smg1/smg1_clipout.wav"
SWEP.Reload2 = "weapons/smg1/smg1_clipin.wav"
SWEP.Reload3 = false
SWEP.Reload4 = "weapons/smg1/smg1_boltforward.wav"

SWEP.Weight = 1.5

SWEP.AttachmentPos = {
    ['sight'] = Vector(-3,0,5.5),
}
SWEP.Attachments = {
    ['sight'] = hg.Attachments.holo2,
}