local enable = false
if CLIENT and enable then
	local blacklistweapon = { ["weapon_hands"] = true } -- Initialize blacklist with the correct table format

	local WeaponInventory = nil
	local fastslotitem = nil
	local daun = false
	local Weapons = {}
	local daun2 = false
	local Slots = {}
	local MaxSlots = 5
	local MaxWeapons = MaxSlots + 1 -- Set a limit of weapons a player can have
	local InventoryOpen = false
	local dragPanel = nil

	-- Disable the default weapon HUD
	hook.Add("HUDShouldDraw", "HideDefaultWeaponSelection", function(name)
		if name == "CHudWeaponSelection" then return false end
	end)

	-- Function to drop excess weapons
	local function DropExcessWeapons()
		local playerWeapons = LocalPlayer():GetWeapons()
		if #playerWeapons > MaxWeapons then
			-- Drop the excess weapons
			for i = MaxWeapons + 1, #playerWeapons do
				local weaponToDrop = playerWeapons[i]
				if IsValid(weaponToDrop) and not blacklistweapon[weaponToDrop:GetClass()] then
					RunConsoleCommand("use", weaponToDrop:GetClass()) -- Select the weapon
					RunConsoleCommand("say", "*drop") -- Drop the weapon
					if daun2 == false then
						daun2 = true
						timer.Simple(0.05	,function() LocalPlayer():ChatPrint("У тебя нет места в инвентаре") end )
						timer.Simple(0.1,function() daun2 = false end )
					end
				end
			end
		end
	end

	-- Function to create context menu
	local function CreateContextMenu(slot)
		local menu = DermaMenu()

		if slot.Weapon and not blacklistweapon[slot.Weapon:GetClass()] then
			menu:AddOption("Выкинуть", function()
				RunConsoleCommand("use", slot.Weapon:GetClass())
				RunConsoleCommand("say", "*drop")
				RunConsoleCommand("hg_openinv")
				timer.Simple(0.04, function() RunConsoleCommand("hg_openinv") end)
			end)

			menu:AddOption("Использовать", function()
				if IsValid(slot.Weapon) then
					RunConsoleCommand("use", slot.Weapon:GetClass()) -- Equip the weapon
				end
			end)

			menu:AddOption("Установить в быстрый слот", function()
				fastslotitem = slot.Weapon:GetClass()
				surface.PlaySound("eft_gear_sounds/gear_armor_use.wav")    
				LocalPlayer():ChatPrint("Вы установили "..slot.Weapon:GetPrintName().." В быстрый слот")
			end)
		end

		menu:Open()
	end

	-- Function to create weapon slot
	local function CreateWeaponSlot(parent, index)
		local slot = vgui.Create("DPanel", parent)
		slot:SetSize(80, 80)
		slot.index = index
		slot.Weapon = nil -- No weapon initially
		slot:SetBackgroundColor(Color(60, 60, 60, 150))

		function slot:Paint(w, h)
			-- Background of the slot
			draw.RoundedBox(8, 0, 0, w, h, self:GetBackgroundColor())

			-- Draw a border around the slot
			surface.SetDrawColor(255, 255, 255, 255) -- White color for the border
			surface.DrawOutlinedRect(0, 0, w, h, 2) -- Border thickness of 2

			-- Draw slot number at the top center
			draw.SimpleText(self.index, "DermaDefaultBold", w / 2, 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			if self.Weapon and IsValid(self.Weapon) then
				-- Draw weapon name at the bottom
				draw.SimpleText(self.Weapon:GetPrintName(), "DermaDefaultBold", w / 2, h - 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

				-- Draw weapon model
				if self.Weapon.Icon then
					self.Weapon.Icon:SetPos(10, 10)
					self.Weapon.Icon:SetSize(w - 20, h - 35)
					self.Weapon.Icon:PaintManual()
				end
			end
		end

		function slot:OnMousePressed(mousecode)
			if mousecode == MOUSE_RIGHT then
				-- Right-click to show context menu
				CreateContextMenu(self)
			end
		end

		return slot
	end

	-- Function to create the flashlight slot
	local function CreateFlashlightSlot(parent)
		local slot = vgui.Create("DPanel", parent)
		slot:SetSize(80, 80)
		slot:SetBackgroundColor(Color(60, 60, 60, 150))
		
		local model = vgui.Create("DModelPanel", slot)
		model:SetSize(180,180)
		model:Center()
		model:SetCamPos(Vector(-2,-1,100))
		model:SetLookAng(Vector(90,0,0))
		model:SetModel("models/maxofs2d/lamp_flashlight.mdl")
		function model:LayoutEntity( ent )
		end
		
		function slot:Paint(w, h)
			-- Draw flashlight slot background
			draw.RoundedBox(8, 0, 0, w, h, self:GetBackgroundColor())
			
			draw.SimpleText("Фонарик", "DermaDefaultBold", w / 2, h - 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			
			draw.SimpleText("F", "DermaDefaultBold", w / 2, 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			-- Draw a border around the flashlight slot
			surface.SetDrawColor(255, 255, 255, 255) -- White color for the border
			surface.DrawOutlinedRect(0, 0, w, h, 2) -- Border thickness of 2

		end

		function slot:OnMousePressed(mousecode)
			if mousecode == MOUSE_RIGHT then
				-- Right-click to show context menu for flashlight slot
				CreateContextMenu(self)
			end
		end

		return slot
	end

	-- VGUI for the custom weapon inventory
	local PANEL = {}
	
	local PANELPLAYERMODEL = {}
	
	function PANELPLAYERMODEL:Init()
		self:SetSize(200, 1200)
		self:SetPos(50, 50)
		
		local PlayerDisplay = vgui.Create("DModelPanel",self)
		PlayerDisplay:SetPos(0, 0)
		PlayerDisplay:SetSize(250,1500)
		PlayerDisplay:SetModel(LocalPlayer():GetModel())
		PlayerDisplay:SetLookAt(PlayerDisplay:GetEntity():GetBonePosition(0))
		PlayerDisplay:SetFOV(37)
		PlayerDisplay:SetCursor("arrow")
		local PDispBT = vgui.Create("DButton", PlayerDisplay)
		PDispBT:SetSize(250,1500)
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
		local Ent = PlayerDisplay:GetEntity()
		function PlayerDisplay:LayoutEntity( ent ) end
		
		Ent:SetSkin(LocalPlayer():GetSkin())
	for k, v in pairs( LocalPlayer():GetBodyGroups() ) do
		local cur_bgid = LocalPlayer():GetBodygroup( v.id )
		Ent:SetBodygroup( v.id, cur_bgid )
	end
		
			if LocalPlayer().EZarmor.suited and LocalPlayer().EZarmor.bodygroups then
		PlayerDisplay:SetColor(LocalPlayer():GetColor())

		for k, v in pairs(LocalPlayer().EZarmor.bodygroups) do
			Ent:SetBodygroup(k, v)
		end
	end
	
	function PlayerDisplay:PostDrawModel(ent)
		ent.EZarmor = LocalPlayer().EZarmor
		JMod.ArmorPlayerModelDraw(ent)
	end
	
	end

	function PANELPLAYERMODEL:OpenInventory()
	
	InventoryOpen = true
		self:SetVisible(true)
		self:MakePopup() -- Make the panel interactive (captures input)
		self:SetKeyboardInputEnabled(false)
		self:SetMouseInputEnabled(true)
	end
	
	function PANELPLAYERMODEL:CloseInventory()
	
	self:SetVisible(false)
	InventoryOpen = false
	self:SetVisible(false)
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
	end
	
	function PANEL:Init()
		self:SetSize(1200, 150)
		self:SetPos((ScrW() / 2) - (self:GetWide() / 2), ScrH() - 200) -- Center bottom of the screen
		self:SetVisible(false)
		self:SetKeyboardInputEnabled(false)
		self:SetMouseInputEnabled(true)
		
		-- Create the flashlight slot on the left
		local reserveSlot = CreateFlashlightSlot(self)
		reserveSlot:SetPos(270, 40) -- Position the flashlight slot to the left of the first slot

		-- Calculate the starting X position for the slots to be centered
		local slotSpacing = 90
		local startX = (self:GetWide() / 2) - ((MaxSlots * slotSpacing) / 2)

		-- Create weapon slots next to flashlight slot
		for i = 1, MaxSlots do
			local slot = CreateWeaponSlot(self, i)
			slot:SetPos(startX + (i - 1) * slotSpacing, 40) -- Center the slots horizontally
			table.insert(Slots, slot)
		end
	end

	function PANEL:OpenInventory()
		Weapons = LocalPlayer():GetWeapons()

		-- Clear previous weapon icons and slot assignments
		for _, slot in ipairs(Slots) do
			if IsValid(slot) then
				slot.Weapon = nil
			end
		end

		-- Assign weapons to slots, excluding blacklisted weapons
		local weaponIndex = 1
		for i = 1, MaxSlots do
			local slot = Slots[i]

			if IsValid(slot) then
				-- Find the next valid weapon that is not blacklisted
				while weaponIndex <= #Weapons do
					local weapon = Weapons[weaponIndex]
					weaponIndex = weaponIndex + 1

					if IsValid(weapon) and not blacklistweapon[weapon:GetClass()] then
						slot.Weapon = weapon
						break
					end
				end
			end
		end

		InventoryOpen = true
		self:SetVisible(true)
		self:MakePopup() -- Make the panel interactive (captures input)
		self:SetKeyboardInputEnabled(false)
		self:SetMouseInputEnabled(true)
	end

	function PANEL:CloseInventory()
		InventoryOpen = false
		self:SetVisible(false)
		self:SetKeyboardInputEnabled(false)
		self:SetMouseInputEnabled(false)
	end

	-- Handle drag and drop functionality
	function PANEL:OnMousePressed(mousecode)
		if mousecode == MOUSE_LEFT and InventoryOpen then
			-- Check for dragging start from a weapon slot
			for _, slot in ipairs(Slots) do
				if slot:IsHovered() and slot.Weapon then
					dragPanel = slot.Weapon.Icon
					dragPanel:MouseCapture(true)
					dragPanel:SetAlpha(150) -- Visual feedback for dragging
					break
				end
			end
		end
	end

--[[	function PANEL:OnMouseReleased(mousecode)
		if mousecode == MOUSE_LEFT and InventoryOpen and dragPanel then
			-- Check where the item is being dropped
			for _, slot in ipairs(Slots) do
				if slot:IsHovered() and dragPanel then
					local activeWeapon = LocalPlayer():GetActiveWeapon()
					if IsValid(activeWeapon) and not blacklistweapon[activeWeapon:GetClass()] then
						slot.Weapon = activeWeapon
						surface.PlaySound("buttons/button14.wav")
					end
				end
			end

			-- Reset dragging
			dragPanel:MouseCapture(false)
			dragPanel:SetAlpha(255)
			dragPanel = nil
		end
	end]]

	vgui.Register("CustomWeaponInventory", PANEL, "EditablePanel")
	vgui.Register("CustomWeaponInventoryPlayerModel", PANELPLAYERMODEL, "EditablePanel")

	-- Console command to open/close the inventory
	concommand.Add("hg_openinv", function()
		if not IsValid(WeaponInventory) then
			WeaponInventory = vgui.Create("CustomWeaponInventory")
		end
		if not IsValid(WeaponInventory2) then
			WeaponInventory2 = vgui.Create("CustomWeaponInventoryPlayerModel")
		end

		if InventoryOpen then
			WeaponInventory:CloseInventory()
			WeaponInventory2:CloseInventory()
			surface.PlaySound("eft_gear_sounds/gear_backpack_pickup.wav")
		else
			WeaponInventory:OpenInventory()
			WeaponInventory2:OpenInventory()
			surface.PlaySound("eft_gear_sounds/gear_backpack_use.wav")
		end
	end)
	
	-- Handle key press to equip weapon_hands
	hook.Add("Think", "EquipWeaponHandsOnKeyPress", function()
		timer.Simple(0.05,function() DropExcessWeapons() end )
		if input.IsKeyDown(KEY_1) then
			RunConsoleCommand("use", "weapon_hands")
		end
		if input.IsKeyDown(KEY_2) and not daun then
			daun = true
			timer.Simple(0.2, function() 
			if fastslotitem and not blacklistweapon[fastslotitem] then
					RunConsoleCommand("use", fastslotitem) 
			end
			end)
			timer.Simple(1, function() daun = false end)
		end
	end)
end
