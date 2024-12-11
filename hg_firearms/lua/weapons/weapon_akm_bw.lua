if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "АКМ Battle Wear"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_akm_bw.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_akm_bw.mdl"
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "7.62x39 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 35
    SWEP.Primary.Spread = 0
    SWEP.Recoil = 1.1
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/firearms/rifle_fnfal/fnfal_fire_01.wav"}
    SWEP.Primary.SuppressedSound = "zcitysnd/sound/weapons/ak74/ak74_suppressed_fp.wav"
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/ak47/ak47_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(5.45,3.5,0.8)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "weapons/darsu_eft/ak/ak74_magout_plastic.ogg"
    SWEP.Reload2 = "weapons/darsu_eft/ak/ak74_magin_plastic.ogg"
    SWEP.Reload3 = "weapons/darsu_eft/ak/ak74_slider_up.ogg"
    SWEP.Reload4 = "weapons/darsu_eft/ak/ak74_slider_down.ogg"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "Slide"
    SWEP.SlideVector = Vector(-7, 0.65, 0)
    
    SWEP.CorrectPosX = 4.7
    SWEP.CorrectPosY = 0.9
    SWEP.CorrectPosZ = -1
    
    SWEP.CorrectAngPitch = -5
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(28,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-4.8,-0.2,0)
    SWEP.addPos = Vector(0,-0.5,5.6)

    SWEP.Fake1 = Vector(4,0,0)
    SWEP.Fake2 = Vector(11,1,-3)

    SWEP.PossibleAtt = {
        ["Okp7"] = {
            name = "okp7",
            CorrectPosX = 0,
            CorrectPosY = 0.1,
            CorrectPosZ = 7,

            CorrectAngPitch = 190,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            ChangesCamera = true,

            CameraPos = Vector(5.8,3.5,0.815),

            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_ekb_okp7_true_marks.png",

            ReticleUp = 7,
            ReticleRight = 0.8,
            ReticleSize = 8,

            Holo = true,

            AttModel = "models/weapons/arc9_eft_shared/atts/optic/dovetail/okp7.mdl"
        },
        ["Ekp1s"] = {
            name = "ekp1s",
            CorrectPosX = 0,
            CorrectPosY = -0.27,
            CorrectPosZ = 6.8,

            CorrectAngPitch = 190,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            ChangesCamera = true,

            CameraPos = Vector(6.3,3.5,0.815),

            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_belomo_pk_06_mark_000.png",

            ReticleUp = 7,
            ReticleRight = 0.8,
            ReticleSize = 7,

            Holo = true,

            AttModel = "models/weapons/arc9_eft_shared/atts/optic/dovetail/ekp1s03.mdl"
        },
        ["Thor"] = {
            name = "thor",
            CorrectPosX = 23,
            CorrectPosY = -0.05,
            CorrectPosZ = 7,

            CorrectAngPitch = 190,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            Suppress = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/silencer_base_awc_thor_psr_xl_multi.mdl"
        }
    }
end