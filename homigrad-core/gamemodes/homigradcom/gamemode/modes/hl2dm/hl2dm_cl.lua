hl2dm = hl2dm or {}

function hl2dm.GetTeam(ply)
    if ply:Team() == 1002 then
        return hg.GetPhrase("spectator"),Color(200,200,200,255),"nothing."
    end
    local tbl = hl2dm.Teams[ply:Team()]

    local n = tbl.Name
    local c = tbl.Color
    local d = tbl.Desc
    return n,c,d
end
local posadd = 0

local gradient_d = Material("vgui/gradient-d")

local units = {
    "CMB-3560", //entropy zero
    "CMB-4821",
    "CMB-1123",
    "CMB-6005",
    "CMB-7550",
    "CMB-3098",
    "CMB-4400",
    "CMB-8662" 
}

local UnitName = " "

function hl2dm.HUDPaint()
    if !hg.ROUND_START then
        hg.ROUND_START = CurTime()
    end

    local StartTime = ((hg.ROUND_START + 7) - CurTime())

    if StartTime < 0 then
        return
    end

    local DarkMul = math.Clamp(StartTime,0,1)

    local Name,color,Desc = hl2dm.GetTeam(LocalPlayer())

    if hl2dm.Teams[LocalPlayer():Team()] and hl2dm.Teams[LocalPlayer():Team()].PrintName then
        Name = hl2dm.Teams[LocalPlayer():Team()].PrintName
    end

    color.a = (255 * DarkMul)

    local PrintName = hg.GetPhrase(Name)

    local w,h = ScrW(),ScrH()

    surface.SetDrawColor(0,0,0,220 * DarkMul)
    surface.DrawRect(0,0,w,h)

    draw.DrawText(string.format(hg.GetPhrase("you_are"),string.format(PrintName,UnitName)),"H.25",w / 2,h / 2,color,TEXT_ALIGN_CENTER)
    draw.DrawText(hl2dm.name,"H.45",w / 2,h / 8,Color(255,0,0,255 * DarkMul),TEXT_ALIGN_CENTER)
    draw.DrawText(hg.GetPhrase(Desc),"H.25",w / 2,h / 1.2,color,TEXT_ALIGN_CENTER)
end

function hl2dm.RenderScreenspaceEffects()
end

function hl2dm.RoundStart()
    hg.ROUND_START = CurTime()
    UnitName = table.Random(units)
end