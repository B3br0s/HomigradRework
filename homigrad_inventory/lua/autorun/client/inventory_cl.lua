local armorSlots = {
    "head", "eyes", "mouthnose", "ears", "rightshoulder", "rightforearm", 
    "rightthigh", "rightcalf", "chest", "pelvis", "leftshoulder", "leftforearm", 
    "leftthigh", "leftcalf", "acc_head", "acc_eyes", "acc_neck", "acc_ears", 
    "acc_lshoulder", "acc_rshoulder", "acc_backpack", "back", "acc_chestrig", "armband"
}

local inventoryFrame
local currentb

local ArmorSlotButtons = {
    {
        title = "Выкинуть",
        actionFunc = function(slot, itemID, itemData, itemInfo)
            net.Start("JMod_Inventory")
            net.WriteInt(1, 8) -- drop action
            net.WriteString(itemID)
            net.SendToServer()

            timer.Simple(0.1, function()
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

local function GetItemInSlot(armorTable, slot)
    if not (armorTable and armorTable.items) then return nil end
    for id, armorData in pairs(armorTable.items) do
        local ArmorInfo = JMod.ArmorTable[armorData.name]
        if ArmorInfo and ArmorInfo.slots and ArmorInfo.slots[slot] then
            return id, armorData, ArmorInfo
        end
    end
    return nil
end

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

local function CreateSlot(slotName, parent)
    --Создание слотов суко
    local slot = vgui.Create("DPanel", parent)
    slot:SetSize(64, 64)

    local ItemID, ItemData, ItemInfo = JMod.GetItemInSlot(LocalPlayer().EZarmor, slotName)
    
    slot.Paint = function(self, w, h)
        --surface.SetDrawColor(25, 25, 25, 255)
        --surface.DrawRect(0, 0, w, h)
        
       -- surface.SetDrawColor(25, 25, 25, 15)
       if self:IsHovered() then
        surface.SetDrawColor(45,45,45,255)
        else
        surface.SetDrawColor(25,25,25,255)
        end
    surface.DrawRect(0,0,w,h)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    slot.Think = function(self)
        if self.nextUpdateTime and self.nextUpdateTime > RealTime() then return end
        self.nextUpdateTime = RealTime() + 0.1
    
        local armorItem = armorSlots[slotName]
        
        if not IsValid(self.butt) then
            self.butt = vgui.Create("DImage", self)
            self.butt:SetSize(50, 50)
            self.butt:Center()
        end
        
        local expectedImagePath = "null.vmt"
        
        if armorItem and ItemInfo and ItemInfo.ent then
            local entityIconPath = "entities/" .. ItemInfo.ent .. ".png"
    
            if not self.cachedEntityIconPath or self.cachedEntityIconPath != entityIconPath then
                if file.Exists("materials/" .. entityIconPath, "GAME") then
                    expectedImagePath = entityIconPath
                else
                    expectedImagePath = "vgui/entities/default.png"
                end
                self.cachedEntityIconPath = entityIconPath
            else
                expectedImagePath = self.cachedEntityIconPath
            end
        end
        
        if self.butt:GetImage() ~= expectedImagePath then
            self.butt:SetImage(expectedImagePath)
        end
    end
    
    slot.OnMousePressed = function(self, mouseCode)
        if armorSlots[slotName] and mouseCode == MOUSE_RIGHT then
            local contextMenu = DermaMenu()
            for _, action in ipairs(ArmorSlotButtons) do
                local isVisible = true
                if action.visTestFunc then
                    isVisible = action.visTestFunc(slot, ItemID, ItemData, ItemInfo)
                end
                if isVisible then
                    currentb = slot.butt
                    contextMenu:AddOption(action.title, function()
                        action.actionFunc(slot, ItemID, ItemData, ItemInfo)
                    end)
                end
            end
            contextMenu:Open()
        end
    end

    return slot
end

local function CreateInventorySlot(i, inventoryFrame, inventorySlotXPos)
    local inventorySlot = vgui.Create("DPanel", inventoryFrame)
    inventorySlot:SetSize(80, 80)
    inventorySlot:SetPos(inventorySlotXPos, ScrH() - 80)
    inventorySlot.SlotItem = "Empty"
    inventorySlot.SlotItemnn = "Empty"

    local image = vgui.Create("DImage", inventorySlot)
    image:SetSize(inventorySlot:GetWide() - 20, inventorySlot:GetTall() - 20)
    image:SetImage("null.vmt")
    image:SetPos(10, -5)

    for _, weapon in ipairs(LocalPlayer():GetWeapons()) do
        if i == 1 and weapon.Slot == 2 and weapon.SlotPos == 0 then
            inventorySlot.SlotItem = weapon:GetClass()
            inventorySlot.SlotItemnn = weapon:GetPrintName()
            if weapon.IconkaInv then
                image:SetImage(weapon.IconkaInv)
            end
        elseif i == 2 and weapon.Slot == 2 and weapon.SlotPos == 1 then
            inventorySlot.SlotItem = weapon:GetClass()
            inventorySlot.SlotItemnn = weapon:GetPrintName()
            if weapon.IconkaInv then
                image:SetImage(weapon.IconkaInv)
            end
        elseif i == 4 and weapon.Slot == 3 then
            inventorySlot.SlotItem = weapon:GetClass()
            inventorySlot.SlotItemnn = weapon:GetPrintName()
            if weapon.IconkaInv then
                image:SetImage(weapon.IconkaInv)
            end
        elseif i == 3 and weapon.Slot == 1 then
            inventorySlot.SlotItem = weapon:GetClass()
            inventorySlot.SlotItemnn = weapon:GetPrintName()
            if weapon.IconkaInv then
                image:SetImage(weapon.IconkaInv)
            end
        end
    end

    inventorySlot.Paint = function(self, w, h)
        if self:IsHovered() then
            surface.SetDrawColor(45,45,45,255)
            else
            surface.SetDrawColor(25,25,25,255)
            end
        surface.DrawRect(0,0,w,h)
        if inventorySlot.SlotItem ~= "Empty" then
            draw.SimpleText(inventorySlot.SlotItemnn, "HomigradFontInvSmallest", w / 2, h - 20, Color(255, 255, 255), TEXT_ALIGN_CENTER)   
        end
    end

    image.Paint = function(self, w, h)
        local angle = -45
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(self:GetMaterial())
        surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, angle)
    end

    inventorySlot.OnMousePressed = function(self, mouseCode)
        if inventorySlot.SlotItem ~= "Empty" and mouseCode == MOUSE_RIGHT then
            local contextMenu = DermaMenu()

            contextMenu:AddOption("Использовать", function()
                net.Start("useweaponinb")
                net.WriteString(inventorySlot.SlotItem)
                net.SendToServer()
            end)

            contextMenu:AddOption("Выкинуть", function()
                print(inventorySlot.SlotItem)
                net.Start("dropweapon")
                net.WriteString(inventorySlot.SlotItem)
                net.SendToServer()
                image:SetImage("null.vmt")
                inventorySlot.SlotItem = "Empty"
                inventorySlot.SlotItemnn = "Empty"
            end)

            contextMenu:Open()
        end
    end

    return inventorySlot
end

local function OpenInventory()
    if IsValid(inventoryFrame) then
        inventoryFrame:Close()
        inventoryFrame = nil
        return
    end
    if LocalPlayer():Alive() and LocalPlayer():GetNWBool("fake") == false then  
        inventoryFrame = vgui.Create("DFrame")
        inventoryFrame:SetSize(ScrW(), ScrH())
        inventoryFrame:Center()
        inventoryFrame:SetTitle("")
        inventoryFrame:MakePopup()
        inventoryFrame:ShowCloseButton(false)
        inventoryFrame:SetDraggable(false)
        inventoryFrame:SetKeyBoardInputEnabled(false)

        if roundActiveName == "construct" then
        
        local teamframe = vgui.Create("DFrame",inventoryFrame)
        teamframe:SetSize(400,150)
        teamframe:SetTitle("")
        teamframe:MakePopup()
        teamframe:ShowCloseButton(false)
        teamframe:SetDraggable(false)
        teamframe:SetKeyBoardInputEnabled(false)
        teamframe:SetPos(0,inventoryFrame:GetTall() - teamframe:GetTall())

        teamframe.Paint = function(self, w, h)
            surface.SetDrawColor(0, 0, 0, 0)
            surface.DrawRect(0, 0, w, h)    
        end

        if LocalPlayer():GetNWBool("InTeam") then
            local leaveframe = vgui.Create("DFrame",teamframe)
            leaveframe:SetSize(200,39)
            leaveframe:SetPos(200,56)
            leaveframe:ShowCloseButton(false)
            leaveframe:SetDraggable(false) 
            leaveframe:SetKeyBoardInputEnabled(false)
            leaveframe:SetTitle("")
            leaveframe.Paint = function(self, w, h)
                surface.SetDrawColor(25, 25, 25, 150)
                surface.DrawRect(0, 0, w, h)    
                draw.SimpleText("Выйти из команды", "HomigradFont", w / 2.5, h / 4, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            end

            local leave = vgui.Create("DImageButton",leaveframe)
            leave:SetSize(20,20)
            leave:SetImage("icon16/cross.png")
            leave:SetPos(leaveframe:GetWide() - 30,leave:GetTall() / 2)
            leave.DoClick = function ()
                net.Start("LeaveParty")
                net.WriteEntity(LocalPlayer())
                net.SendToServer()

                LocalPlayer():ChatPrint("Вы вышли из команды")
                LocalPlayer():ConCommand("hg_inv")
            end
            
        end

        if LocalPlayer():GetNWEntity("InviterToTeam") != NULL then
            local mainframe = vgui.Create("DFrame",teamframe)
            mainframe:SetSize(380,51)
            mainframe:SetTitle(" ")
            mainframe:Center()
            mainframe:ShowCloseButton(false)
            mainframe:SetDraggable(false)
            mainframe.Paint = function(self, w, h)
                surface.SetDrawColor(25, 25, 25, 125)
                surface.DrawRect(0, 0, w, h)
                draw.SimpleText("Пригалашение в команду от "..LocalPlayer():GetNWEntity("InviterToTeam"):Name(), "HomigradFontInv", w / 2 - 60, h / 3, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            end
            
            local accept = vgui.Create("DImageButton",mainframe)
            accept:SetSize(20,20)
            accept:SetImage("icon16/accept.png")
            accept:SetPos(346,16)
            accept.DoClick = function ()
                net.Start("InviteAccept")
                net.WriteEntity(LocalPlayer():GetNWEntity("InviterToTeam"))
                net.WriteEntity(LocalPlayer())
                net.SendToServer()
                LocalPlayer():ChatPrint("Вы приняли приглашение в команду от "..LocalPlayer():GetNWEntity("InviterToTeam"):Name())
                LocalPlayer():ConCommand("hg_inv")
            end

            local decline = vgui.Create("DImageButton",mainframe)
            decline:SetSize(20,20)
            decline:SetImage("icon16/cancel.png")
            decline:SetPos(300,16)
            decline.DoClick = function ()
                net.Start("InviteDecline")
                net.WriteEntity(LocalPlayer():GetNWEntity("InviterToTeam"))
                net.WriteEntity(LocalPlayer())
                net.SendToServer()
                LocalPlayer():ChatPrint("Вы отклонили приглашение в команду от "..LocalPlayer():GetNWEntity("InviterToTeam"):Name())
                LocalPlayer():ConCommand("hg_inv")
            end
        end
        end

        inventoryFrame.Paint = function(self, w, h)
            surface.SetDrawColor(0, 0, 0, 220)
            surface.DrawRect(0, 0, w, h)
        end

        local playerModelPanel = vgui.Create("DModelPanel", inventoryFrame)
        playerModelPanel:SetSize(400, 600)
        playerModelPanel:SetPos(110, ScrH() / 2 - 480)
        playerModelPanel:SetModel(LocalPlayer():GetModel())
        local Ent = playerModelPanel:GetEntity()

        function playerModelPanel:LayoutEntity(ent)
            ent:SetAngles(Angle(0,0,0))
        end

        playerModelPanel:SetCamPos(Vector(45, 0, 45))

        Ent.GetPlayerColor = function() return Vector(LocalPlayer():GetPlayerColor()) end

        local Ply = LocalPlayer()

        if Ply.EZarmor and Ply.EZarmor.suited and Ply.EZarmor.bodygroups then
            playerModelPanel:SetColor(Ply:GetColor())
            for k, v in pairs(Ply.EZarmor.bodygroups) do
                Ent:SetBodygroup(k, v)
            end
        end

        for k, v in pairs(Ply:GetBodyGroups()) do
            local cur_bgid = Ply:GetBodygroup(v.id)
            Ent:SetBodygroup(v.id, cur_bgid)
        end

        function playerModelPanel:PostDrawModel(ent)
            ent.EZarmor = Ply.EZarmor
            JMod.ArmorPlayerModelDraw(ent)
        end

        PopulateArmorSlots()

        local x, y = ScrW() / 4 - 410, ScrH() / 2 - 480
        local size = 64

        CreateSlot("head", inventoryFrame):SetPos(x, y)
        CreateSlot("eyes",inventoryFrame):SetPos(x + size,y + size)
        CreateSlot("mouthnose",inventoryFrame):SetPos(x + size,y)
        CreateSlot("ears",inventoryFrame):SetPos(x,y + size)

        CreateSlot("acc_head",inventoryFrame):SetPos(x + size * 5.5,y)
        CreateSlot("acc_eyes",inventoryFrame):SetPos(x + size * 6.5,y)
        CreateSlot("acc_neck",inventoryFrame):SetPos(x + size * 5.5,y + size)
        CreateSlot("acc_ears",inventoryFrame):SetPos(x + size * 6.5,y + size)

        CreateSlot("rightshoulder",inventoryFrame):SetPos(x,y + size * 2 + 32)
        CreateSlot("rightforearm",inventoryFrame):SetPos(x,y + size * 3 + 32)
        
        CreateSlot("leftshoulder",inventoryFrame):SetPos(x + size,y + size * 2 + 32)
        CreateSlot("leftforearm",inventoryFrame):SetPos(x + size,y + size * 3 + 32)

        CreateSlot("rightthigh",inventoryFrame):SetPos(x + size,y + size * 6 + 32)
        CreateSlot("rightcalf",inventoryFrame):SetPos(x + size,y + size * 7 + 32)

        CreateSlot("leftthigh",inventoryFrame):SetPos(x + size * 5.5,y + size * 6 + 32)
        CreateSlot("leftcalf",inventoryFrame):SetPos(x + size * 5.5,y + size * 7 + 32)

        CreateSlot("chest",inventoryFrame):SetPos(x + size * 5.5,y + size * 5)
        CreateSlot("pelvis",inventoryFrame):SetPos(x + size * 6.5,y + size * 5)

        CreateSlot("back",inventoryFrame):SetPos(x,y + size * 5)

        CreateSlot("acc_chestrig",inventoryFrame):SetPos(x + size,y + size * 5)

        CreateSlot("armband",inventoryFrame):SetPos(x + size * 5.5,y + size * 2 + 32)

        --[[CreateSlot("head",inventoryFrame):SetPos(x,y)
        CreateSlot("eyes",inventoryFrame):SetPos(x + size,y + size)
        CreateSlot("mouthnose",inventoryFrame):SetPos(x + size,y)

        CreateSlot("ears",inventoryFrame):SetPos(x,y + size)
        
        CreateSlot("rightshoulder",inventoryFrame):SetPos(x,y + size * 2 + 32)
        CreateSlot("rightforearm",inventoryFrame):SetPos(x,y + size * 3 + 32)

        CreateSlot("rightthigh",inventoryFrame):SetPos(x,y + size * 6 + 32)
        CreateSlot("rightcalf",inventoryFrame):SetPos(x,y + size * 7 + 32)

        CreateSlot("chest",inventoryFrame):SetPos(x,y + size * 5)
        CreateSlot("pelvis",inventoryFrame):SetPos(x + size,y + size * 5)

        CreateSlot("leftshoulder",inventoryFrame):SetPos(x,y + size * 2 + 32)
        CreateSlot("leftforearm",inventoryFrame):SetPos(x,y + size * 3 + 32)

        CreateSlot("leftthigh",inventoryFrame):SetPos(x,y + size * 6 + 32)
        CreateSlot("leftcalf",inventoryFrame):SetPos(x,y + size * 7 + 32)

        CreateSlot("acc_head",inventoryFrame):SetPos(x,y)
        CreateSlot("acc_eyes",inventoryFrame):SetPos(x - size,y)
        CreateSlot("acc_neck",inventoryFrame):SetPos(x,y + size)
        CreateSlot("acc_ears",inventoryFrame):SetPos(x - size,y + size)

        CreateSlot("acc_lshoulder",inventoryFrame):SetPos(x - size,y + size * 2 + 32)
        CreateSlot("acc_rshoulder",inventoryFrame):SetPos(x - size,y + size * 3 + 32)

        CreateSlot("acc_backpack",inventoryFrame):SetPos(x - size,y + size * 5)
        CreateSlot("acc_chestrig",inventoryFrame):SetPos(x,y + size * 5)
        CreateSlot("armband",inventoryFrame):SetPos(x - size,y + size * 6 + 32)]]

        local inventorySlotXPos = ScrW() / 2 - 320
        for i = 1, 8 do
            CreateInventorySlot(i, inventoryFrame, inventorySlotXPos)
            inventorySlotXPos = inventorySlotXPos + 80
        end
    end
end

concommand.Add("hg_inv", OpenInventory)
