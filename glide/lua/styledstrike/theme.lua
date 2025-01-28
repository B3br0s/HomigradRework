--[[
    StyledStrike's VGUI theme utilities

    A collection of functions to create common
    UI panels and to apply a custom theme to them.
]]

local DEFAULT_COLORS = {
    panelBackground = Color( 20, 20, 20, 200 ),
    frameBackground = Color( 0, 0, 0, 240 ),
    frameBorder = Color( 80, 80, 80, 255 ),
    frameTitleBar = Color( 25, 100, 170 ),

    buttonBorder = Color( 150, 150, 150, 255 ),
    buttonBackground = Color( 30, 30, 30, 255 ),
    buttonBackgroundDisabled = Color( 10, 10, 10, 255 ),
    buttonHover = Color( 255, 255, 255, 30 ),
    buttonPress = Color( 25, 100, 170 ),

    buttonText = Color( 255, 255, 255, 255 ),
    buttonTextDisabled = Color( 180, 180, 180, 255 ),

    entryBorder = Color( 100, 100, 100, 255 ),
    entryBackground = Color( 10, 10, 10, 255 ),
    entryHighlight = Color( 25, 100, 170 ),
    entryPlaceholder = Color( 150, 150, 150, 255 ),
    entryText = Color( 255, 255, 255, 255 ),
    labelText = Color( 255, 255, 255, 255 ),
}

local StyledTheme = _G.StyledTheme or {}
local ClassFunctions = StyledTheme.ClassFunctions or {}

_G.StyledTheme = StyledTheme
StyledTheme.__index = StyledTheme
StyledTheme.ClassFunctions = ClassFunctions

function StyledTheme.Create( colors )
    colors = colors or {}

    for id, color in pairs( DEFAULT_COLORS ) do
        colors[id] = colors[id] or color
    end

    return setmetatable( {
        colors = colors
    }, StyledTheme )
end

function StyledTheme:Apply( panel, classOverride )
    local funcs = ClassFunctions[classOverride or panel.ClassName]
    if not funcs then return end

    panel.STheme = self
    panel.SColors = self.colors

    if funcs.Prepare then
        funcs.Prepare( panel )
    end

    if funcs.Paint then
        panel.Paint = funcs.Paint
    end

    if funcs.UpdateColours then
        panel.UpdateColours = funcs.UpdateColours
    end

    if funcs.Close then
        panel.Close = funcs.Close
    end
end

----- Theme functions by panel class -----

local Lerp = Lerp
local FrameTime = FrameTime

local DrawRect = surface.DrawRect
local DrawRoundedBox = draw.RoundedBox
local SetDrawColor = surface.SetDrawColor

ClassFunctions["DLabel"] = {
    Prepare = function( self )
        self:SetColor( self.SColors.labelText )
    end
}

ClassFunctions["DPanel"] = {
    Paint = function( self, w, h )
        SetDrawColor( self.SColors.panelBackground:Unpack() )
        DrawRect( 0, 0, w, h )
    end
}

ClassFunctions["DButton"] = {
    Prepare = function( self )
        self._hoverAnim = 0
    end,

    Paint = function( self, w, h )
        self._hoverAnim = Lerp( FrameTime() * 10, self._hoverAnim, ( self:IsEnabled() and self.Hovered ) and 1 or 0 )

        local colors = self.SColors
        local bgColor = self._themeHighlight and colors.buttonPress or colors.buttonBackground

        DrawRoundedBox( 4, 0, 0, w, h, colors.buttonBorder )
        DrawRoundedBox( 4, 1, 1, w - 2, h - 2, self:IsEnabled() and bgColor or colors.buttonBackgroundDisabled )

        local r, g, b, a = colors.buttonHover:Unpack()

        SetDrawColor( r, g, b, a * self._hoverAnim )
        DrawRect( 1, 1, w - 2, h - 2 )

        if self:IsDown() or self.m_bSelected then
            DrawRoundedBox( 4, 1, 1, w - 2, h - 2, self._themeHighlight and colors.buttonBackground or colors.buttonPress )
        end
    end,

    UpdateColours = function( self )
        if self:IsEnabled() then
            self:SetTextStyleColor( self.SColors.buttonText )
        else
            self:SetTextStyleColor( self.SColors.buttonTextDisabled )
        end
    end
}

ClassFunctions["DBinder"] = ClassFunctions["DButton"]

