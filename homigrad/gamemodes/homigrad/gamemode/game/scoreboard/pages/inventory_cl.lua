local Panel = ScoreboardPages[2] or {}
ScoreboardPages[2] = Panel

Panel.Name = "inventory"

local SetDrawColor,DrawRect = surface.SetDrawColor,surface.DrawRect

local ArmorSlotButtons = {
	{
		title = "Drop",
		actionFunc = function(slot, itemID, itemData, itemInfo)
			net.Start("JMod_Inventory")
			net.WriteInt(1, 8) -- drop
			net.WriteString(itemID)
			net.SendToServer()
		end
	},
	{
		title = "Toggle",
		visTestFunc = function(slot, itemID, itemData, itemInfo) return itemInfo.tgl end,
		actionFunc = function(slot, itemID, itemData, itemInfo)
			net.Start("JMod_Inventory")
			net.WriteInt(2, 8) -- toggle
			net.WriteString(itemID)
			net.SendToServer()
		end
	},
	{
		title = "Repair",
		visTestFunc = function(slot, itemID, itemData, itemInfo) return itemData.dur < itemInfo.dur * .9 end,
		actionFunc = function(slot, itemID, itemData, itemInfo)
			net.Start("JMod_Inventory")
			net.WriteInt(3, 8) -- repair
			net.WriteString(itemID)
			net.SendToServer()
		end
	},
	{
		title = "Recharge",
		visTestFunc = function(slot, itemID, itemData, itemInfo)
			if itemInfo.chrg then
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
		end
	}
}

local ArmorResourceNiceNames = {
	chemicals = "Chemicals",
	power = "Electricity"
}

net.Receive("update armor ui",function()
    if IsValid(InvArmorFrame) then InvArmorFrame:UpdateInv() end
end)

local empty = {}

local function CreateSlot(name,parent)
    local slot = oop.CreatePanel("v_inv_slot",parent):setSize(64 * ScreenSize,64 * ScreenSize)
    slot.slotX = 0
    slot.slotY = 0
    slot.inv = {}
    slot.slotName = name
    
    parent.slots[slot] = true

    function slot:Draw(w,h)
        SetDrawColor(15,15,15,125)
        DrawRect(0,0,w,h)

        if self:IsHovered() then
            if self:IsDown() then
                surface.SetDrawColor(0,0,0,5)
            else
                surface.SetDrawColor(255,255,255,5)
            end

            surface.DrawRect(0,0,w,h)
        end

        local ItemID,ItemData,specs = JMod.GetItemInSlot(LocalPlayer().EZarmor,name)

        slot:SetItem(specs and specs.ent or false)

        if ItemData then
            local col = ItemData.col
            self:DrawItem(w,h,col.r,col.g,col.b)
            
            local k = ItemData.dur / specs.dur

            surface.SetDrawColor(200,200,200)
            surface.DrawRect(0,h - 2,w * k,2)

            local i = 0

            for name,v in pairs(ItemData.chrg or empty) do
                if name == "power" then
                    surface.SetDrawColor(200,200,0)
                else
                    surface.SetDrawColor(200,0,255)
                end

                surface.DrawRect(0,h - 4 - (2 * i) - (1 * (i + 1 )),w * k,2)
            end
        end

        draw.Frame(0,0,w,h,c2,c1)
    end

    function slot:InvDrop()
        RunConsoleCommand("hg_inv_drop_armor",tostring(name))
    end

    function slot:InvMove(inv1,inv2,x1,y1,x2,y2,count)
        RunConsoleCommand("hg_inv_move_armor",tostring(name),inv2,x2,y2)
    end
    
    function slot:InvMove2(inv1,inv2,x1,y1,x2,y2,count)
        RunConsoleCommand("hg_inv_equip_armor",inv1,x1,y1)
    end

    slot.donotpressright = true--mdam...

    slot:Event_Add("Mouse","Derma",function(self,key,value)
        if not value or key ~= MOUSE_RIGHT then return end

        for k, option in pairs(ArmorSlotButtons) do
            local ItemID,ItemData,specs = JMod.GetItemInSlot(LocalPlayer().EZarmor,name)
            
			if not option.visTestFunc or option.visTestFunc(nil,ItemID,ItemData,specs) then
				local menu = DermaMenu()
                menu:SetParent(parent)
                menu:AddOption(option.title,function()
                    option.actionFunc(nil,ItemID,ItemData,specs)
                end)
                menu:SetPos(mousex,mousey)
                menu:SetZPos(1000)
			end
		end
    end,-10)

    return slot
end

