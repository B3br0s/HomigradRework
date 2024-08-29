CreateConVar("realistic_blood_bloodpool", "1", FCVAR_ARCHIVE)
CreateConVar("realistic_blood_bloodpool_minsize", "18", FCVAR_ARCHIVE)
CreateConVar("realistic_blood_bloodpool_maxsize", "30", FCVAR_ARCHIVE)

local materials = {}

local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Blood pools, and their size multipliers:
local blood_pools = {
    ["bloodpool1"] = 1.5,
    ["bloodpool2"] = 1.5,
    ["bloodpool3"] = 1.5,
    ["bloodpool4"] = 1.5,
    ["bloodpool5"] = 1.5,
    ["bloodpool6"] = 1.5,
    ["bloodpool7"] = 1.5,
    ["bloodpool8"] = 1.5,
    ["bloodpool9"] = 1.5,
    ["bloodpool10"] = 1.5,
    ["bloodpool11"] = 1.5,
    ["bloodpool12"] = 1.5,
    ["bloodpool13"] = 1.6,
    ["bloodpool14"] = 1.5,
    ["bloodpool15"] = 1.4,
    ["bloodpool16"] = 1.6,
    ["bloodpool17"] = 1.4,
    ["bloodpool18"] = 1.5,
    ["bloodpool19"] = 1.7,
    ["bloodpool20"] = 1.5,
    ["bloodpool21"] = 1.5,
    ["bloodpool22"] = 1.5,
    ["bloodpool23"] = 1.5,
    ["bloodpool24"] = 1.5,
    ["bloodpool25"] = 1.5,
    ["bloodpool26"] = 1.5,
    ["bloodpool27"] = 1.4,
    ["bloodpool28"] = 1.5,
    ["bloodpool29"] = 1.5,
    ["bloodpool30"] = 1.5,
    ["bloodpool31"] = 1.5,
    ["bloodpool32"] = 1.5,
    ["bloodpool33"] = 1.5,
    ["bloodpool34"] = 1.5,

}
-- Sloping blood pools:
local slope_pools = {
    ["bloodpool1"] = 1.25,
    ["bloodpool2"] = 1,

}

local function get_light_brightness(pos)
    local light_color = render.GetLightColor(pos)
    return (light_color.x + light_color.y + light_color.z) / 3
end

for k in pairs(blood_pools) do
    local imat_anim = "decals/bloodpool/a/"..k
    local imat_shader = "decals/bloodpool/"..k

    materials[k] = {anim=imat_anim, shader=imat_shader}
end

for k in pairs(slope_pools) do
    local imat_anim = "decals/bloodpool/slope/a/"..k
    local imat_shader = "decals/bloodpool/slope/"..k

    materials["slope_"..k] = {anim=imat_anim, shader=imat_shader}
end

local layers = 20
local die_time = 28800
local dist_from_ground = 0.3

-- Kill all particles when owner of blood pool is removed:
hook.Add("EntityRemoved", "RealisticBlood_RemoveBloodPool", function( ent )
    if ent.RealisticBlood_BloodPoolParticles then
        for _,v in ipairs(ent.RealisticBlood_BloodPoolParticles) do
            v:SetLifeTime(die_time)
        end
    end
end)