ClassFunctions["DTextEntry"] = {
    Prepare = function( self )
        self:SetDrawBorder( false )
        self:SetPaintBackground( false )

        self:SetTextColor( self.SColors.entryText )
        self:SetCursorColor( self.SColors.entryText )
        self:SetHighlightColor( self.SColors.entryHighlight )
        self:SetPlaceholderColor( self.SColors.entryPlaceholder )
    end,

    Paint = function( self, w, h )
        SetDrawColor( self.SColors.entryBorder:Unpack() )
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )

        SetDrawColor( self.SColors.entryBackground:Unpack() )
        DrawRect( 1, 1, w - 2, h - 2 )

        derma.SkinHook( "Paint", "TextEntry", self, w, h )
    end
}

ClassFunctions["DComboBox"] = {
    Prepare = function( self )
        self:SetTextColor( self.SColors.entryText )
    end,

    Paint = function( self, w, h )
        SetDrawColor( self.SColors.entryBorder:Unpack() )
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )

        SetDrawColor( self.SColors.entryBackground:Unpack() )
        DrawRect( 1, 1, w - 2, h - 2 )
    end
}

ClassFunctions["DNumSlider"] = {
    Prepare = function( self )
        self.STheme:Apply( self.TextArea )
        self.STheme:Apply( self.Label )
    end
}

ClassFunctions["DScrollPanel"] = {
    Prepare = function( self )
        self.STheme:Apply( self.VBar )
    end,

    Paint = function( self, w, h )
        SetDrawColor( self.SColors.panelBackground:Unpack() )
        DrawRect( 0, 0, w, h )
    end
}

local function DrawGrip( self, w, h )
    local colors = self.SColors

    SetDrawColor( colors.buttonBorder:Unpack() )
    DrawRect( 0, 0, w, h )

    SetDrawColor( colors.buttonBackground:Unpack() )
    DrawRect( 1, 1, w - 2, h - 2 )

    if self.Depressed then
        SetDrawColor( colors.buttonPress:Unpack() )
        DrawRect( 1, 1, w - 2, h - 2 )

    elseif self.Hovered then
        SetDrawColor( colors.buttonHover:Unpack() )
        DrawRect( 1, 1, w - 2, h - 2 )
    end
end

ClassFunctions["DVScrollBar"] = {
    Prepare = function( self )
        self.btnGrip.SColors = self.SColors
        self.btnGrip.Paint = DrawGrip
    end,

    Paint = function( self, w, h )
        SetDrawColor( self.SColors.entryBackground:Unpack() )
        DrawRect( 0, 0, w, h )
    end
}

local function SlideThink( anim, panel, fraction )
    if not anim.StartPos then
        anim.StartPos = Vector( panel.x, panel.y + anim.StartOffset, 0 )
        anim.TargetPos = Vector( panel.x, panel.y + anim.EndOffset, 0 )
    end

    panel._animAlpha = Lerp( fraction, anim.StartAlpha, anim.EndAlpha )

    local pos = LerpVector( fraction, anim.StartPos, anim.TargetPos )
    panel:SetPos( pos.x, pos.y )
    panel:SetAlpha( 255 * panel._animAlpha )
end

local function FramePerformLayout( self )
    local titlePush = 16

    if IsValid( self.imgIcon ) then
        self.imgIcon:SetPos( 4, 5 )
        self.imgIcon:SetSize( 16, 16 )
    end

    self.btnClose:SetPos( self:GetWide() - 28 - 2, 2 )
    self.btnClose:SetSize( 28, 20 )

    self.lblTitle:SetPos( 8 + titlePush, 2 )
    self.lblTitle:SetSize( self:GetWide() - 25 - titlePush, 20 )
end

ClassFunctions["DFrame"] = {
    Prepare = function( self )
        self._animAlpha = 0
        self._OriginalClose = self.Close
        self.PerformLayout = FramePerformLayout

        self.STheme:Apply( self.btnClose )
        self.btnClose:SetText( "X" )
        self.lblTitle:SetColor( self.SColors.labelText )

        if IsValid( self.btnMaxim ) then
            self.btnMaxim:Remove()
        end

        if IsValid( self.btnMinim ) then
            self.btnMinim:Remove()
        end

        local anim = self:NewAnimation( 0.4, 0, 0.25 )
        anim.StartOffset = -80
        anim.EndOffset = 0
        anim.StartAlpha = 0
        anim.EndAlpha = 1
        anim.Think = SlideThink
    end,

    Close = function( self )
        self:SetMouseInputEnabled( false )
        self:SetKeyboardInputEnabled( false )

        if self.OnStartClosing then
            self.OnStartClosing()
        end

        local anim = self:NewAnimation( 0.2, 0, 0.5, function()
            self:_OriginalClose()
        end )

        anim.StartOffset = 0
        anim.EndOffset = -80
        anim.StartAlpha = 1
        anim.EndAlpha = 0
        anim.Think = SlideThink
    end,

    Paint = function( self, w, h )
        if self.m_bBackgroundBlur then
            Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
        end

        local colors = self.SColors

        SetDrawColor( colors.frameBorder:Unpack() )
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )

        SetDrawColor( colors.frameBackground:Unpack() )
        DrawRect( 0, 0, w, h )

        SetDrawColor( colors.frameTitleBar:Unpack() )
        DrawRect( 0, 0, w, 24 )
    end
}

