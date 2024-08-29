local nightVisionEnabled = false
local db = false
local player = LocalPlayer()
-- Toggle night vision with the N key
hook.Add("Think", "NightVisionToggle", function()
    if player.IsSlenderman then
    if input.IsKeyDown(KEY_N) then
        if not nightVisionEnabled then
            if not db then
            timer.Simple(2,function() db = false end )
            db = true
            nightVisionEnabled = true
            end
        else
            if not db then
                timer.Simple(2,function() db = false end )
                db = true
                nightVisionEnabled = false
                end
        end
    end
end
end)

-- Create the light effect when night vision is enabled
hook.Add("Think", "NightVisionLightEffect", function()
    if nightVisionEnabled then
        -- Create dynamic light attached to the player
        local ply = LocalPlayer()
        local light = DynamicLight(ply:EntIndex())
        
        if light then
            light.pos = ply:GetPos() + Vector(0, 0, 50)  -- Position light slightly above player
            light.r = 255
            light.g = 255
            light.b = 255
            light.brightness = 1  -- Adjust brightness here
            light.Size = 14000  -- Large radius to light up a large area
            light.DieTime = CurTime() + 0.05  -- Set the lifetime of the light to update every frame
        end
    end
end)
