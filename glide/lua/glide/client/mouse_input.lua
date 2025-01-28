CreateConVar( "glide_input_pitch", "0", FCVAR_USERINFO + FCVAR_UNREGISTERED, "Transmit this pitch input to the server.", -1, 1 )
CreateConVar( "glide_input_yaw", "0", FCVAR_USERINFO + FCVAR_UNREGISTERED, "Transmit this yaw input to the server.", -1, 1 )
CreateConVar( "glide_input_roll", "0", FCVAR_USERINFO + FCVAR_UNREGISTERED, "Transmit this roll input to the server.", -1, 1 )

local MouseInput = Glide.MouseInput or {}

Glide.MouseInput = MouseInput

hook.Add( "Glide_OnLocalEnterVehicle", "Glide.ActivateMouseInput", function()
    MouseInput:Activate()
end )

hook.Add( "Glide_OnLocalExitVehicle", "Glide.DeactivateMouseInput", function()
    MouseInput:Deactivate()
end )

local Config = Glide.Config

function MouseInput:Activate()
    local vehicle = Glide.currentVehicle

    -- Only activate mouse input while being a aircraft pilot with direct mouse input enabled
    if
        not IsValid( vehicle ) or
        not Glide.IsAircraft( vehicle ) or
        Glide.currentSeatIndex > 1 or
        Config.mouseFlyMode ~= Glide.MOUSE_FLY_MODE.DIRECT
    then
        self:Deactivate()

        return
    end

    self.mouse = { 0, 0 }
    self.freeLook = false
    self:Reset()

    self.cvarPitch = GetConVar( "glide_input_pitch" )
    self.cvarYaw = GetConVar( "glide_input_yaw" )
    self.cvarRoll = GetConVar( "glide_input_roll" )

    hook.Add( "InputMouseApply", "Glide.UpdateMouseInput", function( _, x, y )
        self:InputMouseApply( x, y )
    end )

    hook.Add( "Think", "Glide.UpdateMouseInput", function()
        local freeLook = input.IsKeyDown( Config.binds.aircraft_controls.free_look ) or vgui.CursorVisible()

        if self.freeLook ~= freeLook then
            self.freeLook = freeLook
            self:Reset()
        end
    end )

    hook.Add( "HUDPaint", "Glide.DrawMouseInput", function()
        self:DrawHUD()
    end )
end

function MouseInput:Deactivate()
    hook.Remove( "InputMouseApply", "Glide.UpdateMouseInput" )
    hook.Remove( "Think", "Glide.UpdateMouseInput" )
    hook.Remove( "HUDPaint", "Glide.DrawMouseInput" )
end

function MouseInput:Reset()
    self.mouse[1] = 0
    self.mouse[2] = 0

    if not self.cvarPitch then return end

    self.cvarPitch:SetFloat( 0 )
    self.cvarYaw:SetFloat( 0 )
    self.cvarRoll:SetFloat( 0 )
end

local Abs = math.abs
local Clamp = math.Clamp

local function ConvertInput( axis, mouse, deadzone )
    if axis == 0 then return 0 end

    local value = mouse[axis]
    if Abs( value ) < deadzone then return 0 end

    return value
end

function MouseInput:InputMouseApply( x, y )
    if self.freeLook then return end

    x = Config.mouseInvertX and -x or x
    y = Config.mouseInvertY and -y or y

    local mouse = self.mouse
    local deadzone = Config.mouseDeadzone

    mouse[1] = Clamp( mouse[1] + x * Config.mouseSensitivityX * 0.01, -1, 1 )
    mouse[2] = Clamp( mouse[2] - y * Config.mouseSensitivityY * 0.01, -1, 1 )

    local pitch = ConvertInput( Config.pitchMouseAxis, mouse, deadzone )
    local yaw = ConvertInput( Config.yawMouseAxis, mouse, deadzone )
    local roll = ConvertInput( Config.rollMouseAxis, mouse, deadzone )

    self.cvarPitch:SetFloat( pitch )
    self.cvarYaw:SetFloat( yaw )
    self.cvarRoll:SetFloat( roll )
end

local ScrW, ScrH = ScrW, ScrH
local SetColor = surface.SetDrawColor
local SetMaterial = surface.SetMaterial

local DrawRect = surface.DrawRect
local DrawTexturedRectRotated = surface.DrawTexturedRectRotated

local MAT_BACKGROUND = Material( "glide/mouse_area.png", "smooth" )
local MAT_JOYSTICK = Material( "glide/mouse_joystick.png", "smooth" )

function MouseInput:DrawHUD()
    if not Config.mouseShow then return end
    if self.freeLook then return end

    local sw, sh = ScrW(), ScrH()
    local size = sh * 0.1

    local x = sw * 0.5
    local y = sh * 0.9

    SetColor( 50, 50, 50, 180 )

    local deadzoneSize = size * Config.mouseDeadzone

    DrawRect( x - size * 0.5, y - deadzoneSize * 0.5, size, deadzoneSize )
    DrawRect( x - deadzoneSize * 0.5, y - size * 0.5, deadzoneSize, size )

    SetColor( 255, 255, 255, 255 )
    SetMaterial( MAT_BACKGROUND )
    DrawTexturedRectRotated( x, y, size, size, 0 )

    size = size * 0.25

    local mouse = self.mouse

    SetMaterial( MAT_JOYSTICK )
    DrawTexturedRectRotated( x + mouse[1] * size * 2, y - mouse[2] * size * 2, size, size, 0 )
end
