local TPIKBones = { --почему эта пизда не работает???
    "ValveBiped.Bip01_L_Wrist",
    "ValveBiped.Bip01_L_Ulna",
    "ValveBiped.Bip01_L_Hand",
    "ValveBiped.Bip01_L_Finger4",
    "ValveBiped.Bip01_L_Finger41",
    "ValveBiped.Bip01_L_Finger42",
    "ValveBiped.Bip01_L_Finger3",
    "ValveBiped.Bip01_L_Finger31",
    "ValveBiped.Bip01_L_Finger32",
    "ValveBiped.Bip01_L_Finger2",
    "ValveBiped.Bip01_L_Finger21",
    "ValveBiped.Bip01_L_Finger22",
    "ValveBiped.Bip01_L_Finger1",
    "ValveBiped.Bip01_L_Finger11",
    "ValveBiped.Bip01_L_Finger12",
    "ValveBiped.Bip01_L_Finger0",
    "ValveBiped.Bip01_L_Finger01",
    "ValveBiped.Bip01_L_Finger02",
    "ValveBiped.Bip01_R_Wrist",
    "ValveBiped.Bip01_R_Ulna",
    "ValveBiped.Bip01_R_Hand",
    "ValveBiped.Bip01_R_Finger4",
    "ValveBiped.Bip01_R_Finger41",
    "ValveBiped.Bip01_R_Finger42",
    "ValveBiped.Bip01_R_Finger3",
    "ValveBiped.Bip01_R_Finger31",
    "ValveBiped.Bip01_R_Finger32",
    "ValveBiped.Bip01_R_Finger2",
    "ValveBiped.Bip01_R_Finger21",
    "ValveBiped.Bip01_R_Finger22",
    "ValveBiped.Bip01_R_Finger1",
    "ValveBiped.Bip01_R_Finger11",
    "ValveBiped.Bip01_R_Finger12",
    "ValveBiped.Bip01_R_Finger0",
    "ValveBiped.Bip01_R_Finger01",
    "ValveBiped.Bip01_R_Finger02",
}

--[[local TPIKBones2 = {
    "ValveBiped.Bip01_L_Clavicle",
    "ValveBiped.Bip01_L_UpperArm",
    "ValveBiped.Bip01_L_Forearm",
    "ValveBiped.Bip01_L_Wrist",
    "ValveBiped.Bip01_L_Ulna",
    "ValveBiped.Bip01_L_Hand",
    "ValveBiped.Bip01_L_Finger4",
    "ValveBiped.Bip01_L_Finger41",
    "ValveBiped.Bip01_L_Finger42",
    "ValveBiped.Bip01_L_Finger3",
    "ValveBiped.Bip01_L_Finger31",
    "ValveBiped.Bip01_L_Finger32",
    "ValveBiped.Bip01_L_Finger2",
    "ValveBiped.Bip01_L_Finger21",
    "ValveBiped.Bip01_L_Finger22",
    "ValveBiped.Bip01_L_Finger1",
    "ValveBiped.Bip01_L_Finger11",
    "ValveBiped.Bip01_L_Finger12",
    "ValveBiped.Bip01_L_Finger0",
    "ValveBiped.Bip01_L_Finger01",
    "ValveBiped.Bip01_L_Finger02",
    "ValveBiped.Bip01_R_Clavicle",
    "ValveBiped.Bip01_R_UpperArm",
    "ValveBiped.Bip01_R_Forearm",
    "ValveBiped.Bip01_R_Wrist",
    "ValveBiped.Bip01_R_Ulna",
    "ValveBiped.Bip01_R_Hand",
    "ValveBiped.Bip01_R_Finger4",
    "ValveBiped.Bip01_R_Finger41",
    "ValveBiped.Bip01_R_Finger42",
    "ValveBiped.Bip01_R_Finger3",
    "ValveBiped.Bip01_R_Finger31",
    "ValveBiped.Bip01_R_Finger32",
    "ValveBiped.Bip01_R_Finger2",
    "ValveBiped.Bip01_R_Finger21",
    "ValveBiped.Bip01_R_Finger22",
    "ValveBiped.Bip01_R_Finger1",
    "ValveBiped.Bip01_R_Finger11",
    "ValveBiped.Bip01_R_Finger12",
    "ValveBiped.Bip01_R_Finger0",
    "ValveBiped.Bip01_R_Finger01",
    "ValveBiped.Bip01_R_Finger02",
}

local TPIKBones3 = {
    "ValveBiped.Bip01_L_Clavicle",
    "ValveBiped.Bip01_L_UpperArm",
    "ValveBiped.Bip01_L_Forearm",
    "ValveBiped.Bip01_L_Wrist",
    "ValveBiped.Bip01_L_Ulna",
    "ValveBiped.Bip01_L_Hand",
    "ValveBiped.Bip01_L_Finger2",
    "ValveBiped.Bip01_L_Finger21",
    "ValveBiped.Bip01_L_Finger22",
    "ValveBiped.Bip01_L_Finger2",
    "ValveBiped.Bip01_L_Finger21",
    "ValveBiped.Bip01_L_Finger22",
    "ValveBiped.Bip01_L_Finger2",
    "ValveBiped.Bip01_L_Finger21",
    "ValveBiped.Bip01_L_Finger22",
    "ValveBiped.Bip01_L_Finger1",
    "ValveBiped.Bip01_L_Finger11",
    "ValveBiped.Bip01_L_Finger12",
    "ValveBiped.Bip01_L_Finger0",
    "ValveBiped.Bip01_L_Finger01",
    "ValveBiped.Bip01_L_Finger02",
    "ValveBiped.Bip01_R_Clavicle",
    "ValveBiped.Bip01_R_UpperArm",
    "ValveBiped.Bip01_R_Forearm",
    "ValveBiped.Bip01_R_Wrist",
    "ValveBiped.Bip01_R_Ulna",
    "ValveBiped.Bip01_R_Hand",
    "ValveBiped.Bip01_R_Finger2",
    "ValveBiped.Bip01_R_Finger21",
    "ValveBiped.Bip01_R_Finger22",
    "ValveBiped.Bip01_R_Finger2",
    "ValveBiped.Bip01_R_Finger21",
    "ValveBiped.Bip01_R_Finger22",
    "ValveBiped.Bip01_R_Finger2",
    "ValveBiped.Bip01_R_Finger21",
    "ValveBiped.Bip01_R_Finger22",
    "ValveBiped.Bip01_R_Finger1",
    "ValveBiped.Bip01_R_Finger11",
    "ValveBiped.Bip01_R_Finger12",
    "ValveBiped.Bip01_R_Finger0",
    "ValveBiped.Bip01_R_Finger01",
    "ValveBiped.Bip01_R_Finger02",
}--]]

