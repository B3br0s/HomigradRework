
if (CLIENT) then
print("HeLo")

function gDisasters_PostSpawnCL()

	LocalPlayer().gDisasters = {}

	
	local function gDisasters_SetupHUDConvars()
	
	
		CreateConVar( "gdisasters_graphics_water_quality", 1, {FCVAR_ARCHIVE}	, "" )
		
	
		CreateConVar( "gdisasters_graphics_dr_resolution", "48x48", {FCVAR_ARCHIVE}	, "")
		CreateConVar( "gdisasters_graphics_dr_monochromatic", "false", {FCVAR_ARCHIVE}	, "")
		CreateConVar( "gdisasters_graphics_dr_maxrenderdistance", 500, {FCVAR_ARCHIVE}	, "")

		CreateConVar( "gdisasters_graphics_dr_refreshrate", 2, {FCVAR_ARCHIVE}	, "")
		CreateConVar( "gdisasters_graphics_dr_updaterate", 2, {FCVAR_ARCHIVE}	, "")
		
		
	end

	gDisasters_SetupHUDConvars()
	
end

hook.Add( "InitPostEntity", "gDisasters_PostSpawnCL", gDisasters_PostSpawnCL )
end
