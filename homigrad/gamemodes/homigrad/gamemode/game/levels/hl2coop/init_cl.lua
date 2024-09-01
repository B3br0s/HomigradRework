hl2coop.GetTeamName = tdm.GetTeamName

local colorSpec = ScoreboardSpec
function hl2coop.Scoreboard_Status(ply)
	local lply = LocalPlayer()
	if not lply:Alive() or lply:Team() == 1002 then return true end

	return "Неизвестно",colorSpec
end

local green = Color(0,125,0)
local white = Color(255,255,255)

function hl2coop.HUDPaint_RoundLeft(white2,time)
	local time = math.Round(roundTimeStart + roundTime - CurTime())
	local acurcetime = string.FormattedTime(time,"%02i:%02i")
	local lply = LocalPlayer()
	local name,color = hl2coop.GetTeamName(lply)

	local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        --[[if playsound then
            playsound = false
            surface.PlaySound("snd_jack_hmcd_disaster.mp3")
        end]]--
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)


        --[[surface.SetFont("HomigradFontBig")
        surface.SetTextColor(color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255)
        surface.SetTextPos(ScrW() / 2 - 40,ScrH() / 2)

        surface.DrawText("Вы " .. name)]]--
        draw.DrawText( "Вы " .. name, "HomigradFontBig", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Half Life 2", "HomigradFontBig", ScrW() / 2, ScrH() / 8, Color( 155,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        --draw.DrawText( roundTypes[roundType], "HomigradFontBig", ScrW() / 2, ScrH() / 5, Color( 55,55,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )

        if lply:Team() == 1 then
            draw.DrawText( "Ваша задача пройти Half Life 2", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 155,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
		end
        return
    end

	if time > 0 then
		draw.SimpleText("До конца раунда : ","HomigradFont",ScrW() / 2 - 200,ScrH()-25,white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText(acurcetime,"HomigradFont",ScrW() / 2 + 200,ScrH()-25,white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	end
	/*
	local time = math.Round(roundTimeStart + (roundTimeLoot or 0) - CurTime())
	local acurcetime = string.FormattedTime(time,"%02i:%02i")

	if time > 0 then
		draw.SimpleText("До спавна лута :","HomigradFont",ScrW() / 2 - 200,ScrH() - 50,white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText(acurcetime,"HomigradFont",ScrW() / 2 + 200,ScrH() - 50,white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	end
	*/
	green.a = white2.a
end

function hl2coop.PlayerClientSpawn()
	if LocalPlayer():Team() ~= 3 then return end

	showRoundInfo = CurTime() + 10
end