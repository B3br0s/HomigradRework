if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "АКС74У"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/akpack/w_aks74u.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/akpack/w_aks74u.mdl"
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "7.62x39 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 75
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"weapons/tfa_ins2/ak103/ak103_fp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m16a4/m16a4_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(5.7,3.5,0.9)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "weapons/darsu_eft/ak/ak74_magout_plastic.ogg"
    SWEP.Reload2 = "weapons/darsu_eft/ak/ak74_magin_plastic.ogg"
    SWEP.Reload3 = "weapons/darsu_eft/ak/ak74_slider_up.ogg"
    SWEP.Reload4 = "weapons/darsu_eft/ak/ak74_slider_down.ogg"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "Slide"
    SWEP.SlideVector = Vector(-5, 0, 0)
    
    SWEP.CorrectPosX = 4.7
    SWEP.CorrectPosY = 0.9
    SWEP.CorrectPosZ = -1
    
    SWEP.CorrectAngPitch = -5
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(22,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-5.2,0.6,0)
    SWEP.addPos = Vector(0,-0.9,6)
    
    SWEP.Fake1 = Vector(5,0,0)
    SWEP.Fake2 = Vector(12,0,0)

    SWEP.PossibleAtt = {
        ["Ekp1s"] = {
            name = "ekp1s",
            CorrectPosX = 0,
            CorrectPosY = -0.27,
            CorrectPosZ = 6.8,
        
            CorrectAngPitch = 190,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,
        
            ChangesCamera = true,
        
            CameraPos = Vector(6.3,3.5,0.815),
        
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_belomo_pk_06_mark_000.png",
        
            ReticleUp = 7,
            ReticleRight = 0.8,
            ReticleSize = 7,
        
            Holo = true,
        
            AttModel = "models/weapons/arc9_eft_shared/atts/optic/dovetail/ekp1s03.mdl"
        }
    }
end