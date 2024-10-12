
AddCSLuaFile()
DEFINE_BASECLASS( "base_edit" )

ENT.Spawnable = false     
ENT.AdminSpawnable = false 
ENT.Editable = true

ENT.PrintName = "Wind Editor"
ENT.Author = "Jimmywells"

function ENT:Initialize()

	BaseClass.Initialize( self )
	self:SetMaterial( "gmod/edit_wind" )
	self:SetBodygroup( "1", 1 )

	if SERVER then

		self:AddCallback( "OnAngleChange", function( entity, newangle )
			local dir=self:GetForward()
			self:SetDirection(dir)
		end )

	end

end

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "Speed", { KeyName = "speed", Edit = { type = "Float",	order = 1, min = 0, max = 500 } } )
	self:NetworkVar( "Vector", 0, "Direction", { KeyName = "direction",	Edit = { type = "Vector", order = 2 } } )

	if SERVER then
		self:SetSpeed(0)
		self:SetDirection(Vector(0,0,0))
		
		self:NetworkVarNotify( "Speed", function()
			gWeather:SetWind(self:GetSpeed(),gWeather:GetWindDirection())
		end)
		
		self:NetworkVarNotify( "Direction", function()
			local dir = self:GetDirection()
			local newdir = Vector(math.Clamp(dir.x,-1,1),math.Clamp(dir.y,-1,1),math.Clamp(dir.z,-1,1))
			gWeather:SetWind(nil,newdir)
		end)
	end


end

function ENT:SpawnFunction( ply, tr, ClassName )

	if #ents.FindByClass(ClassName)>0 then return end
	
	if ( !tr.Hit ) then return end
	
	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos+tr.HitNormal )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:Think()

end

function ENT:OnRemove()
	if (SERVER) then
		if !IsValid(gWeather:GetSky()) then gWeather:WindReset() end
	end
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS

end