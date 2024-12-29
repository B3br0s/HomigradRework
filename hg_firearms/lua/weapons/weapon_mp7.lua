if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "MP7"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты Пулемёты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_mp7.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_mp7.mdl"
    
    SWEP.Primary.ClipSize		= 35
    SWEP.Primary.DefaultClip	= 35
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "4.6×30 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 25
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"sounds_zcity/mp7/close.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/arccw_go/ump45/ump45-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.08
    SWEP.HoldType = "smg"
    SWEP.EmptyBoltOut = true
    SWEP.Grip = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(6.05,6,0.975)
    SWEP.CameraAng = Angle(0,0,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "weapons/mp40/handling/mp40_magout.wav"
    SWEP.Reload2 = "weapons/mp40/handling/mp40_magin.wav"
    SWEP.Reload3 = "weapons/mp5k/handling/mp5k_boltrelease.wav"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "weapons/rpk/handling/rpk_rattle.wav"

    SWEP.SlideBone = "Slide_mp7"
    SWEP.SlideVector = Vector(0, 0, -3)
    
    SWEP.CorrectPosX = -0.5
    SWEP.CorrectPosY = 0.5
    SWEP.CorrectPosZ = -1
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.CorrectSize = 1

    SWEP.MuzzleFXPos = Vector(10,0,-2)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.2,-0.4,0)
    SWEP.addPos = Vector(0,0,7.7)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)

    SWEP.PossibleAtt = {
    ["WMRS"] = { -- название
        name = "wmrs", -- название
        CorrectPosX = 3.6, -- Позиция X
        CorrectPosY = 0.5, -- Позиция Y
        CorrectPosZ = 6.4, -- Позиция Z

        CorrectAngPitch = 180, 
        CorrectAngYaw = 180,
        CorrectAngRoll = 0,

        ChangesCamera = true,

        CameraPos = Vector(6.8,3.56,1),

        ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_belomo_pk_06_mark_000.png",

        ReticleUp = 7,
        ReticleRight = 0.8,
        ReticleSize = 10.3,

        Holo = true,

        AttModel = "models/weapons/arc9/darsu_eft/mods/scope_all_walther_mrs.mdl" -- Моделька
},
    }

end