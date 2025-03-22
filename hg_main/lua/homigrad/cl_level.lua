hook.Add("HUDPaint","LevelDraw",function()
    draw.SimpleText("OPEN-ALPHA","H.25",ScrW() / 2,ScrH() / 1.3,Color(255,255,255,12.5),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    draw.SimpleText("PLEASE REPORT ALL BUGS TO OUR DISCORD.","H.18",ScrW() / 2,ScrH() / 1.27,Color(255,255,255,12.5),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    if ROUND_NAME != nil and TableRound(ROUND_NAME) != nil then
        TableRound().HUDPaint()
	end
end)