function EFFECT:Init( data )
    if !GetConVar("realistic_blood_bloodpool"):GetBool() then return end

    local ent = data:GetEntity()
    if !IsValid(ent) then return end

    local normal = data:GetNormal()
    local pos = data:GetStart()+normal*dist_from_ground
    local ang = normal:Angle()
    self.OnDisplacement = data:GetFlags() != 0

    -- Make slope effect if pool is on a slope, but not if it's on a displacement.
    local should_slope = false
    if (ang.pitch - 270) > 6 && !self.OnDisplacement then should_slope = true end

    local size_mult, name

    if should_slope then
        size_mult, name = table.Random(slope_pools)
        name = "slope_"..name
    else
        size_mult, name = table.Random(blood_pools)
    end

    local mat = materials[name].anim
    local mat_shader = materials[name].shader
    local lerp_ratio = data:GetMagnitude()/GetConVar("realistic_blood_max_damage"):GetInt()
    local size = ( Lerp( lerp_ratio, GetConVar("realistic_blood_bloodpool_minsize"):GetFloat(), GetConVar("realistic_blood_bloodpool_maxsize"):GetFloat()) + math.Rand(0, 2) ) * size_mult
    local grow_time = Lerp( lerp_ratio, 25, 15) + math.Rand(0, 1)

    if should_slope then
        pos = pos - ang:Up()*size*0.5
        ang.roll = ang.yaw^3 - 90
        --grow_time = grow_time*0.5
    else
        ang.roll = math.random(1, 360)
    end

    if !self:GoodSurface( pos, normal, size ) or self:NearbyEffect( pos, size, ent ) then return end
    table.insert(ent.RealisticBlood_BloodPoolPositions, {position=pos, radius=size^2})

    if !ent.RealisticBlood_BloodPoolParticles then ent.RealisticBlood_BloodPoolParticles = {} end
    local emitter3D = ParticleEmitter(pos, true)

    local brightness = get_light_brightness(pos)
    local dark_red = 20
    local normal_red = 130

    for i = 1, layers do
        local particle_3D = emitter3D:Add( mat, pos )
        particle_3D:SetAngles( ang )
        particle_3D:SetDieTime( grow_time + 0.08 )
        particle_3D:SetStartAlpha( 0 )
        particle_3D:SetEndAlpha( 255 )

        if i < layers * 0.5 then
            particle_3D:SetStartSize( size - 0.35 )
            particle_3D:SetEndSize( size - 0.35 )
            particle_3D:SetColor(lerp(dark_red, normal_red, brightness), 0, 0)
        else
            particle_3D:SetStartSize( size )
            particle_3D:SetEndSize( size )
            particle_3D:SetColor(lerp(dark_red, normal_red, brightness), 0, 0)
        end

        table.insert(ent.RealisticBlood_BloodPoolParticles, particle_3D)
    end

    timer.Simple(grow_time, function()
        if ent.RealisticBlood_BloodPoolParticles then
            local particle_3D_shader = emitter3D:Add( mat_shader, pos )
            particle_3D_shader:SetDieTime( die_time )
            particle_3D_shader:SetStartSize( size )
            particle_3D_shader:SetEndSize( size )
            particle_3D_shader:SetAngles( ang )

            table.insert(ent.RealisticBlood_BloodPoolParticles, particle_3D_shader)
        end

        emitter3D:Finish()
    end)
end

function EFFECT:NearbyEffect( pos, size, ent )
    if !ent.RealisticBlood_BloodPoolPositions then
        ent.RealisticBlood_BloodPoolPositions = {}
    else
        for _,blood_pool in ipairs(ent.RealisticBlood_BloodPoolPositions) do
            if blood_pool.position:DistToSqr(pos) < blood_pool.radius then
                return true
            end
        end
    end
end

function EFFECT:GoodSurface( pos, normal, size )
    if self.OnDisplacement then return true end

    local ang = normal:Angle()

    local check_positions = {
        pos + ( ang:Right()+ang:Up() ):GetNormalized()*size*1,
        pos + ( -ang:Right()+ang:Up() ):GetNormalized()*size*1,
        pos + ( -ang:Right()-ang:Up() ):GetNormalized()*size*1,
        pos + ( ang:Right()-ang:Up() ):GetNormalized()*size*1,
    }

    for _,v in ipairs(check_positions) do
        if bit.band(util.PointContents( v-normal*(2+dist_from_ground) ), CONTENTS_SOLID) != CONTENTS_SOLID then return end
    end

    return true
end

function EFFECT:Think() return false end

function EFFECT:Render() end