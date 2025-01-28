-- weapon_ar15.lua"

SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "AR-15"
SWEP.Author = "ArmaLite"
SWEP.Instructions = "Полуавтоматическая винтовка под калибр 5,56x45 мм\n\nТемп стрельбы 950 выстрелов в минуту"
SWEP.Category = "Оружие - Винтовки"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/drgordon/weapons/ar-15/m4/colt_m4.mdl"
SWEP.weaponInvCategory = 1
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 37
SWEP.Primary.Spread = 0
SWEP.Primary.Force = 37
SWEP.Primary.Sound = {"m16a4/m16a4_fp.wav", 75, 90, 100, 2}
SWEP.Primary.Wait = 0.063

SWEP.WepSelectIcon2 = Material("vgui/hud/tfa_ins2_m4a1.png")
SWEP.IconOverride = "entities/weapon_insurgencym4a1.png"

SWEP.availableAttachments = {
	barrel = {
		[1] = {"supressor2", Vector(0,0,0), {}},
		[2] = {"supressor6", Vector(0,0,-0.1), {}},
		["mount"] = Vector(3,1,0),
	},
	sight = {
		["empty"] = {
			"empty",
			{
				[2] = "models/drgordon/weapons/colt/m4/m4_sights"
			},
		},
		["mount"] = Vector(-13, 1.5, -0.15),
		--["mountAngle"] = Angle(0,0,0),
		["mountType"] = "picatinny",
		["removehuy"] = {
			[2] = "null"
		}
	},
	grip = {
		["mount"] = Vector(2 + 7.6, -0.7 + 1.5, -0.15),
		["mountType"] = "picatinny"
	},
	underbarrel = {
		["mount"] = Vector(2 + 7, 0.2 + 1.7, -1.2 + 0.15),
		["mountAngle"] = Angle(0, 0, -90),
		["mountType"] = "picatinny"
	}
}

SWEP.ReloadTime = 2
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.HoldType = "ar2"
SWEP.ZoomPos = Vector(-0.15, -3, 7 - 8.5)
SWEP.RHandPos = Vector(-4, 0, -5)
SWEP.LHandPos = Vector(7, -1, -2)
SWEP.AimHands = Vector(-3, 0, -4.8)
SWEP.EjectAng = Angle(0, -90, 0)
SWEP.attPos = Vector(-1.9, 0, -20)
SWEP.attAng = Angle(90, -90, 0)
SWEP.Spray = {}
for i = 1, 30 do
	SWEP.Spray[i] = Angle(-0.02 - math.cos(i) * 0.01, math.cos(i * i) * 0.04, 0) * 2
end

SWEP.Ergonomics = 1
SWEP.Penetration = 13
SWEP.WorldPos = Vector(4, -1, 0)
SWEP.WorldAng = Angle(0, -90, 0)
SWEP.UseCustomWorldModel = true
SWEP.handsAng = Angle(0, 0, 0)
SWEP.handsAng2 = Angle(0, 90, 0)