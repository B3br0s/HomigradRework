if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "R8"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Револьверы"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/arccw_go/v_pist_r8.mdl"
    SWEP.WorldModel				= "models/weapons/arccw_go/v_pist_r8.mdl"
    
    SWEP.Primary.ClipSize		= 8
    SWEP.Primary.DefaultClip	= 8
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= ".44 Remington Magnum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 165
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"csgo/weapons/revolver/revolver-1_01.wav"}
    SWEP.Primary.SoundFar = "csgo/weapons/revolver/revolver-1_distant.wav"
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

    SWEP.HammerSound = "csgo/weapons/revolver/revolver_prepare.wav"

    SWEP.Reload1 = "csgo/weapons/revolver/revolver_siderelease.wav"
    SWEP.Reload2 = "csgo/weapons/revolver/revolver_clipout.wav"
    SWEP.Reload3 = "csgo/weapons/revolver/revolver_clipin.wav"
    SWEP.Reload4 = "csgo/weapons/revolver/revolver_sideback.wav"

    SWEP.DeploySound = "csgo/weapons/revolver/revolver_draw.wav"

    SWEP.SlideBone = "v_weapon.hammer"
    SWEP.Delay = 0
    SWEP.SlideAngle = Angle(0, 0, -35) 
    
    SWEP.CorrectPosX = -12
    SWEP.CorrectPosY = 5.22
    SWEP.CorrectPosZ = -5.5
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(10,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,0.6,0)
    SWEP.addPos = Vector(0,-0.1,4.5)

    SWEP.Fake1 = Vector(-13,-4.3,-5)
end