if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Desert Eagle Mark XIX"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_deserteagle.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_deserteagle.mdl"
    
    SWEP.Primary.ClipSize		= 7
    SWEP.Primary.DefaultClip	= 7
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= ".44 Remington Magnum"
    SWEP.Primary.Cone = 0.03
    SWEP.Primary.Damage = 1.7 * 32
    SWEP.Primary.Spread = 0
    SWEP.Recoil = 5
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/firearms/hndg_colt1911/colt_1911_fire1.wav"}
    SWEP.Primary.SoundFar = "sounds_zcity/deagle/dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.2
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(4.5,9,0.59)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "zcitysnd/sound/weapons/m16a4/handling/m16_magin.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/m16a4/handling/m16_hit.wav"
    SWEP.Reload3 = " "
    SWEP.Reload4 = "zcitysnd/sound/weapons/m16a4/handling/m16_boltrelease.wav"

    SWEP.DeploySound = "arccw_go/usp/usp_draw.wav"

    SWEP.SlideBone = "slide"
    SWEP.SlideVector = Vector(-3.5, 0, 0.5)
    
    SWEP.CorrectPosX = -0.5
    SWEP.CorrectPosY = 0
    SWEP.CorrectPosZ = 0.5
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(10,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.8,-0.35,0)
    SWEP.addPos = Vector(0,-0.56,4.65)

    SWEP.Fake1 = Vector(4,0,3)--X(Вперед),Y(Вправо),Z(Вверх)
end