--[[if SERVER then
    -- Server-Side Code: Enable weapons when sitting in a vehicle
    hook.Add("PlayerEnteredVehicle", "AllowWeaponInVehicle", function(ply, vehicle)
        if vehicle:GetClass() == "prop_vehicle_prisoner_pod" then
            ply:SetAllowWeaponsInVehicle(true)
			ply:DrawWorldModel(true)
        end
    end)

    hook.Add("PlayerLeaveVehicle", "DisableWeaponAfterVehicle", function(ply, vehicle)
        if vehicle:GetClass() == "prop_vehicle_prisoner_pod" then
            ply:SetAllowWeaponsInVehicle(false)
        end
    end)
else
    -- Client-Side Code: Hide viewmodel but show world model while seated
    hook.Add("Think", "HideViewmodelInVehicle", function()
        local ply = LocalPlayer()

        if ply:InVehicle() and ply:GetAllowWeaponsInVehicle() then
            -- Hide the first-person viewmodel
            local vm = ply:GetViewModel()
            if IsValid(vm) then
                vm:SetNoDraw(true) -- Hide the viewmodel (first-person weapon model)
            end
        else
            -- Make sure the viewmodel is shown again after leaving the vehicle
            local vm = ply:GetViewModel()
            if IsValid(vm) then
                vm:SetNoDraw(false) -- Show the viewmodel again
            end
        end
    end)
end
]]