-- weapon_mp5.lua"

SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "HK MP5"
SWEP.Author = "Heckler & Koch"
SWEP.Instructions = "Пистолет-пулемет под калибр 9x19 мм\n\nТемп стрельбы 800 выстрелов в минуту"
SWEP.Category = "Оружие - Пистолеты-Пулемёты"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/pwb2/weapons/w_mp5a3.mdl"

SWEP.WepSelectIcon2 = Material("vgui/hud/tfa_ins2_mp5a4.png")
SWEP.IconOverride = "vgui/hud/tfa_ins2_mp5a4.png"

SWEP.weaponInvCategory = 1
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 20
SWEP.Primary.Spread = 0
SWEP.Primary.Force = 20
SWEP.Primary.Sound = {"homigrad/weapons/pistols/mp5-1.wav", 75, 120, 130}
SWEP.Primary.Wait = 0.075
SWEP.ReloadTime = 2
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.ShellEject = "EjectBrass_9mm"
SWEP.HoldType = "ar2"
SWEP.ZoomPos = Vector(-2.12, 0.22, 23)
SWEP.RHandPos = Vector(4, -2, 0)
SWEP.LHandPos = Vector(7, -2, -2)
SWEP.availableAttachments = {
	barrel = {
		[1] = {"supressor4", Vector(0,0,0), {}},
		[2] = {"supressor6", Vector(0,0,0), {}},
		["mount"] = Vector(-1.5,0.6,-0.2),
	}
}

SWEP.Spray = {}
for i = 1, 30 do
	SWEP.Spray[i] = Angle(-0.02 - math.cos(i) * 0.01, math.cos(i * i) * 0.01, 0) * 2
end

SWEP.Ergonomics = 1
SWEP.Penetration = 7
SWEP.WorldPos = Vector(-1, -0.5, -1)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.lengthSub = 30
SWEP.handsAng = Angle(5, 1, 0)
SWEP.DistSound = "mp5k/mp5k_dist.wav"