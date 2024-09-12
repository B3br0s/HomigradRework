if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "FNP 45"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Пистолет под калибр 9х19"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "pwb2/vgui/weapons/usptactical"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/tfa_ins2/usp_tactical/fp1.wav"
SWEP.Primary.SoundSupresor = "m45/m45_suppressed_fp.wav"
SWEP.Primary.SoundFar = "weapons/tfa_ins2/usp_tactical/fpddd.wav"
SWEP.Primary.Force = 90/3
SWEP.ReloadTime = 2
SWEP.ReloadSound = ""
SWEP.MagModel = "models/csgo/weapons/w_pist_223_mag.mdl"
SWEP.ShootWait = 0.14

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

SWEP.ViewModel				= "models/pwb/weapons/w_fnp45.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_fnp45.mdl"

SWEP.vbwPos = Vector(6.5,3.4,-4)


SWEP.addPos = Vector(0,0,-0.9)
SWEP.addAng = Angle(-0.4,0.5,0)

SWEP.ValidAttachments = {
    ["Suppressor"] = {
        positionright = 1.2,
        positionforward = 9.5,
        positionup = -3.9,

        angleforward = 180,
        angleright = 10,
        angleup = 0,

        suppressingsound = true,
        newsight = false,
        
        scale = 0.8,
        model = "models/weapons/arc9/darsu_eft/mods/silencer_wave_dd_wave_qd_supressor_multi.mdl",
    }
}
end