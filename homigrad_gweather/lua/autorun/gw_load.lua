AddCSLuaFile()

gWeatherInstalled = true
gWeatherVersion = "1.0.7"

gWeather = gWeather or {}
gWeather.WeatherTypes = gWeather.WeatherTypes or {}

local function CSInclude(dir)
	if SERVER then
		AddCSLuaFile(dir)
	end
include(dir)
end

local function SInclude(dir)
	if SERVER then
		AddCSLuaFile(dir)
		include(dir)
	end
end

local function CInclude(dir)
	if SERVER then
		AddCSLuaFile(dir)
	end
	if CLIENT then
		include(dir)
	end
end


if SERVER then
	resource.AddWorkshop("3322707383")
end

--shared
CSInclude("gweather/convars/convars.lua")
CSInclude("gweather/functions/player/hooks.lua")
CSInclude("gweather/functions/functions.lua")
CSInclude("gweather/functions/player/functions.lua")
CSInclude("gweather/functions/netstrings.lua")
CSInclude("gweather/functions/atmosphere/atmosphere.lua")
CSInclude("gweather/functions/atmosphere/temperature.lua")
CSInclude("gweather/functions/atmosphere/windphysics.lua")
CSInclude("gweather/functions/atmosphere/skypaint.lua")
CSInclude("gweather/functions/atmosphere/fog.lua")
CSInclude("gweather/functions/perlin.lua")
CSInclude("gweather/map/map.lua")

hook.Add( "InitPostEntity", "gWeatherInitMapFuncs", function()
	--CSInclude("gweather/map/map.lua")
	CSInclude("gweather/map/mat.lua")
	MsgC( Color( 175, 175, 255 ), "gWeather: Map Editors Loaded!\n" )
end)

--client
CInclude("gweather/menu/menu.lua")
CInclude("gweather/convars/menu.lua")

MsgC( Color( 175, 175, 255 ), "gWeather: Loaded!\n" )