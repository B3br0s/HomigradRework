SWEP.Base = "homigrad_base"
SWEP.PrintName = "M16A1"
SWEP.Category = "Оружие: Автоматы"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw/c_ud_m16.mdl"
SWEP.ViewModel = "models/weapons/arccw/c_ud_m16.mdl"

SWEP.HoldType = "ar2"

SWEP.holdtypes = {
    ["ar2"] = {[1] = 0.27,[2] = 0.7,[3] = 1.45,[4] = 1.47},
}

SWEP.Primary.ReloadTime = 2.5
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 15
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 1
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Wait = 0.1
SWEP.Sound = "zcitysnd/sound/weapons/m16a4/m16a4_fp.wav"
SWEP.RecoilForce = 0.4

SWEP.WorldPos = Vector(-4,1,0)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(32,2.85,-3.45)
SWEP.AttAng = Angle(0,0,0)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterPos = Vector(-22,0,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.IconPos = Vector(125,-17.25,-20)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.Rarity = 5

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.ZoomPos = Vector(8,-2.81,-1.23)
SWEP.ZoomAng = Angle(-0.5,0,0)

SWEP.CurBul = 0
SWEP.can = true

function SWEP:CanShoot()
    local can = (!self.reload and self:Clip1() > 0 and !self:IsSprinting() and !self:GetOwner():GetNWBool("otrub")) and !self:IsTooClose() and self.can
    return can
end

function SWEP:PrimaryAdd()
    self.CurBul = self.CurBul + 1

    if self.CurBul > (CLIENT and 3 or 2) then
        self.can = false
    end
end

function SWEP:PostAnim()
    local ply = self:GetOwner()

    if !IsValid(ply) then
        return
    end

    if !ply:KeyDown(IN_ATTACK) and self.CurBul > 2 then
        self.can = true
        self.CurBul = 0
    end
end

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