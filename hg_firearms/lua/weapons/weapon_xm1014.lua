if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "XM1014"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Дробовики"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/tfa_ins2/w_m1014.mdl"
    SWEP.WorldModel				= "models/weapons/tfa_ins2/w_m1014.mdl"
    
    SWEP.Primary.ClipSize		= 7
    SWEP.Primary.DefaultClip	= 7
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "12/70 gauge"
    SWEP.Primary.Cone = 0.1
    SWEP.Primary.Damage = 1.5 * 55
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"csgo/weapons/xm1014/xm1014-1.wav"}
    SWEP.Primary.SoundFar = "csgo/weapons/xm1014/xm1014-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.2
    SWEP.HoldType = "ar2"
    SWEP.NumBullet = 8
    SWEP.shotgun = true
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "ShotGun"

    SWEP.CameraPos = Vector(4.15,4.2,1.164)
    SWEP.CameraAng = Angle(-15,0,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = ""
    SWEP.Reload2 = ""
    SWEP.Reload3 = "csgo/weapons/nova/nova_pump.wav"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "csgo/weapons/xm1014/xm1014_draw.wav"

    SWEP.SlideBone = "W_BOLT_SHOT"
    SWEP.SlideVector = Vector(0, 4, 0)
    
    SWEP.CorrectPosX = 5
    SWEP.CorrectPosY = 0.22
    SWEP.CorrectPosZ = -3
    
    SWEP.CorrectAngPitch = -10
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(28,0,3)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-10.5,0.2,0)
    SWEP.addPos = Vector(0,-1,4)

    SWEP.Fake1 = Vector(0,0,0)
    SWEP.Fake2 = Vector(14,0,0)
    
    SWEP.PossibleAtt = {
        ["HoloSun"] = {
            name = "holosun",
            CorrectPosX = 18,
            CorrectPosY = -4.45,
            CorrectPosZ = 9.5,

            CorrectAngPitch = 200,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            ChangesCamera = true,

            CameraPos = Vector(4.7,3.5,0.805),

            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_base_aimpoint_micro_t1_mark.png",

            ReticleUp = 4.5,
            ReticleRight = 1.2,
            ReticleSize = 8,

            Holo = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/scope_all_holosun_hs401g5.mdl"
        }
    }
end