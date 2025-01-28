-- weapon_glock18c.lua"

SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Glock 18C"
SWEP.Author = "Glock GmbH"
SWEP.Instructions = "Пистолет под калибр 9x19 мм\n\nТемп стрельбы 1200 выстрелов в минуту"
SWEP.Category = "Оружие - Пистолеты"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/pwb/weapons/w_glock17.mdl"

SWEP.WepSelectIcon2 = Material("pwb/sprites/glock17.png")
SWEP.IconOverride = "entities/weapon_pwb_glock17.png"

SWEP.weaponInvCategory = 2
SWEP.ShellEject = "EjectBrass_9mm"
SWEP.Primary.ClipSize = 17
SWEP.Primary.DefaultClip = 17
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Sound = {"hndg_beretta92fs/beretta92_fire1.wav", 75, 90, 100}
SWEP.Primary.Force = 25
SWEP.Primary.Wait = 0.05
SWEP.availableAttachments = {
	magwell = {
		[1] = {"mag1", Vector(-5.5, -2.8, 0), {}}
	},
}

SWEP.Primary.ClipSize2 = 17
SWEP.ReloadTime = 2.3
SWEP.DeploySnd = {"homigrad/weapons/draw_pistol.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/holster_pistol.mp3", 55, 100, 110}
SWEP.HoldType = "revolver"
SWEP.ZoomPos = Vector(-0.15, 1, 26)
SWEP.RHandPos = Vector(-13.5, 0, 4)
SWEP.LHandPos = false
SWEP.Spray = {}
for i = 1, 17 do
	SWEP.Spray[i] = Angle(-0.05 - math.cos(i) * 0.04, math.cos(i * i) * 0.05, 0) * 2
end

SWEP.Ergonomics = 1.2
SWEP.Penetration = 7
SWEP.WorldPos = Vector(13, 0, 3.5)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0, 0, -1)
SWEP.attAng = Angle(0.05, -0.1, 0)
SWEP.lengthSub = 25
SWEP.DistSound = "m9/m9_dist.wav"
SWEP.holsteredBone = "ValveBiped.Bip01_R_Thigh"
SWEP.holsteredPos = Vector(0, 0, -3)
SWEP.holsteredAng = Angle(-5, -5, 90)
SWEP.shouldDrawHolstered = false