-- Cvars:
CreateConVar("realistic_blood_player_effects", "0", FCVAR_ARCHIVE)
CreateConVar("realistic_blood_max_damage", "100", FCVAR_ARCHIVE)
CreateConVar("realistic_blood_pcf_particles", "1", FCVAR_ARCHIVE)

-- Toolmenu:
local is_first

local function add_cat( panel, name, func )
    panel:Help(is_first && "--== "..name.." ==--" or "\n\n--== "..name.." ==--")

    func()

    local str = "--="
    for i = 1, #name do str = str.."=" end
    str = str.."=--"
    panel:Help(str)

    if is_first then is_first = false end
end

hook.Add("PopulateToolMenu", "PopulateToolMenu_RealisticBlood", function()
    spawnmenu.AddToolMenuOption("Options", "GalaxyHighMarshal & Zippy", "Blood Effect Options", "Blood Effect Options", "", "", function(panel)
        is_first = true

        add_cat( panel, "GENERAL", function()
            panel:CheckBox("Show My Own Effects", "realistic_blood_player_effects")
            panel:ControlHelp("Should you be able to see blood effects applied to yourself? Disable if you find it distracting.")
            panel:CheckBox("Enable Particles", "realistic_blood_pcf_particles")
            panel:ControlHelp("Enable non-lua particles? This includes the blood mist from exit wounds, and the splashes from the blood stream.")
            panel:NumSlider("Max Damage", "realistic_blood_max_damage", 1, 500, 0)
            panel:ControlHelp("The blood effects will be at peak intensity when the damage is this or higher.")
            panel:NumSlider("Splatter Distance Multiplier", "realistic_blood_splatter_dist_mult", 0.1, 5, 1)
            panel:ControlHelp("Multiply the travel distance of splatter effects by this amount.")
        end)

        add_cat( panel, "BLOOD POOL", function()
            panel:CheckBox("Blood Pool", "realistic_blood_bloodpool")
            panel:ControlHelp("Enable blood pools?")
            panel:NumSlider("Max Blood Pool Size", "realistic_blood_bloodpool_maxsize", 1, 50, 1)
            panel:ControlHelp("The maximum size for blood pools.")
            panel:NumSlider("Min Blood Pool Size", "realistic_blood_bloodpool_minsize", 1, 50, 1)
            panel:ControlHelp("The minimum size for blood pools.")
        end)

        add_cat( panel, "BLOOD STREAM", function()
            panel:CheckBox("Enable Blood Stream", "realistic_blood_stream")
            panel:ControlHelp("Enable blood stream effect?")
            panel:NumSlider("Blood Stream Min Time", "realistic_blood_stream_mintime", 1, 25, 1)
            panel:ControlHelp("Minimum lifetime of a bloodstream.")
            panel:NumSlider("Blood Stream Max Time", "realistic_blood_stream_maxtime", 1, 25, 1)
            panel:ControlHelp("Maximum lifetime of a bloodstream.")
        end)

        add_cat( panel, "BLOOD DROPLETS", function()
            panel:NumSlider("Blood Droplet Lifetime", "realistic_blood_droplet_lifetime", 0, 300, 0)
            panel:ControlHelp("What should the maximum lifetime for a blood droplet be? Set to 0 to disable the effect entirely.")
        end)

        add_cat( panel, "ANIMATED BLOOD STAIN", function()
            panel:NumSlider("Max Animated Stains", "realistic_blood_max_animated_stains", 0, 500, 0)
            panel:ControlHelp("How many animated blood stains can exist at once? Set to 0 to disable the effect entirely.")
        end)
    
        add_cat( panel, "ANIMATED WOUNDS", function()
            panel:CheckBox("Enable Animated Wounds", "realistic_blood_soak")
            panel:ControlHelp("Enable animated wounds?")
            panel:CheckBox("Enable Multicore Rendering", "gmod_mcore_test")
            panel:ControlHelp("This is required in order for animated wounds to work!")
            panel:NumSlider("Max Animated Wound Size", "realistic_blood_soak_scale", 0.5, 4, 1)
            panel:ControlHelp("The maximum size of an animated wound.")
            panel:NumSlider("Min Animated Wound Size", "realistic_blood_soak_scale_min", 0.5, 4, 1)
            panel:ControlHelp("The minimum size of an animated wound.")
        end)
    end)
end)

