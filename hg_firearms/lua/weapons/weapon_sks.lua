if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "СКС"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/tfa_ins2/w_b2k_sks.mdl"
    SWEP.WorldModel				= "models/weapons/tfa_ins2/w_b2k_sks.mdl"
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "7.62x39 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 35
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/sks/sks_fp.wav"}
    SWEP.Primary.SoundFar = "sounds_zcity/sks/dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(5.34,3.5,0.71)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "weapons/darsu_eft/ak/ak74_magout_plastic.ogg"
    SWEP.Reload2 = "weapons/darsu_eft/ak/ak74_magin_plastic.ogg"
    SWEP.Reload3 = "weapons/darsu_eft/ak/ak74_slider_up.ogg"
    SWEP.Reload4 = "weapons/darsu_eft/ak/ak74_slider_down.ogg"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "W_BOLT"
    SWEP.SlideVector = Vector(-4, 0, -0.5)
    
    SWEP.CorrectPosX = 4.7
    SWEP.CorrectPosY = 0.9
    SWEP.CorrectPosZ = -1
    
    SWEP.CorrectAngPitch = -5
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(28,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-5,0,0)
    SWEP.addPos = Vector(0,-0.2,5)

    SWEP.Fake1 = Vector(4,0,0)
    SWEP.Fake2 = Vector(11,1,-3)
end