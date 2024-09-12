if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "АКС-74У"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Автоматическая винтовка под калибр 5,45х39"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "pwb/sprites/aks74u"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.45x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/aks74u/aks_fp.wav"
SWEP.Primary.SoundFar = "ak74/ak74_dist.wav"
SWEP.Primary.SoundSupresor = "ak74/ak74_suppressed_tp.wav"
SWEP.MagModel = "models/draco/w_draco_mag.mdl"
SWEP.Primary.Force = 140/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.075
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.RecoilNumber = 0.4

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_aks74u.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_aks74u.mdl"

SWEP.vbwPos = Vector(5,-6,-6)

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(self.RecoilNumber,math.Rand(self.RecoilNumber*-1,self.RecoilNumber),0)
end


SWEP.ValidAttachments = {
    ["Suppressor"] = {
        positionright = 0.89,
        positionforward = 20,
        positionup = -6.32,

        angleforward = 180,
        angleright = 10,
        angleup = 0,
        
        scale = 1,
        model = "models/weapons/arc9/darsu_eft/mods/silencer_12g_hexagon_12k.mdl",
    },
    ["Opk7"] = {
        positionright = 0.75,
        positionforward = 4,
        positionup = -6.5,

        angleforward = 178,
        angleright = 10,
        angleup = -0.1,

        holosight = true,
        newsight = true,
        aimpos = Vector(6,7,0.725),
        aimang = Angle(-5,0,0),

        scale = 1,
        model = "models/weapons/arc9_eft_shared/atts/optic/dovetail/okp7.mdl",
    },
    ["Grip"] = {
        positionright = 1,
        positionforward = 15,
        positionup = -5.8,

        angleforward = 178,
        angleright = 30,
        angleup = -0.1,

        scale = 1,
        model = "models/weapons/arc9/darsu_eft/mods/pistolgrip_ar15_tactical_dynamics_hexgrip.mdl",
    },
}
end