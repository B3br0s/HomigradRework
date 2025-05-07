dr = dr or {}

dr.RoundEnds = 1e8

function dr.PlayerThink(ply)
    if ply.Fake then
        return
    end
    if ply:OnGround() then
        return
    end

    ply:SetVelocity(ply:GetVelocity() * 1.01)
end

function dr.SpawnKiller(ply)
    local SpawnList = ReadDataMap("dr_spawn_killer")

    if #ReadDataMap("dr_spawn_killer") == 0 then
	    for i, ent in RandomPairs(ents.FindByClass("info_player_terrorist")) do
	    	table.insert(SpawnList,ent:GetPos())
	    end
    end
    ply:SetTeam(2)

    ply:Spawn()

    if #ReadDataMap("dr_spawn_killer") != 0 then
        ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))
    else
        ply:SetPos(table.Random(SpawnList))
    end

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(255,0,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function dr.SpawnRunner(ply)
    local SpawnList = ReadDataMap("dr_spawn_runner")

    if #ReadDataMap("dr_spawn_runner") == 0 then
	    for i, ent in RandomPairs(ents.FindByClass("info_player_counterterrorist")) do
	    	table.insert(SpawnList,ent:GetPos())
	    end
    end

    ply:SetTeam(1)

    ply:Spawn()

    //ply:Give("weapon_knife_css")

    if #ReadDataMap("dr_spawn_runner") != 0 then
        ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))
    else
        ply:SetPos(table.Random(SpawnList))
    end

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
        ply.AppearanceOverride = true
        dr.SpawnRunner(ply)
    end

    local htr = table.Random(plys)

    dr.SpawnKiller(htr)

    game.CleanUpMap(false)

    SetGlobalBool("DefaultMove",true)
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

    for _, ply in ipairs(player.GetAll()) do
        dr.PlayerThink(ply)
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