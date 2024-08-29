local slenderCheckInterval = 0.5  -- Check every 0.5 seconds to reduce performance load
local slenderMaxAngle = 120        -- Maximum angle from the player's view in degrees to apply damage

-- Timer to periodically check if Slenderman is within the player's screen radius
timer.Create("SlendermanCheckTimer", slenderCheckInterval, 0, function()
    local ply = LocalPlayer()
    if not ply:Alive() then return end  -- Don't check if player is dead

    -- Get player's forward direction (the direction they are looking at)
    local plyForward = ply:EyeAngles():Forward()

    -- Loop through all players to check if any are Slenderman
    for _, ent in ipairs(player.GetAll()) do
        if ent != ply and ent:IsValid() and ent:Alive() and ent.IsSlenderman then
            -- Calculate the direction to the Slenderman from the player's eyes
            local directionToSlenderman = (ent:GetPos() - ply:GetPos()):GetNormalized()

            -- Calculate the angle between the player's forward direction and the direction to Slenderman
            local angleDifference = math.deg(math.acos(plyForward:Dot(directionToSlenderman)))

            -- If Slenderman is within the field of view, apply damage
            if angleDifference <= slenderMaxAngle then
                -- Send a message to the server to deal damage to the player
                net.Start("SlenderDamage")
                net.SendToServer()

                -- Optional: play sound or show HUD effect to indicate danger
                surface.PlaySound("ambient/levels/labs/electric_explosion1.wav")  -- Example sound
                break  -- Stop checking once we find a valid Slenderman
            end
        end
    end
end)