local TPIKBonesTranslate = {
    --["ValveBiped.Bip01_L_UpperArm"] = "ValveBiped.Bip01_L_UpperArm",
    --["ValveBiped.Bip01_L_Forearm"] = "ValveBiped.Bip01_L_Forearm",
    --["ValveBiped.Bip01_L_Ulna"] = "ValveBiped.Bip01_L_Ulna",
    --["ValveBiped.Bip01_L_Wrist"] = "ValveBiped.Bip01_L_Wrist",
    ["ValveBiped.Bip01_L_Hand"] = "ValveBiped.Bip01_L_Hand",
    ["ValveBiped.Bip01_L_Finger4"] = "ValveBiped.Bip01_L_Finger2",
    ["ValveBiped.Bip01_L_Finger41"] = "ValveBiped.Bip01_L_Finger21",
    ["ValveBiped.Bip01_L_Finger42"] = "ValveBiped.Bip01_L_Finger22",
    ["ValveBiped.Bip01_L_Finger3"] = "ValveBiped.Bip01_L_Finger2",
    ["ValveBiped.Bip01_L_Finger31"] = "ValveBiped.Bip01_L_Finger21",
    ["ValveBiped.Bip01_L_Finger32"] = "ValveBiped.Bip01_L_Finger22",
    ["ValveBiped.Bip01_L_Finger2"] = "ValveBiped.Bip01_L_Finger2",
    ["ValveBiped.Bip01_L_Finger21"] = "ValveBiped.Bip01_L_Finger21",
    ["ValveBiped.Bip01_L_Finger22"] = "ValveBiped.Bip01_L_Finger22",
    ["ValveBiped.Bip01_L_Finger1"] = "ValveBiped.Bip01_L_Finger1",
    ["ValveBiped.Bip01_L_Finger11"] = "ValveBiped.Bip01_L_Finger11",
    ["ValveBiped.Bip01_L_Finger12"] = "ValveBiped.Bip01_L_Finger12",
    ["ValveBiped.Bip01_L_Finger0"] = "ValveBiped.Bip01_L_Finger0",
    ["ValveBiped.Bip01_L_Finger01"] = "ValveBiped.Bip01_L_Finger01",
    ["ValveBiped.Bip01_L_Finger02"] = "ValveBiped.Bip01_L_Finger02",

    --["ValveBiped.Bip01_R_UpperArm"] = "ValveBiped.Bip01_R_UpperArm",
    --["ValveBiped.Bip01_R_Forearm"] = "ValveBiped.Bip01_R_Forearm",
    --["ValveBiped.Bip01_R_Ulna"] = "ValveBiped.Bip01_R_Ulna",
    --["ValveBiped.Bip01_R_Wrist"] = "ValveBiped.Bip01_R_Wrist",
    ["ValveBiped.Bip01_R_Hand"] = "ValveBiped.Bip01_R_Hand",
    ["ValveBiped.Bip01_R_Finger4"] = "ValveBiped.Bip01_R_Finger2",
    ["ValveBiped.Bip01_R_Finger41"] = "ValveBiped.Bip01_R_Finger21",
    ["ValveBiped.Bip01_R_Finger42"] = "ValveBiped.Bip01_R_Finger22",
    ["ValveBiped.Bip01_R_Finger3"] = "ValveBiped.Bip01_R_Finger2",
    ["ValveBiped.Bip01_R_Finger31"] = "ValveBiped.Bip01_R_Finger21",
    ["ValveBiped.Bip01_R_Finger32"] = "ValveBiped.Bip01_R_Finger22",
    ["ValveBiped.Bip01_R_Finger2"] = "ValveBiped.Bip01_R_Finger2",
    ["ValveBiped.Bip01_R_Finger21"] = "ValveBiped.Bip01_R_Finger21",
    ["ValveBiped.Bip01_R_Finger22"] = "ValveBiped.Bip01_R_Finger22",
    ["ValveBiped.Bip01_R_Finger1"] = "ValveBiped.Bip01_R_Finger1",
    ["ValveBiped.Bip01_R_Finger11"] = "ValveBiped.Bip01_R_Finger11",
    ["ValveBiped.Bip01_R_Finger12"] = "ValveBiped.Bip01_R_Finger12",
    ["ValveBiped.Bip01_R_Finger0"] = "ValveBiped.Bip01_R_Finger0",
    ["ValveBiped.Bip01_R_Finger01"] = "ValveBiped.Bip01_R_Finger01",
    ["ValveBiped.Bip01_R_Finger02"] = "ValveBiped.Bip01_R_Finger02",
}

hg.TPIKBones = TPIKBones

hg.TPIKBonesOther = {
    "ValveBiped.Bip01_R_Clavicle",
    "ValveBiped.Bip01_R_UpperArm",
    "ValveBiped.Bip01_R_Forearm",
    "ValveBiped.Bip01_L_Clavicle",
    "ValveBiped.Bip01_L_UpperArm",
    "ValveBiped.Bip01_L_Forearm"
}

