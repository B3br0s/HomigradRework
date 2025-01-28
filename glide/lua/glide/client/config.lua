local Config = Glide.Config or {}

Glide.Config = Config

--- Reset settings to their default values.
function Config:Reset()
    self.version = 1

    -- Audio settings
    self.carVolume = 1.0
    self.aircraftVolume = 1.0
    self.explosionVolume = 1.0
    self.hornVolume = 1.0
    self.windVolume = 0.7
    self.vcVolume = 0.4

    -- Camera settings
    self.lookSensitivity = 1.0
    self.cameraInvertX = false
    self.cameraInvertY = false

    self.cameraDistance = 1.0
    self.cameraHeight = 1.0
    self.cameraFOVInternal = GetConVar( "fov_desired" ):GetFloat()
    self.cameraFOVExternal = GetConVar( "fov_desired" ):GetFloat()

    self.fixedCameraMode = 0
    self.enableAutoCenter = true
    self.autoCenterDelay = 1.5

    -- Mouse settings
    self.mouseFlyMode = Glide.MOUSE_FLY_MODE.AIM
    self.mouseSensitivityX = 1.0
    self.mouseSensitivityY = 1.0
    self.mouseInvertX = false
    self.mouseInvertY = false

    self.pitchMouseAxis = 2 -- Y
    self.yawMouseAxis = 0 -- None
    self.rollMouseAxis = 1 -- X
    self.mouseDeadzone = 0.15
    self.mouseShow = true

    -- Misc. settings
    self.showHUD = true
    self.showPassengerList = true
    self.showEmptyVehicleHealth = false
    self.showSkybox = true
    self.useKMH = false  -- Option to display speed in KM/H instead of MPH

    self.maxSkidMarkPieces = 500
    self.maxTireRollPieces = 400

    self.manualGearShifting = false
    self.autoHeadlightOn = true
    self.autoHeadlightOff = true
    self.headlightShadows = true
    self.enableTips = true
end

--- Reset binds to their default buttons.
function Config:ResetBinds()
    local binds = {}

    -- Setup default action categories and buttons
    for category, actions in pairs( Glide.InputCategories ) do
        binds[category] = {}

        for action, button in pairs( actions ) do
            binds[category][action] = button
        end
    end

    self.binds = binds
end

--- Save settings to disk.
function Config:Save( immediate )
    timer.Remove( "Glide.SaveConfig" )

    if not immediate then
        -- Don't spam when this function gets called in quick succession
        timer.Create( "Glide.SaveConfig", 1, 1, function()
            self:Save( true )
        end )

        return
    end

    local data = Glide.ToJSON( {
        version = self.version,

        -- Audio settings
        carVolume = self.carVolume,
        aircraftVolume = self.aircraftVolume,
        explosionVolume = self.explosionVolume,
        hornVolume = self.hornVolume,
        windVolume = self.windVolume,
        vcVolume = self.vcVolume,

        -- Camera settings
        lookSensitivity = self.lookSensitivity,
        cameraInvertX = self.cameraInvertX,
        cameraInvertY = self.cameraInvertY,

        cameraDistance = self.cameraDistance,
        cameraHeight = self.cameraHeight,
        cameraFOVInternal = self.cameraFOVInternal,
        cameraFOVExternal = self.cameraFOVExternal,

        fixedCameraMode = self.fixedCameraMode,
        enableAutoCenter = self.enableAutoCenter,
        autoCenterDelay = self.autoCenterDelay,

        -- Mouse settings
        mouseFlyMode = self.mouseFlyMode,
        mouseSensitivityX = self.mouseSensitivityX,
        mouseSensitivityY = self.mouseSensitivityY,
        mouseInvertX = self.mouseInvertX,
        mouseInvertY = self.mouseInvertY,

        pitchMouseAxis = self.pitchMouseAxis,
        yawMouseAxis = self.yawMouseAxis,
        rollMouseAxis = self.rollMouseAxis,
        mouseDeadzone = self.mouseDeadzone,
        mouseShow = self.mouseShow,

        -- Misc. settings
        maxSkidMarkPieces = self.maxSkidMarkPieces,
        maxTireRollPieces = self.maxTireRollPieces,

        showHUD = self.showHUD,
        showPassengerList = self.showPassengerList,
        showEmptyVehicleHealth = self.showEmptyVehicleHealth,
        showSkybox = self.showSkybox,
        useKMH = self.useKMH,

        manualGearShifting = self.manualGearShifting,
        autoHeadlightOn = self.autoHeadlightOn,
        autoHeadlightOff = self.autoHeadlightOff,
        headlightShadows = self.headlightShadows,
        enableTips = self.enableTips,

        -- Category-action-button dictionary
        binds = self.binds
    }, true )

    Glide.SaveDataFile( "glide.json", data )

    hook.Run( "Glide_OnConfigChange" )
