concommand.Add("getbones", function(ply)
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

            print(boneName)

        end
    end
end)