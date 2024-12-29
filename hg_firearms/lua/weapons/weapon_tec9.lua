if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Tec-9"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/tec9/w_tec9.mdl"
    SWEP.WorldModel				= "models/tec9/w_tec9.mdl"
    
    SWEP.Primary.ClipSize		= 20
    SWEP.Primary.DefaultClip	= 20
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0.03
    SWEP.Primary.Damage = 1.5 * 32
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"sounds_zcity/tec9/close.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m1a1/m1a1_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(4.26,9,-0.015)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "arccw_go/tec9/tec9_clipout.wav"
    SWEP.Reload2 = "arccw_go/tec9/tec9_clipin.wav"
    SWEP.Reload3 = "arccw_go/tec9/tec9_boltpull.wav"
    SWEP.Reload4 = "arccw_go/tec9/tec9_boltrelease.wav"

    SWEP.DeploySound = "arccw_go/usp/usp_draw.wav"

    SWEP.SlideBone = "Bone02"
    SWEP.SlideVector = Vector(-5.7, 0, 0.5)
    
    SWEP.CorrectPosX = 3
    SWEP.CorrectPosY = 1.7
    SWEP.CorrectPosZ = -0.48
    
    SWEP.CorrectAngPitch = 180
    SWEP.CorrectAngYaw = 180
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(10,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,0,0)
    SWEP.addPos = Vector(0,-0.3,4.2)

    SWEP.Fake1 = Vector(5,-2,0)--X(Вперед),Y(Вправо),Z(Вверх)
end