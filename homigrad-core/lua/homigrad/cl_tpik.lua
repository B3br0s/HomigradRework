-- "addons\\homigrad\\lua\\homigrad\\cl_tpik.lua"
local TPIKBones = {
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

local TPIKBonesRHDict = {
    ["ValveBiped.Bip01_R_Hand"] = "ValveBiped.Bip01_R_Hand",
    ["ValveBiped.Bip01_R_Finger4"] = "ValveBiped.Bip01_R_Finger4",
    ["ValveBiped.Bip01_R_Finger41"] = "ValveBiped.Bip01_R_Finger41",
    ["ValveBiped.Bip01_R_Finger42"] = "ValveBiped.Bip01_R_Finger42",
    ["ValveBiped.Bip01_R_Finger3"] = "ValveBiped.Bip01_R_Finger3",
    ["ValveBiped.Bip01_R_Finger31"] = "ValveBiped.Bip01_R_Finger31",
    ["ValveBiped.Bip01_R_Finger32"] = "ValveBiped.Bip01_R_Finger32",
    ["ValveBiped.Bip01_R_Finger2"] = "ValveBiped.Bip01_R_Finger2",
    ["ValveBiped.Bip01_R_Finger21"] = "ValveBiped.Bip01_R_Finger21",
    ["ValveBiped.Bip01_R_Finger22"] = "ValveBiped.Bip01_R_Finger22",
    ["ValveBiped.Bip01_R_Finger1"] = "ValveBiped.Bip01_R_Finger1",
    ["ValveBiped.Bip01_R_Finger11"] = "ValveBiped.Bip01_R_Finger11",
    ["ValveBiped.Bip01_R_Finger12"] = "ValveBiped.Bip01_R_Finger12",
    ["ValveBiped.Bip01_R_Finger0"] = "ValveBiped.Bip01_R_Finger0",
    ["ValveBiped.Bip01_R_Finger01"] = "ValveBiped.Bip01_R_Finger01",
    ["ValveBiped.Bip01_R_Finger02"] = "ValveBiped.Bip01_R_Finger02",
    ["R Hand"] = "ValveBiped.Bip01_R_Hand",
    ["R Finger0"] = "ValveBiped.Bip01_R_Finger0",
    ["R Finger01"] = "ValveBiped.Bip01_R_Finger01",
    ["R Finger02"] = "ValveBiped.Bip01_R_Finger02",
    ["R Finger1"] = "ValveBiped.Bip01_R_Finger1",
    ["R Finger11"] = "ValveBiped.Bip01_R_Finger11",
    ["R Finger12"] = "ValveBiped.Bip01_R_Finger12",
    ["R Finger2"] = "ValveBiped.Bip01_R_Finger2",
    ["R Finger21"] = "ValveBiped.Bip01_R_Finger21",
    ["R Finger22"] = "ValveBiped.Bip01_R_Finger22",
    ["R Finger3"] = "ValveBiped.Bip01_R_Finger3",
    ["R Finger31"] = "ValveBiped.Bip01_R_Finger31",
    ["R Finger32"] = "ValveBiped.Bip01_R_Finger32",
    ["R Finger4"] = "ValveBiped.Bip01_R_Finger4",
    ["R Finger41"] = "ValveBiped.Bip01_R_Finger41",
    ["R Finger42"] = "ValveBiped.Bip01_R_Finger42",
    ["Bip01 R Hand"] = "ValveBiped.Bip01_R_Hand",
    ["Bip01 R Finger0"] = "ValveBiped.Bip01_R_Finger0",
    ["Bip01 R Finger01"] = "ValveBiped.Bip01_R_Finger01",
    ["Bip01 R Finger02"] = "ValveBiped.Bip01_R_Finger02",
    ["Bip01 R Finger1"] = "ValveBiped.Bip01_R_Finger1",
    ["Bip01 R Finger11"] = "ValveBiped.Bip01_R_Finger11",
    ["Bip01 R Finger12"] = "ValveBiped.Bip01_R_Finger12",
    ["Bip01 R Finger2"] = "ValveBiped.Bip01_R_Finger2",
    ["Bip01 R Finger21"] = "ValveBiped.Bip01_R_Finger21",
    ["Bip01 R Finger22"] = "ValveBiped.Bip01_R_Finger22",
    ["Bip01 R Finger3"] = "ValveBiped.Bip01_R_Finger3",
    ["Bip01 R Finger31"] = "ValveBiped.Bip01_R_Finger31",
    ["Bip01 R Finger32"] = "ValveBiped.Bip01_R_Finger32",
    ["Bip01 R Finger4"] = "ValveBiped.Bip01_R_Finger4",
    ["Bip01 R Finger41"] = "ValveBiped.Bip01_R_Finger41",
    ["Bip01 R Finger42"] = "ValveBiped.Bip01_R_Finger42",
}

local TPIKBonesLHDict = {
    ["ValveBiped.Bip01_L_Hand"] = "ValveBiped.Bip01_L_Hand",
    ["ValveBiped.Bip01_L_Finger4"] = "ValveBiped.Bip01_L_Finger4",
    ["ValveBiped.Bip01_L_Finger41"] = "ValveBiped.Bip01_L_Finger41",
    ["ValveBiped.Bip01_L_Finger42"] = "ValveBiped.Bip01_L_Finger42",
    ["ValveBiped.Bip01_L_Finger3"] = "ValveBiped.Bip01_L_Finger3",
    ["ValveBiped.Bip01_L_Finger31"] = "ValveBiped.Bip01_L_Finger31",
    ["ValveBiped.Bip01_L_Finger32"] = "ValveBiped.Bip01_L_Finger32",
    ["ValveBiped.Bip01_L_Finger2"] = "ValveBiped.Bip01_L_Finger2",
    ["ValveBiped.Bip01_L_Finger21"] = "ValveBiped.Bip01_L_Finger21",
    ["ValveBiped.Bip01_L_Finger22"] = "ValveBiped.Bip01_L_Finger22",
    ["ValveBiped.Bip01_L_Finger1"] = "ValveBiped.Bip01_L_Finger1",
    ["ValveBiped.Bip01_L_Finger11"] = "ValveBiped.Bip01_L_Finger11",
    ["ValveBiped.Bip01_L_Finger12"] = "ValveBiped.Bip01_L_Finger12",
    ["ValveBiped.Bip01_L_Finger0"] = "ValveBiped.Bip01_L_Finger0",
    ["ValveBiped.Bip01_L_Finger01"] = "ValveBiped.Bip01_L_Finger01",
    ["ValveBiped.Bip01_L_Finger02"] = "ValveBiped.Bip01_L_Finger02",
    ["L Hand"] = "ValveBiped.Bip01_L_Hand",
    ["L Finger0"] = "ValveBiped.Bip01_L_Finger0",
    ["L Finger01"] = "ValveBiped.Bip01_L_Finger01",
    ["L Finger02"] = "ValveBiped.Bip01_L_Finger02",
    ["L Finger1"] = "ValveBiped.Bip01_L_Finger1",
    ["L Finger11"] = "ValveBiped.Bip01_L_Finger11",
    ["L Finger12"] = "ValveBiped.Bip01_L_Finger12",
    ["L Finger2"] = "ValveBiped.Bip01_L_Finger2",
    ["L Finger21"] = "ValveBiped.Bip01_L_Finger21",
    ["L Finger22"] = "ValveBiped.Bip01_L_Finger22",
    ["L Finger3"] = "ValveBiped.Bip01_L_Finger3",
    ["L Finger31"] = "ValveBiped.Bip01_L_Finger31",
    ["L Finger32"] = "ValveBiped.Bip01_L_Finger32",
    ["L Finger4"] = "ValveBiped.Bip01_L_Finger4",
    ["L Finger41"] = "ValveBiped.Bip01_L_Finger41",
    ["L Finger42"] = "ValveBiped.Bip01_L_Finger42",
    ["Bip01 L Hand"] = "ValveBiped.Bip01_L_Hand",
    ["Bip01 L Finger0"] = "ValveBiped.Bip01_L_Finger0",
    ["Bip01 L Finger01"] = "ValveBiped.Bip01_L_Finger01",
    ["Bip01 L Finger02"] = "ValveBiped.Bip01_L_Finger02",
    ["Bip01 L Finger1"] = "ValveBiped.Bip01_L_Finger1",
    ["Bip01 L Finger11"] = "ValveBiped.Bip01_L_Finger11",
    ["Bip01 L Finger12"] = "ValveBiped.Bip01_L_Finger12",
    ["Bip01 L Finger2"] = "ValveBiped.Bip01_L_Finger2",
    ["Bip01 L Finger21"] = "ValveBiped.Bip01_L_Finger21",
    ["Bip01 L Finger22"] = "ValveBiped.Bip01_L_Finger22",
    ["Bip01 L Finger3"] = "ValveBiped.Bip01_L_Finger3",
    ["Bip01 L Finger31"] = "ValveBiped.Bip01_L_Finger31",
    ["Bip01 L Finger32"] = "ValveBiped.Bip01_L_Finger32",
    ["Bip01 L Finger4"] = "ValveBiped.Bip01_L_Finger4",
    ["Bip01 L Finger41"] = "ValveBiped.Bip01_L_Finger41",
    ["Bip01 L Finger42"] = "ValveBiped.Bip01_L_Finger42",
    ["l_wrist"] = "ValveBiped.Bip01_L_Hand",
    ["l_index_low"] = "ValveBiped.Bip01_L_Finger1",
    ["l_index_mid"] = "ValveBiped.Bip01_L_Finger11",
    ["l_index_tip"] = "ValveBiped.Bip01_L_Finger12",
    ["l_middle_low"] = "ValveBiped.Bip01_L_Finger2",
    ["l_middle_mid"] = "ValveBiped.Bip01_L_Finger21",
    ["l_middle_tip"] = "ValveBiped.Bip01_L_Finger22",
    ["l_thumb_low"] = "ValveBiped.Bip01_L_Finger0",
    ["l_thumb_mid"] = "ValveBiped.Bip01_L_Finger01",
    ["l_thumb_tip"] = "ValveBiped.Bip01_L_Finger02",
    
}

hg.TPIKBonesRHDict = TPIKBonesRHDict
hg.TPIKBonesLHDict = TPIKBonesLHDict

hg.TPIKBones = TPIKBones
hg.TPIKBonesTranslate = TPIKBonesTranslate

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

function hg.DoTPIK(ply, ent, rhmat, lhmat)
    local ent = IsValid(ent) and ent or ply
    ply.lastTPIK = ply.lastTPIK or SysTime()
    local dt = SysTime() - ply.lastTPIK
    
    local shouldfullupdate = false
    if dt > 0.01 then
        ply.lastTPIK = SysTime()

        shouldfullupdate = true
    end

    local ply_spine_index = ply:LookupBone("ValveBiped.Bip01_Spine4")
    if !ply_spine_index then return end
    local ply_spine_matrix = ent:GetBoneMatrix(ply_spine_index)

    local ply_head_index = ply:LookupBone("ValveBiped.Bip01_Head1")
    if !ply_head_index then return end
    local ply_head_matrix = ent:GetBoneMatrix(ply_head_index)

	local self = ply:GetActiveWeapon()

    local lhik2 = IsValid(self) //and self.lhandik //and hg.CanUseLeftHand(ply)
    local rhik2 = IsValid(self) //and self.rhandik //and hg.CanUseRightHand(ply)
    
    ply.lerp_lh = LerpFT(0.1, ply.lerp_lh or 1, lhik2 and 1 or 0.001)
    ply.lerp_rh = LerpFT(0.1, ply.lerp_rh or 1, rhik2 and 1 or 0.001)
    
    local rhik = ply.lerp_rh > 0.01
    local lhik = ply.lerp_lh > 0.01
    
    if not rhik and not lhik then return end

    local ply_l_clavicle_index = ply:LookupBone("ValveBiped.Bip01_L_Clavicle")
    local ply_r_clavicle_index = ply:LookupBone("ValveBiped.Bip01_R_Clavicle")
    local ply_l_upperarm_index = ply:LookupBone("ValveBiped.Bip01_L_UpperArm")
    local ply_r_upperarm_index = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
    local ply_l_forearm_index = ply:LookupBone("ValveBiped.Bip01_L_Forearm")
    local ply_r_forearm_index = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
    local ply_l_hand_index = ply:LookupBone("ValveBiped.Bip01_L_Hand")
    local ply_r_hand_index = ply:LookupBone("ValveBiped.Bip01_R_Hand")

    if !ply_l_upperarm_index then return end
    if !ply_r_upperarm_index then return end
    if !ply_l_forearm_index then return end
    if !ply_r_forearm_index then return end
    if !ply_l_hand_index then return end
    if !ply_r_hand_index then return end
    if !ply_head_matrix then return end

    local eyepos, eyeang = ply:EyePos(), ply:GetAimVector():Angle()
    local headpos = ply_head_matrix:GetTranslation()

    local ply_l_clavicle_matrix = ent:GetBoneMatrix(ply_l_clavicle_index)
    local ply_r_clavicle_matrix = ent:GetBoneMatrix(ply_r_clavicle_index)
    local ply_r_upperarm_matrix = ent:GetBoneMatrix(ply_r_upperarm_index)
    local ply_r_forearm_matrix = ent:GetBoneMatrix(ply_r_forearm_index)
    local ply_r_hand_matrix = ent:GetBoneMatrix(ply_r_hand_index)
    
    local ply_l_upperarm_matrix = ent:GetBoneMatrix(ply_l_upperarm_index)
    local ply_l_forearm_matrix = ent:GetBoneMatrix(ply_l_forearm_index)
    local ply_l_hand_matrix = ent:GetBoneMatrix(ply_l_hand_index)

    if not ply_r_hand_matrix or not ply_l_hand_matrix then return end

    local limblength = ply:BoneLength(ply_l_forearm_index)
    local limblength2 = ply:BoneLength(ply_l_upperarm_index)
    if !limblength or limblength == 0 then limblength = 12 end

    local r_upperarm_length = limblength
    local r_forearm_length = limblength
    local l_upperarm_length = limblength
    local l_forearm_length = limblength

    local ply_r_upperarm_pos, ply_r_forearm_pos, ply_r_upperarm_angle, ply_r_forearm_angle

    ply.last_nigga_pos = ply_r_hand_matrix:GetTranslation()
    ply.last_nigga_ang = ply_r_hand_matrix:GetAngles()

    if not rhik2 then
        local lpos, _ = WorldToLocal(ply_r_hand_matrix:GetTranslation(), angle_zero, eyepos, eyeang)
        ply.last_rh_pos = lpos

        if ply.last_rh_pos2 then
            local pos, _ = LocalToWorld(ply.last_rh_pos2, angle_zero, eyepos, eyeang)
            ply_r_hand_matrix:SetTranslation(Lerp(ply.lerp_rh, ply_r_hand_matrix:GetTranslation(), pos))
        end
    else
        local lpos, _ = WorldToLocal(ply_r_hand_matrix:GetTranslation(), angle_zero, eyepos, eyeang)
        ply.last_rh_pos2 = lpos
        
        if ply.last_rh_pos then
            local pos, _ = LocalToWorld(ply.last_rh_pos, angle_zero, eyepos, eyeang)
            ply_r_hand_matrix:SetTranslation(Lerp(ply.lerp_rh, pos, ply_r_hand_matrix:GetTranslation()))
        end
    end

    local r_arm_startingpos = ply_r_upperarm_matrix:GetTranslation()
    local offset = vector_origin
    local r_arm_endpos = ply_r_hand_matrix:GetTranslation() + offset
    
    if shouldfullupdate or !ply.ply_r_upperarm_pos then
        ply_r_upperarm_pos, ply_r_forearm_pos, ply_r_upperarm_angle, ply_r_forearm_angle = hg.Solve2PartIK(r_arm_startingpos, r_arm_endpos, r_upperarm_length, r_forearm_length, ply_r_upperarm_matrix, ply_r_forearm_matrix, -1, ply_spine_matrix, ply:GetAimVector():Angle(), ply_r_hand_matrix:GetAngles())

        ply.ply_r_upperarm_pos, ply.ply_r_upperarm_angle = WorldToLocal(ply_r_upperarm_pos, ply_r_upperarm_angle, headpos, eyeang)
        ply.ply_r_forearm_pos, ply.ply_r_forearm_angle = WorldToLocal(ply_r_forearm_pos, ply_r_forearm_angle, headpos, eyeang)
    else
        ply_r_upperarm_pos, ply_r_upperarm_angle = LocalToWorld(ply.ply_r_upperarm_pos, ply.ply_r_upperarm_angle, headpos, eyeang)
        ply_r_forearm_pos, ply_r_forearm_angle = LocalToWorld(ply.ply_r_forearm_pos, ply.ply_r_forearm_angle, headpos, eyeang)
    end
    
    //ply_r_upperarm_matrix:SetTranslation(r_arm_startingpos)
    ply_r_forearm_matrix:SetTranslation(ply_r_upperarm_pos)
    //debugoverlay.Line(r_arm_startingpos, ply_r_upperarm_pos, 1, color_white)
    //debugoverlay.Line(ply_r_upperarm_pos, ply_r_forearm_pos, 1, color_white)
    local ply_r_upperarm_angle = ply_r_upperarm_angle
    
    ply_r_upperarm_matrix:SetAngles(ply_r_upperarm_angle)

    local ply_r_forearm_angle = ply_r_forearm_angle

    ply_r_forearm_matrix:SetAngles(ply_r_forearm_angle)

    if rhik then
        hg.bone_apply_matrix(ent, ply_r_upperarm_index, ply_r_upperarm_matrix, ply_r_forearm_index)
        //ply_r_forearm_matrix:SetTranslation(ent:GetBoneMatrix(ply_r_forearm_index):GetTranslation())
        hg.bone_apply_matrix(ent, ply_r_forearm_index, ply_r_forearm_matrix, ply_r_hand_index)
        ply_r_hand_matrix:SetTranslation(ply_r_forearm_pos - offset)
        hg.bone_apply_matrix(ent, ply_r_hand_index, ply_r_hand_matrix)
    end

    local ply_l_upperarm_pos, ply_l_forearm_pos, ply_l_upperarm_angle, ply_l_forearm_angle

    if not lhik2 or ply.pullingTowards then
        local lpos, _ = WorldToLocal(ply_l_hand_matrix:GetTranslation(), angle_zero, eyepos, eyeang)
        ply.last_lh_pos = lpos

        if ply.last_lh_pos2 then
            local pos, _ = LocalToWorld(ply.last_lh_pos2, angle_zero, eyepos, eyeang)
            
            local lerp = ply.lerp_lh
            
            if ply.pullingTowards then
                if not IsValid(self) or not self.GetWM or not IsValid(self:GetWM()) || self != ply.pullingTowardsWeapon || (ply.pullingTowardsStart and ((ply.pullingTowardsStart + ply.pullingTowardsTime) < CurTime())) then
                    if ply.pullingTowardsCallback and IsValid(self) and self.GetWM and IsValid(self:GetWM()) and self == ply.pullingTowardsWeapon then
                        ply.pullingTowardsCallback(self)
                        ply.pullingTowardsCallback = nil
                    end

                    ply.pullingTowards = nil
                    ply.pullingTowardsStart = nil
                    ply.pullingTowardsTime = nil
                    ply.pullingTowardsWeapon = nil

                    if IsValid(ply.pullingTowardsModel) then
                        ply.pullingTowardsModel:Remove()
                    end

                    ply.pullingTowardsModel = nil
                    ply.pullingTowardsOffsets = nil
                else
                    lerp = math.ease.InOutSine(1 - math.abs(((ply.pullingTowardsStart + ply.pullingTowardsTime - CurTime()) / ply.pullingTowardsTime) * 2 - 1))
                    
                    local ang = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Spine2")):GetAngles()
                    ang:RotateAroundAxis(ang:Right(), -90)
                    ang:RotateAroundAxis(ang:Up(), 90)
                    ang:RotateAroundAxis(ang:Right(), -30)

                    ply_l_hand_matrix:SetTranslation(LerpVector(lerp, ply_l_hand_matrix:GetTranslation(), (ent:GetBoneMatrix(ent:LookupBone(ply.pullingTowards)):GetTranslation() + ent:GetBoneMatrix(ent:LookupBone(ply.pullingTowards)):GetAngles():Right() * -4 + ent:GetBoneMatrix(ent:LookupBone(ply.pullingTowards)):GetAngles():Up() * 5) or pos))
                    ply_l_hand_matrix:SetAngles(LerpAngle(math.min(lerp * 2,1), ply_l_hand_matrix:GetAngles(), ang))

                    if ((((ply.pullingTowardsStart + ply.pullingTowardsTime - CurTime()) / ply.pullingTowardsTime) * 2 - 1) < 0) then// || ply.pullingMagNow then
                        if IsValid(ply.pullingTowardsModel) and ply.pullingTowardsOffsets then
                            local pos2, ang2 = LocalToWorld(ply.pullingTowardsOffsets[1], ply.pullingTowardsOffsets[2], ply_l_hand_matrix:GetTranslation(), ply_l_hand_matrix:GetAngles())
                            local lerp = math.max(((((1 - (ply.pullingTowardsStart + ply.pullingTowardsTime - CurTime()) / ply.pullingTowardsTime)) - 0.5) * 2 - 0.6) / 0.4,0)
                            
                            local pos1, ang1 = LocalToWorld(ply.pullingTowardsOffsets[4], ply.pullingTowardsOffsets[5], self:GetWM():GetBoneMatrix(ply.pullingTowardsOffsets[3]):GetTranslation(), self:GetWM():GetBoneMatrix(ply.pullingTowardsOffsets[3]):GetAngles())
                            ang1:RotateAroundAxis(ang1:Up(),-90)
                            
                            local pos = LerpVector(lerp, pos2, pos1)
                            local ang = LerpAngle(lerp, ang2, ang1)
                            
                            ply.pullingTowardsModel:SetPos(pos)
                            ply.pullingTowardsModel:SetAngles(ang)
                            ply.pullingTowardsModel:DrawModel()
                        end
                    end
                end
            end
        end
    else
        local lpos, _ = WorldToLocal(ply_l_hand_matrix:GetTranslation(), angle_zero, eyepos, eyeang)
        ply.last_lh_pos2 = lpos

        if ply.last_lh_pos then
            local pos, _ = LocalToWorld(ply.last_lh_pos, angle_zero, eyepos, eyeang)
            ply_l_hand_matrix:SetTranslation(LerpVector(ply.lerp_lh, pos, ply_l_hand_matrix:GetTranslation()))
        end
    end

    if IsValid(self.niggamodel) and developer:GetBool() and LocalPlayer():IsSuperAdmin() and self.lmagpos3 then
        local hand = ply_l_hand_matrix
        local pos, ang = LocalToWorld(self.lmagpos3, self.lmagang3, hand:GetTranslation(), hand:GetAngles())
        self.niggamodel:SetPos(pos)
        self.niggamodel:SetAngles(ang)
        self.niggamodel:SetupBones()
        self.niggamodel:DrawModel()
    end

    local l_arm_startingpos = ply_l_upperarm_matrix:GetTranslation()
    
    local offset = vector_origin
    local l_arm_endpos = ply_l_hand_matrix:GetTranslation() + offset

    
    if shouldfullupdate or !ply.ply_l_upperarm_pos then
        ply_l_upperarm_pos, ply_l_forearm_pos, ply_l_upperarm_angle, ply_l_forearm_angle = hg.Solve2PartIK(l_arm_startingpos, l_arm_endpos, l_upperarm_length, l_forearm_length, ply_l_upperarm_matrix, ply_l_forearm_matrix, 1, ply_spine_matrix, ply:GetAimVector():Angle(), ply_l_hand_matrix:GetAngles())

        ply.ply_l_upperarm_pos, ply.ply_l_upperarm_angle = WorldToLocal(ply_l_upperarm_pos, ply_l_upperarm_angle, headpos, eyeang)
        ply.ply_l_forearm_pos, ply.ply_l_forearm_angle = WorldToLocal(ply_l_forearm_pos, ply_l_forearm_angle, headpos, eyeang)
    else
        ply_l_upperarm_pos, ply_l_upperarm_angle = LocalToWorld(ply.ply_l_upperarm_pos, ply.ply_l_upperarm_angle, headpos, eyeang)
        ply_l_forearm_pos, ply_l_forearm_angle = LocalToWorld(ply.ply_l_forearm_pos, ply.ply_l_forearm_angle, headpos, eyeang)
    end

    local ply_l_forearm_angle = ply_l_forearm_angle
    local ply_l_upperarm_angle = ply_l_upperarm_angle

    ply_l_upperarm_matrix:SetAngles(ply_l_upperarm_angle)
    ply_l_forearm_matrix:SetAngles(ply_l_forearm_angle)
    ply_l_forearm_matrix:SetTranslation(ply_l_upperarm_pos)
    //debugoverlay.Line(l_arm_startingpos, ply_l_upperarm_pos, 1, color_white)
    //debugoverlay.Line(ply_l_upperarm_pos, ply_l_forearm_pos, 1, color_white)
    if lhik then
        hg.bone_apply_matrix(ent, ply_l_upperarm_index, ply_l_upperarm_matrix, ply_l_forearm_index)
        
        //ply_l_forearm_matrix:SetTranslation(ent:GetBoneMatrix(ply_l_forearm_index):GetTranslation())
        hg.bone_apply_matrix(ent, ply_l_forearm_index, ply_l_forearm_matrix, ply_l_hand_index)
        ply_l_hand_matrix:SetTranslation(ply_l_forearm_pos - offset)
        hg.bone_apply_matrix(ent, ply_l_hand_index, ply_l_hand_matrix)
    end
    
    self.lhandik = true
    self.rhandik = true
end

local cached_huy = {}

local hg_coolgloves = ConVarExists("hg_coolgloves") and GetConVar("hg_coolgloves") or CreateClientConVar("hg_coolgloves", 0, true, false, "Enable cool gloves (only firstperson)", 0, 1)

local niggabones = {
    ["ValveBiped.Bip01_R_Finger4"] = "ValveBiped.Bip01_R_Finger2",
    ["ValveBiped.Bip01_R_Finger41"] = "ValveBiped.Bip01_R_Finger21",
    ["ValveBiped.Bip01_R_Finger42"] = "ValveBiped.Bip01_R_Finger22",
    ["ValveBiped.Bip01_R_Finger3"] = "ValveBiped.Bip01_R_Finger2",
    ["ValveBiped.Bip01_R_Finger31"] = "ValveBiped.Bip01_R_Finger21",
    ["ValveBiped.Bip01_R_Finger32"] = "ValveBiped.Bip01_R_Finger22",
    ["ValveBiped.Bip01_L_Finger4"] = "ValveBiped.Bip01_L_Finger2",
    ["ValveBiped.Bip01_L_Finger41"] = "ValveBiped.Bip01_L_Finger21",
    ["ValveBiped.Bip01_L_Finger42"] = "ValveBiped.Bip01_L_Finger22",
    ["ValveBiped.Bip01_L_Finger3"] = "ValveBiped.Bip01_L_Finger2",
    ["ValveBiped.Bip01_L_Finger31"] = "ValveBiped.Bip01_L_Finger21",
    ["ValveBiped.Bip01_L_Finger32"] = "ValveBiped.Bip01_L_Finger22",
}

local vector_small = Vector(0,0,0)
local vector_small2 = Vector(0.1,0.1,0.1) / 1

--hook.Add("PostDrawPlayerRagdoll", "!!!!!!!zcity_PostDrawPlayerRagdollmain", function(ent, ply)
function hg.MainTPIKFunction(ent, ply, wpn)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    
    //local systime = SysTime()
    local should = hg.ShouldTPIK(ply,wpn)
    //print("shouldtpik func: ", SysTime() - systime)

    if should then
        if ent != ply then
            ent:SetupBones()
        end
        //local systime = SysTime()
        if wpn.SetHandPos then
            wpn:SetHandPos()
        end
        //print("sethandpos: ", SysTime() - systime)

        //if ply:InVehicle() then
            //local self = ply:GetActiveWeapon()
            //hg.DragHandsToPos(ent,self,ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_L_Hand")):GetTranslation(),false,0,vector_up,angle_zero,ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_L_Hand")):GetAngles())
            //ply.lerp_lh = 1
        //end

        //local systime = SysTime()
        //hg.FlashlightPos(ply)
        //print("FlashlightPos: ", SysTime() - systime)

        //local systime = SysTime()
        //if IsValid(wpn) and (wpn:GetClass() ~= "weapon_hands_sh") and IsValid(ply:GetNetVar("carryent2")) then
        //    hg.DragHands(ply,wpn)
        //end
        //print("DragHands: ", SysTime() - systime)

        //local systime = SysTime()
        hg.DoTPIK(ply,ent)
        //print("DoTPIK: ", SysTime() - systime)
    end
end

function hg.Solve2PartIK(start_p, end_p, length0, length1, mat0, mat1, sign, torsomat, angs, ang)
    local length2 = (start_p - end_p):Length()

    if length0 + length1 < length2 then
        local add = length2 - length1 - length0
        --length0 = length0 + add * length0 / (length2 - add)
        --length1 = length1 + add * length1 / (length2 - add)
    end

    local prev_ang0 = Quaternion():SetMatrix(mat0)
    local prev_ang1 = Quaternion():SetMatrix(mat1)

    local cosAngle0 = math.Clamp(((length2 * length2) + (length0 * length0) - (length1 * length1)) / (2 * length2 * length0), -1, 1)
    local angle0 = -math.deg(math.acos(cosAngle0))
    local cosAngle1 = math.Clamp(((length1 * length1) + (length0 * length0) - (length2 * length2)) / (2 * length1 * length0), -1, 1)
    local angle1 = -math.deg(math.acos(cosAngle1))
    local diff = end_p - start_p-- + LocalPlayer():EyeAngles():Forward() * 555
    diff:Normalize()
    local angle2 = math.deg(math.atan2(-math.sqrt(diff.x * diff.x + diff.y * diff.y), diff.z)) - 90
    local angle3 = -math.deg(math.atan2(diff.x, diff.y)) - 90
    angle3 = math.NormalizeAngle(angle3)

    local diff2 = -torsomat:GetAngles():Forward()
    --debugoverlay.Line(start_p,start_p + diff2 * 10,0.1,color_white,true)
    --debugoverlay.Line(start_p,start_p + diff * 10,0.1,color_red,true)
    local axis = diff * 1
    axis:Normalize()
    
    local torsoang = torsomat:GetAngles()

    local Joint0 = Angle(angle0 + angle2, angle3, 0)

    local asdot = -vector_up:Dot(torsoang:Up())
    local diffa = math.deg(math.acos(asdot)) + (sign < 0 and -0 or 0)
    local diffa2 = 90 + (sign > 0 and -30 or 30)--math.deg(math.acos(asdot))
    
    local tors = torsoang:Up()
    local torsoright = -math.deg(math.atan2(tors.x, tors.y)) - 120 - 60 * sign
    torsoright = angs.y + 120 * sign
    
    Joint0:RotateAroundAxis(Joint0:Forward(), diffa2)
    Joint0:RotateAroundAxis(axis, angle3 - torsoright)
    prev_ang0:SetAngle(Joint0)

    --debugoverlay.Line(start_p,start_p + -diff:Angle():Up() * 10,0.1,color_black,true)
    --debugoverlay.Line(start_p,start_p + torsoang:Up() * sign * 10,0.1,color_red,true)
    
    --render.DrawLine(start_p,start_p + -diff:Angle():Up() * 10,color_black, true)
    --render.DrawLine(start_p,start_p + torsoang:Up() * sign * 10,color_red, true)

    local Joint0 = prev_ang0:Angle():Forward() * length0
    //local diffa2 = ang[3] + 90

    local Joint1 = Angle(angle0 + angle2 + 180 + angle1, angle3, 0)
    Joint1:RotateAroundAxis(Joint1:Forward(), diffa2)//+ ang[3] / 4 + 60)
    Joint1:RotateAroundAxis(axis, angle3 - torsoright)
    prev_ang1:SetAngle(Joint1)
    --prev_ang1:SetDirection(Joint1:Forward(), torsomat:GetAngles():Up() * 1)
    
    local Joint1 = prev_ang1:Angle():Forward() * length1

    local Joint0_F = start_p + Joint0
    local Joint1_F = Joint0_F + Joint1

    return Joint0_F, Joint1_F, prev_ang0:Angle(), prev_ang1:Angle()
end

local vecZero,angZero = Vector(0,0,0),Angle(0,0,0)
local vec1 = Vector(0, 2, 0)
local vec2 = Vector(0, -2, 0)
local ang1 = Angle(-0,25,0)
local ang2 = Angle(-0,-25,180)

function hg.DragHands(ply,self)
    if not IsValid(ply) then return end
    	
    local ply_spine_index = ply:LookupBone("ValveBiped.Bip01_Spine4")
    if !ply_spine_index then return end
    local ply_spine_matrix = ply:GetBoneMatrix(ply_spine_index)
    local wmpos = ply_spine_matrix:GetTranslation()

    local eyetr = hg.eyeTrace(ply)

	local ent = IsValid(ply:GetNetVar("carryent")) and ply:GetNetVar("carryent") or IsValid(ply:GetNetVar("carryent2")) and ply:GetNetVar("carryent2")
	local pos = IsValid(ent) and ent:GetPos() or false
	local bon = ply:GetNetVar("carrybone",0) ~= 0 and ply:GetNetVar("carrybone",0) or ply:GetNetVar("carrybone2",0)
	local lpos = IsValid(ent) and ply:GetNetVar("carrypos",nil) or ply:GetNetVar("carrypos2",nil)
	--local twohands = (ply:GetNetVar("carrymass",0) ~= 0 and ply:GetNetVar("carrymass",0) or ply:GetNetVar("carrymass2",0)) > 15
	local twohands = ply:GetNetVar("carrymass",0) > 15 or (!hg.CanUseLeftHand(ply) and ply:GetActiveWeapon():GetClass() == "weapon_hands_sh")
	
	local norm
    local dist

    local TraceResult
    if IsValid(ent) then
		local bone = ent:TranslatePhysBoneToBone(bon)
		local wanted_pos = bone and ent:GetBoneMatrix(bone) or ent:GetPos()

        if lpos then
            if not ent:IsRagdoll()then
                wanted_pos = ent:LocalToWorld(lpos)
            elseif ismatrix(wanted_pos) then
                wanted_pos = LocalToWorld(lpos, angle_zero, wanted_pos:GetTranslation(), wanted_pos:GetAngles())
            end
        end
        dist = wanted_pos:Distance(ply_spine_matrix:GetTranslation())

		local start = ply_spine_matrix:GetTranslation()
		local len = (wanted_pos - start):Length()
		len = math.min(len,40)
        local tr = {}

		tr.start = start
		tr.endpos = start + (wanted_pos - start):GetNormalized() * len
		tr.filter = ply
		TraceResult = util.TraceLine(tr)
		pos = TraceResult.HitPos - TraceResult.Normal * 4
		norm = wanted_pos - ply:EyePos()
	end

	local rh,lh = ply:LookupBone("ValveBiped.Bip01_R_Hand"), ply:LookupBone("ValveBiped.Bip01_L_Hand")
	local rhmat,lhmat = ply:GetBoneMatrix(rh),ply:GetBoneMatrix(lh)
    
	if pos then
        local dot = (pos - ply_spine_matrix:GetTranslation()):GetNormalized():Dot(eyetr.Normal:Angle():Right())
        
        --hg.bone.Set(ply, "spine", vector_origin, Angle(0, 0, -dot * 25), "holding")
        --hg.bone.Set(ply, "spine2", vector_origin, Angle(0, 0, -dot * 25), "holding")
        --hg.bone.Set(ply, "head", vector_origin, -Angle(0, 0, -dot * 50), "holding2")
        --надо тогда и на сервере делать, а то будет различаться

        --local matang = ply_spine_matrix:GetAngles()
        --matang[2] = matang[2] - dot * 40
        --ply_spine_matrix:SetAngles(matang)
        --hg.bone_apply_matrix(ply, ply_spine_index, ply_spine_matrix)

        if twohands then

            local oldpos = rhmat:GetTranslation()
            --pos = pos + LerpFT(0.01,ply.oldposrh or (pos - oldpos),pos - oldpos)
            pos.x = math.Clamp(pos.x, oldpos.x - 38, oldpos.x + 38)
            pos.y = math.Clamp(pos.y, oldpos.y - 38, oldpos.y + 38)
            pos.z = math.Clamp(pos.z, oldpos.z - 38, oldpos.z + 38)

            rhmat:SetTranslation(pos)

            if norm then
                --local min, max = ent:GetModelBounds()
                --local len = max:Distance(min)
                --local tr = util.TraceLine({start = ent:GetPos() + -TraceResult.HitNormal:Angle():Right() * (len), endpos = ent:GetPos() + -TraceResult.HitNormal:Angle():Right() * (len) + TraceResult.HitNormal:Angle():Right() * len, filter = {ply, Entity(0)}})
                --local pos = tr.HitPos
                local pos,newang = LocalToWorld(vec2,ang2,pos,norm:Angle())
                rhmat:SetTranslation(pos)
                rhmat:SetAngles(newang)
            end

            hg.bone_apply_matrix(ply,rh,rhmat)
            
            ply.oldposrh = pos - oldpos
            self.rhandik = true
        end

        local oldpos = lhmat:GetTranslation()
        pos.x = math.Clamp(pos.x, oldpos.x - 38, oldpos.x + 38)
        pos.y = math.Clamp(pos.y, oldpos.y - 38, oldpos.y + 38)
        pos.z = math.Clamp(pos.z, oldpos.z - 38, oldpos.z + 38)

        if norm then
            local pos,newang = LocalToWorld(twohands and vec1 or vector_origin,ang1,pos,norm:Angle())
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

local meta = FindMetaTable("Entity")
function meta:PullLHTowards(towards, timetopull, mdl, offsets, callback)
    local ply = hg.RagdollOwner(self) or self
    if towards == nil then
        ply.pullingTowards = nil
        ply.pullingTowardsStart = nil
        ply.pullingTowardsTime = nil
        ply.pullingTowardsWeapon = nil

        if IsValid(ply.pullingTowardsModel) then
            ply.pullingTowardsModel:Remove()
        end

        //ply.pullingMagNow = nil
        ply.pullingTowardsModel = nil
        ply.pullingTowardsOffsets = nil

        return
    end

    //ply.pullingMagNow = magNOW
    ply.pullingTowards = towards
    ply.pullingTowardsStart = CurTime()
    ply.pullingTowardsTime = timetopull
    ply.pullingTowardsWeapon = (ply.GetActiveWeapon and ply:GetActiveWeapon() or NULL)
    ply.pullingTowardsCallback = callback
    if mdl then
        ply.pullingTowardsModel = ClientsideModel(mdl,RENDERGROUP_OPAQUE)
        if IsValid(ply.pullingTowardsModel) then
            ply.pullingTowardsModel:SetNoDraw(true)
        end
        ply.pullingTowardsOffsets = offsets
        //ply.pullingTowardsModel:SetPos(self:GetPos())
    end
end

hook.Add("Player Think","HachiTrukachi",function(ply)
    hg.MainTPIKFunction(hg.GetCurrentCharacter(ply),ply,ply:GetActiveWeapon())
end)