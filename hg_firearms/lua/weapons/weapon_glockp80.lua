if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Glock P80"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/tfa_ins2/w_glock_p80.mdl"
    SWEP.WorldModel				= "models/weapons/tfa_ins2/w_glock_p80.mdl"
    
    SWEP.Primary.ClipSize		= 12
    SWEP.Primary.DefaultClip	= 12
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 50
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"homicide_weapons/hndg_glock17/glock_fire_01.wav"}
    SWEP.Primary.SuppressedSound = "weapons/darsu_eft/usp/usp_fire_silenced_close.ogg"
    SWEP.Primary.SoundFar = "csgo/weapons/glock18/glock18-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = false
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "revolver"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(4.25,7,0.7)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1

    SWEP.Reload1 = "zcitysnd/sound/weapons/m1911/handling/m1911_magout.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/m1911/handling/m1911_maghit.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/m1911/handling/m1911_boltback.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/m1911/handling/m1911_boltrelease.wav"

    SWEP.DeploySound = "csgo/weapons/usp/usp_draw.wav"

    SWEP.SlideBone = "gatslide"
    SWEP.SlideVector = Vector(-0.5, 1.3, 2)
    
    SWEP.CorrectPosX = 3
    SWEP.CorrectPosY = 1
    SWEP.CorrectPosZ = -2.5
    
    SWEP.CorrectAngPitch = 0
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(6,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(0.5, -0.2, 0)
    SWEP.addPos = Vector(0,-0.8, 4)

    SWEP.Fake1 = Vector(5,-1,-0.6)--X(Вперед),Y(Вправо),Z(Вверх)

    SWEP.PossibleAtt = {
        ["Rotor"] = {
            name = "rotor",
            CorrectPosX = 3.4,
            CorrectPosY = -0.34,
            CorrectPosZ = 6.25,

            CorrectAngPitch = 0,
            CorrectAngYaw = 0,
            CorrectAngRoll = 0,

            Suppress = true,

            AttModel = "models/weapons/arc9_eft_shared/atts/muzzle/silencer_all_rotor_43_v2.mdl"
        },
        ["Drum"] = {
            name = "drum",
            CorrectPosX = -2.2,
            CorrectPosY = -0.34,
            CorrectPosZ = 4.3,

            CorrectAngPitch = 180,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            AmmoExtend = 18,

            AttModel = "models/weapons/arc9/darsu_eft/mods/mag_glock_drum_50.mdl"
        }
    }
end