local TPIKBonesRH = {
    "ValveBiped.Bip01_R_Wrist",
    "ValveBiped.Bip01_R_Ulna",
    "ValveBiped.Bip01_R_Hand",
    "ValveBiped.Bip01_R_Finger4",
    "ValveBiped.Bip01_R_Finger41",
    "ValveBiped.Bip01_R_Finger42",
    "ValveBiped.Bip01_R_Finger3",
    "ValveBiped.Bip01_R_Finger31",
    "ValveBiped.Bip01_R_Finger32",
    "ValveBiped.Bip01_R_Finger2",
    "ValveBiped.Bip01_R_Finger21",
    "ValveBiped.Bip01_R_Finger22",
    "ValveBiped.Bip01_R_Finger1",
    "ValveBiped.Bip01_R_Finger11",
    "ValveBiped.Bip01_R_Finger12",
    "ValveBiped.Bip01_R_Finger0",
    "ValveBiped.Bip01_R_Finger01",
    "ValveBiped.Bip01_R_Finger02",
}

hg.TPIKBonesRH = TPIKBonesRH

local TPIKBonesLH = {
    "ValveBiped.Bip01_L_Wrist",
    "ValveBiped.Bip01_L_Ulna",
    "ValveBiped.Bip01_L_Hand",
    "ValveBiped.Bip01_L_Finger4",
    "ValveBiped.Bip01_L_Finger41",
    "ValveBiped.Bip01_L_Finger42",
    "ValveBiped.Bip01_L_Finger3",
    "ValveBiped.Bip01_L_Finger31",
    "ValveBiped.Bip01_L_Finger32",
    "ValveBiped.Bip01_L_Finger2",
    "ValveBiped.Bip01_L_Finger21",
    "ValveBiped.Bip01_L_Finger22",
    "ValveBiped.Bip01_L_Finger1",
    "ValveBiped.Bip01_L_Finger11",
    "ValveBiped.Bip01_L_Finger12",
    "ValveBiped.Bip01_L_Finger0",
    "ValveBiped.Bip01_L_Finger01",
    "ValveBiped.Bip01_L_Finger02",
}

hg.TPIKBonesLH = TPIKBonesLH

local developer = GetConVar("developer")

local hook_Run = hook.Run

