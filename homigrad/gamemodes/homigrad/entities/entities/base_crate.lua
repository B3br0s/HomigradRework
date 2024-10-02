AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Обычный Ящик"
ENT.Author = "Homigrad"
ENT.Spawnable = true
ENT.BeingLooted = false
ENT.AdminSpawnable = false
ENT.OpenedBefore = false

local items = {
    {item = "Empty", icon = "null.vmt", rarity = "None"},
    {item = "weapon_glock", icon = "vgui/weapon_csgo_glock.png", rarity = "Ultra Rare"},
    {item = "weapon_r8", icon = "vgui/weapon_csgo_revolver.png", rarity = "Ultra Rare"},
    {item = "painkiller", icon = "vgui/pills.png", rarity = "UnCommon"},
    {item = "weapon_t", icon = "vgui/tomahawk.png", rarity = "Rare"},
    {item = "food_fishcan", icon = "vgui/fishcan.png", rarity = "Common"},
    {item = "food_lays", icon = "vgui/chips.png", rarity = "Common"},
    {item = "weapon_de", icon = "vgui/weapon_csgo_deagle.png", rarity = "Ultra Rare"},
    {item = "weapon_fnp", icon = "vgui/weapon_csgo_tec9.png", rarity = "Ultra Rare"},
    {item = "Empty", icon = "null.vmt", rarity = "None"},
    {item = "Empty", icon = "null.vmt", rarity = "None"}
}

