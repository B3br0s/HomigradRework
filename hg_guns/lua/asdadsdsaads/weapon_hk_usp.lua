-- weapon_hk_usp.lua"

SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "HK USP"
SWEP.Author = "Heckler & Koch"
SWEP.Instructions = "Пистолет под калибр 9×19 мм\n\nТемп стрельбы 460 выстрелов в минуту"
SWEP.Category = "Оружие - Пистолеты"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/pwb2/weapons/w_usptactical.mdl"

SWEP.WepSelectIcon2 = Material("pwb2/vgui/weapons/usptactical.png")
SWEP.IconOverride = "entities/weapon_pwb2_usptactical.png"

SWEP.weaponInvCategory = 2
SWEP.ShellEject = "EjectBrass_9mm"
SWEP.Primary.ClipSize = 15
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Sound = {"hndg_beretta92fs/beretta92_fire1.wav", 75, 90, 100}
SWEP.SupressedSound = {"homigrad/weapons/pistols/sil.wav", 65, 90, 100}
--models/weapons/tfa_ins2/upgrades/laser_pistol.mdl
SWEP.availableAttachments = {
	barrel = {
		[1] = {"supressor3", Vector(0,0,0), {}},
		[2] = {"supressor6", Vector(0,0,0), {}},
		["mount"] = Vector(-1,-0.5,0),
	},
	underbarrel = {
		["mount"] = Vector(15.5, -0.6, 0.15),
		["mountAngle"] = Angle(0, 0, 180),
		["mountType"] = "picatinny"
	}
}

SWEP.Primary.Force = 25
SWEP.Primary.Wait = 0.1
SWEP.ReloadTime = 2.3
SWEP.DeploySnd = {"homigrad/weapons/draw_pistol.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/holster_pistol.mp3", 55, 100, 110}
SWEP.HoldType = "revolver"
SWEP.ZoomPos = Vector(0.6, 0.65, 27)
SWEP.RHandPos = Vector(0, -0.5, -1)
SWEP.LHandPos = false
SWEP.SprayRand = {Angle(-0.03, -0.03, 0), Angle(-0.05, 0.03, 0)}
SWEP.Ergonomics = 1.2
SWEP.Penetration = 7
SWEP.WorldPos = Vector(0, -0.5, -0.5)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0.35, 0, -0.85)
SWEP.attAng = Angle(0.52, 0.65, 0)
SWEP.lengthSub = 130
SWEP.DistSound = "m9/m9_dist.wav"
SWEP.holsteredBone = "ValveBiped.Bip01_R_Thigh"
SWEP.holsteredPos = Vector(0, 2, -4)
SWEP.holsteredAng = Angle(-5, -5, 90)
SWEP.shouldDrawHolstered = false