if SERVER then
    util.AddNetworkString("SuicideByKnife")

    net.Receive("SuicideByKnife", function(_, ply)
        if not IsValid(ply) or not ply:IsPlayer() then return end

        if ply.HasSuicidedByKnife then return end

        ply.HasSuicidedByKnife = true

        ply.suicidingknife = false

        ply:SetNWBool("Suicidingknife",false)

        local neckBoneID = ply:LookupBone("ValveBiped.Bip01_Neck1")
        if neckBoneID then
            local bonePos = ply:GetBonePosition(neckBoneID)
            local randomAngle = Angle(math.random(360), math.random(360), math.random(360))

            for i = 1, 7 do
                ParticleEffect("exit_blood_small", bonePos, randomAngle)
                ParticleEffect("exit_blood_large", bonePos, randomAngle)
            end

            sound.Play("artery.wav", ply:GetPos())
            sound.Play("weapons/knife/knife_hit3.wav", ply:GetPos())
            ply:TakeDamage(25)
            ply.Organs["artery"] = 0
            ply:ChatPrint("Вы пробили себе артерию.")
        end
    end)

    hook.Add("PlayerSpawn", "ResetSuicideKnifeStatus", function(ply)
        ply.HasSuicidedByKnife = false 
        ply:SetNWBool("Suicidingknife", false)
    end)
end
local suicidetable = { 
    ["weapon_kabar"] = true,
    ["weapon_gurkha"] = true,
    ["weapon_hg_kitknife"] = true,
    ["weapon_knife"] = true,
    ["weapon_t"] = true,
    ["weapon_hg_hatchet"] = true,
    ["weapon_hg_fireaxe"] = true
    }
