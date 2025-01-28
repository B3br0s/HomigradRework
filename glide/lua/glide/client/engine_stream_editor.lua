concommand.Add(
    "glide_engine_stream_editor",
    function() Glide:OpenSoundEditor() end,
    nil,
    "Opens the engine sound editor for Glide cars/motorcycles/tanks."
)

function Glide:OpenSoundEditor()
    if IsValid( self.frameStreamEditor ) then
        self.frameStreamEditor:Close()
        self.frameStreamEditor = nil

        return
    end

    local frame = vgui.Create( "Glide_EngineStreamEditor" )
    frame:Center()
    frame:MakePopup()

    self.frameStreamEditor = frame
end

local L = Glide.GetLanguageText
local Frame = {}

function Frame:Init()
    self:SetIcon( "icon16/sound.png" )
    self:SetTitle( L"stream_editor.title" )
    self:SetPos( 0, 0 )
    self:SetSize( 800, math.max( ScrH() * 0.7, 400 ) )
    self:SetMinWidth( 800 )
    self:SetMinHeight( 400 )
    self:SetSizable( true )
    self:SetDraggable( true )
    self:SetDeleteOnClose( true )
    self:SetScreenLock( true )

    Glide.Theme:Apply( self, "DFrame" )

    self.menuBar = vgui.Create( "DMenuBar", self )
    self.menuBar:DockMargin( -4, -4, -4, 0 )

    -- File menu options
    local fileMenu = self.menuBar:AddMenu( L"stream_editor.file" )

    fileMenu:AddOption( L"stream_editor.import_json", function()
        self:OnClickImportJSON( false )
    end ):SetIcon( "icon16/folder.png" )

    fileMenu:AddOption( L"stream_editor.import_json_static", function()
        self:OnClickImportJSON( true )
    end ):SetIcon( "icon16/folder.png" )

    fileMenu:AddOption( L"stream_editor.export_json", function()
        self:OnClickExportJSON()
    end ):SetIcon( "icon16/disk.png" )

    fileMenu:AddOption( L"stream_editor.export_code", function()
        self:OnClickExportCode()
    end ):SetIcon( "icon16/script_go.png" )

    -- Layer menu options
    local layerMenu = self.menuBar:AddMenu( L"stream_editor.layers" )

    layerMenu:AddOption( L"stream_editor.add_layer", function()
        self:OnClickAddLayer()
    end ):SetIcon( "icon16/sound_add.png" )

    layerMenu:AddOption( L"stream_editor.remove_all_layers", function()
        self:OnClickRemoveAllLayers()
    end ):SetIcon( "icon16/sound_delete.png" )

    -- Toggle engine button
    local buttonToggleEngine = self.menuBar:Add( "DButton" )
    buttonToggleEngine:SetPaintBackground( false )
    buttonToggleEngine:Dock( LEFT )
    buttonToggleEngine:DockMargin( 0, 0, 0, 0 )

    self.buttonToggleEngine = buttonToggleEngine

    buttonToggleEngine.DoClick = function()
        if self.isEngineOn then
            self:StopEngine()
        else
            self:StartEngine()
        end

        self:UpdateEngineToggleButton()
    end

    self:UpdateEngineToggleButton()

    -- Bottom sheet
    local sheet = vgui.Create( "DPropertySheet", self )
    sheet:SetTall( 100 )
    sheet:Dock( BOTTOM )

    -- Simulated engine panel
    local panelEngine = vgui.Create( "DPanel", sheet )
    panelEngine:DockPadding( 4, 4, 0, 0 )
    sheet:AddSheet( L"stream_editor.tab_engine", panelEngine, "icon16/cog.png" )

    local CreateEngineParam = function( name )
        local panel = vgui.Create( "DPanel", panelEngine )
        panel:SetTall( 24 )
        panel:Dock( TOP )
        panel:DockMargin( 0, 0, 0, 4 )
        panel:SetPaintBackground( false )

        local label = vgui.Create( "DLabel", panel )
        label:SetText( name )
        label:SetWide( 100 )
        label:SetTextColor( color_white )
        label:Dock( LEFT )

        local progress = vgui.Create( "DProgress", panel )
        progress:SetFraction( 0 )
        progress:Dock( FILL )
        progress:DockMargin( 0, 0, 4, 0 )

        local slider = vgui.Create( "DNumSlider", panel )
        slider:SetWide( 200 )
        slider:SetText( name )
        slider:SetMin( 0 )
        slider:SetMax( 1 )
        slider:SetDecimals( 2 )
        slider:Dock( RIGHT )

        slider.Label:SetVisible( false )

        return progress, slider, label
    end

    self.rpmProgress, self.rpmSlider, self.rpmLabel = CreateEngineParam( L"stream_editor.rpm" )
    self.throttleProgress, self.throttleSlider = CreateEngineParam( L"stream_editor.throttle" )

    self.rpmSlider.OnValueChanged = function()
        self.manualInput = true
    end

    self.throttleSlider.OnValueChanged = function()
        self.manualInput = true
    end

    -- Stream parameters panel
    local panelParams = vgui.Create( "DPanel", sheet )
    panelParams:DockPadding( 4, 4, 0, 0 )
    sheet:AddSheet( L"stream_editor.tab_params", panelParams, "icon16/chart_line.png" )

    local scrollParams = vgui.Create( "DScrollPanel", panelParams )
    scrollParams:Dock( FILL )

    local listParams = vgui.Create( "DIconLayout", scrollParams )
    listParams:Dock( FILL )
    listParams:SetSpaceY( 4 )
    listParams:SetSpaceX( 4 )

    -- Min, max and decimals
    local paramLimits = {
        pitch = { 0.5, 2, 2 },
        volume = { 0.1, 2, 2 },
        fadeDist = { 500, 4000, 0 },
        redlineFrequency = { 30, 70, 0 },
        wobbleFrequency = { 10, 70, 0 },
        wobbleStrength = { 0.1, 1.0, 2 }
    }

    self.paramSliders = {}

    local CreateStreamParam = function( key )
        local panel = listParams:Add( "DPanel" )
        panel:SetSize( 245, 24 )
        panel:DockPadding( 4, 0, 4, 0 )

        Glide.Theme:Apply( panel )

        local slider = vgui.Create( "DNumSlider", panel )
        slider:SetWide( 120 )
        slider:SetText( key )
        slider:SetMin( paramLimits[key][1] )
        slider:SetMax( paramLimits[key][2] )
        slider:SetDecimals( paramLimits[key][3] )
        slider:Dock( RIGHT )

        slider.Label:SetVisible( false )
        self.paramSliders[key] = slider

        slider.OnValueChanged = function( _, value )
            self.stream[key] = math.Round( value, paramLimits[key][3] )
        end

        local label = vgui.Create( "DLabel", panel )
        label:SetText( key )
        label:SetTextColor( color_white )
        label:Dock( FILL )
    end

    for k, _ in SortedPairs( Glide.DEFAULT_STREAM_PARAMS ) do
        CreateStreamParam( k )
    end

    -- Paint bottom panels
    local PaintSheetPanel = function( _, w, h )
        surface.SetDrawColor( 30, 30, 30, 255 )
        surface.DrawRect( 0, 0, w, h )
    end

    panelEngine.Paint = PaintSheetPanel
    panelParams.Paint = PaintSheetPanel

    self.scrollLayers = vgui.Create( "DScrollPanel", self )
    self.scrollLayers:Dock( FILL )
    self.scrollLayers:GetCanvas():DockPadding( 0, 4, 4, 4 )

    self.stream = Glide.CreateEngineStream( LocalPlayer() )
    self.stream.firstPerson = true

    self.stream.errorCallback = function( path, errorName )
        Derma_Message( string.format( L"stream_editor.load_error", path, errorName ), L"error", L"ok" )
    end

    self:UpdateStreamParamSliders()
