if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'b3bros_base'
    
    SWEP.PrintName 				= "СКС"
    SWEP.Author 				= "Homigrad"
    SWEP.Instructions			= "Самозарядный карабин Симонова под калибр 7.62x39"
    SWEP.Category 				= "Оружие"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.IconkaInv = "vgui/pineapple.png"
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "7.62x39 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.7 * 45
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = "zcitysnd/sound/weapons/sks/sks_fp.wav"
    SWEP.Primary.Force = 240/3
    SWEP.Primary.SoundSupresor = "weapons/sks/sks_suppressed_fp.wav"
    SWEP.ReloadTime = 2
    SWEP.ShootWait = 0.1
    SWEP.MagModel = "models/gredwitch/bar/bar_mag.mdl"
    if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/smoke' )
    SWEP.BounceWeaponIcon = false
    end
    SWEP.ReloadSound = ""
    SWEP.TwoHands = true
    SWEP.MagOut = "zcitysnd/sound/weapons/sks/handling/sks_magout.wav"
    SWEP.MagIn = "zcitysnd/sound/weapons/sks/handling/sks_magin.wav"
    SWEP.BoltIn = "zcitysnd/sound/weapons/sks/handling/sks_boltback.wav"
    SWEP.BoltOut = "zcitysnd/sound/weapons/sks/handling/sks_boltrelease.wav"
    SWEP.MagOutWait = 0.2
    SWEP.MagInWait = 1
    SWEP.BoltInWait = 1.5
    SWEP.BoltOutWait = 1.7

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

    SWEP.ValidAttachments = {
        ["Suppressor"] = {
            positionright = 3.5,
            positionforward = 32,
            positionup = -5,
    
            angleforward = 180,
            angleright = 2,
            angleup = 5,
            
            scale = 1,
            model = "models/weapons/arc9/darsu_eft/mods/silencer_12g_hexagon_12k.mdl",
        }
    }
    end