function hg.DoTPIK(ply,ent,rhmat,lhmat)
    local ent = IsValid(ent) and ent or ply
    local tpikdelay = 0
    
	ply.TPIKCache = ply.TPIKCache or {}

    if ply != LocalPlayer() then
        --return
    end

    local shouldfulltpik = true

    if (ply.LastTPIKTime or 0) + tpikdelay > RealTime() then
        shouldfulltpik = false
    end

	--ent:SetupBones()

    local bones = TPIKBones

    local ply_spine_index = ply:LookupBone("ValveBiped.Bip01_Spine4")
    if !ply_spine_index then return end
    local ply_spine_matrix = ent:GetBoneMatrix(ply_spine_index)
    if !ply_spine_matrix then return end
    local wmpos = ply_spine_matrix:GetTranslation()
    
	local self = ply:GetActiveWeapon()
    
	if IsValid(self) and self.SetHandPos then
		--self:SetHandPos()
	end

    local lhik2 = IsValid(self) and self.lhandik and hg.CanUseLeftHand(ply)
    local rhik2 = IsValid(self) and self.rhandik
    
    ply.lerp_lh = LerpFT(0.1, ply.lerp_lh or 1, lhik2 and 1 or 0.001)
    ply.lerp_rh = LerpFT(0.1, ply.lerp_rh or 1, rhik2 and 1 or 0.001)
    
    local rhik = ply.lerp_rh > 0.01
    local lhik = ply.lerp_lh > 0.01
    
    if not rhik and not lhik then return end

    hook_Run("HandsChangePos",ply)

    local ply_l_upperarm_index = ply:LookupBone("ValveBiped.Bip01_L_UpperArm")
    local ply_r_upperarm_index = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
    local ply_l_forearm_index = ply:LookupBone("ValveBiped.Bip01_L_Forearm")
    local ply_r_forearm_index = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
    local ply_l_hand_index = ply:LookupBone("ValveBiped.Bip01_L_Hand")
    local ply_r_hand_index = ply:LookupBone("ValveBiped.Bip01_R_Hand")

    local ply_l_HELPERelbow_index = ply:LookupBone("ValveBiped.Bip01_L_Elbow")
    if ply_l_HELPERelbow_index and !ply:BoneHasFlag(ply_l_HELPERelbow_index, 524032) then ply_l_HELPERelbow_index = nil end -- ply:GetBoneName(ply_l_HELPERelbow_index) == "__INVALIDBONE__" can work too, same performance hit

    local ply_l_bicep_index = ply:LookupBone("ValveBiped.Bip01_L_Bicep")
    local ply_l_ulna_index = ply:LookupBone("ValveBiped.Bip01_L_Ulna") or ply:LookupBone("HumanLForearm2") -- THANK YOU MAl0 FOR NOT RENAMING YOUR BONES
    local ply_l_wrist_index = ply:LookupBone("ValveBiped.Bip01_L_Wrist") or ply:LookupBone("HumanLForearm3")

    local ply_r_HELPERelbow_index = ply:LookupBone("ValveBiped.Bip01_R_Elbow")
    if ply_r_HELPERelbow_index and !ply:BoneHasFlag(ply_r_HELPERelbow_index, 524032) then ply_r_HELPERelbow_index = nil end

    local ply_r_bicep_index = ply:LookupBone("ValveBiped.Bip01_R_Bicep")
    local ply_r_ulna_index = ply:LookupBone("ValveBiped.Bip01_R_Ulna") or ply:LookupBone("HumanRForearm2")
    local ply_r_wrist_index = ply:LookupBone("ValveBiped.Bip01_R_Wrist") or ply:LookupBone("HumanRForearm3")

    if ply_l_bicep_index and !ply:BoneHasFlag(ply_l_bicep_index, 524032) then ply_l_bicep_index = nil end
    if ply_l_ulna_index and !ply:BoneHasFlag(ply_l_ulna_index, 524032) then ply_l_ulna_index = nil end
    if ply_r_bicep_index and !ply:BoneHasFlag(ply_r_bicep_index, 524032) then ply_r_bicep_index = nil end
    if ply_r_ulna_index and !ply:BoneHasFlag(ply_r_ulna_index, 524032) then ply_r_ulna_index = nil end
    if ply_l_wrist_index and !ply:BoneHasFlag(ply_l_wrist_index, 524032) then ply_l_wrist_index = nil end
    if ply_r_wrist_index and !ply:BoneHasFlag(ply_r_wrist_index, 524032) then ply_r_wrist_index = nil end

    if !ply_l_upperarm_index then return end
    if !ply_r_upperarm_index then return end
    if !ply_l_forearm_index then return end
    if !ply_r_forearm_index then return end
    if !ply_l_hand_index then return end
    if !ply_r_hand_index then return end

    local ply_r_upperarm_matrix = ent:GetBoneMatrix(ply_r_upperarm_index)
    local ply_r_forearm_matrix = ent:GetBoneMatrix(ply_r_forearm_index)
    local ply_r_hand_matrix = ent:GetBoneMatrix(ply_r_hand_index)
    
    local ply_l_upperarm_matrix = ent:GetBoneMatrix(ply_l_upperarm_index)
    local ply_l_forearm_matrix = ent:GetBoneMatrix(ply_l_forearm_index)
    local ply_l_hand_matrix = ent:GetBoneMatrix(ply_l_hand_index)

    local limblength = ply:BoneLength(ply_l_forearm_index)
    local limblength2 = ply:BoneLength(ply_l_upperarm_index)
    if !limblength or limblength == 0 then limblength = 12 end

    local r_upperarm_length = limblength
    local r_forearm_length = limblength
    local l_upperarm_length = limblength
    local l_forearm_length = limblength

    local ply_r_upperarm_pos, ply_r_forearm_pos

    if not rhik2 then
        local lpos, _ = WorldToLocal(ply_r_hand_matrix:GetTranslation(), angle_zero, ply:EyePos(), ply:EyeAngles())
        ply.last_rh_pos = lpos

        if ply.last_rh_pos2 then
            local pos, _ = LocalToWorld(ply.last_rh_pos2, angle_zero, ply:EyePos(), ply:EyeAngles())
            ply_r_hand_matrix:SetTranslation(Lerp(ply.lerp_rh, ply_r_hand_matrix:GetTranslation(), pos))
        end
    else
        local lpos, _ = WorldToLocal(ply_r_hand_matrix:GetTranslation(), angle_zero, ply:EyePos(), ply:EyeAngles())
        ply.last_rh_pos2 = lpos
        
        if ply.last_rh_pos then
            local pos, _ = LocalToWorld(ply.last_rh_pos, angle_zero, ply:EyePos(), ply:EyeAngles())
            ply_r_hand_matrix:SetTranslation(Lerp(ply.lerp_rh, pos, ply_r_hand_matrix:GetTranslation()))
        end
    end

    --[[
    local sppos, spang = ply_spine_matrix:GetTranslation(), ply_spine_matrix:GetAngles()

    local lposlh, _ = WorldToLocal(ply_l_hand_matrix:GetTranslation(), angle_zero, sppos, spang)
    local lposrh, _ = WorldToLocal(ply_r_hand_matrix:GetTranslation(), angle_zero, sppos, spang)

    ply.last_rh_pos = LerpFT(0.1, ply.last_rh_pos or lposrh, lposrh)
    ply.last_lh_pos = LerpFT(0.1, ply.last_lh_pos or lposlh, lposlh)
    
    local poslh, _ = LocalToWorld(ply.last_lh_pos, angle_zero, sppos, spang)
    local posrh, _ = LocalToWorld(ply.last_rh_pos, angle_zero, sppos, spang)

    ply_r_hand_matrix:SetTranslation(posrh)
    ply_l_hand_matrix:SetTranslation(poslh)
    --]]

    local r_arm_startingpos = ply_r_upperarm_matrix:GetTranslation()
    local r_arm_endpos = ply_r_hand_matrix:GetTranslation() + ply_r_hand_matrix:GetAngles():Forward() * 1 + ply_r_hand_matrix:GetAngles():Up() * 0.5 + ply_r_hand_matrix:GetAngles():Right() * 0
    
    if shouldfulltpik or (not ply.TPIKCache.r_upperarm_pos) or (not ply.TPIKCache.r_forearm_pos) then
        ply_r_upperarm_pos, ply_r_forearm_pos, ply_r_upperarm_angle, ply_r_forearm_angle = hg.Solve2PartIK(r_arm_startingpos, r_arm_endpos, r_upperarm_length, r_forearm_length, ply_r_upperarm_matrix, ply_r_forearm_matrix, -40 + (ent:IsRagdoll() and -30 or 0), ply_spine_matrix)
        ply.LastTPIKTime = RealTime()
        
        ply.TPIKCache.r_upperarm_pos = WorldToLocal(ply_r_upperarm_pos, angle_zero, ply_r_upperarm_matrix:GetTranslation(), ply_r_upperarm_matrix:GetAngles())
        ply.TPIKCache.r_forearm_pos = WorldToLocal(ply_r_forearm_pos, angle_zero, ply_r_upperarm_matrix:GetTranslation(), ply_r_upperarm_matrix:GetAngles())
    else
        ply_r_upperarm_pos = LocalToWorld(ply.TPIKCache.r_upperarm_pos, angle_zero, ply_r_upperarm_matrix:GetTranslation(), ply_r_upperarm_matrix:GetAngles())
        ply_r_forearm_pos = LocalToWorld(ply.TPIKCache.r_forearm_pos, angle_zero, ply_r_upperarm_matrix:GetTranslation(), ply_r_upperarm_matrix:GetAngles())
    end

    ply_r_upperarm_matrix:SetTranslation(r_arm_startingpos)
    ply_r_forearm_matrix:SetTranslation(ply_r_upperarm_pos)

    local ply_r_upperarm_angle = ply_r_upperarm_angle--(ply_r_upperarm_pos - ply_r_upperarm_matrix:GetTranslation()):GetNormalized():Angle()
    
    ply_r_upperarm_matrix:SetAngles(ply_r_upperarm_angle)

    local ply_r_forearm_angle = ply_r_forearm_angle--(ply_r_forearm_pos - ply_r_upperarm_pos):GetNormalized():Angle()

    ply_r_forearm_matrix:SetAngles(ply_r_forearm_angle)

    if rhik then
        hg.bone_apply_matrix(ent, ply_r_upperarm_index, ply_r_upperarm_matrix, ply_r_hand_index)
        ply_r_forearm_matrix:SetTranslation(ent:GetBoneMatrix(ply_r_forearm_index):GetTranslation())
        hg.bone_apply_matrix(ent, ply_r_forearm_index, ply_r_forearm_matrix, ply_r_hand_index)
        hg.bone_apply_matrix(ent, ply_r_hand_index, ply_r_hand_matrix)
    end

    local ply_l_HELPERelbow_matrix = ply_l_HELPERelbow_index and ent:GetBoneMatrix(ply_l_HELPERelbow_index)
    local ply_l_bicep_matrix = ply_l_bicep_index and ent:GetBoneMatrix(ply_l_bicep_index)
    local ply_l_ulna_matrix = ply_l_ulna_index and ent:GetBoneMatrix(ply_l_ulna_index)
    local ply_l_wrist_matrix = ply_l_wrist_index and ent:GetBoneMatrix(ply_l_wrist_index)

    local ply_r_HELPERelbow_matrix = ply_r_HELPERelbow_index and ent:GetBoneMatrix(ply_r_HELPERelbow_index)
    local ply_r_bicep_matrix = ply_r_bicep_index and ent:GetBoneMatrix(ply_r_bicep_index)
    local ply_r_ulna_matrix = ply_r_ulna_index and ent:GetBoneMatrix(ply_r_ulna_index)
    local ply_r_wrist_matrix = ply_r_wrist_index and ent:GetBoneMatrix(ply_r_wrist_index)

    local ply_l_upperarm_pos, ply_l_forearm_pos

    if not lhik2 then
        local lpos, _ = WorldToLocal(ply_l_hand_matrix:GetTranslation(), angle_zero, ply:EyePos(), ply:EyeAngles())
        ply.last_lh_pos = lpos

        if ply.last_lh_pos2 then
            local pos, _ = LocalToWorld(ply.last_lh_pos2, angle_zero, ply:EyePos(), ply:EyeAngles())
            ply_l_hand_matrix:SetTranslation(Lerp(ply.lerp_lh, ply_l_hand_matrix:GetTranslation(), pos))
        end
    else
        local lpos, _ = WorldToLocal(ply_l_hand_matrix:GetTranslation(), angle_zero, ply:EyePos(), ply:EyeAngles())
        ply.last_lh_pos2 = lpos

        if ply.last_lh_pos then
            local pos, _ = LocalToWorld(ply.last_lh_pos, angle_zero, ply:EyePos(), ply:EyeAngles())
            ply_l_hand_matrix:SetTranslation(Lerp(ply.lerp_lh, pos, ply_l_hand_matrix:GetTranslation()))
        end
    end

    local l_arm_startingpos = ply_l_upperarm_matrix:GetTranslation()
    local l_arm_endpos = ply_l_hand_matrix:GetTranslation() + ply_l_hand_matrix:GetAngles():Forward() * 1 + ply_l_hand_matrix:GetAngles():Up() * -0.5 + ply_l_hand_matrix:GetAngles():Right() * 0

    if shouldfulltpik or (not ply.TPIKCache.l_upperarm_pos) or (not ply.TPIKCache.l_forearm_pos) then
        ply_l_upperarm_pos, ply_l_forearm_pos, ply_l_upperarm_angle, ply_l_forearm_angle = hg.Solve2PartIK(l_arm_startingpos, l_arm_endpos, l_upperarm_length, l_forearm_length, ply_l_upperarm_matrix, ply_l_forearm_matrix, 40 + (ent:IsRagdoll() and 30 or 0), ply_spine_matrix)
        
        ply.LastTPIKTime = RealTime()
        ply.TPIKCache.l_upperarm_pos = WorldToLocal(ply_l_upperarm_pos, angle_zero, ply_l_upperarm_matrix:GetTranslation(), ply_l_upperarm_matrix:GetAngles())
        ply.TPIKCache.l_forearm_pos = WorldToLocal(ply_l_forearm_pos, angle_zero, ply_l_upperarm_matrix:GetTranslation(), ply_l_upperarm_matrix:GetAngles())
    else
        ply_l_upperarm_pos = LocalToWorld(ply.TPIKCache.l_upperarm_pos, angle_zero, ply_l_upperarm_matrix:GetTranslation(), ply_l_upperarm_matrix:GetAngles())
        ply_l_forearm_pos = LocalToWorld(ply.TPIKCache.l_forearm_pos, angle_zero, ply_l_upperarm_matrix:GetTranslation(), ply_l_upperarm_matrix:GetAngles())
    end
    
    local ply_l_forearm_angle = ply_l_forearm_angle--(ply_l_forearm_pos - ply_l_upperarm_pos):Angle()
    local ply_l_upperarm_angle = ply_l_upperarm_angle--(ply_l_upperarm_pos - ply_l_upperarm_matrix:GetTranslation()):Angle()

    --ply_l_upperarm_matrix:SetTranslation(l_arm_startingpos)
    --ply_l_forearm_matrix:SetTranslation(ply_l_upperarm_pos)

    ply_l_upperarm_matrix:SetAngles(ply_l_upperarm_angle)

    ply_l_forearm_angle.r = ply_l_forearm_angle.r - (ThatPlyIsFemale(ent) and 15 or 0)
    ply_l_forearm_matrix:SetAngles(ply_l_forearm_angle)

    if lhik then
        hg.bone_apply_matrix(ent, ply_l_upperarm_index, ply_l_upperarm_matrix)

        ply_l_forearm_matrix:SetTranslation(ent:GetBoneMatrix(ply_l_forearm_index):GetTranslation())
        hg.bone_apply_matrix(ent, ply_l_forearm_index, ply_l_forearm_matrix)
        --local dist = ply_l_hand_matrix:GetTranslation():Distance(ply_spine_matrix:GetTranslation())
        hg.bone_apply_matrix(ent, ply_l_hand_index, ply_l_hand_matrix)
    end

    self.lhandik = false
    self.rhandik = false
