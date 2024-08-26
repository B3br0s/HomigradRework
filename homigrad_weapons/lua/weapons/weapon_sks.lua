if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'salat_base'
    
    SWEP.PrintName 				= "СКС"
    SWEP.Author 				= "Homigrad"
    SWEP.Instructions			= "Самозарядный карабин Симонова под калибр 7.62x39"
    SWEP.Category 				= "Оружие"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "7.62x39 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.7 * 45
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = "weapons/sks/sks_fp.wav"
    SWEP.Primary.Force = 240/3
    SWEP.ReloadTime = 2
    SWEP.ShootWait = 0.1
    SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
    SWEP.TwoHands = true

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
    
    SWEP.ViewModel				= "models/weapons/insurgency/w_sks.mdl"
    SWEP.WorldModel				= "models/weapons/insurgency/w_sks.mdl"
    
    SWEP.addAng = Angle(0.5,-0.35,0)
    SWEP.addPos = Vector(0,0,0)
    end