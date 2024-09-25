local PANEL = oop.Reg("v_textentry","v_panel")
if not PANEL then return end

function PANEL:FunctionCreate(parent)
	local panel = vgui.Create("DTextEntry",parent)
	
	local Paint = panel.Paint
	local Think = panel.Thinkssed

	for k,v in pairs(self) do panel[k] = v end

	panel:Init()

	panel.Draw = Paint
	panel.Step = Think

	function panel:OnMouse(key,value)
		if not value or key ~= MOUSE_LEFT then return end

		local panel = self

		panel:RequestFocus()

		while true do
			local parent = panel:GetParent()
			if not IsValid(parent) then break end

			panel = parent

			if parent.Base == "EditablePanel" then break end
		end

		self.lastEditablePanel = panel
		panel:SetKeyboardInputEnabled(true)--cring????
	end

	return panel--mdem
end

hook.Add("OnTextEntryLoseFocus","TextEntryH",function(self)
	local panel = self.lastEditablePanel

	if IsValid(panel) then panel:SetKeyboardInputEnabled(false) end
end)