----- Custom panels -----

function StyledTheme:CreateHeader( parent, text, mleft, mtop, mright, mbottom )
    mleft = mleft or 0
    mtop = mtop or 4
    mright = mright or 0
    mbottom = mbottom or 4

    local panel = vgui.Create( "DPanel", parent )
    panel:SetTall( 32 )
    panel:Dock( TOP )
    panel:DockMargin( mleft, mtop, mright, mbottom )
    panel:SetBackgroundColor( color_black )

    local label = vgui.Create( "DLabel", panel )
    label:SetText( text )
    label:SetContentAlignment( 5 )
    label:SizeToContents()
    label:Dock( FILL )

    self:Apply( label )

    return panel
end

function StyledTheme:CreatePropertyLabel( parent, text )
    local label = vgui.Create( "DLabel", parent )
    label:Dock( TOP )
    label:DockMargin( 0, 0, 0, 2 )
    label:SetText( text )
    label:SetTall( 26 )

    self:Apply( label )

    return label
end

function StyledTheme:CreateButton( parent, label, callback )
    local button = vgui.Create( "DButton", parent )
    button:SetTall( 30 )
    button:SetText( label )
    button:Dock( TOP )
    button:DockMargin( 20, 0, 20, 4 )
    button.DoClick = callback

    self:Apply( button )

    return button
end

function StyledTheme:CreateToggleButton( parent, label, isChecked, callback )
    local button = vgui.Create( "DButton", parent )
    button:SetTall( 30 )
    button:SetIcon( isChecked and "icon16/accept.png" or "icon16/cancel.png" )
    button:SetText( label )
    button:Dock( TOP )
    button:DockMargin( 20, 0, 20, 4 )
    button._isChecked = isChecked

    self:Apply( button )

    button.DoClick = function( s )
        s._isChecked = not s._isChecked
        button:SetIcon( s._isChecked and "icon16/accept.png" or "icon16/cancel.png" )
        callback( s._isChecked )
    end

    return button
end

function StyledTheme:CreateSlider( parent, label, default, min, max, decimals, callback )
    local slider = vgui.Create( "DNumSlider", parent )
    slider:SetTall( 36 )
    slider:SetText( label )
    slider:SetMin( min )
    slider:SetMax( max )
    slider:SetValue( default )
    slider:SetDecimals( decimals )
    slider:Dock( TOP )
    slider:DockMargin( 20, 0, 20, 6 )

    self:Apply( slider )

    slider.OnValueChanged = function( _, value )
        callback( decimals == 0 and math.floor( value ) or math.Round( value, decimals ) )
    end

    return slider
end

function StyledTheme:CreateComboBox( parent, text, options, defaultIndex, callback )
    local panel = vgui.Create( "DPanel", parent )
    panel:SetTall( 30 )
    panel:SetPaintBackground( false )
    panel:Dock( TOP )
    panel:DockMargin( 20, 0, 20, 4 )

    local label = vgui.Create( "DLabel", panel )
    label:Dock( LEFT )
    label:DockMargin( 0, 0, 0, 0 )
    label:SetText( text )
    label:SetWide( 190 )

    self:Apply( label )

    local combo = vgui.Create( "DComboBox", panel )
    combo:Dock( FILL )
    combo:SetSortItems( false )

    for _, v in ipairs( options ) do
        combo:AddChoice( v )
    end

    combo:ChooseOptionID( defaultIndex )

    self:Apply( combo )

    combo.OnSelect = function( _, index )
        callback( index )
    end
end

function StyledTheme:CreateBinderButton( parent, text, defaultKey )
    local panel = vgui.Create( "DPanel", parent )
    panel:SetTall( 30 )
    panel:SetPaintBackground( false )
    panel:Dock( TOP )
    panel:DockMargin( 20, 0, 20, 4 )

    local label = vgui.Create( "DLabel", panel )
    label:Dock( LEFT )
    label:DockMargin( 0, 0, 0, 0 )
    label:SetText( text )
    label:SetWide( 190 )

    self:Apply( label )

    local binder = vgui.Create( "DBinder", panel )
    binder:SetValue( defaultKey or KEY_NONE )
    binder:Dock( FILL )

    self:Apply( binder )

    return binder
end

