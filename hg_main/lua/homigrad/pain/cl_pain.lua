local graddown = Material( "vgui/gradient-u" )
local gradup = Material( "vgui/gradient-d" )
local gradright = Material( "vgui/gradient-l" )
local gradleft = Material( "vgui/gradient-r" )
local math_Clamp = math.Clamp
local k = 0
local k4 = 0
local pulseStart = 0

hook.Add("Think","DumalkaOstalnix",function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetNWBool("suiciding") != nil then
            ply.suiciding = ply:GetNWBool("suiciding")
        end
    end
end)

hook.Add("HUDPaint","Homigrad_Pain_HUD",function()
    local ply = LocalPlayer()
    --RunConsoleCommand("slot5")
    if not ply:Alive() then if LastDeathTime < CurTime() then k = 0 ply:SetDSP(0) end return end
    
    local painlosing = ply:GetNWFloat("painlosing")
    local pain = ply:GetNWFloat("pain")
    local critical = ply:GetNWBool("crit",false)
    local incapacitated = ply:GetNWBool("incap",false)

    if painlosing > 0 then
        DrawMotionBlur(0.8,painlosing / 3,0.016)
    end

    local active = ply:GetNWBool("otrub")

    cam.Start2D()

    render.ClearStencil()

    local w,h = ScrW(),ScrH()
    k = Lerp(0.02,k,math_Clamp(ply:GetNWFloat("pain")  / 50,0,15))

    surface.SetMaterial(graddown)
    surface.SetDrawColor(0,0,0,255)
    surface.DrawTexturedRect(0,0,w,h * k)

    surface.SetMaterial(gradup)
    surface.SetDrawColor(0, 0, 0, 255 )
    surface.DrawTexturedRect(0,h - h * k,w,h * k + 1)

    surface.SetMaterial(gradright)
    surface.SetDrawColor(0,0,0,255)
    surface.DrawTexturedRect(0,0,w * k,h)

    surface.SetMaterial(gradleft)
    surface.SetDrawColor(0,0,0,255)
    surface.DrawTexturedRect(w - w * k,0,w * k + 1,h)

    if active then
        ply:SetDSP(16)

        draw.RoundedBox(0,0,0,w,h,Color(0,0,0))

        local text2 =  
			( critical and "Тебя невозможно спасти." ) or 
			( incapacitated and "Ты не поднимешься без чьей-то помощи." ) or 
			( 
				"Ты очнешься примерно через "
				..( 
                    ( pain < 60 and "несколько секунд." ) or 	
					( pain < 130 and "минуту." ) or 
					( pain < 200 and "две минуты." ) or 
					"несколько минут."
				) 
			)

        draw.SimpleText("Ты без сознания.","HOS.18",w / 2,h / 1.1,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(text2,"HOS.18",w / 2,h / 1.08,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        local pulse = ply.pulse

        if pulse ~= 0 and pulseStart + pulse * 60 < RealTime() then
            pulseStart = RealTime()

            surface.PlaySound("snd_jack_hmcd_heartpound.wav")
        end
    else
        ply:SetDSP(0)
    end

    cam.End2D()
end)