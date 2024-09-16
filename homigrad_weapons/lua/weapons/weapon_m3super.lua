if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "M4 Super 90"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Дробовик под калибр 12/70"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "pwb2/vgui/weapons/m4super90"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "12/70 gauge"
SWEP.Primary.Cone = 0.02
SWEP.Primary.Damage = 1.7 * 30
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = ("zcitysnd/sound/weapons/firearms/shtg_winchestersx3/shotgun_semiauto_fire"..math.random(1,2)..".wav")
SWEP.Primary.SoundFar = "toz_shotgun/toz_dist.wav"
SWEP.Primary.Force = 15
SWEP.ReloadTime = 2
SWEP.LoadSound = "csgo/weapons/xm1014/xm1014_insertshell_01"
SWEP.ShootWait = 0.4
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

SWEP.ViewModel				= "models/pwb2/weapons/w_m4super90.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_m4super90.mdl"

SWEP.vbwPos = Vector(-2,-3.7,2)
SWEP.vbwAng = Angle(5,-30,0)

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(1.7,0,0)

SWEP.ValidAttachments = {
    ["Eotech553"] = {
        positionright = 1.05,
        positionforward = 10,
        positionup = -5.4,

        angleforward = 180,
        angleright = 10,
        angleup = 0,

        holosight = true,
        newsight = true,
        aimpos = Vector(5,4,0.65),
        aimang = Angle(5,-30,0),

        scale = 0.8,
        model = "models/weapons/arc9_eft_shared/atts/optic/eft_optic_553.mdl",
    }
}

function SWEP:ApplyEyeSpray()
    self.Primary.Sound = ("zcitysnd/sound/weapons/firearms/shtg_winchestersx3/shotgun_semiauto_fire"..math.random(1,2)..".wav")
    self.eyeSpray = self.eyeSpray - Angle(5,math.Rand(-2,2),0)
end
end