end

function Frame:OnClose()
    self:StopEngine()

    if self.stream then
        self.stream:Destroy()
        self.stream = nil
    end

    if IsValid( self.frameBrowser ) then
        self.frameBrowser:Close()
        self.frameBrowser = nil
    end

    if IsValid( self.frameExport ) then
        self.frameExport:Close()
        self.frameExport = nil
    end
end

function Frame:UpdateEngineToggleButton()
    self.buttonToggleEngine:SetText( self.isEngineOn and L"stream_editor.stop_engine" or L"stream_editor.start_engine" )
    self.buttonToggleEngine:SetIcon( self.isEngineOn and "icon16/control_stop_blue.png" or "icon16/control_play_blue.png" )
    self.buttonToggleEngine:SizeToContentsX( 60 )
end

function Frame:UpdateStreamParamSliders()
    if not self.stream then return end

    for k, slider in pairs( self.paramSliders ) do
        slider:SetValue( self.stream[k] )
    end
end

function Frame:GetFreeLayerID( path )
    local name = string.StripExtension( string.GetFileFromFilename( path ) )
    local layers = self.stream.layers

    local i = 0
    local id = name

    while layers[id] and i < 10000 do
        i = i + 1
        id = name .. i
    end

    return id
end

function Frame:AddLayer( id, path, controllers, redline )
    id = id or self:GetFreeLayerID( path )
    controllers = controllers or {}

    self.stream:AddLayer( id, path, controllers, redline )

    local layer = self.stream.layers[id]

    local panel = vgui.Create( "Glide_EngineLayer" )
    panel:Dock( TOP )
    panel:DockMargin( 0, 0, 0, 8 )

    self.scrollLayers:AddItem( panel )
    layer.panel = panel

    panel.id = id
    panel.path = path
    panel:SetLayerData( layer )

    panel.OnClickRemove = function()
        self:RemoveLayer( id )
    end
