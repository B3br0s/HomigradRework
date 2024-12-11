if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Beretta PX4"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_pist_px4.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_pist_px4.mdl"
    
    SWEP.Primary.ClipSize		= 13
    SWEP.Primary.DefaultClip	= 13
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 40
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"homicide_weapons/hndg_beretta92fs/beretta92_fire1.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m9/m9_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(4.7,7,0.41)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "zcitysnd/sound/weapons/m9/handling/m9_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/m9/handling/m9_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/m9/handling/m9_boltrelease.wav"

    SWEP.DeploySound = "csgo/weapons/usp/usp_draw.wav"

    SWEP.SlideBone = "ValveBiped.Slide"
    SWEP.SlideVector = Vector(0, 0, -2)
    
    SWEP.CorrectPosX = -0.50
    SWEP.CorrectPosY = 0.7
    SWEP.CorrectPosZ = -0.2
    
    SWEP.CorrectAngPitch = -0.5
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(5,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,-0.2,0)
    SWEP.addPos = Vector(0,-0.5,4.3)

    SWEP.Fake1 = Vector(0,0,0)--X(Вперед),Y(Вправо),Z(Вверх)
end