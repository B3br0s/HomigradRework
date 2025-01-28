-- weapon_hk21.lua"

SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "HK21"
SWEP.Author = "Heckler & Koch"
SWEP.Instructions = "Пулемет под калибр 7,62x51 мм\n\nТемп стрельбы 900 выстрелов в минуту"
SWEP.Category = "Оружие - Пулемёты"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/pwb/weapons/w_hk23e.mdl"

SWEP.WepSelectIcon2 = Material("pwb/sprites/hk23e.png")
SWEP.IconOverride = "entities/weapon_pwb_hk23e.png"

SWEP.weaponInvCategory = 1
SWEP.Primary.ClipSize = 150
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "7.62x51 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 65
SWEP.Primary.Spread = 0
SWEP.Primary.Force = 65
SWEP.Primary.Sound = {"homigrad/weapons/rifle/pdr-2.wav", 75, 80, 90}
SWEP.Primary.Wait = 0.066
SWEP.ReloadTime = 3
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.DeploySnd = {"homigrad/weapons/draw_hmg.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/hmg_holster.mp3", 55, 100, 110}
SWEP.HoldType = "ar2"
SWEP.ZoomPos = Vector(-4.15, 0.17, 42)
SWEP.RHandPos = Vector(-14, -1, 4)
SWEP.LHandPos = Vector(7, -2, -2)
SWEP.Spray = {}
for i = 1, 150 do
	SWEP.Spray[i] = Angle(-0.04 - math.cos(i) * 0.03, math.cos(i * i) * 0.05, 0) * 2
end

SWEP.ShellEject = "EjectBrass_762Nato"
SWEP.Ergonomics = 0.6
SWEP.OpenBolt = false
SWEP.Penetration = 20
SWEP.WorldPos = Vector(14, -1, 4)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.AimHands = Vector(0, 1.8, -4.5)
SWEP.lengthSub = 15
SWEP.DistSound = "m249/m249_dist.wav"
SWEP.bipodAvailable = true