--[[hook.Add("HUDPaint", "ShowSWEPBones", function()
    local ply = LocalPlayer() -- Get the local player
    if not IsValid(ply) then return end

    local weapon = ply:GetActiveWeapon() -- Get the player's active weapon
    if not IsValid(weapon) then return end

    local weaponModel = weapon:GetModel() -- Get the weapon model
    if not weaponModel then return end

    -- Get the weapon model entity
    local vm = ply:GetViewModel()
    if not IsValid(vm) then return end

    -- Loop through all bones
    for boneID = 0, vm:GetBoneCount() - 1 do
        local boneName = vm:GetBoneName(boneID) -- Get bone name
        local bonePos, boneAng = vm:GetBonePosition(boneID) -- Get bone position and angle

        if bonePos then
            -- Convert bone position to 2D screen position
            local screenPos = bonePos:ToScreen()

            draw.SimpleText(boneName, "Trebuchet24", screenPos.x, screenPos.y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            -- Optionally, draw a small circle at the bone's position
            surface.SetDrawColor(255, 0, 0, 255) -- Red color
            surface.DrawRect(screenPos.x - 2, screenPos.y - 2, 4, 4) -- Small rectangle representing the bone
        end
    end
end)]]