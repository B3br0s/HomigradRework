-- weapon_p22.lua"

SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Walther P22"
SWEP.Author = "Walther"
SWEP.Instructions = "Пистолет под калибр .22 lr\n\nТемп стрельбы 600 выстрелов в минуту"
SWEP.Category = "Оружие - Пистолеты"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/w_p99.mdl"

SWEP.WepSelectIcon2 = Material("vgui/wep_jack_hmcd_suppressed.png")
SWEP.IconOverride = "vgui/wep_jack_hmcd_suppressed.png"

SWEP.weaponInvCategory = 2
SWEP.ShellEject = "EjectBrass_9mm"
SWEP.Primary.ClipSize = 16
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 15
SWEP.Primary.Sound = {"hndg_beretta92fs/beretta92_fire1.wav", 75, 90, 100}
SWEP.SupressedSound = {"homigrad/weapons/pistols/sil.wav", 55, 90, 100}
SWEP.availableAttachments = {
	barrel = {
		[1] = {"supressor4", Vector(0,0,0), {}},
		[2] = {"supressor6", Vector(0,0,0), {}},
		["mount"] = Vector(-0.1,0.4,0.03),
	},
}

SWEP.Primary.Force = 20
SWEP.Primary.Wait = 0.1
SWEP.ReloadTime = 2.3
SWEP.DeploySnd = {"homigrad/weapons/draw_pistol.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/holster_pistol.mp3", 55, 100, 110}
SWEP.HoldType = "revolver"
SWEP.ZoomPos = Vector(-1, 0, 24)
SWEP.RHandPos = Vector(-13.5, 0, 4)
SWEP.LHandPos = false
SWEP.SprayRand = {Angle(-0.00, -0.01, 0), Angle(-0.01, 0.01, 0)}
SWEP.Ergonomics = 1.2
SWEP.AnimShootMul = 2
SWEP.AnimShootHandMul = 0.1
SWEP.addSprayMul = 0.5
SWEP.Penetration = 8
SWEP.WorldPos = Vector(4,-1.5,-2)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0, 0, 0)
SWEP.attAng = Angle(-0.15,-0.9,0)
SWEP.lengthSub = 25
SWEP.DistSound = "m9/m9_dist.wav"

SWEP.holsteredBone = "ValveBiped.Bip01_R_Thigh"
SWEP.holsteredPos = Vector(0, 0, -3)
SWEP.holsteredAng = Angle(-5, -5, 90)
SWEP.shouldDrawHolstered = false