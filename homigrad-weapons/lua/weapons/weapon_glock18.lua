SWEP.Base = "weapon_glockp80"
SWEP.PrintName = "Glock 18"
SWEP.Category = "Оружие: Пистолеты"
SWEP.Spawnable = true

SWEP.Bodygroups = {[1] = 2,[2] = 0,[3] = 3}

SWEP.WorldModel = "models/weapons/arccw/c_ud_glock.mdl"
SWEP.ViewModel = "models/weapons/arccw/c_ud_glock.mdl"

SWEP.HoldType = "revolver"

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Primary.Automatic = true
SWEP.Primary.ReloadTime = 1.85
SWEP.Primary.ClipSize = 33
SWEP.Primary.DefaultClip = 33
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 15
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Wait = 0.08
SWEP.Sound = "sounds_zcity/glock17/close.wav"
SWEP.SubSound = "hmcd/hndg_beretta92fs/beretta92_fire1.wav"

SWEP.WorldPos = Vector(-6,-0.5,0)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(22.5,2.33,-3)
SWEP.AttAng = Angle(-0.5,-0.1,0)
SWEP.HolsterAng = Angle(0,-90,0)
SWEP.HolsterPos = Vector(-16,4,2)

SWEP.BoltBone = "glock_slide"
SWEP.BoltVec = Vector(0,0,-1)

SWEP.IconPos = Vector(40,-9.75,-7.5)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = false

SWEP.ZoomPos = Vector(8,-2.31,-2.45)
SWEP.ZoomAng = Angle(-0.5,0,0)

SWEP.holdtypes = {
    ["revolver_empty"] = {[1] = 0.3,[2] = 0.9,[3] = 1.3,[4] = 0},
}

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
        Source = "reload_33",
        MinProgress = 0.5,
        Time = 1.5
    },
    ["reload_empty"] = {
        Source = "reload_empty_33",
        MinProgress = 0.5,
        Time = 1.9
    }
}