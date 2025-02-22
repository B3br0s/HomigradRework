include("shared.lua")
include("autorun/loader.lua")

function GM:PlayerLoadout() end--нахуя?

function GM:DoPlayerDeath(ply) return end

function GM:PlayerDeathThink(ply)
    ply:Spectate(OBS_MODE_ROAMING)
end

function GM:Initialize()
    RunConsoleCommand("hostname","Homigrad Rework | Open-Alpha")
end

function GM:PlayerSpawn(ply)
    local ValidModels = {
        ["models/player/group01/male_01.mdl"] = true,
        ["models/player/group01/male_02.mdl"] = true,
        ["models/player/group01/male_03.mdl"] = true,
        ["models/player/group01/male_04.mdl"] = true,
        ["models/player/group01/male_05.mdl"] = true,
        ["models/player/group01/male_06.mdl"] = true,
        ["models/player/group01/male_07.mdl"] = true,
        ["models/player/group01/male_08.mdl"] = true,
        ["models/player/group01/male_09.mdl"] = true,
        ["models/player/group01/female_01.mdl"] = true,
        ["models/player/group01/female_02.mdl"] = true,
        ["models/player/group01/female_03.mdl"] = true,
        ["models/player/group01/female_04.mdl"] = true,
        ["models/player/group01/female_05.mdl"] = true,
        ["models/player/group01/female_06.mdl"] = true
    }

    local NiggaModels = {
        "models/player/group01/male_01.mdl",
        "models/player/group01/male_02.mdl",
        "models/player/group01/male_03.mdl",
        "models/player/group01/male_04.mdl",
        "models/player/group01/male_05.mdl",
        "models/player/group01/male_06.mdl",
        "models/player/group01/male_07.mdl",
        "models/player/group01/male_08.mdl",
        "models/player/group01/male_09.mdl",
        "models/player/group01/female_01.mdl",
        "models/player/group01/female_02.mdl",
        "models/player/group01/female_03.mdl",
        "models/player/group01/female_04.mdl",
        "models/player/group01/female_05.mdl",
        "models/player/group01/female_06.mdl"
    }

    ply:SetCanZoom(false)
    ApplyAppearance(ply,ply.Appearance)
    ply:Give("weapon_hands")
    if not PLYSPAWN_OVERRIDE then
    ply:SetModel(table.Random(NiggaModels))
    end
    ply:UnSpectate()
    hg.Gibbed[ply] = false
end

hook.Add("Player Think","PlayerKillSilent",function(ply,time)
    if ply.KSILENT and ply:Alive() then
        ply:KillSilent()
    elseif ply.KSILENT and not ply:Alive() then
        ply.KSILENT = false
    end
end)

function GM:PlayerInitialSpawn(ply)
    ply.KSILENT = true
end

function GM:DoPlayerDeath(ply,attacker,dmginfo)
    --ply.Fake = false
    --ply.FakeRagdoll = NULL
end