AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity" 
ENT.PrintName = "Средний Ящик"
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
		self.AmtLoot = math.random(2,4)
		self.Inventory = {}
		for i = 1, math.random(1,self.AmtLoot) do
			local shit = table.Random(hg.loots.medium_crate)
			//print(shit)
			table.insert(self.Inventory,shit)
		end
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

	net.Start("hg inventory")
	net.WriteEntity(self)
	net.WriteTable(self.Inventory)
	net.WriteFloat(self.AmtLoot)
	net.Send(ply)
end

if SERVER then return end

net.Receive("hg inventory",function()
	local ent = net.ReadEntity()
	local inv = net.ReadTable()
	local amt = net.ReadFloat()

	if hg.islooting then
		return
	end

	hg.lootent = ent

	surface.PlaySound("homigrad/vgui/item_drop1_common.wav")

	if !IsValid(ScoreBoardPanel) then
		show_scoreboard()
	end
	hg.ScoreBoard = 3
	timer.Simple(0.06,function()
		CreateLootFrame(inv,amt,ent)
	end)
end)

function ENT:Draw()
    self:DrawModel()
end