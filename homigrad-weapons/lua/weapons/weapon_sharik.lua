do return end //Создано чтобы потроллить хомяков))
SWEP.Base = "homigrad_base"
SWEP.PrintName = "M4A1 SHARIK"
SWEP.Category = "Оружие: Автоматы"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arc9/darsu_eft/c_hk416.mdl"
SWEP.ViewModel = "models/weapons/arc9/darsu_eft/c_hk416.mdl"

SWEP.HoldType = "ar2"

SWEP.Primary.ReloadTime = 2.4
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 35
SWEP.Primary.Force = 1
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Wait = 0.085
SWEP.Sound = "pwb2/weapons/m4a1/ru-556 fire unsilenced.wav"
SWEP.RecoilForce = 0.4

SWEP.WorldPos = Vector(-5,0,0)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(32,5.15,-3.45)
SWEP.AttAng = Angle(0,0.2,0)
SWEP.HolsterAng = Angle(0,-90,0)
SWEP.HolsterPos = Vector(-16,4,2)

SWEP.IconPos = Vector(110,-18.5,-2.5)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.Rarity = 5

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.ZoomPos = Vector(7,-4.3,-1.2)
SWEP.ZoomAng = Angle(-0.8,0,0)

SWEP.Details = {
    [1] = {
        Model = "models/weapons/arc9/darsu_eft/mods/mag_stanag_hk_416_steel_maritime_556x45_30.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(0,-90,0),
        Bone = "mod_magazine"
    },
    [2] = {
        Model = "models/weapons/arc9/darsu_eft/mods/barrel_416_hk_368mm_556x45.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(0,-90,0),
        Bone = "shellport"
    },
    [3] = {
        Model = "models/weapons/arc9/darsu_eft/mods/charge_ar15_badger_ordnance_tactical_latch.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(0,-90,0),
        Bone = "mod_charge"
    },
    [4] = {
        Model = "models/weapons/arc9/darsu_eft/mods/pistolgrip_ar15_sig_mcx_std.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(0,-90,0),
        Bone = "mod_pistol_grip"
    },
    [5] = {
        Model = "models/weapons/arc9/darsu_eft/mods/reciever_ar15_hk_hk416a5_std.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(0,-90,0),
        Bone = "mod_reciever"
    },
    [6] = {
        Model = "models/weapons/arc9/darsu_eft/mods/handguard_416_hk_quad_rail.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(0,-0,0),
        Bone = "shellport"
    },
    [7] = {
        Model = "models/weapons/arc9/darsu_eft/mods/stock_ar15_colt_stock_tube_std.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(0,-90,0),
        Bone = "mod_stock"
    },
    [8] = {
        Model = "models/weapons/arc9/darsu_eft/mods/stock_ar15_hk_slim_line.mdl",
        Pos = Vector(-3,0,-0.9),
        Ang = Angle(0,-90,0),
        Bone = "mod_stock"
    },
}

SWEP.Animations = {
	["idle"] = {
        Source = "idle",
    },
	["draw"] = {
        Source = "draw",
        MinProgress = 0.5,
        Time = 1
    },
    ["reload"] = {
        Source = "reload0",
        MinProgress = 0.5,
        Time = 2.5
    },
    ["reload_empty"] = {
        Source = "reload_empty0",
        MinProgress = 0.5,
        Time = 2.5
    }
}

SWEP.Reload1 = false
SWEP.Reload2 = false
SWEP.Reload3 = false
SWEP.Reload4 = false