if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "KSG"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Дробовики"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/pwb2/weapons/w_ksg.mdl"
    SWEP.WorldModel				= "models/pwb2/weapons/w_ksg.mdl"
    
    SWEP.Primary.ClipSize		= 12
    SWEP.Primary.DefaultClip	= 12
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "12/70 gauge"
    SWEP.Primary.Cone = 0.01
    SWEP.Primary.Damage = 1.5 * 25
    SWEP.Primary.Spread = 0
    SWEP.Recoil = 4
    SWEP.Primary.Sound = {"sounds_zcity/remington870/close.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/mosin/mosin_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "ar2"
    SWEP.NumBullet = 5
    SWEP.shotgun = true
    SWEP.RubberBullets = true
    SWEP.Pump = true
    SWEP.Pumped = true
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = nil

    SWEP.CameraPos = Vector(6.8,2,1.025)
    SWEP.CameraAng = Angle(0,5,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = ""
    SWEP.Reload2 = ""
    SWEP.Reload3 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltrelease.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/m14/handling/m14_rattle.wav"

    SWEP.SlideBone = nil  
    
    SWEP.CorrectPosX = 1.5
    SWEP.CorrectPosY = 0.71
    SWEP.CorrectPosZ = 1.01
    
    SWEP.CorrectAngPitch = 175
    SWEP.CorrectAngYaw = 180
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(20,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-4.7,-0,0)
    SWEP.addPos = Vector(0,-1,4.7)

    SWEP.Fake1 = Vector(0,0,2)
    SWEP.Fake2 = Vector(14,0,0)
end