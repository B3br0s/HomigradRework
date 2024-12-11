if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "СВД"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Снайперские Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_svd.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_svd.mdl"
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "7.62x54 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 145
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"sounds_zcity/svd/close.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m40a1/m40a1_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(5.2,4,0)
    SWEP.CameraAng = Angle(-5,-20,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/ak47/handling/ak47_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/ak47/handling/ak47_magin.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltrelease.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "W_BOLT"
    SWEP.SlideVector = Vector(-7, 0, 0)
    
    SWEP.CorrectPosX = 5
    SWEP.CorrectPosY = 1.25
    SWEP.CorrectPosZ = -1
    
    SWEP.CorrectAngPitch = -5
    SWEP.CorrectAngYaw = 4
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(46,0,2)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-5.3,-3.9,0)
    SWEP.addPos = Vector(0,-0.7,5.4)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)

    SWEP.PossibleAtt = {
        ["Pso1"] =  {
            name = "pso1",
            CorrectPosX = -1,
            CorrectPosY = -0.05,
            CorrectPosZ = 7,

            CorrectAngPitch = 190,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            ChangesCamera = true,

            CameraPos = Vector(6.1,2,0.2),

            ReticleMaterial = "decals/perekrestie12.png",

            ReticleUp = 0,
            ReticleRight = 0,
            ReticleSize = 5000,

            BlackoutSize = 3500,

            BlackoutAmount = 400,

            ZoomFOV = 15,

            LocalPos = Vector(20, 0.5, 0.5),

            OffsetPos = Vector(7, 0, 0.772),

            Optic = true,

            AttModel = "models/weapons/arc9_eft_shared/atts/optic/dovetail/pso1.mdl"
        }
    }
end