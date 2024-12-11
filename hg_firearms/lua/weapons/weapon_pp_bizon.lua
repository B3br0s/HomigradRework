if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "ПП-Бизон 19"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Пистолеты Пулемёты"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/arccw_go/v_smg_bizon.mdl"
    SWEP.WorldModel				= "models/weapons/arccw_go/v_smg_bizon.mdl"
    
    SWEP.Primary.ClipSize		= 64
    SWEP.Primary.DefaultClip	= 64
    SWEP.Primary.Automatic		= true
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 15
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"arccw_go/bizon/bizon_01.wav","arccw_go/bizon/bizon_02.wav"}
    SWEP.Primary.SoundFar = "arccw_go/bizon/bizon-1-distant.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.08
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = "Pistol"

    SWEP.CameraPos = Vector(5.2,3,1.1)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "arccw_go/bizon/bizon_clipout.wav"
    SWEP.Reload2 = "arccw_go/bizon/bizon_clipin.wav"
    SWEP.Reload3 = "arccw_go/bizon/bizon_boltback.wav"
    SWEP.Reload4 = "arccw_go/bizon/bizon_boltforward.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = "v_weapon.bizon_bolt"
    SWEP.SlideVector = Vector(0, 0, -3)
    
    SWEP.CorrectPosX = -12
    SWEP.CorrectPosY = 5.7
    SWEP.CorrectPosZ = -4.3
    
    SWEP.CorrectAngPitch = -10
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(18,-1,1)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-9.5,-1.1,0)
    SWEP.addPos = Vector(0,0,5.5)

    SWEP.Fake1 = Vector(-13,-4.3,-5)
    SWEP.Fake2 = Vector(8,0,0)
end