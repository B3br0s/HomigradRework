if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "HK-416"
SWEP.Instructions			= "Автоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 55
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/mk18/mk18_fp.wav"
SWEP.Primary.SoundFar = "m16a4/m16a4_dist.wav"
SWEP.Primary.Force = 160/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
SWEP.ReloadSound = ""
SWEP.TwoHands = true
SWEP.MagOut = "zcitysnd/sound/weapons/mk18/handling/mk18_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/mk18/handling/mk18_magin.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/mk18/handling/mk18_boltrelease.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.9
SWEP.BoltOutWait = 1.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false

SWEP.Secondary.Ammo			= "none"
SWEP.SubMaterial = {
    [1] = "null",
    [2] = "null",
}

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_hk416.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_hk416.mdl"

SWEP.vbwPos = Vector(5,-3.7,-8)
SWEP.vbwAng = Angle(5,-30,0)

SWEP.ValidAttachments = {
    ["Elcan"] = {
        positionright = 0.85,
        positionforward = 7,
        positionup = -6.5,

        angleforward = 180,
        angleright = 10,
        angleup = 0,

        holosight = true,
        newsight = true,
        aimpos = Vector(6.4,7,0.83),
        aimang = Angle(-5,0,0),

        scale = 1,
        model = "models/weapons/arc9/darsu_eft/mods/scope_elcan_specter_hco.mdl",
    },
    ["Suppressor"] = {
        positionright = 0.96,
        positionforward = 23,
        positionup = -7.1,

        angleforward = 180,
        angleright = 10,
        angleup = 0,

        scale = 1,
        model = "models/weapons/arc9/darsu_eft/mods/silencer_tbac_thunder_beast_ultra_5_762x51.mdl",
    },
    ["Grip"] = {
        positionright = 1,
        positionforward = 15,
        positionup = -5.8,

        angleforward = 178,
        angleright = 30,
        angleup = -0.1,

        scale = 1,
        model = "models/weapons/arc9/darsu_eft/mods/pistolgrip_ar15_f1_firearms_st2_pc_skeletonized.mdl",
    }
}
end