if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "MP5"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты Пулемёты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/mp5/w_mp5_sef.mdl"
    SWEP.WorldModel				= "models/weapons/mp5/w_mp5_sef.mdl"
    
    SWEP.Primary.ClipSize		= 25
    SWEP.Primary.DefaultClip	= 25
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 25
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"arccw_go/mp7/mp7_01.wav","arccw_go/mp7/mp7_02.wav","arccw_go/mp7/mp7_03.wav"}
    SWEP.Primary.SoundFar = "arccw_go/ump45/ump45-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.08
    SWEP.HoldType = "ar2"
    SWEP.ReloadEmpty = true
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(6.30,3,1)
    SWEP.CameraAng = Angle(0,0,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/mp5k/handling/mp5k_boltback.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/mp5k/handling/mp5k_magout.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/mp5k/handling/mp5k_magin.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/mp5k/handling/mp5k_boltrelease.wav"

    SWEP.DeploySound = "weapons/rpk/handling/rpk_rattle.wav"

    SWEP.SlideBone = nil  
    
    SWEP.CorrectPosX = 6
    SWEP.CorrectPosY = 1.22
    SWEP.CorrectPosZ = -0.45
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.CorrectSize = 1

    SWEP.MuzzleFXPos = Vector(17,0,-1)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.5,-0.1,0)
    SWEP.addPos = Vector(0,-1.3,6.2)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)
end