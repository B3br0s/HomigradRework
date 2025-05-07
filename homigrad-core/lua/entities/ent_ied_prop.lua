AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity" 
ENT.PrintName = "IED Prop"
ENT.Author = "Homigrad"
ENT.Category = "Разное"
ENT.Purpose = "ну а хули"
ENT.Spawnable = true

function ENT:Initialize()
	if SERVER then
	    self:SetModel( "models/props_junk/cardboard_box004a.mdl" )
	    self:PhysicsInit( SOLID_VPHYSICS ) 
	    self:SetMoveType( MOVETYPE_VPHYSICS )
	    self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType(SIMPLE_USE)
        self:SetModelScale(0.5,0)
	    local phys = self:GetPhysicsObject()
	    if phys:IsValid() then
	        phys:Wake()
	    end
	end
end

if SERVER then return end

function ENT:Draw()
    self:DrawModel()
end