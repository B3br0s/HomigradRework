eft.GetTeamName = tdm.GetTeamName

function eft.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = eft.GetTeamName(lply)

	local startRound = roundTimeStart + 4 - CurTime()
    if startRound > 0 and lply:Alive() then
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)

        draw.DrawText( "Вы оператор ЧВК " .. name, "HomigradFontBig", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Escape From Tarkov", "HomigradFontBig", ScrW() / 2, ScrH() / 8, Color( 155,155,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Нейтрализуйте всех кого видите...", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 55,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        return
    end
end