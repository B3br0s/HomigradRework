AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	local tbl = hg.Armors[self.Armor]
	self.Entity:SetModel(tbl.Model)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(true)
	self:SetModelScale(tbl.Scale or 1,0)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(true)
	end
end

function ENT:Use( activator )
    if activator:IsPlayer() then 

		local ply = activator

		local tbl = hg.Armors[self.Armor]
		//print(activator.armor[tbl.Placement])
		if ply.armor[tbl.Placement] != "NoArmor" then
			hg.DropArmor(ply,ply.armor[tbl.Placement])
			ply.armor[tbl.Placement] = self.Armor
		else
			ply.armor[tbl.Placement] = self.Armor
		end
        self:Remove()

		net.Start("armor_sosal")
		net.WriteEntity(ply)
		net.WriteTable(ply.armor)
		net.Broadcast()
	end
end