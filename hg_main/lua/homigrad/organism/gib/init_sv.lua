util.AddNetworkString("blood particle")
util.AddNetworkString("bleed artery")
util.AddNetworkString("blood particle more")
util.AddNetworkString("blood particle explode")
util.AddNetworkString("bp headshoot explode")
util.AddNetworkString("bp buckshoot")
util.AddNetworkString("bp hit")
util.AddNetworkString("bp fall")

hg.Gibbed = {}

local WhiteList = {
    ["models/props_c17/furnituremattress001a.mdl"] = true,
    ["models/vortigaunt_slave.mdl"] = true,
    ["models/vortigaunt.mdl"] = true,
    ["models/lamarr.mdl"] = true
}

local filterEnt
local function filter(ent)
	return ent == filterEnt
end

local util_TraceLine = util.TraceLine

local VecZero = Vector(0.0001,0.0001,0.0001)
local VecFull = Vector(1,1,1)

BoneIntoHG={
    ["ValveBiped.Bip01_Head1"]=1,
    ["ValveBiped.Bip01_R_UpperArm"]=5,
    ["ValveBiped.Bip01_R_Forearm"]=5,
    ["ValveBiped.Bip01_R_Hand"]=5,
    ["ValveBiped.Bip01_L_UpperArm"]=4,
    ["ValveBiped.Bip01_L_Forearm"]=4,
    ["ValveBiped.Bip01_L_Hand"]=4,
    ["ValveBiped.Bip01_Pelvis"]=3,
    ["ValveBiped.Bip01_Spine"]=2,
    ["ValveBiped.Bip01_Spine2"]=2,
    ["ValveBiped.Bip01_Spine4"]=2,
    ["ValveBiped.Bip01_L_Thigh"]=6,
    ["ValveBiped.Bip01_L_Calf"]=6,
    ["ValveBiped.Bip01_L_Foot"]=6,
    ["ValveBiped.Bip01_R_Thigh"]=7,
    ["ValveBiped.Bip01_R_Calf"]=7,
    ["ValveBiped.Bip01_R_Foot"]=7
}

hook.Add("Homigrad_Gib","Gib_Main",function(rag,dmginfo,physbone,hitgroup,bone)
    if WhiteList[rag:GetModel()] then return end
    if IsValid(rag:GetNWEntity("RagdollOwner")) and rag:GetNWEntity("RagdollOwner").FakeRagdoll == rag then
        rag:GetNWEntity("RagdollOwner").LastHitBone = bone
        rag:GetNWEntity("RagdollOwner"):SetNWString('LastHitBone',bone)

    end
    if not rag.gib then
        rag.gib = {
            ["Head"] = false,
            ["LArm"] = false,
            ["RArm"] = false,
            ["Torso"] = false,
            ["LLeg"] = false,
            ["RLeg"] = false,
            ["Full"] = false
        }
    end
    if rag.gib["Full"] then
    rag.gib = {
        ["Head"] = true,
        ["LArm"] = true,
        ["RArm"] = true,
        ["Torso"] = true,
        ["LLeg"] = true,
        ["RLeg"] = true,  
        ["Full"] = true
    }
    return
    end
    if dmginfo:GetDamage() > 80 and not dmginfo:IsDamageType(DMG_SLASH + DMG_CRUSH) or dmginfo:GetDamage() > 270 and dmginfo:IsDamageType(DMG_SLASH + DMG_CRUSH) then
        if hitgroup == HITGROUP_HEAD and not rag.gib["Head"] then
            local bonePos, boneAng = rag:GetBonePosition(physbone)
            rag.gib["Head"] = true
            if rag:GetNWEntity("RagdollOwner") != nil and rag:GetNWEntity("RagdollOwner").FakeRagdoll == rag or rag:GetNWEntity("RagdollOwner") != NULL and !rag:GetNWEntity("RagdollOwner"):Alive() then
                hg.Gibbed[rag:GetNWEntity("RagdollOwner")] = true
            end
            rag:ManipulateBoneScale(rag:LookupBone("ValveBiped.Bip01_Head1"),VecZero)
            local phys_obj = rag:GetPhysicsObjectNum(physbone)
	        phys_obj:EnableCollisions(false)
	        phys_obj:SetMass(0.1)
            constraint.RemoveAll(phys_obj)
            if rag and rag:GetNWEntity("RagdollOwner").FakeRagdoll == rag then
                rag:GetNWEntity("RagdollOwner").KillReason = "dead_headExplode"
                if rag:GetNWEntity("RagdollOwner"):Alive() then
                rag:GetNWEntity("RagdollOwner"):Kill()
                end
            end
            local Pos,Ang = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_Head1"))
            net.Start("bp headshoot explode")
            net.WriteVector(Pos)
            net.WriteVector(Vector(0,0,0) + VectorRand() + (IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():EyeAngles():Forward() * -10 or Ang:Forward() * 10) * math.random(10,30))
            net.Broadcast()
            net.Start("bp buckshoot")
            net.WriteVector(Pos)
            net.WriteVector(Vector(0,0,0) + dmginfo:GetAttacker():EyeAngles():Forward())
            net.Broadcast()
        end
    end
    if dmginfo:GetDamage() > 350 and rag:GetVelocity():Length() > 450 or rag:GetVelocity():Length() > 1750 or dmginfo:GetDamageType() == DMG_BLAST then-- we do a little trolling
        if dmginfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT) then return end
        if not rag.gib["Full"] then
            if rag:GetNWEntity("RagdollOwner") != nil and rag:GetNWEntity("RagdollOwner").FakeRagdoll == rag or rag:GetNWEntity("RagdollOwner") != NULL and !rag:GetNWEntity("RagdollOwner"):Alive() then
                hg.Gibbed[rag:GetNWEntity("RagdollOwner")] = true
            end 
            if rag and rag:GetNWEntity("RagdollOwner").FakeRagdoll == rag then
                timer.Simple(0,function()
                    rag:GetNWEntity("RagdollOwner").KillReason = "dead_fullgib"
                    if rag:GetNWEntity("RagdollOwner"):Alive() then
                        rag:GetNWEntity("RagdollOwner"):Kill()
                        end
                end)
            end
            local Pos,Ang = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_Spine2"))
            net.Start("blood particle explode")
            net.WriteVector(Pos)
            net.WriteVector(Pos + Ang:Up() * 10)
            net.Broadcast()
            net.Start("bp fall")
            net.WriteVector(Pos)
            net.WriteVector(Pos + Ang:Up() * 10)
            net.Broadcast()
            if dmginfo:GetDamage() > 600 then
                rag:Remove()
            end
            rag.gib["Full"] = true
        end
    end
end)

hook.Add("EntityTakeDamage","Homigrad_Gib_Main",function(ent,dmginfo)
    --print(GetPhysicsBoneDamageInfo(ent,dmginfo))
    if !ent:IsRagdoll() then return end
    local PhysBone = GetPhysicsBoneDamageInfo(ent,dmginfo)

    local Bone = ent:GetBoneName(ent:TranslatePhysBoneToBone(PhysBone))
    hook.Run("Homigrad_Gib",ent,dmginfo,PhysBone,BoneIntoHG[Bone],Bone)
end)