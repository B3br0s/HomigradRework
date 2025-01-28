-- weapon_xm1014.lua"

--ents.Reg(nil,"weapon_m4super")
SWEP.Base = "weapon_m4super"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "XM-1014"
SWEP.Author = "Benelli Armi SPA"
SWEP.Instructions = "Полуавтоматический дробовик под калибр 12/70"
SWEP.Category = "Оружие - Дробовики"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/pwb/weapons/w_xm1014.mdl"

SWEP.WepSelectIcon2 = Material("pwb/sprites/xm1014.png")
SWEP.IconOverride = "entities/weapon_pwb_xm1014.png"

SWEP.weaponInvCategory = 1
SWEP.ShellEject = "ShotgunShellEject"
SWEP.UseCustomWorldModel = false
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 16
SWEP.Primary.Spread = Vector(0.05, 0.05, 0.05)
SWEP.Primary.Force = 8
SWEP.NumBullet = 8
SWEP.AnimShootMul = 3
SWEP.AnimShootHandMul = 10
SWEP.Primary.Sound = {"toz_shotgun/toz_fp.wav", 80, 70, 75}
SWEP.Primary.Wait = 0.2
SWEP.DeploySnd = {"homigrad/weapons/draw_hmg.mp3", 65, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/hmg_holster.mp3", 65, 100, 110}
SWEP.AnimShootMul = 1.5
SWEP.AnimShootHandMul = 7
SWEP.HoldType = "ar2"
SWEP.ZoomPos = Vector(0, 0.065, 33)
SWEP.RHandPos = Vector(-10, -2, 4)
SWEP.LHandPos = Vector(7, -2, 0)
SWEP.SprayRand = {Angle(-0.2, -0.4, 0), Angle(-0.4, 0.4, 0)}
SWEP.Ergonomics = 0.9
SWEP.Penetration = 7
SWEP.WorldPos = Vector(13, -1, 3)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0, 0, 0)
SWEP.attAng = Angle(0, 0.3, 0)
SWEP.lengthSub = 18
SWEP.handsAng = Angle(-1, 0, 0)