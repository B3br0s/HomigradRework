if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'salat_base' -- base
    
    SWEP.PrintName 				= "Desert Eagle"
    SWEP.Author 				= "Homigrad"
    SWEP.Instructions			= "Пистолет с охуенной бронебойностью под калибр .44 Magnum"
    SWEP.Category 				= "Оружие"
    SWEP.WepSelectIcon			= "pwb/sprites/glock17"
    SWEP.MagModel = "models/weapons/arc9/darsu_eft/mods/mag_glock_std_17.mdl"
    
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    
    ------------------------------------------
    
    SWEP.Primary.ClipSize		= 17
    SWEP.Primary.DefaultClip	= 17
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.7 * 25
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = "csgo/weapons/deagle/deagle_02.wav"
    SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
    SWEP.Primary.Force = 90/3
    SWEP.ReloadSound = ""
    SWEP.ReloadTime = 2
    SWEP.ShootWait = 0.12
    SWEP.MagOut = "csgo/weapons/deagle/de_clipout.wav"
    SWEP.MagIn = "csgo/weapons/deagle/de_clipin.wav"
    SWEP.BoltIn = "csgo/weapons/deagle/de_slideforward.wav"
    SWEP.MagOutWait = 0.2
    SWEP.MagInWait = 1.5
    SWEP.BoltInWait = 2
    
    
    SWEP.Secondary.ClipSize		= -1
    SWEP.Secondary.DefaultClip	= -1
    SWEP.Secondary.Automatic	= false
    SWEP.Secondary.Ammo			= "none"
    
    ------------------------------------------
    
    SWEP.Weight					= 5
    SWEP.AutoSwitchTo			= false
    SWEP.AutoSwitchFrom			= false
    
    SWEP.HoldType = "revolver"
    
    ------------------------------------------
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1
    SWEP.DrawAmmo				= true
    SWEP.DrawCrosshair			= false
    
    SWEP.ViewModel				= "models/csgo/weapons/w_pist_deagle.mdl"
    SWEP.WorldModel				= "models/csgo/weapons/w_pist_deagle.mdl"
    
    function SWEP:ApplyEyeSpray()
        self.eyeSpray = self.eyeSpray - Angle(3,math.Rand(-1.5,1.5),0)
    end 

    SWEP.dwsPos = Vector(13,13,5)
    SWEP.dwsItemPos = Vector(10,-1,-2)
    
    SWEP.addAng = Angle(0.4,0,0)
    SWEP.addPos = Vector(0,0,-1)
    --SWEP.vbwPos = Vector(7,-10,-6)
    end