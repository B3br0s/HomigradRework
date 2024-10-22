if SERVER then
    AddCSLuaFile()
end

if CLIENT then
    local function ShowPlayerModels()
        local modelstable = {}

        local validModels = player_manager.AllValidModels()

        for modelName, modelPath in pairs(validModels) do
            table.insert(modelstable, { name = modelName, model = modelPath })
        end
        local frame = vgui.Create("DFrame")
        frame:SetTitle("Плеермодельки")
        frame:SetSize(435, 600)
        frame:Center()
        frame:MakePopup()
        frame:SetDraggable(false)

        local PM = vgui.Create("DModelPanel")
        PM:SetSize(frame:GetWide(),frame:GetTall())
        PM:SetPos(frame:GetX() + frame:GetX() / 2,frame:GetY())
        PM:SetModel(LocalPlayer():GetModel())
        local Ent = PM:GetEntity()

        function PM:LayoutEntity(ent)
            ent:SetAngles(Angle(0,0,0))
        end

        local scrollPanel = vgui.Create("DScrollPanel", frame)
        scrollPanel:Dock(FILL)

        local iconLayout = vgui.Create("DIconLayout", scrollPanel)
        iconLayout:Dock(FILL)
        iconLayout:SetSpaceY(5)
        iconLayout:SetSpaceX(5)

        frame.OnClose = function ()
            PM:Remove()
        end

        for _, modelInfo in ipairs(modelstable) do
            local modelIcon = iconLayout:Add("SpawnIcon")
            modelIcon:SetModel(modelInfo.model)
            modelIcon:SetTooltip(modelInfo.name)

            modelIcon.DoRightClick = function()
                local contextMenu = DermaMenu()

                contextMenu:AddOption("Скопировать в буфер обмена", function()
                    SetClipboardText('"' .. modelInfo.model .. '"')
                    --notification.AddLegacy("Скопирован путь к модельке: " .. modelInfo.model, NOTIFY_HINT, 5)
                end)

                contextMenu:Open()
            end
            modelIcon.DoClick = function ()
                PM:SetModel(modelInfo.model)
            end
        end
    end

    concommand.Add("hg_playermodels", function()
        ShowPlayerModels()
    end)
end
