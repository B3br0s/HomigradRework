if CLIENT then
    --[[local ICON_SIZE = 100
    local ICON_HALF_SIZE = ICON_SIZE / 2
    local ply = LocalPlayer()
    local rag = nil
    local obbeblo = nil
    local posR,angR = nil,nil
    local posL,angL = nil,nil

    hook.Add("Think", "FakeIndickR",function ()
        if ply:GetNWEntity("Ragdoll") != nil and ply:GetNWBool("fake") then
            rag = ply:GetNWEntity("Ragdoll")
            obbeblo = rag:OBBCenter()
            if ply:KeyDown(IN_WALK) and ply:GetNWBool("HvatR") and ply:GetNWEntity("Ragdoll") != nil then
                posR,angR = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_R_Hand"))
            end
        end
end)
    hook.Add("Think", "FakeIndickL",function ()
        if ply:GetNWEntity("Ragdoll") != nil and ply:GetNWBool("fake") then
            rag = ply:GetNWEntity("Ragdoll")
            obbeblo = rag:OBBCenter()
            if ply:KeyDown(IN_SPEED) and ply:GetNWBool("HvatL") and ply:GetNWEntity("Ragdoll") != nil then
                posL,angL = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_L_Hand"))
            end
        end
    end)
    hook.Add("HUDPaint", "FakeIndickR",function ()
        if ply:KeyDown(IN_WALK) and ply:GetNWBool("HvatR") and posR != nil and ply:GetNWEntity("Ragdoll") != nil and ply:GetNWBool("fake") then
            local RightScreenPos = posR:ToScreen()
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(Material("vgui/iconright.png"))
            surface.DrawTexturedRect(RightScreenPos.x, RightScreenPos.y, ICON_SIZE, ICON_SIZE)
        end
    end)
    hook.Add("HUDPaint", "FakeIndickL",function ()
        if ply:KeyDown(IN_SPEED) and ply:GetNWBool("HvatL") and posL != nil and ply:GetNWEntity("Ragdoll") != nil and ply:GetNWBool("fake") then
            local LeftScreenPos = posL:ToScreen()
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(Material("vgui/iconleft.png"))
            surface.DrawTexturedRect(LeftScreenPos.x, LeftScreenPos.y, ICON_SIZE, ICON_SIZE)
        end
end)]]
end