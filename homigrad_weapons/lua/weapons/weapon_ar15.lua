if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "AR-15"
    SWEP.Author 				= "Homigrad"
    SWEP.Instructions			= "Полуавтоматическая винтовка под калибр 5,56х45"
    SWEP.Category 				= "Оружие"
    SWEP.IconkaInv = "vgui/weapon_csgo_m4a1.png"
    
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    
    ------------------------------------------
    
    SWEP.Primary.ClipSize		= 30
    SWEP.Primary.DefaultClip	= 30
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "5.56x45 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.7 * 40
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = "zcitysnd/sound/weapons/m4a1/m4a1_fp.wav"
    SWEP.Primary.SoundSupresor = "zcitysnd/sound/weapons/m4a1/m4a1_suppressed_fp.wav"
    SWEP.Primary.SoundFar = "m4a1/m4a1_dist.wav"
    SWEP.Primary.Force = 160/3
    SWEP.ReloadTime = 2
    SWEP.MagModel = "models/csgo/weapons/w_rif_m4a1_mag.mdl"
    SWEP.ShootWait = 0.07
    SWEP.ReloadSound = ""
    SWEP.TwoHands = true
    SWEP.MagOut = "zcitysnd/sound/weapons/m4a1/handling/m4a1_magout.wav"
    SWEP.MagIn = "zcitysnd/sound/weapons/m4a1/handling/m4a1_magin.wav"
    SWEP.BoltOut = "zcitysnd/sound/weapons/m4a1/handling/m4a1_boltrelease.wav"
    SWEP.MagOutWait = 0.2
    SWEP.MagInWait = 0.9
    SWEP.BoltOutWait = 1.2
    
    SWEP.Secondary.ClipSize		= -1
    SWEP.Secondary.DefaultClip	= -1
    SWEP.Secondary.Automatic	= false
    SWEP.RecoilNumber = 0.4
    SWEP.Secondary.Ammo			= "none"
    if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/smoke' )
    SWEP.BounceWeaponIcon = false
    end
    SWEP.SubMaterial = {
        [1] = "null"
    }
    ------------------------------------------
    
    SWEP.Weight					= 5
    SWEP.AutoSwitchTo			= false
    SWEP.AutoSwitchFrom			= false
    
    SWEP.HoldType = "ar2"
    
    ------------------------------------------
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0
    SWEP.DrawAmmo				= true
    SWEP.DrawCrosshair			= false
    
    SWEP.ViewModel				= "models/pwb2/weapons/w_m4a1.mdl"
    SWEP.WorldModel				= "models/pwb2/weapons/w_m4a1.mdl"
    
    SWEP.vbwPos = Vector(-2,-3.7,2)
    SWEP.vbwAng = Angle(5,-30,0)
    
    SWEP.OffsetVec = Vector(10,-2.6,2)
    
    function SWEP:ApplyEyeSpray()
        self.eyeSpray = self.eyeSpray - Angle(self.RecoilNumber,math.Rand(self.RecoilNumber*-1,self.RecoilNumber),0)
    end
    
    SWEP.ValidAttachments = {
        ["Elcan"] = {
            positionright = 0.96,
            positionforward = 7,
            positionup = -5.2,
    
            angleforward = 180,
            angleright = 10,
            angleup = 0,
    
            holosight = true,
            newsight = true,
            aimpos = Vector(5.3,7,0.725),
            aimang = Angle(-5,0,0),
    
            scale = 1,
            model = "models/weapons/arc9/darsu_eft/mods/scope_elcan_specter_hco.mdl",
        },
        ["Walther"] = {
            positionright = 0.96,
            positionforward = 7,
            positionup = -5.2,
    
            angleforward = 180,
            angleright = 10,
            angleup = 0,
    
            holosight = true,
            newsight = true,
            aimpos = Vector(5,7,0.725),
            aimang = Angle(-5,0,0),
    
            scale = 1,
            model = "models/weapons/arc9/darsu_eft/mods/scope_all_walther_mrs.mdl",
        },
        ["Suppressor"] = {
            positionright = 0.96,
            positionforward = 23,
            positionup = -7.1,
    
            angleforward = 180,
            angleright = 10,
            angleup = 0,
    
            scale = 1,
            model = "models/weapons/arc9/darsu_eft/mods/silencer_tbac_thunder_beast_ultra_5_762x51.mdl",
        },
        ["Grip"] = {
            positionright = 1,
            positionforward = 15,
            positionup = -5.8,
    
            angleforward = 178,
            angleright = 30,
            angleup = -0.1,
    
            scale = 1,
            model = "models/weapons/arc9/darsu_eft/mods/pistolgrip_ar15_f1_firearms_st2_pc_skeletonized.mdl",
        }
    }
    end