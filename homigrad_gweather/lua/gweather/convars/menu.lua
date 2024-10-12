gWeather.Panel={}

local color_blue = Color(68,85,120,255)
local color_dark = Color(100,100,100,255)
local color_gray = Color(150,150,150,255)
local color_white = Color(255,255,255,255)

surface.CreateFont( "gWeather_Font", {
	font = "Arial",
	extended = false,
	size = 20,
	weight = 1600,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )

local function CreateTextLabel(DPanel, text, offset, font)

	local DLabel = vgui.Create( "DLabel", DPanel )
		DLabel:Dock(TOP)
		DLabel:DockMargin( offset, 10, 0, 10 )
		DLabel:DockPadding(10, 10, 0, 0)
		DLabel:Center()
		DLabel:SetText(text)
		DLabel:SetFont(font or "Trebuchet18")
		DLabel:SizeToContents()
		
	return DLabel
end

local function CreateClientPanel(DPanel)

	local function CreateComboBox(DPanel, desc, cvar, choices, offset)
		if not GetConVar(cvar) then return end
		
		local DCombo = vgui.Create( "DComboBox", DPanel )
			DCombo:DockMargin(25+(offset or 0), 0, 50, 0)
			DCombo:DockPadding(10, 10, 10, 10)
			DCombo:Dock(TOP)
			DCombo:SetValue( GetConVar(cvar):GetString() )
			
			local helptext=GetConVar(cvar):GetHelpText()
			DCombo:SetTooltip(string.len(helptext)>0 and helptext or false)
			
			for k,v in pairs(choices) do DCombo:AddChoice(v) end
			
			DCombo.OnSelect = function( self, index, value )
				if ConVarExists(cvar) then GetConVar(cvar):SetString(value) end
				DCombo:SetValue( value )
				surface.PlaySound("garrysmod/ui_click.wav")
			end
			
		return DCombo
	end	


	local function CreateCheckBox(DPanel, desc, cvar, offset, color)
		if not GetConVar(cvar) then return end
		if color==nil then color = Color(200,200,200) end
		
		local DCheck = vgui.Create( "DCheckBoxLabel", DPanel )
			DCheck:SetText(desc)							
			DCheck:Dock(TOP)			
			DCheck:DockMargin( (offset or 10), 10, 10, 10)			
			DCheck:SetConVar(cvar)						
			DCheck:SetValue(	GetConVar(cvar):GetBool()	)	
			DCheck:SetTextColor(color)
			DCheck:SizeToContents()
			
			local helptext=GetConVar(cvar):GetHelpText()
			DCheck:SetTooltip(string.len(helptext)>0 and helptext or false)
			
		return DCheck 
	end

	local function CreateNumSlider(DPanel, min, max, desc, cvar, offset)
		if not GetConVar(cvar) then return end
		
		local DSlider = vgui.Create( "DNumSlider", DPanel )
			DSlider:SetMinMax(min, max)
			DSlider:Dock(TOP)
			DSlider:DockMargin( (offset or 10), 10, 50, 10 )
			DSlider:SetText(desc)	
			DSlider:SetConVar(cvar)
			DSlider:SetValue(	GetConVar(cvar):GetFloat()	)
			DSlider:SetDecimals(2)

			local helptext=GetConVar(cvar):GetHelpText()
			DSlider:SetTooltip(string.len(helptext)>0 and helptext or false)
			
		return DSlider
	end	


	CreateTextLabel(DPanel, "General", 10, "Trebuchet24")
	
	CreateTextLabel(DPanel,"Weather Quality:", 20)
	local P_Amount = CreateComboBox(DPanel,"Particle Amount", "gw_particle_level", {"low","high"}, 20)
	
	local SFX = CreateCheckBox(DPanel,"Enable Weather Screen Effects?","gw_screeneffects", 20)
	local Fog = CreateCheckBox(DPanel,"Enable Weather Fog?","gw_enablefog", 20)
	local Mat = CreateCheckBox(DPanel,"Enable Weather Material Replacement?","gw_matchange", 20)
	local S_Shake = CreateCheckBox(DPanel,"Enable Screen-Shake?","gw_screenshake", 20)
	local L_Flash = CreateCheckBox(DPanel,"Enable Lightning Flashes?","gw_lightning_flash", 20)
	local W_SFX = CreateNumSlider(DPanel, 0, 1, "Wind Volume", "gw_windvolume", 20)
	
	CreateTextLabel(DPanel, "Temperature", 10, "HomigradFont")
	local W_Damage = CreateCheckBox(DPanel,"Enable Temperature Effects?","gw_temp_effect", 20)
end

local function CreateServerPanel(DPanel)

	local function CreateComboBox(DPanel, desc, cvar, choices, offset)
		if not GetConVar(cvar) then return end
		
		local DCombo = vgui.Create( "DComboBox", DPanel )
			DCombo:DockMargin(25+(offset or 0), 0, 50, 0)
			DCombo:DockPadding(10, 10, 10, 10)
			DCombo:Dock(TOP)
			DCombo:SetValue( desc )
			DCombo:SetSortItems(false)

			local helptext=GetConVar(cvar):GetHelpText()
			DCombo:SetTooltip(string.len(helptext)>0 and helptext or false)
			
			for k,v in SortedPairsByValue(choices) do
				DCombo:AddChoice(k) 
				if v==math.Round(GetConVar(cvar):GetFloat(),3) then DCombo:SetValue(k) end
			end
			
			DCombo.OnSelect = function( self, index, value )
				if !LocalPlayer():IsAdmin() then surface.PlaySound( "buttons/combine_button_locked.wav" ) return end

				DCombo:SetValue(table.KeyFromValue(choices,choices[value])) 
			
				net.Start( "gw_convarsync" )
					net.WriteString( cvar )
					net.WriteFloat(choices[value])
				net.SendToServer()
			end
			
		return DCombo
	end	

	local function CreateCheckBox(DPanel, desc, cvar, offset, color)
		if not GetConVar(cvar) then return end
		if color==nil then color = Color(200,200,200) end
		
		local DCheck = vgui.Create( "DCheckBoxLabel", DPanel )
			DCheck:SetText(desc)							
			DCheck:Dock(TOP)			
			DCheck:DockMargin( (offset or 10), 10, 10, 10)			
			DCheck:SetConVar(cvar)						
			DCheck:SetValue(	GetConVar(cvar):GetBool()	)	
			DCheck:SetTextColor(color)
			DCheck:SizeToContents()

			local helptext=GetConVar(cvar):GetHelpText()
			DCheck:SetTooltip(string.len(helptext)>0 and helptext or false)
			
			function DCheck:OnChange( val )
				if !LocalPlayer():IsAdmin() then surface.PlaySound( "buttons/combine_button_locked.wav" ) return end

				net.Start( "gw_convarsync" )
					net.WriteString( cvar )
					net.WriteFloat(val and 1 or 0)
				net.SendToServer()
			end
			
		return DCheck 
	end

	local function CreateNumSlider(DPanel, min, max, desc, cvar, offset, dec)
		if not GetConVar(cvar) then return end
		
		local DSlider = vgui.Create( "DNumSlider", DPanel )
			DSlider:SetMinMax(min, max)
			DSlider:Dock(TOP)
			DSlider:DockMargin( (offset or 10), 10, 50, 10 )
			DSlider:SetText(desc)	
			DSlider:SetConVar(cvar)
			DSlider:SetValue(	GetConVar(cvar):GetFloat()	)
			DSlider:SetDecimals(dec or 2)

			local helptext=GetConVar(cvar):GetHelpText()
			DSlider:SetTooltip(string.len(helptext)>0 and helptext or false)
			
			function DSlider:OnValueChanged( val )
				if !LocalPlayer():IsAdmin() then surface.PlaySound( "buttons/combine_button_locked.wav" ) return end
		
				net.Start( "gw_convarsync" )
					net.WriteString( cvar )
					net.WriteFloat(val)
				net.SendToServer()
			end
			
		return DSlider
	end	
	
	local function AddControlLabel( CPanel, label )
		return CPanel:ControlHelp( label )
	end
	
	CreateTextLabel(DPanel, "General", 10, "Trebuchet24")
	local W_LifeTime = CreateNumSlider(DPanel, 0, 1000, "Weather Lifetime", "gw_weather_lifetime", 20, 0)
	local W_Damage = CreateCheckBox(DPanel,"Enable Weather Damage?","gw_weather_entitydamage", 20)
	
	if file.Exists("autorun/gdisasters_load.lua","LUA") then
		local S_Flood = CreateCheckBox(DPanel,"Enable Hurricane Floods?","gw_weather_shouldflood", 20)
	end

	CreateTextLabel(DPanel, "Wind", 10, "Trebuchet24")
	local W_PlyPhys = CreateCheckBox(DPanel,"Enable Player/NPC Physics?","gw_windphysics_player", 20)
	local W_PropPhys = CreateCheckBox(DPanel,"Enable Prop Physics?","gw_windphysics_prop", 20)
	local W_PropUnweld = CreateCheckBox(DPanel,"Enable Breaking Constraints?","gw_windphysics_unweld", 20)
	--local W_Time = CreateNumSlider(DPanel, 0.1, 0.5, "Next Physics Time", "gw_nextwind", 20)
	CreateTextLabel(DPanel,"Physics Quality:", 20)
	local W_Time = CreateComboBox(DPanel,"Physics Quality", "gw_nextwind",{["potato"]=0.5,["low"]=0.3,["medium"]=0.2,["high"]=0.1}, 20)

	CreateTextLabel(DPanel, "Temperature", 10, "Trebuchet24")
	local Affect = CreateCheckBox(DPanel,"Enable Temperature Affection?","gw_tempaffect", 20)
	local T_Scale = CreateNumSlider(DPanel, 0, 10, "Affection Multiplier", "gw_tempaffect_rate", 20, 1)

end

list.Set( "DesktopWindows", "gWeather_Settings", {

	title		= "gWeather",
	icon		= "icons/gw_icon.png",
	width		= 500,
	height		= 700,
	onewindow	= true,
	init		= function( icon, window )

	window:SetTitle( "" )
	window:SetSize( math.min( ScrW() - 16, window:GetWide() ), math.min( ScrH() - 16, window:GetTall() ) )
	window:SetSizable( false )
	window:SetMinWidth( window:GetWide() )
	window:SetMinHeight( window:GetTall() )
	window:Center()
	window.Paint = function( self, w, h )
		draw.RoundedBoxEx( 5, 0, 0, w, h, color_blue, true, true, true, true )
		draw.DrawText( "gWeather - Settings", "Trebuchet24", 6, 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
	
	gWeather.Panel.Client=true -- client will be displayed
	gWeather.Panel.Server=false
	
	local DPanel = vgui.Create( "DPanel", window )
	DPanel.Paint = function(self, w, h ) 
		surface.SetDrawColor( color_dark:Unpack() )
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawLine( 0, 0, w, 0 )
		surface.DrawLine( 0, self:GetTall()-31, w, self:GetTall()-31 )
	end
	DPanel:DockMargin( 0, 0, 0, 0 )
	DPanel:DockPadding( 0, 0, 0, 0 )
	DPanel:SetSize( 0, window:GetTall() - 85 )
	DPanel:Dock( BOTTOM )
	
	local Scroll = vgui.Create( "DScrollPanel", DPanel )
	Scroll:Dock( FILL )
	Scroll:GetCanvas():DockPadding(0, 0, 0, 10)

	local DButton = vgui.Create( "DButton", window )
	DButton:DockMargin( 0, 0, 0, 0 )
	DButton:SetText( "" )
	DButton:SetSize( window:GetWide()/2, 1 )
	DButton:Dock( LEFT )
	
	DButton.DoClick = function()
		surface.PlaySound("garrysmod/ui_click.wav")
		if gWeather.Panel.Client then return end

		Scroll:GetCanvas():Clear()

		gWeather.Panel.Server = false
		gWeather.Panel.Client = true
		
		CreateClientPanel(Scroll)
		
	end
	
	DButton.Paint = function(self, w, h ) 
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect(0, 0, w, h)
	
		local hover = self:IsHovered() or gWeather.Panel.Client

		if hover then
			surface.SetDrawColor( color_gray:Unpack() )
		else
			surface.SetDrawColor( color_dark:Unpack() )
		end

		surface.DrawRect(1, 1, w-1, h-1)
		
		local Col = hover and color_white or color_gray
		draw.DrawText( "CLIENT", "Trebuchet24", w * 0.5, h * 0.25, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local DButton = vgui.Create( "DButton", window )
	DButton:DockMargin( 0, 0, 0, 0 )
	DButton:SetText( "" )
	DButton:SetSize( window:GetWide()/2, 1 )
	DButton:Dock( RIGHT )
	
	DButton.DoClick = function()
		if !LocalPlayer():IsSuperAdmin() then surface.PlaySound("buttons/button10.wav") return end
		surface.PlaySound("garrysmod/ui_click.wav")
		if gWeather.Panel.Server then return end
		
		Scroll:GetCanvas():Clear()
		
		gWeather.Panel.Client = false
		gWeather.Panel.Server = true
		
		CreateServerPanel(Scroll)
		
	end
	
	DButton.Paint = function(self, w, h ) 
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect(0, 0, w, h)
	
		local hover = self:IsHovered() or gWeather.Panel.Server

		if hover then
			surface.SetDrawColor( color_gray:Unpack() )
		else
			surface.SetDrawColor( color_dark:Unpack() )
		end
		
		surface.DrawRect(1, 1, w-2, h-1)

		local Col = hover and color_white or color_gray
		draw.DrawText( "SERVER", "Trebuchet24", w * 0.5, h * 0.25, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	CreateClientPanel(Scroll) -- makes the initial first panel
		
	local test = vgui.Create( "DPanel", DPanel )
	test.Paint = function(self, w, h ) 
		surface.SetDrawColor(  color_gray:Unpack() )
		surface.DrawRect(0, 0, w, h)
	end
	test:SetSize( 0, 30 )
	test:Dock( BOTTOM )
		
	local DLabel = vgui.Create( "DLabel", test )
	DLabel:Dock(RIGHT)
	DLabel:DockMargin( 5, 0, 5, 0 )

	DLabel:SetText("V "..tostring(gWeatherVersion))
	DLabel:SetColor(Color(65,85,185))
	DLabel:SetFont("gWeather_Font")
	DLabel:SizeToContents()

end})