end

local cached_huy = {}

local hg_coolgloves = ConVarExists("hg_coolgloves") and GetConVar("hg_coolgloves") or CreateClientConVar("hg_coolgloves", 0, true, false, "Enable cool gloves (only firstperson)", 0, 1)

local vector_small = Vector(0,0,0)
local vector_small2 = Vector(0.1,0.1,0.1) / 1

hook.Add("PostDrawPlayerRagdoll", "zcity_drawplayerragdollmain", function(ent, ply)
	if not ply:IsPlayer() then return end
	if not IsValid(ply) then return end
    local wpn = ply:GetActiveWeapon()

    local ply_l_hand_index = ply:LookupBone("ValveBiped.Bip01_L_Hand")
    local ply_r_hand_index = ply:LookupBone("ValveBiped.Bip01_R_Hand")

    ply.ply_l_hand_matrix = ent:GetBoneMatrix(ply_l_hand_index)
    ply.ply_r_hand_matrix = ent:GetBoneMatrix(ply_r_hand_index)

	if wpn.SetHandPos then wpn:SetHandPos() end
	
	hg.FlashlightPos(ply)
	
	if IsValid(wpn) and (wpn:GetClass() ~= "weapon_hands_sh") and IsValid(ply:GetNetVar("carryent2")) then
        hg.DragHands(ply,wpn)
    end

	--local rhmat,lhmat = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_R_Hand")),ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_L_Hand"))

    --if hg.ShouldTPIK(ply,wpn) and (wpn.lhandik or wpn.rhandik) then hg.DoTPIK(ply,ent) end
    if hg.ShouldTPIK(ply,wpn) or ply.GettingUp then hg.DoTPIK(ply,ent) end
    
    if not hg_coolgloves:GetBool() then return end
    local huy = (GetViewEntity() == ply) or (not LocalPlayer():Alive() and LocalPlayer():GetNWEntity("spect") == ply and LocalPlayer():GetNWInt("viewmode",0) == 1)
    
    if ply.GetPlayerClass and ply:GetPlayerClass() and ply:GetPlayerClass().NoGloves then return end

    if not huy then return end

    if not IsValid(ply.c_hands) then
        ply.c_hands = ClientsideModel("models/romka/c_arms/romka_combine_soldier_prison_c_hands.mdl")
        ply.c_hands:SetNoDraw(true)
        ply.c_hands:SetPos(ply:EyePos())
        ply.c_hands:SetParent(ply)
        --[[ply.c_hands.GetPlayerColor = function()
            return ply:GetPlayerColor()
        end--]]
    end
    --ply.c_hands:Remove()
    local mdl = ply.c_hands
    --mdl:SetModel("models/romka/c_arms/romka_combine_soldier_prison_c_hands.mdl")
    --mdl:SetPos(ent:GetPos())
    --mdl:SetAngles(ent:GetAngles())
    mdl:SetupBones()

    local mdlmodel = mdl:GetModel()
    cached_huy[mdlmodel] = cached_huy[mdlmodel] or {}
    for bone1 = 0, mdl:GetBoneCount() - 1 do
        if not cached_huy[mdlmodel][bone1] then cached_huy[mdlmodel][bone1] = mdl:GetBoneName(bone1) end
        local bone = cached_huy[mdlmodel][bone1]
        local wm_boneindex = mdl:LookupBone(bone)
        if !wm_boneindex then continue end
        local wm_bonematrix = mdl:GetBoneMatrix(wm_boneindex)
        if !wm_bonematrix then continue end
        
        local ply_boneindex = ent:LookupBone(TPIKBonesTranslate[bone] or bone)
        if !ply_boneindex then continue end
        local ply_bonematrix = ent:GetBoneMatrix(ply_boneindex)
        if !ply_bonematrix then continue end

        local bonepos = ply_bonematrix:GetTranslation()
        local boneang = ply_bonematrix:GetAngles()

        if !TPIKBonesTranslate[bone] or bone == TPIKBonesTranslate[bone] then wm_bonematrix:SetTranslation(bonepos) end
        wm_bonematrix:SetAngles(boneang)
        
        if TPIKBonesTranslate[bone] then
            ply_bonematrix:SetScale(vector_small2)
            ent:SetBoneMatrix(ply_boneindex, ply_bonematrix)
        end

        hg.bone_apply_matrix(mdl, wm_boneindex, wm_bonematrix)
                
        if !TPIKBonesTranslate[bone] then
            wm_bonematrix:SetScale(vector_small)
            mdl:SetBoneMatrix(wm_boneindex, wm_bonematrix)
        end
    end
    --render.SetColorModulation(255,0,255)
    mdl:DrawModel()
    --render.SetColorModulation(255,255,255)
    --mdl:SetColor(Color(255,255,0,255))