if CLIENT then
    local boneManipulation = {
        forearm_bone_r = "ValveBiped.Bip01_R_Forearm",
        hand_bone_r = "ValveBiped.Bip01_R_Hand",
        clavicle_bone_r = "ValveBiped.Bip01_R_Clavicle",
        upperarm_bone_r = "ValveBiped.Bip01_R_UpperArm",

        forearm_bone_l = "ValveBiped.Bip01_L_Forearm",
        hand_bone_l = "ValveBiped.Bip01_L_Hand",
        clavicle_bone_l = "ValveBiped.Bip01_L_Clavicle",
        upperarm_bone_l = "ValveBiped.Bip01_L_UpperArm",

        forearm_offset = Vector(0, 0, 0),
        forearm_angle = Angle(-20, -90, 0),
        hand_offset = Vector(0, 0, 0),
        hand_angle = Angle(50, -30, 0),
        clavicle_offset = Vector(0, 0, 0),
        clavicle_angle = Angle(30, 0, 0),
        upperarm_offset = Vector(0, 0, 0),
        upperarm_angle = Angle(0, -10, 0)
    }

    hook.Add("Think", "ModifyArmPositionAndHandleSuicide", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() then return end

        if ply:GetNWBool("Suicidingknife", false) then
            local weapon = ply:GetActiveWeapon()
            if IsValid(weapon) then
                weapon:SetHoldType("normal")
            end

            local forearmID_r = ply:LookupBone(boneManipulation.forearm_bone_r)
            local handID_r = ply:LookupBone(boneManipulation.hand_bone_r)
            local clavicleID_r = ply:LookupBone(boneManipulation.clavicle_bone_r)
            local upperarmID_r = ply:LookupBone(boneManipulation.upperarm_bone_r)
            
            if forearmID_r then
                ply:ManipulateBonePosition(forearmID_r, boneManipulation.forearm_offset)
                ply:ManipulateBoneAngles(forearmID_r, boneManipulation.forearm_angle)
            end
            
            if handID_r then
                ply:ManipulateBonePosition(handID_r, boneManipulation.hand_offset)
                ply:ManipulateBoneAngles(handID_r, boneManipulation.hand_angle)
            end

            if clavicleID_r then
                ply:ManipulateBonePosition(clavicleID_r, boneManipulation.clavicle_offset)
                ply:ManipulateBoneAngles(clavicleID_r, boneManipulation.clavicle_angle)
            end

            if upperarmID_r then
                ply:ManipulateBonePosition(upperarmID_r, boneManipulation.upperarm_offset)
                ply:ManipulateBoneAngles(upperarmID_r, boneManipulation.upperarm_angle)
            end

            local forearmID_l = ply:LookupBone(boneManipulation.forearm_bone_l)
            local handID_l = ply:LookupBone(boneManipulation.hand_bone_l)
            local clavicleID_l = ply:LookupBone(boneManipulation.clavicle_bone_l)
            local upperarmID_l = ply:LookupBone(boneManipulation.upperarm_bone_l)
            
            if forearmID_l then
                ply:ManipulateBonePosition(forearmID_l, Vector(0,0,0))
                ply:ManipulateBoneAngles(forearmID_l, Angle(0,0,0))
            end
            
            if handID_l then
                ply:ManipulateBonePosition(handID_l, Vector(0,0,0))
                ply:ManipulateBoneAngles(handID_l, Angle(0,0,0))
            end

            if clavicleID_l then
                ply:ManipulateBonePosition(clavicleID_l, Vector(0,0,0))
                ply:ManipulateBoneAngles(clavicleID_l, Angle(0,0,0))
            end

            if upperarmID_l then
                ply:ManipulateBonePosition(upperarmID_l, Vector(0,0,0))
                ply:ManipulateBoneAngles(upperarmID_l, Angle(0,0,0))
            end

            if ply:KeyDown(IN_ATTACK) and not ply.HasSuicidedByKnife then
                if suicidetable[ply:GetActiveWeapon():GetClass()] then
                    ply:ConCommand("say *drop")
                    net.Start("SuicideByKnife")
                    net.WriteEntity(ply)
                    net.SendToServer() 
                end
            end
        else
                if not ply:Alive() then return end
                if IsValid(ply:GetActiveWeapon()) then
             if suicidetable[ply:GetActiveWeapon():GetClass()] then
            local forearmID_r = ply:LookupBone(boneManipulation.forearm_bone_r)
            local handID_r = ply:LookupBone(boneManipulation.hand_bone_r)
            local clavicleID_r = ply:LookupBone(boneManipulation.clavicle_bone_r)
            local upperarmID_r = ply:LookupBone(boneManipulation.upperarm_bone_r)
            local weapon = ply:GetActiveWeapon()
            if IsValid(weapon) and weapon.HoldType then
                weapon:SetHoldType(weapon.HoldType)
            end
            if ply:GetActiveWeapon():GetClass() != "weapon_kabar" then
            if forearmID_r then
                ply:ManipulateBonePosition(forearmID_r, Vector(0, 0, 0))
                ply:ManipulateBoneAngles(forearmID_r, Angle(0, 0, 0))
            end
            
            if handID_r then
                ply:ManipulateBonePosition(handID_r, Vector(0, 0, 0))
                ply:ManipulateBoneAngles(handID_r, Angle(0, 0, 0))
            end

            if clavicleID_r then
                ply:ManipulateBonePosition(clavicleID_r, Vector(0, 0, 0))
                ply:ManipulateBoneAngles(clavicleID_r, Angle(0, 0, 0))
            end

            if upperarmID_r then
                ply:ManipulateBonePosition(upperarmID_r, Vector(0, 0, 0))
                ply:ManipulateBoneAngles(upperarmID_r, Angle(0, 0, 0))
            end

            local forearmID_l = ply:LookupBone(boneManipulation.forearm_bone_l)
            local handID_l = ply:LookupBone(boneManipulation.hand_bone_l)
            local clavicleID_l = ply:LookupBone(boneManipulation.clavicle_bone_l)
            local upperarmID_l = ply:LookupBone(boneManipulation.upperarm_bone_l)

            if forearmID_l then
                ply:ManipulateBonePosition(forearmID_l, Vector(0, 0, 0))
                ply:ManipulateBoneAngles(forearmID_l, Angle(0, 0, 0))
            end
            
            if handID_l then
                ply:ManipulateBonePosition(handID_l, Vector(0, 0, 0))
                ply:ManipulateBoneAngles(handID_l, Angle(0, 0, 0))
            end

            if clavicleID_l then
                ply:ManipulateBonePosition(clavicleID_l, Vector(0, 0, 0))
                ply:ManipulateBoneAngles(clavicleID_l, Angle(0, 0, 0))
            end

            if upperarmID_l then
                ply:ManipulateBonePosition(upperarmID_l, Vector(0, 0, 0))
                ply:ManipulateBoneAngles(upperarmID_l, Angle(0, 0, 0))
            end

        end
    end
        end
        end
    end)
end
