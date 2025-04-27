--Хеллоу хукер :3
local open = false
local panelka
local restart_panel = false
if !lootEnt then
    lootEnt = nil
end
local items 
local items_ammo 
local slots_ply
local armorSlots = {
    "head", "eyes", "mouthnose", "ears", "rightshoulder", "rightforearm", 
    "rightthigh", "rightcalf", "chest", "pelvis", "leftshoulder", "leftforearm", 
    "leftthigh", "leftcalf", "acc_head", "acc_eyes", "acc_neck", "acc_ears", 
    "acc_lshoulder", "acc_rshoulder", "acc_backpack", "back", "acc_chestrig", "armband"
}


function GetItemInSlot(armorTable, slot)
    if not (armorTable and armorTable.items) then return nil end
    for id, armorData in pairs(armorTable.items) do
        local ArmorInfo = JMod.ArmorTable[armorData.name]
        if ArmorInfo and ArmorInfo.slots and ArmorInfo.slots[slot] then
            return id, armorData, ArmorInfo
        end
    end
    return nil
end
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



local function CreateSlot(slotName, parent,customsize)--ЕЕЕ СИСТЕМА СТАРАЯ!!!
    local slot = vgui.Create("DPanel", parent)
    local size = (customsize != nil and customsize or 64)
    slot:SetSize(size, size)
    slot:MakePopup()
    local ItemID, ItemData, ItemInfo = JMod.GetItemInSlot(LocalPlayer().EZarmor, slotName)
    
    slot.Paint = function(self, w, h)
        draw.RoundedBox(0, 2, 2, w - 4, h - 4, Color(49, 49, 49, 215))

        
        surface.SetDrawColor(255,255,255,27)

        surface.DrawOutlinedRect(0,0,w,h,1)
    end

    slot.Think = function(self)
        if self.nextUpdateTime and self.nextUpdateTime > RealTime() then return end
        self.nextUpdateTime = RealTime() + 0.1
    
        local armorItem = armorSlots[slotName]
        
        if not IsValid(self.butt) then
            self.butt = vgui.Create("DImage", self)
            self.butt:SetSize(size - 14, size - 14)
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




local function getText(text,limitW)
    local newText = {}
    local newText_I = 1
    local curretText = ""

    surface.SetFont("DefaultFixedDropShadow")

    for i = 1,#text do
        local sumbol = string.sub(text,i,i)
        local w,h = surface.GetTextSize(curretText .. sumbol)

        if w >= limitW then
            newText_I = newText_I + 1
            curretText = sumbol
        else
            curretText = curretText .. sumbol
        end

        newText[newText_I] = curretText
    end

    return newText
end
local BlackList = {
    ['weapon_hands'] = true,
    ['weapon_knife']= true
}

local white = Color(255,255,255)
local black = Color(0,0,0,128)
local black2 = Color(64,64,64,128)
local sweps = {}
local swepslootent = {}


