construct.GetTeamName = tdm.GetTeamName

local colorSpec = ScoreboardSpec
function construct.Scoreboard_Status(ply)
	local lply = LocalPlayer()
	if not lply:Alive() or lply:Team() == 1002 then return true end

	return "Неизвестно",colorSpec
end

local green = Color(0,125,0)
local white = Color(255,255,255)

function construct.HUDPaint_RoundLeft(white2,time)
	local time = math.Round(roundTimeStart + roundTime - CurTime())
	local acurcetime = string.FormattedTime(time,"%02i:%02i")
	local lply = LocalPlayer()
	local name,color = construct.GetTeamName(lply)

	local startRound = roundTimeStart + 3 - CurTime()
    if startRound > 0 and lply:Alive() then
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)

        draw.DrawText( "Construct", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 55,155,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        return
    end

	if time > 0 then
		draw.SimpleText("До конца раунда : ","HomigradFont",ScrW() / 2 - 200,ScrH()-25,white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText(acurcetime,"HomigradFont",ScrW() / 2 + 200,ScrH()-25,white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	end
	green.a = white2.a
end

function construct.PlayerClientSpawn()
	if LocalPlayer():Team() ~= 3 then return end

	showRoundInfo = CurTime() + 3
end