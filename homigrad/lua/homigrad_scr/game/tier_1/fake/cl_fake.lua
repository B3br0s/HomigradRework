if CLIENT then
    local ragdollLeftHandPos = nil
    local ragdollRightHandPos = nil
    local rag = nil
    local obbCenter = nil
    local istrueL = false
    local istrueR = false

    local ICON_SIZE = 60
    local ICON_HALF_SIZE = ICON_SIZE / 2

    local function UpdateRagdoll()
        rag = LocalPlayer():GetNWEntity("Ragdoll")
        if IsValid(rag) then
            obbCenter = rag:OBBCenter()
        else
            obbCenter = nil
        end
    end

    local SMOOTHING_FACTOR = 1

    local function SmoothTransition(currentPos, newPos)
        if currentPos == nil then
            return newPos
        end
        return Lerp(SMOOTHING_FACTOR, currentPos, newPos)
    end

    net.Receive("HandindicatorR", function()
        if not IsValid(rag) then
            UpdateRagdoll()
        end

        if not IsValid(rag) or not obbCenter then
            return
        end
        
        local newPos = --[[rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_R_Hand"))]] net.ReadVector() + obbCenter
        ragdollRightHandPos = SmoothTransition(ragdollRightHandPos, newPos)
        istrueR = net.ReadBool()
    end)

    net.Receive("HandindicatorL", function()
        if not IsValid(rag) then
            UpdateRagdoll()
        end

        if not IsValid(rag) or not obbCenter then
            return
        end
        
        local newPos = --[[rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_L_Hand"))]]net.ReadVector() + obbCenter
        ragdollLeftHandPos = SmoothTransition(ragdollLeftHandPos, newPos)
        istrueL = net.ReadBool()
    end)

    hook.Add("HUDPaint", "DrawRagdollHandLeft", function()
        if LocalPlayer():Alive() and IsValid(LocalPlayer():GetNWEntity("Ragdoll")) then
        if not IsValid(rag) or not obbCenter then
            return
        end
        if istrueL then
            if ragdollLeftHandPos then
                local leftScreenPos = ragdollLeftHandPos:ToScreen()
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.SetMaterial(Material("vgui/iconleft.png"))
                    surface.DrawTexturedRect(leftScreenPos.x, leftScreenPos.y - 60, ICON_SIZE, ICON_SIZE)
            end
        else
            ragdollLeftHandPos = nil
        end
    end
    end)

    hook.Add("HUDPaint", "DrawRagdollHandRight", function()
        if LocalPlayer():Alive() and IsValid(LocalPlayer():GetNWEntity("Ragdoll")) then
        if not IsValid(rag) or not obbCenter then
            return
        end
        if istrueR then
            if ragdollRightHandPos then
                local rightScreenPos = ragdollRightHandPos:ToScreen()
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.SetMaterial(Material("vgui/iconright.png"))
                    surface.DrawTexturedRect(rightScreenPos.x, rightScreenPos.y - 60, ICON_SIZE, ICON_SIZE)
            end
        else
            ragdollRightHandPos = nil
        end
    end
    end)
end
