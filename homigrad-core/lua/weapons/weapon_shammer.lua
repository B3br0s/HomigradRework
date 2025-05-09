SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Spawnable = true
SWEP.PrintName = "Кувалда"

SWEP.WorldModel = "models/weapons/me_sledge/w_me_sledge.mdl"

SWEP.Primary.Damage = 55
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.4
SWEP.Primary.Force = 150

SWEP.DrawSound = "weapons/melee/holster_in_light.wav"
SWEP.HitSound = {"physics/metal/metal_box_impact_hard1.wav","physics/metal/metal_box_impact_hard2.wav","physics/metal/metal_box_impact_hard3.wav"}
SWEP.FlashHitSound = {"physics/flesh/flesh_strider_impact_bullet1.wav","physics/flesh/flesh_strider_impact_bullet2.wav","physics/flesh/flesh_strider_impact_bullet3.wav"}
SWEP.ShouldDecal = false
SWEP.HoldType = "melee2"
SWEP.DamageType = DMG_CLUB

SWEP.SubStamina = 10

local VecZero = Vector(0.0001,0.0001,0.0001)
local VecFull = Vector(1,1,1)

function SWEP:Attack(ent,tr,dmgTab)
    if ent:GetBoneName(ent:TranslatePhysBoneToBone(tr.PhysicsBone)) == "ValveBiped.Bip01_Head1" then
        ent:EmitSound("physics/metal/sawblade_stick" .. math.random(1,3) .. ".wav")

        if not ent:IsRagdoll() then return end

        local rag = ent

        if not rag.gib then
            rag.gib = {}
        end

        if rag.gib["Head"] then return end

        local bonePos, boneAng = rag:GetBonePosition(tr.PhysicsBone)
        rag.gib["Head"] = true
        if rag:GetNWEntity("RagdollOwner") != nil and rag:GetNWEntity("RagdollOwner").FakeRagdoll == rag or rag:GetNWEntity("RagdollOwner") != NULL and !rag:GetNWEntity("RagdollOwner"):Alive() then
            hg.Gibbed[rag:GetNWEntity("RagdollOwner")] = true
        end
        rag:ManipulateBoneScale(rag:LookupBone("ValveBiped.Bip01_Head1"),VecZero)
        local phys_obj = rag:GetPhysicsObjectNum(tr.PhysicsBone)
	    phys_obj:EnableCollisions(false)
	    phys_obj:SetMass(0.1)
        constraint.RemoveAll(phys_obj)
        if rag and rag:GetNWEntity("RagdollOwner").FakeRagdoll == rag and rag:GetNWEntity("RagdollOwner"):Alive() then
            rag:GetNWEntity("RagdollOwner").KillReasoun = "HeadSmash"
            rag:GetNWEntity("RagdollOwner"):Kill()
        end
        local Pos,Ang = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_Head1"))
        net.Start("bp headshoot explode")
        net.WriteVector(Pos)
        net.WriteVector(Vector(0,0,-10) + VectorRand(-1,1))
        net.Broadcast()
        net.Start("bp buckshoot")
        net.WriteVector(Pos)
        net.WriteVector(Vector(0,0,-10) + VectorRand(-1,1))
        net.Broadcast()
    end

    local ent = RagdollOwner(ent) or ent
    if not IsValid(ent) then return end

    if IsValid(ent:GetPhysicsObject()) and (string.find(ent:GetPhysicsObject():GetMaterial(),"flesh") or string.find(ent:GetPhysicsObject():GetMaterial(),"player")) then
        sound.Play("physics/body/body_medium_break" .. math.random(1,2) .. ".wav",tr.HitPos,75)
    end
end

SWEP.sndTwroh = {"weapons/melee/swing_heavy_blunt_01.wav","weapons/melee/swing_heavy_blunt_02.wav","weapons/melee/swing_heavy_blunt_03.wav"}

SWEP.dwsItemPos = Vector(-0.5,4,0)
SWEP.dwsItemAng = Angle(90 + 45,0,90)
SWEP.dwsItemFOV = 0

SWEP.IconPos = Vector(16,50,-6)
SWEP.IconAng = Angle(-120,0,90)
SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""