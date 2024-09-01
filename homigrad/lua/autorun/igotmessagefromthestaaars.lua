if SERVER then
    AddCSLuaFile()
end

if CLIENT then
    local runAnimSequence = "ACT_HL2MP_RUN_FAST"

    hook.Add("Think", "CustomRunAnimation", function()
        local ply = LocalPlayer()

        if ply:KeyDown(IN_FORWARD) and ply:KeyDown(IN_SPEED) and ply:GetActiveWeapon():GetClass() == "weapon_hands" or not ply:GetActiveWeapon() then
            if ply:IsOnGround() and ply:Alive() then
                local animSequence = ply:LookupSequence(runAnimSequence)

                ply:SetSequence(animSequence)

                ply:SetPlaybackRate(1)
            end
        else
            ply:SetPlaybackRate(1)
        end
    end)
end
