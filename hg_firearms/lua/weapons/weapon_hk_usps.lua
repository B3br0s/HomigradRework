if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "HK USP"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_usp_9mm.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_usp_9mm.mdl"
    
    SWEP.Primary.ClipSize		= 12
    SWEP.Primary.DefaultClip	= 12
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 50
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/m1911/m1911_fp.wav"}
    SWEP.Primary.SuppressedSound = "sounds_zcity/hk_usp/supressor.wav"
    SWEP.Primary.SoundFar = "arccw_go/usp/usp_unsil-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(4.7,7,0.42)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "zcitysnd/sound/weapons/m45/handling/m45_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/m45/handling/m45_maghit.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/m45/handling/m45_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/m45/handling/m45_boltrelease.wav"

    SWEP.DeploySound = "arccw_go/usp/usp_draw.wav"

    SWEP.SlideBone = "Slide"
    SWEP.SlideVector = Vector(0, 2.6, 0)
    
    SWEP.CorrectPosX = 5
    SWEP.CorrectPosY = 1.3
    SWEP.CorrectPosZ = -1.85
    
    SWEP.CorrectAngPitch = 180
    SWEP.CorrectAngYaw = 180
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(8,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.2, -0.1, 0)
    SWEP.addPos = Vector(0,-0.3,4.5)

    SWEP.Fake1 = Vector(5,-2,0)--X(Вперед),Y(Вправо),Z(Вверх)

    SWEP.PossibleAtt = {
        ["Osprey"] = {
            name = "osprey",
            CorrectPosX = 3,
            CorrectPosY = -0.86,
            CorrectPosZ = 5.9,

            CorrectAngPitch = 0,
            CorrectAngYaw = 0,
            CorrectAngRoll = 180,

            Suppress = true,

            AttModel = "models/weapons/arccw_go/atts/supp_osprey.mdl"
        }
    }
end