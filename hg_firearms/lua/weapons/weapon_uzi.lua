if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "UZI"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты Пулемёты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/tfa_ins2/w_uzi.mdl"
    SWEP.WorldModel				= "models/weapons/tfa_ins2/w_uzi.mdl"
    
    SWEP.Primary.ClipSize		= 35
    SWEP.Primary.DefaultClip	= 35
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "4.6×30 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 55
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"weapons/tfa_ins2/vz61/vz61_fp.wav"}
    SWEP.Primary.SoundFar = "arccw_go/ump45/ump45-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.08
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(4.37,7,1.18)
    SWEP.CameraAng = Angle(-20,0,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/m16a4/handling/m16_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/m16a4/handling/m16_magin.wav"
    SWEP.Reload3 = ""
    SWEP.Reload4 = "weapons/tfa_ins2/vityaz/vityaz_boltrelease.wav"

    SWEP.DeploySound = "weapons/rpk/handling/rpk_rattle.wav"

    SWEP.SlideBone = nil
    
    SWEP.CorrectPosX = 9
    SWEP.CorrectPosY = 0.71
    SWEP.CorrectPosZ = -1.6
    
    SWEP.CorrectAngPitch = -10
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.CorrectSize = 1

    SWEP.MuzzleFXPos = Vector(17,0,0.5)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-9.8,-0.85,0)
    SWEP.addPos = Vector(0,-0.9,5.5)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(10,0,0)
end