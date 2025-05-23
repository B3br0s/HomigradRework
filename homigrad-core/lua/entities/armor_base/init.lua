AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

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
		
		sound.Play("eft_gear_sounds/gear_armor_use.wav",activator:GetPos(),100,100,1)

        self:Remove()

		//net.Start("armor_sosal")
		//net.WriteEntity(ply)
		//net.WriteTable(ply.armor)
		//net.Broadcast()
	end
end

function ENT:Initialize()
	local tbl = hg.Armors[self.Armor]
	self.Entity:SetModel(tbl.Model)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
    if SERVER then
	    self:SetUseType(SIMPLE_USE)
    end
	self:DrawShadow(true)
	self:SetModelScale(tbl.Scale or 1,0)
	timer.Simple(0,function()
		self:PhysicsInit( SOLID_VPHYSICS ) 
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableMotion(true)
		end
	end)
end