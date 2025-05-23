hook.Add("InitArmor_CL","ArmorInit",function(ply)
    ply.armor_render = ply.armor_render or {}
    ply.armor = ply.armor or {}

    ply:SetNWBool("otrub",false)
    ply:SetNWFloat("pain",0)
end)

//net.Receive("armor_sosal",function()
//    local ent = net.ReadEntity()
//    local arm = net.ReadTable()
//
//    ent.armor = arm
//end)

hook.Add("PostDrawOpaqueRenderables","FixShit",function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetNWBool("Fake") then
            hook.Run("PostDrawPlayerRagdoll",ply,hg.GetCurrentCharacter(ply))
        end
    end
end)

hook.Add("PrePlayerDraw","DrawArmor",function(ply)
    hook.Run("PostDrawPlayerRagdoll",ply,hg.GetCurrentCharacter(ply))
end)

function hg.RenderArmor(ply)
    local ent = hg.GetCurrentCharacter(ply)
    if !ply.armor then
        return  
    end

    ply.armor = ply:GetNetVar("Armor")
    if !ply:Alive() then
        for placement, armor in pairs(ply.armor) do
            if ply.armor_render[placement] != nil then
                ply.armor_render[placement]:Remove()
                ply.armor_render[placement] = nil
            end
        end
        
        return 
    end

    local armor_torso = ply.armor.torso
    local armor_head = ply.armor.head
    local armor_face = ply.armor.face
    local armor_back = ply.armor.back

    ply.armor_render = ply.armor_render or {}

    for placement, armor in pairs(ply.armor) do
        local tbl = hg.Armors[armor]
        if tbl != nil then
            if ply.armor_render[placement] == nil then
                ply.armor_render[placement] = ClientsideModel(tbl.Model,RENDERMODE_NORMAL)
                ply.armor_render[placement]:SetNotSolid(true)
                ply.armor_render[placement]:SetNWBool("nophys", true)
                ply.armor_render[placement]:SetSolidFlags(FSOLID_NOT_SOLID)
                ply.armor_render[placement]:AddEFlags(EFL_NO_DISSOLVE)
                ply.armor_render[placement]:AddEffects(EF_BONEMERGE)
                table.insert(hg.csm,ply.armor_render[placement])
            end
        
            if ply.armor_render[placement]:GetModel() != tbl.Model then
                ply.armor_render[placement]:Remove()
                ply.armor_render[placement] = nil
            end
        
            if ply.armor_render[placement] == nil then
                continue 
            end
            
            ply.armor_render[placement].NoRender = ply.armor_render[placement]:GetNoDraw()
        
            if tbl.NoDraw and GetViewEntity() == ply then
                ply.armor_render[placement]:SetNoDraw(true)
                ply.armor_render[placement].NoRender = true
                continue 
            elseif tbl.NoDraw and GetViewEntity() != ply then
                //ply.armor_render[placement]:SetNoDraw(false)
                ply.armor_render[placement].NoRender = false
            end
        
            ply.armor_render[placement]:SetModelScale(((hg.IsFemale(ent) and tbl.FemScale) and tbl.FemScale or tbl.Scale) or 1,0)
        
            ply.armor_render[placement]:SetBodygroup(0,1)
        
            if ent == NULL then
                continue 
            end
        
            local pos,ang = ent:GetBonePosition(ent:LookupBone(tbl.Bone))
        
            ang:RotateAroundAxis(ang:Forward(),tbl.Ang[1])
            ang:RotateAroundAxis(ang:Up(),tbl.Ang[2])
            ang:RotateAroundAxis(ang:Right(),tbl.Ang[3])
        
            if !hg.IsFemale(ent) or !tbl.FemPos then
                pos = pos + ang:Forward() * tbl.Pos[1]
                pos = pos + ang:Right() * tbl.Pos[2]
                pos = pos + ang:Up() * tbl.Pos[3]
            else
                pos = pos + ang:Forward() * tbl.FemPos[1]
                pos = pos + ang:Right() * tbl.FemPos[2]
                pos = pos + ang:Up() * tbl.FemPos[3]
            end
        
            //ply.armor_render[placement]:SetParent(ent)
        
            ply.armor_render[placement]:SetRenderOrigin(pos)
            ply.armor_render[placement]:SetRenderAngles(ang)
        
            ply.armor_render[placement]:SetPos(pos)
            ply.armor_render[placement]:SetAngles(ang)
        
            //ply.armor_render[placement]:DrawModel()
        else
            if ply.armor_render[placement] != nil then
                ply.armor_render[placement]:Remove()
                ply.armor_render[placement] = nil
            end
        end
    end
end

hook.Add("HUDPaint","Armor_Overlay",function()
    local ply = LocalPlayer()

    if !ply:Alive() then
        return
    end

    if GetViewEntity() != ply then
        return
    end

    if !ply.armor then
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