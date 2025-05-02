hook.Add("HUDPaint","Round_Shit123",function()
    local nonspect = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 then
            table.insert(nonspect,ply)
        end
    end
    if #nonspect < 2 then
        surface.SetFont("HS.45")
        local shit_size = surface.GetTextSize(hg.GetPhrase("need_2_players"))

        surface.SetMaterial(Material('vgui/gradient-l'))
        surface.SetDrawColor(255,20,20,255)
        surface.DrawTexturedRect(ScrW()/2,100,shit_size / 1.5,50)
        surface.SetMaterial(Material('vgui/gradient-r'))
        surface.DrawTexturedRect((ScrW()/2)-shit_size/1.505,100,shit_size / 1.5,50)

        draw.SimpleText(hg.GetPhrase("need_2_players"),"HS.45",ScrW()/2,123,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    if ROUND_ENDED and hg.WinTime < CurTime() then
        draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(0,0,0,250))
        draw.SimpleText(string.format(hg.GetPhrase("lvl_loadingmode"),TableRound(ROUND_NEXT).name),"H.45",ScrW()/2,ScrH()/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end)

hook.Add("HUDPaint","Round-Paint",function()
    if !TableRound or !TableRound() then return end
    if TableRound().HUDPaint then
        TableRound():HUDPaint()
    end
end)

hook.Add("RenderScreenspaceEffects","Round-FX",function()
    if !TableRound or !TableRound() then return end
    if TableRound().RenderScreenspaceEffects then
        TableRound():RenderScreenspaceEffects()
    end
end)

net.Receive("SyncRound",function()
    ROUND_NAME = net.ReadString()
    ROUND_NEXT = net.ReadString()
    local is = net.ReadBool()
    if is then
        hg.LastRoundTime = CurTime()
        hg.ROUND_START = CurTime()
        hg.CROUND = ROUND_NAME
        ROUND_ENDED = false

        if TableRound().RoundStart then
            TableRound().RoundStart()
        end
    end
end)