end

--- Check if the config. data requires migration to a new version.
function Config:CheckVersion( data )
    if type( data.version ) ~= "number" then
        Glide.Print( "glide.json: Pre-release version or no version found." )
        Glide.Print( "glide.json: Resetting all settings to default." )
        return {}
    end

    -- This data is fine
    Glide.Print( "glide.json: version %i", data.version )

    return data
end

--- Load settings from disk.
function Config:Load()
    self:Reset()
    self:ResetBinds()

    local data = Glide.FromJSON( Glide.LoadDataFile( "glide.json" ) )
    local SetNumber = Glide.SetNumber

    local LoadBool = function( k, default )
        self[k] = Either( data[k] == nil, default, data[k] == true )
    end

    data = self:CheckVersion( data )

    -- Audio settings
    SetNumber( self, "carVolume", data.carVolume, 0, 1, self.carVolume )
    SetNumber( self, "aircraftVolume", data.aircraftVolume, 0, 1, self.aircraftVolume )
    SetNumber( self, "explosionVolume", data.explosionVolume, 0, 1, self.explosionVolume )
    SetNumber( self, "hornVolume", data.hornVolume, 0, 1, self.hornVolume )
    SetNumber( self, "windVolume", data.windVolume, 0, 1, self.windVolume )
    SetNumber( self, "vcVolume", data.vcVolume, 0, 1, self.vcVolume )

    -- Camera settings
    SetNumber( self, "lookSensitivity", data.lookSensitivity, 0.01, 5, self.lookSensitivity )
    LoadBool( "cameraInvertX", false )
    LoadBool( "cameraInvertY", false )

    SetNumber( self, "cameraDistance", data.cameraDistance, 0.5, 3, self.cameraDistance )
    SetNumber( self, "cameraHeight", data.cameraHeight, 0.25, 2, self.cameraHeight )
    SetNumber( self, "cameraFOVInternal", data.cameraFOVInternal, 30, 120, self.cameraFOVInternal )
    SetNumber( self, "cameraFOVExternal", data.cameraFOVExternal, 30, 120, self.cameraFOVExternal )
    SetNumber( self, "fixedCameraMode", data.fixedCameraMode, 0, 3, self.fixedCameraMode )

    LoadBool( "enableAutoCenter", true )
    SetNumber( self, "autoCenterDelay", data.autoCenterDelay, 0.1, 5, self.autoCenterDelay )

    -- Mouse settings
    self.mouseFlyMode = math.Round( Glide.ValidateNumber( data.mouseFlyMode, 0, 2, self.mouseFlyMode ) )
    LoadBool( "mouseInvertX", false )
    LoadBool( "mouseInvertY", false )

    SetNumber( self, "mouseSensitivityX", data.mouseSensitivityX, 0.01, 5, self.mouseSensitivityX )
    SetNumber( self, "mouseSensitivityY", data.mouseSensitivityY, 0.01, 5, self.mouseSensitivityY )
    SetNumber( self, "pitchMouseAxis", data.pitchMouseAxis, 0, 2, self.pitchMouseAxis )
    SetNumber( self, "yawMouseAxis", data.yawMouseAxis, 0, 2, self.yawMouseAxis )
    SetNumber( self, "rollMouseAxis", data.rollMouseAxis, 0, 2, self.rollMouseAxis )

    self.mouseDeadzone =  Glide.ValidateNumber( data.mouseDeadzone, 0, 1, self.mouseDeadzone )
    LoadBool( "mouseShow", true )

    -- Misc. settings
    SetNumber( self, "maxSkidMarkPieces", data.maxSkidMarkPieces, 0, 1000, self.maxSkidMarkPieces )
    SetNumber( self, "maxTireRollPieces", data.maxTireRollPieces, 0, 1000, self.maxTireRollPieces )

    LoadBool( "showHUD", true )
    LoadBool( "showPassengerList", true )
    LoadBool( "showEmptyVehicleHealth", false )
    LoadBool( "showSkybox", true )
    LoadBool( "useKMH", false )

    LoadBool( "manualGearShifting", false )
    LoadBool( "autoHeadlightOn", true )
    LoadBool( "autoHeadlightOff", true )
    LoadBool( "headlightShadows", true )
    LoadBool( "enableTips", true )

    -- Category-action-button dictionary
    local loadedBinds = type( data.binds ) == "table" and data.binds or {}

    for category, actions in pairs( self.binds ) do
        for action, button in pairs( actions ) do
            local loadedCategory = loadedBinds[category]

            if type( loadedCategory ) == "table" then
                SetNumber( actions, action, loadedCategory[action], KEY_NONE, BUTTON_CODE_LAST, button )
            end
        end
    end

    hook.Run( "Glide_OnConfigChange" )
