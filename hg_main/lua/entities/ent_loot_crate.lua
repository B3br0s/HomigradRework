AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity" 
ENT.PrintName = "Ящик"
ENT.Author = "Homigrad"
ENT.Category = "Разное"
ENT.Purpose = ""
ENT.Spawnable = true

function ENT:Initialize()
	if SERVER then
	    self:SetModel( "models/sarma_crates/supply_crate03.mdl" )
	    self:PhysicsInit( SOLID_VPHYSICS ) 
	    self:SetMoveType( MOVETYPE_VPHYSICS )
	    self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType(SIMPLE_USE)
        self:SetModelScale(1,0)
	    local phys = self:GetPhysicsObject()
	    if phys:IsValid() then
	        phys:Wake()
	    end
	end
end

if SERVER then
	util.AddNetworkString("hg inventory")
end

function ENT:Use(ply)
	if !ply:IsPlayer() then
		return
	end

	
end

if SERVER then return end

net.Receive("hg inventory",function()
	local inv = net.ReadTable()
end)

function ENT:Draw()
    self:DrawModel()
end