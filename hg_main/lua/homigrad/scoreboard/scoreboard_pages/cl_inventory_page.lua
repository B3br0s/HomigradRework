local open = false
local panelka

local weps = {}

local armorSlots = {
    "head", "eyes", "mouthnose", "ears", "rightshoulder", "rightforearm", 
    "rightthigh", "rightcalf", "chest", "pelvis", "leftshoulder", "leftforearm", 
    "leftthigh", "leftcalf", "acc_head", "acc_eyes", "acc_neck", "acc_ears", 
    "acc_lshoulder", "acc_rshoulder", "acc_backpack", "back", "acc_chestrig", "armband"
}

local BlackList = {
    ["weapon_hands"] = true,
    ["weapon_physgun"] = true,
    ["gmod_tool"] = true,
    ["gmod_camera"] = true,
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

function PopulateArmorSlots()
    local playerArmor = LocalPlayer().EZarmor
    if not playerArmor then
        return
    end

    for _, slotName in ipairs(armorSlots) do
        local itemID, itemData, armorInfo = GetItemInSlot(playerArmor, slotName)
        if itemID then
            armorSlots[slotName] = {
                id = itemID,
                data = itemData,
                specs = armorInfo
            }
        else
            armorSlots[slotName] = nil
        end
    end
end

function CreateInvSlot(Parent,SlotsSize,PosI)
    local InvButton = vgui.Create("hg_button",Parent)
    InvButton:SetSize(SlotsSize, SlotsSize)
    InvButton:SetPos(SlotsSize * (PosI - 1),0)
    InvButton:Dock(LEFT)
    InvButton:SetText(" ")
    InvButton.LowerText = ""
    InvButton.LowerFont = "HS.10"

    function InvButton:DoRightClick()

    end
    
    function InvButton:SubPaint(w,h)
        for _, wep in ipairs(LocalPlayer():GetWeapons()) do
            if !BlackList[wep:GetClass()] and !table.HasValue(weps,wep) then
                table.insert(weps,wep)
            end
        end
        
        for _, wep in pairs(weps) do
            if IsValid(wep) and wep:GetOwner() != LocalPlayer() then
                table.remove(weps,_)
            end
        end

        if IsValid(self.Weapon) and self.Weapon:GetOwner() != LocalPlayer() then
            self.Weapon = nil
        end

        /*print("                                             ")
        print(Parent[1].Weapon)
        print(Parent[2].Weapon)
        print(Parent[3].Weapon)
        print(Parent[4].Weapon)
        print(Parent[5].Weapon)
        print(Parent[6].Weapon)
        print(Parent[7].Weapon)
        print(Parent[8].Weapon)
        print("                                             ")*/
        for i, w in ipairs(weps) do
            if PosI == i and (not IsValid(self.Weapon) or (IsValid(self.Weapon) and self.Weapon:GetOwner() != LocalPlayer())) then
                /*if Parent[PosI - 1] and Parent[PosI - 1].Weapon == nil then
                    Parent[PosI - 1].Weapon = w
                    Parent[PosI].Weapon = nil
                    //print(w)
                else*/if Parent[PosI] and Parent[PosI].Weapon == nil then
                    Parent[PosI].Weapon = w
                    if Parent[PosI + 1].Weapon == w then
                        Parent[PosI + 1].Weapon = nil
                    end
                end
            end
        end

        for i, w in ipairs(weps) do
            //print(PosI)
        end

        if IsValid(self.Weapon) and self.Weapon:GetOwner() == LocalPlayer() then
            self.LowerText = self.Weapon:GetPrintName()
        elseif IsValid(self.Weapon) or !IsValid(self.Weapon) then
            self.LowerText = " "
        end
    end

    return InvButton
end

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

        local CenterX = ScoreBoardPanel:GetWide() / 2
        //MainFrame:Center()

        function MainFrame:SubPaint(w,h)
            draw.SimpleText("WORK IN PROGRESS.","HS.45",ScrW()/1.995,ScrH()/2.095,Color(204,0,255,45),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText("WORK IN PROGRESS.","HS.45",ScrW()/2,ScrH()/2.1,Color(255,255,255,45),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

            draw.SimpleText("COME BACK SOON!","HS.45",ScrW()/1.995,ScrH()/1.895,Color(204,0,255,45),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText("COME BACK SOON!","HS.45",ScrW()/2,ScrH()/1.9,Color(255,255,255,45),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        local SlotsSize = 75

        local InvFrame = vgui.Create("hg_frame",MainFrame)
        InvFrame:ShowCloseButton(false)
        InvFrame:SetTitle(" ")
        InvFrame:SetDraggable(false)
        InvFrame:SetSize(ScrW() / 3.2, SlotsSize)
        InvFrame:Center()
        InvFrame:SetPos(CenterX - ScrW()/6.4,ScrH()-SlotsSize)
        InvFrame:DockMargin(0,0,0,0)
        InvFrame:DockPadding(0,0,0,0)

        for _, wep in ipairs(LocalPlayer():GetWeapons()) do
            if !BlackList[wep:GetClass()] and !table.HasValue(weps,wep) then
                table.insert(weps,wep)
            end
        end

        for i = 1, 8 do
            local Slot = CreateInvSlot(InvFrame,SlotsSize,i)
            InvFrame[i] = Slot

            for _, wep in ipairs(weps) do
                if i == _ then
                    Slot.Weapon = wep
                end
            end
        end

        panelka = MainFrame
    elseif hg.ScoreBoard != 3 then
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
    end
end)