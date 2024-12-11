if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "ПКМ"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пулемёты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/pwb2/weapons/w_pkm.mdl"
    SWEP.WorldModel				= "models/pwb2/weapons/w_pkm.mdl"
    
    SWEP.Primary.ClipSize		= 100
    SWEP.Primary.DefaultClip	= 100
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "7.62x54 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 85
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/rpk/rpk_fp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/rpk/rpk_dist.wav"
    SWEP.ReloadTime = 2.4
    SWEP.TwoHands = true
    SWEP.ReloadEmpty = true
    SWEP.ShootWait = 0.09
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = nil

    SWEP.CameraPos = Vector(6.7,4,0.915)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/m249/handling/m249_beltpullout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/m249/handling/m249_magout_full.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/m249/handling/m249_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/m249/handling/m249_boltrelease.wav"

    SWEP.DeploySound = "arccw_go/negev/negev_draw.wav"

    SWEP.SlideBone = nil  
    
    SWEP.CorrectPosX = -1
    SWEP.CorrectPosY = 0.71
    SWEP.CorrectPosZ = -0.47
    
    SWEP.CorrectAngPitch = 180
    SWEP.CorrectAngYaw = 180
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(26,0,-1)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,0,0)
    SWEP.addPos = Vector(0,-1.5,6.3)

    SWEP.Fake1 = Vector(0,0,0)
    SWEP.Fake2 = Vector(15,0,-3)
end