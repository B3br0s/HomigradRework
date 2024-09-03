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

local ATTInformation = {
    
}

hook.Add("PostDrawOpaqueRenderables", "Holosightes", function()
    local ply = LocalPlayer()
    local weapon = ply:GetActiveWeapon()
    if not IsValid(weapon) or not weapon.ActivitySight then return end
    local sight = weapon.ActivitySight
    local infoatt = ATTInformation[weapon:GetClass()][sight]
    local sightsam = weapon.AttachmentsOBJ[sight]
    local material = Material(infoatt.ReticleMaterial, "noclamp nocull smooth")
    local correctpos = IsValid(weapon.WModel) and weapon.WModel or weapon
    render.UpdateScreenEffectTexture()
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_REPLACE)
    render.SetStencilWriteMask(255)
    render.SetStencilTestMask(255)

    render.SetBlend(0)

    render.SetStencilReferenceValue(1)

    sightsam:DrawModel()
    
    render.SetBlend(1)

    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilCompareFunction(STENCIL_EQUAL)

	render.DepthRange(0.993, 0)
	render.SetMaterial(material or Material("empty"))
    local size = weapon:GetNWFloat("ReticleSize")
    local attachment = correctpos:GetAttachment(1)
    if not attachment then return end
	local pos = attachment.Pos
	local ang = sightsam:GetAngles()
	ang:RotateAroundAxis(ang:Right(), weapon:GetNWFloat("AngleRightAxis", 0))
    local up = ang:Up()
    local right = ang:Right()
    local forward = ang:Forward()
    pos = pos + forward * 100 + up * weapon:GetNWInt("ReticlePosUp", 0) + right * weapon:GetNWInt("ReticlePosRight", 0)
	local xr, yr = pos:ToScreen().x, pos:ToScreen().y
	local lighted = size + 0.7
	render.DrawQuad(
	    	pos + (up * lighted / 2) - (right * lighted / 2),
	    	pos + (up * lighted / 2) + (right * lighted / 2),
        	pos - (up * lighted / 2) + (right * lighted / 2),
        	pos - (up * lighted / 2) - (right * lighted / 2),
    	Color(162,165,165)
    )
    render.DrawQuad(
        	pos + (up * size / 2) - (right * size / 2),
        	pos + (up * size / 2) + (right * size / 2),
        	pos - (up * size / 2) + (right * size / 2),
        	pos - (up * size / 2) - (right * size / 2),
        standart
    )
	render.DepthRange(0, 1)
    render.SetStencilEnable(false)
end)