function CreateInventoryButton(parent, index, x, y, lastbutton)
    local black = Color(0, 0, 0, 156)
    local black2 = Color(25, 25, 25, 156)
    local white = Color(255, 255, 255, 255)
    
    local bbbutton = vgui.Create("DButton", parent)
    bbbutton:SetText("")
    
    if lastbutton == nil then 
        bbbutton:SetPos(x, y)
    else
        bbbutton:SetPos(x, y)
    end
    bbbutton:SetSize(102, 102)
    bbbutton:MakePopup()
    bbbutton:SetY(ScrH()/2.3 + y)
    
    bbbutton.Paint = function(self, w, h)
        draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
        surface.SetDrawColor(255, 255, 255, 26)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        draw.SimpleText("Пусто", "DefaultFixedDropShadow", w/2, h/2, Color(255, 255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    bbbutton.Think = function(self)
        if self.nextUpdateTime and self.nextUpdateTime > RealTime() then return end
        self.nextUpdateTime = RealTime() + 0.1
        if sweps[index]["swep"] != nil and IsValid(sweps[index]["swep"]) then
            if sweps[index]["swep"]:GetOwner() == LocalPlayer() then
                local wepTbl = sweps[index]["swep"]
                local text = wepTbl.PrintName or "Оружие"
                
                bbbutton.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and black2 or black)
                    surface.SetDrawColor(255, 255, 255, 128)
                    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
                    
                    draw.SimpleText(text, "DefaultFixedDropShadow", w/2, h-15, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    
                    local x, y = self:LocalToScreen(0, 0)
                    if type(DrawWeaponSelectionEX) == "function" then
                        DrawWeaponSelectionEX(wepTbl, x, y, w, h)
                    end
                end
            else
                sweps[index]["swep"] = nil
            end
        else
            bbbutton.Paint = function(self, w, h)
                draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
                surface.SetDrawColor(255, 255, 255, 26)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
                draw.SimpleText("Пусто", "DefaultFixedDropShadow", w/2, h/2, Color(255, 255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
    bbbutton.DoClick = function()
        if sweps[index]["swep"] != nil and IsValid(sweps[index]["swep"]) then
            net.Start("DropItemInv")
            net.WriteString(sweps[index]["swep"]:GetClass())
            net.SendToServer()
            sweps[index]["swep"] = nil
        end
    end
    bbbutton.DoRightClick = function()
        if sweps[index]["swep"] != nil and IsValid(sweps[index]["swep"]) then
            local Menu = DermaMenu(true, bbbutton)
            Menu:SetPos(input.GetCursorPos())
            Menu:MakePopup()
            
            Menu:AddOption("Выкинуть", function()
                net.Start("DropItemInv")
                net.WriteString(sweps[index]["swep"]:GetClass())
                net.SendToServer()
                sweps[index]["swep"] = nil
            end)
        end
    end
    
    return bbbutton
end

function CreateInventoryButton_Secound(parent, index, x, y, lastbutton, isPlayerInv)
    local black = Color(0, 0, 0, 156)
    local black2 = Color(25, 25, 25, 156)
    local white = Color(255, 255, 255, 255)
    
    local bbbutton = vgui.Create("DButton", parent)
    bbbutton:SetText("")
    
    if lastbutton == nil then 
        bbbutton:SetPos(x, y)
    else
        bbbutton:SetPos(x, y)
    end
    bbbutton:SetSize(102, 102)
    bbbutton:MakePopup()
    
    bbbutton.Paint = function(self, w, h)
        draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
        surface.SetDrawColor(255, 255, 255, 26)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        draw.SimpleText("Пусто", "DefaultFixedDropShadow", w/2, h/2, Color(255, 255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    bbbutton.Think = function(self)
        if self.nextUpdateTime and self.nextUpdateTime > RealTime() then return end
        self.nextUpdateTime = RealTime() + 0.1
        self.ThinkNext = RealTime() + 0.1
        if swepslootent[index]["swep"] != nil then
            local weaponClass = swepslootent[index]["swep"]
            local text = weapons.Get(weaponClass).PrintName or "Оружие"
            
            if weapons.Get(weaponClass) then
                text = weapons.Get(weaponClass).PrintName
            end
            
            bbbutton.Paint = function(self, w, h)
                draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
                surface.SetDrawColor(255, 255, 255, 26)
                surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
                
                draw.SimpleText(text, "DefaultFixedDropShadow", w/2, h-15, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                local x, y = self:LocalToScreen(0, 0)
                if type(DrawWeaponSelectionEX) == "function" then
                    DrawWeaponSelectionEX(weapons.Get(weaponClass), x, y, w, h)
                end
            end
        else
            bbbutton.Paint = function(self, w, h)
                draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
                surface.SetDrawColor(255, 255, 255, 26)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
                draw.SimpleText("Пусто", "DefaultFixedDropShadow", w/2, h/2, Color(255, 255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
    
    bbbutton.DoClick = function()
        if swepslootent[index]["swep"] != nil then
            net.Start("ply_take_item")
            net.WriteEntity(lootEnt)
            net.WriteString(tostring(swepslootent[index]["swep"]))
            net.SendToServer()

            timer.Simple(0.1, function()
                if not open then
                    hg.ScoreBoard = 2
                    open = true
                end
            end)
    
            local emptySlot = nil
            for i, data in pairs(sweps) do
                if data["swep"] == nil then
                    emptySlot = i
                    break
                end
            end
            
            if emptySlot then
                local weapon = swepslootent[index]["swep"]
                swepslootent[index]["swep"] = nil
            end
        end
    end
    return bbbutton
end


function CreateEnemyInventoryPanel(MainPanel, items, lootEnt)
    if lootEnt then 
        inv_enemy = vgui.Create("DFrame", MainPanel)
        inv_enemy:SetAlpha(255)
        inv_enemy:SetSize(ScrW()*0.6, ScrH()*0.5)
        inv_enemy:Center()
        inv_enemy:SetY(ScrH()/2.3)
        inv_enemy:SetX(ScrW()*0.6)
        inv_enemy:SetDraggable(false)
        inv_enemy:MakePopup()
        inv_enemy:SetTitle("")
        inv_enemy:ShowCloseButton(false)
        local swep_ar2
        local swep_ar2_p
        for weapon, _ in pairs(items) do 
            weapon = weapons.Get(weapon)
            if (IsValid(weapon) and (weapon.TwoHands ~= nil and weapon.TwoHands == true)) then  
                swep_ar2 = weapon
            end
        end
        
        for weapon, _ in pairs(items) do 
            weapon = weapons.Get(weapon)
            if IsValid(weapon) and (weapon.TwoHands == nil or weapon.TwoHands == false) and weapon.Base == 'homigrad_base' then  
                swep_ar2_p = weapon
            end
        end

        inv_enemy.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 0))
        end
        
        inv_enemy.Think = function(self)
            if self.nextUpdateTime and self.nextUpdateTime > RealTime() then return end
            self.nextUpdateTime = RealTime() + 0.1
            local assignedWeapons = {}

            for i, buttonData in pairs(swepslootent) do
                if buttonData["swep"] != nil then
                    assignedWeapons[buttonData["swep"]] = true
                end
            end

            for weaponClass, _ in pairs(items) do
                if BlackList and BlackList[weaponClass] then continue end
                if not assignedWeapons[weaponClass] then
                    for i, buttonData in pairs(swepslootent) do
                        if buttonData["swep"] == nil then
                            buttonData["swep"] = weaponClass
                            assignedWeapons[weaponClass] = true
                            break
                        end
                    end
                end
            end

            for i, buttonData in pairs(swepslootent) do
                if buttonData["swep"] != nil then
                    local weaponExists = false
                    for weaponClass, _ in pairs(items) do
                        if weaponClass == buttonData["swep"] then
                            weaponExists = true
                            break
                        end
                    end
                    
                    if not weaponExists then
                        buttonData["swep"] = nil
                    end
                end
            end
        end
    
        local lastbutton = nil
        local currentX, currentY = ScrW()*0.6, 10 
        local buttonsPerRow = 7
        local buttonCount = 0
        

        for i=1, 7 do

            local rowNumber = math.floor((buttonCount) / buttonsPerRow)
            local colNumber = buttonCount % buttonsPerRow
            
            local buttonX = ScrW()*0.6 + (colNumber * 110)
            local buttonY = ScrH()/2.246 + (rowNumber * 100) - 10
            
            local bbbutton = CreateInventoryButton_Secound(inv_enemy, i, buttonX, buttonY, lastbutton, false)
            
            buttonCount = buttonCount + 1
            
            swepslootent[i] = {
                ["buton"] = bbbutton,
                ["swep"] = nil
            }
            
            lastbutton = bbbutton
        end
        for i=7, 13 do

            local rowNumber = math.floor((buttonCount) / buttonsPerRow)
            local colNumber = buttonCount % buttonsPerRow
            
            local buttonX = ScrW()*0.6 + (colNumber * 110)
            local buttonY = ScrH()/2.246 + (rowNumber * 100) - 10
            
            local bbbutton = CreateInventoryButton_Secound(inv_enemy, i, buttonX, buttonY, lastbutton, false)
            
            buttonCount = buttonCount + 1
            
            swepslootent[i] = {
                ["buton"] = bbbutton,
                ["swep"] = nil
            }
            
            lastbutton = bbbutton
        end
        for i=13, 19 do

            local rowNumber = math.floor((buttonCount) / buttonsPerRow)
            local colNumber = buttonCount % buttonsPerRow
            
            local buttonX = ScrW()*0.6 + (colNumber * 110)
            local buttonY = ScrH()/2.246 + (rowNumber * 100) - 10
            
            local bbbutton = CreateInventoryButton_Secound(inv_enemy, i, buttonX, buttonY, lastbutton, false)
            
            buttonCount = buttonCount + 1
            
            swepslootent[i] = {
                ["buton"] = bbbutton,
                ["swep"] = nil
            }
            
            lastbutton = bbbutton
        end
        for i=19, 25 do

            local rowNumber = math.floor((buttonCount) / buttonsPerRow)
            local colNumber = buttonCount % buttonsPerRow
            
            local buttonX = ScrW()*0.6 + (colNumber * 110)
            local buttonY = ScrH()/2.246 + (rowNumber * 100) - 10
            
            local bbbutton = CreateInventoryButton_Secound(inv_enemy, i, buttonX, buttonY, lastbutton, false)
            
            buttonCount = buttonCount + 1
            
            swepslootent[i] = {
                ["buton"] = bbbutton,
                ["swep"] = nil
            }
            
            lastbutton = bbbutton
        end
        return inv_enemy
    end
    return nil
end


hook.Add("HUDPaint", "InventoryPage", function()
    if not hg.ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false return end
    
    if hg.ScoreBoard == 2 and not open then
        open = true
        local ply = LocalPlayer()
        local MainPanel = vgui.Create("DFrame", ScoreBoardPanel)
        MainPanel:SetSize(ScrW(), ScrH())
        MainPanel:Center()
        MainPanel:SetDraggable(false)
        MainPanel:SetTitle(" ")
        MainPanel:ShowCloseButton(false)
        MainPanel:SetPos(0, MainPanel:GetY())
        MainPanel:SetDraggable(false)
        MainPanel:SetKeyBoardInputEnabled(true)
        MainPanel:SetMouseInputEnabled(false) 
        
        function MainPanel:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end
        

        local inv_player = vgui.Create("DFrame", MainPanel)
        inv_player:SetAlpha(255)
        inv_player:SetSize(ScrW()*0.4, ScrH()*0.5)
        inv_player:Center()
        inv_player:SetY(ScrH()/2.3)
        inv_player:SetX(ScrW()*0.00)
        inv_player:SetDraggable(false)
        inv_player:MakePopup()
        inv_player:SetTitle("")
        inv_player:ShowCloseButton(false)
        
        inv_player.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 0))
        end
        
        local swep_ar2
        local swep_ar2_p
        for _, weapon in pairs(ply:GetWeapons()) do 
            if (IsValid(weapon) and (weapon.TwoHands ~= nil and weapon.TwoHands == true)) then  
                swep_ar2 = weapon
            end
        end
        
        for _, weapon in pairs(ply:GetWeapons()) do 
            if IsValid(weapon) and (weapon.TwoHands == nil or weapon.TwoHands == false) and weapon.Base == 'homigrad_base' then  
                swep_ar2_p = weapon
            end
        end
        
        inv_player.Think = function(self)
            if self.nextUpdateTime and self.nextUpdateTime > RealTime() then return end
            self.nextUpdateTime = RealTime() + 0.1
            local weapons = LocalPlayer():GetWeapons()
            for _, weapon in pairs(ply:GetWeapons()) do 
                if (IsValid(weapon) and (weapon.TwoHands ~= nil and weapon.TwoHands == true)) then  
                    swep_ar2 = weapon
                end
            end
        
            for _, weapon in pairs(ply:GetWeapons()) do 
                if IsValid(weapon) and (weapon.TwoHands == nil or weapon.TwoHands == false) and weapon.Base == 'homigrad_base' then  
                    swep_ar2_p = weapon
                end
            end
            
            local assignedWeapons = {}
            for i, buttonData in pairs(sweps) do
                if buttonData["swep"] != nil then
                    assignedWeapons[buttonData["swep"]] = true
                end
            end

            for _, wep in pairs(weapons) do
                if BlackList and BlackList[wep:GetClass()] then continue end
                if (wep == swep_ar2) or (wep == swep_ar2_p) then continue end
                if not assignedWeapons[wep] then
                    for i, buttonData in pairs(sweps) do
                        if buttonData["swep"] == nil then
                            buttonData["swep"] = wep
                            assignedWeapons[wep] = true
                            break
                        end
                    end
                end
            end
            
            for i, buttonData in pairs(sweps) do
                if buttonData["swep"] != nil then
                    local weaponExists = false
                    for _, wep in pairs(weapons) do
                        if wep == buttonData["swep"] then
                            weaponExists = true
                            break
                        end
                    end
                    
                    if not weaponExists then
                        buttonData["swep"] = nil
                    end
                end
            end
        end
        
        panelka = MainPanel
        local ply = LocalPlayer()

        local cr2w = vgui.Create("DFrame",MainPanel) 
        cr2w:SetSize(ScrW()/5,ScrH()/6)
        cr2w:SetPos(-ScrW()/9000,ScrH()/12)
        cr2w:SetDraggable(false)
        cr2w:SetTitle(" ")
        cr2w:ShowCloseButton(false)
        function cr2w:Paint(w, h)
            draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
            if not swep_ar2 then
                draw.SimpleText("Пусто.","hg_HomicideSmalles",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
                cr2w.Gun = nil
            else
                cr2w.Gun = swep_ar2
                draw.SimpleText(swep_ar2.PrintName,"hg_HomicideSmalles",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
            end

            surface.SetDrawColor(255,255,255,24)

            surface.DrawOutlinedRect(0,0,w,h,2)
        end

        local cr2wmodel = vgui.Create("DModelPanel",cr2w)
        cr2wmodel:SetSize(cr2w:GetWide(),cr2w:GetTall())
        cr2wmodel:SetPos(cr2w:GetPos())
        cr2wmodel:SetModel(IsValid(swep_ar2) and swep_ar2.WorldModel or " ")
        if swep_ar2 ~= nil then
            if swep_ar2:GetPrintName() == 'Remington 870' then
                cr2wmodel:SetCamPos(Vector(38,14,4))
            else 
                cr2wmodel:SetCamPos(Vector(35,0,5))
            end 
        end
        function cr2wmodel:LayoutEntity(ent)

            --print(cr2wmodel:GetCamPos(  ))
            
            cr2wmodel:SetLookAng(Angle(0,180,0))
            ent:SetPos(Vector(0,0,0))
            ent:SetAngles(Angle(0,90,0))
        end
        function cr2wmodel:DoRightClick()
            if swep_ar2 == nil then return end
            local Menu = DermaMenu(true,cr2p)

            Menu:SetPos(input.GetCursorPos())
            Menu:MakePopup()

            Menu:AddOption("Выкинуть",function()
                net.Start("DropItemInv")
                net.WriteString(swep_ar2:GetClass())
                net.SendToServer()
                self:SetModel(" ")
                swep_ar2 = nil
            end)
        end
        cr2wmodel:MakePopup()
        local cr2p = vgui.Create("DFrame",MainPanel) 
        cr2p:SetSize(ScrH()/6,ScrH()/6)
        cr2p:SetPos(-ScrW()/9000,ScrH()/3.9)
        cr2p:SetDraggable(false)
        cr2p:SetTitle(" ")
        cr2p:ShowCloseButton(false)
        function cr2p:Paint(w, h)
            draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
            if not swep_ar2_p then
                draw.SimpleText("Пусто.","hg_HomicideSmalles",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
            else
                draw.SimpleText(swep_ar2_p.PrintName,"hg_HomicideSmalles",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
            end

            surface.SetDrawColor(255,255,255,24)

            surface.DrawOutlinedRect(0,0,w,h,2)
        end

        local cr2pmodel = vgui.Create("DModelPanel",cr2p)
        cr2pmodel:SetSize(cr2w:GetWide(),cr2w:GetTall())
        cr2pmodel:SetPos(cr2p:GetPos())
        cr2pmodel:SetModel(IsValid(swep_ar2_p) and swep_ar2_p.WorldModel or " ")

        if swep_ar2_p ~= nil then
            if swep_ar2_p:GetPrintName() == 'M9 Berreta' or swep_ar2_p:GetPrintName() == 'M1911' then
                cr2pmodel:SetCamPos(Vector(15,-1,5))
            else 
                cr2pmodel:SetCamPos(Vector(20,10,4))
            end 
        end
        function cr2pmodel:DoRightClick()

            local Menu = DermaMenu(true,cr2p)

            Menu:SetPos(input.GetCursorPos())
            Menu:MakePopup()

            Menu:AddOption("Выкинуть",function()
                net.Start("DropItemInv")
                net.WriteString(swep_ar2_p:GetClass())
                net.SendToServer()
                self:SetModel(" ")
                swep_ar2_p = nil
            end)
        end
        function cr2pmodel:LayoutEntity(ent)

            cr2pmodel:SetLookAng(Angle(0,180,0))
            --ent:SetPos(Vector(50,50,50))
            ent:SetAngles(Angle(0,90,0))
        end
        cr2pmodel:MakePopup()

        function cr2p:Paint(w, h)
            draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
            if not swep_ar2_p then
                draw.SimpleText("Пусто.","hg_HomicideSmalles",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
            else
                draw.SimpleText(swep_ar2_p.PrintName,"hg_HomicideSmalles",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
            end

            surface.SetDrawColor(255,255,255,26)

            surface.DrawOutlinedRect(0,0,w,h,1)
        end


        local lastbutton = nil
        local currentX, currentY = 0, 10
        
        for i=1, 7 do
            local bbbutton = CreateInventoryButton(inv_player, i, currentX, currentY, lastbutton, false)
            
            currentX = currentX + bbbutton:GetWide() + 1
            if currentX + bbbutton:GetWide() >= inv_player:GetWide() then
                currentX = 10
                currentY = currentY + bbbutton:GetTall() + 6
            end
            
            sweps[i] = {
                ["buton"] = bbbutton,
                ["swep"] = nil
            }
            
            lastbutton = bbbutton
        end
        
        local currentX, currentY = 0,110
        
        for i=8, 14 do
            local bbbutton = CreateInventoryButton(inv_player, i, currentX, currentY, lastbutton, false)
            
            currentX = currentX + bbbutton:GetWide() + 1
            if currentX + bbbutton:GetWide() >= inv_player:GetWide() then
                currentX = 10
                currentY = currentY + bbbutton:GetTall() + 6
            end
            
            sweps[i] = {
                ["buton"] = bbbutton,
                ["swep"] = nil
            }
            
            lastbutton = bbbutton
        end
        local currentX, currentY = 0,210
        
        for i=14, 20 do
            local bbbutton = CreateInventoryButton(inv_player, i, currentX, currentY, lastbutton, false)
            
            currentX = currentX + bbbutton:GetWide() + 1
            if currentX + bbbutton:GetWide() >= inv_player:GetWide() then
                currentX = 10
                currentY = currentY + bbbutton:GetTall() + 6
            end
            
            sweps[i] = {
                ["buton"] = bbbutton,
                ["swep"] = nil
            }
            
            lastbutton = bbbutton
        end
        local currentX, currentY = 0,310
        
        for i=20, 26 do
            local bbbutton = CreateInventoryButton(inv_player, i, currentX, currentY, lastbutton, false)
            
            currentX = currentX + bbbutton:GetWide() + 1
            if currentX + bbbutton:GetWide() >= inv_player:GetWide() then
                currentX = 10
                currentY = currentY + bbbutton:GetTall() + 6
            end
            
            sweps[i] = {
                ["buton"] = bbbutton,
                ["swep"] = nil
            }
            
            lastbutton = bbbutton
        end

        if lootEnt then 

            local enemyPanel = CreateEnemyInventoryPanel(MainPanel, items, lootEnt)
            
        else
            local PlayerModelBG = vgui.Create("DFrame",MainPanel)
            PlayerModelBG:SetSize(ScrW()/5.8,ScrH()/1.2)
            PlayerModelBG:SetPos(ScrW()/1.2,ScrH()/15)
            PlayerModelBG:SetDraggable(false)
            PlayerModelBG:SetTitle(" ")
            PlayerModelBG:ShowCloseButton(false)
            function PlayerModelBG:Paint(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            end
            local PlayerModel = vgui.Create("DModelPanel",PlayerModelBG)
            PlayerModel:SetSize(PlayerModelBG:GetWide(),PlayerModelBG:GetTall())
            PlayerModel:SetPos(0,0)
            PlayerModel:SetModel(LocalPlayer():GetModel() )
            PlayerModel:SetFOV( 30 )
            PlayerModel:SetLookAng( Angle( 15, 180, 0 ) )
            PlayerModel:SetCamPos( Vector( 75   , 0, 55 ) )
    

            function PlayerModel:LayoutEntity(Entity)
                -- Handle angles and base color
                Entity.Angles = Entity.Angles or Angle(0, 0, 0)
                Entity:SetAngles(Entity.Angles)
            
                local playerColor = LocalPlayer():GetColor()
                Entity:SetColor(playerColor)
                Entity:SetNWVector("PlayerColor", Vector(playerColor.r/255, playerColor.g/255, playerColor.b/255))
                
                -- Handle SubMaterials (0 to 32)
                local ply = LocalPlayer()
                if not IsValid(ply) then return end
                
                for i = 0, 32 do
                    local subMat = ply:GetSubMaterial(i)
                    -- Check if the submaterial exists and isn't an empty string
                    if subMat and subMat ~= "" then
                        Entity:SetSubMaterial(i, subMat)
                    end
                end
            end
            local x, y = 10, 30
            local corner = 6
            
            PopulateArmorSlots()
            local x_bg, y_bg = ScrW()/2.70,ScrH()/3.50
            local xpl_bg, ypl_bg = ScrW()/3.4,ScrH()/1.065
            local x, y = ScrW() / 1 - (ScrW() /4), ScrH() / 1.7 - 420
            local size = 64
            
            CreateSlot("head", MainPanel):SetPos(x, y)
            CreateSlot("eyes",MainPanel):SetPos(x + size,y + size)
            CreateSlot("mouthnose",MainPanel):SetPos(x + size,y)
            CreateSlot("ears",MainPanel):SetPos(x,y + size)



            CreateSlot("rightshoulder",MainPanel):SetPos(x,y + size * 2 + 32)
            CreateSlot("rightforearm",MainPanel):SetPos(x,y + size * 3 + 32)
            
            CreateSlot("leftshoulder",MainPanel):SetPos(x + size,y + size * 2 + 32)
            CreateSlot("leftforearm",MainPanel):SetPos(x + size,y + size * 3 + 32)

            CreateSlot("rightthigh",MainPanel):SetPos(x,y + size * 5)
            CreateSlot("rightcalf",MainPanel):SetPos(x,y + size * 6)

            CreateSlot("leftthigh",MainPanel):SetPos(x + size,y + size * 5)
            CreateSlot("leftcalf",MainPanel):SetPos(x+size,y + size * 6)
            CreateSlot("chest",MainPanel):SetPos(x + size ,y + size * 7+64)
            CreateSlot("pelvis",MainPanel):SetPos(x + size,y + size * 7)
            CreateSlot("back",MainPanel):SetPos(x,y + size * 7)

            function PlayerModel:PostDrawModel(ent)
                ent.EZarmor = ply.EZarmor

                JMod.ArmorPlayerModelDraw(ent)
            end
            PlayerModelBG.Paint = function(self, w,h)
                draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
                surface.SetDrawColor(255,255,255,0)
                surface.DrawOutlinedRect(1,1,w - 2,h - 2)
                
            end
            function PlayerModel.Entity:GetPlayerColor() return ply:GetColor() end
            
        end
    elseif hg.ScoreBoard != 2 then
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
        lootEnt = nil
    end
end)
net.Receive("inventory", function()
    lootEnt = net.ReadEntity()
    items = net.ReadTable()
    items_ammo = net.ReadTable()
    if IsValid(ScoreBoardPanel) or IsValid(panelka) then
        if inv_enemy then
            inv_enemy:Remove()
            local enemyPanel = CreateEnemyInventoryPanel(panelka, items, lootEnt)

        end
    else 
        show_scoreboard(true)
        hg.ScoreBoard = 2
    end
end)