if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "АК74"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/tfa_ins2/akpack/w_ak74.mdl"
    SWEP.WorldModel				= "models/weapons/tfa_ins2/akpack/w_ak74.mdl"
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "7.62x39 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 75
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"weapons/tfa_ins2/sks/sks_fp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/fnfal/fnfal_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(5.3,2.5,0.812)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "weapons/darsu_eft/ak/ak74_magout_plastic.ogg"
    SWEP.Reload2 = "weapons/darsu_eft/ak/ak74_magin_plastic.ogg"
    SWEP.Reload3 = "weapons/darsu_eft/ak/ak74_slider_up.ogg"
    SWEP.Reload4 = "weapons/darsu_eft/ak/ak74_slider_down.ogg"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "W_BOLT"
    SWEP.SlideVector = Vector(-6, 1, -0.6)
    
    SWEP.CorrectPosX = 4.7
    SWEP.CorrectPosY = 0.9
    SWEP.CorrectPosZ = -1
    
    SWEP.CorrectAngPitch = -5
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(28,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-4.9,0.2,0)
    SWEP.addPos = Vector(0,-1.6,5.2)

    SWEP.Fake1 = Vector(5,0,0)
    SWEP.Fake2 = Vector(17,0,0)
end