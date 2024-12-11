if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Draco"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/draco/w_draco.mdl"
    SWEP.WorldModel				= "models/draco/w_draco.mdl"
    
    SWEP.Primary.ClipSize		= 25
    SWEP.Primary.DefaultClip	= 25
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "7.62x39 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 35
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/galil/galil_fp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/fnfal/fnfal_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(5.2,4,0.05)
    SWEP.CameraAng = Angle(0,0,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/ak47/handling/ak47_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/ak47/handling/ak47_magin.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltrelease.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = nil  
    
    SWEP.CorrectPosX = 5
    SWEP.CorrectPosY = 1.3
    SWEP.CorrectPosZ = -0.6
    
    SWEP.CorrectAngPitch = 180
    SWEP.CorrectAngYaw = 176
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(16,0,-2)
    SWEP.UsingVM = true
    SWEP.BodyGroup = 
    {[1] = 1}
    SWEP.addAng = Angle(0,-3.8,0)
    SWEP.addPos = Vector(0,-1.3,6.5)

    SWEP.Fake1 = Vector(0,0,0)

    SWEP.PossibleAtt = {
        ["WMRS"] = {
            name = "WMRS",
            CorrectPosX = 0,
            CorrectPosY = -0.66,
            CorrectPosZ = 5,
    
            CorrectAngPitch = 182,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,
    
            ChangesCamera = true,
    
            CameraPos = Vector(5.8,4,0.05),
    
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_base_aimpoint_micro_t1_mark.png",
    
            ReticleUp = 3,
            ReticleRight = 0.1,
            ReticleSize = 16,
    
            Holo = true,
    
            AttModel = "models/weapons/arc9/darsu_eft/mods/scope_all_walther_mrs.mdl"
        }
    }
end