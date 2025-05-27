SWEP.Base = "weapon_870_a"
SWEP.PrintName = "Remington 870-B"
SWEP.Category = "Оружие: Дробовики"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw/c_ud_870.mdl"
SWEP.ViewModel = "models/weapons/arccw/c_ud_870.mdl"

SWEP.HoldType = "ar2"

SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Damage = 28
SWEP.Primary.Force = 20
SWEP.NumBullet = 8
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Sound = "sounds_zcity/remington870/close.wav"
SWEP.InsertSound = "pwb2/weapons/m4super90/shell.wav"
SWEP.Pump = 0
SWEP.PumpEnd = false
SWEP.Pumped = true
SWEP.PumpTarg = 0
SWEP.Primary.ReloadTime = 0.3
SWEP.Primary.Wait = 0.5

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.IsShotgun = true

SWEP.WorldPos = Vector(-4,-0.5,-1)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(37,3.7,-2.7)
SWEP.AttAng = Angle(0.2,0,0)
SWEP.HolsterAng = Angle(0,-30,0)
SWEP.HolsterPos = Vector(-28,5,7.5)

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.IconPos = Vector(160,-17,0)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.ZoomPos = Vector(8,-3.78,-1.65)
SWEP.ZoomAng = Angle(-0.3,0.1,0)

SWEP.RecoilForce = 2

SWEP.Animations = {
    ["pump"] = {
        Source = "cycle",
        Time = 0.8
    },
    ["draw"] = {
        Source = "draw",
        Time = 1
    },
    ["idle"] = {
        Source = "idle",
        Time = 1
    },
    ["insert"] = {
        Source = "sgreload_insert",
        Time = 0.8
    },
    ["insert_start"] = {
        Source = "sgreload_start",
        Time = 0.6
    },
    ["insert_end"] = {
        Source = "sgreload_finish",
        Time = 1
    },
}

SWEP.Reload1 = false
SWEP.Reload2 = false
SWEP.Reload3 = false
SWEP.Reload4 = false