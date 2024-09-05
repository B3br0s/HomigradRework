-- shop_system_with_gui.lua
if SERVER then
    util.AddNetworkString("OpenShopMenu")
    util.AddNetworkString("ShopPurchaseItem")

    local shopDataFile = "shopdata.txt"
    local shopItems = {}

    -- Load shop data from file
    local function LoadShopData()
        if file.Exists(shopDataFile, "DATA") then
            local data = file.Read(shopDataFile, "DATA")
            shopItems = util.JSONToTable(data) or {}
        else
            shopItems = {}
        end
    end

    -- Save shop data to file
    local function SaveShopData()
        local data = util.TableToJSON(shopItems, true)
        file.Write(shopDataFile, data)
    end

    -- Add item to shop
    function AddItemToShop(itemID, itemName, itemPrice)
        shopItems[itemID] = {
            name = itemName,
            price = itemPrice
        }
        SaveShopData()
    end

    -- Get item from shop
    function GetItemFromShop(itemID)
        return shopItems[itemID]
    end

    -- List all items in shop
    function ListShopItems()
        return shopItems
    end

    -- Initialize shop data
    LoadShopData()

    -- Console command to open the shop menu
    concommand.Add("hg_openshop", function(ply, cmd, args)
        if IsValid(ply) and ply:IsPlayer() then
            net.Start("OpenShopMenu")
            net.Send(ply)
        end
    end)

    -- Handle item purchases
    net.Receive("ShopPurchaseItem", function(len, ply)
        local itemID = net.ReadString()
        local item = GetItemFromShop(itemID)

        if item then
            -- Check if the player has enough money (modify this based on your currency system)
            local playerMoney = ply:GetNWInt("Money", 0)

            if playerMoney >= item.price then
                ply:SetNWInt("Money", playerMoney - item.price)
                ply:ChatPrint("You purchased: " .. item.name .. " for $" .. item.price)
                -- Optionally give the player the item here
            else
                ply:ChatPrint("You don't have enough money to buy: " .. item.name)
            end
        end
    end)

    AddItemToShop("1", "Pistol", 1000)

else -- CLIENT SIDE

    -- Open the shop menu GUI
    net.Receive("OpenShopMenu", function()
        local frame = vgui.Create("DFrame")
        frame:SetTitle("Shop Menu")
        frame:SetSize(400, 600)
        frame:Center()
        frame:MakePopup()

        local itemList = vgui.Create("DListView", frame)
        itemList:SetSize(380, 500)
        itemList:SetPos(10, 30)
        itemList:SetMultiSelect(false)
        itemList:AddColumn("Item ID")
        itemList:AddColumn("Item Name")
        itemList:AddColumn("Price")

        -- Request items from the server
        local shopItems = ListShopItems()

        -- Populate the list with items from the server
        for id, item in pairs(shopItems) do
            itemList:AddLine(id, item.name, "$" .. item.price)
        end

        -- Buy button
        local buyButton = vgui.Create("DButton", frame)
        buyButton:SetSize(380, 30)
        buyButton:SetPos(10, 540)
        buyButton:SetText("Buy Selected Item")

        buyButton.DoClick = function()
            local selectedLine = itemList:GetSelectedLine()
            if selectedLine then
                local selectedID = itemList:GetLine(selectedLine):GetValue(1)
                net.Start("ShopPurchaseItem")
                net.WriteString(selectedID)
                net.SendToServer()
            else
                notification.AddLegacy("Please select an item to purchase.", NOTIFY_ERROR, 5)
            end
        end
    end)

end
