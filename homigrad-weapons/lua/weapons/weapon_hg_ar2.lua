SWEP.Base = "homigrad_base"
SWEP.PrintName = "AR2"
SWEP.Category = "Оружие: Винтовки"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw/w_irifle.mdl"
SWEP.WorldModelReal = "models/weapons/arccw/c_irifle.mdl"
SWEP.ViewModel = "models/weapons/arccw/c_irifle.mdl"

SWEP.HoldType = "ar2"

SWEP.holdtypes = {
    ["ar2"] = {[1] = 0.35,[2] = 1.15,[3] = 1.2,[4] = 1.3},
}

SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 45
SWEP.Primary.Force = 1
SWEP.Primary.Ammo = "7.62x39 mm"
SWEP.Primary.Wait = 0.09
SWEP.Sound = "weapons/ar2/fire1.wav"
SWEP.RecoilForce = 0.2

SWEP.MuzzleColor = Color(0,153,255)

SWEP.WorldPos = Vector(-8,-1.5,0)
SWEP.WorldAng = Angle(1,0,-1)
SWEP.AttPos = Vector(37,5.1,-4.8)
SWEP.AttAng = Angle(0,-0.1,0)
SWEP.HolsterAng = Angle(0,-20,0)
SWEP.HolsterPos = Vector(-28,1,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.BoltBone = "v_weapon.AK47_bolt"
SWEP.BoltVec = Vector(0,0,-3)

SWEP.ZoomPos = Vector(10,-5.18,-1.99)
SWEP.ZoomAng = Angle(-0.5,0,0)

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Rarity = 4

SWEP.TwoHands = true

SWEP.IconPos = Vector(130,-23.5,2)
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
    },
    ["reload_empty"] = {
        Source = "reloadempty",
        MinProgress = 0.5,
        Time = 2
    }
}

SWEP.Reload1 = "weapons/ar2/ar2_magout.wav"
SWEP.Reload2 = "weapons/ar2/ar2_magin.wav"
SWEP.Reload3 = "weapons/ar2/ar2_rotate.wav"
SWEP.Reload4 = "weapons/ar2/ar2_push.wav"