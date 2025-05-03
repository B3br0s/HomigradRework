AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ent_small_crate" 
ENT.PrintName = "Ящик со взрывчаткой"
ENT.Author = "Homigrad"
ENT.Category = "Разное"
ENT.Purpose = ""
ENT.Spawnable = true

function ENT:Initialize()
	if SERVER then
	    self:SetModel( "models/sarma_crates/supply_crate02.mdl" )
	    self:PhysicsInit( SOLID_VPHYSICS ) 
	    self:SetMoveType( MOVETYPE_VPHYSICS )
	    self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType(SIMPLE_USE)
        self:SetModelScale(1,0)
		self.AmtLoot = 1
		self:SetSkin(3)
		local shit = table.Random(hg.loots.explosives_crate)
		local shit_ent = ents.Create(shit)
		shit_ent:Spawn()
		shit_ent:SetPos(self:GetPos())
		self.JModInv = shit_ent
		self:SetNWEntity("JModInv",shit_ent)
		self.Inventory = {}
	    local phys = self:GetPhysicsObject()
	    if phys:IsValid() then
	        phys:Wake()
	    end
	end
end

if SERVER then
	function ENT:Think()
		local shit_ent = self.JModInv
		self:SetNWEntity("JModInv",shit_ent)
		if IsValid(shit_ent) then
			shit_ent:SetPos(self:GetPos())
			shit_ent:SetNoDraw(true)
			shit_ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
		end
	end
end