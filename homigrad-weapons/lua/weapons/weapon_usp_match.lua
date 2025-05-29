SWEP.Base = "homigrad_base"
SWEP.PrintName = "HK USP"
SWEP.Category = "Оружие: Пистолеты"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/tfa_ins2/w_usp_match.mdl"
SWEP.WorldModelReal = "models/weapons/tfa_ins2/c_usp_match.mdl"
SWEP.ViewModel = "models/weapons/tfa_ins2/c_usp_match.mdl"

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.HoldType = "revolver"

SWEP.holdtypes = {
    ["revolver"] = {[1] = 0.45,[2] = 0.7,[3] = 0.95,[4] = 1.2},
    ["revolver_empty"] = {[1] = 0.25,[2] = 0.8,[3] = 1,[4] = 1.7},
}

SWEP.Primary.ReloadTime = 1.9
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 12
SWEP.Primary.Damage = 45
SWEP.Primary.Force = 12
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Wait = 0.09
SWEP.Sound = "sounds_zcity/hk_usp/close.wav"
SWEP.RecoilForce = 1
SWEP.Empty3 = false

SWEP.WorldPos = Vector(-2,0,0)
SWEP.WorldAng = Angle(0.1,-0.5,-1)
SWEP.AttPos = Vector(24,2.05,-1.25)
SWEP.AttAng = Angle(0.5,0,0)
SWEP.HolsterAng = Angle(0,-20,0)
SWEP.HolsterPos = Vector(-28,1,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.BoltBone = "Slide"
SWEP.BoltVec = Vector(0,1.1,0)

SWEP.ZoomPos = Vector(7,-2.085,-0.35)
SWEP.ZoomAng = Angle(0,0,0)

SWEP.Rarity = 4

SWEP.IconPos = Vector(50,1,-12.5)
SWEP.IconAng = Angle(0,90,0)

SWEP.Animations = {
	["idle"] = {
        Source = "base_idle",
    },
	["draw"] = {
        Source = "base_draw",
        MinProgress = 0.5,
        Time = 1
    },
    ["reload"] = {
        Source = "base_reload",
        MinProgress = 0.5,
        Time = 2
    },
    ["reload_empty"] = {
        Source = "base_reload_empty",
        MinProgress = 0.5,
        Time = 2.25
    },
}

SWEP.TwoHands = false

SWEP.Reload1 = "weapons/tfa_ins2/usp_tactical/magout.wav"
SWEP.Reload2 = "zcitysnd/sound/weapons/m9/handling/m9_magin.wav"
SWEP.Reload3 = "weapons/tfa_ins2/usp_match/usp_match_maghit.wav"
SWEP.Reload4 = "weapons/tfa_ins2/usp_match/usp_match_boltrelease.wav"

function SWEP:PostAnim()
    if self.BoltBone and self.BoltVec and CLIENT then
        local bone = self:GetWM():LookupBone(self.BoltBone)

        if bone then
            self:GetWM():ManipulateBonePosition(bone,self.BoltVec * self.animmul)
        end
    end

    if self.reload and CLIENT then
        local bone = self:GetWM():LookupBone("MagazineSwap")
        self:GetWM():ManipulateBoneScale(bone,Vector(1,1,1))
    elseif CLIENT then
        local bone = self:GetWM():LookupBone("MagazineSwap")
        self:GetWM():ManipulateBoneScale(bone,Vector(0,0,0))
    end

    if self:Clip1() == 0 and !self.reload then
        self.animmul = 1
    else 
        self.animmul = LerpFT(0.25,self.animmul,0)
    end
end