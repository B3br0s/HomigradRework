SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "ПП-Бизон 19"
SWEP.Author = "Homigrad"
SWEP.Instructions = "\n13 выстрелов в секунду\n25 Урона\n0.075 Разброс"
SWEP.Category = "Оружие - ПП"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/arccw_go/v_smg_bizon.mdl"

SWEP.ShellEject = "EjectBrass_9mm"
SWEP.weaponInvCategory = 1
SWEP.Primary.ClipSize = 45
SWEP.Primary.DefaultClip = 45
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0.0025
SWEP.Primary.Force = 50
SWEP.Primary.Sound = {"arccw_go/bizon/bizon_01.wav", 85, 100, 100}
SWEP.Primary.RandomSounds = {
	"arccw_go/bizon/bizon_01.wav",
	"arccw_go/bizon/bizon_02.wav"
}
SWEP.Primary.Wait = 1 / 13
SWEP.DeploySnd = {"homigrad/weapons/draw_hmg.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/hmg_holster.mp3", 55, 100, 110}
SWEP.ReloadTime = 2
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.HoldType = "ar2"
SWEP.ZoomPos = Vector(0,-0.07,31)
SWEP.RHandPos = Vector(-12, -1, 4)
SWEP.LHandPos = Vector(7, -2, -2)
SWEP.attPos = Vector(5, 1, 40)
SWEP.attAng = Angle(0.5,-0.12,0)
SWEP.TwoHanded = true
SWEP.Spray = {}
for i = 1, 45 do
	SWEP.Spray[i] = Angle(-0.04 - math.cos(i) * 0.03, math.cos(i * i) * 0.05, 0) * 2
end

SWEP.Ergonomics = 0.75
SWEP.Penetration = 15
SWEP.EjectAng = Angle(180, 0, 0)
SWEP.WorldPos = Vector(-9, -6, -7)
SWEP.WorldAng = Angle(0, -0, 0)
SWEP.UseCustomWorldModel = true
SWEP.lengthSub = 15
SWEP.DistSound = "arccw_go/ump45/ump45-1-distant.wav"
SWEP.holsteredBone = "ValveBiped.Bip01_Spine2"
SWEP.holsteredPos = Vector(29,-2.5, 10)
SWEP.holsteredAng = Angle(-10, 180, 0)
SWEP.EjectPos = Vector(17,6,-3.5)
SWEP.EjectAng = Angle(0,0,-60)
SWEP.IconAng = Angle(-25,0,0)
SWEP.IconPos = Vector(0,70,-7)

SWEP.BoltBone = "v_weapon.bizon_bolt"
SWEP.BoltMul = Vector(0,0,-3.5)