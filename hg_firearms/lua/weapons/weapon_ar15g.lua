if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "AR-15-G"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/ar15/w_colt6149.mdl"
    SWEP.WorldModel				= "models/ar15/w_colt6149.mdl"
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "5.56x45 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 35
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"sounds_zcity/ar_pistol/close.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m1a1/m1a1_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(6.95,6,-0.2)
    SWEP.CameraAng = Angle(0,-2,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/mk18/handling/mk18_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/mk18/handling/mk18_hit.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/mk18/handling/mk18_boltrelease.wav"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "Bolt"
    SWEP.SlideVector = Vector(0, 0, -5)
    
    SWEP.CorrectPosX = 0
    SWEP.CorrectPosY = 1.1
    SWEP.CorrectPosZ = -0.4
    
    SWEP.CorrectAngPitch = 180
    SWEP.CorrectAngYaw = 176
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(22,0,-1)
    SWEP.UsingVM = true
    SWEP.HasSight = true
    SWEP.addAng = Angle(-0.4,-4,0)
    SWEP.addPos = Vector(0,-1.4,6.6)

    SWEP.Fake1 = Vector(2,0,0)

    SWEP.CurrentAtt = {
        [1] = {
            name = "base",
            CorrectPosX = 7.1,
            CorrectPosY = -0.35,
            CorrectPosZ = 6,

            CorrectAngPitch = 180,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_walther_mrs_mark_001.png",

            ReticleUp = 7,
            ReticleRight = 0.7,
            ReticleSize = 5,

            Holo = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/scope_all_vomz_pilad_p1x42_weaver.mdl"
        },
    }
end