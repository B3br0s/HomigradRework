REALISTIC_BLOOD_SOAK_MATERIALS = {}
if SERVER then REALISTIC_BLOOD_SOAK_MAT_IDX = 1 end

for i1 = 1, 21 do
    for i2 = 1, 12 do
        local name = "decals/flesh/animated/blood"..i2.."_mats/blood"..i2.."_"..i1
        local imat = Material(name)

        table.insert(REALISTIC_BLOOD_SOAK_MATERIALS, {str=name, material=imat})
    end
end