do return end 
SWEP.Base = "homigrad_base"
SWEP.PrintName = "SR-25"
SWEP.Category = "Оружие: Снайперские Винтовки"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/w_sr25_ins2_eft.mdl"
SWEP.WorldModelReal = "models/weapons/v_sr25_eft.mdl" //МОДЕЛЬКА ГАВНО!!!!!
SWEP.ViewModel = "models/weapons/v_sr25_eft.mdl"

SWEP.HoldType = "ar2"

SWEP.holdtypes = {
    ["ar2"] = {[1] = 0.27,[2] = 0.7,[3] = 1.45,[4] = 1.47},
}

SWEP.Primary.ReloadTime = 2.4
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Damage = 35
SWEP.Primary.Force = 7
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Wait = 0.1
SWEP.Sound = "zcitysnd/sound/weapons/firearms/rifle_fnfal/fnfal_fire_01.wav"
SWEP.SubSound = "hmcd/rifle_win1892/win1892_fire_01.wav"
SWEP.SuppressedSound = "zcitysnd/sound/weapons/m4a1/m4a1_suppressed_fp.wav"
SWEP.RecoilForce = 0.4

SWEP.WorldPos = Vector(-4,1,0)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(27,2.85,-3.45)
SWEP.AttAng = Angle(0,0,0)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterPos = Vector(-18,0,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.IconPos = Vector(95,-14.5,-20)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.Rarity = 5

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.ZoomPos = Vector(8,-2.825,-1.4)
SWEP.ZoomAng = Angle(0,0,0)

SWEP.AttBone = "m16_parent"

SWEP.MountType = "picatinny"

SWEP.AvaibleAtt = {
    ["sight"] = true,
    ["barrel"] = true,
}

SWEP.AttachmentPos = {
    ['sight'] = Vector(2,0,1.55),
    ['barrel'] = Vector(15.5,0,0.35),
}
SWEP.AttachmentAng = {
    ['sight'] = Angle(-90,0,-90),
    ['barrel'] = Angle(-90,0,-90),
}

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
        Time = 2
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        MinProgress = 0.5,
        Time = 2.5
    }
}

SWEP.Reload1 = "weapons/arccw_ud/m16/magout.ogg"
SWEP.Reload2 = "weapons/arccw_ud/m16/magin.ogg"
SWEP.Reload3 = "weapons/arccw_ud/m16/chamber_press.ogg"
SWEP.Reload4 = "weapons/arccw_ud/m16/chamber.ogg"

function SWEP:PostAnim()
    if self.Attachments["sight"][1] then
        self.Bodygroups[6] = 3
    else
        self.Bodygroups[6] = 2
    end
end