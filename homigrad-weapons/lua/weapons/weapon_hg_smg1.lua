SWEP.Base = "homigrad_base"
SWEP.PrintName = "SMG-1"
SWEP.Category = "Оружие: ПП"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/w_iiopnsmg1.mdl"
SWEP.WorldModelReal = "models/weapons/c_iiopnsmg1.mdl"
SWEP.ViewModel = "models/weapons/c_iiopnsmg1.mdl"

SWEP.HoldType = "smg"

SWEP.holdtypes = {
    ["smg"] = {[1] = 0.35,[2] = 1,[3] = 1.3,[4] = 0},
}

SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 45
SWEP.Primary.DefaultClip = 45
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 1
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Wait = 0.08
SWEP.Sound = {"weapons/smg1/smg1_fire1.wav","weapons/smg1/smg1_fire2.wav","weapons/smg1/smg1_fire3.wav"}
SWEP.RecoilForce = 0.4
SWEP.Empty3 = false

SWEP.WorldPos = Vector(-5,-1.5,0)
SWEP.WorldAng = Angle(1,-2,-1)
SWEP.AttPos = Vector(37,4.3,-4.8)
SWEP.AttAng = Angle(0,0.5,0)
SWEP.HolsterAng = Angle(0,-20,0)
SWEP.HolsterPos = Vector(-28,1,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.BoltBone = "v_weapon.AK47_bolt"
SWEP.BoltVec = Vector(0,0,-3)

SWEP.ZoomPos = Vector(8,-4.79,-1.4)
SWEP.ZoomAng = Angle(-0.5,0.4,0)

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Rarity = 4

SWEP.TwoHands = true

SWEP.IconPos = Vector(80,-25.5,-6)
SWEP.IconAng = Angle(0,90,0)

SWEP.Animations = {
	["idle"] = {
        Source = "idle",
    },
	["draw"] = {
        Source = "draw",
        MinProgress = 0.5,
        Time = 0.5
    },
    ["reload"] = {
        Source = "reload",
        MinProgress = 0.5,
        Time = 2
    }
}

SWEP.Reload1 = "weapons/smg1/smg1_clipout.wav"
SWEP.Reload2 = "weapons/smg1/smg1_clipin.wav"
SWEP.Reload3 = "weapons/smg1/smg1_boltforward.wav"
SWEP.Reload4 = false