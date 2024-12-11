if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "АК-12"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/zcity/weapons/skf_rwroclav_ak_12.mdl"
    SWEP.WorldModel				= "models/zcity/weapons/skf_rwroclav_ak_12.mdl"
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "7.62x39 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 75
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/ak74/ak74_fp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/ak74/ak74_dist.wav"
    SWEP.Primary.SuppressedSound = "zcitysnd/sound/weapons/ak74/ak74_suppressed_fp.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(6.5,5,0.45)
    SWEP.CameraAng = Angle(0,-5,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "weapons/darsu_eft/ak/ak74_magout_plastic.ogg"
    SWEP.Reload2 = "weapons/darsu_eft/ak/ak74_magin_plastic.ogg"
    SWEP.Reload3 = "weapons/darsu_eft/ak/ak74_slider_up.ogg"
    SWEP.Reload4 = "weapons/darsu_eft/ak/ak74_slider_down.ogg"

    SWEP.DeploySound = "zcitysnd/sound/weapons/m14/handling/m14_rattle.wav"

    SWEP.SlideBone = "charging_handle"
    SWEP.SlideVector = Vector(0, 0, 5) 
    
    SWEP.CorrectPosX = 4
    SWEP.CorrectPosY = 1
    SWEP.CorrectPosZ = 0
    
    SWEP.CorrectAngPitch = 170
    SWEP.CorrectAngYaw = -2
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(30,0,-2)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-6.7,-2,0)
    SWEP.addPos = Vector(0,-0.4,7.5)

    SWEP.Fake1 = Vector(4,0,0)
    SWEP.Fake2 = Vector(11,1,-3)

    SWEP.PossibleAtt = {
        ["vortex"] = {
            name = "vortex",
            CorrectPosX = 0,
            CorrectPosY = -0.2,
            CorrectPosZ = 6.1,

            CorrectAngPitch = 197,
            CorrectAngYaw = -0.2,
            CorrectAngRoll = 1,

            ChangesCamera = true,

            CameraPos = Vector(6.8,5,0.5),

            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_vortex_razor_amg_uh-1_marks.png",

            ReticleUp = 7,
            ReticleRight = 0.4,
            ReticleSize = 6,

            Holo = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/scope_all_vortex_razor_amg_uh-1.mdl"
        },
        ["Hexagon"] = {
            name = "hexagon",
            CorrectPosX = 20,
            CorrectPosY = 0.5,
            CorrectPosZ = 7.9,

            CorrectAngPitch = 20,
            CorrectAngYaw = 184,
            CorrectAngRoll = 0,

            Suppress = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/silencer_12g_hexagon_12k.mdl"
        }
    }
end