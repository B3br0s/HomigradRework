--эээ ну да?
util.AddNetworkString("SyncRound")
util.AddNetworkString("EndRound")

local SmallMaps = {
    ["ttt_clue_2022"] = true,
    ["hmcd_metropolis"] = true,
    ["hmcd_lighthouse"] = true,
    ["gm_zabroshka"] = true,
    ["gm_bbicotka_hmcd"] = true,
    ["gm_bbicotka_snow_hmcd"] = true,
}

function StartRound()
    if #player.GetAll() == 1 then
        RunConsoleCommand("bot")
    end

    ROUND_ACTIVE = true

    game.CleanUpMap(false)
    
    if not ROUND_NEXT then
        ROUND_NAME = table.Random(ROUND_LIST)

        if SmallMaps[game.GetMap()] and not ROUND_NEXT then
            ROUND_NAME = "hmcd"
        end
    else
        ROUND_NAME = ROUND_NEXT
        ROUND_NEXT = nil
    end

    ROUND_ENDED = false

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == 1002 then
            continue 
        end
        ply:KillSilent()
        ply:Spawn()
    end

    if TableRound().StartRound then
        TableRound().StartRound()
    end

    if TableRound().StartRoundSV then
        TableRound().StartRoundSV()
    end

    net.Start("SyncRound")
    net.WriteString(ROUND_NAME)
    net.Broadcast()

    //DiscordLog("Round started - "..(TableRound().coolname or TableRound().name), "Info")
end

function EndRound(team_wins)
    local TeamName = TableRound().Teams[team_wins]["Name"]
    local TeamColor = TableRound().Teams[team_wins]["Color"]

    net.Start("EndRound")
    net.WriteColor(TeamColor)
    net.WriteString("level_wins")
    net.WriteString(TeamName)
    net.Broadcast()
end

--PrintTable(TableRound())

hook.Add("Think","Round-Think",function()
    if #player.GetAll() > 2 then
        for _, ply in ipairs(player.GetAll()) do
            if ply:IsBot() then
                ply:Kick()
            end
        end
    end

    if ROUND_ENDED and ROUND_ACTIVE then
        if ROUND_ENDSIN < CurTime() then
            ROUND_ACTIVE = false
        end
    end

    if #player.GetAll() == 0 then
        ROUND_ACTIVE = false
        return
    end

    if not ROUND_ACTIVE then
        StartRound()
    else
        if TableRound().RoundThink then
            TableRound():RoundThink()
        end
    end
end)