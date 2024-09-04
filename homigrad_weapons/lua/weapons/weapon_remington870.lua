if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Remington 870"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Дробовик под калибр 12/70"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12/70 gauge"
SWEP.Primary.Cone = 0.05
SWEP.Primary.Damage = 1.7 * 45
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "snd_jack_hmcd_sht_close.wav"
SWEP.Primary.SoundSupresor = "homigrad/weapons/rifle/masada_sil.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_sht_far.wav"
SWEP.Primary.Force = 15
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.5
SWEP.RecoilNumber = 4
SWEP.NumBullet = 8
SWEP.Sight = true
SWEP.TwoHands = true
SWEP.shotgun = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

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

SWEP.ViewModel				= "models/bydistac/weapons/w_shot_m3juper90.mdl"
SWEP.WorldModel				= "models/bydistac/weapons/w_shot_m3juper90.mdl"

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(self.RecoilNumber,math.Rand(-2,2),0)
end

SWEP.vbwPos = Vector(-9,-5,-5)

SWEP.CLR_Scope = 0.05
SWEP.CLR = 0.025

SWEP.addAng = Angle(2.5,0.1,0)
SWEP.addPos = Vector(0,0,0)
SWEP.ValidAttachments = {
    ["Eotech553"] = {
        positionright = 0.5,
        positionforward = 10,
        positionup = -5.7,

        angleforward = 180,
        angleright = 5,
        angleup = 0,

        holosight = true,
        newsight = true,
        aimpos = Vector(5.5,4,1.20),
        aimang = Angle(-1,0,0),

        scale = 0.8,
        model = "models/weapons/arc9_eft_shared/atts/optic/eft_optic_553.mdl",
    },
    ["Suppressor"] = {
        positionright = 0.5,
        positionforward = 29,
        positionup = -7.45,

        angleforward = 180,
        angleright = 8,
        angleup = 0,

        scale = 1.4,
        model = "models/weapons/arc9_eft_shared/atts/muzzle/silencer_all_rotor_43_v1.mdl",
    }
}
end