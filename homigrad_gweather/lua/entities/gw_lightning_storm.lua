AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Lightning Storm"
ENT.Author = "Jimmywells"

function ENT:Initialize()			
	self.NextLightningTime=CurTime()+math.random(2,4)

	if (SERVER) then

		self:SetModel("models/props_lab/huladoll.mdl")
		self:PhysicsInit( SOLID_NONE  )
		self:SetSolid( SOLID_NONE  )
		self:SetMoveType( MOVETYPE_NONE  )
		self:SetUseType( ONOFF_USE )
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		
		self:SetNoDraw(true)
		
	end

end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end
	
	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos+tr.HitNormal )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:LightningSpawn()
	if self.NextLightningTime>CurTime() then return end
	
	if gWeather.PChance(50) then
		if CLIENT then
			if IsValid(gWeather:GetSky()) then gWeather:SkyFlash() end
		elseif SERVER then
			timer.Simple(math.random(1,3),function() 
				if !IsValid(self) then return end 
				self:EmitSound( "weather/thunder/thunder_distant0"..tostring(math.random(1,3))..".wav", 150, 100, math.random() ) 
			end)
		end
		self.NextLightningTime=CurTime()+math.random(5,8) 
	return end 

	if SERVER then

		local startpos = gWeather:GetRandomBounds(true)

		local bolt = ents.Create("gw_lightningbolt")
		bolt:SetPos(startpos)
		bolt:Spawn()
		bolt:Activate()

	end
	
	self.NextLightningTime=CurTime()+math.random(5,10)
end

function ENT:Think()
	self:LightningSpawn()

	if (SERVER) then
		self:NextThink(CurTime()+1)
		return true
	end
	
end

function ENT:OnRemove()
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







