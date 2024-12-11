if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Пистолет Макарова"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/m_models/w_pm.mdl"
    SWEP.WorldModel				= "models/weapons/m_models/w_pm.mdl"
    
    SWEP.Primary.ClipSize		= 8
    SWEP.Primary.DefaultClip	= 8
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9x18 Rubber"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 32.25
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/makarov/makarov_fp.wav"}
    SWEP.Primary.SuppressedSound = "zcitysnd/sound/weapons/makarov/makarov_suppressed_fp.wav"
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/makarov/makarov_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.CameraPos = Vector(4,7,0.21)
    SWEP.ShellType = "Pistol"
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "zcitysnd/sound/weapons/makarov/handling/makarov_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/makarov/handling/makarov_maghit.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/makarov/handling/makarov_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/makarov/handling/makarov_boltrelease.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/makarov/handling/makarov_magin.wav"

    SWEP.SlideBone = "W_PIS_BOLT"
    SWEP.SlideVector = Vector(-1.5, -0.15, 0)
    
    SWEP.CorrectPosX = 4.6
    SWEP.CorrectPosY = 1.5
    SWEP.CorrectPosZ = -1.41
    
    SWEP.CorrectAngPitch = -1
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(6,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,0,0)
    SWEP.addPos = Vector(0,-0.2,4.5)

    SWEP.Fake1 = Vector(4,-4,0)

    SWEP.PossibleAtt = {
        ["Wave"] = {
            name = "wave",
            CorrectPosX = 1.5,
            CorrectPosY = -1.29,
            CorrectPosZ = 5,

            CorrectAngPitch = 2,
            CorrectAngYaw = 0,
            CorrectAngRoll = 0,

            Suppress = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/silencer_wave_dd_wave_qd_supressor_multi.mdl"
        }
    }
end