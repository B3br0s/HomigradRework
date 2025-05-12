coop = coop or {}

function coop.GetTeamName(ply)
    if ply:Team() == 1002 then
        return hg.GetPhrase("spectator"),Color(200,200,200,255),"nothing."
    end
    local tbl = coop.Teams[ply:Team()]

    if ply:GetNWBool("MistrGondon") then
        return "coop_gondon",Color(255,102,0),"coop_gondon_desc"
    end

    if !tbl then
        return "N/A",Color(255,0,0),"N/A"
    end

    local n = tbl.Name
    local c = tbl.Color
    local d = tbl.Desc
    return n,c,d
end

local posadd = 0

local gradient_d = Material("vgui/gradient-d")

local isfrozen = 0

net.Receive("coop exiting",function()
    coop.Exiting = net.ReadBool()
    coop.ExitsIn = CurTime() + 20
end)

function coop.HUDPaint()
    if !hg.ROUND_START then
        hg.ROUND_START = CurTime()
    end
    local w,h = ScrW(),ScrH()

    local StartTime = ((hg.ROUND_START + 7) - CurTime())

    if !LocalPlayer():IsFrozen() then
        isfrozen = 0

        if coop.Exiting then
            draw.DrawText(string.format(hg.GetPhrase("coop_endsin"),math.Round(coop.ExitsIn - CurTime(),2)),"hg_HomicideSmalles",w / 2,h / 7,Color(255,255,255),TEXT_ALIGN_CENTER)
        end
    else
        if coop.Exiting then
            isfrozen = LerpFT(0.08,isfrozen,1)
            
            draw.RoundedBox(0,0,0,w,h,Color(25,25,25,230 * isfrozen))
            
            draw.SimpleText(string.format(hg.GetPhrase("coop_endsin"),math.Round(coop.ExitsIn - CurTime(),2)),"hg_HomicideMediumLarge",w/2,h/2,Color(255,255,255,255 * isfrozen),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    if hg.ROUND_START + coop.TimeRoundEnds - CurTime() > 0 then
    local sw,sh = ScrW(),ScrH()

    local text = string.format(hg.GetPhrase("levels_endin"),string.FormattedTime(hg.ROUND_START + coop.TimeRoundEnds - CurTime(), "%02i:%02i"	))

    draw.SimpleText( text, "hg_HomicideSmalles", sw / 2,sh / 1.01, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end

    if StartTime < 0 then
        return
    end

    local DarkMul = math.Clamp(StartTime,0,1)

    local Name,Color,Desc = coop.GetTeamName(LocalPlayer())

    Desc = (LocalPlayer():GetNWBool("MistrGondon") and "coop_gondon_desc" or Desc)

    Color.a = (255 * DarkMul)

    local PrintName = (LocalPlayer():GetNWBool("MistrGondon") and hg.GetPhrase("coop_gondon") or hg.GetPhrase(Name))

    surface.SetDrawColor(0,0,0,220 * DarkMul)
    surface.DrawRect(0,0,w,h)

    draw.DrawText(string.format(hg.GetPhrase("you_are"),PrintName),"H.25",w / 2,h / 2,Color,TEXT_ALIGN_CENTER)
    draw.DrawText(coop.name,"H.45",w / 2,h / 8,Color,TEXT_ALIGN_CENTER)
    draw.DrawText(hg.GetPhrase(Desc),"H.25",w / 2,h / 1.2,Color,TEXT_ALIGN_CENTER)
end

function coop.RenderScreenspaceEffects()
end

function coop.RoundStart()
    hg.ROUND_START = CurTime()
    coop.Exiting = false
end