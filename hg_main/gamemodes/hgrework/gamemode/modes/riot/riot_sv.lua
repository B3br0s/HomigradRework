riot = riot or {}

function riot.SpawnBlue(ply)
    local SpawnList = ReadDataMap("tdm_blue")

    local weps_pri = {"weapon_bat"}
    local weps_sec = {"","","","","","","","","","","weapon_glock17"}

    ply:SetTeam(1)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_primary = ply:Give(table.Random(weps_pri))
    local wep_secondary = ply:Give(table.Random(weps_sec))


    if IsValid(wep_secondary) then
        wep_secondary:SetClip1(wep_secondary:GetMaxClip1())
        ply:GiveAmmo(wep_secondary:GetMaxClip1() * 1, wep_secondary:GetPrimaryAmmoType(), true)
    end

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(0,0,255):ToVector())
        ply:SetSubMaterial()
        ply:SetModel("models/player/riot.mdl")
    end)
end

function riot.SpawnRed(ply)
    local SpawnList = ReadDataMap("tdm_red")

    local weps_pri = {"","","","","","","","","","","","","","","","","weapon_glock17","","",""}
    local weps_sec = {"weapon_shovel","weapon_pipe","weapon_hatchet","weapon_knife","weapon_bat"}

    ply:SetTeam(2)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_primary = ply:Give(table.Random(weps_pri))
    local wep_secondary = ply:Give(table.Random(weps_sec))

    if IsValid(wep_primary) then
    wep_primary:SetClip1(wep_primary:GetMaxClip1())
    end

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(148,54,31):ToVector())
        ply:SetSubMaterial()
    end)
end

function riot.StartRoundSV()
    team.DirectTeams(1,2)

    local blus = team.GetPlayers(1)
    local reds = team.GetPlayers(2)

    for _, ply in ipairs(reds) do
        riot.SpawnRed(ply)
    end

    for _, ply in ipairs(blus) do
        riot.SpawnBlue(ply)
    end
    
    game.CleanUpMap(false)
end

function riot.RoundThink()
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