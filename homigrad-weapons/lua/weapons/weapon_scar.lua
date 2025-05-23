SWEP.Base = "homigrad_base"
SWEP.PrintName = "SCAR"
SWEP.Category = "Оружие: Автоматы"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw_go/v_rif_scar.mdl"
SWEP.ViewModel = "models/weapons/arccw_go/v_rif_scar.mdl"

SWEP.HoldType = "ar2"

SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 35
SWEP.Primary.Force = 1
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Wait = 0.085
SWEP.Sound = "pwb/weapons/hk416/shoot.wav"
SWEP.RecoilForce = 0.4

SWEP.WorldPos = Vector(-6,-1.5,0)
SWEP.WorldAng = Angle(0.2,1,0)
SWEP.AttPos = Vector(37,5.5,-3.5)
SWEP.AttAng = Angle(0.6,-0.9,0)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterPos = Vector(-28,-3.5,3.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.IconPos = Vector(110,-18.5,-2.5)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.Rarity = 5

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.ZoomPos = Vector(10,-4.962,-0.78)
SWEP.ZoomAng = Angle(0.2,-0.85,0)

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
        Source = "reload_empty",
        MinProgress = 0.5,
        Time = 2
    }
}

SWEP.Reload1 = "pwb2/weapons/m4a1/ru-556 clip out 1.wav"
SWEP.Reload2 = "pwb2/weapons/m4a1/ru-556 clip in 2.wav"
SWEP.Reload3 = "pwb2/weapons/m4a1/ru-556 bolt forward.wav"
SWEP.Reload4 = false