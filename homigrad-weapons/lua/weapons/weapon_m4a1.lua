SWEP.Base = "homigrad_base"
SWEP.PrintName = "M4A1"
SWEP.Category = "Оружие: Автоматы"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw_go/v_rif_m4a1.mdl"
SWEP.ViewModel = "models/weapons/arccw_go/v_rif_m4a1.mdl"

SWEP.HoldType = "ar2"

SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 35
SWEP.Primary.Force = 1
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Wait = 0.085
SWEP.Sound = "pwb2/weapons/m4a1/ru-556 fire unsilenced.wav"
SWEP.RecoilForce = 0.4

SWEP.WorldPos = Vector(-6,-1.5,0)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(32,5.15,-3.45)
SWEP.AttAng = Angle(0,0.2,0)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterPos = Vector(-28,-3,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.IconPos = Vector(110,-18.5,-2.5)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.Rarity = 5

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.ZoomPos = Vector(10,-5.21,-0.5)
SWEP.ZoomAng = Angle(-0.8,-0.05,0)

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
        Time = 1.8
    }
}

SWEP.Reload1 = "pwb2/weapons/m4a1/ru-556 clip out 1.wav"
SWEP.Reload2 = "pwb2/weapons/m4a1/ru-556 clip in 2.wav"
SWEP.Reload3 = "pwb2/weapons/m4a1/ru-556 bolt forward.wav"
SWEP.Reload4 = false