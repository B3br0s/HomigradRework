local cvarlist={
	{"gw_windphysics_player",1,"Enable custom player gWeather wind physics?"},
	{"gw_windphysics_prop",1,"Enable custom prop gWeather wind physics?"},
	{"gw_windphysics_unweld",1,"Should the wind destroy constraints?"},
	{"gw_nextwind",0.1,"How often should the wind push objects?"},
	{"gw_tempaffect",0,"Should weather affect your body temperature?"},
	{"gw_tempaffect_rate",1,"How fast should your body temperature increase/decrease?"},
	{"gw_weather_lifetime",0,"How long should the weather last for? ( 0 = usually infinite, 1-x = lifetime )"},
	{"gw_weather_entitydamage",1,"Should weather deal damage to entities?"}
}

if file.Exists("autorun/gdisasters_load.lua","LUA") then table.insert(cvarlist,{"gw_weather_shouldflood",1,"Should gDisasters floods spawn with hurricanes?"}) end

if (SERVER) then
	
local servercvarlist={
	
}

end

for k,v in ipairs(cvarlist) do
	CreateConVar( v[1], (v[2] or 1), {FCVAR_ARCHIVE,FCVAR_REPLICATED}, (v[3] or "") )
end

if (CLIENT) then

local clientcvarlist={
	{"gw_particle_level","high","Change particle density"},
	{"gw_screenshake",1,"should player's screen shake during high winds?"},
	{"gw_matchange",1,"can the ground material be replaced?"},
	{"gw_screeneffects",1},
	{"gw_hud_temp","celsius"},
	{"gw_hud_wind","km/h"},
	{"gw_temp_effect",0,"Should HUD temperature effects appear?"},
	{"gw_lightning_flash",1,"Should sky flash during lightning?"},
	{"gw_windvolume",1,"How loud are the wind sound effects?"},
	{"gw_enablefog",1,"Should weather have fog?"}
}

	
	for k,v in ipairs(clientcvarlist) do
		CreateConVar( v[1], (v[2] or 1), FCVAR_ARCHIVE, (v[3] or "") )
	end
	
--[[
	for k,v in ipairs(cvarlist) do
		CreateConVar( v[1], (v[2] or 1), FCVAR_NONE, (v[3] or "") ) -- placeholder convar for menus
	end
--]]

end