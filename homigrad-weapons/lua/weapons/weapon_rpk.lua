SWEP.Base = "homigrad_base"
SWEP.PrintName = "РПК-74М"
SWEP.Category = "Оружие: Пулемёты"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw/c_ur_ak.mdl"
SWEP.ViewModel =  "models/weapons/arccw/c_ur_ak.mdl"

SWEP.Bodygroups = {[1] = 5,[2] = 1,[3] = 0,[4] = 0,[5] = 0,[6] = 5,[7] = 4,[8] = 0,[9] = 2}

SWEP.HoldType = "ar2"

SWEP.holdtypes = {
    ["ar2"] = {[1] = 0.2,[2] = 1.25,[3] = 2,[4] = 2.1},
}

SWEP.Primary.ReloadTime = 2.5
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 75
SWEP.Primary.DefaultClip = 75
SWEP.Primary.Damage = 45
SWEP.Primary.Force = 15
SWEP.Primary.Ammo = "7.62x39 mm"
SWEP.Primary.Wait = 0.09
SWEP.Sound = "zcitysnd/sound/weapons/ak47/ak47_fp.wav"
SWEP.RecoilForce = 0.4

SWEP.WorldPos = Vector(-4,1,0)
SWEP.WorldAng = Angle(0.65,0.1,4)
SWEP.AttPos = Vector(37,2.9,-2.5)
SWEP.AttAng = Angle(0.5,-0.2,0)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterPos = Vector(-18,0,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.IconPos = Vector(135,-21.25,-2)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.Rarity = 5

SWEP.BoltBone = "vm_bolt"
SWEP.BoltVec = Vector(0,2,0)

SWEP.ZoomPos = Vector(6,-2.57,-0.8)
SWEP.ZoomAng = Angle(0,-0.26,0)

SWEP.Animations = {
	["idle"] = {
        Source = "idle",
    },
	["draw"] = {
        Source = "draw",
        MinProgress = 0.5,
        Time = 1
    },
    ["reload"] = {
        Source = "reload_drum",
        MinProgress = 0.5,
        Time = 2.5
    },
    ["reload_empty"] = {
        Source = "reload_drum_empty",
        MinProgress = 0.5,
        Time = 3
    }
}

SWEP.Reload1 = "zcitysnd/sound/weapons/rpk/handling/rpk_magout.wav"
SWEP.Reload2 = "zcitysnd/sound/weapons/rpk/handling/rpk_magin.wav"
SWEP.Reload3 = "zcitysnd/sound/weapons/rpk/handling/rpk_boltback.wav"
SWEP.Reload4 = "zcitysnd/sound/weapons/rpk/handling/rpk_boltrelease.wav"