-- weapon_remington870.lua"

--ents.Reg(nil,"weapon_m4super")
SWEP.Base = "weapon_m4super"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Remington 870"
SWEP.Author = "Remington Arms"
SWEP.Instructions = "Помповый дробовик под калибр 12/70"
SWEP.Category = "Оружие - Дробовики"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/w_shot_m3juper90.mdl"

SWEP.WepSelectIcon2 = Material("vgui/wep_jack_hmcd_shotgun.png")
SWEP.IconOverride = "vgui/wep_jack_hmcd_shotgun.png"

SWEP.weaponInvCategory = 1
SWEP.ShellEject = "ShotgunShellEject"
SWEP.AutomaticDraw = false
SWEP.UseCustomWorldModel = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 16
SWEP.Primary.Spread = Vector(0.05, 0.05, 0.05)
SWEP.Primary.Force = 8
SWEP.Primary.Sound = {"sounds_zcity/remington870/close.wav", 80, 90, 100}
SWEP.SupressedSound = {"toz_shotgun/toz_suppressed_fp.wav", 65, 90, 100}
SWEP.availableAttachments = {
	barrel = {
		[1] = {"supressor5", Vector(0,0,0), {}},
	},
	sight = {
		["mountType"] = "picatinny",
		["mount"] = Vector(-20, 1, 0),
	},
}

--models/weapons/tfa_ins2/upgrades/att_suppressor_12ga.mdl
SWEP.Primary.Wait = 0.25
SWEP.NumBullet = 8
SWEP.AnimShootMul = 3
SWEP.AnimShootHandMul = 10
SWEP.DeploySnd = {"homigrad/weapons/draw_hmg.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/hmg_holster.mp3", 55, 100, 110}
SWEP.HoldType = "ar2"
SWEP.ZoomPos = Vector(5, -6, 0.8)
SWEP.RHandPos = Vector(0, 0, -1)
SWEP.LHandPos = Vector(7, 0, -2)
SWEP.SprayRand = {Angle(-0.2, -0.4, 0), Angle(-0.4, 0.4, 0)}
SWEP.Ergonomics = 0.9
SWEP.Penetration = 7
SWEP.WorldPos = Vector(0, -0.8, -0.2)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0, 0, 0)
SWEP.attAng = Angle(0, -2.50, 0)
SWEP.lengthSub = 20