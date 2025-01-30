local lcl = SERVER and AddCSLuaFile or include
local lsv = SERVER and include or function() end
local lsh = function(path) lsv(path) lcl(path) end

lsv('jmod_eft/inventory/sv_inventory.lua')
lcl('jmod_eft/inventory/cl_gui.lua')
-- lsh('')