function Panel.Open(frame)
    if not LocalPlayer():Alive() then
        function frame:Draw(w,h)
            draw.SimpleText("Ты мёртв.","H.45",w / 2,h / 2,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        return
    end

    frame.slots = {}

    InvArmorFrame = frame

    local playerModel = oop.CreatePanel("v_playermodel",frame):ad(function(self,w,h) self:setSize(w * 0.2 * ScreenSize,h * 0.7 * ScreenSize):setPos(75 + 64,scrh / 2 - self:H() / 2 - 75 * ScreenSize) end)
    playerModel:SetPlayer(LocalPlayer())

    playerModel:Event_Add("Draw","Background",function(self,w,h)
        SetDrawColor(0,0,0,100)
        DrawRect(0,0,w,h)
        draw.GradientDown(0,0,w,h)
    end,-1)

    function frame:InputLSHIFT(butt)
        if not IsValid(InvPanelOther) then return end

        butt.waitQueue = true

        InvPlaySndDecay(butt:GetItemTable(),"InvMoveSnd","InvMoveSnd",InvMoveSnd,-20,-0.3)
        InvMoveQueueAdd({butt,"hg_inv_move_armor",butt.slotName,InvPanelOther.inv.id})
    end
    
    function frame:UpdateInv()
        for i,child in pairs(self:GetChildren()) do
            if child.UpdateInv then child:UpdateInv() end
        end
    end

    playerModel:ad(function()
        for slot in pairs(frame.slots) do
            if IsValid(slot) then slot:Remove() end

            frame.slots[slot] = nil
        end

        local x,y = playerModel.x + playerModel:W(),playerModel.y

        local size = 64 * ScreenSize

        CreateSlot("head",frame):setPos(x,y)
        CreateSlot("eyes",frame):setPos(x + size,y + size)
        CreateSlot("mouthnose",frame):setPos(x + size,y)

        CreateSlot("ears",frame):setPos(x,y + size)
        
        CreateSlot("rightshoulder",frame):setPos(x,y + size * 2 + 32)
        CreateSlot("rightforearm",frame):setPos(x,y + size * 3 + 32)

        CreateSlot("rightthigh",frame):setPos(x,y + size * 6 + 32)
        CreateSlot("rightcalf",frame):setPos(x,y + size * 7 + 32)

        CreateSlot("chest",frame):setPos(x,y + size * 5)
        CreateSlot("pelvis",frame):setPos(x + size,y + size * 5)

        x = playerModel.x - size

        CreateSlot("leftshoulder",frame):setPos(x,y + size * 2 + 32)
        CreateSlot("leftforearm",frame):setPos(x,y + size * 3 + 32)

        CreateSlot("leftthigh",frame):setPos(x,y + size * 6 + 32)
        CreateSlot("leftcalf",frame):setPos(x,y + size * 7 + 32)

        CreateSlot("acc_head",frame):setPos(x,y)
        CreateSlot("acc_eyes",frame):setPos(x - size,y)
        CreateSlot("acc_neck",frame):setPos(x,y + size)
        CreateSlot("acc_ears",frame):setPos(x - size,y + size)

        CreateSlot("acc_lshoulder",frame):setPos(x - size,y + size * 2 + 32)
        CreateSlot("acc_rshoulder",frame):setPos(x - size,y + size * 3 + 32)

        CreateSlot("acc_backpack",frame):setPos(x - size,y + size * 5)
        CreateSlot("acc_chestrig",frame):setPos(x,y + size * 5)
        CreateSlot("armband",frame):setPos(x - size,y + size * 6 + 32)
    end)
end

function Panel.Hovered(value,isClose)
    INVOPEN = value

    --InvCloseK = (isClose and 1) or (value and 1 or 0)
end

//if Initialize then OpenTab() end

function ScoreboardInvOpen()
    ScoreboardPage = 2

    if ScoreboardStatus ~= true then
        OpenTab()
    end
end

function ScoreboardInvClose()
    if ScoreboardStatus ~= nil then CloseTab() end
end

event.Add("Player Death","Inventory UI",function(ply)
    if ply ~= LocalPlayer() then return end

    timer.Simple(0.1,function()--BLAAAAAAAAAAAAAAAAAAAAAAAAD
        if IsValid(ScoreboardFrame) then ScoreboardFrame:UpdateButtons() end
    end)
end)

event.Add("Player Spawn","Inventory UI",function(ply)
    if ply ~= LocalPlayer() then return end

    if IsValid(ScoreboardFrame) then ScoreboardFrame:UpdateButtons() end
end)

function Panel.CanOpen() return LocalPlayer():Alive() end