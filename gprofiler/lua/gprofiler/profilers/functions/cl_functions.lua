GProfiler.Functions = GProfiler.Functions or {}
GProfiler.Functions.Realm = GProfiler.Functions.Realm or "Client"
GProfiler.Functions.ProfileActive = GProfiler.Functions.ProfileActive or false
GProfiler.Functions.StartTime = GProfiler.Functions.StartTime or 0
GProfiler.Functions.EndTime = GProfiler.Functions.EndTime or 0

local TabPadding = 10
local MenuColors = GProfiler.MenuColors

local function PaintEmpty() end

local function ValidateFocus(foc)
	return string.find(foc or "", "function: 0x") != nil
end

local FocusColors = {
	Valid = Color(0, 255, 0),
	Invalid = Color(255, 0, 0)
}

-- Hacky solution for functions that have no signature but are mutually the same
local function CombineDuplicates()
	local combined = {}
	for k, v in pairs(GProfiler.Functions.ProfileData) do
		local lines = string.Split(v.lines, " - ")
		local key = v.source .. lines[1] .. lines[2]
		if not combined[key] then
			combined[key] = {
				name = v.name, source = v.source,
				lines = v.lines, calls = v.calls,
				time = v.time, average = v.average,
				focus = v.focus
			}
		else
			combined[key].calls = combined[key].calls + v.calls
			combined[key].time = combined[key].time + v.time
			combined[key].average = combined[key].average + v.average
		end
	end

	GProfiler.Functions.ProfileData = combined
end

