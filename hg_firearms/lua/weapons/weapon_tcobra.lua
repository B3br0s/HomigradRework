if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Thanez Cobra"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Револьверы"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_thanez_cobra.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_thanez_cobra.mdl"
    
    SWEP.Primary.ClipSize		= 6
    SWEP.Primary.DefaultClip	= 6
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= ".44 Remington Magnum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 75
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"homicide_weapons/hndg_colt1911/colt_1911_fire1.wav"}
    SWEP.Primary.SoundFar = "arccw_go/revolver/revolver-1_distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.revolver = true
    SWEP.ReloadEmpty = true
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = nil

    SWEP.CameraPos = Vector(5.05,7,0.47)
    SWEP.CameraAng = Angle(0,5,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.HammerSound = "arccw_go/revolver/revolver_prepare.wav"

    SWEP.Reload1 = "arccw_go/revolver/revolver_siderelease.wav"
    SWEP.Reload2 = "arccw_go/revolver/revolver_clipout.wav"
    SWEP.Reload3 = "arccw_go/revolver/revolver_clipin.wav"
    SWEP.Reload4 = "arccw_go/revolver/revolver_sideback.wav"

    SWEP.DeploySound = "arccw_go/revolver/revolver_draw.wav"

    SWEP.SlideBone = "shooter"
    SWEP.Delay = 0  
    SWEP.SlideAngle = Angle(0, 35, 0) 
    
    SWEP.CorrectPosX = 4.5
    SWEP.CorrectPosY = 1.3
    SWEP.CorrectPosZ = -1.8
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.CorrectSize = 0.8

    SWEP.MuzzleFXPos = Vector(10,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.25,-0.2,0)
    SWEP.addPos = Vector(0,-0.6,4.5)

    SWEP.Fake1 = Vector(-13,-4.3,-5)
end