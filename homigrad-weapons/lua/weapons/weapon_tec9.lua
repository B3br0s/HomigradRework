SWEP.Base = "homigrad_base"
SWEP.PrintName = "TEC-9"
SWEP.Category = "Оружие: Пистолеты"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw_go/v_pist_tec9.mdl"
SWEP.ViewModel = "models/weapons/arccw_go/v_pist_tec9.mdl"

SWEP.HoldType = "revolver"

SWEP.holdtypes = {
    ["revolver"] = {[1] = 0.3,[2] = 1.2,[3] = 1.7,[4] = 1.9},
}

SWEP.Bodygroups = {[1] = 2,[2] = 2}

SWEP.Primary.Automatic = true
SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 32
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 15
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Wait = 0.05
SWEP.Primary.ReloadTime = 2.4
SWEP.Sound = "zcitysnd/sound/weapons/firearms/rifle_cz858/cz858_fire_01.wav"
SWEP.SubSound = "hmcd/hndg_beretta92fs/beretta92_fire1.wav"
SWEP.RecoilForce = 1

SWEP.WorldPos = Vector(-6,-1.5,0)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(27,5.16,-3.5)
SWEP.AttAng = Angle(0.5,-0.2,0)
SWEP.HolsterAng = Angle(0,-90,0)
SWEP.HolsterPos = Vector(-16,4,2)

SWEP.BoltBone = "v_weapon.Slide"
SWEP.BoltVec = Vector(0,0,-2)

SWEP.IconPos = Vector(70,-27,0)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = false

SWEP.ZoomPos = Vector(9.5,-5.11,-2.4)
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
        Time = 1.5
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        MinProgress = 0.5,
        Time = 2.5
    }
}

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Reload1 = "arccw_go/tec9/tec9_clipout.wav"
SWEP.Reload2 = "arccw_go/tec9/tec9_clipin.wav"
SWEP.Reload3 = "arccw_go/tec9/tec9_boltpull.wav"
SWEP.Reload4 = "arccw_go/tec9/tec9_boltrelease.wav"