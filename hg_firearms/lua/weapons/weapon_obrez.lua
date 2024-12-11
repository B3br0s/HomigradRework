if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Обрез"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Дробовики"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/tfa_ins2/w_doublebarrel_sawnoff.mdl"
    SWEP.WorldModel				= "models/weapons/tfa_ins2/w_doublebarrel_sawnoff.mdl"
    
    SWEP.Primary.ClipSize		= 2
    SWEP.Primary.DefaultClip	= 2
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "12/70 gauge"
    SWEP.Primary.Cone = 0.1
    SWEP.Primary.Damage = 1.5 * 55
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/firearms/shtg_winchestersx3/shotgun_semiauto_fire1.wav","zcitysnd/sound/weapons/firearms/shtg_winchestersx3/shotgun_semiauto_fire2.wav"}
    SWEP.Primary.SoundFar = "arccw_go/xm1014/xm1014-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.2
    SWEP.HoldType = "ar2"
    SWEP.NumBullet = 8
    SWEP.shotgun = true
    SWEP.EmptyBoltOut = false
    SWEP.ReloadEmpty = true
    SWEP.ShellType = nil
    SWEP.Breaking = true

    SWEP.CameraPos = Vector(4,3,0.8)
    SWEP.CameraAng = Angle(-10,-2,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/m590/handling/m590_pumpback.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/m590/handling/m590_shell_insert_2.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/m590/handling/m590_shell_insert_1.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/m590/handling/m590_pumpforward.wav"

    SWEP.DeploySound = "arccw_go/xm1014/xm1014_draw.wav"

    SWEP.SlideBone = nil
    
    SWEP.CorrectPosX = 3
    SWEP.CorrectPosY = 0.55
    SWEP.CorrectPosZ = -1.9
    
    SWEP.CorrectAngPitch = -10
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(28,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-9,0,0)
    SWEP.addPos = Vector(0,-0.6,4.5)

    SWEP.Fake1 = Vector(0,0,0)
    SWEP.Fake2 = Vector(15,0,0)
end