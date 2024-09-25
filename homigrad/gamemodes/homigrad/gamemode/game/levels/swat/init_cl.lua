swat.GetTeamName = tdm.GetTeamName

local playsound = false
local bhop
local aABASDBASDBABDSB = true
local started = false
function swat.StartRoundCL()
end

function swat.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = swat.GetTeamName(lply)
	local startRound = roundTimeStart + 5 - CurTime()

    if (roundTimeStart + roundTimeSWAT - CurTime()) <= 0 and not started == true then
        started = true
        surface.PlaySound("swatarrive.wav")
    end
    if (roundTimeStart + roundTimeSWAT - CurTime()) > 116 then
        if aABASDBASDBABDSB == true then
            aABASDBASDBABDSB = false
            started = false
            surface.PlaySound("swatuntil.wav")
            timer.Simple(5,function() aABASDBASDBABDSB = true end )
        end
    end
    
    if startRound > 0 and lply:Alive() then
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)
        draw.DrawText( "Ваша команда " .. name, "HomigradFontBig", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "SWAT", "HomigradFontBig", ScrW() / 2, ScrH() / 8, Color( 155,155,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        if name == "Полиция" then
            draw.DrawText( "Нейтрализуйте бунтующих людей, старайтесь не убивать", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 155,155,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        else
            draw.DrawText( "Забаррикадируйтесь и не дайте полиции связать/убить вас", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 155,155,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
            draw.DrawText( "У вас 2 минуты", "HomigradFontBig", ScrW() / 2, ScrH() / 1.3, Color( 155,155,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        end
        return
    end
end