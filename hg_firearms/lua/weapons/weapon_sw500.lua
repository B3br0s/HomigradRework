if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "SW-500"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Револьверы"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/w_pist_sw500.mdl"
    SWEP.WorldModel				= "models/weapons/w_pist_sw500.mdl"
    
    SWEP.Primary.ClipSize		= 8
    SWEP.Primary.DefaultClip	= 8
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= ".44 Remington Magnum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 165
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/revolver/revolver_fp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/revolver/revolver_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.revolver = true
    SWEP.ReloadEmpty = true
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = nil

    SWEP.CameraPos = Vector(4.6,7,0.25)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.HammerSound = "zcitysnd/sound/weapons/revolver/handling/revolver_cock_hammer_ready.wav"

    SWEP.Reload1 = "csgo/weapons/revolver/revolver_siderelease.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/revolver/handling/revolver_dump_rounds_03.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/revolver/handling/revolver_speed_loader_insert_01.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/revolver/handling/revolver_close_chamber.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/revolver/handling/revolver_round_insert_single_03.wav"

    SWEP.SlideBone = nil
    SWEP.Delay = 0
    
    SWEP.CorrectPosX = -0.6
    SWEP.CorrectPosY = 1.1
    SWEP.CorrectPosZ = 0.1
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(10,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,0.6,0)
    SWEP.addPos = Vector(0,-0.1,4.5)

    SWEP.Fake1 = Vector(-13,-4.3,-5)
end