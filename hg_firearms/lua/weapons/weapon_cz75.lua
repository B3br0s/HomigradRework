if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "CZ-75"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_cz75.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_cz75.mdl"
    
    SWEP.Primary.ClipSize		= 12
    SWEP.Primary.DefaultClip	= 12
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 45
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"homicide_weapons/hndg_mkiii/mkiii_fire_01.wav"}
    SWEP.Primary.SuppressedSound = "m9/m9_suppressed_fp.wav"
    SWEP.Primary.SoundFar = "homicide_arccw_go/ump45/ump45-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.CameraPos = Vector(3.95,7,0.085)
    SWEP.ShellType = "Pistol"
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "arccw_go/fiveseven/fiveseven_clipout.wav"
    SWEP.Reload2 = "arccw_go/fiveseven/fiveseven_clipin.wav"
    SWEP.Reload3 = "arccw_go/fiveseven/fiveseven_slideback.wav"
    SWEP.Reload4 = "arccw_go/fiveseven/fiveseven_sliderelease.wav"

    SWEP.DeploySound = "arccw_go/fiveseven/fiveseven_draw.wav"

    SWEP.SlideBone = "Slide"
    SWEP.SlideVector = Vector(-2, 0, 0.3)  
    
    SWEP.CorrectPosX = 13.5
    SWEP.CorrectPosY = 0.71
    SWEP.CorrectPosZ = 2.5
    
    SWEP.CorrectAngPitch = -7
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(10,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-6,0.2,0)
    SWEP.addPos = Vector(0,-0.15,4.52)

    SWEP.Fake1 = Vector(4,-1,-1.5)
end