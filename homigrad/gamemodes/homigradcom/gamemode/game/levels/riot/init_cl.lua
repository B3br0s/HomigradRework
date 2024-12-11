riot.GetTeamName = tdm.GetTeamName

local playsound = false
local bhop
function riot.StartRoundCL()
end


function riot.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = riot.GetTeamName(lply)

	local startRound = roundTimeStart + 5 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)
        draw.DrawText( "You are an " .. name, "MersText2", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "RIOT", "MersHead1", ScrW() / 2, ScrH() / 8, Color( 0, 89, 255,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        if name == "Police" then
            draw.DrawText( "Нейтрализуйте беспорядки, старайтесь не убивать людей", "MersRadial", ScrW() / 2, ScrH() / 1.2, Color( 136,155,172,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        else
            draw.DrawText( "Сохраняйте свои права! Уничтожьте всех тех, кто вас замедлит!", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color(168,94,94,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        end
        return
    end

    --draw.SimpleText(acurcetime,"HomigradFont",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end