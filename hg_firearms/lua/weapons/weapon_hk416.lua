if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "HK-416"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_hk416.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_hk416.mdl"
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "5.56x45 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 55
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/m4a1/m4a1_fp.wav"}
    SWEP.Primary.SuppressedSound = "zcitysnd/sound/weapons/m4a1/m4a1_suppressed_fp.wav"
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m4a1/m4a1_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.09
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(6.6,5,1.1)
    SWEP.CameraAng = Angle(-2,5,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/m4a1/handling/m4a1_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/m4a1/handling/m4a1_magin.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/m4a1/handling/m4a1_boltrelease.wav"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "zcitysnd/sound/weapons/m4a1/handling/m4a1_fireselect.wav"

    SWEP.SlideBone = "Bolt"
    SWEP.SlideVector = Vector(0, 0, -5)
    
    SWEP.CorrectPosX = 4.4
    SWEP.CorrectPosY = 0.7
    SWEP.CorrectPosZ = -1.5
    
    SWEP.CorrectAngPitch = 180
    SWEP.CorrectAngYaw = 180
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(25,-1,-2.5)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-0.1,0,0)
    SWEP.addPos = Vector(0,-1,7.3)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)

    SWEP.PossibleAtt = {
        ["Monolith"] = {
            name = "monolith",
            CorrectPosX = 28.5,
            CorrectPosY = 0.5,
            CorrectPosZ = 6.2,

            CorrectAngPitch = 0,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            Suppress = true,

            AttModel = "models/weapons/csgo/weapons/atts/supp_monolith.mdl"
        },
        ["Eotech553"] = {
            name = "eotech553",
            CorrectPosX = 0,
            CorrectPosY = 0.36,
            CorrectPosZ = 7.7,

            CorrectAngPitch = 180,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            ChangesCamera = true,

            CameraPos = Vector(7.6,5,1.1),

            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_eotech_xps3-0_marks.png",

            ReticleUp = 8,
            ReticleRight = 0.8,
            ReticleSize = 8,

            Holo = true,

            AttModel = "models/weapons/arc9_eft_shared/atts/optic/eft_optic_xps3_0.mdl"
        }
    }
end