end)

function hg.Solve2PartIK(start_p, end_p, length0, length1, mat0, mat1, add_rotation, torsomat)
    -- local circle = math.sqrt((end_p.x-start_p.x) ^ 2 + (end_p.y-start_p.y) ^ 2 )
    -- local length2 = math.sqrt(circle ^ 2 + (end_p.z-start_p.z) ^ 2 )
    local length2 = (start_p - end_p):Length()

    if length0 + length1 < length2 then
        local add = length2 - length1 - length0
        length0 = length0 + add * length0 / (length2 - add)
        length1 = length1 + add * length1 / (length2 - add)
    end
    
    local prev_ang0 = Quaternion():SetMatrix(mat0)
    local prev_ang1 = Quaternion():SetMatrix(mat1)

    local cosAngle0 = math.Clamp(((length2 * length2) + (length0 * length0) - (length1 * length1)) / (2 * length2 * length0), -1, 1)
    local angle0 = -math.deg(math.acos(cosAngle0))
    local cosAngle1 = math.Clamp(((length1 * length1) + (length0 * length0) - (length2 * length2)) / (2 * length1 * length0), -1, 1)
    local angle1 = -math.deg(math.acos(cosAngle1))
    local diff = end_p - start_p
    diff:Normalize()
    local angle2 = math.deg(math.atan2(-math.sqrt(diff.x * diff.x + diff.y * diff.y), diff.z)) - 90
    local angle3 = -math.deg(math.atan2(diff.x, diff.y)) - 90
    angle3 = math.NormalizeAngle(angle3)

    --[[local torsopos = torsomat:GetTranslation()
    local diffang = (torsopos - end_p):Angle()
    diffang:Normalize()
    local difference = math.AngleDifference(angle3, diffang[2])
    angle3 = angle3 - difference + (math.abs(difference) > 20 and (20 * (difference / math.abs(difference))) or difference)--]]
    local axis = diff * 1
    axis:Normalize()
    local Joint0 = Angle(angle0 + angle2, angle3, 30)
    Joint0:RotateAroundAxis(Joint0:Forward(),90)
    Joint0:RotateAroundAxis(axis,add_rotation)
    --prev_ang0:SetDirection(Joint0:Forward())
    prev_ang0:SetAngle(Joint0)

    local Joint0 = prev_ang0:Angle():Forward() * length0

    local Joint1 = Angle(angle0 + angle2 + 180 + angle1, angle3, 0)
    Joint1:RotateAroundAxis(Joint1:Forward(),90)
    Joint1:RotateAroundAxis(axis,add_rotation)
    --prev_ang1:SetDirection(Joint1:Forward())
    prev_ang1:SetAngle(Joint1)

    local Joint1 = prev_ang1:Angle():Forward() * length1

    local Joint0_F = start_p + Joint0
    local Joint1_F = Joint0_F + Joint1

    return Joint0_F, Joint1_F, prev_ang0:Angle(), prev_ang1:Angle()
