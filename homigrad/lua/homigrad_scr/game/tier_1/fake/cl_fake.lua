-- Make sure the script waits until everything is fully loaded
hook.Add("Initialize", "CheckGamemode", function()
    if engine.ActiveGamemode() == "homigrad" then
        -- Now everything is loaded, we can proceed safely

        local iconKA1337 = Material("icon32/hand_point_090") -- Load the material once
        local drawIcon = false
        local pos = Vector(0, 0, 0) -- Default vector

        -- Net receiver
        net.Receive("RightHandInDICKator", function()
            pos = net.ReadVector() -- Update the position
            local isenabled = net.ReadBool() -- Receive the enable/disable flag

            if isenabled then
                drawIcon = true
            else
                drawIcon = false
            end

            -- Debug print to ensure position and enable flag are correct
            print("Received Position: ", pos)
            print("Is Enabled: ", isenabled)
        end)

        -- Hook to draw the icon on the screen
        hook.Add("HUDPaint", "DrawRightHandIndicator", function()
            if drawIcon then
                -- Make sure the position is valid
                if pos then
                    local screenPos = pos:ToScreen() -- Convert world position to 2D screen coordinates

                    -- Check if the position is within screen bounds
                    if screenPos.visible then
                        surface.SetDrawColor(255, 255, 255, 255) -- Set icon color (white)
                        surface.SetMaterial(iconKA1337) -- Set the material to the icon texture
                        surface.DrawTexturedRect(screenPos.x - 16, screenPos.y - 16, 32, 32) -- Draw the icon (32x32 pixels, centered)
                    else
                        print("Position not visible on screen")
                    end
                end
            end
        end)
    end
end)
