if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    --SWEP.PrintName 				= "Негев"
    SWEP.PrintName 				= "Negev"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пулемёты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/csgo/weapons/v_mach_negev.mdl"
    SWEP.WorldModel				= "models/weapons/csgo/weapons/v_mach_negev.mdl"
    
    SWEP.Primary.ClipSize		= 100
    SWEP.Primary.DefaultClip	= 100
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "7.62x54 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 35
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"csgo/weapons/negev/negev_01.wav","csgo/weapons/negev/negev_02.wav","csgo/weapons/negev/negev_05.wav"}
    SWEP.Primary.SoundFar = "csgo/weapons/negev/negev-1-distant.wav"
    SWEP.ReloadTime = 2.4
    SWEP.TwoHands = true
    SWEP.ReloadEmpty = true
    SWEP.ShootWait = 0.07
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = nil

    SWEP.CameraPos = Vector(7.9,8,0.86)
    SWEP.CameraAng = Angle(0,10,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "homigrad/france/ineedabullets2.wav"
    SWEP.Reload2 = "csgo/weapons/m249/m249_coverdown.wav"
    SWEP.Reload3 = "csgo/weapons/m249/m249_coverup.wav"
    SWEP.Reload4 = "csgo/weapons/negev/negev_pump.wav"

    SWEP.DeploySound = "csgo/weapons/negev/negev_draw.wav"

    SWEP.SlideBone = "v_weapon.chargehandle"
    SWEP.SlideVector = Vector(0, 0, -6)  
    
    SWEP.CorrectPosX = -17
    SWEP.CorrectPosY = 8.7
    SWEP.CorrectPosZ = -10
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(26,0,-1)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,0.2,0)
    SWEP.addPos = Vector(0,-0.6,7)

    SWEP.Fake1 = Vector(-11,-7,-4)
    SWEP.Fake2 = Vector(15,0,0)
end