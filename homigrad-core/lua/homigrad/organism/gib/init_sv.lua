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

hook.Add("Think","Ragdoll_Zalupa",function()
    for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do
        if IsValid(ent) and ent:IsRagdoll() then
            local rag = ent
            if rag.gib then
                rag:SetNWBool("NoHead",rag.gib.Head)
                rag:SetNWBool("NoLArm",rag.gib.LArm)
                rag:SetNWBool("NoRArm",rag.gib.RArm)
                rag:SetNWBool("NoLLeg",rag.gib.LLeg)
                rag:SetNWBool("NoRLeg",rag.gib.RLeg)
            end
        end
    end
end)

local vecZero = Vector(0,0,0)
local vecInf = Vector(1,1,1) / 0

local function removeBone(rag,bone,phys_bone)
	rag:ManipulateBoneScale(bone,vecZero)
	--rag:ManipulateBonePosition(bone,vecInf) -- Thanks Rama (only works on certain graphics cards!)

	if rag.gibRemove[phys_bone] then return end

	local phys_obj = rag:GetPhysicsObjectNum(phys_bone)
	
	if not IsValid(phys_obj) then return end

	phys_obj:EnableCollisions(false)
	phys_obj:SetMass(0.1)
	--rag:RemoveInternalConstraint(phys_bone)

	if rag.constraints and IsValid(rag.constraints[rag:GetBoneName(bone)]) then
		rag.constraints[rag:GetBoneName(bone)]:Remove()
		rag.constraints[rag:GetBoneName(bone)] = nil
	end

	constraint.RemoveAll(phys_obj)
	rag.gibRemove[phys_bone] = phys_obj
end

