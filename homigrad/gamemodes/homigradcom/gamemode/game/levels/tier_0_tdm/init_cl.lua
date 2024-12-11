tdm.GetTeamName = tdm.GetTeamName

local playsound = false

function tdm.StartRoundCL()
    playsound = true
end

function tdm.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = tdm.GetTeamName(lply)

	local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            OpenBuyMenu()
            surface.PlaySound("music_themes/tdm_start.wav")
            timer.Simple(18,function()
                surface.PlaySound("music_themes/tdm_action.wav")
            end)
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)

        draw.DrawText( "Ваша команда " .. name, "MersText2", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Team DeathMatch", "MersHead1", ScrW() / 2, ScrH() / 8, Color( 255, 0, 0,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        return
    end
end