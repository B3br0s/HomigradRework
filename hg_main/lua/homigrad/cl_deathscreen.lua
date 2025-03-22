LastDeathTime = 0
local Reason = ""
local KilledBy = NULL
local Attacker = NULL
local LastHit = ""
local LerpedMul = 0

local graddown = Material( "vgui/gradient-u" )
local gradup = Material( "vgui/gradient-d" )
local gradright = Material( "vgui/gradient-l" )
local gradleft = Material( "vgui/gradient-r" )

net.Receive("DeathScreen",function()
    Reason = net.ReadString()
    KilledBy = net.ReadEntity()
    Attacker = net.ReadEntity()
    LastHit = net.ReadString()

    LerpedMul = 1

    LastDeathTime = CurTime() + 5
end)

local TransReason = {
    ["NeckSnap"] = "Твоя шея была свёрнута.",
    ["Neck"] = "Твоя шея была сломана.",
    ["Fall"] = "Ты умер от падения.",
    ["Crush"] = "Ты умер от столкновения.",
    ["FullGib"] = "Тебя расплющило",
    ["HeadGib"] = "Твоя голова была расплющена всмятку.",
    ["HeadSmash"] = "Твоя голова была расплющена ближним оружием.",
    ["Shot"] = "Ты умер от пулевого ранения.",
    ["BuckShot"] = "Ты умер от ранения дробью.",
    ["Exploded"] = "Ты умер от взрыва.",
    ["Beated"] = "Тебя избили до-смерти.",
    ["Stabbed"] = "Тебя зарезали до-смерти.",
    ["BurnedToDeath"] = "Ты сгорел до-смерти.",
    [" "] = "Ты умер магическим образом."
}

local NoAttacker = {
    ["NeckSnap"] = true,
    ["FullGib"] = true,
    ["HeadGib"] = true
}

hook.Add("HUDPaint","Death_Screen",function()
    if LastDeathTime > CurTime() and !LocalPlayer():Alive() then
        if (LastDeathTime - CurTime()) < 0.1 then
            LocalPlayer():ScreenFade(SCREENFADE.IN,Color(0,0,0),1,1)
        end
        if !LocalPlayer():Alive() and IsValid(LocalPlayer():GetNWEntity("FakeRagdoll")) then
            LocalPlayer():SetDSP(31)
        elseif !LocalPlayer():Alive() then
            LocalPlayer():SetDSP(0)
        end
        local Minus = math.Clamp(LastDeathTime - CurTime(),0,1)
        local Minus3 = math.Clamp(LastDeathTime - CurTime(),0,5)
        local Plus = (0.8 - math.Clamp(LastDeathTime - (CurTime() + 3.5),0,1))
        draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(0,0,0,250 * Minus * Plus))

        LerpedMul = LerpFT(0.01,LerpedMul,0)

        surface.SetMaterial(graddown)
        surface.SetDrawColor(0,0,0,255)
        surface.DrawTexturedRect(0,0,ScrW(),ScrH() * Plus)
    
        surface.SetMaterial(gradup)
        surface.SetDrawColor(0, 0, 0, 255 )
        surface.DrawTexturedRect(0,ScrH() - ScrH() * Plus,ScrW(),ScrH() * Plus + 1)
    
        surface.SetMaterial(gradright)
        surface.SetDrawColor(0,0,0,255)
        surface.DrawTexturedRect(0,0,ScrW() * Plus,ScrH())
    
        surface.SetMaterial(gradleft)
        surface.SetDrawColor(0,0,0,255)
        surface.DrawTexturedRect(ScrW() - ScrW() * Plus,0,ScrW() * Plus + 1,ScrH())    

        draw.SimpleText("МЁРТВ","HS.45",ScrW() / 2 + (math.random(-35,35) * LerpedMul),ScrH() / 2--[[.5]] + (math.random(-35,35) * LerpedMul),Color(255 * Plus,255 * Plus,255 * Plus,255 * Minus * Plus),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        draw.SimpleText(TransReason[Reason],"HOS.25",ScrW() / 2,ScrH() / 1.5,Color(255,255,255,255 * Minus * Plus),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        if !NoAttacker[Reason] then
        draw.SimpleText(((IsValid(Attacker) and Attacker != LocalPlayer()) and "Тебя убили в " or "Ты умер от удара в ")..LastHit,"HOS.25",ScrW() / 2,ScrH() / 1.45,Color(255,255,255,255 * Minus * Plus),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
        if Attacker != LocalPlayer() then
            draw.SimpleText("Тебя убил - ","HOS.25",ScrW() / 2.1,ScrH() / 3.5,Color(255,255,255,255 * Minus * Plus),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
            draw.SimpleText(tostring((Attacker:IsPlayer() and Attacker:Name() or Attacker:GetClass())),"HOS.25",ScrW() / 2.1,ScrH() / 3.5,Color(255,255,255,255 * Minus * Plus),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("Ты убил сам себя","HOS.25",ScrW() / 2,ScrH() / 3.5,Color(255,255,255,255 * Minus * Plus),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
end)