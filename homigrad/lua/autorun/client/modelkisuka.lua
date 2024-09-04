if CLIENT then
    concommand.Add("hg_playermodels", function()
        local frame = vgui.Create("DFrame")
        frame:SetTitle("Плеермодельки")
        frame:SetSize(500, 700)
        frame:Center()
        frame:MakePopup()

        local scrollPanel = vgui.Create("DScrollPanel", frame)
        scrollPanel:Dock(FILL)

        local iconLayout = vgui.Create("DIconLayout", scrollPanel)
        iconLayout:Dock(FILL)
        iconLayout:SetSpaceY(5)
        iconLayout:SetSpaceX(5)

        for _, modelPath in ipairs(player_manager.AllValidModels()) do
            local icon = vgui.Create("SpawnIcon", iconLayout)
            icon:SetModel(modelPath)
            icon:SetToolTip(modelPath)
            icon.DoClick = function()
                LocalPlayer():ConCommand('cl_playermodel "' .. modelPath .. '"')
                chat.AddText(Color(0, 255, 0), "Changed playermodel to: ", Color(255, 255, 255), modelPath)
            end
            iconLayout:Add(icon)
        end
    end)
end