end

local vecZero,angZero = Vector(0,0,0),Angle(0,0,0)

hook.Add("Camera","Flashlights",function(ply, pos, angles, view)
    local ply = ply or LocalPlayer()
    if not IsValid(ply) then return end
    --hg.FlashlightPos(ply)
end)

function hg.FlashlightPos(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not ply:GetNetVar("flashlight",false) then if IsValid(ply.flashlight) then ply.flashlight:Remove() end return end
    if not ply:GetNetVar("Inventory")["Weapons"]["hg_flashlight"] then if IsValid(ply.flashlight) then ply.flashlight:Remove() end if IsValid(ply.flmodel) then ply.flmodel:SetNoDraw(true) end return end
    
    local wep = ply:GetActiveWeapon()
    local flashlightwep

    if IsValid(wep) then
        local laser = wep.attachments and wep.attachments.underbarrel
        local attachmentData
        if (laser and not table.IsEmpty(laser)) or wep.laser then
            if laser and not table.IsEmpty(laser) then
                attachmentData = hg.attachments.underbarrel[laser[1]]
            else
                attachmentData = wep.laserData
            end
        end
        
        if attachmentData then flashlightwep = attachmentData.supportFlashlight end
    end

    if flashlightwep then if IsValid(ply.flashlight) then ply.flashlight:Remove() end return end -- может хуки добавить для подобной хрени
    
    local ent = hg.GetCurrentCharacter(ply)
	local rh,lh = ply:LookupBone("ValveBiped.Bip01_R_Hand"), ply:LookupBone("ValveBiped.Bip01_L_Hand")

	local rhmat = ply:GetBoneMatrix(rh)
	local lhmat = ply:GetBoneMatrix(lh)

    local headmat = ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_Head1"))
	
    local veclh,lang
    if ply == LocalPlayer() and ply == GetViewEntity() then
        veclh,lang = hg.FlashlightTransform(ply)
    else
        veclh,lang = hg.FlashlightTransform(ply,false)
    end

	local rhmat,lhmat = ply:GetBoneMatrix(rh),ply:GetBoneMatrix(lh)

    if IsValid(ply.FakeRagdoll) then return end
    if not rhmat or not lhmat then return end
    if not ishgweapon(wep) or wep.reload then return end

    if veclh and lang then
	    lhmat:SetTranslation(veclh)
	    lhmat:SetAngles(lang)
    end
    
	--hg.bone_apply_matrix(ply,rh,rhmat)
	--hg.bone_apply_matrix(ply,lh,lhmat)
end

hook.Add("DrawPlayerRagdoll","huy2",function(ent,ply)  end)

hook.Add("DrawPlayerRagdoll","govno_a_ne_Flashlights",function(ent,ply)

end)


function hg.DragHands(ply,self)
    if not IsValid(ply) then return end
    	
    local ply_spine_index = ply:LookupBone("ValveBiped.Bip01_Spine4")
    if !ply_spine_index then return end
    local ply_spine_matrix = ply:GetBoneMatrix(ply_spine_index)
    local wmpos = ply_spine_matrix:GetTranslation()

	local ent = IsValid(ply:GetNetVar("carryent")) and ply:GetNetVar("carryent") or IsValid(ply:GetNetVar("carryent2")) and ply:GetNetVar("carryent2")
	local pos = IsValid(ent) and ent:GetPos() or false
	local bon = ply:GetNetVar("carrybone",0) ~= 0 and ply:GetNetVar("carrybone",0) or ply:GetNetVar("carrybone2",0)
	local lpos = IsValid(ent) and (ply:GetNetVar("carrypos",nil) and ent:LocalToWorld(ply:GetNetVar("carrypos",nil)) or ply:GetNetVar("carrypos2",nil) and ent:LocalToWorld(ply:GetNetVar("carrypos2",nil)))
	--local twohands = (ply:GetNetVar("carrymass",0) ~= 0 and ply:GetNetVar("carrymass",0) or ply:GetNetVar("carrymass2",0)) > 15
	local twohands = ply:GetNetVar("carrymass",0) > 15 or (!hg.CanUseLeftHand(ply) and ply:GetActiveWeapon():GetClass() == "weapon_hands_sh")
	
	local norm
	
	if IsValid(ent) then
		local bone = ent:TranslatePhysBoneToBone(bon)
		local wanted_pos = bone ~= -1 and ent:GetBoneMatrix(bone) and ent:GetBoneMatrix(bone):GetTranslation() or ent:GetBoneMatrix(0) and ent:GetBoneMatrix(0):GetTranslation() or ent:GetPos()
		wanted_pos = lpos or wanted_pos
		local tr = {}
		local eyetr = hg.eyeTrace(ply)
		local start = ply_spine_matrix:GetTranslation()
		local len = (wanted_pos - start):Length()
		len = math.min(len,30)
		
		tr.start = start
		tr.endpos = start + (wanted_pos - start):GetNormalized() * len
		tr.filter = ply
		local TraceResult = util.TraceLine(tr)
		pos = TraceResult.HitPos - TraceResult.Normal * 4
		norm = wanted_pos - ply:EyePos()
	end

	local rh,lh = ply:LookupBone("ValveBiped.Bip01_R_Hand"), ply:LookupBone("ValveBiped.Bip01_L_Hand")
	local rhmat,lhmat = ply:GetBoneMatrix(rh),ply:GetBoneMatrix(lh)
    
	if pos then

        if twohands then

            local oldpos = rhmat:GetTranslation()
            --pos = pos + LerpFT(0.01,ply.oldposrh or (pos - oldpos),pos - oldpos)
            pos.x = math.Clamp(pos.x, oldpos.x - 38, oldpos.x + 38)
            pos.y = math.Clamp(pos.y, oldpos.y - 38, oldpos.y + 38)
            pos.z = math.Clamp(pos.z, oldpos.z - 38, oldpos.z + 38)

            rhmat:SetTranslation(pos)

            if norm then
                local pos,newang = LocalToWorld(Vector(0,-5,0),Angle(-45,0,90),pos,norm:Angle())
                rhmat:SetTranslation(pos)
                rhmat:SetAngles(newang)
            end

            hg.bone_apply_matrix(ply,rh,rhmat)
            
            ply.oldposrh = pos - oldpos
        end

        local oldpos = lhmat:GetTranslation()
        pos.x = math.Clamp(pos.x, oldpos.x - 38, oldpos.x + 38)
        pos.y = math.Clamp(pos.y, oldpos.y - 38, oldpos.y + 38)
        pos.z = math.Clamp(pos.z, oldpos.z - 38, oldpos.z + 38)

        if norm then
            local pos,newang = LocalToWorld(Vector(0,twohands and 5 or 0,0),Angle(-45,0,90),pos,norm:Angle())
            lhmat:SetTranslation(pos)
            lhmat:SetAngles(newang)
        end
        
        if hg.CanUseLeftHand(ply) then
            hg.bone_apply_matrix(ply,lh,lhmat)
        end
        ply.oldposlh = pos - oldpos
        
        self.lhandik = true
    end
end

function hg.DragHandsToPos(ply,self,pos,twohanded,twohanddist,norm,angrh,anglh)
    if not IsValid(ply) then return end
    	
    local ply_spine_index = ply:LookupBone("ValveBiped.Bip01_Spine4")
    if !ply_spine_index then return end
    local ply_spine_matrix = ply:GetBoneMatrix(ply_spine_index)
    local wmpos = ply_spine_matrix:GetTranslation()

	local ply_spine_index = ply:LookupBone("ValveBiped.Bip01_Spine4")
	if !ply_spine_index then return end
	local ply_spine_matrix = ply:GetBoneMatrix(ply_spine_index)
	local wmpos = ply_spine_matrix:GetTranslation()

	--local ent = IsValid(ply:GetNetVar("carryent")) and ply:GetNetVar("carryent") or IsValid(ply:GetNetVar("carryent2")) and ply:GetNetVar("carryent2")
	--local pos = IsValid(ent) and ent:GetPos() or false
	--local bon = ply:GetNetVar("carrybone",0) ~= 0 and ply:GetNetVar("carrybone",0) or ply:GetNetVar("carrybone2",0)
	--local lpos = IsValid(ent) and (ply:GetNetVar("carrypos",nil) and ent:LocalToWorld(ply:GetNetVar("carrypos",nil)) or ply:GetNetVar("carrypos2",nil) and ent:LocalToWorld(ply:GetNetVar("carrypos2",nil)))
	--local twohands = (ply:GetNetVar("carrymass",0) ~= 0 and ply:GetNetVar("carrymass",0) or ply:GetNetVar("carrymass2",0)) > 15
	local twohands = twohanded
	
	local norm = norm

	local rh,lh = ply:LookupBone("ValveBiped.Bip01_R_Hand"), ply:LookupBone("ValveBiped.Bip01_L_Hand")
	local rhmat,lhmat = ply:GetBoneMatrix(rh),ply:GetBoneMatrix(lh)
    
    self.lhandik = true
    
	if pos then
        if twohanded then
            self.rhandik = true

            local oldpos = rhmat:GetTranslation()
            --pos = pos + LerpFT(0.01,ply.oldposrh or (pos - oldpos),pos - oldpos)
            pos.x = math.Clamp(pos.x, oldpos.x - 38, oldpos.x + 38)
            pos.y = math.Clamp(pos.y, oldpos.y - 38, oldpos.y + 38)
            pos.z = math.Clamp(pos.z, oldpos.z - 38, oldpos.z + 38)

            rhmat:SetTranslation(pos)

            if norm then
                local pos,newang = LocalToWorld(Vector(0, -twohanddist or -5,0),angrh or Angle(0,0,180),pos,norm:Angle())
                rhmat:SetTranslation(pos)
                rhmat:SetAngles(newang)
            end

            hg.bone_apply_matrix(ply,rh,rhmat)
            ply.oldposrh = pos - oldpos
        end


        local oldpos = lhmat:GetTranslation()
        pos.x = math.Clamp(pos.x, oldpos.x - 38, oldpos.x + 38)
        pos.y = math.Clamp(pos.y, oldpos.y - 38, oldpos.y + 38)
        pos.z = math.Clamp(pos.z, oldpos.z - 38, oldpos.z + 38)

        if norm then
            local pos,newang = LocalToWorld(Vector(0,twohands and twohanddist or 5 or 0,0), anglh or Angle(0,0,0),pos,norm:Angle())
            lhmat:SetTranslation(pos)
            lhmat:SetAngles(newang)
        end

        hg.bone_apply_matrix(ply,lh,lhmat)
        ply.oldposlh = pos - oldpos
    end
end