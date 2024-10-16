gangrazborki.GetTeamName = tdm.GetTeamName

local playsound = false
local bhop
function gangrazborki.StartRoundCL()
    playsound = true
end


function gangrazborki.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = gangrazborki.GetTeamName(lply)

	local startRound = roundTimeStart + 8 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("snd_b3_makhabat_round.wav")
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)
        draw.DrawText( "Вы участник банды " .. name, "HomigradFontBig", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Разборки Гетто", "HomigradFontBig", ScrW() / 2, ScrH() / 3, Color( 255,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        if name == "Crips" then
            draw.DrawText( "Защитите свою территорию.", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 255,255,255,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        else
            draw.DrawText( "Захватите территорию Crips.", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 255,255,255,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        end
        return
    end

    --draw.SimpleText(acurcetime,"HomigradFont",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end