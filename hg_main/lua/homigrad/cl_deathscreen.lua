LastDeathTime = 0
local Reason = ""
local KilledBy = NULL
local Attacker = NULL
local LastHit = ""
local LerpedMul = 0
local lply = LocalPlayer()

local graddown = Material( "vgui/gradient-u" )
local gradup = Material( "vgui/gradient-d" )
local gradright = Material( "vgui/gradient-l" )
local gradleft = Material( "vgui/gradient-r" )

net.Receive("DeathScreen",function()
    Reason = lply:GetNWString("KillReason")
    KilledBy = lply:GetNWEntity("LastInflictor")
    Attacker = lply:GetNWEntity("LastAttacker")
    LastHit = lply:GetNWString("LastHitBone")

    LerpedMul = 1

    LastDeathTime = CurTime() + 5

    surface.PlaySound("homigrad/vgui/csgo_ui_crate_open.wav")
end)

local nothing = {
    ["dead_hungry"] = true,
    ["dead_neck"] = true,
    ["dead_necksnap"] = true,
    ["dead_world"] = true,
    ["dead_headExplode"] = true,
    ["dead_fullgib"] = true,
    ["dead_unknown"] = true,
    //["dead_burn"] = true,
    ["dead_kys"] = true,
    ["dead_adrenaline"] = true,
    ["dead_painlosing"] = true,
    //["dead_blood"] = true,
    //["dead_pain"] = true,

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

        draw.SimpleText(hg.GetPhrase("Dead"),"HS.45",ScrW() / 2 + (math.random(-35,35) * LerpedMul),ScrH() / 2--[[.5]] + (math.random(-35,35) * LerpedMul),Color(255 * Plus,255 * Plus,255 * Plus,255 * Minus * Plus),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        //draw.SimpleText(string.format(hg.GetPhrase(Reason),LocalPlayer():GetName()),"HOS.25",ScrW() / 2,ScrH() / 1.5,Color(255,255,255,255 * Minus * Plus),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        if !nothing[Reason] then
        draw.SimpleText(hg.GetPhrase("died").." "..hg.GetPhrase("in").." "..hg.GetPhrase("kill_"..LastHit),"HOS.25",ScrW() / 2,ScrH() / 1.45,Color(255,255,255,255 * Minus * Plus),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        if Attacker != LocalPlayer() and IsValid(Attacker) and Attacker != NULL then
            local deathMessage
            local attacker = lply:GetNWEntity("LastAttacker")
            local attackerName
                    
            if IsValid(attacker) then
                attackerName = attacker.Name and attacker:Name() or attacker:GetClass()
                deathMessage = hg.GetPhrase("died_by") .. " " .. attackerName
                
                if IsValid(KilledBy) then
                    local weaponName
                    if KilledBy.GetPrintName ~= nil then
                        weaponName = KilledBy:GetPrintName()
                    elseif attacker:IsPlayer() and IsValid(attacker:GetActiveWeapon()) then
                        weaponName = KilledBy:GetActiveWeapon():GetPrintName()
                    else
                        weaponName = KilledBy:GetClass()
                    end
                    deathMessage = deathMessage .. " " .. hg.GetPhrase("kill_by_wep") .. " " .. weaponName
                end
            else
                deathMessage = hg.GetPhrase("dead_unknown")
            end
            
            draw.SimpleText(
                deathMessage,
                "HOS.25",
                ScrW() / 2,
                ScrH() / 3.5,
                Color(255, 255, 255, 255 * Minus * Plus),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )
        elseif IsValid(Attacker) and Attacker != NULL then
            draw.SimpleText(hg.GetPhrase("dead_kys"),"HOS.25",ScrW() / 2,ScrH() / 3.5,Color(255,255,255,255 * Minus * Plus),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(hg.GetPhrase("died_by").." "..tostring(Entity(0)),"HOS.25",ScrW() / 2,ScrH() / 3.5,Color(255,255,255,255 * Minus * Plus),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
        end
    end
end)