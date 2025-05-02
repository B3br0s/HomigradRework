local open = false
local panelka

function AddFrame(Parent,Text,SizeXY,DockTo,size)
    local FrameShit = Parent:Add("hg_frame")
    FrameShit:SetSize(SizeXY.x,SizeXY.y)
    FrameShit:SetText(" ")
    FrameShit:Dock(DockTo)
    FrameShit:DockMargin(0,0,0,0)
    FrameShit:Center()
    FrameShit:SetPos(0,0)
    local wshit,hshit = FrameShit:GetSize()
    local uhh = 0

    /*function FrameShit:Paint(w,h)
        if !self:IsHovered() then
            uhh = LerpFT(0.2,uhh,1.3)
            draw.RoundedBox(0, 0, 0, w, h, Color(32,32,32))
        else
            uhh = LerpFT(0.2,uhh,1)
            draw.RoundedBox(0, 0, 0, w, h, Color(38, 38, 38, 255))
        end

        self:SetSize(wshit * uhh,hshit * uhh)

        draw.SimpleText(Text, "HS.18", w / 2, h / 1.1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(100,100,100,75)
        surface.DrawOutlinedRect(1,1,w,h,1)
        surface.DrawOutlinedRect(-1,-1,w,h,1)
        surface.SetDrawColor(100,100,100,5)
        surface.DrawOutlinedRect(2,2,w,h,1)
        surface.DrawOutlinedRect(-2,-2,w,h,1)
    end*/
end

function AddButtonCustom(Parent,Text,size,number,func,clr)
    local FrameShit = Parent:Add("hg_button")
    FrameShit:SetSize(size.x,size.y)
    FrameShit:SetText(" ")
    FrameShit:Center()
    FrameShit:SetPos(0 + (FrameShit:GetWide() * 1.5) * number,0)
    //FrameShit:SetDraggable(false)
    //FrameShit:SetTitle(" ")
    //FrameShit:ShowCloseButton(false)
    FrameShit.LowerText = Text

    Parent:SetWide((FrameShit:GetWide() * 1.335) * (1 + number))
    Parent:Center()

    FrameShit.DoClick = func
    FrameShit.GradColor = clr
end

hook.Add("HUDPaint","Teams_Page",function()
    if not hg.ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false return end
    if hg.ScoreBoard == 2 and not open then
        open = true
        local MainPanel = vgui.Create("DFrame", ScoreBoardPanel)
        MainPanel:SetSize(ScrW(), ScrH() / 1.15)
        MainPanel:Center()
        MainPanel:SetDraggable(false)
        MainPanel:SetTitle(" ")
        MainPanel:ShowCloseButton(false)
        //MainPanel:SetMouseInputEnabled(false)

        function MainPanel:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        local MainFrame = vgui.Create("DFrame",MainPanel)
        MainFrame:SetSize(ScrW() / 2,ScrH() / 3)
        MainFrame:Center()
        MainFrame:SetDraggable(false)
        MainFrame:SetTitle(" ")
        MainFrame:ShowCloseButton(false)

        function MainFrame:Paint(w, h)
            /*draw.RoundedBox(0, 0, 0, w, h, Color(22, 22, 22, 200))
            
            surface.SetDrawColor(100,100,100,75)
            surface.DrawOutlinedRect(1,1,w,h,1)
            surface.DrawOutlinedRect(-1,-1,w,h,1)
            surface.SetDrawColor(100,100,100,5)
            surface.DrawOutlinedRect(2,2,w,h,1)
            surface.DrawOutlinedRect(-2,-2,w,h,1)*/
        end

        AddButtonCustom(MainFrame,hg.GetPhrase((TableRound().Teams[1].Name or "N/A")),{x=200,y=MainFrame:GetTall()},0,function() surface.PlaySound("homigrad/vgui/menu_accept.wav") net.Start("hg changeteam") net.WriteFloat(1) net.SendToServer() end,TableRound().Teams[1].Color)
        AddButtonCustom(MainFrame,hg.GetPhrase("spectator"),{x=200,y=MainFrame:GetTall()},1,function() surface.PlaySound("homigrad/vgui/menu_accept.wav") net.Start("hg changeteam") net.WriteFloat(1002) net.SendToServer() end,Color(200,200,200))
        AddButtonCustom(MainFrame,hg.GetPhrase((TableRound().Teams[2].Name or "N/A")),{x=200,y=MainFrame:GetTall()},2,function() surface.PlaySound("homigrad/vgui/menu_accept.wav") net.Start("hg changeteam") net.WriteFloat(2) net.SendToServer() end,TableRound().Teams[2].Color)

        panelka = MainPanel
    elseif hg.ScoreBoard != 2 then
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
    end
end)