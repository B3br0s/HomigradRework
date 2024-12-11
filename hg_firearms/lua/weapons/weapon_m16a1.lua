if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "M16A1"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/ar15/w_dan_m16a1.mdl"
    SWEP.WorldModel				= "models/ar15/w_dan_m16a1.mdl"
    
    SWEP.Primary.ClipSize		= 20
    SWEP.Primary.DefaultClip	= 20
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "5.56x45 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 55
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/m16a4/m16a4_fp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m16a4/m16a4_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(6.95,4,0.38)
    SWEP.CameraAng = Angle(0,-10,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/mk18/handling/mk18_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/mk18/handling/mk18_hit.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/mk18/handling/mk18_boltrelease.wav"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = nil
    
    SWEP.CorrectPosX = -2
    SWEP.CorrectPosY = 1.33
    SWEP.CorrectPosZ = -0.5
    
    SWEP.CorrectAngPitch = 180
    SWEP.CorrectAngYaw = 176
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(30,0,-2)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,-3.5,0)
    SWEP.addPos = Vector(0,-0.8,6.5)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)
end