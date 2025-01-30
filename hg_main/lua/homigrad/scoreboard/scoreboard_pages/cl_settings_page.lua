local open = false
local panelka

hook.Add("HUDPaint","SettingsPage",function()
    if not ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false return end
    if ScoreBoard == 3 and not open then
        open = true
        local MainPanel = vgui.Create("DFrame", ScoreBoardPanel)
        MainPanel:SetSize(ScrW() / 1.15, ScrH() / 1.1)
        MainPanel:Center()
        MainPanel:SetDraggable(false)
        MainPanel:SetTitle(" ")
        MainPanel:ShowCloseButton(false)

        function MainPanel:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
        end

        panelka = MainPanel
    elseif ScoreBoard != 3 then
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
    end
end)