function GProfiler.Functions.DoTab(Content)
	local Header = vgui.Create("DPanel", Content)
	Header:SetSize(Content:GetWide(), 40)
	Header:SetPos(0, 10)
	Header.Paint = PaintEmpty

	local FunctionsFocusLabel = vgui.Create("DLabel", Header)
	FunctionsFocusLabel:SetFont("GProfiler.Menu.SectionHeader")
	FunctionsFocusLabel:SetText(string.format("%s:", GProfiler.Language.GetPhrase("focus")))
	FunctionsFocusLabel:SizeToContents()
	FunctionsFocusLabel:SetPos(TabPadding, Header:GetTall() / 2 - FunctionsFocusLabel:GetTall() / 2)
	FunctionsFocusLabel:SetTextColor(MenuColors.White)

	local FunctionsFocusInput = vgui.Create("DTextEntry", Header)
	FunctionsFocusInput:SetFont("GProfiler.Menu.SectionHeader")
	FunctionsFocusInput:SetText(GProfiler.Functions.Focus or "")
	FunctionsFocusInput:SetMouseInputEnabled(true)
	FunctionsFocusInput:SetSize(150, Header:GetTall() - TabPadding * 2)
	FunctionsFocusInput:SetPos(FunctionsFocusLabel:GetWide() + FunctionsFocusLabel:GetPos() + 5, Header:GetTall() / 2 - FunctionsFocusInput:GetTall() / 2)
	FunctionsFocusInput:SetTextColor(MenuColors.White)

	local IsValidInput = false
	function FunctionsFocusInput:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, MenuColors.RealmSelectorOutline)
		draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.RealmSelectorBackground)
		draw.RoundedBox(4, 1, 1, 10, h - 2, IsValidInput and FocusColors.Valid or FocusColors.Invalid)
		local x = draw.SimpleText(self:GetText(), "GProfiler.Menu.FocusEntry", 15, h / 2, MenuColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		if self:IsEditing() and (x < w - 15) and (SysTime() % 1 > 0.5) then
			local caretPos = self:GetCaretPos()
			local text = self:GetText()
			surface.SetFont("GProfiler.Menu.FocusEntry")
			local textWidth = surface.GetTextSize(text)
			local textWidthBeforeCaret = surface.GetTextSize(string.sub(text, 1, caretPos))
			draw.RoundedBox(0, textWidthBeforeCaret + 15, 1, 2, h - 2, MenuColors.White)
		end
	end

	function FunctionsFocusInput:OnTextChanged()
		IsValidInput = ValidateFocus(self:GetText())
		GProfiler.Functions.Focus = self:GetText()
		if not IsValidInput then
			GProfiler.Functions.Focus = false
		end
	end
	FunctionsFocusInput:OnTextChanged()

	local RealmSelector = GProfiler.Menu.CreateRealmSelector(Header, "Functions", Header:GetWide() - 110 - TabPadding, Header:GetTall() / 2 - 30 / 2, 110, 30, function(s, _, value)
		GProfiler.Functions.Realm = value
		GProfiler.Menu.OpenTab("Functions", GProfiler.Functions.DoTab)
	end)
	RealmSelector:SetPos(Header:GetWide() - RealmSelector:GetWide() - TabPadding, Header:GetTall() / 2 - RealmSelector:GetTall() / 2)

	local StartButton = vgui.Create("DButton", Header)
	StartButton:SetText(GProfiler.Functions.ProfileActive and GProfiler.Language.GetPhrase("profiler_stop") or GProfiler.Language.GetPhrase("profiler_start"))
	StartButton:SetTextColor(MenuColors.White)
	StartButton:SetFont("GProfiler.Menu.RealmSelector")
	StartButton:SizeToContents()
	StartButton:SetTall(30)
	StartButton:SetPos(Header:GetWide() - StartButton:GetWide() - RealmSelector:GetWide() - TabPadding * 2, Header:GetTall() / 2 - StartButton:GetTall() / 2)
	StartButton.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, MenuColors.ButtonOutline)
		draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.ButtonBackground)

		if s:IsHovered() then
			draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.ButtonHover)
		end
	end

	local FunctionTimeRunning = vgui.Create("DLabel", Header)
	FunctionTimeRunning:SetFont("GProfiler.Menu.SectionHeader")
	FunctionTimeRunning:SetText(GProfiler.TimeRunning(GProfiler.Functions.StartTime, GProfiler.Functions.EndTime, GProfiler.Functions.ProfileActive) .. "s")
	FunctionTimeRunning:SizeToContents()
	FunctionTimeRunning:SetPos(Header:GetWide() - FunctionTimeRunning:GetWide() - RealmSelector:GetWide() - StartButton:GetWide() - TabPadding * 3, Header:GetTall() / 2 - FunctionTimeRunning:GetTall() / 2)
	FunctionTimeRunning:SetTextColor(MenuColors.White)
	function FunctionTimeRunning:Think()
		if GProfiler.Functions.ProfileActive then
			self:SetText(GProfiler.TimeRunning(GProfiler.Functions.StartTime, 0, GProfiler.Functions.ProfileActive) .. "s")
			self:SizeToContents()
			self:SetPos(Header:GetWide() - self:GetWide() - RealmSelector:GetWide() - StartButton:GetWide() - TabPadding * 3, Header:GetTall() / 2 - self:GetTall() / 2)
		end
	end

	StartButton.DoClick = function()
		if GProfiler.Functions.ProfileActive then
			GProfiler.Functions.EndTime = SysTime()
			if GProfiler.Functions.Realm == "Server" then
				net.Start("GProfiler_Functions_ToggleServerProfile")
				net.WriteBool(false)
				net.SendToServer()
			else
				GProfiler.Functions:RestoreFunctions()
				GProfiler.Functions.ProfileActive = false
				GProfiler.Menu.OpenTab("Functions", GProfiler.Functions.DoTab)
			end
		else
			GProfiler.Functions.StartTime = SysTime()
			GProfiler.Functions.EndTime = 0
			local focusIsValid = ValidateFocus(GProfiler.Functions.Focus)
			if GProfiler.Functions.Realm == "Server" then
				net.Start("GProfiler_Functions_ToggleServerProfile")
				net.WriteBool(true)
				net.WriteBool(focusIsValid)
				if focusIsValid then
					net.WriteString(GProfiler.Functions.Focus)
				end
				net.SendToServer()
			else
				GProfiler.Functions:DetourFunctions()
				GProfiler.Functions.ProfileActive = true
				StartButton:SetText(GProfiler.Language.GetPhrase("profiler_stop"))

				if focusIsValid then
					GProfiler.Functions.Focus = FunctionsFocusInput:GetText()
				end
			end
		end
	end

	local SectionHeader = vgui.Create("DPanel", Content)
	SectionHeader:SetSize(Content:GetWide(), 40)
	SectionHeader:SetPos(0, Header:GetTall())
	SectionHeader.Paint = PaintEmpty

	local leftFraction = .7
	local rightFraction = .3

	local LeftHeader, LeftHeaderText = GProfiler.Menu.CreateHeader(SectionHeader, GProfiler.Language.GetPhrase("profiler_results"), 0, 0, SectionHeader:GetWide() * leftFraction - 5, SectionHeader:GetTall())
	local RightHeader, RightHeaderText = GProfiler.Menu.CreateHeader(SectionHeader, GProfiler.Language.GetPhrase("function_details"), LeftHeader:GetWide() + 10, 0, SectionHeader:GetWide() * rightFraction - 5, LeftHeader:GetTall())

	local LeftContent = vgui.Create("DPanel", Content)
	LeftContent:SetSize(Content:GetWide() * leftFraction - 5, Content:GetTall() - SectionHeader:GetTall() - Header:GetTall())
	LeftContent:SetPos(0, SectionHeader:GetTall() + Header:GetTall())
	LeftContent.Paint = PaintEmpty

	local RightContent = vgui.Create("DPanel", Content)
	RightContent:SetSize(Content:GetWide() * rightFraction - 5, Content:GetTall() - SectionHeader:GetTall() - Header:GetTall())
	RightContent:SetPos(LeftContent:GetWide() + 10, SectionHeader:GetTall() + Header:GetTall())
	RightContent.Paint = PaintEmpty

	local FunctionDetailsBackground = vgui.Create("DPanel", RightContent)
	FunctionDetailsBackground:SetSize(RightContent:GetWide() - TabPadding * 2, RightContent:GetTall() - TabPadding * 2 - 50)
	FunctionDetailsBackground:SetPos(TabPadding, TabPadding)
	FunctionDetailsBackground.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, MenuColors.DListRowBackground) end

	local FunctionDetails = vgui.Create("DTextEntry", FunctionDetailsBackground)
	FunctionDetails:Dock(FILL)
	FunctionDetails:SetMultiline(true)
	FunctionDetails:SetKeyboardInputEnabled(false)
	FunctionDetails:SetVerticalScrollbarEnabled(true)
	FunctionDetails:SetDrawBackground(false)
	FunctionDetails:SetTextColor(MenuColors.White)
	FunctionDetails:SetFont("GProfiler.Menu.FunctionDetails")
	FunctionDetails:SetText(GProfiler.Language.GetPhrase("function_select"))

	local FunctionDetailsSeparator = vgui.Create("DPanel", RightContent)
	FunctionDetailsSeparator:SetSize(RightContent:GetWide() - TabPadding * 2, 1)
	FunctionDetailsSeparator:SetPos(TabPadding, FunctionDetailsBackground:GetTall() + TabPadding * 2)
	FunctionDetailsSeparator.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, MenuColors.HeaderSeparator) end

	local BottomSection = vgui.Create("DPanel", RightContent)
	BottomSection:SetSize(RightContent:GetWide() - TabPadding * 2, RightContent:GetTall() - FunctionDetailsBackground:GetTall() - FunctionDetailsSeparator:GetTall() - TabPadding * 3)
	BottomSection:SetPos(TabPadding, FunctionDetailsBackground:GetTall() + FunctionDetailsSeparator:GetTall() + TabPadding * 3)
	BottomSection.Paint = PaintEmpty

	local SelectedProfile = nil
	local Buttons = {
		[GProfiler.Language.GetPhrase("focus")] = function()
			if not SelectedProfile then return end
			FunctionsFocusInput:SetText(SelectedProfile.focus)
			FunctionsFocusInput:OnTextChanged()
		end,
		[GProfiler.Language.GetPhrase("print_details")] = function(b)
			if not SelectedProfile then return end

			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("function"), ": ", MenuColors.White, SelectedProfile.name, "\n")
			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("file"), ": ", MenuColors.White, SelectedProfile.source, "\n")
			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("lines"), ": ", MenuColors.White, SelectedProfile.lines, "\n")
			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("times_called"), ": ", MenuColors.White, SelectedProfile.calls, "\n")
			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("total_time"), ": ", MenuColors.White, SelectedProfile.time, "\n")
			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("average_time"), ": ", MenuColors.White, SelectedProfile.average, "\n")

			b:SetText(GProfiler.Language.GetPhrase("printed"))
			timer.Simple(2, function()
				if not IsValid(b) then return end
				b:SetText(GProfiler.Language.GetPhrase("print_details"))
			end)
		end
	}

	local ButtonWidth = BottomSection:GetWide() / table.Count(Buttons)
	local ButtonHeight = BottomSection:GetTall() - TabPadding

	local i = 0
	for k, v in pairs(Buttons) do
		local Button = vgui.Create("DButton", BottomSection)
		Button:SetSize(ButtonWidth - 5, ButtonHeight)
		Button:SetPos(i * ButtonWidth + (i * 5), 0)
		Button:SetText(k)
		Button:SetTextColor(MenuColors.White)
		Button:SetFont("GProfiler.Menu.RealmSelector")
		Button.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, MenuColors.ButtonOutline)
			draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.ButtonBackground)

			if self:IsHovered() then
				draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.ButtonHover)
			end
		end
		Button.DoClick = v
		i = i + 1
	end

	local FunctionProfiler = vgui.Create("DListView", LeftContent)
	FunctionProfiler:SetSize(LeftContent:GetWide() - TabPadding * 2, LeftContent:GetTall() - TabPadding * 2)
	FunctionProfiler:SetPos(TabPadding, TabPadding)
	FunctionProfiler:SetMultiSelect(false)
	FunctionProfiler:AddColumn(GProfiler.Language.GetPhrase("function"))
	FunctionProfiler:AddColumn(GProfiler.Language.GetPhrase("file"))
	FunctionProfiler:AddColumn(GProfiler.Language.GetPhrase("times_called"))
	FunctionProfiler:AddColumn(string.format("%s (ms)", GProfiler.Language.GetPhrase("total_time")))
	FunctionProfiler:AddColumn(string.format("%s (ms)", GProfiler.Language.GetPhrase("average_time")))

	CombineDuplicates()

	for k, v in pairs(GProfiler.Functions.ProfileData) do
		if GProfiler.Functions.ProfileActive and GProfiler.Functions.Realm == "Client" then break end
		local line = FunctionProfiler:AddLine(v.name or "Unknown", string.format("%s (%s)", v.source, v.lines), v.calls, v.time, v.average)
		line.OnMousePressed = function(s, l)
			if l == 108 then
				local menu = DermaMenu()
				menu:AddOption(GProfiler.Language.GetPhrase("focus"), function()
					FunctionsFocusInput:SetText(v.focus)
					FunctionsFocusInput:OnTextChanged()
				end):SetIcon("icon16/zoom.png")
				menu:AddOption(GProfiler.CopyLang("name"), function() SetClipboardText(v.name) end):SetIcon("icon16/page_copy.png")
				menu:AddOption(GProfiler.CopyLang("file"), function() SetClipboardText(v.source) end):SetIcon("icon16/page_copy.png")
				menu:AddOption(GProfiler.CopyLang("times_called"), function() SetClipboardText(v.calls) end):SetIcon("icon16/page_copy.png")
				menu:AddOption(GProfiler.CopyLang("total_time"), function() SetClipboardText(v.time) end):SetIcon("icon16/page_copy.png")
				menu:AddOption(GProfiler.CopyLang("average_time"), function() SetClipboardText(v.average) end):SetIcon("icon16/page_copy.png")
				menu:Open()
				return
			end

			SelectedProfile = v
			for k, v in ipairs(FunctionProfiler.Lines) do
				v:SetSelected(false)
			end
			line:SetSelected(true)

			local lines = string.Split(v.lines, " - ")
			GProfiler.RequestFunctionSource(v.source, lines[1], lines[2], function(source)
				if not IsValid(FunctionDetails) then return end
				FunctionDetails:SetText(table.concat(source, "\n"))
			end)
		end
	end

	FunctionProfiler:SortByColumn(5, true)

	GProfiler.StyleDListView(FunctionProfiler)