end

function Frame:RemoveLayer( id )
    local layer = self.stream.layers[id]

    if layer and IsValid( layer.panel ) then
        layer.panel:Remove()
    end

    self.stream:RemoveLayer( id )
end

function Frame:ClearLayers()
    for id, _ in pairs( self.stream.layers ) do
        self:RemoveLayer( id )
    end
end

function Frame:StartEngine()
    self.rpmProgress:SetFraction( 0 )
    self.throttleProgress:SetFraction( 0 )

    self.rpmSlider:SetValue( 0 )
    self.throttleSlider:SetValue( 0 )

    self.isEngineOn = true
    self.manualInput = false
    self.stream:Play()

    -- Fake engine constants
    self.minRPM = 2000
    self.maxRPM = 15000

    self.flywheelMass = 50
    self.flywheelRadius = 0.5

    self.flywheelFriction = -5000
    self.flywheelTorque = 10000

    -- Fake engine variables
    self.throttle = 0
    self.angularVelocity = 0
    self.isRedlining = false
end

function Frame:StopEngine()
    self.isEngineOn = false

    if self.stream then
        self.stream:Pause()
    end
end

do
    local TAU = math.pi * 2

    function Frame:GetEngineRPM()
        return self.angularVelocity * 60 / TAU
    end

    function Frame:SetEngineRPM( rpm )
        self.angularVelocity = rpm * TAU / 60
    end

    function Frame:Accelerate( torque, dt )
        -- Calculate moment of inertia
        local radius = self.flywheelRadius
        local inertia = 0.5 * self.flywheelMass * radius * radius

        -- Calculate angular acceleration using Newton's second law for rotation
        local angularAcceleration = torque / inertia -- Ah, the classic F = m * a

        -- Calculate new angular velocity after delta time
        self.angularVelocity = self.angularVelocity + angularAcceleration * dt
    end

    local IsKeyDown = input.IsKeyDown
    local BaseClass = baseclass.Get( "DFrame" )

    function Frame:Think()
        BaseClass.Think( self )

        if not self.isEngineOn then return end

        local dt = FrameTime()
        local rpm = self:GetEngineRPM()
        local isRedlining = false

        if rpm < self.minRPM then
            self:SetEngineRPM( self.minRPM + 1 )

        elseif rpm > self.maxRPM then
            self:SetEngineRPM( self.maxRPM - 1 )
            isRedlining = true
        end

        local throttle

        if self.manualInput then
            throttle = self.throttleSlider:GetValue()

            local rpmFraction = self.rpmSlider:GetValue()

            self:SetEngineRPM( self.minRPM + ( self.maxRPM - self.minRPM ) * rpmFraction )

            -- Disable manual input from the sliders if we press W
            if IsKeyDown( 33 ) then
                self.manualInput = false
            end
        else
            throttle = IsKeyDown( 33 ) and 1 or 0

            self:Accelerate( self.flywheelFriction + self.flywheelTorque * self.throttle, dt )
        end

        self.throttle = math.Approach( self.throttle, throttle, dt * ( throttle > self.throttle and 3 or 2 ) )

        isRedlining = isRedlining and throttle > 0

        if self.isRedlining ~= isRedlining then
            self.isRedlining = isRedlining
            self.rpmLabel:SetColor( isRedlining and Color( 255, 0, 0 ) or color_white )
        end

        local rpmFraction = ( rpm - self.minRPM ) / ( self.maxRPM - self.minRPM )

        self.rpmProgress:SetFraction( rpmFraction )
        self.throttleProgress:SetFraction( self.throttle )

        local inputs = self.stream.inputs

        inputs.rpmFraction = rpmFraction
        inputs.throttle = self.throttle

        self.stream.isRedlining = isRedlining
    end
