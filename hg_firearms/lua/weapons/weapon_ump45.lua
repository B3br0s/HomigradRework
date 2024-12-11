if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "UMP-45"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты Пулемёты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/arccw_go/v_smg_ump45.mdl"
    SWEP.WorldModel				= "models/weapons/arccw_go/v_smg_ump45.mdl"
    
    SWEP.Primary.ClipSize		= 45
    SWEP.Primary.DefaultClip	= 45
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 55
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"arccw_go/ump45/ump45_02.wav"}
    SWEP.Primary.SoundFar = "arccw_go/ump45/ump45-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.08
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(6.06,7,1.112)
    SWEP.CameraAng = Angle(0,4,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "weapons/mp40/handling/mp40_magout.wav"
    SWEP.Reload2 = "weapons/mp40/handling/mp40_magin.wav"
    SWEP.Reload3 = "weapons/mp5k/handling/mp5k_boltrelease.wav"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "weapons/rpk/handling/rpk_rattle.wav"

    SWEP.SlideBone = "v_weapon.ump45_Bolt"
    SWEP.SlideVector = Vector(0, 0, 0)
    
    SWEP.CorrectPosX = -16
    SWEP.CorrectPosY = 5.7
    SWEP.CorrectPosZ = -6.5
    
    SWEP.CorrectAngPitch = -5
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.CorrectSize = 1

    SWEP.MuzzleFXPos = Vector(17,0,-1)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-5.3,0.2,0)
    SWEP.addPos = Vector(0,-1.2,6.4)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)

    SWEP.PossibleAtt = {
        ["WMRS"] = {
            name = "wmrs",
            CorrectPosX = 20,
            CorrectPosY = -4.57,
            CorrectPosZ = 13,

            CorrectAngPitch = 190,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            ChangesCamera = true,

            CameraPos = Vector(7,5,1.112),

            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_belomo_pk_06_mark_000.png",

            ReticleUp = 8,
            ReticleRight = 1.3,
            ReticleSize = 12,

            Holo = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/scope_all_walther_mrs.mdl"
        },
    }
end