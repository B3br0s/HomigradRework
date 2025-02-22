util.AddNetworkString("round_state")
util.AddNetworkString("SyncRound")

RTV_ROUNDS = 20
CURRENT_ROUND = (CURRENT_ROUND or 0)
ROUNDS_ENABLED = false
RTV_ACTIVE = (RTV_ACTIVE or false)

function StartRound()
    if RTV_ACTIVE then return end
    if !ROUNDS_ENABLED then return end
    if #player.GetAll() < 2 then return end
    CURRENT_ROUND = CURRENT_ROUND + 1
    if CURRENT_ROUND >= RTV_ROUNDS then
        SolidMapVote.start()
        RTV_ACTIVE = true

        timer.Simple(0.5,function()
            for i,ply in pairs(player.GetAll()) do
                if ply:Alive() then ply:KillSilent() end
            end
        end)
    end
    if (RTV_ROUNDS - CURRENT_ROUND) < 3 and (RTV_ROUNDS - CURRENT_ROUND) > 0 then
        PrintMessage(3,(RTV_ROUNDS - CURRENT_ROUND).." раунд(ов) осталось до RTV")
    end
    RunConsoleCommand("hostname","Homigrad Rework | Open-Alpha")

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