end

function Frame:OnClickImportJSON( fromStaticFolder )
    local dir = fromStaticFolder and "data_static" or "data"

    self:ShowOpenFileFrame( L"stream_editor.open_json", "*.json", dir, function( path )
        self:ClearLayers()

        local data = file.Read( path, "GAME" )

        if not data or string.len( path ) == 0 then
            Derma_Message( L"stream_editor.err_no_data", L"error", L"ok" )
            return
        end

        data = Glide.FromJSON( data )

        local keyValues = data.kv or {}

        if type( keyValues ) ~= "table" then
            Derma_Message( L"stream_editor.err_invalid_data", L"error", L"ok" )
            return
        end

        local layers = data.layers

        if type( layers ) ~= "table" then
            Derma_Message( L"stream_editor.err_invalid_data", L"error", L"ok" )
            return
        end

        local defaultParams = Glide.DEFAULT_STREAM_PARAMS

        for k, v in pairs( keyValues ) do
            if defaultParams[k] and type( v ) == "number" then
                self.stream[k] = v
            else
                Glide.Print( "Invalid key/value: %s/$s", k, v )
            end
        end

        for id, layer in SortedPairs( layers ) do
            if type( layer ) ~= "table" then
                Derma_Message( L"stream_editor.err_invalid_data", L"error", L"ok" )
                return
            end

            local p = layer.path
            local c = layer.controllers

            if
                type( id ) == "string" and
                type( p ) == "string" and
                type( c ) == "table"
            then
                self:AddLayer( id, p, c, layer.redline == true )
            else
                Derma_Message( L"stream_editor.err_invalid_data", L"error", L"ok" )
                return
            end
        end

        self.lastPath = string.sub( path, string.len( dir ) + 2 ) -- remove "data/" or "data_static/"
        self:UpdateStreamParamSliders()
    end )

    self.frameBrowser:SetIcon( "materials/icon16/folder.png" )
end

function Frame:OnClickExportJSON()
    local data = {
        kv = {},
        layers = {}
    }

    for k, default in pairs( Glide.DEFAULT_STREAM_PARAMS ) do
        local value = self.stream[k]

        if value ~= default then
            data.kv[k] = value
        end
    end

    local layers = self.stream.layers

    for id, layer in pairs( layers ) do
        data.layers[id] = {
            path = layer.path,
            controllers = layer.controllers,
            redline = layer.redline
        }
    end

    data = util.TableToJSON( data, false )

    local function WriteFile( path )
        local dir = string.GetPathFromFilename( path )

        if not file.Exists( dir, "DATA" ) then
            file.CreateDir( dir )
        end

        Glide.SaveDataFile( path, data )

        self.lastPath = path

        if file.Exists( path, "DATA" ) then
            notification.AddLegacy( string.format( L"stream_editor.saved", path ), NOTIFY_GENERIC, 5 )
        else
            notification.AddLegacy( L"stream_editor.err_save", NOTIFY_ERROR, 5 )
        end
    end

    local now = os.date( "*t" )
    local path = self.lastPath or string.format( "glide_%04i_%02i_%02i %02i-%02i-%02i.json",
            now.year, now.month, now.day, now.hour, now.min, now.sec )

    Derma_StringRequest(
        L"stream_editor.export_json",
        L"stream_editor.enter_file_name",
        path,
        function( result )
            path = string.Trim( result )

            if string.len( path ) == 0 then
                Derma_Message( L"stream_editor.enter_file_name", L"error", L"ok" )
                return
            end

            local ext = string.Right( path, 5 )

            if ext ~= ".json" then
                path = path .. ".json"
            end

            WriteFile( path )
        end
    )
end

