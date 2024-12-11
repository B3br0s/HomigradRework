if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "M4A1"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/v_eftm4a1.mdl"
    SWEP.CorrectModel           = "models/weapons/v_eftm4a1.mdl"
    SWEP.WorldModel				= "models/pwb2/weapons/w_m4a1.mdl"
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "5.56x45 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 25
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"weapons/darsu_eft/m4a1/fire_new/tx15_fire_outdoor_close.ogg"}
    SWEP.Primary.SoundFar = "weapons/darsu_eft/m4a1/fire_new/tx15_fire_outdoor_distant.ogg"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.085
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(5.6,4,1.21)
    SWEP.CameraAng = Angle(0,0,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "weapons/darsu_eft/m4a1/mcx_bolt_out.ogg"
    SWEP.Reload2 = "weapons/darsu_eft/m4a1/mcx_mag_in3.ogg"
    SWEP.Reload3 = "weapons/darsu_eft/m4a1/mcx_bolt_catchrelease.ogg"
    SWEP.Reload4 = ""

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "Bolt"
    SWEP.SlideVector = Vector(0, 4.3, 0)
    
    SWEP.CorrectPosX = 9
    SWEP.CorrectPosY = 0.5
    SWEP.CorrectPosZ = -4.3
    
    SWEP.CorrectAngPitch = 172
    SWEP.CorrectAngYaw = 180
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(20,0,-1)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-8.7,0.3,0)
    SWEP.addPos = Vector(0,-0.8,6)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)

    SWEP.CurrentAtt = {
        [1] = {
            name = "base",
            CorrectPosX = -16,
            CorrectPosY = -1.65,
            CorrectPosZ = 9.4,

            CorrectAngPitch = 197,
            CorrectAngYaw = 180,
            CorrectAngRoll = 0,

            AttModel = "models/weapons/tfa_ins2/upgrades/a_eftm4a1_iron.mdl"
        },
    }
end