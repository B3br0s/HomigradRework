if SERVER then
    util.AddNetworkString("PlayLandingSound")

    local landingSounds = {
        dirt = {
            "homigrad/player/footsteps/new/land_dirt_01.wav",
            "homigrad/player/footsteps/new/land_dirt_02.wav",
            "homigrad/player/footsteps/new/land_dirt_03.wav"
        },
        grass = {
            "homigrad/player/footsteps/new/land_grass_01.wav",
            "homigrad/player/footsteps/new/land_grass_02.wav",
            "homigrad/player/footsteps/new/land_grass_03.wav"
        },
        carpet = {
            "homigrad/player/footsteps/new/land_carpet_01.wav",
            "homigrad/player/footsteps/new/land_carpet_02.wav",
            "homigrad/player/footsteps/new/land_carpet_03.wav"
        },
        metal = {
            "homigrad/player/footsteps/new/land_metal_solid_01.wav",
            "homigrad/player/footsteps/new/land_metal_solid_02.wav",
            "homigrad/player/footsteps/new/land_metal_solid_03.wav"
        },
        metalvent = {
            "homigrad/player/footsteps/new/land_metal_vent_01.wav",
            "homigrad/player/footsteps/new/land_metal_vent_02.wav",
            "homigrad/player/footsteps/new/land_metal_vent_03.wav"
        },
        metalpanel = {
            "homigrad/player/footsteps/new/land_auto_01.wav",
            "homigrad/player/footsteps/new/land_auto_02.wav",
            "homigrad/player/footsteps/new/land_auto_03.wav"
        },
        tile = {
            "homigrad/player/footsteps/new/land_tile_01.wav",
            "homigrad/player/footsteps/new/land_tile_02.wav",
            "homigrad/player/footsteps/new/land_tile_03.wav"
        },
        chainlink = {
            "homigrad/player/footsteps/new/metal_chainlink_01.wav",
            "homigrad/player/footsteps/new/metal_chainlink_02.wav",
            "homigrad/player/footsteps/new/metal_chainlink_03.wav"
        },
        sand = {
            "homigrad/player/footsteps/new/land_sand_01.wav",
            "homigrad/player/footsteps/new/land_sand_02.wav",
            "homigrad/player/footsteps/new/land_sand_03.wav"
        },
        gravel = {
            "homigrad/player/footsteps/new/land_gravel_01.wav",
            "homigrad/player/footsteps/new/land_gravel_02.wav",
            "homigrad/player/footsteps/new/land_gravel_03.wav"
        },
        glass = {
            "homigrad/player/footsteps/new/land_glass_01.wav",
            "homigrad/player/footsteps/new/land_glass_02.wav",
            "homigrad/player/footsteps/new/land_glass_03.wav"
        },
        rubber = {
            "homigrad/player/footsteps/new/land_rubber_01.wav",
            "homigrad/player/footsteps/new/land_rubber_02.wav",
            "homigrad/player/footsteps/new/land_rubber_03.wav"
        },
        mud = {
            "homigrad/player/footsteps/new/land_mud_01.wav",
            "homigrad/player/footsteps/new/land_mud_02.wav",
            "homigrad/player/footsteps/new/land_mud_03.wav"
        },
        snow = {
            "homigrad/player/footsteps/new/land_snow_01.wav",
            "homigrad/player/footsteps/new/land_snow_02.wav",
            "homigrad/player/footsteps/new/land_snow_03.wav"
        },
        wood = {
            "homigrad/player/footsteps/new/wood_15.wav"
        },
        wood_crate = {
            "homigrad/player/footsteps/new/wood_15.wav"
        },
        wood_panel = {
            "homigrad/player/footsteps/new/wood_15.wav"
        },
        concrete = {
            "homigrad/player/footsteps/new/land_concrete_01.wav"
        },
    }

    local function PlayLandingSound(ply)
        local tr = util.TraceLine({
            start = ply:GetPos(),
            endpos = ply:GetPos() - Vector(0, 0, 50),
            filter = ply,
            mask = MASK_PLAYERSOLID
        })

        if tr.Hit then
            local surfaceType = util.GetSurfacePropName(tr.SurfaceProps)

            local sounds = landingSounds[surfaceType]
            if not sounds then
                sounds = landingSounds["concrete"]
            end

            local soundPath = sounds[math.random(#sounds)]

            net.Start("PlayLandingSound")
            net.WriteEntity(ply)
            net.WriteString(soundPath)
            net.Broadcast()
        end
    end

    hook.Add("OnPlayerHitGround", "CustomLandingSounds", function(ply, inWater, onFloater, speed)
        if IsValid(ply) and not inWater then
            PlayLandingSound(ply)
        end
    end)
end

if CLIENT then
    net.Receive("PlayLandingSound", function(l,ply)
        local soundPath = net.ReadString()

        if IsValid(ply) then
            ply:EmitSound(soundPath, 100, 100, 1, CHAN_BODY)
        end
    end)
end
 