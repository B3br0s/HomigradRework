-- weapon_ak74u.lua"

SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "АКС-74У"
SWEP.Author = "Ижевский машиностроительный завод"
SWEP.Instructions = "Автоматическая винтовка под калибр 5,45x39 мм\n\nТемп стрельбы 700 выстрелов в минуту"
SWEP.Category = "Оружие - Винтовки"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/pwb/weapons/w_aks74u.mdl"
SWEP.weaponInvCategory = 1
SWEP.CustomEjectAngle = Angle(0, 0, 90)
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "5.45x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = 0
SWEP.Primary.Force = 35
SWEP.Primary.Sound = {"homigrad/weapons/rifle/g3.wav", 75, 120, 140}
SWEP.Primary.Wait = 0.085
SWEP.ReloadTime = 2
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.HoldType = "ar2"
SWEP.ZoomPos = Vector(-0.8, 0.25, 29)
SWEP.RHandPos = Vector(-12, -1, 4)
SWEP.LHandPos = Vector(7, -2, -2)
SWEP.Penetration = 12
SWEP.Spray = {}
for i = 1, 30 do
	SWEP.Spray[i] = Angle(-0.03 - math.cos(i) * 0.04, math.cos(i * i) * 0.04, 0) * 2
end

SWEP.WepSelectIcon2 = Material("pwb/sprites/aks74u.png")
SWEP.IconOverride = "entities/weapon_pwb_aks74u.png"

SWEP.Ergonomics = 1.1
SWEP.WorldPos = Vector(13, -1, 4)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0, 0, 0)
SWEP.attAng = Angle(-0.05, 0.15, 0)
SWEP.lengthSub = 25
SWEP.handsAng = Angle(1, -1.5, 0)
SWEP.DistSound = "ak74/ak74_dist.wav"