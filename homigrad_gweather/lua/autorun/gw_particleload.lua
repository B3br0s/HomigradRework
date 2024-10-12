AddCSLuaFile()

local files, directories = file.Find( "particles/gweather/*.pcf", "GAME" ) -- change this to the actual steamid later :)
for k,v in pairs(files) do 
	game.AddParticles("particles/gweather/"..v)
end

local gwprecache = { -- name of particle effect
"gw_aurora_green",
"gw_aurora_blue",
"gw_aurora_green_small",
"gw_aurora_blue_small",
"gweather_breath",
"gw_heavy_rain",
"gw_light_rain",
"gw_light_snow",
"gw_sleet",
"gw_quarter-sized_hail",
"gw_golfball-sized_hail",
"gw_baseball-sized_hail",
"gw_grapefruit-sized_hail",
"gw_heavy_snow",
"gw_haboob",
"gw_ash_storm",
"gw_heavy_fog",
"gw_blizzard",
"gw_extreme_rain",
"gw_acid_rain",
"gw_light_rain_drop",
"gw_firestorm",
"gw_radiation_storm",
"gw_downburst",
"gw_articblast",
"gw_pyroclastic_flow",
"gw_derecho",
"gw_ash_storm_debrie",
"gw_lightning_sprite_01",
"gw_lightning_sprite_02",
"gw_lightning_sprite_03",
"gw_lavabomb_explosion_main_air",
"gw_lavabomb_explosion_main_ground",
"gw_lavabomb_explosion_main_water",
"gw_haboob_cloud",
"gw_lightning_impact_negative",
"gw_lightning_impact_positive",
"gw_lightning_impact_positive_flash",
"gw_lightning_impact_positive_flash"
}

hook.Add( "InitPostEntity", "gWeather.PrecacheParticles", function()
	for k,pps in pairs(gwprecache) do
		PrecacheParticleSystem(pps)
	end	
end)