local function recursive_bone(rag,bone,list)
	for i,bone in pairs(rag:GetChildBones(bone)) do
		if bone == 0 then continue end--wtf

		list[#list + 1] = bone

		recursive_bone(rag, bone, list)
	end

end

function Gib_RemoveBone(rag,bone,phys_bone)
	rag.gibRemove = rag.gibRemove or {}

	removeBone(rag,bone,phys_bone)

	local list = {}
	recursive_bone(rag,bone,list)
	for i,bone in pairs(list) do
		removeBone(rag,bone,rag:TranslateBoneToPhysBone(bone))
	end
end

hook.Add("Homigrad_Gib", "Gib_Main", function(rag, dmginfo, physbone, hitgroup, bone)
	if WhiteList[rag:GetModel()] then return end

	local owner = rag:GetNWEntity("RagdollOwner")
	if IsValid(owner) and owner.FakeRagdoll == rag then
		owner.LastHitBone = bone
		owner:SetNWString("LastHitBone", bone)
	end

	dmginfo:ScaleDamage(2)
	if dmginfo:GetInflictor().NumBullet then
		dmginfo:ScaleDamage(dmginfo:GetInflictor().NumBullet / 2)
	end

	if not rag.gib then
		rag.gib = {
			Head = false,
			LArm = false,
			RArm = false,
			Torso = false,
			LLeg = false,
			RLeg = false,
			Full = false
		}
	end

	if rag.gib.Full then
		rag.gib = {
			Head = true,
			LArm = true,
			RArm = true,
			Torso = true,
			LLeg = true,
			RLeg = true,
			Full = true
		}
		return
	end

	local highDamage = dmginfo:GetDamage() > 40 and not dmginfo:IsDamageType(DMG_SLASH + DMG_CRUSH)
	local slashCrushKill = dmginfo:GetDamage() > 370 and dmginfo:IsDamageType(DMG_SLASH + DMG_CRUSH)

	if (highDamage or slashCrushKill) and hitgroup == HITGROUP_HEAD and not rag.gib.Head then
		rag.gib.Head = true

		local bonePos, boneAng = rag:GetBonePosition(physbone)

		if IsValid(owner) and (owner.FakeRagdoll == rag or not owner:Alive()) then
			hg.Gibbed[owner] = true
		end

		local headBone = rag:LookupBone("ValveBiped.Bip01_Head1")
		rag:ManipulateBoneScale(headBone, VecZero)

		local phys = rag:GetPhysicsObjectNum(physbone)
		phys:EnableCollisions(false)
		phys:SetMass(0.1)
		constraint.RemoveAll(phys)

		if IsValid(owner) and owner.FakeRagdoll == rag then
			owner.KillReason = "dead_headExplode"
			local realOwner = hg.RagdollOwner(rag)
			if IsValid(realOwner) and realOwner.Fake and realOwner.FakeRagdoll == rag and realOwner:Alive() then
				hg.DropArmor(owner, owner.armor.head, phys:GetPos(), phys:GetAngles():Forward() * 250 + phys:GetAngles():Right() * 100)
				owner:Kill()
			end
		end

		local pos, ang = rag:GetBonePosition(headBone)

		net.Start("bp headshoot explode")
		net.WriteVector(pos)
		net.WriteVector(VectorRand() + ((IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():EyeAngles():Forward() * -10) or ang:Forward() * 10) * math.random(10, 30))
		net.Broadcast()

		net.Start("bp buckshoot")
		net.WriteVector(pos)
		net.WriteVector((dmginfo:GetAttacker():EyeAngles():Forward()))
		net.Broadcast()
	end

	local highVel = rag:GetVelocity():Length()
	local fullGibCondition = (
		(dmginfo:GetDamage() > 350 and highVel > 450) or 
		highVel > 900 or 
		dmginfo:GetDamageType() == DMG_BLAST
	)

	if fullGibCondition and not dmginfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT) then
		if not rag.gib.Full then
			if IsValid(owner) and (owner.FakeRagdoll == rag or not owner:Alive()) then
				hg.Gibbed[owner] = true
			end

			if IsValid(owner) and owner.FakeRagdoll == rag then
				timer.Simple(0, function()
					owner.KillReason = "dead_fullgib"
					local realOwner = hg.RagdollOwner(rag)
					if IsValid(realOwner) and realOwner.Fake and realOwner.FakeRagdoll == rag and realOwner:Alive() then
						realOwner:Kill()
					end
				end)
			end

			local spinePos, spineAng = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_Spine2"))

			net.Start("blood particle explode")
			net.WriteVector(spinePos)
			net.WriteVector(spinePos + spineAng:Up() * 10)
			net.Broadcast()

			net.Start("bp fall")
			net.WriteVector(spinePos)
			net.WriteVector(spinePos + spineAng:Up() * 10)
			net.Broadcast()

			rag.gib.Full = true
			rag:Remove()
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



//Остальная хуйня

local vecZero = Vector(0,0,0)
local vecInf = Vector(1,1,1) / 0

local function removeBone(rag,bone,phys_bone)
	rag:ManipulateBoneScale(bone,vecZero)
	--rag:ManipulateBonePosition(bone,vecInf) -- Thanks Rama (only works on certain graphics cards!)

	if rag.gibRemove[phys_bone] then return end

	local phys_obj = rag:GetPhysicsObjectNum(phys_bone)
	
	if not IsValid(phys_obj) then return end

	phys_obj:EnableCollisions(false)
	phys_obj:SetMass(0.1)
	--rag:RemoveInternalConstraint(phys_bone)

	if rag.constraints and IsValid(rag.constraints[rag:GetBoneName(bone)]) then
		rag.constraints[rag:GetBoneName(bone)]:Remove()
		rag.constraints[rag:GetBoneName(bone)] = nil
	end

	constraint.RemoveAll(phys_obj)
	rag.gibRemove[phys_bone] = phys_obj
end

local function recursive_bone(rag,bone,list)
	for i,bone in pairs(rag:GetChildBones(bone)) do
		if bone == 0 then continue end--wtf

		list[#list + 1] = bone

		recursive_bone(rag, bone, list)
	end

end

/*
["Head"] 
["LArm"] 
["RArm"] 
["Torso"]
["LLeg"] 
["RLeg"] 
["Full"] 
*/

local BoneToGib = {
    ["ValveBiped.Bip01_Head1"] = "NoHead",
    ["ValveBiped.Bip01_Neck1"] = "NoHead",
    ["ValveBiped.Bip01_L_Thigh"] = "NoLLeg",
    ["ValveBiped.Bip01_R_Thigh"] = "NoRLeg",
    ["ValveBiped.Bip01_L_UpperArm"] = "NoLArm",
    ["ValveBiped.Bip01_R_UpperArm"] = "NoRArm",
}

function Gib_RemoveBone(rag,bone,phys_bone)
    local name = rag:GetBoneName(bone)

    //print(name)
	rag.gibRemove = rag.gibRemove or {}

	removeBone(rag,bone,phys_bone)

    if BoneToGib[name] then
        rag:SetNWBool(BoneToGib[name],true)
        //print(BoneToGib[name])
    end

	local list = {}
	recursive_bone(rag,bone,list)
	for i,bone in pairs(list) do
		removeBone(rag,bone,rag:TranslateBoneToPhysBone(bone))
	end
end

concommand.Add("hg_removebone",function(ply)
	if not ply:IsAdmin() then return end
	local trace = hg.eyeTrace(ply,1000)
	local ent = trace.Entity
	if not IsValid(ent) then return end

	local phys_bone = trace.PhysicsBone
	if not phys_bone or phys_bone == 0 then return end

	Gib_RemoveBone(ent,ent:TranslatePhysBoneToBone(phys_bone),phys_bone)
end)