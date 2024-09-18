if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "Сайга-12"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Полуавтоматический дробовик на базе АК под калибр 12/70"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12/70 gauge"
SWEP.Primary.Cone = 0.05
SWEP.Primary.Damage = 1.7 * 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/shtg_winchestersx3/shotgun_semiauto_fire1.wav"
SWEP.Primary.SoundFar = "toz_shotgun/toz_dist.wav"
SWEP.Primary.SoundSupresor = "homigrad/weapons/rifle/masada_sil.wav"
SWEP.Primary.Force = 15
SWEP.ReloadTime = 2
SWEP.ReloadSound = ""
SWEP.ShootWait = 0.15
SWEP.NumBullet = 8
SWEP.Sight = true
SWEP.TwoHands = true
SWEP.MagOut = "zcitysnd/sound/weapons/ak74/handling/ak74_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/ak74/handling/ak74_magin.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/ak74/handling/ak74_boltrelease.wav"
SWEP.BoltIn = "zcitysnd/sound/weapons/ak74/handling/ak74_boltback.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.9
SWEP.BoltInWait = 1.2
SWEP.BoltOutWait = 1.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"
SWEP.shotgun = true

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_saiga_12.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_saiga_12.mdl"

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(4,math.Rand(-1,1),0)
end

SWEP.vbwPos = Vector(0,0,0)
SWEP.vbwAng = Angle(0,0,0)

SWEP.addAng = Angle(1,0.1,0)
SWEP.ValidAttachments = {
    ["Suppressor"] = {
        positionright = 0.89,
        positionforward = 23,
        positionup = -6.78,

        angleforward = 180,
        angleright = 10,
        angleup = 0,

        suppressingsound = true,
        newsight = false,
        
        scale = 0.7,
        model = "models/weapons/arc9/darsu_eft/mods/silencer_base_silencerco_salvo_12g.mdl",
    }
}
end