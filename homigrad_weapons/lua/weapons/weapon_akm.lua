if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "АКМ"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Автоматическая винтовка под калибр 7,62х39"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon          = "pwb/sprites/akm"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.MagModel = "models/csgo/weapons/w_rif_ak47_mag.mdl"
SWEP.Primary.Damage = 1.7 * 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "ak74/ak74_fp.wav"
SWEP.Primary.SoundFar = "ak74/ak74_dist.wav"
SWEP.Primary.SoundSupresor = "ak74/ak74_suppressed_tp.wav"
SWEP.Primary.Force = 240/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.1
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

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

SWEP.ViewModel				= "models/pwb/weapons/w_akm.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_akm.mdl"

SWEP.vbwPos = Vector(5,-6,-6)

SWEP.addAng = Angle(1,0,0)
SWEP.addPos = Vector(0,0,0)


SWEP.ValidAttachments = {
    ["Suppressor"] = {
        positionright = 1,
        positionforward = 29,
        positionup = -8.25,

        angleforward = 180,
        angleright = 10,
        angleup = 0,
        
        scale = 1,
        model = "models/weapons/arc9/darsu_eft/mods/silencer_12g_hexagon_12k.mdl",
    },
    ["Opk7"] = {
        positionright = 0.75,
        positionforward = 4,
        positionup = -6.5,

        angleforward = 178,
        angleright = 10,
        angleup = -0.1,

        holosight = true,
        newsight = true,
        aimpos = Vector(6,7,0.725),
        aimang = Angle(-5,0,0),

        scale = 1,
        model = "models/weapons/arc9_eft_shared/atts/optic/dovetail/okp7.mdl",
    },
    ["Pkaa"] = {
        positionright = 1.05,
        positionforward = 4,
        positionup = -6.5,

        angleforward = 178,
        angleright = 10,
        angleup = -0.1,

        holosight = true,
        newsight = true,
        aimpos = Vector(6,7,0.725),
        aimang = Angle(-5,0,0),

        scale = 1,
        model = "models/weapons/arc9_eft_shared/atts/optic/dovetail/pkaa.mdl",
    }
}
end