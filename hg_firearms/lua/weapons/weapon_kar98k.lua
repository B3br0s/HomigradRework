if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Kar98k"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Снайперские Винтовки"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/zcity/gleb/w_kar98k.mdl"
    SWEP.WorldModel				= "models/weapons/zcity/gleb/w_kar98k.mdl"
    
    SWEP.Primary.ClipSize		= 5
    SWEP.Primary.DefaultClip	= 5
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "7.62x54 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 115
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"homicide_weapons/rifle_win1892/win1892_fire_01.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/m40a1/m40a1_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.3
    SWEP.HoldType = "ar2"
    SWEP.EmptyBoltOut = false
    SWEP.ShellType = nil
    SWEP.Bolt = true

    SWEP.CameraPos = Vector(4.42,3,-0.3)
    SWEP.CameraAng = Angle(-5,-10,0)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = "zcitysnd/sound/weapons/mosin/handling/mosin_boltback.wav"
    SWEP.Reload2 = "zcitysnd/sound/weapons/mosin/handling/mosin_bulletin_2.wav"
    SWEP.Reload3 = "zcitysnd/sound/weapons/mosin/handling/mosin_bulletin_1.wav"
    SWEP.Reload4 = "zcitysnd/sound/weapons/mosin/handling/mosin_boltforward.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = nil

    SWEP.BoltBone1 = "Bolt.001"
    SWEP.BoltBone2 = "Bolt"
    
    SWEP.CorrectPosX = 0
    SWEP.CorrectPosY = 1.7
    SWEP.CorrectPosZ = -1
    
    SWEP.CorrectAngPitch = -10
    SWEP.CorrectAngYaw = 4
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(46,0,2)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-10.3,-3.4,0)
    SWEP.addPos = Vector(0,-0.2,5.5)

    SWEP.Fake1 = Vector(2,0,0)
    SWEP.Fake2 = Vector(17,0,0)
end