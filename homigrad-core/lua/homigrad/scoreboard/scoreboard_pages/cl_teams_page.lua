local open = false
local panelka
local open_gavno = 0

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

    return FrameShit
end

function CreateModel(p,t)
    local t_mdl = p:Add("DModelPanel")
    t_mdl:SetModel(t != 1002 and "models/player/group02/male_08.mdl" or "models/player/gman_high.mdl")
    t_mdl:SetSize(p:GetWide(),p:GetTall())
    t_mdl:SetKeyboardInputEnabled(false)
    t_mdl:SetMouseInputEnabled(false)
    t_mdl:GetEntity().GetPlayerColor = function()
        return (((TableRound and TableRound().Teams) and TableRound().Teams[t]) and TableRound().Teams[t].Color:ToVector() or Color(100,100,100):ToVector())
    end
    if (TableRound and TableRound().Teams) and TableRound().Teams[t] and TableRound().Teams[t].Model then
        t_mdl:SetModel(TableRound().Teams[t].Model)
    end
    local zaebal = 1
    function t_mdl:LayoutEntity(ent)
        if p:IsHovered() then
            zaebal = LerpFT(0.2,zaebal,1.2)
        else
            zaebal = LerpFT(0.2,zaebal,1)
        end
        local pos,ang = ent:GetBonePosition(0)
        t_mdl:SetCamPos(Vector(60 / zaebal,0,pos.z + 6))
        self:SetLookAt(pos)
        
        ent:SetAngles(Angle(0,0,0))
    end
end

hook.Add("HUDPaint","Teams_Page",function()
    if not hg.ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false open_gavno = 1 return end
    if hg.ScoreBoard == 2 and !hg.score_closing then
        open_gavno = LerpFT(0.2,open_gavno,0)
    else
        open_gavno = LerpFT(0.2,open_gavno,1)
    end
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

        local t1 = AddButtonCustom(MainFrame,hg.GetPhrase((TableRound().Teams[1].Name or "N/A")),{x=200,y=MainFrame:GetTall()},0,function() surface.PlaySound("homigrad/vgui/menu_accept.wav") net.Start("hg changeteam") net.WriteFloat(1) net.SendToServer() end,TableRound().Teams[1].Color)
        local spect = AddButtonCustom(MainFrame,hg.GetPhrase("spectator"),{x=200,y=MainFrame:GetTall()},1,function() surface.PlaySound("homigrad/vgui/menu_accept.wav") net.Start("hg changeteam") net.WriteFloat(1002) net.SendToServer() end,Color(200,200,200))
        local t2 = AddButtonCustom(MainFrame,hg.GetPhrase((TableRound().Teams[2].Name or "N/A")),{x=200,y=MainFrame:GetTall()},2,function() surface.PlaySound("homigrad/vgui/menu_accept.wav") net.Start("hg changeteam") net.WriteFloat(2) net.SendToServer() end,TableRound().Teams[2].Color)

        CreateModel(t1,1)
        CreateModel(spect,1002)
        CreateModel(t2,2)

        local cx = MainFrame:GetX()
        
        function MainFrame:Paint(w, h)
            MainFrame:SetX(cx+((SW/1.4)*open_gavno))
        end

        panelka = MainPanel
    elseif hg.ScoreBoard != 2 then
        open = false
        if IsValid(panelka) and open_gavno >= 0.95 then
            panelka:Remove()
        end
    end
end)