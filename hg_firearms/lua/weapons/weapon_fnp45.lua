if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "FNP 45"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/w_fnp45.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/w_fnp45.mdl"
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 45
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"homicide_weapons/hndg_mkiii/mkiii_fire_01.wav"}
    SWEP.Primary.SuppressedSound = "weapons/tfa_ins2/pyro_uspt/fp_suppressed.wav"
    SWEP.Primary.SoundFar = "homicide_weapons/mp5k/mp5k_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.CameraPos = Vector(4.55,6,0.70)
    SWEP.ShellType = "Pistol"
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "zcitysnd/sound/weapons/m9/handling/m9_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/makarov/handling/makarov_maghit.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/m9/handling/m9_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/m9/handling/m9_boltrelease.wav"

    SWEP.DeploySound = "csgo/weapons/fiveseven/fiveseven_draw.wav"

    SWEP.SlideBone = "Slide"
    SWEP.SlideVector = Vector(-2, 0, 0.5)
    
    SWEP.CorrectPosX = 12
    SWEP.CorrectPosY = 0.49
    SWEP.CorrectPosZ = 3
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(10,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.3,-0.2,0)
    SWEP.addPos = Vector(0,-0.7,4.2)

    SWEP.Fake1 = Vector(13,0,3)

    SWEP.PossibleAtt = {
        ["Osprey"] = {
            name = "osprey",
            CorrectPosX = -5.5,
            CorrectPosY = 0.23,
            CorrectPosZ = 0.7,

            CorrectAngPitch = 0,
            CorrectAngYaw = 0,
            CorrectAngRoll = 180,

            Suppress = true,

            AttModel = "models/weapons/arccw_go/atts/supp_osprey.mdl"
        }
    }
end