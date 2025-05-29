SWEP.Base = "homigrad_base"
SWEP.PrintName = "Five-Seven" //РАЗВЕЙ МОЙ ПРАХ,С БАЛКОНА. С ПЕРВОГО ПОДХОДА. Сейчас 03:27 и я маюсь хуйнёй,привет хукеры и разрабы.
SWEP.Category = "Оружие: Пистолеты"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw_go/v_pist_fiveseven.mdl"
SWEP.ViewModel = "models/weapons/arccw_go/v_pist_fiveseven.mdl"

SWEP.HoldType = "revolver"

SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 12
SWEP.Primary.Damage = 30
SWEP.Primary.Ammo = "5.7×28mm"
SWEP.Primary.Wait = 0.1
SWEP.Sound = "pwb2/weapons/fiveseven/fire.wav"

SWEP.WorldPos = Vector(-4,-1.5,0)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(20,2.8,-1.5)
SWEP.AttAng = Angle(-0.5,-0.3,0)
SWEP.HolsterAng = Angle(0,-90,0)
SWEP.HolsterPos = Vector(-16,4,2)

SWEP.BoltBone = "v_weapon.fiveSeven_slide"
SWEP.BoltVec = Vector(0,0,-1)

SWEP.IconPos = Vector(40,-18.25,3.5)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = false

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.ZoomPos = Vector(5,-2.74,-0.62)
SWEP.ZoomAng = Angle(-1,-0.28,0)

SWEP.RecoilForce = 1.25

SWEP.Animations = {
	["idle"] = {
        Source = "idle",
    },
	["draw"] = {
        Source = "draw",
        MinProgress = 0.5,
        Time = 0.5
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

SWEP.Reload1 = "zcitysnd/sound/weapons/m9/handling/m9_magout.wav"
SWEP.Reload2 = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav"
SWEP.Reload3 = "arccw_go/glock18/glock_slideback.wav"
SWEP.Reload4 = "arccw_go/glock18/glock_sliderelease.wav"