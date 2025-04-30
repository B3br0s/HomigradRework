dr = dr or {}

dr.RoundEnds = 1e8

function dr.SpawnKiller(ply)
    local SpawnList = ReadDataMap("hunt_dr")

    ply:SetTeam(2)

    ply:Spawn()

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(255,0,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function dr.SpawnRunner(ply)
    local weps_oth = {"weapon_chips","weapon_energy_drink","weapon_milk","weapon_water_bottle"}

    local SpawnList = ReadDataMap("hunt_victim")

    ply:SetTeam(1)

    ply:Spawn()

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_other = ply:Give(table.Random(weps_oth))

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(0,255,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function dr.StartRoundSV()
    local plys = {}

    dr.RoundEnds = CurTime() + dr.TimeRoundEnds

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == 1002 then
            continue 
        end
        table.insert(plys,ply)
        ply:SetTeam(1)
        dr.SpawnRunner(ply)
    end

    local htr = table.Random(plys)

    dr.SpawnKiller(htr)

    game.CleanUpMap(false)
end

function dr.RoundThink()
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

    if dr.RoundEnds < CurTime() and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(2)
    end
end

function dr.CanStart()
    local mapname = string.lower(game.GetMap())

    if !string.match(mapname,"deathrun_") then
        return false
    else
        return true
    end
end