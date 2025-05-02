SWEP.Base = "homigrad_base"
SWEP.PrintName = "ПП-Бизон 19"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_smg_bizon.mdl"

SWEP.CorrectPos = Vector(-14,-4,7)
SWEP.CorrectAng = Angle(0,4,0)

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "v_weapon.bizon_bolt"
SWEP.BoltVec = Vector(0,0,-1.5)
SWEP.BoltLock = false

SWEP.ZoomPos = Vector(-1,1.88,-7.62)
SWEP.ZoomAng = Angle(0,3.8,0.2)
SWEP.AttPos = Vector(38,1,5.5)
SWEP.AttAng = Angle(-3.8,0.1,0)

SWEP.Primary.DefaultClip = 45
SWEP.Primary.ClipSize = 45
SWEP.Primary.Damage = 3.5
SWEP.Primary.Force = 15
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Sound = {"arccw_go/bizon/bizon_01.wav","arccw_go/bizon/bizon_02.wav"}
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Automatic = true
SWEP.Primary.Wait = 0.07
SWEP.TwoHands = true
SWEP.RecoilForce = 2
SWEP.HoldType = "ar2"

SWEP.IconPos = Vector(1,80,-5)
SWEP.IconAng = Angle(-20,0,0)

SWEP.ReloadSounds = {
    [0.55] = "arccw_go/bizon/bizon_clipout.wav",
    [0.85] = "arccw_go/bizon/bizon_clipin.wav",
}

SWEP.ReloadSoundsEmpty = {
    [0.55] = "arccw_go/bizon/bizon_clipout.wav",
    [0.75] = "arccw_go/bizon/bizon_clipin.wav",
    [0.95] = "arccw_go/bizon/bizon_boltback.wav",
    [1.15] = "arccw_go/bizon/bizon_boltforward.wav"
}