AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable		            	 = false        
ENT.AdminSpawnable		             = false 

ENT.PrintName		                 =  "Lava Bomb"
ENT.Author			                 =  "Jimmywells"

ENT.Model                            = "models/xqm/rails/gumball_1.mdl"	
ENT.Material 						 = "models/lavabomb/lavabomb_texture"

function ENT:Initialize()	

	if (SERVER) then
		
		self:SetModel(self.Model)
	--	self:SetModelScale(2,0.001)
		self:SetMaterial(self.Material)
		self:SetColor(Color(155,155,155,255))
		
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS )
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(ONOFF_USE)
			
		self.Particle = "gw_lavabomb_explosion_main_air"

		timer.Simple(14,function()
			if !self:IsValid() then return end
			self:Remove()
		end)
			
		timer.Simple(0.1,function()
			if !self:IsValid() then return end	
			ParticleEffectAttach("gw_lavabomb_initial", PATTACH_POINT_FOLLOW, self, 0)
		end)
		

	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	local skypos = gWeather:GetCeilingVector(true)
	local hitpos = tr.HitPos
	
	local ent = ents.Create( ClassName )
	ent:SetPos( Vector(hitpos.x,hitpos.y,skypos) ) 
	ent:Spawn()
	ent:Activate()
	
	local phys = ent:GetPhysicsObject()
	
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(1000)
		phys:EnableDrag( false )
		phys:EnableMotion(true)
		phys:SetVelocity( Vector(0,0,-6000)  )
		phys:AddAngleVelocity( VectorRand() * 100 )
	end
	
	
	return ent
end

function ENT:CreateShards(num,data)

	for i=1,num do
	
		local rock = ents.Create( "prop_physics" )
		rock:SetModel("models/props_junk/rock001a.mdl")
		rock:SetMaterial(self.Material)
		rock:SetColor(Color(155,155,155,255))
		rock:SetPos(data.HitPos+data.HitNormal+Vector(math.random(-i,i),math.random(-i,i),5))
		rock:DrawShadow(false)
		rock:Spawn()
		rock:Activate()
				
		timer.Simple(1,function()
		if !IsValid(rock) then return end
			rock:SetModelScale( 0, 2 )
			SafeRemoveEntityDelayed( rock, 2 )
		end)
				
		local phys=rock:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity( VectorRand()*2000 + Vector(0,0,500) )
			phys:AddAngleVelocity( VectorRand() * 100 )
		end
		
	end

end

function ENT:PhysicsCollide( data, phys )
	if (data.Speed > 500) then 

		self:Explode()	

		if data.HitNormal:Dot(Vector(0,0,-1)) > 0.95 then 
			if data.HitEntity==game.GetWorld() then
				self.Particle = "gw_lavabomb_explosion_main_ground"
		
				local h = data.HitPos + data.HitNormal
				local p = data.HitPos - data.HitNormal
				util.Decal("Scorch", h, p )			
			end
		end
		self:CreateShards(math.random(4,6),data)
		ParticleEffect(self.Particle, data.HitPos, Angle(0,0,0), nil)	

		self:Remove()	
	end

end

function ENT:DrawLight()
	local dlight = DynamicLight( self:EntIndex() )

	if ( dlight ) then
		dlight.pos = self:GetPos()
		dlight.r = 255
		dlight.g = 25
		dlight.b = 25
		dlight.brightness = 6
		dlight.Decay = 200
		dlight.Size = 1028
		dlight.DieTime = CurTime() + 0.5
	end
end

function ENT:Explode()
	local pos = self:GetPos()
	
	gWeather.CreateShockWave(pos, 1300, 500, 343)
	gWeather.SoundWave("impact/explosion_"..math.random(1,3)..".wav",pos,110)
end

function ENT:Think()
	if (CLIENT) then
		self:DrawLight()
	end
	if (SERVER) then
		local i = ( FrameTime() / 0.015 ) * .01
		
		if self:WaterLevel() > 0 then 
		
			local selfpos = self:GetPos()
		
			local waterpos = util.TraceLine( {start = selfpos+Vector(0,0,100),endpos = selfpos,filter = self,mask = MASK_WATER} ).HitPos
		
			gWeather.SoundWave("impact/underwater.wav",waterpos,110)
			ParticleEffect("gw_lavabomb_explosion_main_water",waterpos,Angle(0,0,0), nil) 
			self:Remove() 
		end
	
		self:NextThink(CurTime() + i)
		return true
	end
end

function ENT:OnRemove()
	if CLIENT then
		local dlight = DynamicLight( self:EntIndex() )

		if ( dlight ) then
			dlight.pos = self:GetPos()
			dlight.r = 255
			dlight.g = 25
			dlight.b = 25
			dlight.brightness = 8
			dlight.Decay = 600
			dlight.Size = 1028
			dlight.DieTime = CurTime() + 2
		end
	end
end

function ENT:Draw()
	self:DrawModel()
end


