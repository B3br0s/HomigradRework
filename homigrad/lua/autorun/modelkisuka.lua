if SERVER then
    AddCSLuaFile()
end

if CLIENT then
    local function ShowPlayerModels()
        local frame = vgui.Create("DFrame")
        frame:SetTitle("Плеермодельки")
        frame:SetSize(435, 600)
        frame:Center()
        frame:MakePopup()

        local scrollPanel = vgui.Create("DScrollPanel", frame)
        scrollPanel:Dock(FILL)

        local iconLayout = vgui.Create("DIconLayout", scrollPanel)
        iconLayout:Dock(FILL)
        iconLayout:SetSpaceY(5)
        iconLayout:SetSpaceX(5)


        local playerModels = list.Get("PlayerOptionsModel")
        

        local defaultModels = list.Get("PlayerChoices")

        for modelName, modelPath in pairs(defaultModels) do
            playerModels[modelName] = modelPath
        end

        for modelName, modelPath in pairs(playerModels) do
            local modelIcon = iconLayout:Add("SpawnIcon")
            modelIcon:SetModel(modelPath)
            modelIcon:SetTooltip(modelName)

            modelIcon.DoClick = function()
                SetClipboardText(modelPath)
                notification.AddLegacy("Скопирован путь к модельке: " .. modelPath, NOTIFY_HINT, 5)
            end
        end
    end

    concommand.Add("hg_playermodels", function()
        ShowPlayerModels()
    end)
end
