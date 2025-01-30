local blurMat = Material("pp/blurscreen")
local Dynamic = 0
local FriendMenuOpen = false
local SelectionMenuOpen = false
local YesMat = Material("icon16/accept.png")
local NoMat = Material("icon16/cancel.png")
local FavMat = Material("icon16/star.png")
local FriendMat = Material("icon16/user_green.png")
local NotFriendMat = Material("icon16/user_red.png")

local function BlurBackground(panel)
	if not((IsValid(panel))and(panel:IsVisible()))then return end
	local layers,density,alpha=1,1,255
	local x,y=panel:LocalToScreen(0,0)
	surface.SetDrawColor(255,255,255,alpha)
	surface.SetMaterial(blurMat)
	local FrameRate,Num,Dark=1/FrameTime(),5,150
	for i=1,Num do
		blurMat:SetFloat("$blur",(i/layers)*density*Dynamic)
		blurMat:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x,-y,ScrW(),ScrH())
	end
	surface.SetDrawColor(0,0,0,Dark*Dynamic)
	surface.DrawRect(0,0,panel:GetWide(),panel:GetTall())
	Dynamic=math.Clamp(Dynamic+(1/FrameRate)*7,0,1)
end

local function GetItemInSlot(armorTable, slot)
		if not (armorTable and armorTable.items) then return nil end

		for id, armorData in pairs(armorTable.items) do
			local ArmorInfo = JMod.ArmorTable[armorData.name]
			if ArmorInfo.slots[slot] then return id, armorData, ArmorInfo end
		end

		return nil
	end

local ArmorSlotButtons = {
	{
		title = "Drop",
		actionFunc = function(slot, itemID, itemData, itemInfo)
			net.Start("JMod_EFT_Inventory")
			net.WriteInt(1, 8) -- drop
			net.WriteString(itemID)
			net.SendToServer()
		end
	},
	{
		title = "Toggle",
		visTestFunc = function(slot, itemID, itemData, itemInfo) return itemInfo.tgl end,
		actionFunc = function(slot, itemID, itemData, itemInfo)
			net.Start("JMod_EFT_Inventory")
			net.WriteInt(2, 8) -- toggle
			net.WriteString(itemID)
			net.SendToServer()
		end
	},
	{
		title = "Repair",
		visTestFunc = function(slot, itemID, itemData, itemInfo) return itemData.dur < itemInfo.dur * .9 end,
		actionFunc = function(slot, itemID, itemData, itemInfo)
			net.Start("JMod_EFT_Inventory")
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
			net.Start("JMod_EFT_Inventory")
			net.WriteInt(4, 8) -- recharge
			net.WriteString(itemID)
			net.SendToServer()
		end
	}
}

local ArmorResourceNiceNames = {
	chemicals = "Chemicals",
	power = "Electricity",
	gas = "Compressed Gas"
}

local OpenDropdown = nil