end

--- Send the current input settings to the server.
function Config:TransmitInputSettings( immediate )
    timer.Remove( "Glide.TransmitInputSettings" )

    if not immediate then
        -- Don't spam when this function gets called in quick succession
        timer.Create( "Glide.TransmitInputSettings", 1, 1, function()
            self:TransmitInputSettings( true )
        end )

        return
    end

    local data = {
        -- Mouse settings
        mouseFlyMode = self.mouseFlyMode,
        replaceYawWithRoll = self.mouseFlyMode == Glide.MOUSE_FLY_MODE.DIRECT and self.yawMouseAxis > 0,

        -- Keyboard settings
        manualGearShifting = self.manualGearShifting,

        -- Action-key dictionary
        binds = self.binds
    }

    Glide.StartCommand( Glide.CMD_INPUT_SETTINGS )
    Glide.WriteTable( data )
    net.SendToServer()
end

--- Apply local skid mark limits.
function Config:ApplySkidMarkLimits( immediate )
    timer.Remove( "Glide.ApplySkidMarkLimits" )

    if not immediate then
        -- Don't spam when this function gets called in quick succession
        timer.Create( "Glide.ApplySkidMarkLimits", 1, 1, function()
            self:ApplySkidMarkLimits( true )
        end )

        return
    end

    Glide.SetupSkidMarkMeshes()
end

Config:Load()

hook.Add( "InitPostEntity", "Glide.TransmitInputSettings", function()
    Config:TransmitInputSettings()
    hook.Run( "Glide_OnConfigChange" )
end )

----------

concommand.Add(
    "glide_settings",
    function() Config:OpenFrame() end,
    nil,
    "Opens the Glide settings menu."
)

if engine.ActiveGamemode() == "sandbox" then
    list.Set(
        "DesktopWindows",
        "GlideDesktopIcon",
        {
            title = Glide.GetLanguageText( "settings_window" ),
            icon = "materials/glide/icons/car.png",
            init = function() Config:OpenFrame() end
        }
    )
end

function Config:CloseFrame()
    if IsValid( self.frame ) then
        self.frame:Close()
    end
end

