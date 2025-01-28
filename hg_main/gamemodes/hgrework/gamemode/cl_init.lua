include("shared.lua")

hook.Add("HUDShouldDraw", "NoHUD", function(name)
    local hideHUDElements = {
        "CHudHealth",
        "CHudBattery",
        "CHudAmmo",
        "CHudSecondaryAmmo",
        "CHudCrosshair",
        "CHudSquadStatus"
    }

    for _, hudElement in ipairs(hideHUDElements) do
        if name == hudElement then
            return false
        end
    end
end)