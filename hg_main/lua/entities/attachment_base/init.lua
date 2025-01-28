AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetColor(Color(255,255,255))
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetUseType(SIMPLE_USE)
	self:SetModelScale(self:GetModelScale()*1,0)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(999999999)
		phys:Wake()
		phys:EnableMotion(true)
	end
end

function ENT:Use(ent)
    if ent:IsPlayer() then
		hg.GiveAttachment(ent, self:GetClass()) -- круто што оставили вот эту ффункцию
		self:Remove()
	end
end