if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'salat_base'
    
    SWEP.PrintName 				= "M1A1"
    SWEP.Author 				= "Homigrad"
    SWEP.Instructions			= ""
    SWEP.Category 				= "Оружие"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "7.62x39 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.7 * 40
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = "zcitysnd/sound/weapons/m1a1/m1a1_fp.wav"
    SWEP.Primary.Force = 240/3
    SWEP.ReloadTime = 2
    SWEP.ShootWait = 0.1
    SWEP.ReloadSound = ""
    SWEP.TwoHands = true
    SWEP.MagOut = "zcitysnd/sound/weapons/m1a1/handling/m1a1_magout.wav"
    SWEP.MagIn = "zcitysnd/sound/weapons/m1a1/handling/m1a1_magin.wav"
    SWEP.BoltIn = "zcitysnd/sound/weapons/m1a1/handling/m1a1_boltrelease.wav"
    SWEP.MagOutWait = 0.2
    SWEP.MagInWait = 1
    SWEP.BoltInWait = 1.3
    
    SWEP.vbwAng = Vector(0,0,0)
    SWEP.vbwPos = Vector(0,0,0)

    SWEP.Secondary.ClipSize		= -1
    SWEP.Secondary.DefaultClip	= -1
    SWEP.Secondary.Automatic	= false
    SWEP.Secondary.Ammo			= "none"
    
    SWEP.Weight					= 5
    SWEP.AutoSwitchTo			= false
    SWEP.AutoSwitchFrom			= false
    
    SWEP.HoldType = "ar2"
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0
    SWEP.DrawAmmo				= true
    SWEP.DrawCrosshair			= false
    
    SWEP.ViewModel				= "models/weapons/insurgency/w_m1a1.mdl"
    SWEP.WorldModel				= "models/weapons/insurgency/w_m1a1.mdl"
    
    SWEP.addAng = Angle(1.5,0.05,0)
    SWEP.addPos = Vector(0,0,0)
    end