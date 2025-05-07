SWEP.Base = "homigrad_base"
SWEP.PrintName = "XM1014"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_shot_m1014.mdl"

SWEP.CorrectPos = Vector(-11.5,-4.9,7.6)
SWEP.CorrectAng = Angle(0,3,0)
SWEP.HoldType = "ar2"
SWEP.TwoHands = true

SWEP.HolsterPos = Vector(-20,-1,8)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.BoltBone = "v_weapon.xm1014_Bolt"
SWEP.BoltVec = Vector(0,0,-2)

SWEP.ZoomPos = Vector(10,-4.32,-2.75)
SWEP.ZoomAng = Angle(0,2,0)
SWEP.AttPos = Vector(-2,0,0)
SWEP.AttAng = Angle(0,0.75,0)

SWEP.MuzzlePos = Vector(36,4.15,-4)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.IsShotgun = true
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Damage = 17.5
SWEP.Primary.Wait = 0.2
SWEP.Primary.ReloadTimeEnd = 1.5
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Primary.Damage = 12.25
SWEP.Primary.Force = 45
SWEP.Primary.Sound = "homigrad/weapons/shotguns/xm1014-2.wav"//{"zcitysnd/sound/weapons/firearms/shtg_winchestersx3/shotgun_semiauto_fire1.wav","zcitysnd/sound/weapons/firearms/shtg_winchestersx3/shotgun_semiauto_fire2.wav"}
SWEP.NumBullet = 8
SWEP.RecoilForce = 10

SWEP.IconPos = Vector(-4.25,50,-4)
SWEP.IconAng = Angle(-20,0,0)

function SWEP:PostAnim()

end