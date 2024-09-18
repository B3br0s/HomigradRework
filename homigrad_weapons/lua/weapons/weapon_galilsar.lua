if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "АС «Вал»"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Автоматическая винтовка со встроенным глушителем под калибр 9х39"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "pwb2/vgui/weapons/asval"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 45
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/m4a1/m4a1_suppressed_fp.wav"
--SWEP.Primary.SoundFar = "mp5k/mp5k_suppressed_tp.wav"
SWEP.Primary.Force = 200/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.065
SWEP.ReloadSound = ""
SWEP.TwoHands = true
SWEP.MagOut = "zcitysnd/sound/weapons/aks74u/handling/aks_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/aks74u/handling/aks_magin.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/aks74u/handling/aks_boltrelease.wav"
SWEP.BoltIn = "zcitysnd/sound/weapons/aks74u/handling/aks_boltback.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.7
SWEP.BoltInWait = 1.2
SWEP.BoltOutWait = 1.4

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
SWEP.MagModel = "models/csgo/weapons/w_rif_galilar_mag.mdl"
SWEP.Efect = "PhyscannonImpact"

SWEP.ViewModel				= "models/pwb2/weapons/w_asval.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_asval.mdl"

SWEP.addAng = Angle(0,0,0)
SWEP.addPos = Vector(0,0,0)

SWEP.Supressed = true

SWEP.ValidAttachments = {
    ["Opk7"] = {
        positionright = 0.9,
        positionforward = 4,
        positionup = -5.5,

        angleforward = 178,
        angleright = 10,
        angleup = -0.1,

        holosight = true,
        newsight = true,
        aimpos = Vector(5.1,7,0.5),
        aimang = Angle(-5,0,0),

        scale = 1,
        model = "models/weapons/arc9_eft_shared/atts/optic/dovetail/okp7.mdl",
    },
    ["Grip"] = {
        positionright = 1,
        positionforward = 14,
        positionup = -5.8,

        angleforward = 178,
        angleright = 30,
        angleup = -0.1,

        scale = 1,
        model = "models/weapons/arc9/darsu_eft/mods/pistolgrip_ar15_tactical_dynamics_hexgrip.mdl",
    },
}
end