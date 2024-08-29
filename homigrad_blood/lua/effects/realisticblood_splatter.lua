CreateConVar("realistic_blood_splatter_dist_mult", "1", FCVAR_ARCHIVE)

local dense_materials = {}
local lowdense_materials = {}
local verylowdense_materials = {}

for i = 1, 8 do
    local imat = Material("decals/middenseblood/blood"..i)
    table.insert(verylowdense_materials, imat)
end

for i = 1, 11 do
    local imat = Material("decals/lowdenseblood/blood"..i)
    table.insert(lowdense_materials, imat)
end

for i = 1, 23 do
    local imat = Material("decals/denseblood/blood"..i)
    table.insert(dense_materials, imat)
end

local white = Color(255, 255, 255)

local SPLATTER_NORMAL = 1
local SPLATTER_PHYS = 2
local SPLATTER_PHYS_ANIMSTAIN = 3								 

local function get_filter_ents( ent, pos, dist )
    local filter_ents = {}

    table.insert(filter_ents, ent)

    for _,v in ipairs( ents.FindInSphere( pos, dist ) ) do
        if v:GetClass() == "prop_ragdoll" then table.insert(filter_ents, v) end
    end

    return filter_ents
end

function EFFECT:Init( data )
    local ent = data:GetEntity()
    local pos = data:GetStart()
    local normal = data:GetNormal()
    local damage = data:GetMagnitude()
    local decimal = math.Clamp( damage / GetConVar("realistic_blood_max_damage"):GetInt(), 0, 1)
    local flags = data:GetFlags()

    local function phys_splatter()
        return flags==SPLATTER_PHYS or flags==SPLATTER_PHYS_ANIMSTAIN
    end

    local size = Lerp(decimal, 0.7, 1.1)
    local dist = Lerp(decimal, 45, 75)*GetConVar("realistic_blood_splatter_dist_mult"):GetFloat()

    for i = 1, decimal >= 0.66 && 3 or decimal >= 0.33 && 2 or 1 do
        local tr = util.TraceLine({
            start = pos,
            endpos = pos + normal*dist + VectorRand()*dist*0.35,
            filter = get_filter_ents(ent, pos, dist),
        })

        timer.Simple(tr.Fraction*0.65, function()
            local fell_to_ground = false

            if !tr.Hit then
                -- Decal falls to ground, if it didn't hit a wall:
                tr = util.TraceLine({
                    start = tr.HitPos,
                    endpos = tr.HitPos - Vector(0,0,125),
                    filter = get_filter_ents(ent, pos, 125),
                })
                
                tr.Fraction = tr.Fraction*2
                fell_to_ground = true
            end

            local use_dense = i==1 && !phys_splatter() && !fell_to_ground && tr.Fraction<0.15
            local use_lowdense = tr.Fraction<0.75

            local mats = ( use_dense && table.Copy(dense_materials) ) or ( use_lowdense && table.Copy(lowdense_materials) ) or table.Copy(verylowdense_materials)

            if tr.Hit && !tr.HitSky && ( IsValid(tr.Entity) or tr.Entity:IsWorld() ) then
                if flags==SPLATTER_NORMAL or flags==SPLATTER_PHYS_ANIMSTAIN && tr.HitNormal:Angle().pitch < 22.5 && tr.Entity:IsWorld() && tr.Fraction < 0.65 then
                    -- Create animated wall stain:
                    local effectdata = EffectData()
                    effectdata:SetStart(tr.HitPos)
                    effectdata:SetNormal(tr.HitNormal)
                    effectdata:SetMagnitude( damage )
                    effectdata:SetFlags(1)
                    util.Effect("realisticblood_animatedstain", effectdata)
                end

                util.DecalEx( table.Random(mats), tr.Entity, tr.HitPos, tr.HitNormal, white, size+math.Rand(0, 0.1), size+math.Rand(0, 0.1) )
            end
        end)
    end
end

function EFFECT:Think() return false end

function EFFECT:Render() end