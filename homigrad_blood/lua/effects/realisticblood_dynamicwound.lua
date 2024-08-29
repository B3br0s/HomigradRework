local wound_materials = {}

for i = 1, 5 do
    local imat = Material("decals/flesh/blood"..i.."_subrect")
    table.insert(wound_materials, imat)
end

local sounds = {
    "realistic_flesh_impacts/flesh_impact_bullet1.wav",
    "realistic_flesh_impacts/flesh_impact_bullet2.wav",
    "realistic_flesh_impacts/flesh_impact_bullet3.wav",
    "realistic_flesh_impacts/flesh_impact_bullet4.wav",
    "realistic_flesh_impacts/flesh_impact_bullet5.wav",
    "realistic_flesh_impacts/flesh_impact_bullet6.wav",
    "realistic_flesh_impacts/flesh_impact_bullet7.wav",
}

local white = Color(255, 255, 255)

local WOUND_NORMAL = 1
local WOUND_EXIT = 2

function EFFECT:Init( data )
    local ent = data:GetEntity()
    if !IsValid(ent) then return end

    local flags = data:GetFlags()
    local bone_follower
    local victim

    if flags == WOUND_EXIT && ent:GetClass() == "base_gmodentity" then
        bone_follower = ent
        victim = bone_follower:GetOwner()
    else
        victim = ent
    end

    local pos = data:GetStart()
    local normal = data:GetNormal()
    local max_radius = data:GetRadius()
    local damage = data:GetMagnitude()
    local lerp_ratio = math.Clamp( damage / GetConVar("realistic_blood_max_damage"):GetInt(), 0, 1)
    local radius = Lerp(lerp_ratio, 1, max_radius)

    if flags == WOUND_EXIT then
        if lerp_ratio >= 0.5 then
            local effectdata = EffectData()
            effectdata:SetEntity(bone_follower)
            util.Effect("realisticblood_stream", effectdata)

            ParticleEffect("exit_blood_large", pos, normal:Angle())
        else
            local effectdata = EffectData()
            effectdata:SetEntity(bone_follower)
            effectdata:SetMagnitude( math.Rand(3, 5) )
            util.Effect("realisticblood_droplets", effectdata)

            if GetConVar("realistic_blood_pcf_particles"):GetBool() then ParticleEffect("exit_blood_small", pos, normal:Angle()) end
        end
    end

    util.DecalEx(table.Random(wound_materials), victim, pos, normal, white, radius, radius)
    sound.Play(table.Random(sounds), pos, 68, Lerp(lerp_ratio, 115, 80), Lerp(lerp_ratio, 0.45, 0.65))

    if ( flags == WOUND_NORMAL && ( lerp_ratio >= 0.66 or math.random(1, 4)==1 ) ) or
    flags == WOUND_EXIT && ( lerp_ratio >= 0.33 or math.random(1, 2)==1 ) then
        local effectdata = EffectData()
        effectdata:SetEntity(victim)
        effectdata:SetStart(pos)
        effectdata:SetNormal(normal)
        effectdata:SetMagnitude(damage)
        effectdata:SetFlags( 1 )
        util.Effect("realisticblood_splatter", effectdata)
    end
end

function EFFECT:Think() return false end

function EFFECT:Render() end