local ENT = oop.Reg("wep","base_entity",true)
if not ENT then return INCLUDE_BREAK end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "wep"

ENT.Spawnable = false
DEFINE_BASECLASS( "base_anim" )


