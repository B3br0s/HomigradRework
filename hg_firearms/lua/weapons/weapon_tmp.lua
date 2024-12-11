if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "TMP"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты Пулемёты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_tmp.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_tmp.mdl"
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 35
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"arccw_go/mp9/mp9_01.wav","arccw_go/mp9/mp9_02.wav","arccw_go/mp9/mp9_03.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/arccw_go/ump45/ump45-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.08
    SWEP.HoldType = "smg"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(7.15,2,0.732)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/mp5k/handling/mp5k_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/mp5k/handling/mp5k_magin.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/mp5k/handling/mp5k_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/mp5k/handling/mp5k_boltrelease.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "slide_tmp"
    SWEP.SlideVector = Vector(0, 0, -3)
    
    SWEP.CorrectPosX = 20
    SWEP.CorrectPosY = 0.71
    SWEP.CorrectPosZ = 2.52
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.CorrectSize = 1.1

    SWEP.MuzzleFXPos = Vector(14,0,-2.6)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(2,0.7,0)
    SWEP.addPos = Vector(0,-0.4,7.6)

    SWEP.Fake1 = Vector(14,0,2)
    SWEP.Fake2 = Vector(10,0,0)
end