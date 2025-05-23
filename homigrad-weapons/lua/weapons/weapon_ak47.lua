SWEP.Base = "homigrad_base"
SWEP.PrintName = "AK47"
SWEP.Category = "Оружие: Автоматы"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw_go/v_rif_ak47.mdl"
SWEP.ViewModel = "models/weapons/arccw_go/v_rif_ak47.mdl"

SWEP.HoldType = "ar2"

SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 35
SWEP.Primary.Force = 1
SWEP.Primary.Ammo = "7.62x39 mm"
SWEP.Primary.Wait = 0.09
SWEP.Sound = "pwb/weapons/rpk/shoot.wav"
SWEP.RecoilForce = 0.4

SWEP.WorldPos = Vector(-5,-1.5,0)
SWEP.WorldAng = Angle(1,0,-1)
SWEP.AttPos = Vector(37,5,-2)
SWEP.AttAng = Angle(0,-0.1,0)
SWEP.HolsterAng = Angle(0,-20,0)
SWEP.HolsterPos = Vector(-28,1,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.BoltBone = "v_weapon.AK47_bolt"
SWEP.BoltVec = Vector(0,0,-3)

SWEP.ZoomPos = Vector(10,-5.05,-1.1)
SWEP.ZoomAng = Angle(-0.5,0,0)

SWEP.Rarity = 4

SWEP.TwoHands = true

SWEP.IconPos = Vector(130,-23.2,-1)
SWEP.IconAng = Angle(0,90,0)

SWEP.Animations = {
	["idle"] = {
        Source = "ak47_idle",
    },
	["draw"] = {
        Source = "ak47_draw",
        MinProgress = 0.5,
        Time = 0.5
    },
    ["reload"] = {
        Source = "ak47_reload",
        MinProgress = 0.5,
        Time = 1.6
    },
    ["reload_empty"] = {
        Source = "ak47_reload_empty",
        MinProgress = 0.5,
        Time = 2
    }
}

SWEP.Reload1 = "arccw_go/ak47/ak47_clipout.wav"
SWEP.Reload2 = "arccw_go/ak47/ak47_clipin.wav"
SWEP.Reload3 = "pwb2/weapons/ace23/boltpull.wav"
SWEP.Reload4 = "pwb2/weapons/ace23/boltforward.wav"