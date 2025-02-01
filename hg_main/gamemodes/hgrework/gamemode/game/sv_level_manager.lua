util.AddNetworkString("round_state")
util.AddNetworkString("SyncRound")

function StartRound()
    if true then return end--временно.
    if #player.GetAll() < 2 then return end
    RunConsoleCommand("hostname","Homigrad Rework "..TableRound().Name)

    if ROUND_STATE == ROUND_STATE_WAITING then
        ROUND_STATE = ROUND_STATE_ACTIVE
        StartTime = CurTime()
        SetRoundTimer()
    end

    ROUND_NAME = table.Random(ROUND_LIST)

    TableRound().StartRound()
    
    net.Start("SyncRound")
    net.WriteString(ROUND_NAME)
    net.WriteFloat(ROUND_STATE)
    net.WriteBool(ROUND_ACTIVE)
    net.Broadcast()
end

function EndRound(winner)
    --пусто
end

function ResetRound()
    ROUND_STATE = ROUND_STATE_WAITING
end

function SetRoundTimer()
    --чо
end

function CheckRoundEndCondition()
    if #player.GetAll() < 2 then return end
    if not ROUND_ACTIVE then
        ROUND_ACTIVE = true
        StartRound()
    end
    if ROUND_ACTIVE then
        TableRound():CheckRoundEndCondition()
    end
end

hook.Add("Think", "RoundEndCheck", function()
    CheckRoundEndCondition()
end)