if SERVER then
    util.AddNetworkString("BoxOpen")
    util.AddNetworkString("BoxClose")
    util.AddNetworkString("BoxLoot")
    util.AddNetworkString("BoxSendItems")

    function ENT:Initialize()
        self:SetModel("models/props_crates/supply_crate01_static.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)

        self.R1 = math.random(1, #items)
        self.R2 = math.random(1, #items)
        self.R3 = math.random(1, #items)
        self.R4 = math.random(1, #items)

        self.Item1 = "Empty"
        self.Item2 = "Empty"
        self.Item3 = "Empty"
        self.Item4 = "Empty"

        self.AmountOfDrop = math.random(1, 4)
        self.Item1 = items[self.R1].item
        if self.AmountOfDrop >= 2 then self.Item2 = items[self.R2].item end
        if self.AmountOfDrop >= 3 then self.Item3 = items[self.R3].item end
        if self.AmountOfDrop == 4 then self.Item4 = items[self.R4].item end 
        
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
    end

    net.Receive("BoxClose", function(len, ply)
        local entity = net.ReadEntity()
        if IsValid(entity) then
            entity.BeingLooted = false
        end
    end)

    net.Receive("BoxLoot", function(len, ply)
        local entity = net.ReadEntity()
        local slot = net.ReadFloat()

        if not IsValid(entity) or not IsValid(ply) then return end

        local itemlooted = net.ReadString()
        if slot == 1 and entity.Item1 != "Empty" then
            itemlooted = entity.Item1
            entity.R1 = 1
            entity.Item1 = "Empty"
        elseif slot == 2 and entity.Item2 != "Empty" then
            itemlooted = entity.Item2
            entity.R2 = 1
            entity.Item2 = "Empty"
        elseif slot == 3 and entity.Item3 != "Empty" then
            itemlooted = entity.Item3
            entity.R3 = 1
            entity.Item3 = "Empty"
        elseif slot == 4 and entity.Item4 != "Empty" then
            itemlooted = entity.Item4
            entity.R4 = 1
            entity.Item4 = "Empty"
        end

        if itemlooted and itemlooted != "Empty" then
            ply:Give(itemlooted)
        end
    end)

    function ENT:Use(ply)
        if self.BeingLooted == false then
            self.BeingLooted = true
            net.Start("BoxOpen")
            net.WriteEntity(self)
            net.WriteUInt(self.AmountOfDrop, 8)
            net.WriteUInt(self.R1, 8)
            net.WriteUInt(self.R2, 8)
            net.WriteUInt(self.R3, 8)
            net.WriteUInt(self.R4, 8)
            net.Send(ply)
        end
    end
end

if CLIENT then
    local function openVgui(ent, amt)
        local looting = false
        local panel = vgui.Create("DFrame")
        panel:SetSize(340, 80)
        panel:Center()
        panel:SetTitle(" ")
        panel:SetDraggable(false)
        panel:ShowCloseButton(false)
        panel:MakePopup()


        panel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(31, 31, 31, 255))
        end

        panel.Think = function(self)
            if looting then return end
            local mx, my = input.GetCursorPos()
            local px, py = self:GetPos()
            local pw, ph = self:GetSize()

            if input.IsMouseDown(MOUSE_LEFT) and (mx < px or mx > (px + pw) or my < py or my > (py + ph)) then
                surface.PlaySound("homigrad/vgui/item_drop.wav")

                net.Start("BoxClose")
                net.WriteEntity(ent)
                net.SendToServer()

                self:Close()
            end
        end

        local receivedItems = {R1, R2, R3, R4}
        local itemData = {}

        if amt == 1 then
            itemData[1] = items[receivedItems[1]]
            itemData[2] = items[1]
            itemData[3] = items[1]
            itemData[4] = items[1]
        elseif amt == 2 then
            itemData[1] = items[receivedItems[1]]
            itemData[2] = items[receivedItems[2]]
            itemData[3] = items[1]
            itemData[4] = items[1]
        elseif amt == 3 then
            itemData[1] = items[receivedItems[1]]
            itemData[2] = items[receivedItems[2]]
            itemData[3] = items[receivedItems[3]]
            itemData[4] = items[1]
        elseif amt == 4 then
            itemData[1] = items[receivedItems[1]]
            itemData[2] = items[receivedItems[2]]
            itemData[3] = items[receivedItems[3]]
            itemData[4] = items[receivedItems[4]]
        end
        for i = 1, 4 do
            local lootf = vgui.Create("DFrame", panel)
            lootf:SetSize(80, 80)
            lootf:Dock(LEFT)
            lootf:ShowCloseButton(false)
            lootf:DockMargin(0, -25, 3, 0)
            lootf:DockPadding(0, 0, 1, 0)
            lootf:SetTitle("")

            lootf.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(41, 41, 41, 255))
            end

            local loot = vgui.Create("DImageButton", lootf)
            loot:SetSize(70, 70)
            loot:Dock(FILL)
            loot.Item = itemData[i].item
            loot:SetImage(itemData[i].icon)

            loot.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(41, 41, 41, 0))
            end

            function loot:DoClick()
                if loot.Item != "Empty" then
                    local loading = vgui.Create("DImage", loot)
                    loading:SetImage("homigrad/vgui/loading.png")
                    loading:SetSize(50, 50)
                    loading:Center()
                    looting = true

                    local rotationAngle = 0

                    loading.Paint = function(self, w, h)
                        rotationAngle = (rotationAngle + 5) % 360
                        local cx, cy = w / 2, h / 2
                        surface.SetDrawColor(255, 255, 255, 255)
                        surface.SetMaterial(self:GetMaterial())
                        surface.DrawTexturedRectRotated(cx, cy, w, h, rotationAngle)
                    end

                    for y = 1, 6 do
                        timer.Simple(0.05 * y, function()
                            if y == 6 then
                                looting = false
                                loading:Remove()
                                surface.PlaySound("homigrad/vgui/panorama/cards_draw_one_01.wav")
                                net.Start("BoxLoot")
                                net.WriteEntity(ent)
                                net.WriteFloat(i)
                                net.WriteString(loot.Item)
                                loot.Item = "Empty"
                                if i == 1 then
                                    R1 = 1
                                elseif i == 2 then
                                    R2 = 1
                                elseif i == 3 then
                                    R3 = 1
                                elseif i == 4 then
                                    R4 = 1
                                end
                                loot:SetImage("null.vmt")
                                net.SendToServer()
                            end
                        end)
                    end
                end
            end
        end

        surface.PlaySound("homigrad/vgui/item_drop1_common.wav")
    end

    net.Receive("BoxOpen", function()
        local ent = net.ReadEntity()
        local amt = net.ReadUInt(8)
        R1 = net.ReadUInt(8)
        R2 = net.ReadUInt(8)
        R3 = net.ReadUInt(8)
        R4 = net.ReadUInt(8)

        openVgui(ent, amt)
    end)
end
