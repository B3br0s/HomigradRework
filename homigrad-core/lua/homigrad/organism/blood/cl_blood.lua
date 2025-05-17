hook.Add("Player Think", "BloodManager", function(ply)
    if not ply:Alive() then return end
    
    ply.bloodnext = ply.bloodnext or 0
    
    if not ply:GetNWBool("bleeding") or ply.bloodnext > CurTime() then 
        return
    end
    
    ply.bloodnext = CurTime() + 0.35
    
    local rag = ply:GetNWEntity("FakeRagdoll")
    
    bp_hit((IsValid(rag) and rag:GetPos() or ply:GetPos()) or ply:GetPos() + Vector(0, 0, 32), Vector(0, 0, -2))
    blood_Bleed((IsValid(rag) and rag:GetPos() or ply:GetPos()) or ply:GetPos() + Vector(0, 0, 32), Vector(0, 0, -2))
end)

hook.Add( "RenderScreenspaceEffects", "Blood_FX", function()

    local ply = LocalPlayer()

    if !ply:Alive() then
        return
    end

    local blood = ply:GetNWFloat("blood")

    local frac = math.Clamp(1 - (blood - 3200) / ((5000 - 1400) - 1800), 0, 1)

    if !ply:GetNWBool("otrub") then
	    DrawToyTown(frac * 13, ScrH() * (frac * 1.5))
    end

    //print(frac * 13)
    //print(blood)
end )

hook.Add("Think","RagdollBlood",function()
    for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do
        if IsValid(ent) and ent:IsRagdoll() then
            if ent.blood and ent.blood <= 0 then
                continue 
            end
            if !ent.LastBleed then
                ent.LastBleed = 0
            end
            if ent.LastBleed > CurTime() then
                continue 
            end
            if ent.LastBleed < CurTime() then
                ent.LastBleed = CurTime() + 0.1
            end
            if !ent.blood then
                ent.blood = 5000
            end
            if ent:GetNWBool("NoHead") then
                ent.blood = math.Clamp(ent.blood - math.random(1,5),0,5000)
                local zalupa_ragdolla = ent:LookupBone("ValveBiped.Bip01_Neck1")
                if zalupa_ragdolla then
                    local head = ent:GetBoneMatrix(zalupa_ragdolla)

                    if !head then
                        continue 
                    end

                    blood_BleedArtery(head:GetTranslation(),(head:GetAngles() + AngleRand(-15,15)):Forward() * math.random(150,250) * (ent.blood / 5000))
                end
            end
            if ent:GetNWBool("NoLLeg") then
                ent.blood = math.Clamp(ent.blood - math.random(1,3),0,5000)
                local zalupa_ragdolla = ent:LookupBone("ValveBiped.Bip01_Pelvis")
                if zalupa_ragdolla then
                    local head = ent:GetBoneMatrix(zalupa_ragdolla)

                    if !head then
                        continue 
                    end

                    blood_BleedArtery(head:GetTranslation(),(head:GetAngles() + AngleRand(-15,15)):Right() * math.random(150,250) * (ent.blood / 5000))
                end
            end
            if ent:GetNWBool("NoRLeg") then
                ent.blood = math.Clamp(ent.blood - math.random(1,3),0,5000)
                local zalupa_ragdolla = ent:LookupBone("ValveBiped.Bip01_Pelvis")
                if zalupa_ragdolla then
                    local head = ent:GetBoneMatrix(zalupa_ragdolla)

                    if !head then
                        continue 
                    end

                    blood_BleedArtery(head:GetTranslation(),(head:GetAngles() + AngleRand(-15,15)):Right() * math.random(150,250) * (ent.blood / 5000))
                end
            end
            if ent:GetNWBool("NoLArm") then
                ent.blood = math.Clamp(ent.blood - math.random(1,3),0,5000)
                local zalupa_ragdolla = ent:LookupBone("ValveBiped.Bip01_L_Clavicle")
                if zalupa_ragdolla then
                    local head = ent:GetBoneMatrix(zalupa_ragdolla)

                    if !head then
                        continue 
                    end

                    blood_BleedArtery(head:GetTranslation(),(head:GetAngles() + AngleRand(-15,15)):Forward() * math.random(150,250) * (ent.blood / 5000))
                end
            end
            if ent:GetNWBool("NoRArm") then
                ent.blood = math.Clamp(ent.blood - math.random(1,3),0,5000)
                local zalupa_ragdolla = ent:LookupBone("ValveBiped.Bip01_R_Clavicle")
                if zalupa_ragdolla then
                    local head = ent:GetBoneMatrix(zalupa_ragdolla)

                    if !head then
                        continue 
                    end

                    blood_BleedArtery(head:GetTranslation(),(head:GetAngles() + AngleRand(-15,15)):Forward() * math.random(150,250) * (ent.blood / 5000))
                end
            end
        end
    end
end)