function Frame:OnClickExportCode()
    local lines = {
        "function ENT:OnCreateEngineStream( stream )"
    }

    local function Add( str, ... )
        lines[#lines + 1] = str:format( ... )
    end

    for k, default in pairs( Glide.DEFAULT_STREAM_PARAMS ) do
        local value = self.stream[k]

        if value ~= default then
            Add( [[    stream.%s = %s]], k, value )
        end
    end

    Add( "" )

    local layers = self.stream.layers

    for id, layer in pairs( layers ) do
        Add( [[    stream:AddLayer( "%s", "%s", {]], id, layer.path )

        for _, c in ipairs( layer.controllers ) do
            Add( [[        { "%s", %s, %s, "%s", %s, %s },]], c[1], c[2], c[3], c[4], c[5], c[6] )
        end

        Add( layer.redline and "    }, true )\n" or "    } )\n" )
    end

    Add( "end" )

    self:ShowExportFrame( table.concat( lines, "\n" ), L"stream_editor.export_code", L"stream_editor.export_help" )
end

function Frame:OnClickAddLayer()
    self:ShowOpenFileFrame( L"stream_editor.open_audio", "*.ogg *.mp3 *.wav", "sound", function( path )
        path = string.sub( path, 7 ) -- remove "sound/"
        self:AddLayer( nil, path )
        self.lastAudioFolder = string.GetPathFromFilename( path )
    end )

    self.frameBrowser:SetIcon( "materials/icon16/sound.png" )

    if self.lastAudioFolder then
        self.fileBrowser:SetCurrentFolder( self.lastAudioFolder )
    end
end

function Frame:OnClickRemoveAllLayers()
    Derma_Query( L"stream_editor.remove_all_layers_query", L"stream_editor.remove_all_layers", L"yes", function()
        self:ClearLayers()
    end, L"no" )
end

function Frame:ShowOpenFileFrame( title, filter, baseFolder, callback )
    if IsValid( self.frameBrowser ) then
        self.frameBrowser:Close()
    end

    local frame = vgui.Create( "DFrame" )
    frame:SetSize( math.max( 600, ScrW() * 0.5 ), math.max( 500, ScrH() * 0.6 ) )
    frame:SetSizable( true )
    frame:SetDraggable( true )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle( title .. " (" .. filter .. ")" )
    frame:SetDeleteOnClose( true )

    Glide.Theme:Apply( frame )
    self.frameBrowser = frame

    frame.OnClose = function()
        self.frameBrowser = nil
        self.fileBrowser = nil
    end

    local browser = vgui.Create( "DFileBrowser", frame )
    browser:Dock( FILL )
    browser:SetModels( false )
    browser:SetPath( "GAME" )
    browser:SetBaseFolder( baseFolder )
    browser:SetFileTypes( filter )
    browser:SetCurrentFolder( "/" )
    browser:SetOpen( true )
    browser.Divider:SetLeftWidth( 250 )

    self.fileBrowser = browser

    function browser.OnDoubleClick( _, path )
        frame:Close()
        callback( path:gsub( "//", "/" ) )
    end
end

function Frame:ShowExportFrame( code, titleText, helpText )
    if IsValid( self.frameExport ) then
        self.frameExport:Close()
    end

    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 600, 500 )
    frame:SetDraggable( true )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle( titleText )
    frame:SetIcon( "icon16/script_go.png" )
    frame:SetDeleteOnClose( true )

    Glide.Theme:Apply( frame )
    self.frameExport = frame

    frame.OnClose = function()
        self.frameExport = nil
    end

    local labelHelp = vgui.Create( "DLabel", frame )
    labelHelp:SetFont( "Trebuchet18" )
    labelHelp:SetText( helpText )
    labelHelp:SetTextColor( Color( 255, 255, 255 ) )
    labelHelp:Dock( TOP )
    labelHelp:SetContentAlignment( 5 )

    local entryCode = vgui.Create( "DTextEntry", frame )
    entryCode:Dock( FILL )
    entryCode:DockMargin( 16, 16, 16, 16 )
    entryCode:SetMultiline( true )
    entryCode:SetValue( code )
    entryCode.AllowInput = function() return true end

    local buttonCopy = vgui.Create( "DButton", frame )
    buttonCopy:SetText( L"stream_editor.copy_clipboard" )
    buttonCopy:SetTall( 40 )
    buttonCopy:Dock( BOTTOM )

    Glide.Theme:Apply( buttonCopy )

    buttonCopy.DoClick = function()
        SetClipboardText( code )
        frame:Close()
    end
end

vgui.Register( "Glide_EngineStreamEditor", Frame, "DFrame" )

----------

local Layer = {}

function Layer:Init()
    self:SetTall( 60 )
    self:DockPadding( 2, 24, 2, 2 )

    self.controllerPanels = {}
    self.id = ""
    self.path = "/"

    local panelOptions = vgui.Create( "DPanel", self )
    panelOptions:SetTall( 20 )
    panelOptions:Dock( BOTTOM )
    panelOptions:SetPaintBackground( false )

    local buttonRemove = vgui.Create( "DButton", panelOptions )
    buttonRemove:SetText( L"stream_editor.remove_layer" )
    buttonRemove:SetIcon( "icon16/sound_delete.png" )
    buttonRemove:SetWide( 150 )
    buttonRemove:Dock( RIGHT )

    Glide.Theme:Apply( buttonRemove )

    buttonRemove.DoClick = function()
        self:OnClickRemove()
    end

    local buttonAdd = vgui.Create( "DButton", panelOptions )
    buttonAdd:SetText( L"stream_editor.add_controller" )
    buttonAdd:SetIcon( "icon16/cog_add.png" )
    buttonAdd:SetWide( 200 )
    buttonAdd:Dock( RIGHT )

    Glide.Theme:Apply( buttonAdd )

    buttonAdd.DoClick = function()
        self:OnClickAddController()
    end

    local checkRevLimiter = vgui.Create( "DCheckBoxLabel", panelOptions )
    checkRevLimiter:SetText( L"stream_editor.rev_limiter" )
    checkRevLimiter:SetValue( false )
    checkRevLimiter:SizeToContents()
    checkRevLimiter:Dock( LEFT )

    self.checkRevLimiter = checkRevLimiter

    checkRevLimiter.OnChange = function( _, value )
        if self.layerData then
            self.layerData.redline = value
        end
    end
end

function Layer:OnClickRemove() end

function Layer:SetLayerData( data )
    self.layerData = data
    self.checkRevLimiter:SetValue( data.redline == true )
    self:SetControllers( data.controllers )
end

local BG_COLORS = {
    Color( 62, 84, 117 ),
    Color( 45, 62, 87 )
}

function Layer:SetControllers( controllers )
    for _, panel in ipairs( self.controllerPanels ) do
        if IsValid( panel ) then panel:Remove() end
    end

    table.Empty( self.controllerPanels )
    self.controllers = controllers

    if not controllers then return end

    local height = 48

    for i, params in ipairs( controllers ) do
        local panel = vgui.Create( "DPanel", self )
        panel:SetTall( 30 )
        panel:Dock( TOP )
        panel:DockMargin( 1, 0, 1, 2 )
        panel:DockPadding( 2, 2, 0, 2 )
        panel:SetBackgroundColor( BG_COLORS[( i % 2 ) + 1] )

        -- Controller input type
        local comboIn = vgui.Create( "DComboBox", panel )
        comboIn:SetWide( 85 )
        comboIn:Dock( LEFT )
        comboIn:AddChoice( "throttle" )
        comboIn:AddChoice( "rpmFraction" )
        comboIn:SetValue( params[1] )

        comboIn.OnSelect = function( _, _, value )
            params[1] = value
        end

        -- Controller input minimum value
        local imgIMin = vgui.Create( "DImage", panel )
        imgIMin:SetWide( 18 )
        imgIMin:SetImage( "icon16/bullet_arrow_down.png" )
        imgIMin:SetKeepAspect( true )
        imgIMin:Dock( LEFT )
        imgIMin:DockMargin( 4, 4, 0, 4 )

        local sliderIMin = vgui.Create( "DNumSlider", panel )
        sliderIMin:SetWide( 120 )
        sliderIMin:SetMin( 0 )
        sliderIMin:SetMax( 1 )
        sliderIMin:SetDecimals( 2 )
        sliderIMin:Dock( LEFT )
        sliderIMin.Label:SetVisible( false )
        sliderIMin:SetValue( params[2] )

        sliderIMin.OnValueChanged = function( _, value )
            params[2] = math.Round( value, 2 )
        end

        -- Controller input maximum value
        local imgIMax = vgui.Create( "DImage", panel )
        imgIMax:SetWide( 18 )
        imgIMax:SetImage( "icon16/bullet_arrow_up.png" )
        imgIMax:SetKeepAspect( true )
        imgIMax:Dock( LEFT )
        imgIMax:DockMargin( -8, 4, 0, 4 )

        local sliderIMax = vgui.Create( "DNumSlider", panel )
        sliderIMax:SetWide( 120 )
        sliderIMax:SetMin( 0 )
        sliderIMax:SetMax( 1 )
        sliderIMax:SetDecimals( 2 )
        sliderIMax:Dock( LEFT )
        sliderIMax.Label:SetVisible( false )
        sliderIMax:SetValue( params[3] )

        sliderIMax.OnValueChanged = function( _, value )
            params[3] = math.Round( value, 2 )
        end

        -- Controller output type
        local comboOut = vgui.Create( "DComboBox", panel )
        comboOut:SetWide( 75 )
        comboOut:Dock( LEFT )
        comboOut:DockMargin( -6, 0, 0, 0 )
        comboOut:AddChoice( "volume" )
        comboOut:AddChoice( "pitch" )
        comboOut:SetValue( params[4] )

        comboOut.OnSelect = function( _, _, value )
            params[4] = value
        end

        -- Controller output minimum value
        local imgOMin = vgui.Create( "DImage", panel )
        imgOMin:SetWide( 18 )
        imgOMin:SetImage( "icon16/bullet_arrow_down.png" )
        imgOMin:Dock( LEFT )
        imgOMin:DockMargin( 4, 4, 0, 4 )

        local sliderOMin = vgui.Create( "DNumSlider", panel )
        sliderOMin:SetWide( 120 )
        sliderOMin:SetMin( 0 )
        sliderOMin:SetMax( 2 )
        sliderOMin:SetDecimals( 2 )
        sliderOMin:Dock( LEFT )
        sliderOMin.Label:SetVisible( false )
        sliderOMin:SetValue( params[5] )

        sliderOMin.OnValueChanged = function( _, value )
            params[5] = math.Round( value, 2 )
        end

        -- Controller input maximum value
        local imgOMax = vgui.Create( "DImage", panel )
        imgOMax:SetWide( 18 )
        imgOMax:SetImage( "icon16/bullet_arrow_up.png" )
        imgOMax:Dock( LEFT )
        imgOMax:DockMargin( -4, 4, 0, 4 )

        local sliderOMax = vgui.Create( "DNumSlider", panel )
        sliderOMax:SetWide( 120 )
        sliderOMax:SetMin( 0 )
        sliderOMax:SetMax( 2 )
        sliderOMax:SetDecimals( 2 )
        sliderOMax:Dock( LEFT )
        sliderOMax.Label:SetVisible( false )
        sliderOMax:SetValue( params[6] )

        sliderOMax.OnValueChanged = function( _, value )
            params[6] = math.Round( value, 2 )
        end

        -- Remove controller
        local buttonRemove = vgui.Create( "DButton", panel )
        buttonRemove:SetText( "" )
        buttonRemove:SetTooltip( L"stream_editor.remove_controller" )
        buttonRemove:SetIcon( "icon16/cog_delete.png" )
        buttonRemove:SetWide( 24 )
        buttonRemove:Dock( RIGHT )
        buttonRemove:DockMargin( 0, -4, 0, -4 )

        buttonRemove.DoClick = function()
            self:OnClickRemoveController( i )
        end

        height = height + 32
        self.controllerPanels[i] = panel
    end

    self:SetTall( height )
end

function Layer:OnClickAddController()
    local controllers = self.controllers
    if not controllers then return end

    controllers[#controllers + 1] = {
        "throttle", 0, 1, "volume", 0, 1
    }

    self:SetControllers( controllers )
end

function Layer:OnClickRemoveController( index )
    local controllers = self.controllers
    if not controllers then return end

    if controllers[index] then
        table.remove( controllers, index )
        self:SetControllers( controllers )
    end
end

function Layer:Paint( w, h )
    surface.SetDrawColor( 50, 50, 50, 255 )
    surface.DrawRect( 0, 0, w, h )

    surface.SetDrawColor( 90, 90, 90 )
    surface.DrawRect( 0, 0, w, 20 )

    if self.layerData then
        surface.SetDrawColor( 13, 122, 13 )
        surface.DrawRect( 0, 0, w * self.layerData.volume, 20 )
    end

    draw.SimpleText( self.id, "DermaDefault", 4, 10, nil, 0, 1 )
    draw.SimpleText( self.path, "DermaDefault", w - 4, 10, nil, 2, 1 )
end

vgui.Register( "Glide_EngineLayer", Layer, "DPanel" )
