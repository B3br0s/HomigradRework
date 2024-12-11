table.insert(LevelList,"dm")
dm = {}
dm.Name = "Death Match"
dm.LoadScreenTime = 5.5
dm.CantFight = 30

dm.RoundRandomDefalut = 1
dm.NoSelectRandom = true

local red = Color(155,155,255)

function dm.GetTeamName(ply)
    local teamID = ply:Team()

     if teamID == 1 then return "Боец",red end
end

function dm.StartRound(data)
    team.SetColor(1,red)
    team.SetColor(2,blue)
    team.SetColor(1,green)

    game.CleanUpMap(false)

    if CLIENT then
        roundTimeStart = data[1]
        roundTime = data[2]
        dm.StartRoundCL()

        return
    end

    return dm.StartRoundSV()
end

if SERVER then return end

local nigger = Color(0,0,0)
local red = Color(255,0,0)

local kill = 4

local white,red = Color(255,255,255),Color(255,0,0)

local fuck,fuckLerp = 0,0


local playsound = false
function dm.StartRoundCL()
    playsound = true
end

function dm.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
    local name, color = dm.GetTeamName(lply)

    local startRound = roundTimeStart + 5 - CurTime()
    local CFT = roundTimeStart + dm.CantFight - CurTime()
    local cantFightTime = math.max(0, CFT)

    if cantFightTime > 0 and lply:Alive() then
    draw.DrawText(string.format("%.0f", cantFightTime), "MersText2", ScrW() / 2, ScrH() / 11, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            --surface.PlaySound("music_themes/dm/dm.wav")
        end
        lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0.5)

        draw.DrawText("Вы " .. name, "MersText2", ScrW() / 2, ScrH() / 2, Color(color.r, color.g, color.b, math.Clamp(startRound - 0.5, 0, 1) * 255), TEXT_ALIGN_CENTER)
        draw.DrawText("Death Match", "MersHead1", ScrW() / 2, ScrH() / 8, Color(255, 0, 0, math.Clamp(startRound - 0.5, 0, 1) * 255), TEXT_ALIGN_CENTER)
        return
    end
end

net.Receive("dm die",function()
    timeStartAnyDeath = CurTime()
end)

function dm.CanUseSpectateHUD()
    return false
end

dm.RoundRandomDefalut = 3