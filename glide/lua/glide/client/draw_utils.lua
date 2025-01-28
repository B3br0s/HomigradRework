local cache = {}

function Glide.GetCachedIcon( path )
    if cache[path] then
        return cache[path]
    end

    cache[path] = Material( path, "smooth" )

    return cache[path]
end

local ScrH = ScrH
local Floor = math.floor

local SetColor = surface.SetDrawColor
local SetMaterial = surface.SetMaterial
local DrawTexturedRectRotated = surface.DrawTexturedRectRotated

function Glide.DrawWeaponCrosshair( x, y, icon, size, color )
    size = Floor( ScrH() * size )

    if not cache[icon] then
        cache[icon] = Material( icon, "smooth" )
    end

    SetMaterial( cache[icon] )
    SetColor( color:Unpack() )
    DrawTexturedRectRotated( x, y, size, size, 0 )
end

local MAT_BACKGROUND = Material( "glide/weapon_name.png", "smooth" )

function Glide.DrawWeaponSelection( name, icon )
    local sw, sh = ScrW(), ScrH()
    local size = sh * 0.15
    local y = sh * 0.2

    SetMaterial( MAT_BACKGROUND )
    SetColor( 255, 255, 255 )
    DrawTexturedRectRotated( sw * 0.5, y, size, size, 0 )

    draw.SimpleText( name, "GlideSelectedWeapon", sw * 0.5, y + size * 0.06, color_white, 1 )

    if not cache[icon] then
        cache[icon] = Material( icon, "smooth" )
    end

    SetMaterial( cache[icon] )
    DrawTexturedRectRotated( sw * 0.5, y - size * 0.1, size * 0.3, size * 0.3, 0 )
end

local DrawRect = surface.DrawRect
local GetCachedIcon = Glide.GetCachedIcon

local THEME_COLOR = Glide.THEME_COLOR

function Glide.DrawHealthBar( x, y, w, h, health, icon )
    icon = GetCachedIcon( icon or "materials/glide/icons/cogs.png" )

    SetColor( 20, 20, 20, 240 )
    DrawRect( x, y, w, h )

    SetColor( THEME_COLOR:Unpack() )
    DrawRect( x + 1, y + 1, h - 2, h - 2 )

    SetMaterial( icon )
    SetColor( 255, 255, 255, 255 )
    DrawTexturedRectRotated( x + h * 0.5, y + h * 0.5, h * 0.9, h * 0.9, 0 )

    local padding = 1 + Floor( h * 0.13 )

    x = x + h + padding
    y = y + padding
    w = w - h - padding * 2
    h = h - padding * 2

    SetColor( 255 * ( 1 - health ), 255 * health, 0, 255 )
    DrawRect( x, y, w * health, h )
end

local VEHICLE_ICONS = {
    [Glide.VEHICLE_TYPE.CAR] = "materials/glide/icons/car.png",
    [Glide.VEHICLE_TYPE.MOTORCYCLE] = "materials/glide/icons/motorcycle.png",
    [Glide.VEHICLE_TYPE.HELICOPTER] = "materials/glide/icons/helicopter.png",
    [Glide.VEHICLE_TYPE.PLANE] = "materials/glide/icons/plane.png",
    [Glide.VEHICLE_TYPE.TANK] = "materials/glide/icons/tank.png"
}

function Glide.GetVehicleIcon( vehicleType )
    return VEHICLE_ICONS[vehicleType] or VEHICLE_ICONS[1]
end

local DrawHealthBar = Glide.DrawHealthBar

function Glide.DrawVehicleHealth( x, y, w, h, vehicleType, chassisHealth, engineHealth )
    local colW = w * 0.49

    DrawHealthBar( x, y, colW, h, chassisHealth, VEHICLE_ICONS[vehicleType] or VEHICLE_ICONS[1] )
    DrawHealthBar( x + w - colW, y, colW, h, engineHealth )
end

local COLOR_WHITE = Color( 255, 255, 255, 255 )

function Glide.DrawRotatedBox( x, y, w, h, ang, color )
    color = color or COLOR_WHITE

    draw.NoTexture()
    SetColor( color:Unpack() )
    surface.DrawTexturedRectRotated( x, y, w, h, ang )
end

local RoundedBoxEx = draw.RoundedBoxEx
local DrawSimpleText = draw.SimpleText

local COLOR_STATUS_BG = Color( 20, 20, 20, 220 )

function Glide.DrawVehicleStatusItem( x, y, w, h, radius, padding, label, value, progress )
    RoundedBoxEx( radius, x, y, w, h, COLOR_STATUS_BG, true, false, true, false )

    if progress then
        RoundedBoxEx( radius, x + 1, y + 1, w * progress - 2, h - 2, THEME_COLOR, true, false, true, false )
    end

    DrawSimpleText( label, "GlideHUD", x + padding, y + h * 0.5, COLOR_WHITE, 0, 1 )

    if value then
        DrawSimpleText( value, "GlideHUD", x + w - padding, y + h * 0.5, COLOR_WHITE, 2, 1 )
    end
end
