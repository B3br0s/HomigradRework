--Хеллоу хукер :3
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




local SubMaterials = {
    -- Male
    ["models/player/group01/male_01.mdl"] = 3,
    ["models/player/group01/male_02.mdl"] = 2,
    ["models/player/group01/male_03.mdl"] = 4,
    ["models/player/group01/male_04.mdl"] = 4,
    ["models/player/group01/male_05.mdl"] = 4,
    ["models/player/group01/male_06.mdl"] = 0,
    ["models/player/group01/male_07.mdl"] = 4,
    ["models/player/group01/male_08.mdl"] = 0,
    ["models/player/group01/male_09.mdl"] = 2,
    -- Female
    ["models/player/group01/female_01.mdl"] = 2,
    ["models/player/group01/female_02.mdl"] = 3,
    ["models/player/group01/female_03.mdl"] = 3,
    ["models/player/group01/female_04.mdl"] = 1,
    ["models/player/group01/female_05.mdl"] = 2,
    ["models/player/group01/female_06.mdl"] = 4
}

local Clothes = {--еее русификатор
    ["Нормальный"] = { [1] = "models/humans/male/group01/normal", [2] = "models/humans/female/group01/normal" },
    ["Формальный"] = { [1] = "models/humans/male/group01/formal", [2] = "models/humans/female/group01/formal" },
    ["Клетчатый"] = { [1] = "models/humans/male/group01/plaid", [2] = "models/humans/female/group01/plaid" },
    ["Полоски"] = { [1] = "models/humans/male/group01/striped", [2] = "models/humans/female/group01/striped" },
    ["Молодой"] = { [1] = "models/humans/male/group01/young", [2] = "models/humans/female/group01/young" },
    ["Куртка"] = { [1] = "models/humans/male/group01/cold", [2] = "models/humans/female/group01/cold" },
    ["Казуал"] = { [1] = "models/humans/male/group01/casual", [2] = "models/humans/female/group01/casual" }
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



-- ДААААА УРАААААА

--[[
TODO:
[1] - драггебейл слоты
[2] - иконки оружий
[3] - Рюкзаки добавить к основному инвентарю(что бы можно было брать в них вещи)
[4] - увеличить интерфейс и добавить лутание игроков
]]

local BL = {
    ["weapon_m4super"] = true,
    ["weapon_870"] = true,
    ["homigrad_base"] = true,
}

local function createinvslot(slotid,parent,backpackid,x,y)--е,копипастим
    local slot = vgui.Create("DPanel", parent)
    slot:SetSize(ScrW()/(backpackid != nil and 30 or 20),ScrW()/(backpackid != nil and 30 or 20))
    slot:SetPos(x,y)
    slot.SlotItem = NULL
    local ply = LocalPlayer()

    if backpackid ~= nil then-- Если рюкзак то ищем в нём предмет если наоборот то в игроке 🔥🔥🔥🔥
        --вывод:боглер нарик ебанный (b3bros) | правда ничего не отрицаю (thebogler)
        local item
        for id,info in pairs(ply.EZarmor.items) do
            if info.IsBackpack then 
                item = info.BackpackSlots[slotid]
                return 
            end
        end
        slot.Paint = function(self,w,h)
            draw.RoundedBox(0, 2, 2, w - 4, h - 4, Color(31, 31, 31, 25))
    
            
            surface.SetDrawColor(255,255,255,185)
    
            surface.DrawOutlinedRect(0,0,w,h,1)
        end
        slot.SlotItem = item
    else

        local item = ply:GetNWEntity("Slot"..slotid)
        if item ~= NULL and !BL[item.Base] then
            local wepdata = (weapons.Get(item:GetClass()) or nil)
            if wepdata == nil then return end
            local wepmodel = wepdata.WorldModel 
        else
            item = NULL 
        end
        slot.SlotItem = item
        slot.Paint = function(self,w,h)
            draw.RoundedBox(0, 2, 2, w - 4, h - 4, Color(31, 31, 31, 200))
    
            surface.SetDrawColor(255,255,255,185)
    
            surface.DrawOutlinedRect(0,0,w,h,1)

            --draw.SimpleText(slot.SlotItem.PrintName,"HOS.18",w,h,Color(255,255,255,50),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        local SlotModel = vgui.Create("DModelPanel",slot)
        SlotModel:SetModel(IsValid(item) and item.WorldModel or " ")
        SlotModel:SetSize(slot:GetWide(),slot:GetTall())
        SlotModel:SetLookAt(Vector(0,-17,0))
        SlotModel:SetCamPos(Vector(40,-17,0))

        function SlotModel:LayoutEntity(ent) ent:SetAngles(Angle(0,90,0)) end
    
    end

end

local function CreateSlot(slotName, parent,customsize)--ЕЕЕ СИСТЕМА СТАРАЯ!!!
    local slot = vgui.Create("DPanel", parent)
    local size = (customsize != nil and customsize or 64)
    slot:SetSize(size, size)

    local ItemID, ItemData, ItemInfo = JMod.GetItemInSlot(LocalPlayer().EZarmor, slotName)
    
    slot.Paint = function(self, w, h)
        draw.RoundedBox(0, 2, 2, w - 4, h - 4, Color(31, 31, 31, 200))

        
        surface.SetDrawColor(255,255,255,185)

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

local RandomTips = {--ЕЕЕ ОБАМКИ!!!
    "Нажмите 'Q' чтобы использовать вакцину прямо сейчас.",
    "Пропишите в консоль 'suicide' а после выстрелите из своего оружия чтобы получить оружие круче.",
    "Не используйте броню чтобы не умереть быстрее.",
    "Не используйте бинты,они могут быть со спидом.",
    "Не используйте аптечки,в их состав входят наркотики. А наркотики это зло."
}

hook.Add("HUDPaint","InventoryPage",function()
    if not ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false return end
    if ScoreBoard == 2 and not open then
        open = true
        local MainPanel = vgui.Create("DFrame", ScoreBoardPanel)
        MainPanel:SetSize(ScrW() / 1.07, ScrH())
        MainPanel:Center()
        MainPanel:SetDraggable(false)
        MainPanel:SetTitle(" ")
        MainPanel:ShowCloseButton(false)
        MainPanel:SetPos(0, MainPanel:GetY())

        local tip = table.Random(RandomTips)

        function MainPanel:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))

            draw.SimpleText(tip,"HOS.18",w / 1.9,h / 1.13,Color(255,255,255,10),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        panelka = MainPanel
        local ply = LocalPlayer()
        local swep_ar2
        for _, weapon in pairs(ply:GetWeapons()) do 
            if IsValid(weapon) and weapon.TwoHanded ~= nil then  
                swep_ar2 = weapon
            end
        end

        local swep_ar2_p
        for _, weapon in pairs(ply:GetWeapons()) do 
            if IsValid(weapon) and weapon.TwoHanded == nil and weapon.Base == 'homigrad_base' then  
                swep_ar2_p = weapon
            end
        end
        local cr2w = vgui.Create("DFrame",MainPanel) 
        cr2w:SetSize(ScrW()/5,ScrH()/6)
        cr2w:SetPos(ScrW()/3,ScrH()/12)
        cr2w:SetDraggable(false)
        cr2w:SetTitle(" ")
        cr2w:ShowCloseButton(false)
        function cr2w:Paint(w, h)
            draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
            if not swep_ar2 then
                draw.SimpleText("Пусто.","HS.25",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
                cr2w.Gun = nil
            else
                cr2w.Gun = swep_ar2
                draw.SimpleText(swep_ar2.PrintName,"HS.25",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
            end

            surface.SetDrawColor(255,255,255,185)

            surface.DrawOutlinedRect(0,0,w,h,1)
        end

        local cr2wmodel = vgui.Create("DModelPanel",cr2w)
        cr2wmodel:SetSize(cr2w:GetWide(),cr2w:GetTall())
        cr2wmodel:SetModel(IsValid(swep_ar2) and swep_ar2.WorldModel or " ")
        cr2wmodel:SetCamPos(Vector(42,18,-5))
        function cr2wmodel:LayoutEntity(ent)

            --print(cr2wmodel:GetCamPos(  ))
            
            cr2wmodel:SetLookAng(Angle(0,180,0))
            --ent:SetPos(Vector(50,50,50))
            ent:SetAngles(Angle(0,90,0))
        end
        function cr2wmodel:DoRightClick()
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

        local cr2p = vgui.Create("DFrame",MainPanel) 
        cr2p:SetSize(ScrH()/6,ScrH()/6)
        cr2p:SetPos(ScrW()/1.8,ScrH()/12)
        cr2p:SetDraggable(false)
        cr2p:SetTitle(" ")
        cr2p:ShowCloseButton(false)
        function cr2p:Paint(w, h)
            draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
            if not swep_ar2_p then
                draw.SimpleText("Пусто.","HS.25",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
            else
                draw.SimpleText(swep_ar2_p.PrintName,"HS.25",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
            end

            surface.SetDrawColor(255,255,255,185)

            surface.DrawOutlinedRect(0,0,w,h,1)
        end

        local cr2pmodel = vgui.Create("DModelPanel",cr2p)
        cr2pmodel:SetSize(cr2w:GetWide(),cr2w:GetTall())
        cr2pmodel:SetModel(IsValid(swep_ar2_p) and swep_ar2_p.WorldModel or " ")
        cr2pmodel:SetCamPos(Vector(30,28,-3.5))
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

            --print(cr2pmodel:GetCamPos(  ))
            
            cr2pmodel:SetLookAng(Angle(0,180,0))
            --ent:SetPos(Vector(50,50,50))
            ent:SetAngles(Angle(0,90,0))
        end

        function cr2p:Paint(w, h)
            draw.RoundedBox(0, 4.5, 4.5, w - 7, h - 7, Color(0, 0, 0, 156))
            if not swep_ar2_p then
                draw.SimpleText("Пусто.","HS.25",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
            else
                draw.SimpleText(swep_ar2_p.PrintName,"HS.25",w/1.03,h/1.03,Color(255,255,255,100),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
            end

            surface.SetDrawColor(255,255,255,185)

            surface.DrawOutlinedRect(0,0,w,h,1)
        end
                
        local PlayerModelBG = vgui.Create("DFrame",panelka)
        PlayerModelBG:SetSize(ScrW()/6,ScrH()/1.7)
        PlayerModelBG:SetPos(ScrW()/13,ScrH()/10)
        PlayerModelBG:SetDraggable(false)
        PlayerModelBG:SetTitle(" ")
        PlayerModelBG:ShowCloseButton(false)
        
        local PlayerModel = vgui.Create("DModelPanel",PlayerModelBG)
        PlayerModel:SetSize(PlayerModelBG:GetWide(),PlayerModelBG:GetTall())
        PlayerModel:SetPos(0,0)
        PlayerModel:SetModel(LocalPlayer():GetModel() )
        PlayerModel:SetFOV( 30 )
        PlayerModel:SetLookAng( Angle( 15, 180, 0 ) )
        PlayerModel:SetCamPos( Vector( 75   , 0, 55 ) )
        local Ply = LocalPlayer()
        local ply = LocalPlayer()--че
        local armorid,ArmorTBL,ArmorTBL2 = GetItemInSlot(ply.EZarmor, "back")
        local AppearanceTableJSON = file.Read("hgr/appearance.json","DATA")
        local AppearanceTable = util.JSONToTable(AppearanceTableJSON)
        function PlayerModel:LayoutEntity( Entity ) 
            Entity.Angles = Entity.Angles or Angle(0,0,0)
            Entity:SetNWVector("PlayerColor",Vector(AppearanceTable.Color.r / 255, AppearanceTable.Color.g / 255, AppearanceTable.Color.b / 255))
            Entity:SetAngles(Entity.Angles)
            Entity:SetSubMaterial()
            Entity:SetSubMaterial(SubMaterials[string.lower(AppearanceTable.Model)],Clothes[AppearanceTable.ClothesStyle][AppearanceTable.Gender])
        end
        
        PopulateArmorSlots()
        local x_bg, y_bg = ScrW()/2.70,ScrH()/3.49
        local xpl_bg, ypl_bg = ScrW()/5,ScrH()/1.097 
        local x, y = ScrW() / 4 - 415, ScrH() / 2 - 420
        local size = 64 -- Так инфа о рюкзаке находится в ArmorTBL | Ну так,о IsBackpack в тбл2 | а окей сорян
        
        if ArmorTBL2 != nil and ArmorTBL2.IsBackpack then
            print()
            if ArmorTBL.BackpackSlots >= 6 then
                local slotscoool = ArmorTBL.BackpackSlots/2
                for i in pairs(ArmorTBL.items_bp) do
                    for i = 1,slotscoool do
                        print(i)
                        createinvslot(i,MainPanel,10,x_bg+(i*64.13),y_bg)
                    end
                end
                for i in pairs(ArmorTBL.items_bp) do
                    for i = slotscoool+1,ArmorTBL.BackpackSlots do
                        print(i)
                        createinvslot(i,MainPanel,10,(x_bg+(i*64.13))-(slotscoool*64.17),y_bg+62)
                    end
                end
            else
                for i in pairs(ArmorTBL.items_bp) do
                    for i = 1,ArmorTBL.BackpackSlots do
                        createinvslot(i,MainPanel,10,x_bg+(i*64.13),y_bg)
                    end
                end
            end

        end
        
        --PrintTable(ply)
        for i=1,ply:GetNWFloat("SlotsAvaible") do
            createinvslot(i,MainPanel,nil,xpl_bg+(i*96),ypl_bg)
        end
        
        CreateSlot("head", MainPanel):SetPos(x, y)
        CreateSlot("eyes",MainPanel):SetPos(x + size,y + size)
        CreateSlot("mouthnose",MainPanel):SetPos(x + size,y)
        CreateSlot("ears",MainPanel):SetPos(x,y + size)

        CreateSlot("acc_head",MainPanel):SetPos(x + size * 5.5,y)
        CreateSlot("acc_eyes",MainPanel):SetPos(x + size * 6.5,y)
        CreateSlot("acc_neck",MainPanel):SetPos(x + size * 5.5,y + size)
        CreateSlot("acc_ears",MainPanel):SetPos(x + size * 6.5,y + size)

        CreateSlot("rightshoulder",MainPanel):SetPos(x,y + size * 2 + 32)
        CreateSlot("rightforearm",MainPanel):SetPos(x,y + size * 3 + 32)
        
        CreateSlot("leftshoulder",MainPanel):SetPos(x + size,y + size * 2 + 32)
        CreateSlot("leftforearm",MainPanel):SetPos(x + size,y + size * 3 + 32)

        CreateSlot("rightthigh",MainPanel):SetPos(x + size,y + size * 6 + 32)
        CreateSlot("rightcalf",MainPanel):SetPos(x + size,y + size * 7 + 32)

        CreateSlot("leftthigh",MainPanel):SetPos(x + size * 5.5,y + size * 6 + 32)
        CreateSlot("leftcalf",MainPanel):SetPos(x + size * 5.5,y + size * 7 + 32)

        CreateSlot("chest",MainPanel):SetPos(x + size * 5.5,y + size * 5)
        CreateSlot("pelvis",MainPanel):SetPos(x + size * 6.5,y + size * 5)
        CreateSlot("back",MainPanel):SetPos(x,y + size * 5)
        
        CreateSlot("back",MainPanel,128):SetPos(ScrW()/3,ScrH()/3.5)

        CreateSlot("acc_chestrig",MainPanel):SetPos(x + size,y + size * 5)

        CreateSlot("armband",MainPanel):SetPos(x + size * 5.5,y + size * 2 + 32)

        function PlayerModel:PostDrawModel(ent)
            ent.EZarmor = Ply.EZarmor

            JMod.ArmorPlayerModelDraw(ent)
        end
        PlayerModelBG.Paint = function(self, w,h)
            draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
			surface.SetDrawColor(255,255,255,0)
			surface.DrawOutlinedRect(1,1,w - 2,h - 2)
            
        end
        function PlayerModel.Entity:GetPlayerColor() return Vector(AppearanceTable.Color.r / 255, AppearanceTable.Color.g / 255, AppearanceTable.Color.b / 255) end
        
    elseif ScoreBoard != 2 then
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
    end
end)