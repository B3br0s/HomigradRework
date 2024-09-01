local function OpenShopMenu()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Магазин")
    frame:SetSize(400, 300)
    frame:Center()
    frame:MakePopup()

    local shopList = vgui.Create("DPanelList", frame)
    shopList:Dock(FILL)
    shopList:SetSpacing(5)
    shopList:EnableVerticalScrollbar(true)

    local items = {
        {name = "Аптечка", price = 100},
        {name = "Броня", price = 150},
        {name = "Патроны", price = 50}
    }

    for _, item in pairs(items) do
        local itemPanel = vgui.Create("DPanel", shopList)
        itemPanel:SetTall(50)

        local itemName = vgui.Create("DLabel", itemPanel)
        itemName:SetText(item.name .. " - $" .. item.price)
        itemName:Dock(LEFT)
        itemName:DockMargin(10, 10, 0, 10)

        local buyButton = vgui.Create("DButton", itemPanel)
        buyButton:SetText("Купить")
        buyButton:Dock(RIGHT)
        buyButton:DockMargin(0, 10, 10, 10)

        buyButton.DoClick = function()
            chat.AddText(Color(0, 255, 0), "Вы приобрели " .. item.name .. " за" .. item.price)
        end

        shopList:AddItem(itemPanel)
    end
end

concommand.Add("hg_openshop", function()
    --OpenShopMenu()
    print("Nedorabotano idi nahui")
end)

