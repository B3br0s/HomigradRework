CreateConVar("realistic_blood_soak", "1", FCVAR_ARCHIVE)
CreateConVar("realistic_blood_soak_scale_min", "1.8", FCVAR_ARCHIVE)
CreateConVar("realistic_blood_soak_scale", "2.2", FCVAR_ARCHIVE)

local white = Color(255, 255, 255)

function EFFECT:Init( data )
    if !GetConVar("gmod_mcore_test"):GetBool() then return end
    if !GetConVar("realistic_blood_soak"):GetBool() then return end

    local ent = data:GetEntity()
    if !IsValid(ent) then return end

    local flags = data:GetFlags()
    local pos = data:GetStart()
    local normal = data:GetNormal()
    local radius = math.Rand(GetConVar("realistic_blood_soak_scale_min"):GetFloat(), GetConVar("realistic_blood_soak_scale"):GetFloat())

    util.DecalEx(REALISTIC_BLOOD_SOAK_MATERIALS[flags]["material"], ent, pos, normal, white, radius, radius)
end

function EFFECT:Think() return false end

function EFFECT:Render() end