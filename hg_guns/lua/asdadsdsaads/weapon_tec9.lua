-- weapon_tec9.lua"

SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "TEC-9"
SWEP.Author = "Intratec"
SWEP.Instructions = "Полуавтоматический пистолет под калибр 9×19 мм\n\nТемп стрельбы 460 выстрелов в минуту"
SWEP.Category = "Оружие - Пистолеты"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/tec9/w_tec9.mdl"
SWEP.weaponInvCategory = 2
SWEP.ShellEject = "EjectBrass_9mm"
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 32
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 20
SWEP.Primary.Sound = {"hndg_beretta92fs/beretta92_fire1.wav", 75, 90, 100}
SWEP.Primary.Force = 20
SWEP.Primary.Wait = 0.1
SWEP.ReloadTime = 2.3
SWEP.DeploySnd = {"homigrad/weapons/draw_pistol.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/holster_pistol.mp3", 55, 100, 110}
SWEP.HoldType = "revolver"
SWEP.ZoomPos = Vector(-0.52, 0.035, 30)
SWEP.RHandPos = Vector(-5, -0.5, -1)
SWEP.LHandPos = false
SWEP.OpenBolt = false
SWEP.SprayRand = {Angle(-0.03, -0.03, 0), Angle(-0.05, 0.03, 0)}
SWEP.Ergonomics = 1.2
SWEP.Penetration = 7
function SWEP:InitializePost()
	self.bodyGroups = "00020"
	self:SetBodyGroups("00020")
end

SWEP.WorldPos = Vector(4, -1, -1)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.lengthSub = 25
SWEP.DistSound = "m9/m9_dist.wav"
SWEP.holsteredBone = "ValveBiped.Bip01_Pelvis"
SWEP.holsteredPos = Vector(-4, 4, 7)
SWEP.holsteredAng = Angle(25, -70, -90)