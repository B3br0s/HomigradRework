if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Five-Seven"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/arccw_go/v_pist_fiveseven.mdl"
    SWEP.WorldModel				= "models/weapons/arccw_go/v_pist_fiveseven.mdl"
    
    SWEP.Primary.ClipSize		= 20
    SWEP.Primary.DefaultClip	= 20
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "5.7×28 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 65
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"arccw_go/fiveseven/fiveseven_01.wav"}
    SWEP.Primary.SoundFar = "arccw_go/fiveseven/fiveseven-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(4.25,7,0.35)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "arccw_go/fiveseven/fiveseven_clipout.wav"
    SWEP.Reload2 = "arccw_go/fiveseven/fiveseven_clipin.wav"
    SWEP.Reload3 = "arccw_go/fiveseven/fiveseven_slideback.wav"
    SWEP.Reload4 = "arccw_go/fiveseven/fiveseven_sliderelease.wav"

    SWEP.DeploySound = "arccw_go/fiveseven/fiveseven_draw.wav"

    SWEP.SlideBone = "v_weapon.fiveSeven_slide"
    SWEP.SlideVector = Vector(0, 0, -3)
    
    SWEP.CorrectPosX = -13
    SWEP.CorrectPosY = 4.1
    SWEP.CorrectPosZ = -5.05
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(7,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.6,-0.4,0)
    SWEP.addPos = Vector(0,-0.5,3.4)

    SWEP.Fake1 = Vector(-13,-4.3,-5)
end