end

GProfiler.Menu.RegisterTab("Functions", "icon16/bug.png", 3, GProfiler.Functions.DoTab, function()
	if GProfiler.Functions.ProfileActive then
		return "", MenuColors.ActiveProfile
	end
	return nil
end)

net.Receive("GProfiler_Functions_ServerProfileStatus", function()
	local status = net.ReadBool()
	local ply = net.ReadEntity()
	GProfiler.Functions.ProfileActive = status

	if ply == LocalPlayer() then
		GProfiler.Menu.OpenTab("Functions", GProfiler.Functions.DoTab)
	end
end)

net.Receive("GProfiler_Functions_SendData", function(len, ply)
	local first = net.ReadBool()

	if first then
		GProfiler.Functions.ProfileData = {}
	end

	local last = net.ReadBool()
	local count = net.ReadUInt(32)
	for i = 1, count do
		local name = net.ReadString()
		local source = net.ReadString()
		local lines = net.ReadString()
		local calls = net.ReadUInt(32)
		local time = net.ReadFloat()
		local average = net.ReadFloat()
		local focus = net.ReadString()

		if not GProfiler.Functions.ProfileData[name] then
			GProfiler.Functions.ProfileData[name] = {
				name = name,
				source = source,
				lines = lines,
				calls = 0,
				time = 0,
				average = 0,
				focus = focus
			}
		end

		GProfiler.Functions.ProfileData[name].calls = GProfiler.Functions.ProfileData[name].calls + calls
		GProfiler.Functions.ProfileData[name].time = GProfiler.Functions.ProfileData[name].time + time
		GProfiler.Functions.ProfileData[name].average = GProfiler.Functions.ProfileData[name].average + average
	end

	if last then
		GProfiler.Menu.OpenTab("Functions", GProfiler.Functions.DoTab)
	end
end)
