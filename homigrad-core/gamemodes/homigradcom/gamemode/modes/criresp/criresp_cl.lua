criresp = criresp or {}

function criresp.GetTeam(ply)
    if ply:Team() == 1002 then
        return hg.GetPhrase("spectator"),Color(200,200,200,255),"nothing."
    end
    local tbl = criresp.Teams[ply:Team()]

    local n = tbl.Name
    local c = tbl.Color
    local d = tbl.Desc
    return n,c,d
end
local posadd = 0

local gradient_d = Material("vgui/gradient-d")

local soundplayed = false
local swatin = 0
local posadd = 0
local sw,sh = ScrW(),ScrH()

function criresp.HUDPaint()
    if !hg.ROUND_START then
        hg.ROUND_START = CurTime()
    end

    local StartTime = ((hg.ROUND_START + 7) - CurTime())

    //print(swatin > CurTime())
    //print(swatin - CurTime())

    if swatin > CurTime() then
        posadd = Lerp(FrameTime() * 5,posadd or 0, hg.ROUND_START + 7.3 < CurTime() and 0 or -sw * 0.4) 
	    local color = Color(255*-math.sin(CurTime()*3),25,255*math.sin(CurTime()*3))
	    draw.SimpleText( string.format(hg.GetPhrase("swat_arrivein"),string.FormattedTime(swatin - CurTime(), "%02i:%02i")), "hg_HomicideMedium", sw * 0.02 + posadd, sh * 0.95, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	    draw.SimpleText( string.format(hg.GetPhrase("swat_arrivein"),string.FormattedTime(swatin - CurTime(), "%02i:%02i")), "hg_HomicideMedium", (sw * 0.02) - 2 + posadd, (sh * 0.95) - 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    if StartTime < 0 then
        return
    end

    if !soundplayed then
        soundplayed = true
        surface.PlaySound("zbattle/criresp.mp3")
        surface.PlaySound("zbattle/criresp/criepmission.mp3")
    end

    local DarkMul = math.Clamp(StartTime,0,1)

    local Name,color,Desc = criresp.GetTeam(LocalPlayer())

    color.a = (255 * DarkMul)

    local PrintName = hg.GetPhrase(Name)

    local w,h = ScrW(),ScrH()

    surface.SetDrawColor(0,0,0,220 * DarkMul)
    surface.DrawRect(0,0,w,h)

    draw.DrawText(string.format(hg.GetPhrase("you_are"),PrintName),"H.25",w / 2,h / 2,color,TEXT_ALIGN_CENTER)
    draw.DrawText(criresp.name,"H.45",w / 2,h / 8,Color(255,0,0,255 * DarkMul),TEXT_ALIGN_CENTER)
    draw.DrawText(hg.GetPhrase(Desc),"H.25",w / 2,h / 1.2,color,TEXT_ALIGN_CENTER)
end

function criresp.RenderScreenspaceEffects()
end

function criresp.RoundStart()
    hg.ROUND_START = CurTime()
    soundplayed = false
    swatin = CurTime() + criresp.untilswat
end