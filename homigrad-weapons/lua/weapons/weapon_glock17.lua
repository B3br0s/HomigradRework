SWEP.Base = "homigrad_base"
SWEP.PrintName = "Glock-17"
SWEP.Category = "Оружие: Пистолеты"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw_go/v_pist_glock.mdl"
SWEP.ViewModel = "models/weapons/arccw_go/v_pist_glock.mdl"

SWEP.HoldType = "revolver"

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.ClipSize = 17
SWEP.Primary.DefaultClip = 17
SWEP.Primary.Damage = 10
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Wait = 0.1
SWEP.Sound = "arccw_go/glock18/glock18-1.wav"

SWEP.WorldPos = Vector(-4,-1.5,0)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(19.5,2.82,-1.5)
SWEP.AttAng = Angle(-0.5,-0.1,0)
SWEP.HolsterAng = Angle(0,-90,0)
SWEP.HolsterPos = Vector(-16,4,2)

SWEP.BoltBone = "v_weapon.glock_slide"
SWEP.BoltVec = Vector(0,0,-1)

SWEP.IconPos = Vector(40,-9.75,-7.5)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = false

SWEP.ZoomPos = Vector(6,-2.8,-1.18)
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
        Time = 1.8
    }
}

SWEP.Reload1 = "zcitysnd/sound/weapons/m9/handling/m9_magout.wav"
SWEP.Reload2 = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav"
SWEP.Reload3 = "arccw_go/glock18/glock_slideback.wav"
SWEP.Reload4 = "arccw_go/glock18/glock_sliderelease.wav"