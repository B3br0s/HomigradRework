SWEP.Base = "homigrad_base"
SWEP.PrintName = "M60" //Уолтер Уайт оценил.
SWEP.Category = "Оружие: Пулемёты"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/w_nam_m60.mdl"
SWEP.WorldModelReal = "models/weapons/bocw_m60.mdl"
SWEP.ViewModel =  "models/weapons/bocw_m60.mdl"

SWEP.Bodygroups = {[1] = 5,[2] = 1,[3] = 0,[4] = 0,[5] = 0,[6] = 5,[7] = 4,[8] = 0,[9] = 2}

SWEP.HoldType = "smg"

SWEP.Empty3 = false
SWEP.Empty4 = false

SWEP.holdtypes = {
    ["smg"] = {[1] = 0.3,[2] = 1.25,[3] = 2,[4] = 2.1},
}

SWEP.Primary.ReloadTime = 9
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 75
SWEP.Primary.DefaultClip = 75
SWEP.Primary.Damage = 95
SWEP.Primary.Force = 15
SWEP.Primary.Ammo = "7.62x39 mm"
SWEP.Primary.Wait = 0.12
SWEP.Sound = "sounds_zcity/m60/close.wav"
SWEP.RecoilForce = 0.4

SWEP.WorldPos = Vector(-9,-2,4)
SWEP.WorldAng = Angle(0,0,0)
SWEP.AttPos = Vector(37,4.95,-9.2)
SWEP.AttAng = Angle(0.6,-0.1,0)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterPos = Vector(-18,0,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.IconPos = Vector(135,-21.25,-2)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.Rarity = 5

SWEP.BoltBone = "vm_bolt"
SWEP.BoltVec = Vector(0,2,0)

SWEP.ZoomPos = Vector(11,-4.86,-5.6)
SWEP.ZoomAng = Angle(0,-0.05,0)

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
        Source = "reload",
        MinProgress = 0.5,
        Time = 8.5
    },
}

SWEP.Reload1 = "zcitysnd/sound/weapons/m249/handling/m249_boltback.wav"
SWEP.Reload2 = "zcitysnd/sound/weapons/m249/handling/m249_boltrelease.wav"
SWEP.Reload3 = "zcitysnd/sound/weapons/rpk/handling/rpk_boltback.wav"
SWEP.Reload4 = "zcitysnd/sound/weapons/rpk/handling/rpk_boltrelease.wav"