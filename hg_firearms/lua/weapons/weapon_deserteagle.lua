if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Desert Eagle"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/tasty/w-d50.mdl"
    SWEP.CorrectModel           = "models/tasty/d50.mdl"
    SWEP.WorldModel				= "models/tasty/w-d50.mdl"
    
    SWEP.Primary.ClipSize		= 7
    SWEP.Primary.DefaultClip	= 7
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= ".50 Action Express"
    SWEP.Primary.Cone = 0.03
    SWEP.Primary.Damage = 1.7 * 42
    SWEP.Primary.Spread = 0
    SWEP.Recoil = 5
    SWEP.Primary.Sound = {"homicide_weapons/hndg_sw686/revolver_fire_01.wav"}
    SWEP.Primary.SoundFar = "arccw_go/elite/elite-1-distant.wav"
    SWEP.Primary.SuppressedSound = "weapons/darsu_eft/sr25/sr25_fire_outdoor_silenced_close.ogg"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.2
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(5.12,9,0.11)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "tasty/d50-magout.wav"
    SWEP.Reload2 = "tasty/d50-maghit.wav"
    SWEP.Reload3 = "tasty/d50-sliderelease.wav"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "arccw_go/usp/usp_draw.wav"

    SWEP.SlideBone = "slide"
    SWEP.SlideVector = Vector(0, 0, -3)
    
    SWEP.CorrectPosX = -9.6
    SWEP.CorrectPosY = 5.6
    SWEP.CorrectPosZ = -6.5
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(10,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0,-0.15,0)
    SWEP.addPos = Vector(0,-0.25,5.2)

    SWEP.Fake1 = Vector(4,0,3)--X(Вперед),Y(Вправо),Z(Вверх)

    SWEP.PossibleAtt = {
        ["Monster"] = {
            name = "Monster",
            CorrectPosX = 19,
            CorrectPosY = -5.5,
            CorrectPosZ = 10.6,

            CorrectAngPitch = 0,
            CorrectAngYaw = 0,
            CorrectAngRoll = 0,

            Suppress = true,

            AttModel = "models/weapons/arccw_go/atts/supp_monster.mdl"
        }
    }
end