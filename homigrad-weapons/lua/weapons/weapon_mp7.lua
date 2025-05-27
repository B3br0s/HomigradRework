SWEP.Base = "homigrad_base"
SWEP.PrintName = "MP7"
SWEP.Category = "Оружие: ПП"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw_go/v_smg_mp7.mdl"
SWEP.ViewModel = "models/weapons/arccw_go/v_smg_mp7.mdl"

SWEP.HoldType = "ar2"

SWEP.Primary.Automatic = true
SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.ClipSize = 45
SWEP.Primary.DefaultClip = 45
SWEP.Primary.Damage = 35
SWEP.Primary.Ammo = "4.6x30mm NATO"
SWEP.Primary.Wait = 0.08
SWEP.Sound = "pwb2/weapons/usptactical/usp_unsil-1.wav"

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.WorldPos = Vector(-6,-1.5,-0.5)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(30,5.2,-3.5)
SWEP.AttAng = Angle(-0.4,-0.05,0)
SWEP.HolsterAng = Angle(0,-90,0)
SWEP.HolsterPos = Vector(-16,4,2)

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.IconPos = Vector(80,-15.5,-5)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.Rarity = 4

SWEP.ZoomPos = Vector(11,-5.26,-0.76)
SWEP.ZoomAng = Angle(-0.9,-0.1,0)

SWEP.RecoilForce = 1

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
        Time = 1.8
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        MinProgress = 0.5,
        Time = 1.8
    }
}

SWEP.Reload1 = "arccw_go/mp7/mp7_clipout.wav"
SWEP.Reload2 = "arccw_go/mp7/mp7_clipin.wav"
SWEP.Reload3 = "arccw_go/mp7/mp7_slideback.wav"
SWEP.Reload4 = "arccw_go/mp7/mp7_slideforward.wav"