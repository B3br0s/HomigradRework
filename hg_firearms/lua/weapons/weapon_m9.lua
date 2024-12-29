if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Beretta M9"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/tfa_ins2/w_m9.mdl"
    SWEP.CorrectModel           = "models/weapons/tfa_ins2/c_beretta.mdl"
    SWEP.WorldModel				= "models/weapons/tfa_ins2/w_m9.mdl"
    
    SWEP.Primary.ClipSize		= 15
    SWEP.Primary.DefaultClip	= 15
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 35
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/firearms/hndg_beretta92fs/beretta92_fire1.wav"}  
    SWEP.Primary.SoundFar = "arccw_go/elite/elite-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(4,7,0.515)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "arccw_go/elite/elite_clipout.wav"
    SWEP.Reload2 = "arccw_go/elite/elite_rightclipin.wav"
    SWEP.Reload3 = "arccw_go/elite/elite_sliderelease.wav"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "arccw_go/usp/usp_draw.wav"

    SWEP.SlideBone = "Slide"
    SWEP.SlideVector = Vector(0, 2.3, 0)
    
    SWEP.CorrectPosX = 8
    SWEP.CorrectPosY = 1.2
    SWEP.CorrectPosZ = -1
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(10,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.4,-0.15,0)
    SWEP.addPos = Vector(0,-0.5,3.8)

    SWEP.Fake1 = Vector(0,0,0)--X(Вперед),Y(Вправо),Z(Вверх)
end