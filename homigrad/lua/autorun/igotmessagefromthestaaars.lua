if SERVER then
    AddCSLuaFile()
end

if CLIENT then
local enabled = flase

    local runAnimActivity = ACT_HL2MP_RUN_FAST

    hook.Add("Think", "CustomRunAnimation", function()
        local ply = LocalPlayer()

        if not IsValid(ply) or not ply:Alive() or not ply:IsOnGround() then return end

        local activeWeapon = ply:GetActiveWeapon()

        if ply:KeyDown(IN_FORWARD) and ply:KeyDown(IN_SPEED) and (IsValid(activeWeapon) and activeWeapon:GetClass() == "weapon_hands" or not IsValid(activeWeapon)) and enabled then
            if not IsValid(ply:GetNWEntity("Ragdoll")) then
                local animSequence = ply:SelectWeightedSequence(runAnimActivity)
                if animSequence >= 0 then
                    ply:SetSequence(animSequence)
                    ply:SetPlaybackRate(1)
                end
            end
        else
            ply:SetPlaybackRate(1)
        end
    end)
end