function Config:OpenFrame()
    if IsValid( self.frame ) then
        self:CloseFrame()
        return
    end

    local theme = Glide.Theme

    local frame = vgui.Create( "Styled_TabbedFrame" )
    frame:SetIcon( "glide/icons/car.png" )
    frame:SetTitle( Glide.GetLanguageText( "settings_window" ) )
    frame:ApplyTheme( theme )
    frame:Center()
    frame:MakePopup()

    frame.OnClose = function()
        self.frame = nil
    end

    self.frame = frame

    local L = Glide.GetLanguageText

    ----- Camera settings -----

    local panelCamera = frame:AddTab( "icon16/camera.png", L"settings.camera" )

    theme:CreateHeader( panelCamera, L"settings.camera" )

    theme:CreateSlider( panelCamera, L"camera.sensitivity", self.lookSensitivity, 0.01, 5, 2, function( value )
        self.lookSensitivity = value
        self:Save()
    end )

    theme:CreateToggleButton( panelCamera, L"camera.invert_x", self.cameraInvertX, function( value )
        self.cameraInvertX = value
        self:Save()
    end )

    theme:CreateToggleButton( panelCamera, L"camera.invert_y", self.cameraInvertY, function( value )
        self.cameraInvertY = value
        self:Save()
    end )

    theme:CreateSlider( panelCamera, L"camera.distance", self.cameraDistance, 0.5, 3, 2, function( value )
        self.cameraDistance = value
        self:Save()
    end )

    theme:CreateSlider( panelCamera, L"camera.height", self.cameraHeight, 0.25, 2, 2, function( value )
        self.cameraHeight = value
        self:Save()
    end )

    theme:CreateSlider( panelCamera, L"camera.fov_internal", self.cameraFOVInternal, 30, 120, 0, function( value )
        self.cameraFOVInternal = value
        self:Save()

        if Glide.Camera.isActive then
            Glide.Camera:SetFirstPerson( true )
        end
    end )

    theme:CreateSlider( panelCamera, L"camera.fov_external", self.cameraFOVExternal, 30, 120, 0, function( value )
        self.cameraFOVExternal = value
        self:Save()

        if Glide.Camera.isActive then
            Glide.Camera:SetFirstPerson( false )
        end
    end )

    local autoCenterButton, autoCenterSlider

    local SetupAutoCenterSettings = function()
        if autoCenterButton then autoCenterButton:Remove() end
        if autoCenterSlider then autoCenterSlider:Remove() end
        if self.fixedCameraMode > 2 then return end

        autoCenterButton = theme:CreateToggleButton( panelCamera, L"camera.autocenter", self.enableAutoCenter, function( value )
            self.enableAutoCenter = value
            self:Save()
        end )

        autoCenterSlider = theme:CreateSlider( panelCamera, L"camera.autocenter_delay", self.autoCenterDelay, 0.1, 5, 2, function( value )
            self.autoCenterDelay = value
            self:Save()
        end )
    end

    local fixedCameraOptions = {
        L"camera.fixed.disabled",
        L"camera.fixed.firstperson",
        L"camera.fixed.thirdperson",
        L"camera.fixed.both"
    }

    theme:CreateComboBox( panelCamera, L"camera.fixed", fixedCameraOptions, self.fixedCameraMode + 1, function( value )
        self.fixedCameraMode = value - 1
        self:Save()
        SetupAutoCenterSettings()
    end )

    SetupAutoCenterSettings()

    ----- Mouse settings -----

    local panelMouse = frame:AddTab( "icon16/mouse.png", L"settings.mouse" )

    theme:CreateHeader( panelMouse, L"settings.mouse" )

    local mouseModeOptions = {
        L"mouse.mode_aim",
        L"mouse.mode_direct",
        L"mouse.mode_camera"
    }

    local mouseAxisOptions = {
        L"mouse.none",
        L"mouse.x",
        L"mouse.y"
    }

    local SetupMouseModeSettings

    theme:CreateComboBox( panelMouse, L"mouse.flying_mode", mouseModeOptions, self.mouseFlyMode + 1, function( value )
        self.mouseFlyMode = value - 1
        self:Save()
        self:TransmitInputSettings()

        SetupMouseModeSettings()
        Glide.MouseInput:Activate()
    end )

    local directMousePanel = vgui.Create( "DPanel", panelMouse )
    directMousePanel:SetPaintBackground( false )
    directMousePanel:Dock( TOP )

    directMousePanel.PerformLayout = function()
        if self.mouseFlyMode == Glide.MOUSE_FLY_MODE.DIRECT then
            directMousePanel:SizeToChildren( false, true )
        else
            directMousePanel:SetTall( 1 )
        end
    end

    SetupMouseModeSettings = function()
        for _, p in pairs( directMousePanel:GetChildren() ) do
            p:Remove()
        end

        if self.mouseFlyMode ~= Glide.MOUSE_FLY_MODE.DIRECT then return end

        theme:CreateComboBox( directMousePanel, L"mouse.pitch_axis", mouseAxisOptions, self.pitchMouseAxis + 1, function( value )
            self.pitchMouseAxis = value - 1
            self:Save()
        end )

        theme:CreateComboBox( directMousePanel, L"mouse.yaw_axis", mouseAxisOptions, self.yawMouseAxis + 1, function( value )
            self.yawMouseAxis = value - 1
            self:Save()
            self:TransmitInputSettings()
        end )

        theme:CreateComboBox( directMousePanel, L"mouse.roll_axis", mouseAxisOptions, self.rollMouseAxis + 1, function( value )
            self.rollMouseAxis = value - 1
            self:Save()
        end )

        theme:CreateToggleButton( directMousePanel, L"mouse.invert_x", self.mouseInvertX, function( value )
            self.mouseInvertX = value
            self:Save()
        end )

        theme:CreateToggleButton( directMousePanel, L"mouse.invert_y", self.mouseInvertY, function( value )
            self.mouseInvertY = value
            self:Save()
        end )

        theme:CreateSlider( directMousePanel, L"mouse.sensitivity_x", self.mouseSensitivityX, 0.1, 5, 1, function( value )
            self.mouseSensitivityX = value
            self:Save()
        end )

        theme:CreateSlider( directMousePanel, L"mouse.sensitivity_y", self.mouseSensitivityY, 0.1, 5, 1, function( value )
            self.mouseSensitivityY = value
            self:Save()
        end )

        theme:CreateSlider( directMousePanel, L"mouse.deadzone", self.mouseDeadzone, 0, 0.5, 2, function( value )
            self.mouseDeadzone = value
            self:Save()
        end )

        theme:CreateToggleButton( directMousePanel, L"mouse.show_hud", self.mouseShow, function( value )
            self.mouseShow = value
            self:Save()
        end )
    end

    SetupMouseModeSettings()

    ----- Keyboard settings -----

    local CreateBinderButton = function( parent, text, actionId, defaultKey, callback )
        local binder = theme:CreateBinderButton( parent, text, defaultKey )

        function binder:OnChange( value )
            if self._ignoreChange then return end

            if Glide.SEAT_SWITCH_BUTTONS[value] then
                self._ignoreChange = true
                binder:SetValue( defaultKey )
                self._ignoreChange = nil

                local msg = Glide.GetLanguageText( "input.reserved_seat_key" ):format( input.GetKeyName( value ) )
                Derma_Message( msg, "#glide.input.invalid_bind", "#glide.ok" )
            else
                callback( actionId, value )
            end
        end
    end

    local panelKeyboard = frame:AddTab( "icon16/keyboard.png", L"settings.input" )
    local binds = self.binds

    local generalBinds = binds["general_controls"]

    local function OnChangeGeneralBind( action, key )
        generalBinds[action] = key
        self:Save()
        self:TransmitInputSettings()
    end

    theme:CreateHeader( panelKeyboard, L"input.general_controls" )
    CreateBinderButton( panelKeyboard, L"input.switch_weapon", "switch_weapon", generalBinds.switch_weapon, OnChangeGeneralBind )
    CreateBinderButton( panelKeyboard, L"input.toggle_engine", "toggle_engine", generalBinds.toggle_engine, OnChangeGeneralBind )

    local landBinds = binds["land_controls"]

    local function OnChangeLandBind( action, key )
        landBinds[action] = key
        self:Save()
        self:TransmitInputSettings()
    end

    theme:CreateHeader( panelKeyboard, L"input.land_controls" )
    CreateBinderButton( panelKeyboard, L"input.attack", "attack", landBinds.attack, OnChangeLandBind )

    CreateBinderButton( panelKeyboard, L"input.steer_left", "steer_left", landBinds.steer_left, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.steer_right", "steer_right", landBinds.steer_right, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.accelerate", "accelerate", landBinds.accelerate, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.brake", "brake", landBinds.brake, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.handbrake", "handbrake", landBinds.handbrake, OnChangeLandBind )

    CreateBinderButton( panelKeyboard, L"input.horn", "horn", landBinds.horn, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.siren", "siren", landBinds.siren, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.headlights", "headlights", landBinds.headlights, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.reduce_throttle", "reduce_throttle", landBinds.reduce_throttle, OnChangeLandBind )

    CreateBinderButton( panelKeyboard, L"input.lean_forward", "lean_forward", landBinds.lean_forward, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.lean_back", "lean_back", landBinds.lean_back, OnChangeLandBind )

    CreateBinderButton( panelKeyboard, L"input.signal_left", "signal_left", landBinds.signal_left, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.signal_right", "signal_right", landBinds.signal_right, OnChangeLandBind )

    theme:CreateHeader( panelKeyboard, L"input.manual_shift" )
    theme:CreateToggleButton( panelKeyboard, L"input.manual_shift", self.manualGearShifting, function( value )
        self.manualGearShifting = value
        self:Save()
        self:TransmitInputSettings()
    end )

    CreateBinderButton( panelKeyboard, L"input.shift_up", "shift_up", landBinds.shift_up, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.shift_down", "shift_down", landBinds.shift_down, OnChangeLandBind )
    CreateBinderButton( panelKeyboard, L"input.shift_neutral", "shift_neutral", landBinds.shift_neutral, OnChangeLandBind )

    local airBinds = binds["aircraft_controls"]

    local function OnChangeAirBind( action, key )
        airBinds[action] = key
        self:Save()
        self:TransmitInputSettings()
    end

    theme:CreateHeader( panelKeyboard, L"input.aircraft_controls" )
    CreateBinderButton( panelKeyboard, L"input.attack", "attack", airBinds.attack, OnChangeAirBind )
    CreateBinderButton( panelKeyboard, L"input.attack_alt", "attack_alt", airBinds.attack_alt, OnChangeAirBind )

    CreateBinderButton( panelKeyboard, L"input.free_look", "free_look", airBinds.free_look, OnChangeAirBind )
    CreateBinderButton( panelKeyboard, L"input.landing_gear", "landing_gear", airBinds.landing_gear, OnChangeAirBind )
    CreateBinderButton( panelKeyboard, L"input.countermeasures", "countermeasures", airBinds.countermeasures, OnChangeAirBind )

    CreateBinderButton( panelKeyboard, L"input.pitch_up", "pitch_up", airBinds.pitch_up, OnChangeAirBind )
    CreateBinderButton( panelKeyboard, L"input.pitch_down", "pitch_down", airBinds.pitch_down, OnChangeAirBind )
    CreateBinderButton( panelKeyboard, L"input.yaw_left", "yaw_left", airBinds.yaw_left, OnChangeAirBind )
    CreateBinderButton( panelKeyboard, L"input.yaw_right", "yaw_right", airBinds.yaw_right, OnChangeAirBind )
    CreateBinderButton( panelKeyboard, L"input.roll_left", "roll_left", airBinds.roll_left, OnChangeAirBind )
    CreateBinderButton( panelKeyboard, L"input.roll_right", "roll_right", airBinds.roll_right, OnChangeAirBind )
    CreateBinderButton( panelKeyboard, L"input.throttle_up", "throttle_up", airBinds.throttle_up, OnChangeAirBind )
    CreateBinderButton( panelKeyboard, L"input.throttle_down", "throttle_down", airBinds.throttle_down, OnChangeAirBind )

    ----- Audio settings -----

    local panelAudio = frame:AddTab( "icon16/sound.png", L"settings.audio" )

    theme:CreateHeader( panelAudio, L"settings.audio" )

    theme:CreateSlider( panelAudio, L"audio.car_volume", self.carVolume, 0, 1, 1, function( value )
        self.carVolume = value
        self:Save()
    end )

    theme:CreateSlider( panelAudio, L"audio.aircraft_volume", self.aircraftVolume, 0, 1, 1, function( value )
        self.aircraftVolume = value
        self:Save()
    end )

    theme:CreateSlider( panelAudio, L"audio.explosion_volume", self.explosionVolume, 0, 1, 1, function( value )
        self.explosionVolume = value
        self:Save()
    end )

    theme:CreateSlider( panelAudio, L"audio.horn_volume", self.hornVolume, 0, 1, 1, function( value )
        self.hornVolume = value
        self:Save()
    end )

    theme:CreateSlider( panelAudio, L"audio.wind_volume", self.windVolume, 0, 1, 1, function( value )
        self.windVolume = value
        self:Save()
    end )

    theme:CreateSlider( panelAudio, L"audio.voice_chat_reduction", self.vcVolume, 0, 1, 1, function( value )
        self.vcVolume = value
        self:Save()
    end )

    ----- Misc -----

    local panelMisc = frame:AddTab( "icon16/cog.png", L"settings.misc" )

    theme:CreateHeader( panelMisc, L"settings.skidmarks" )

    local maxSkidSlider

    maxSkidSlider = theme:CreateSlider( panelMisc, L"misc.skid_mark_max", self.maxSkidMarkPieces, 0, 1000, 0, function( value )
        if value < 10 then
            value = 0
            maxSkidSlider:SetValue( value )
        end

        self.maxSkidMarkPieces = value
        self:Save()
        self:ApplySkidMarkLimits()
    end )

    local maxRollSlider

    maxRollSlider = theme:CreateSlider( panelMisc, L"misc.roll_mark_max", self.maxTireRollPieces, 0, 1000, 0, function( value )
        if value < 10 then
            value = 0
            maxRollSlider:SetValue( value )
        end

        self.maxTireRollPieces = value
        self:Save()
        self:ApplySkidMarkLimits()
    end )

    theme:CreateHeader( panelMisc, L"settings.misc" )

    theme:CreateToggleButton( panelMisc, L"misc.show_hud", self.showHUD, function( value )
        self.showHUD = value
        self:Save()
    end )

    theme:CreateToggleButton( panelMisc, L"misc.show_passenger_list", self.showPassengerList, function( value )
        self.showPassengerList = value
        self:Save()
    end )

    theme:CreateToggleButton( panelMisc, L"misc.show_health_empty_vehicles", self.showEmptyVehicleHealth, function( value )
        self.showEmptyVehicleHealth = value
        self:Save()
    end )

    theme:CreateToggleButton( panelMisc, L"misc.show_skybox", self.showSkybox, function( value )
        self.showSkybox = value
        self:Save()
        Glide.EnableSkyboxIndicator()
    end )

    theme:CreateToggleButton( panelMisc, L"misc.auto_headlights_on", self.autoHeadlightOn, function( value )
        self.autoHeadlightOn = value
        self:Save()
    end )

    theme:CreateToggleButton( panelMisc, L"misc.auto_headlights_off", self.autoHeadlightOff, function( value )
        self.autoHeadlightOff = value
        self:Save()
    end )

    theme:CreateToggleButton( panelMisc, L"misc.headlight_shadows", self.headlightShadows, function( value )
        self.headlightShadows = value
        self:Save()
    end )

    theme:CreateToggleButton( panelMisc, L"misc.tips", self.enableTips, function( value )
        self.enableTips = value
        self:Save()
    end )

    theme:CreateToggleButton( panelMisc, L"misc.use_kmh", self.useKMH, function( value )
        self.useKMH = value
        self:Save()
    end )

    theme:CreateHeader( panelMisc, L"settings.reset" )

    theme:CreateButton( panelMisc, L"misc.reset_binds", function()
        Derma_Query( L"misc.reset_binds_query", L"misc.reset_binds", L"yes", function()
            self:CloseFrame()
            self:ResetBinds()
            self:Save()
            self:TransmitInputSettings()

            timer.Simple( 1, function()
                self:OpenFrame()
                self.frame:SetActiveTabByIndex( 5 )
            end )
        end, L"no" )
    end )

    theme:CreateButton( panelMisc, L"misc.reset_settings", function()
        Derma_Query( L"misc.reset_settings_query", L"misc.reset_settings", L"yes", function()
            self:CloseFrame()
            self:Reset()
            self:Save()
            self:TransmitInputSettings()
            self:ApplySkidMarkLimits()

            timer.Simple( 1, function()
                self:OpenFrame()
                self.frame:SetActiveTabByIndex( 5 )
            end )
        end, L"no" )
    end )
end

local FrameTime = FrameTime
local Approach = math.Approach

local glideVolume = 1

hook.Add( "Tick", "Glide.CheckVoiceActivity", function()
    local players = player.GetAll()
    local ply, isAnyoneTalking = nil, false

    for i = 1, #players do
        ply = players[i]

        if ply:IsVoiceAudible() and ply:VoiceVolume() > 0.01 then
            isAnyoneTalking = true
            break
        end
    end

    glideVolume = Approach(
        glideVolume,
        isAnyoneTalking and Config.vcVolume or 1,
        FrameTime() * ( isAnyoneTalking and 10 or 2 )
    )
end )

-- Calculate the volume multiplier for a specific audio type,
-- depending on settings and how loud the voice chat is.
--
-- audioType must be one of these:
-- "carVolume", "aircraftVolume", "explosionVolume", "hornVolume", "windVolume"
function Config.GetVolume( audioType )
    return Config[audioType] * glideVolume
end
