SWEP.Base = "weapon_deagle_b"
SWEP.PrintName = "Desert Eagle Golden"
SWEP.Category = "Оружие: Пистолеты"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw/c_ud_deagle.mdl"
SWEP.ViewModel = "models/weapons/arccw/c_ud_deagle.mdl"

SWEP.HoldType = "revolver"

SWEP.Primary.ReloadTime = 2.4
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Damage = 95
SWEP.Primary.Force = 30
SWEP.Primary.Ammo = "Golden Ingot"
SWEP.Primary.Wait = 0.2
SWEP.Sound = "sounds_zcity/deagle/close.wav"
SWEP.SubSound = "homigrad/vgui/xp_milestone_05.wav"
SWEP.SubSoundVolume = 2
SWEP.SoundVolume = 0.6

SWEP.Skin = 2
SWEP.RecoilForce = 3

SWEP.holdtypes = {
    ["revolver"] = {[1] = 0.15,[2] = 0.85,[3] = 1.3,[4] = 0},
    ["revolver_empty"] = {[1] = 0.15,[2] = 1.15,[3] = 1.6,[4] = 0},
}

function SWEP:PostAnim()
    if self.BoltBone and self.BoltVec and CLIENT then
        local bone = self:GetWM():LookupBone(self.BoltBone)

        if bone then
            self:GetWM():ManipulateBonePosition(bone,self.BoltVec * self.animmul)
        end
    end

    if self:Clip1() == 0 and !self.reload then
        self.animmul = 1
    else 
        self.animmul = LerpFT(0.25,self.animmul,0)
    end

    self.SubSound = "homigrad/vgui/xp_milestone_0"..math.random(3,5)..".wav"
end

if SERVER then
    function SWEP:HitCallBack(tr)
        if IsValid(tr.Entity) then
            local ent = tr.Entity
            if tr.Entity:IsPlayer() then
                tr.Entity:Kill()
            end
            timer.Simple(0,function()
                if IsValid(tr.Entity.FakeRagdoll) then
                    ent = tr.Entity.FakeRagdoll
                end

                self:MakeGolden(ent)
            end)
        end
    end

    function SWEP:MakeGolden(ent)
        local ply = self:GetOwner()

        local bones = ent:GetPhysicsObjectCount()

        ent:SetMaterial("phoenix_storms/grey_chrome")
        ent:SetColor(Color(255,255,0))

        for bone = 1, bones - 1 do
			local constr = constraint.Weld( ent, ent, 0, bone, 0 )

            ent:GetPhysicsObjectNum(bone):Sleep()
            ent:GetPhysicsObjectNum(bone):SetMass(1)
        end
    end
end