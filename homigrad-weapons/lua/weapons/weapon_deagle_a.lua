SWEP.Base = "homigrad_base"
SWEP.PrintName = "Desert Eagle IMI" //Ебальники школьников представили по которым будут хуярить с этого?
SWEP.Category = "Оружие: Пистолеты"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw_go/v_pist_deagle.mdl"
SWEP.ViewModel = "models/weapons/arccw_go/v_pist_deagle.mdl"

SWEP.HoldType = "revolver"

SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Damage = 40
SWEP.Primary.Force = 30
SWEP.Primary.Ammo = ".50 Action Express"
SWEP.Primary.Wait = 0.2
SWEP.Sound = "arccw_go/deagle/deagle-1.wav"

SWEP.RecoilForce = 1.5

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.WorldPos = Vector(-2,-1.5,-0.5)
SWEP.WorldAng = Angle(1,-2,0)
SWEP.AttPos = Vector(25.5,3.85,-1.25)
SWEP.AttAng = Angle(-0.4,-0.3,0)
SWEP.HolsterAng = Angle(0,-90,0)
SWEP.HolsterPos = Vector(-16,4,2)

SWEP.BoltBone = "v_weapon.deagle_slide"
SWEP.BoltVec = Vector(0,0,-1)

SWEP.IconPos = Vector(40,-11.5,-8)
SWEP.IconAng = Angle(0,90,0)

SWEP.Rarity = 5

SWEP.TwoHands = false

SWEP.ZoomPos = Vector(6,-4,-0.3)
SWEP.ZoomAng = Angle(-0.8,-0.3,0)

SWEP.Animations = {
	["idle"] = {
        Source = "idle",
    },
	["draw"] = {
        Source = "draw",
        MinProgress = 0.5,
        Time = 1
    },
    ["reload"] = {
        Source = "reload",
        MinProgress = 0.5,
        Time = 1.5
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        MinProgress = 0.5,
        Time = 1.8
    }
}

SWEP.Reload1 = "arccw_go/deagle/de_clipout.wav"
SWEP.Reload2 = "arccw_go/deagle/de_clipin.wav"
SWEP.Reload3 = "arccw_go/deagle/de_slideback.wav"
SWEP.Reload4 = "arccw_go/deagle/de_slideforward.wav"