if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "M60"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пулемёты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/pwb2/weapons/w_m60.mdl"
    SWEP.WorldModel				= "models/pwb2/weapons/w_m60.mdl"
    
    SWEP.Primary.ClipSize		= 70
    SWEP.Primary.DefaultClip	= 70
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "7.62x54 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 85
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/m249/m249_tp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m249/m249_dist.wav"
    SWEP.ReloadTime = 2.4
    SWEP.TwoHands = true
    SWEP.ReloadEmpty = true
    SWEP.ShootWait = 0.12
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = nil

    SWEP.CameraPos = Vector(8.5,4,0.93)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/m249/handling/m249_beltpullout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/m249/handling/m249_magout_full.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/m249/handling/m249_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/m249/handling/m249_boltrelease.wav"

    SWEP.DeploySound = "arccw_go/negev/negev_draw.wav"

    SWEP.SlideBone = nil
    
    SWEP.CorrectPosX = 3
    SWEP.CorrectPosY = 0.5
    SWEP.CorrectPosZ = -1
    
    SWEP.CorrectAngPitch = 180
    SWEP.CorrectAngYaw = 180
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(29,0,-1)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,-0.1,0)
    SWEP.addPos = Vector(0,-1.1,6.2)

    SWEP.Fake1 = Vector(0,0,0)
    SWEP.Fake2 = Vector(15,0,0)
end