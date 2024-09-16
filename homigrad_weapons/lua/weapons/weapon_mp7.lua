if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base 

SWEP.PrintName 				= "MP7"
SWEP.Instructions			= "Пистолет-пулемёт под калибр 4,6×30"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 40
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "4.6×30 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 30
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/mp40/mp40_fp.wav"
SWEP.Primary.SoundFar = "mp5k/mp5k_dist.wav"
SWEP.Primary.Force = 120/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.06
SWEP.MagOut = "csgo/weapons/galilar/galil_clipout.wav"
SWEP.MagIn = "csgo/weapons/galilar/galil_clipin.wav"
SWEP.BoltOut = "csgo/weapons/galilar/galil_boltback.wav"
SWEP.BoltIn = "csgo/weapons/galilar/galil_boltforward.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.9
SWEP.BoltOutWait = 1.2
SWEP.BoltInWait = 1.4
SWEP.ReloadSound = ""--"weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

							
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "smg"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.MagModel = "models/csgo/weapons/w_pist_tec9_mag.mdl"
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb2/weapons/w_mp7.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_mp7.mdl"

SWEP.vbwPos = Vector(-2,-3.7,1)
SWEP.vbwAng = Angle(5,-30,0)

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(-0.5,0,0)

SWEP.ValidAttachments = {
    ["Pilad"] = {
        positionright = 0.95,
        positionforward = 2.5,
        positionup = -4,

        angleforward = 180,
        angleright = 10,
        angleup = -0.1,

        holosight = true,
        newsight = true,
        aimpos = Vector(4.5,-3.7,0.75),
        aimang = Angle(-5,0,0),

        scale = 0.8,
        model = "models/weapons/arc9/darsu_eft/mods/scope_all_vomz_pilad_p1x42_weaver.mdl",
    }
}
end