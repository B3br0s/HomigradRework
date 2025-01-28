-- weapon_m590a1.lua"

--ents.Reg(nil,"weapon_m4super")
SWEP.Base = "weapon_m4super"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Mossberg 590A1"
SWEP.Author = "O.F. Mossberg & Sons"
SWEP.Instructions = "Помповый дробовик под калибр 12/70"
SWEP.Category = "Оружие - Дробовики"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/pwb/weapons/w_m590a1.mdl"

SWEP.WepSelectIcon2 = Material("pwb/sprites/m590a1.png")
SWEP.IconOverride = "entities/weapon_pwb_m590a1.png"

SWEP.weaponInvCategory = 1
SWEP.ShellEject = "ShotgunShellEject"
SWEP.AutomaticDraw = false
SWEP.UseCustomWorldModel = false
SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 16
SWEP.Primary.Spread = Vector(0.05, 0.05, 0.05)
SWEP.Primary.Force = 8
SWEP.NumBullet = 8
SWEP.Primary.Sound = {"toz_shotgun/toz_fp.wav", 80, 90, 100}
SWEP.Primary.Wait = 0.25
SWEP.AnimShootMul = 3
SWEP.AnimShootHandMul = 10
SWEP.DeploySnd = {"homigrad/weapons/draw_hmg.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/hmg_holster.mp3", 55, 100, 110}
SWEP.HoldType = "ar2"
SWEP.ZoomPos = Vector(-1.45, 0.1, 36)
SWEP.RHandPos = Vector(-14, 0, 4)
SWEP.LHandPos = Vector(7, 0, -2)
SWEP.SprayRand = {Angle(-0.2, -0.4, 0), Angle(-0.4, 0.4, 0)}
SWEP.Ergonomics = 0.9
SWEP.DeploySnd = {"homigrad/weapons/draw_hmg.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/hmg_holster.mp3", 55, 100, 110}
SWEP.Penetration = 7
SWEP.WorldPos = Vector(13, -1, 4)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0, 0, 0)
SWEP.attAng = Angle(-0.05, -0.8, 0)
SWEP.lengthSub = 13
SWEP.handsAng = Angle(-1, -0.5, 0)