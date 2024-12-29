if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Kriss Vector"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты Пулемёты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_vectorsmg.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_vectorsmg.mdl"
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 25
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"sounds_zcity/vector/close.wav"}
    SWEP.Primary.SoundFar = "sounds_zcity/vector/dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.08
    SWEP.HoldType = "smg"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(4,6,0.26)
    SWEP.CameraAng = Angle(-4,5,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/mp40/handling/mp40_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/mp40/handling/mp40_magin.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/m16a4/handling/m16_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/m16a4/handling/m16_boltrelease.wav"

    SWEP.DeploySound = "weapons/rpk/handling/rpk_rattle.wav"

    SWEP.SlideBone = "Slide_vector"
    SWEP.SlideVector = Vector(0, 0, -3)
    
    SWEP.CorrectPosX = 0.7
    SWEP.CorrectPosY = 1.2
    SWEP.CorrectPosZ = 1
    
    SWEP.CorrectAngPitch = -10
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.CorrectSize = 1

    SWEP.MuzzleFXPos = Vector(13,0,-1.5)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-10,0.3,0)
    SWEP.addPos = Vector(0,-0.15,4.6)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(10,0,0)
end