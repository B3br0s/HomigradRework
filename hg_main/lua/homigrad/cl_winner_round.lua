function WinRound(color,text1,text2,winply)
    --"homigrad/vgui/panorama/case_awarded_4_legendary_01.wav" - звук при выигрыше

    local StartTime = CurTime()

    local ContinuingTime = 8

    surface.PlaySound("homigrad/vgui/panorama/case_awarded_4_legendary_01.wav")
    
    local WinGui = vgui.Create("DFrame")
    WinGui:SetSize(812,160)
    WinGui:Center()
    local XPos = WinGui:GetX()
    WinGui:SetPos(WinGui:GetX(),ScrH() / 16)
    WinGui:ShowCloseButton(false)
    WinGui:SetTitle(" ")

    function WinGui:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(32,32,32,255))

        surface.SetDrawColor(255,255,255,40)

        surface.DrawOutlinedRect(0,0,w,h,1)

        draw.SimpleText(text1, "HS.25", 157, 40, Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        draw.SimpleText(text2, "HS.25", 157, 67, Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        
        surface.SetMaterial(Material("vgui/gradient-l"))

        surface.SetDrawColor(color.r,color.g,color.b,100)

        surface.DrawTexturedRect(0,0,w,h)
    end

    local WinAvatar = vgui.Create("AvatarImage",WinGui)
    WinAvatar:SetPos(30,30)
    WinAvatar:SetSize(100,100)
    WinAvatar:SetPlayer(((winply != NULL and winply:IsPlayer()) and winply or table.Random(player.GetAll())),64)

    function WinAvatar:Paint(w,h)
        surface.SetDrawColor(255,255,255,50)

        surface.DrawOutlinedRect(0,0,w,h,4)
    end

    hook.Add("HUDPaint","Homigrad_Win_Round",function()
        local CurrentTimeAnim = (StartTime + ContinuingTime - CurTime())
        local UpPos = 0
        local HoldPos = 160
        local WinGuiAnim = WinGui
        CurAnimPosY = CurAnimPosY or 0
        WinGuiAnim:SetSize(812,CurAnimPosY)
        if CurrentTimeAnim > 5.5 then
            CurAnimPosY = LerpFT(0.1,CurAnimPosY,HoldPos)
        elseif CurrentTimeAnim < 2 then
            CurAnimPosY = LerpFT(0.1,CurAnimPosY,UpPos)
        end

        if CurrentTimeAnim <= 0 then
            WinGuiAnim:Remove()
            hook.Remove("HUDPaint","Homigrad_Win_Round")
        end
    end)
end

net.Receive("EndRound",function()
    local color = net.ReadColor()
    local text1 = net.ReadString()
    local text2 = net.ReadString()
    local winply = net.ReadEntity()
    WinRound(color,text1,text2,winply)
end)