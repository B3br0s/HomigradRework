if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "AR-15"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/weapons_hmgd/v_ar15_tac.mdl"
    SWEP.CorrectModel           = "models/weapons/weapons_hmgd/v_ar15_tac.mdl"
    SWEP.WorldModel				= "models/weapons/weapons_hmgd/w_notmicro_saigry.mdl"
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "5.56x45 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 55
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/m4a1/m4a1_fp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m4a1/m4a1_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "smg"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(6.95,4,0.93)
    SWEP.CameraAng = Angle(0,-10,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/mk18/handling/mk18_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/mk18/handling/mk18_hit.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/mk18/handling/mk18_boltrelease.wav"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = nil

    SWEP.CorrectPosX = -16
    SWEP.CorrectPosY = 6.8
    SWEP.CorrectPosZ = -9.5
    
    SWEP.CorrectAngPitch = 180
    SWEP.CorrectAngYaw = -180
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(28,0,-2)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,-0.2,0)
    SWEP.addPos = Vector(0,-1,6.4)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)
end