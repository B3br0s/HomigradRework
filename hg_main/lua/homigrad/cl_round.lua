hook.Add("HUDPaint","Round-Paint",function()
    if !TableRound() then return end
    if TableRound().HUDPaint then
        TableRound():HUDPaint()
    end
end)

hook.Add("RenderScreenspaceEffects","Round-FX",function()
    if !TableRound() then return end
    if TableRound().RenderScreenspaceEffects then
        TableRound():RenderScreenspaceEffects()
    end
end)

net.Receive("SyncRound",function()
    hg.LastRoundTime = CurTime()
    hg.ROUND_START = CurTime()
    ROUND_NAME = net.ReadString()
    hg.CROUND = ROUND_NAME

    if TableRound().RoundStart then
        TableRound().RoundStart()
    end
end)