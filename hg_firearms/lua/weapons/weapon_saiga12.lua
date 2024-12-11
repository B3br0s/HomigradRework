if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Сайга-12"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Дробовики"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/pwb/weapons/w_saiga_12.mdl"
    SWEP.WorldModel				= "models/pwb/weapons/w_saiga_12.mdl"
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "12/70 gauge"
    SWEP.Primary.Cone = 0.1
    SWEP.Primary.Damage = 1.5 * 55
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"weapons/darsu_eft/ak/fire_new/saiga_outdoor_close2.ogg","weapons/darsu_eft/ak/fire_new/saiga_outdoor_close1.ogg"}
    SWEP.Primary.SoundFar = "arccw_go/xm1014/xm1014-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.2
    SWEP.HoldType = "ar2"
    SWEP.NumBullet = 8
    SWEP.shotgun = true
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "ShotGun"

    SWEP.CameraPos = Vector(6.7,3,0.87)
    SWEP.CameraAng = Angle(0,0,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/ak47/handling/ak47_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/ak47/handling/ak47_magin.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltrelease.wav"

    SWEP.DeploySound = "arccw_go/xm1014/xm1014_draw.wav"

    SWEP.SlideBone = nil
    
    SWEP.CorrectPosX = 13
    SWEP.CorrectPosY = 0.6
    SWEP.CorrectPosZ = 3.5
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(28,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.5,-0.2,0)
    SWEP.addPos = Vector(0,-0.7,3.5)

    SWEP.Fake1 = Vector(10,0,5)
    SWEP.Fake2 = Vector(15,0,0)
end