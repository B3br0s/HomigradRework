hunter = hunter or {}

function hunter.GetTeam(ply)
    if ply:Team() == 1002 then
        return hg.GetPhrase("spectator"),Color(200,200,200,255),"nothing."
    end
    local tbl = hunter.Teams[ply:Team()]

    local n = tbl.Name
    local c = tbl.Color
    local d = tbl.Desc
    return n,c,d
end
local posadd = 0

local gradient_d = Material("vgui/gradient-d")


function hunter.HUDPaint()
    if !hg.ROUND_START then
        hg.ROUND_START = CurTime()
    end
    local StartTime = ((hg.ROUND_START + 7) - CurTime())

    if hg.ROUND_START + 120 - CurTime() > 0 then
    local sw,sh = ScrW(),ScrH()
    local timeuntilshit = 1// * (hg.ROUND_START + 120 - CurTime()) / (LocalPlayer():Team() == 2 and 180 or 90)

    local text = string.format(hg.GetPhrase("swat_arrivein"),string.FormattedTime(hg.ROUND_START + 120 - CurTime(), "%02i:%02i"	))

    /*surface.SetFont("hg_HomicideMedium")
	local tw, th = surface.GetTextSize(text)
    local size = 32

    local x,y = sw * 0.127, sh * 0.95

	surface.SetDrawColor(255, 0, 0, 255 * 0.5)
	surface.SetMaterial(gradient_d)
	surface.DrawTexturedRect(x - size / 2 - tw / 2, y - th / 2, size + tw, th)

    local barWidth = math.Clamp((hg.ROUND_START + 120 - CurTime()) / 120 * (size + tw), 0,size + tw)
    local barcolor = ((hg.ROUND_START + 120 - CurTime()) / 120) * 255

	surface.SetDrawColor(255, barcolor, barcolor, 255)
	surface.DrawRect(x - barWidth / 2, y + th / 1.8, barWidth, ScreenScale(1))*/
    
    draw.SimpleText( text, "hg_HomicideMedium", sw * 0.02, sh * 0.95, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    if StartTime < 0 then
        return
    end

    local DarkMul = math.Clamp(StartTime,0,1)

    local Name,Color,Desc = hunter.GetTeam(LocalPlayer())

    Color.a = (255 * DarkMul)

    local PrintName = hg.GetPhrase(Name)

    local w,h = ScrW(),ScrH()

    surface.SetDrawColor(0,0,0,220 * DarkMul)
    surface.DrawRect(0,0,w,h)

    draw.DrawText(string.format(hg.GetPhrase("you_are"),PrintName),"H.25",w / 2,h / 2,Color,TEXT_ALIGN_CENTER)
    draw.DrawText(hunter.name,"H.45",w / 2,h / 8,Color,TEXT_ALIGN_CENTER)
    draw.DrawText(hg.GetPhrase(Desc),"H.25",w / 2,h / 1.2,Color,TEXT_ALIGN_CENTER)
end

function hunter.RenderScreenspaceEffects()
end

function hunter.RoundStart()
    hg.ROUND_START = CurTime()
end