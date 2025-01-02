concommand.Add("getbones", function(ply)
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local weapon = ply:GetActiveWeapon()
    if not IsValid(weapon) then return end

    local weaponModel = weapon:GetModel()
    if not weaponModel then return end

    local vm = ply:GetViewModel()
    if not IsValid(vm) then return end

    for boneID = 0, vm:GetBoneCount() - 1 do
        local boneName = vm:GetBoneName(boneID)
        print(boneName)
    end
end)