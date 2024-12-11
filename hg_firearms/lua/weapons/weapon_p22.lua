if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Walther P22"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_p99.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_p99.mdl"
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 40
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"homicide_weapons/hndg_mkiii/mkiii_fire_01.wav"}
    SWEP.Primary.SuppressedSound = "m9/m9_suppressed_fp.wav"
    SWEP.Primary.SoundFar = "homicide_arccw_go/ump45/ump45-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.CameraPos = Vector(4.4,7,0.23)
    SWEP.ShellType = "Pistol"
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "arccw_go/fiveseven/fiveseven_clipout.wav"
    SWEP.Reload2 = "arccw_go/fiveseven/fiveseven_clipin.wav"
    SWEP.Reload3 = "arccw_go/fiveseven/fiveseven_slideback.wav"
    SWEP.Reload4 = "arccw_go/fiveseven/fiveseven_sliderelease.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak74/handling/ak74_magout_rattle.wav"

    SWEP.SlideBone = "Slide"
    SWEP.SlideVector = Vector(0, 2.6, 0)
    
    SWEP.CorrectPosX = 3.8
    SWEP.CorrectPosY = 1.5
    SWEP.CorrectPosZ = -1.46
    
    SWEP.CorrectAngPitch = -1
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(8,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.2, -0.1, 0)
    SWEP.addPos = Vector(0,-0.3,4.5)

    SWEP.Fake1 = Vector(4,-1,-1.5)--X(Вперед),Y(Вправо),Z(Вверх)

    SWEP.PossibleAtt = {
        ["Wave"] = {
            name = "wave",
            CorrectPosX = 3.3,
            CorrectPosY = -1.3,
            CorrectPosZ = 5.25,

            CorrectAngPitch = 2,
            CorrectAngYaw = 0,
            CorrectAngRoll = 0,

            Suppress = true,

            AttModel = "models/weapons/arc9/darsu_eft/mods/silencer_wave_dd_wave_qd_supressor_multi.mdl"
        }
    }
end