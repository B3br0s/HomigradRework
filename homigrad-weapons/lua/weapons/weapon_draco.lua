SWEP.Base = "homigrad_base"
SWEP.PrintName = "Draco"
SWEP.Category = "Оружие: Пистолеты"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw/c_ur_ak.mdl"
SWEP.ViewModel = "models/weapons/arccw/c_ur_ak.mdl"

SWEP.Bodygroups = {[1] = 6,[2] = 0,[3] = 0,[4] = 2,[5] = 1,[6] = 9,[7] = 5,[8] = 2,[9] = 0,[10] = 0}

SWEP.HoldType = "revolver"

SWEP.holdtypes = {
    ["revolver"] = {[1] = 0.55,[2] = 1.2,[3] = 1.85,[4] = 2},
}

SWEP.Primary.ReloadTime = 2.4
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 45
SWEP.Primary.Force = 45
SWEP.Primary.Ammo = "7.62x39 mm"
SWEP.Primary.Wait = 0.09
SWEP.Sound = "sounds_zcity/sr25/close.wav"
SWEP.SubSound = "hmcd/rifle_win1892/win1892_fire_01.wav"
SWEP.SuppressedSound = "sounds_zcity/ak74/supressor.wav"
SWEP.RecoilForce = 0.4

SWEP.WorldPos = Vector(-5,-0.5,0)
SWEP.WorldAng = Angle(0,0,6)
SWEP.AttPos = Vector(27,2.91,-2.4)
SWEP.AttAng = Angle(1.8,-0.15,0)
SWEP.HolsterAng = Angle(140,0,180)
SWEP.HolsterPos = Vector(-16,6,5.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.BoltBone = "vm_bolt"
SWEP.BoltVec = Vector(0,2,0)

SWEP.ZoomPos = Vector(7,-2.55,-1.3)
SWEP.ZoomAng = Angle(1.3,-0.26,0)

SWEP.Rarity = 4

SWEP.TwoHands = true

SWEP.MountType = "dovetail"
SWEP.MountModel = "models/weapons/arc9_eft_shared/atts/mounts/mount_dovetail_aksion_kobra.mdl"
SWEP.MountPos = Vector(0.71,5,3.1)
SWEP.MountAng = Angle(0,0,0)
SWEP.MountScale = 0.75

SWEP.AttBone = "tag_weapon"

SWEP.AttachmentPos = {
    ['sight'] = Vector(3,0,4.9),
    ['barrel'] = Vector(24,0,2.7),
}

SWEP.AttachmentAng = {
    ['sight'] = Angle(0,0,-90),
    ['barrel'] = Angle(0,0,-90),
}

SWEP.IconPos = Vector(80,-18.5,-1.5)
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