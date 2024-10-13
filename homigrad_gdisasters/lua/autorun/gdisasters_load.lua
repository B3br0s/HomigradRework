

if (SERVER) then

	AddCSLuaFile("autorun/gdisasters_load.lua")
	AddCSLuaFile("gdisasters/shared_func/main.lua")
	AddCSLuaFile("gdisasters/shared_func/netstrings.lua")	
	AddCSLuaFile("gdisasters/game/convars/main.lua")	
	AddCSLuaFile("gdisasters/extensions/paths.lua")
	AddCSLuaFile("gdisasters/extensions/bounds.lua")
	AddCSLuaFile("gdisasters/player/cl_menu.lua")
	AddCSLuaFile("gdisasters/player/sv_menu.lua")
	AddCSLuaFile("gdisasters/player/postspawn.lua")
	AddCSLuaFile("gdisasters/game/water_physics.lua")
	AddCSLuaFile("gdisasters/game/world_init.lua")
	AddCSLuaFile("gdisasters/spawnlist/menu/main.lua")
	AddCSLuaFile("gdisasters/spawnlist/menu/populate.lua")
	AddCSLuaFile("gdisasters/game/damagetypes.lua")

	include("gdisasters/shared_func/main.lua")	
	include("gdisasters/shared_func/netstrings.lua")	
	include("gdisasters/extensions/paths.lua")
	include("gdisasters/extensions/bounds.lua")
	include("gdisasters/player/sv_menu.lua")
	include("gdisasters/game/antilag/main.lua")
	include("gdisasters/game/water_physics.lua")
	include("gdisasters/game/world_init.lua")
	include("gdisasters/game/convars/main.lua")
	include("gdisasters/player/postspawn.lua")
	include("gdisasters/player/cl_menu.lua")
	
	include("gdisasters/spawnlist/menu/main.lua")
	include("gdisasters/spawnlist/menu/populate.lua")
	include("gdisasters/game/damagetypes.lua")

	
end

if (CLIENT) then	

	include("gdisasters/player/cl_menu.lua")
	include("gdisasters/shared_func/main.lua")	
	include("gdisasters/shared_func/netstrings.lua")	
	include("gdisasters/extensions/paths.lua")
	include("gdisasters/extensions/bounds.lua")
	include("gdisasters/player/postspawn.lua")
		
	include("gdisasters/spawnlist/menu/main.lua")
	include("gdisasters/spawnlist/menu/populate.lua")
	
end


PrecacheParticleSystem("earthquake_player_ground_rocks")
PrecacheParticleSystem("earthquake_player_ground_dust")
PrecacheParticleSystem("earthquake_player_ground_debris")



PrecacheParticleSystem("tsunami_splash_effect_r100")
PrecacheParticleSystem("tsunami_splash_effect_r200")
PrecacheParticleSystem("tsunami_splash_effect_r300")
PrecacheParticleSystem("tsunami_splash_effect_r400")
PrecacheParticleSystem("tsunami_splash_effect_r500")


