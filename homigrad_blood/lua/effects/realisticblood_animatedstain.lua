CreateConVar("realistic_blood_max_animated_stains", "100", FCVAR_ARCHIVE)

local materials = {}
local materials_bloodstream = {}

for i = 1, 30 do
    local imat = Material("decals/animatedblood/blood_leak"..i)
    table.insert(materials, imat)
end

for i = 1, 20 do
    local imat = Material("decals/animatedblood2/blood_leak"..i)
    table.insert(materials_bloodstream, imat)
end

local die_time = 28800
local live_particles = {}
local effect_positions = {}

local function remove_effect( idx )
    for k, effect in ipairs(live_particles) do
        if k == idx then
            for _,v in ipairs(effect) do
                v:SetLifeTime(die_time)
            end
        end
    end

    table.remove(live_particles, idx)
    table.remove(effect_positions, idx)
end

hook.Add("PostCleanupMap", "RealisticBlood_CleanupStains", function()
    for _, effect in ipairs(live_particles) do
        for _,v in ipairs(effect) do
            v:SetLifeTime(die_time)
        end
    end

    table.Empty(live_particles)
    table.Empty(effect_positions)
end)

local ANIMSTAIN_BLOODSTREAM = 2

function EFFECT:Init(data)
    local max_stains = GetConVar("realistic_blood_max_animated_stains"):GetInt()
    if max_stains <= 0 then return end

    local effect_count = table.Count(live_particles)
    if effect_count >= max_stains then
        remove_effect(1)
    end

    local distance_scale = 0.3 
    local flags = data:GetFlags()
    local normal = data:GetNormal() * distance_scale -- scale the normal vector by the distance scale
    local pos = data:GetStart() + normal
    local grow_time = flags == ANIMSTAIN_BLOODSTREAM and math.Rand(5, 7) or math.Rand(10, 12)
    local lerp_ratio = data:GetMagnitude() / GetConVar("realistic_blood_max_damage"):GetInt()
    local size = flags == ANIMSTAIN_BLOODSTREAM and math.Rand(6, 10) or (Lerp(lerp_ratio, 21, 26) + math.Rand(0, 2))

    local ang = normal:Angle()
    if ang.pitch > 22.5 then return end
    ang.roll = ang.roll - 90

    if not self:GoodSurface(pos, normal, size) or self:NearbyEffect(pos, size) then return end
    table.insert(effect_positions, { position = pos, radius = size ^ 2 })

    local particles = {}
    local emitter3D = ParticleEmitter(pos, true)

    local mats = flags == ANIMSTAIN_BLOODSTREAM and table.Copy(materials_bloodstream) or table.Copy(materials)
    local mat = table.Random(mats)

    local lighting = render.GetLightColor(pos)
    local color_r = math.Clamp(130 * lighting.r + 29, 0, 255)
    local color_g = math.Clamp(50 * lighting.g, 0, 255)
    local color_b = math.Clamp(50 * lighting.b, 0, 255)

    for i = 1, 15 do
        local particle_3D = emitter3D:Add(mat, pos)
        particle_3D:SetAngles(ang)
        particle_3D:SetDieTime(grow_time + 0.08)
        particle_3D:SetStartAlpha(flags == ANIMSTAIN_BLOODSTREAM and 62 or 42)
        particle_3D:SetEndAlpha(255)
        particle_3D:SetStartSize(size)
        particle_3D:SetEndSize(size)
        particle_3D:SetColor(color_r, color_g, color_b)
        table.insert(particles, particle_3D)
    end

    table.insert(live_particles, particles)

    timer.Simple(grow_time, function()
        for _, v in ipairs(particles) do
            v:SetStartAlpha(255)
            v:SetDieTime(die_time)
        end
    end)

    emitter3D:Finish()
end
function EFFECT:NearbyEffect( pos, size )
    if !effect_positions then
        effect_positions = {}
    else
        for _,blood_pool in ipairs(effect_positions) do
            if blood_pool.position:DistToSqr(pos) < blood_pool.radius then
                return true
            end
        end
    end
end

function EFFECT:GoodSurface( pos, normal, size )
    local ang = normal:Angle()

    local check_positions = {
        pos + ( ang:Right()+ang:Up() ):GetNormalized()*size*1.35,
        pos + ( -ang:Right()+ang:Up() ):GetNormalized()*size*1.35,
        pos + ( -ang:Right()-ang:Up() ):GetNormalized()*size*1.35,
        pos + ( ang:Right()-ang:Up() ):GetNormalized()*size*1.35,
    }

    for _,v in ipairs(check_positions) do
        local tr = util.TraceLine({
            start = pos,
            endpos = v-normal*1.5,
            mask = MASK_NPCWORLDSTATIC,
        })

        if !tr.Hit or tr.HitSky then return false end
    end

    return true
end

function EFFECT:Think() return false end

function EFFECT:Render() end