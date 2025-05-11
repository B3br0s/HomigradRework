hl2dm = hl2dm or {}

function hl2dm.SpawnBlue(ply)
    local SpawnList = ReadDataMap("tdm_blue")

    local weps_pri = {"weapon_ar2_hl2","weapon_mp7_hl2","weapon_spas12_hl2"}
    local weps_sec = {"weapon_hl2_pistol"}

    ply:SetTeam(1)

    ply:Spawn()
    
    ply:SetPlayerClass("combine")

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_primary = ply:Give(table.Random(weps_pri))
    local wep_secondary = ply:Give(table.Random(weps_sec))

    wep_primary:SetClip1(wep_primary:GetMaxClip1())
    wep_secondary:SetClip1(wep_secondary:GetMaxClip1())

    ply:GiveAmmo(wep_primary:GetMaxClip1() * math.random(8,16), wep_primary:GetPrimaryAmmoType(), true)
    ply:GiveAmmo(wep_secondary:GetMaxClip1() * math.random(2,4), wep_secondary:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(255,0,0):ToVector())
        ply:SetSubMaterial()

        ply:SetModel("models/player/combine_soldier.mdl")
    end)
end

local rebels = {
    "models/player/group03/female_01.mdl",
    "models/player/group03/female_02.mdl",
    "models/player/group03/female_03.mdl",
    "models/player/group03/female_04.mdl",
    "models/player/group03/female_05.mdl",
    "models/player/group03/female_06.mdl",

    "models/player/group03/male_01.mdl",
    "models/player/group03/male_02.mdl",
    "models/player/group03/male_03.mdl",
    "models/player/group03/male_04.mdl",
    "models/player/group03/male_05.mdl",
    "models/player/group03/male_06.mdl",
    "models/player/group03/male_07.mdl",
    "models/player/group03/male_08.mdl",
    "models/player/group03/male_09.mdl",
}

function hl2dm.SpawnRed(ply)
    local SpawnList = ReadDataMap("tdm_red")

    local weps_pri = {"weapon_ak47","weapon_mp7_hl2","weapon_xm1014","weapon_scar"}
    local weps_sec = {"weapon_hl2_pistol","weapon_magnum357"}
    local weps_oth = {"weapon_kabar","weapon_bandage","weapon_medkit_hg","weapon_painkillers_hg"}

    ply:SetTeam(2)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_primary = ply:Give(table.Random(weps_pri))
    local wep_secondary = ply:Give(table.Random(weps_sec))
    for _, wep in pairs(weps_oth) do
        ply:Give(wep)
    end

    wep_primary:SetClip1(wep_primary:GetMaxClip1())
    wep_secondary:SetClip1(wep_secondary:GetMaxClip1())

    ply:GiveAmmo(wep_primary:GetMaxClip1() * math.random(8,16), wep_primary:GetPrimaryAmmoType(), true)
    ply:GiveAmmo(wep_secondary:GetMaxClip1() * math.random(2,4), wep_secondary:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(255,153,0):ToVector())
        ply:SetModel(table.Random(rebels))
        ply:SetSubMaterial()
    end)
end

function hl2dm.StartRoundSV()
    team.DirectTeams(1,2)

    local blus = team.GetPlayers(1)
    local reds = team.GetPlayers(2)

    for _, ply in ipairs(reds) do
        hl2dm.SpawnRed(ply)
    end

    for _, ply in ipairs(blus) do
        hl2dm.SpawnBlue(ply)
    end
    
    game.CleanUpMap(false)
end

function hl2dm.RoundThink()
    local T_ALIVE = team.GetCountLive(team.GetPlayers(2))
    local CT_ALIVE = team.GetCountLive(team.GetPlayers(1))

    if T_ALIVE == 0 and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(1)
    end

    if CT_ALIVE == 0 and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(2)
    end
end

function hl2dm.CanStart()
    local world = game.GetWorld()
    
    local min, max = world:GetModelBounds()
    local size = max - min

    local size_final = size:Length()

    if size_final < 15000 then
        return false
    else
        return true 
    end
end

function hl2dm.LootSpawn()
    return false
end