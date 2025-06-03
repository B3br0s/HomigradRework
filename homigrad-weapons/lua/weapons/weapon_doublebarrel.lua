SWEP.Base = "homigrad_base"
SWEP.PrintName = "Izh-27"
SWEP.Category = "Оружие: Дробовики"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw/c_ur_dbs.mdl"
SWEP.ViewModel = "models/weapons/arccw/c_ur_dbs.mdl"

SWEP.holdtypes = {
    ["ar2"] = {[1] = 0.27,[2] = 0.7,[3] = 1.75,[4] = 2.2},
    ["revolver"] = {[1] = 0.27,[2] = 0.7,[3] = 1.75,[4] = 2.2},
}

SWEP.HoldType = "ar2"

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Damage = 20
SWEP.Primary.Force = 40
SWEP.NumBullet = 8
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Sound = "zcitysnd/sound/weapons/firearms/shtg_berettasv10/beretta_fire_01.wav"
SWEP.InsertSound = "pwb2/weapons/m4super90/shell.wav"
SWEP.Primary.ReloadTime = 2.5
SWEP.Primary.Wait = 0.2

SWEP.Empty3 = false
SWEP.Empty4 = false

SWEP.IsShotgun = true

SWEP.WorldPos = Vector(1,2,-1)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(37,1.5,-2.7)
SWEP.AttAng = Angle(0.2,0,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"
SWEP.HolsterAng = Angle(120,0,-10)
SWEP.HolsterPos = Vector(-10,0,3)

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.IconPos = Vector(160,-17,0)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.ZoomPos = Vector(5,-1.53,-2.5)
SWEP.ZoomAng = Angle(-0.3,0,0)

SWEP.RecoilForce = 2

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
        Time = 1
    },
    ["idle"] = {
        Source = "idle",
        Time = 1
    },
    ["reload"] = {
        Source = "reload",
        Time = 3
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 3
    },
}

SWEP.Reload1 = "weapons/arccw_ur/dbs/open.ogg"
SWEP.Reload2 = "weapons/arccw_ur/dbs/eject.ogg"
SWEP.Reload3 = "arccw_uc/common/dbs-shell-insert-02.ogg"
SWEP.Reload4 = "weapons/arccw_ur/dbs/close.ogg"