hook.Add( "RenderScreenspaceEffects", "Hp_FX", function()

    local ply = LocalPlayer()

    if !ply:Alive() then
        return
    end

    local frac = math.Clamp(ply:Health() / 100,0,1)

    local tab = {
        [ "$pp_colour_addr" ] = 0,
        [ "$pp_colour_addg" ] = 0,
        [ "$pp_colour_addb" ] = 0,
        [ "$pp_colour_brightness" ] = 0,
        [ "$pp_colour_contrast" ] = 1,
        [ "$pp_colour_colour" ] = 1 * frac,
        [ "$pp_colour_mulr" ] = 0,
        [ "$pp_colour_mulg" ] = 0,
        [ "$pp_colour_mulb" ] = 0
    }

    if !ply:GetNWBool("otrub") then
	    DrawColorModify( tab )
    end
end )