if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "SG-556"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/arccw_go/v_rif_sg556.mdl"
    SWEP.WorldModel				= "models/weapons/arccw_go/v_rif_sg556.mdl"
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "5.56x45 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 45
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"csgo/weapons/sg556/sg556_01.wav","csgo/weapons/sg556/sg556_02.wav","csgo/weapons/sg556/sg556_03.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m16a4/m16a4_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.11
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Rifle"

    SWEP.CameraPos = Vector(5.8,6,1.05)
    SWEP.CameraAng = Angle(-10,5,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "csgo/weapons/sg556/sg556_clipout.wav"
    SWEP.Reload2 = "csgo/weapons/sg556/sg556_clipin.wav"
    SWEP.Reload3 = "csgo/weapons/sg556/sg556_boltforward.wav"
    SWEP.Reload4 = "csgo/weapons/sg556/sg556_boltback.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "v_weapon.sg556_Chamber"
    SWEP.SlideVector = Vector(0, 0, -5)
    
    SWEP.CorrectPosX = -11.5
    SWEP.CorrectPosY = 5.8
    SWEP.CorrectPosZ = -6
    
    SWEP.CorrectAngPitch = 174
    SWEP.CorrectAngYaw = 180
    SWEP.CorrectAngRoll = 0

    SWEP.MuzzleFXPos = Vector(26,0,-3)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-6.3,0.4,0)
    SWEP.addPos = Vector(0,-0.5,6.7)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)
end