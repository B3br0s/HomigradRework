SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "M4A4"
SWEP.Author = "Homigrad"
SWEP.Instructions = "\n11 выстрелов в секунду\n35 Урона\n0.0025 Разброс"
SWEP.Category = "Оружие - Винтовки"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/arccw_go/v_rif_m4a1.mdl"
SWEP.weaponInvCategory = 1
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = 0.0025
SWEP.Primary.Force = 50
SWEP.Primary.Sound = {"arccw_go/m4a1/m4a1_01.wav", 85, 100, 100}
SWEP.Primary.RandomSounds = {
	"arccw_go/m4a1/m4a1_01.wav",
	"arccw_go/m4a1/m4a1_02.wav",
	"arccw_go/m4a1/m4a1_03.wav",
	"arccw_go/m4a1/m4a1_04.wav"
}
SWEP.Primary.Wait = 1 / 11
SWEP.DeploySnd = {"homigrad/weapons/draw_hmg.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/hmg_holster.mp3", 55, 100, 110}
SWEP.ReloadTime = 2
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.HoldType = "ar2"
SWEP.ZoomPos = Vector(-0.45,-0.19,31)
SWEP.RHandPos = Vector(-12, -1, 4)
SWEP.LHandPos = Vector(7, -2, -2)
SWEP.attPos = Vector(5, 1, 40)
SWEP.attAng = Angle(0.5,-0.12,0)
SWEP.TwoHanded = true
SWEP.Spray = {}
for i = 1, 75 do
	SWEP.Spray[i] = Angle(-0.04 - math.cos(i) * 0.03, math.cos(i * i) * 0.05, 0) * 2
end
SWEP.IconAng = Angle(-25,0,0)
SWEP.IconPos = Vector(1.5,55,-7)

SWEP.Ergonomics = 0.75
SWEP.Penetration = 15
SWEP.ShellEject = "EjectBrass_338Mag"
SWEP.EjectAng = Angle(180, 0, 0)
SWEP.WorldPos = Vector(-9, -6, -6.3)
SWEP.WorldAng = Angle(0, -0, 0)
SWEP.UseCustomWorldModel = true
SWEP.lengthSub = 15
SWEP.DistSound = "ak74/ak74_dist.wav"
SWEP.holsteredBone = "ValveBiped.Bip01_Spine2"
SWEP.holsteredPos = Vector(29,-2.5, 10)
SWEP.holsteredAng = Angle(-10, 180, 0)
SWEP.EjectPos = Vector(17,6,-3.5)
SWEP.EjectAng = Angle(0,0,-60)

SWEP.BoltBone = false