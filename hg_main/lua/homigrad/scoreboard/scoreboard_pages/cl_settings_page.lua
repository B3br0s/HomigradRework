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
            draw.RoundedBox(12, 0, 0, w, h, Color(0, 0, 0, 58))

            draw.SimpleText("Анимации затворов","HS.18",30,68)
        end

        local DWR_SOUND_SLIDER = vgui.Create("DNumSlider",MainPanel)
        DWR_SOUND_SLIDER:SetSize(MainPanel:GetWide() / 2.5,MainPanel:GetTall() / 14)
        DWR_SOUND_SLIDER:SetPos(0,0)
        DWR_SOUND_SLIDER:SetDefaultValue(cl_dwr_volume / 100)
        DWR_SOUND_SLIDER:SetValue(cl_dwr_volume / 100)
        DWR_SOUND_SLIDER:SetMinMax(0,1)

        function DWR_SOUND_SLIDER:OnValueChanged(value)
            cl_dwr_volume = value * 100
        end

        function DWR_SOUND_SLIDER:Paint(w,h)
            draw.SimpleText("Громкость реверберации DWR","HS.18",30,28)
        end

        local BOLT_ANIMS = vgui.Create("DCheckBox",MainPanel)
        BOLT_ANIMS:SetSize(MainPanel:GetTall() / 50,MainPanel:GetTall() / 50)
        BOLT_ANIMS:SetPos(MainPanel:GetWide() / 8.8,MainPanel:GetTall() / 14)
        BOLT_ANIMS:SetChecked(GetConVar("hg_boltanims"):GetBool())

        function BOLT_ANIMS:OnChange(value)

            GetConVar("hg_boltanims"):SetBool(value)
        end

        panelka = MainPanel
    elseif ScoreBoard != 3 then
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
    end
end)