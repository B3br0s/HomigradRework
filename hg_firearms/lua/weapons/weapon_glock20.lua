if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Glock 20"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/tfa_fas2/c_g20.mdl"
    SWEP.WorldModel				= "models/weapons/tfa_fas2/c_g20.mdl"
    
    SWEP.Primary.ClipSize		= 12
    SWEP.Primary.DefaultClip	= 12
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 50
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"homicide_weapons/hndg_glock17/glock_fire_01.wav"}
    SWEP.Primary.SuppressedSound = "zcitysnd/sound/weapons/m1911/m1911_suppressed_fp.wav"
    SWEP.Primary.SoundFar = "csgo/weapons/glock18/glock18-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(3.8,7,0.43)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "zcitysnd/sound/weapons/m1911/handling/m1911_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/m1911/handling/m1911_maghit.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/m1911/handling/m1911_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/m1911/handling/m1911_boltrelease.wav"

    SWEP.DeploySound = "csgo/weapons/usp/usp_draw.wav"

    SWEP.SlideBone = "glock_slide"
    SWEP.SlideVector = Vector(0, 2, 0)
    
    SWEP.CorrectPosX = -17
    SWEP.CorrectPosY = 4.2
    SWEP.CorrectPosZ = -5
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.CorrectSize = 1.2

    SWEP.MuzzleFXPos = Vector(6,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.5, -0.2, 0)
    SWEP.addPos = Vector(0,-0.8, 4)

    SWEP.Fake1 = Vector(-13,-4.3,-5)--X(Вперед),Y(Вправо),Z(Вверх)
end