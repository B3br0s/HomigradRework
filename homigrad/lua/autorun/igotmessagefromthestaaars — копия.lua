if CLIENT then
    -- Hook into the network message to update animations
    net.Receive("PlayerRunAnimation", function()
        local ply = net.ReadEntity()
        local isRunning = net.ReadBool()

        if not IsValid(ply) or not ply:IsPlayer() then return end

        -- Get the run sequence index for the player's model
        local runSequence = ply:LookupSequence("run_all")  -- Use the correct sequence for running

        if isRunning and runSequence > 0 then
            -- Set the player to the running sequence and loop it
            ply:SetSequence(runSequence)
            ply:SetPlaybackRate(1)  -- Set the speed to normal
        else
            -- Reset the animation to the default idle or walk animation
            ply:ResetSequenceInfo()  -- Resets to the default sequence
            ply:SetCycle(0)          -- Ensures animation starts from the beginning
            ply:SetPlaybackRate(1)   -- Resets playback rate
        end
    end)
end