local function CreateArmorSlotButton(parent, slot, x, y)
	local Buttalony, Ply = vgui.Create("DButton", parent), LocalPlayer()
	Buttalony:SetSize(180, 40)
	Buttalony:SetPos(x, y)
	Buttalony:SetText("")
	Buttalony:SetCursor("hand")
	local ItemID, ItemData, ItemInfo = JMod.GetItemInSlot(Ply.EZarmor, slot)

	function Buttalony:Paint(w, h)
		surface.SetDrawColor(50, 50, 50, 100)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText(JMod.ArmorSlotNiceNames[slot], "DermaDefault", Buttalony:GetWide() / 2, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		local Str = "--EMPTY--"
		if ItemID then
			Str = ItemData.name --..": "..math.Round(ItemData.dur/ItemInfo.dur*100).."%"

			if ItemData.tgl and ItemInfo.tgl.slots[slot] == 0 then
				Str = "DISENGAGED"
			end
		end
		draw.SimpleText(Str, "DermaDefault", Buttalony:GetWide() / 2, 25, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if ItemID then
		local str = "Durability: " .. math.Round(ItemData.dur, 1) .. "/" .. ItemInfo.dur

		if ItemInfo.chrg then
			for resource, maxAmt in pairs(ItemInfo.chrg) do
				str = str .. "\n" .. ArmorResourceNiceNames[resource] .. ": " .. math.Round(ItemData.chrg[resource], 1) .. "/" .. maxAmt
			end
		end

		Buttalony:SetTooltip(str)
	else
		Buttalony:SetTooltip("slot is empty")
	end

	function Buttalony:DoClick()
		if OpenDropdown then
			OpenDropdown:Remove()
		end

		if not ItemID then return end
		local Options = {}

		for k, option in pairs(ArmorSlotButtons) do
			if not option.visTestFunc or option.visTestFunc(slot, ItemID, ItemData, ItemInfo) then
				table.insert(Options, option)
			end
		end

		local Dropdown = vgui.Create("DPanel", parent)
		Dropdown:SetSize(Buttalony:GetWide(), #Options * 40)
		local ecks, why = gui.MousePos()
		local harp, darp = parent:GetPos()
		local fack, fock = parent:GetSize()
		local floop, florp = Dropdown:GetSize()
		Dropdown:SetPos(math.Clamp(ecks - harp, 0, fack - floop), math.Clamp(why - darp, 0, fock - florp))

		function Dropdown:Paint(w, h)
			surface.SetDrawColor(70, 70, 70, 220)
			surface.DrawRect(0, 0, w, h)
		end

		for k, option in pairs(Options) do
			local Butt = vgui.Create("DButton", Dropdown)
			Butt:SetPos(5, k * 40 - 35)
			Butt:SetSize(floop - 10, 30)
			Butt:SetText(option.title)

			function Butt:DoClick()
				option.actionFunc(slot, ItemID, ItemData, ItemInfo)
				if IsValid(parent) then
					parent:Close()
				end
			end
		end

		OpenDropdown = Dropdown
	end
end

net.Receive("JMod_ItemInventory", function(len, sender) -- for when we pick up stuff with JMOD HANDS
	local invEnt = net.ReadEntity()
	local command = net.ReadString()
	local newInv = net.ReadTable()

	if not(IsValid(invEnt)) then 
		invEnt = LocalPlayer()
	end

	invEnt.JModInv = newInv

	if command == "open_menu" then
		local frame = vgui.Create("DFrame")
		frame:SetSize(210, 312)
		frame:SetTitle((invEnt.PrintName or invEnt:GetClass() or "Player"))
		frame:Center()
		frame:MakePopup()
		--frame:SetKeyboardInputEnabled(false)

		frame.OnClose = function()
			if OpenDropdown then
				OpenDropdown:Remove()
			end
			frame = nil
		end

		frame.Paint = function(self, w, h)
			BlurBackground(self)
		end

		local scrollPanel = vgui.Create("DScrollPanel", frame)
		scrollPanel:SetSize(200, 370)
		scrollPanel:SetPos(5, 30)
		
		local ShownItems = 0
		if newInv then
			for k, v in ipairs(newInv.items) do
				CreateInvButton(frame, v, (ShownItems % 4 * 50), (math.floor(ShownItems/4) * 50), 50, 50, scrollPanel, invEnt)
				ShownItems = ShownItems + 1
			end
			if newInv.EZresources then
				for k, v in pairs(newInv.EZresources) do
					CreateResButton(frame, k, v, (ShownItems % 4 * 50), (math.floor(ShownItems/4) * 50), 50, 50, scrollPanel, invEnt)
					ShownItems = ShownItems + 1
				end
			end
		end
		local Status = vgui.Create("DLabel", frame)
		Status:SetSize(200, 10)
		Status:SetPos(2, 300)
		--Status:SetText("Current Inventory Space: " .. tostring(invEnt.JModInv.volume) .. "/" .. tostring(invEnt.JModInv.maxVolume))
	end
end)

local function CreateCommandButton(parent, commandTbl, x, y, num)
	local Buttalony, Ply = vgui.Create("DButton", parent), LocalPlayer()
	Buttalony:SetSize(180, 20)
	Buttalony:SetPos(x, y)
	Buttalony:SetText("")
	Buttalony:SetCursor("hand")

	function Buttalony:Paint(w, h)
		surface.SetDrawColor(50, 50, 50, 100)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText(num..": "..commandTbl.name, "DermaDefault", Buttalony:GetWide() / 2, 10, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local HelpStr = commandTbl.helpTxt
	if commandTbl.adminOnly then
		HelpStr = "ADMIN ONLY!\n"..commandTbl.helpTxt
	end
		
	Buttalony:SetTooltip(HelpStr)

	function Buttalony:DoClick()
		Ply:ConCommand("jmod_ez_"..commandTbl.name)
		if IsValid(parent) then
			parent:Close()
		end
	end
end


net.Receive("JMod_EFT_Inventory", function()
	local Ply = LocalPlayer()
	local weight = Ply.EZarmor.totalWeight
	local PlyModel = net.ReadString()
	--local itemTable = net.ReadTable()
	--Ply.JModInv = itemTable

	--PrintTable(Ply.JModInv)

	local motherFrame = vgui.Create("DFrame")
	motherFrame:SetSize(800, 400)
	motherFrame:SetVisible(true)
	motherFrame:SetDraggable(true)
	motherFrame:ShowCloseButton(true)
	--motherFrame:SetTitle("EFT Accessories Inventory | Current Inventory Weight: " .. weight .. "kg. | Current Inventory Volume: " .. tostring(Ply.JModInv.volume) .. "/" .. tostring(Ply.JModInv.maxVolume))
	motherFrame:SetTitle("EFT Accessories Inventory | Current Inventory Weight: " .. weight .. "kg.")

	function motherFrame:Paint()
		BlurBackground(self)
	end

	motherFrame:MakePopup()
	motherFrame:Center()

	function motherFrame:OnKeyCodePressed(key)
		if key == KEY_Q or key == KEY_ESCAPE or key == KEY_E then
			self:Close()
		end
	end

	function motherFrame:OnClose()
		if OpenDropdown then
			OpenDropdown:Remove()
		end
	end

	local PDispBG = vgui.Create("DPanel", motherFrame)
	PDispBG:SetPos(200, 30)
	PDispBG:SetSize(200, 360)

	function PDispBG:Paint(w, h)
		surface.SetDrawColor(50, 50, 50, 100)
		surface.DrawRect(0, 0, w, h)
	end

	local PlayerDisplay = vgui.Create("DModelPanel", PDispBG)
	PlayerDisplay:SetPos(0, 0)
	PlayerDisplay:SetSize(PDispBG:GetWide(), PDispBG:GetTall())
	PlayerDisplay:SetModel(PlyModel or Ply:GetModel())
	PlayerDisplay:SetLookAt(PlayerDisplay:GetEntity():GetBonePosition(0))
	PlayerDisplay:SetFOV(37)
	PlayerDisplay:SetCursor("arrow")
	local Ent = PlayerDisplay:GetEntity()

	local PDispBT = vgui.Create("DButton", motherFrame)
	PDispBT:SetPos(200, 30)
	PDispBT:SetSize(200, 360)
	PDispBT:SetText("")

	function PDispBT:Paint(w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.DrawRect(0, 0, w, h)
	end

	local entAngs = nil
	local curDif = nil
	local lastCurPos = input.GetCursorPos()
	local doneOnce = false

	function PlayerDisplay:LayoutEntity(ent)

		if not PDispBT:IsDown() then
			entAngs = ent:GetAngles()
			doneOnce = false
		else
			if not doneOnce then
				lastCurPos = input.GetCursorPos()
				doneOnce = true
			end

			curDif = input.GetCursorPos() - lastCurPos
			
			ent:SetAngles( Angle( 0, entAngs.y + curDif % 360, 0 ) )
		end
	end

	Ent:SetSkin(Ply:GetSkin())
	--Ent:SetColor(Color(255, 208, 0))
	--Ent:SetMaterial("models/mat_jack_aidboxside")
	for k, v in pairs( Ply:GetBodyGroups() ) do
		local cur_bgid = Ply:GetBodygroup( v.id )
		Ent:SetBodygroup( v.id, cur_bgid )
	end
	Ent.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end
	
	
	if Ply.EZarmor.suited then
		Ent:SetColor(Ply:GetColor())
		if Ply.EZarmor.bodygroups then
			for k, v in pairs(Ply.EZarmor.bodygroups) do
				Ent:SetBodygroup(k, v)
			end
		end
	end

	function PlayerDisplay:PostDrawModel(ent)
		ent.EZarmor = Ply.EZarmor
		JMod.ArmorPlayerModelDraw(ent)
	end

	function PlayerDisplay:DoClick()
		if OpenDropdown then
			OpenDropdown:Remove()
		end
	end

	function motherFrame:OnRemove()
		local ent = PlayerDisplay:GetEntity()
		if not ent.EZarmor then return end
		if not ent.EZarmor.items then return end

		for id, v in pairs(ent.EZarmor.items) do
			if(ent.EZarmorModels[id])then ent.EZarmorModels[id]:Remove() end
		end
	end

	local ArmorButtonsLeft = {"acc_head", "acc_eyes", "acc_ears", "acc_neck", "aventail"}
	local ArmorButtonsRight = {"acc_chestrig", "armband", "acc_rshoulder", "acc_lshoulder"}

	---
	for k, v in ipairs(ArmorButtonsLeft) do
		CreateArmorSlotButton(motherFrame, v, 10, 30 + ((k - 1) * 45))
	end
	---
	for k, v in ipairs(ArmorButtonsRight) do
		CreateArmorSlotButton(motherFrame, v, 410, 30 + ((k - 1) * 45))
	end
	local ShownCommands = {}
	for k, v in ipairs(JMod.EZ_CONCOMMANDS) do
		if v.noShow and v.noShow == true then continue end
		CreateCommandButton(motherFrame, v, 600, 30 + (#ShownCommands * 25), #ShownCommands + 1)
		table.insert(ShownCommands, v.name)
	end
	--[[
	--Item Inventory
	local DScrollyPanel = vgui.Create( "DScrollPanel", motherFrame )
	DScrollyPanel:SetPos(600, 30 + (#ShownCommands * 25))
	DScrollyPanel:SetSize(180, 370-(#ShownCommands * 25))
	
	local ShownItems = 0
	local ButtonSize = 55
	if Ply.JModInv then
		for k, v in ipairs(Ply.JModInv.items) do
			CreateInvButton(motherFrame, v, (ShownItems % 3 * ButtonSize), (math.floor(ShownItems/3) * ButtonSize), ButtonSize, ButtonSize, DScrollyPanel, Ply)
			ShownItems = ShownItems + 1
		end
		for k, v in pairs(Ply.JModInv.EZresources) do
			CreateResButton(motherFrame, k, v, (ShownItems % 3 * ButtonSize), (math.floor(ShownItems/3) * ButtonSize), ButtonSize, ButtonSize, DScrollyPanel, Ply, k)
			ShownItems = ShownItems + 1
		end
	end
	if ShownItems <= 0 then
		local InfoLabel = vgui.Create("DLabel", motherFrame)
		InfoLabel:SetPos(610, 100 + (#ShownCommands * 25))
		InfoLabel:SetSize(300, 20)
		InfoLabel:SetText("Use JMod Hands to pick up items")
	end

	function motherFrame:OnKeyCodePressed(num)
		if num > 10 then return end
		if num == 1 then num = 11 end -- Weird wrap around for the 0 slot
		if ShownCommands[num - 1] then
			Ply:ConCommand("jmod_ez_"..ShownCommands[num - 1])
		end
		motherFrame:Close()
		return true
	end
	]]
end)
