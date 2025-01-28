local graddown = Material( "vgui/gradient-u" )
local gradup = Material( "vgui/gradient-d" )
local gradright = Material( "vgui/gradient-l" )
local gradleft = Material( "vgui/gradient-r" )
local math_Clamp = math.Clamp
local k = 0
local k4 = 0
local pulseStart = 0

net.Receive("bcst_org",function()
    local org = net.ReadTable()
    if org.owner != LocalPlayer() then return end
    PrintTable(org)
    LocalPlayer().organism = org
end)

hook.Add("HUDPaint","Homigrad_Pain_HUD",function()
    local ply = LocalPlayer()
    if not ply:Alive() then k = 0 return end
    
    local painlosing = ply.organism.painlosing

    if painlosing > 0 then
        DrawMotionBlur(0.8,painlosing / 3,0.016)
    end

    local active = ply.organism.otrub

    cam.Start2D()

    render.ClearStencil()

    if active then
        ply:SetDSP(16)

        surface.SetDrawColor(0,0,0,255)
        surface.DrawRect(0,0,ScrW(),ScrH())

        local pulse = ply.organism.pulse

        if pulse ~= 0 and pulseStart + pulse * 60 < RealTime() then
            pulseStart = RealTime()

            surface.PlaySound("snd_jack_hmcd_heartpound.wav")
        end
    else
        ply:SetDSP(0)
    end

    local w,h = ScrW(),ScrH()
    k = Lerp(0.02,k,math_Clamp(ply.organism.pain / 45 * (active and 4 or 1),0,15))

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

    cam.End2D()
end)