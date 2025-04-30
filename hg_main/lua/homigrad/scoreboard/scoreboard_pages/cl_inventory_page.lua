local open = false
local panelka

local armorSlots = {
    "head", "eyes", "mouthnose", "ears", "rightshoulder", "rightforearm", 
    "rightthigh", "rightcalf", "chest", "pelvis", "leftshoulder", "leftforearm", 
    "leftthigh", "leftcalf", "acc_head", "acc_eyes", "acc_neck", "acc_ears", 
    "acc_lshoulder", "acc_rshoulder", "acc_backpack", "back", "acc_chestrig", "armband"
}


local ArmorSlotButtons = {
    {
        title = "Выкинуть",
        actionFunc = function(slot, itemID, itemData, itemInfo)
            net.Start("JMod_Inventory")
            net.WriteInt(1, 8) -- drop action
            net.WriteString(itemID)
            net.SendToServer()

            timer.Simple(0.1, function()
                if not IsValid(slot.butt) then return end
                slot.butt:SetImage("null.vmt")
                PopulateArmorSlots()
                slot:InvalidateLayout(true)
            end)
        end        
    },
    {
        title = "Переключить",
        visTestFunc = function(slot, itemID, itemData, itemInfo)
            return itemInfo and itemInfo.tgl
        end,
        actionFunc = function(slot, itemID, itemData, itemInfo)
            net.Start("JMod_Inventory")
            net.WriteInt(2, 8) -- toggle
            net.WriteString(itemID)
            net.SendToServer()
            timer.Simple(0.001, function() PopulateArmorSlots() slot:InvalidateLayout(true) end)
        end
    },
    {
        title = "Починить",
        visTestFunc = function(slot, itemID, itemData, itemInfo)
            return itemInfo and itemData.dur < itemInfo.dur * 0.9
        end,
        actionFunc = function(slot, itemID, itemData, itemInfo)
            net.Start("JMod_Inventory")
            net.WriteInt(3, 8) -- repair
            net.WriteString(itemID)
            net.SendToServer()
            timer.Simple(0.001, function() PopulateArmorSlots() slot:InvalidateLayout(true) end)
        end
    },
    {
        title = "Перезарядить",
        visTestFunc = function(slot, itemID, itemData, itemInfo)
            if itemInfo and itemInfo.chrg then
                for resource, maxAmt in pairs(itemInfo.chrg) do
                    if itemData.chrg[resource] < maxAmt then return true end
                end
            end
            return false
        end,
        actionFunc = function(slot, itemID, itemData, itemInfo)
            net.Start("JMod_Inventory")
            net.WriteInt(4, 8) -- recharge
            net.WriteString(itemID)
            net.SendToServer()
            timer.Simple(0.001, function() PopulateArmorSlots() slot:InvalidateLayout(true) end)
        end
    }
}

hook.Add("HUDPaint","InventoryPage",function()
    if not hg.ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false return end
    if hg.ScoreBoard == 3 and not open then
        if !LocalPlayer():Alive() then
            hg.ScoreBoard = 1
        end

        open = true
        
        local MainFrame = vgui.Create("hg_frame",ScoreBoardPanel)
        MainFrame:ShowCloseButton(false)
        MainFrame:SetTitle(" ")
        MainFrame:SetDraggable(false)
        MainFrame:SetSize(ScrW() / 1.06, ScrH())
        MainFrame.NoDraw = true
        //MainFrame:Center()

        function MainFrame:SubPaint(w,h)
            draw.SimpleText("WORK IN PROGRESS.","HS.45",ScrW()/1.995,ScrH()/2.095,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText("WORK IN PROGRESS.","HS.45",ScrW()/2,ScrH()/2.1,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

            draw.SimpleText("COME BACK SOON!","HS.45",ScrW()/1.995,ScrH()/1.895,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText("COME BACK SOON!","HS.45",ScrW()/2,ScrH()/1.9,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        //да мне уже честно похуй,завтра сделаю

        panelka = MainFrame
    elseif hg.ScoreBoard != 3 then
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
    end
end)