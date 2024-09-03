if SERVER then
    local footstepSounds = {
        dirt = {
            "homigrad/player/footsteps/new/dirt_01.wav",
            "homigrad/player/footsteps/new/dirt_02.wav",
            "homigrad/player/footsteps/new/dirt_03.wav",
            "homigrad/player/footsteps/new/dirt_04.wav",
            "homigrad/player/footsteps/new/dirt_05.wav",
            "homigrad/player/footsteps/new/dirt_06.wav",
            "homigrad/player/footsteps/new/dirt_07.wav",
            "homigrad/player/footsteps/new/dirt_08.wav",
            "homigrad/player/footsteps/new/dirt_09.wav",
            "homigrad/player/footsteps/new/dirt_10.wav",
            "homigrad/player/footsteps/new/dirt_11.wav",
            "homigrad/player/footsteps/new/dirt_12.wav",
            "homigrad/player/footsteps/new/dirt_13.wav",
            "homigrad/player/footsteps/new/dirt_14.wav"
        },
        grass = {
            "homigrad/player/footsteps/new/grass_01.wav",
            "homigrad/player/footsteps/new/grass_02.wav",
            "homigrad/player/footsteps/new/grass_03.wav",
            "homigrad/player/footsteps/new/grass_04.wav",
            "homigrad/player/footsteps/new/grass_05.wav",
            "homigrad/player/footsteps/new/grass_06.wav",
            "homigrad/player/footsteps/new/grass_07.wav",
            "homigrad/player/footsteps/new/grass_08.wav",
            "homigrad/player/footsteps/new/grass_09.wav",
            "homigrad/player/footsteps/new/grass_10.wav",
            "homigrad/player/footsteps/new/grass_11.wav",
            "homigrad/player/footsteps/new/grass_12.wav",
            "homigrad/player/footsteps/new/grass_13.wav"
        },
        metal = {
            "homigrad/player/footsteps/new/metal_solid_35.wav",
            "homigrad/player/footsteps/new/metal_solid_36.wav",
            "homigrad/player/footsteps/new/metal_solid_37.wav",
            "homigrad/player/footsteps/new/metal_solid_38.wav",
            "homigrad/player/footsteps/new/metal_solid_39.wav",
            "homigrad/player/footsteps/new/metal_solid_40.wav",
            "homigrad/player/footsteps/new/metal_solid_41.wav",
            "homigrad/player/footsteps/new/metal_solid_42.wav",
            "homigrad/player/footsteps/new/metal_solid_43.wav",
            "homigrad/player/footsteps/new/metal_solid_44.wav",
            "homigrad/player/footsteps/new/metal_solid_45.wav",
            "homigrad/player/footsteps/new/metal_solid_46.wav",
            "homigrad/player/footsteps/new/metal_solid_47.wav",
            "homigrad/player/footsteps/new/metal_solid_48.wav",
            "homigrad/player/footsteps/new/metal_solid_49.wav",
            "homigrad/player/footsteps/new/metal_solid_50.wav"
        },
        metalvent = {
            "homigrad/player/footsteps/new/metal_grate_01.wav",
            "homigrad/player/footsteps/new/metal_grate_02.wav",
            "homigrad/player/footsteps/new/metal_grate_03.wav",
            "homigrad/player/footsteps/new/metal_grate_04.wav",
            "homigrad/player/footsteps/new/metal_grate_05.wav",
            "homigrad/player/footsteps/new/metal_grate_06.wav",
            "homigrad/player/footsteps/new/metal_grate_07.wav",
            "homigrad/player/footsteps/new/metal_grate_08.wav",
            "homigrad/player/footsteps/new/metal_grate_09.wav",
            "homigrad/player/footsteps/new/metal_grate_10.wav",
            "homigrad/player/footsteps/new/metal_grate_11.wav",
            "homigrad/player/footsteps/new/metal_grate_12.wav",
            "homigrad/player/footsteps/new/metal_grate_13.wav",
            "homigrad/player/footsteps/new/metal_grate_14.wav",
            "homigrad/player/footsteps/new/metal_grate_15.wav"
        },
        metalpanel = {
            "homigrad/player/footsteps/new/metal_auto_01.wav",
            "homigrad/player/footsteps/new/metal_auto_02.wav",
            "homigrad/player/footsteps/new/metal_auto_03.wav",
            "homigrad/player/footsteps/new/metal_auto_04.wav",
            "homigrad/player/footsteps/new/metal_auto_05.wav"
        },
        tile = {
            "homigrad/player/footsteps/new/tile_01.wav",
            "homigrad/player/footsteps/new/tile_02.wav",
            "homigrad/player/footsteps/new/tile_03.wav",
            "homigrad/player/footsteps/new/tile_04.wav",
            "homigrad/player/footsteps/new/tile_05.wav",
            "homigrad/player/footsteps/new/tile_06.wav",
            "homigrad/player/footsteps/new/tile_07.wav",
            "homigrad/player/footsteps/new/tile_08.wav",
            "homigrad/player/footsteps/new/tile_09.wav",
            "homigrad/player/footsteps/new/tile_10.wav",
            "homigrad/player/footsteps/new/tile_11.wav",
            "homigrad/player/footsteps/new/tile_12.wav",
            "homigrad/player/footsteps/new/tile_13.wav",
            "homigrad/player/footsteps/new/tile_14.wav"
        },
        chainlink = {
            "homigrad/player/footsteps/new/metal_chainlink_01.wav",
            "homigrad/player/footsteps/new/metal_chainlink_02.wav",
            "homigrad/player/footsteps/new/metal_chainlink_03.wav",
            "homigrad/player/footsteps/new/metal_chainlink_04.wav",
            "homigrad/player/footsteps/new/metal_chainlink_05.wav",
            "homigrad/player/footsteps/new/metal_chainlink_06.wav",
            "homigrad/player/footsteps/new/metal_chainlink_07.wav",
            "homigrad/player/footsteps/new/metal_chainlink_09.wav"
        },
        sand = {
            "homigrad/player/footsteps/new/sand_01.wav",
            "homigrad/player/footsteps/new/sand_02.wav",
            "homigrad/player/footsteps/new/sand_03.wav",
            "homigrad/player/footsteps/new/sand_04.wav",
            "homigrad/player/footsteps/new/sand_05.wav",
            "homigrad/player/footsteps/new/sand_06.wav",
            "homigrad/player/footsteps/new/sand_07.wav",
            "homigrad/player/footsteps/new/sand_08.wav",
            "homigrad/player/footsteps/new/sand_09.wav",
            "homigrad/player/footsteps/new/sand_10.wav",
            "homigrad/player/footsteps/new/sand_11.wav",
            "homigrad/player/footsteps/new/sand_12.wav"
        },
        gravel = {
            "homigrad/player/footsteps/new/gravel_01.wav",
            "homigrad/player/footsteps/new/gravel_02.wav",
            "homigrad/player/footsteps/new/gravel_03.wav",
            "homigrad/player/footsteps/new/gravel_04.wav",
            "homigrad/player/footsteps/new/gravel_05.wav",
            "homigrad/player/footsteps/new/gravel_06.wav",
            "homigrad/player/footsteps/new/gravel_07.wav",
            "homigrad/player/footsteps/new/gravel_08.wav",
            "homigrad/player/footsteps/new/gravel_09.wav",
            "homigrad/player/footsteps/new/gravel_10.wav"
        },
        glass = {
            "homigrad/player/footsteps/new/glass_01.wav",
            "homigrad/player/footsteps/new/glass_07.wav",
            "homigrad/player/footsteps/new/glass_08.wav",
            "homigrad/player/footsteps/new/glass_09.wav",
            "homigrad/player/footsteps/new/glass_10.wav",
            "homigrad/player/footsteps/new/glass_11.wav",
            "homigrad/player/footsteps/new/glass_12.wav",
            "homigrad/player/footsteps/new/glass_13.wav"
        },
        rubber = {
            "homigrad/player/footsteps/new/rubber_03.wav",
            "homigrad/player/footsteps/new/rubber_04.wav",
            "homigrad/player/footsteps/new/rubber_05.wav",
            "homigrad/player/footsteps/new/rubber_06.wav",
            "homigrad/player/footsteps/new/rubber_07.wav",
            "homigrad/player/footsteps/new/rubber_08.wav",
            "homigrad/player/footsteps/new/rubber_11.wav",
            "homigrad/player/footsteps/new/rubber_12.wav"
        },
        mud = {
            "homigrad/player/footsteps/new/mud_01.wav",
            "homigrad/player/footsteps/new/mud_02.wav",
            "homigrad/player/footsteps/new/mud_03.wav",
            "homigrad/player/footsteps/new/mud_04.wav",
            "homigrad/player/footsteps/new/mud_05.wav",
            "homigrad/player/footsteps/new/mud_06.wav",
            "homigrad/player/footsteps/new/mud_07.wav",
            "homigrad/player/footsteps/new/mud_08.wav",
            "homigrad/player/footsteps/new/mud_09.wav"
        },
        snow = {
            "homigrad/player/footsteps/new/snow_01.wav",
            "homigrad/player/footsteps/new/snow_02.wav",
            "homigrad/player/footsteps/new/snow_03.wav",
            "homigrad/player/footsteps/new/snow_04.wav",
            "homigrad/player/footsteps/new/snow_05.wav",
            "homigrad/player/footsteps/new/snow_06.wav",
            "homigrad/player/footsteps/new/snow_07.wav",
            "homigrad/player/footsteps/new/snow_08.wav",
            "homigrad/player/footsteps/new/snow_09.wav",
            "homigrad/player/footsteps/new/snow_10.wav",
            "homigrad/player/footsteps/new/snow_11.wav",
            "homigrad/player/footsteps/new/snow_12.wav"
        },
        wood = {
            "homigrad/player/footsteps/new/wood_01.wav",
            "homigrad/player/footsteps/new/wood_02.wav",
            "homigrad/player/footsteps/new/wood_03.wav",
            "homigrad/player/footsteps/new/wood_04.wav",
            "homigrad/player/footsteps/new/wood_05.wav",
            "homigrad/player/footsteps/new/wood_06.wav",
            "homigrad/player/footsteps/new/wood_07.wav",
            "homigrad/player/footsteps/new/wood_08.wav",
            "homigrad/player/footsteps/new/wood_09.wav",
            "homigrad/player/footsteps/new/wood_10.wav",
            "homigrad/player/footsteps/new/wood_11.wav",
            "homigrad/player/footsteps/new/wood_12.wav",
            "homigrad/player/footsteps/new/wood_13.wav",
            "homigrad/player/footsteps/new/wood_14.wav",
            "homigrad/player/footsteps/new/wood_15.wav"
        },
        wood_crate = {
            "homigrad/player/footsteps/new/wood_01.wav",
            "homigrad/player/footsteps/new/wood_02.wav",
            "homigrad/player/footsteps/new/wood_03.wav",
            "homigrad/player/footsteps/new/wood_04.wav",
            "homigrad/player/footsteps/new/wood_05.wav",
            "homigrad/player/footsteps/new/wood_06.wav",
            "homigrad/player/footsteps/new/wood_07.wav",
            "homigrad/player/footsteps/new/wood_08.wav",
            "homigrad/player/footsteps/new/wood_09.wav",
            "homigrad/player/footsteps/new/wood_10.wav",
            "homigrad/player/footsteps/new/wood_11.wav",
            "homigrad/player/footsteps/new/wood_12.wav",
            "homigrad/player/footsteps/new/wood_13.wav",
            "homigrad/player/footsteps/new/wood_14.wav",
            "homigrad/player/footsteps/new/wood_15.wav"
        },
        wood_panel = {
            "homigrad/player/footsteps/new/wood_01.wav",
            "homigrad/player/footsteps/new/wood_02.wav",
            "homigrad/player/footsteps/new/wood_03.wav",
            "homigrad/player/footsteps/new/wood_04.wav",
            "homigrad/player/footsteps/new/wood_05.wav",
            "homigrad/player/footsteps/new/wood_06.wav",
            "homigrad/player/footsteps/new/wood_07.wav",
            "homigrad/player/footsteps/new/wood_08.wav",
            "homigrad/player/footsteps/new/wood_09.wav",
            "homigrad/player/footsteps/new/wood_10.wav",
            "homigrad/player/footsteps/new/wood_11.wav",
            "homigrad/player/footsteps/new/wood_12.wav",
            "homigrad/player/footsteps/new/wood_13.wav",
            "homigrad/player/footsteps/new/wood_14.wav",
            "homigrad/player/footsteps/new/wood_15.wav"
        },
        concrete = {
            "homigrad/player/footsteps/new/concrete_ct_01.wav",
            "homigrad/player/footsteps/new/concrete_ct_02.wav",
            "homigrad/player/footsteps/new/concrete_ct_03.wav",
            "homigrad/player/footsteps/new/concrete_ct_04.wav",
            "homigrad/player/footsteps/new/concrete_ct_05.wav",
            "homigrad/player/footsteps/new/concrete_ct_06.wav",
            "homigrad/player/footsteps/new/concrete_ct_07.wav",
            "homigrad/player/footsteps/new/concrete_ct_08.wav",
            "homigrad/player/footsteps/new/concrete_ct_09.wav",
            "homigrad/player/footsteps/new/concrete_ct_10.wav",
            "homigrad/player/footsteps/new/concrete_ct_11.wav",
            "homigrad/player/footsteps/new/concrete_ct_12.wav",
            "homigrad/player/footsteps/new/concrete_ct_13.wav",
            "homigrad/player/footsteps/new/concrete_ct_14.wav",
            "homigrad/player/footsteps/new/concrete_ct_15.wav",
            "homigrad/player/footsteps/new/concrete_ct_16.wav",
            "homigrad/player/footsteps/new/concrete_ct_17.wav"
        },
    }

    local function PlayFootstepSound(ply)
        local tr = util.TraceLine({
            start = ply:GetPos(),
            endpos = ply:GetPos() - Vector(0, 0, 50),
            filter = ply,
            mask = MASK_PLAYERSOLID
        })

        if tr.Hit then
            local surfaceType = util.GetSurfacePropName(tr.SurfaceProps)
            local sounds = footstepSounds[surfaceType]

            if sounds then
                local soundPath = sounds[math.random(#sounds)]
                ply:EmitSound(soundPath, 50, 100, 1, CHAN_BODY)
            else
                local fallbackSounds = footstepSounds["concrete"]
                local soundPath = fallbackSounds[math.random(#fallbackSounds)]
                ply:EmitSound(soundPath, 50, 100, 1, CHAN_BODY)
            end
        end
    end

    hook.Add("PlayerFootstep", "CustomFootstepSounds", function(ply, pos, foot, sound, volume, filter)
        if IsValid(ply) then
            PlayFootstepSound(ply)
            return true
        end
    end)
end
