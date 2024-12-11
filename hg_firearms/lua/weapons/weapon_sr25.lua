if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "SR-25"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Снайперские Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_sr25_gleb.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_sr25_gleb.mdl"
    
    SWEP.Primary.ClipSize		= 20
    SWEP.Primary.DefaultClip	= 20
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "7.62x54 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 55
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"weapons/darsu_eft/sr25/sr25_fire_indoor_close.ogg"}
    SWEP.Primary.SoundFar = "sounds_zcity/sr25/dist.wav"
    SWEP.Primary.SuppressedSound = "sounds_zcity/sr25/supressor.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(6.9,5,-0.35)
    SWEP.CameraAng = Angle(0,-13,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/mk18/handling/mk18_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/mk18/handling/mk18_hit.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/mk18/handling/mk18_boltrelease.wav"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "Slide_ar15"
    SWEP.SlideVector = Vector(0, 0, -4)
    
    SWEP.CorrectPosX = 5
    SWEP.CorrectPosY = 1.6
    SWEP.CorrectPosZ = -1
    
    SWEP.CorrectAngPitch = 180
    SWEP.CorrectAngYaw = 176
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(32,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.4, -4.3, 0)
    SWEP.addPos = Vector(0, -0.05, 7.5)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)

    SWEP.PossibleAtt = {
        ["HoloSun"] = {
            name = "holosun",
            CorrectPosX = 0,
            CorrectPosY = -1.25,
            CorrectPosZ = 7,

            CorrectAngPitch = 180,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            ChangesCamera = true,

            CameraPos = Vector(7.45,3,-0.25),

            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_base_aimpoint_micro_t1_mark.png",

            ReticleUp = 7,
            ReticleRight = 0.4,
            ReticleSize = 8,

            Holo = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/scope_all_holosun_hs401g5.mdl"
        },
        ["Hexagon"] = {
            name = "hexagon",
            CorrectPosX = 25,
            CorrectPosY = 0.4,
            CorrectPosZ = 5.85,

            CorrectAngPitch = 0,
            CorrectAngYaw = 7.5,
            CorrectAngRoll = 0,

            Suppress = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/silencer_12g_hexagon_12k.mdl"
        },
        ["NCstar"] =  {
            name = "ncstar",
            CorrectPosX = -1,
            CorrectPosY = -1.32,
            CorrectPosZ = 7,

            CorrectAngPitch = 180,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            ChangesCamera = true,

            CameraPos = Vector(7.4,3,-0.15),

            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_ncstar_advance_dual_optic_3_9x_42_mark.png",

            ReticleUp = 90,
            ReticleRight = 40,
            ReticleSize = 4000,

            BlackoutSize = 6500,

            BlackoutAmount = 200,

            ZoomFOV = 15,

            LocalPos = Vector(20, -0.5, 0.5),

            OffsetPos = Vector(9, 0, -1.275),

            Optic = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/scope_ncstar_advance_dual.mdl"
        }
    }
end