----- Custom DFrame with tabs -----

local TabButton = {}

function TabButton:Init()
    self:SetCursor( "hand" )
    self.icon = vgui.Create( "DImage", self )

    self.isSelected = false
    self.notificationCount = 0
    self.SColors = DEFAULT_COLORS
end

function TabButton:SetIcon( path )
    self.icon:SetImage( path )
end

function TabButton:PerformLayout( w, h )
    local size = math.max( w, h ) * 0.4

    self.icon:SetSize( size, size )
    self.icon:Center()
end

local COLOR_INDICATOR = Color( 200, 0, 0, 255 )

function TabButton:Paint( w, h )
    local colors = self.SColors

    if self.isSelected then
        SetDrawColor( colors.buttonPress:Unpack() )
        DrawRect( 0, 0, w, h )
    end

    if self:IsHovered() then
        SetDrawColor( colors.buttonHover:Unpack() )
        DrawRect( 0, 0, w, h )
    end

    if self.notificationCount > 0 then
        local size = 14
        local x = w - size - 2
        local y = h - size - 2

        DrawRoundedBox( size * 0.5, x, y, size, size, COLOR_INDICATOR )
        draw.SimpleText( self.notificationCount, "TargetIDSmall", x + size * 0.5, y + size * 0.5, colors.buttonText, 1, 1 )
    end
end

function TabButton:OnMousePressed( keyCode )
    if keyCode == MOUSE_LEFT then
        self:GetParent():GetParent():SetActiveTab( self.tab )
    end
end

vgui.Register( "Styled_TabButton", TabButton, "DPanel" )

local PANEL = {}

function PANEL:Init()
    local w = math.max( ScrH() * 0.7, 600 )
    local h = math.max( ScrH() * 0.45, 400 )

    self:SetPos( 0, 0 )
    self:SetSize( w, h )
    self:SetSizable( true )
    self:SetDraggable( true )
    self:SetDeleteOnClose( true )
    self:SetScreenLock( true )
    self:SetMinWidth( 600 )
    self:SetMinHeight( 400 )
    self:DockPadding( 4, 28, 4, 4 )

    self.tabList = vgui.Create( "DPanel", self )
    self.tabList:SetWide( 48 )
    self.tabList:Dock( LEFT )
    self.tabList:DockPadding( 2, 2, 2, 2 )

    self.tabContainer = vgui.Create( "DPanel", self )
    self.tabContainer:Dock( FILL )
    self.tabContainer:DockMargin( 4, 0, 0, 0 )
    self.tabContainer:DockPadding( 0, 0, 0, 0 )
    self.tabContainer:SetPaintBackground( false )

    self.tabs = {}
end

function PANEL:ApplyTheme( theme )
    self.tabList:SetBackgroundColor( theme.colors.panelBackground )

    theme:Apply( self, "DFrame" )

    for _, t in ipairs( self.tabs ) do
        t.button.SColors = theme.colors
    end
end

function PANEL:AddTab( icon, tooltip )
    local tab = {}

    tab.button = vgui.Create( "Styled_TabButton", self.tabList )
    tab.button:SetIcon( icon )
    tab.button:SetTall( 44 )
    tab.button:SetTooltip( tooltip )
    tab.button:Dock( TOP )
    tab.button:DockMargin( 0, 0, 0, 2 )
    tab.button.tab = tab
    tab.button.SColors = self.SColors or DEFAULT_COLORS

    tab.panel = vgui.Create( "DScrollPanel", self.tabContainer )
    tab.panel:Dock( FILL )
    tab.panel:DockMargin( 0, 0, 0, 0 )
    tab.panel:DockPadding( 0, 0, 0, 0 )
    tab.panel:SetPaintBackground( false )
    tab.panel:SetVisible( false )
    tab.panel.pnlCanvas:DockPadding( 0, -4, 4, 0 )

    self.tabs[#self.tabs + 1] = tab

    if #self.tabs == 1 then
        self:SetActiveTab( tab )
    end

    return tab.panel
end

function PANEL:SetActiveTab( tab )
    for i, t in ipairs( self.tabs ) do
        local isThisOne = t == tab

        t.button.isSelected = isThisOne
        t.panel:SetVisible( isThisOne )

        if isThisOne then
            self.lastTabIndex = i
        end
    end
end

function PANEL:SetActiveTabByIndex( index )
    if self.tabs[index] then
        self:SetActiveTab( self.tabs[index] )
    end
end

function PANEL:SetTabNotificationCountByIndex( index, count )
    if self.tabs[index] then
        self.tabs[index].button.notificationCount = count
    end
end

vgui.Register( "Styled_TabbedFrame", PANEL, "DFrame" )
