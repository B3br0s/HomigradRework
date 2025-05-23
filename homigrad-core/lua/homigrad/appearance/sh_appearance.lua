hg = hg or {}

hg.Models = {
    [0] = {
        "models/player/group01/male_01.mdl",
        "models/player/group01/male_02.mdl",
        "models/player/group01/male_03.mdl",
        "models/player/group01/male_04.mdl",
        "models/player/group01/male_05.mdl",
        "models/player/group01/male_06.mdl",
        "models/player/group01/male_07.mdl",
        "models/player/group01/male_08.mdl",
        "models/player/group01/male_09.mdl",
        },
    [1] = {
        "models/player/group01/female_01.mdl",
        "models/player/group01/female_02.mdl",
        "models/player/group01/female_03.mdl",
        "models/player/group01/female_04.mdl",
        "models/player/group01/female_05.mdl",
        "models/player/group01/female_06.mdl",
        },
}

function hg.IsFemale(ent)
    if ent == NULL then
        return false
    end
    if ent == nil then
        return false
    end
    if table.HasValue(hg.Models[1],ent:GetModel()) then
        return true
    else
        return false
    end
end