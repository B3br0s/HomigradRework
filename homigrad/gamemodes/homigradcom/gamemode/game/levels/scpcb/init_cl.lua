

local colorSpec = ScoreboardSpec
function scpcb.Scoreboard_Status(ply)
	local lply = LocalPlayer()
	if not lply:Alive() or lply:Team() == 1002 then return true end

	return "Неизвестно",colorSpec
end

local green = Color(0,125,0)
local white = Color(255,255,255)

net.Receive("SCPRoleGet",function()
	local entity = net.ReadEntity()
	local role = net.ReadString()
	local color = net.ReadColor()

	entity.RoleColor = color
	entity.Role = role
end)

function scpcb.StartRoundCL()
	playsound = true
end

function scpcb.HUDPaint_RoundLeft(white2,time)
	local time = math.Round(roundTimeStart + roundTime - CurTime())
	local acurcetime = string.FormattedTime(time,"%02i:%02i")
	local lply = LocalPlayer()
	local name,color = scpcb.GetTeamName(lply)

	local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
			surface.PlaySound("scp/intro.wav")
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)

        draw.DrawText( "Вы " .. name, "MersText2", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Breach | S.C.P", "MersHead1", ScrW() / 2, ScrH() / 8, Color( 185, 0, 0,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        
		if lply:Team() == 1 then
            draw.DrawText( "Ваша задача убить весь персонал комплекса.", "MersRadial", ScrW() / 2, ScrH() / 1.2, Color( 155,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        elseif lply:Team() == 2 then
            draw.DrawText( "Кооперируйтесь с Повстанцами Хаоса \n Старайтесь не контактировать с персоналом комплекса.", "MersRadial", ScrW() / 2, ScrH() / 1.2, Color( 55,155,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
		elseif lply:Team() == 3 then
            draw.DrawText( "Кооперируйтесь с Охраной Комплекса и М.О.Г \n Старайтесь не контактировать с объектами SCP и Д-Классом.", "MersRadial", ScrW() / 2, ScrH() / 1.2, Color( 55,155,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
		end
		return
    end

	if time <= 0 then
		
	end
	green.a = white2.a
end

function scpcb.PlayerClientSpawn()
	if LocalPlayer():Team() ~= 3 then return end

	showRoundInfo = CurTime() + 10
end