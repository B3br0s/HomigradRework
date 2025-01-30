hook.Add("ScoreboardShow","Homigrad_ScoreBoard",function()
    if not ScoreBoard then
        ScoreBoard = 1 -- 1 - Скорборд, 2 - Инвент, 3 - Настройки
    end
    ScoreBoardPanel = vgui.Create("DFrame")
    ScoreBoardPanel:SetSize(ScrW(),ScrH())
    ScoreBoardPanel:Center()
    ScoreBoardPanel:ShowCloseButton(false)
    ScoreBoardPanel:SetTitle(" ")
    ScoreBoardPanel:MakePopup()
    ScoreBoardPanel:SetDraggable(false)
    ScoreBoardPanel:SetKeyBoardInputEnabled(false)
    function ScoreBoardPanel:Paint(w,h)
        draw.RoundedBox(0,self:GetX(),self:GetY(),w,h,Color(0,0,0,150))
        --draw.SimpleText("Homigrad Rework","HOS.18",5,h/1.01,Color(255,255,255,100),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) --не
    end
    local ScoreBoardButton = vgui.Create("DButton",ScoreBoardPanel)
    ScoreBoardButton:SetSize(100,100)
    ScoreBoardButton:SetText(" ")
    ScoreBoardButton:SetPos(ScrW() / 1.0545,ScrH() / (LocalPlayer():Alive() and 4 or 2.92))

    function ScoreBoardButton:DoClick()
        surface.PlaySound("homigrad/vgui/panorama/sidemenu_click_01.wav")
        ScoreBoard = 1
    end

    function ScoreBoardButton:Paint(w,h)
        if !self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, (ScoreBoard == 1 and Color(42, 42, 42) or Color(32,32,32)))
        else
            draw.RoundedBox(0, 0, 0, w, h, Color(38, 38, 38, 255))
        end

        draw.SimpleText("Игроки", "HS.18", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255,255,255,20)

        surface.DrawOutlinedRect(0,0,w,h,1)
    end

    local InventoryButton = vgui.Create("DButton",ScoreBoardPanel)
    InventoryButton:SetSize(100,100)
    InventoryButton:SetText(" ")
    InventoryButton:SetPos(ScrW() / 1.0545,ScrH() / 2.92 )

    function InventoryButton:DoClick()
        surface.PlaySound("homigrad/vgui/panorama/sidemenu_click_01.wav")
        ScoreBoard = 2
    end

    function InventoryButton:Paint(w,h)
        if !self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, (ScoreBoard == 2 and Color(42, 42, 42) or Color(32,32,32)))
        else
            draw.RoundedBox(0, 0, 0, w, h, Color(38, 38, 38, 255))
        end

        draw.SimpleText("Инвентарь", "HS.18", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255,255,255,20)

        surface.DrawOutlinedRect(0,0,w,h,1)
    end

    local SettingsButton = vgui.Create("DButton",ScoreBoardPanel)
    SettingsButton:SetSize(100,100)
    SettingsButton:SetText(" ")
    SettingsButton:SetPos(ScrW() / 1.0545,ScrH() / 2.305)

    function SettingsButton:DoClick()
        surface.PlaySound("homigrad/vgui/panorama/sidemenu_click_01.wav")
        ScoreBoard = 3
    end

    function SettingsButton:Paint(w,h)
        if !self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, (ScoreBoard == 3 and Color(42, 42, 42) or Color(32,32,32)))
        else
            draw.RoundedBox(0, 0, 0, w, h, Color(38, 38, 38, 255))
        end

        draw.SimpleText("Настройки", "HS.18", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255,255,255,20)

        surface.DrawOutlinedRect(0,0,w,h,1)
    end

    if not LocalPlayer():Alive() then
        InventoryButton:Remove()
        if ScoreBoard == 2 then
            ScoreBoard = 1
        end
    end
    
    return false
end)

hook.Add("ScoreboardHide","Homigrad_ScoreBoard",function()
    if IsValid(ScoreBoardPanel) then
        ScoreBoardPanel:Remove()
    end
end)