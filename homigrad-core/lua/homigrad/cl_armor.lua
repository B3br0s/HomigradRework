hook.Add("InitArmor_CL","ArmorInit",function(ply)
    ply.armor_render = ply.armor_render or {}
    ply.armor = ply.armor or {}
end)

net.Receive("armor_sosal",function()
    local ent = net.ReadEntity()
    local arm = net.ReadTable()

    ent.armor = arm
end)

hook.Add("PostDrawOpaqueRenderables","Armor_Render",function()
        for _, ply in ipairs(player.GetAll()) do
            if !ply.armor then
                continue 
            end
            if !ply:Alive() then
                for placement, armor in pairs(ply.armor) do
                    if ply.armor_render[placement] != nil then
                        ply.armor_render[placement]:Remove()
                        ply.armor_render[placement] = nil
                    end
                end
                
                continue
            end
        
            local armor_torso = ply.armor.torso
            local armor_head = ply.armor.head
            local armor_face = ply.armor.face
            local armor_back = ply.armor.back
        
            local ent = hg.GetCurrentCharacter(ply)
        
            ply.armor_render = ply.armor_render or {}
        
            for placement, armor in pairs(ply.armor) do
                local tbl = hg.Armors[armor]
                if tbl != nil then
                    if ply.armor_render[placement] == nil then
                        ply.armor_render[placement] = ClientsideModel(tbl.Model)
                        table.insert(hg.csm,ply.armor_render[placement])
                    end
                
                    if ply.armor_render[placement]:GetModel() != tbl.Model then
                        ply.armor_render[placement]:Remove()
                        ply.armor_render[placement] = nil
                    end
                
                    if ply.armor_render[placement] == nil then
                        continue 
                    end
                
                    if tbl.NoDraw and GetViewEntity() == ply then
                        ply.armor_render[placement]:SetNoDraw(true)
                        continue 
                    elseif tbl.NoDraw and GetViewEntity() != ply then
                        ply.armor_render[placement]:SetNoDraw(false)
                    end
                
                    ply.armor_render[placement]:SetModelScale(tbl.Scale or 1,0)
                
                    ply.armor_render[placement]:SetBodygroup(0,1)
                
                    if ent == NULL then
                        continue 
                    end
                
                    local pos,ang = ent:GetBonePosition(ent:LookupBone(tbl.Bone))
                
                    ang:RotateAroundAxis(ang:Forward(),tbl.Ang[1])
                    ang:RotateAroundAxis(ang:Up(),tbl.Ang[2])
                    ang:RotateAroundAxis(ang:Right(),tbl.Ang[3])
                
                    pos = pos + ang:Forward() * tbl.Pos[1]
                    pos = pos + ang:Right() * tbl.Pos[2]
                    pos = pos + ang:Up() * tbl.Pos[3]
                
                    ply:SetPredictable(true)
                    ply:SetupBones()
                
                    ply.armor_render[placement]:SetParent(ent)
                
                    ply.armor_render[placement]:SetRenderOrigin(pos)
                    ply.armor_render[placement]:SetRenderAngles(ang)
                
                    ply.armor_render[placement]:SetPos(pos)
                    ply.armor_render[placement]:SetAngles(ang)
                
                    ply.armor_render[placement]:SetPredictable(true)
                    ply.armor_render[placement]:SetupBones()
                
                    //ply.armor_render[placement]:DrawModel()
                else
                    if ply.armor_render[placement] != nil then
                        ply.armor_render[placement]:Remove()
                        ply.armor_render[placement] = nil
                    end
                end
            end
        end
end)

hook.Add("HUDPaint","Armor_Overlay",function()
    local ply = LocalPlayer()

    if !ply:Alive() then
        return
    end

    if GetViewEntity() != ply then
        return
    end

    local armor_head = ply.armor.head
    local armor_face = ply.armor.face

    local tbl_head = hg.Armors[armor_head]
    local tbl_face = hg.Armors[armor_face]

    if tbl_face != nil and tbl_face.Overlay != nil then
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(Material(tbl_face.Overlay))
        surface.DrawTexturedRect(0,0,ScrW(),ScrH())
    end

    if tbl_head != nil and tbl_head.Overlay != nil then
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(Material(tbl_head.Overlay))
        surface.DrawTexturedRect(0,0,ScrW(),ScrH())
    end
end)