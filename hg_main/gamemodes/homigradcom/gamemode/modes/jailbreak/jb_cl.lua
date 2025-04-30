jb = jb or {}

function jb.GetTeam(ply)
    if ply:Team() == 1002 then
        return hg.GetPhrase("spectator"),Color(200,200,200,255),"nothing."
    end
    local tbl = jb.Teams[ply:Team()]

    local n = tbl.Name
    local c = tbl.Color
    local d = tbl.Desc
    return n,c,d
end
local posadd = 0

local gradient_d = Material("vgui/gradient-d")


function jb.HUDPaint()
    if !hg.ROUND_START then
        hg.ROUND_START = CurTime()
    end
    local StartTime = ((hg.ROUND_START + 7) - CurTime())

    if StartTime < 0 then
        return
    end

    local DarkMul = math.Clamp(StartTime,0,1)

    local Name,Color,Desc = jb.GetTeam(LocalPlayer())

    Color.a = (255 * DarkMul)

    local PrintName = hg.GetPhrase(Name)

    local w,h = ScrW(),ScrH()

    surface.SetDrawColor(0,0,0,220 * DarkMul)
    surface.DrawRect(0,0,w,h)

    draw.DrawText(string.format(hg.GetPhrase("you_are"),PrintName),"H.25",w / 2,h / 2,Color,TEXT_ALIGN_CENTER)
    draw.DrawText(jb.name,"H.45",w / 2,h / 8,Color,TEXT_ALIGN_CENTER)
    draw.DrawText(hg.GetPhrase(Desc),"H.25",w / 2,h / 1.2,Color,TEXT_ALIGN_CENTER)
end

function jb.RenderScreenspaceEffects()
end

function jb.RoundStart()
    hg.ROUND_START = CurTime()
end