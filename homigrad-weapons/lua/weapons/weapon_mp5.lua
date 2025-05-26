SWEP.Base = "homigrad_base"
SWEP.PrintName = "MP5"
SWEP.Category = "Оружие: ПП"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw_go/v_smg_mp5.mdl"
SWEP.ViewModel = "models/weapons/arccw_go/v_smg_mp5.mdl"

SWEP.HoldType = "ar2"

SWEP.Primary.Automatic = true
SWEP.Primary.ReloadTime = 2.2
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 25
SWEP.Primary.Damage = 10
SWEP.Primary.Force = 2.5
SWEP.RecoilForce = 0.25
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Wait = 0.08
SWEP.Sound = "pwb/weapons/mp7/shoot.wav"

SWEP.WorldPos = Vector(-8,-2.5,0)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(30,5.2,-4.05)
SWEP.AttAng = Angle(-0.4,-0.05,0)
SWEP.HolsterAng = Angle(0,-90,0)
SWEP.HolsterPos = Vector(-16,4,2)

SWEP.RecoilForce = 1.5

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.holdtypes = {
    ["ar2"] = {[1] = 0.3,[2] = 1.3,[3] = 0.1,[4] = 1.7},
}

SWEP.IconPos = Vector(110,-10,1.5)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Rarity = 4

SWEP.ZoomPos = Vector(10,-5.205,-1.35)
SWEP.ZoomAng = Angle(-1,0,0)

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
        Time = 2.25
    }
}

SWEP.Reload1 = "arccw_go/mp5/mp5_clipout.wav"
SWEP.Reload2 = "arccw_go/mp5/mp5_clipin.wav"
SWEP.Reload3 = "arccw_go/mp5/mp5_slideback.wav"
SWEP.Reload4 = "arccw_go/mp5/mp5_slideforward.wav"