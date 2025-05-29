SWEP.Base = "homigrad_base"
SWEP.PrintName = "AK74"
SWEP.Category = "Оружие: Винтовки"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw/c_ur_ak.mdl"
SWEP.ViewModel = "models/weapons/arccw/c_ur_ak.mdl"

SWEP.Bodygroups = {[1] = 3,[2] = 9,[3] = 0,[4] = 0,[5] = 0,[6] = 12,[7] = 0,[8] = 0,[9] = 2,[10] = 2}

SWEP.HoldType = "ar2"

SWEP.holdtypes = {
    ["ar2"] = {[1] = 0.55,[2] = 1.2,[3] = 1.85,[4] = 2},
}

SWEP.Primary.ReloadTime = 2.4
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 35
SWEP.Primary.Force = 1
SWEP.Primary.Ammo = "5.45x39 mm"
SWEP.Primary.Wait = 0.09
SWEP.Sound = "zcitysnd/sound/weapons/firearms/rifle_cz858/cz858_fire_01.wav"
SWEP.RecoilForce = 0.4

SWEP.WorldPos = Vector(-5,-0.5,0)
SWEP.WorldAng = Angle(0,0,6)
SWEP.AttPos = Vector(37,2.93,-2.4)
SWEP.AttAng = Angle(-0.45,-0.27,0)
SWEP.HolsterAng = Angle(140,0,180)
SWEP.HolsterPos = Vector(-16,6,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.BoltBone = "vm_bolt"
SWEP.BoltVec = Vector(0,2,0)

SWEP.ZoomPos = Vector(6,-2.55,-0.8)
SWEP.ZoomAng = Angle(-0.7,-0.26,0)

SWEP.Rarity = 4

SWEP.TwoHands = true

SWEP.IconPos = Vector(130,-23.2,-1)
SWEP.IconAng = Angle(0,90,0)

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
        Source = "reload_308",
        MinProgress = 0.5,
        Time = 2.7
    },
    ["reload_empty"] = {
        Source = "reload_308_empty",
        MinProgress = 0.5,
        Time = 3
    }
}

function SWEP:PostAnim()
    if self.BoltBone and self.BoltVec and CLIENT then
        local bone = self:GetWM():LookupBone(self.BoltBone)

        if bone then
            self:GetWM():ManipulateBonePosition(bone,self.BoltVec * self.animmul)
        end
    end

    if IsValid(self.worldModel) and self.worldModel:LookupBone("vm_mag2") then
        self.worldModel:ManipulateBoneScale(self.worldModel:LookupBone("vm_mag2"),Vector(1,1,1) * (self.reload != nil and 1 or 0))
        self.worldModel:ManipulateBoneScale(self.worldModel:LookupBone("tag_mag2"),Vector(1,1,1) * (self.reload != nil and 1 or 0))
    end

    self.animmul = LerpFT(0.25,self.animmul,0)
end

SWEP.Reload1 = "zcitysnd/sound/weapons/ak74/handling/ak74_magout.wav"
SWEP.Reload2 = "zcitysnd/sound/weapons/aks74u/handling/aks_magin.wav"
SWEP.Reload3 = "zcitysnd/sound/weapons/ak74/handling/ak74_boltback.wav"
SWEP.Reload4 = "zcitysnd/sound/weapons/ak74/handling/ak74_boltrelease.wav"