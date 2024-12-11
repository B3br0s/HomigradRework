if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "АС-ВАЛ"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_asval.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_asval.mdl"
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "9x39 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 40
    SWEP.Primary.Spread = 0
    SWEP.Recoil = -0.3
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/mp5k/mp5k_suppressed_fp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/arccw_go/ump45/ump45-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.08
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(5.1,2,0.875)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/ak47/handling/ak47_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/ak47/handling/ak47_magin.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltrelease.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "Slide"
    SWEP.SlideVector = Vector(-5, 0, 1)
    
    SWEP.CorrectPosX = 2.8
    SWEP.CorrectPosY = 0.9
    SWEP.CorrectPosZ = 0.7
    
    SWEP.CorrectAngPitch = -5
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(30,0,1)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-5, 0.2, 0)
    SWEP.addPos = Vector(0,-0.5,5)

    SWEP.Fake1 = Vector(0,0,3)
    SWEP.Fake2 = Vector(12,0,0)

    SWEP.PossibleAtt = {
        ["Okp7"] = {
            name = "okp7",
            CorrectPosX = 0,
            CorrectPosY = 0.1,
            CorrectPosZ = 5,

            CorrectAngPitch = 190,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            ChangesCamera = true,

            CameraPos = Vector(5.8,3.5,0.815),

            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_ekb_okp7_true_marks.png",

            ReticleUp = 7,
            ReticleRight = 0.8,
            ReticleSize = 7,

            Holo = true,

            AttModel = "models/weapons/arc9_eft_shared/atts/optic/dovetail/okp7.mdl"
        }
    }
end