-- Blood droplets for lua effects:
CreateConVar("realistic_blood_droplet_lifetime", "8", FCVAR_ARCHIVE)

local material_particle = Material("effects/slime1")
local materials = {}

for i = 1, 11 do
    local imat = Material("effects/droplets/drop"..i)
    table.insert(materials, imat)
end

local sounds = {
    "realistic_blood_drips/drip_01.wav",
    "realistic_blood_drips/drip_02.wav",
    "realistic_blood_drips/drip_03.wav",
    "realistic_blood_drips/drip_04.wav",
    "realistic_blood_drips/drip_05.wav",
    "realistic_blood_drips/drip_06.wav",
    "realistic_blood_drips/drip_07.wav",
    "realistic_blood_drips/drip_08.wav",
}

local live_particles = {}

hook.Add("PostCleanupMap", "RealisticBlood_CleanupDroplets", function()
    for k,v in pairs(live_particles) do
        v.part:SetLifeTime(v.die_time)
        timer.Remove("RealisticBloodDropletRemoval"..k)
    end

    table.Empty(live_particles)
end)

function RealisticBlood_Droplet( pos, normal, emitter, emitter3D )
    if GetConVar("realistic_blood_droplet_lifetime"):GetInt() <= 0 then return end
    if !IsValid(emitter) then return end

    local length = math.Rand(8, 20)
    local particle = emitter:Add( material_particle, pos )
    particle:SetDieTime( 1.5 )
    particle:SetStartSize( math.Rand(0.05, 0.4) )
    particle:SetEndSize(0)
    particle:SetStartLength( length*0.1 )
    particle:SetEndLength( length )
    particle:SetGravity( Vector(0,0,-600) + VectorRand()*100 )
    particle:SetAngles( particle:GetVelocity():Angle() )
    particle:SetColor(80,0,0)
    particle:SetStartAlpha(math.Rand(175, 255))
    particle:SetVelocity( normal*-100 + VectorRand()*28 )
    particle:SetCollide( true )
    particle:SetCollideCallback( function( me, hit_pos, hit_normal )
        if !IsValid(emitter3D) then return end

        local large = false
        if math.random(1, 5) == 1 then large = true end

        local particle_3D_size = large && math.Rand(6, 8) or math.Rand(2, 4)
        local lifetime = GetConVar("realistic_blood_droplet_lifetime"):GetInt()
        local dietime = math.Rand(lifetime*0.5, lifetime)

        local ang = hit_normal:Angle()
        ang.Roll = math.Rand(1,360)

        local mat = table.Random(materials)
        local pos_3D = hit_pos+hit_normal*0

        local particle_3D = emitter3D:Add( mat, pos_3D )
        particle_3D:SetAngles( ang )
        particle_3D:SetDieTime( dietime )
        particle_3D:SetStartSize( particle_3D_size )
        particle_3D:SetEndSize( particle_3D_size )
        particle_3D:SetStartAlpha( 255 )
        particle_3D:SetEndAlpha( 255 )
        particle_3D:SetColor(135,0,0)

        local particle_data = {part = particle_3D, die_time = dietime}
        local idx = table.insert(live_particles, particle_data)

        timer.Create("RealisticBloodDropletRemoval"..idx, dietime-0.15, 1, function()
            local emitter_local = ParticleEmitter( pos_3D, true )
            local fade_particle = emitter_local:Add( mat, pos_3D )

            fade_particle:SetAngles( ang )
            fade_particle:SetDieTime( 1 )
            fade_particle:SetStartSize( particle_3D_size )
            fade_particle:SetEndSize( particle_3D_size )
            fade_particle:SetStartAlpha( 255 )
            fade_particle:SetEndAlpha( 0 )
            fade_particle:SetColor(135,0,0)

            emitter_local:Finish()
            live_particles[idx] = nil
        end)
    end)
end