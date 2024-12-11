if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Remington 870"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Дробовики"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_shot_m3juper90.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_shot_m3juper90.mdl"
    
    SWEP.Primary.ClipSize		= 8
    SWEP.Primary.DefaultClip	= 8
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "12/70 gauge"
    SWEP.Primary.Cone = 0.1
    SWEP.Primary.Damage = 1.5 * 55
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/firearms/shtg_remington870/remington_fire_01.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/toz_shotgun/toz_dist.wav"
    SWEP.Primary.SuppressedSound = "zcitysnd/sound/weapons/m590/m590_suppressed_fp.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "ar2"
    SWEP.NumBullet = 8
    SWEP.shotgun = true
    SWEP.Pump = true
    SWEP.Pumped = true
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = nil

    SWEP.CameraPos = Vector(4.8,5,0.9)
    SWEP.CameraAng = Angle(0,5,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = ""
    SWEP.Reload2 = ""
    SWEP.Reload3 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/ak47/handling/ak47_boltrelease.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/m14/handling/m14_rattle.wav"

    SWEP.SlideBone = "slide"
    SWEP.SlideVector = Vector(0, 0, -2)
    
    SWEP.CorrectPosX = 1.5
    SWEP.CorrectPosY = 0.74
    SWEP.CorrectPosZ = 1
    
    SWEP.CorrectAngPitch = 175
    SWEP.CorrectAngYaw = 180
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(25,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-5,-0.1,0)
    SWEP.addPos = Vector(0,-0.5,5)

    SWEP.Fake1 = Vector(0,0,0)
    SWEP.Fake2 = Vector(14,0,-5)

    SWEP.PossibleAtt = {
        ["Salvo"] = {
            name = "salvo",
            CorrectPosX = 24,
            CorrectPosY = 0.1,
            CorrectPosZ = 5.6,

            CorrectAngPitch = 10,
            CorrectAngYaw = 0,
            CorrectAngRoll = 0,

            Suppress = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/silencer_base_silencerco_salvo_12g.mdl"
        }
    }
end