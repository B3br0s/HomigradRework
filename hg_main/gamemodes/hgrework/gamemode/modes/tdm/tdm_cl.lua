tdm = tdm or {}

function tdm.GetTeam(ply)
    local tbl = tdm.Teams[ply:Team()]

    local n = tbl.Name
    local c = tbl.Color
    local d = tbl.Desc
    return n,c,d
end
local posadd = 0

local gradient_d = Material("vgui/gradient-d")


function tdm.HUDPaint()
    if !hg.ROUND_START then
        hg.ROUND_START = CurTime()
    end

    local StartTime = ((hg.ROUND_START + 7) - CurTime())

    if StartTime < 0 then
        return
    end

    local DarkMul = math.Clamp(StartTime,0,1)

    local Name,color,Desc = tdm.GetTeam(LocalPlayer())

    color.a = (255 * DarkMul)

    local PrintName = hg.GetPhrase(Name)

    local w,h = ScrW(),ScrH()

    surface.SetDrawColor(0,0,0,220 * DarkMul)
    surface.DrawRect(0,0,w,h)

    draw.DrawText(string.format(hg.GetPhrase("you_are"),PrintName),"H.25",w / 2,h / 2,color,TEXT_ALIGN_CENTER)
    draw.DrawText(tdm.name,"H.45",w / 2,h / 8,Color(255,0,0,255 * DarkMul),TEXT_ALIGN_CENTER)
    draw.DrawText(hg.GetPhrase(Desc),"H.25",w / 2,h / 1.2,color,TEXT_ALIGN_CENTER)
end

function tdm.RenderScreenspaceEffects()
end

function tdm.RoundStart()
    hg.ROUND_START = CurTime()
end