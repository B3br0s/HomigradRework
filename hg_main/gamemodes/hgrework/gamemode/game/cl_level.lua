hook.Add("HUDPaint","LevelDraw",function()
    if ROUND_NAME != nil and TableRound(ROUND_NAME) != nil then
        TableRound().HUDPaint()
	end
end)