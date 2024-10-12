AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Hailstone"
ENT.Author = "Jimmywells"

ENT.Scale =.5
ENT.ShouldExplode = true

function ENT:Initialize()			

	if (CLIENT) then
		
	end

	if (SERVER) then
	
		self:SetModel("models/hunter/misc/sphere025x025.mdl")
		self:SetMaterial("models/hail/hail_texture")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS  )
		self:SetUseType( ONOFF_USE )
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		--self:SetModelScale( self.Scale, 0 )
		self:ManipulateBoneScale( 0, Vector(self.Scale,self.Scale,self.Scale) )
		--self:SetGravity(2)

		self:DrawShadow(false)
		
		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:SetMass(math.random(2,3)*self.Scale)
			phys:EnableDrag(false)
			phys:Wake()
		end
		
	end
end

function ENT:CreateShards(num,data)

	for i=1,num do
	
		local hail = ents.Create( "prop_physics" )
		hail:SetModel("models/props_junk/rock001a.mdl")
		hail:SetMaterial("models/hail/hail_texture")
		hail:SetPos(data.HitPos+data.HitNormal+Vector(math.random(-i,i),math.random(-i,i),5*self.Scale))
		hail:SetModelScale( math.min(self.Scale/2,0.5), 0 )
		hail:DrawShadow(false)
		hail:Spawn()
		hail:Activate()
				
		timer.Simple(1,function()
		if !IsValid(hail) then return end
			hail:SetModelScale( 0, 2 )
			SafeRemoveEntityDelayed( hail, 2 )
		end)
				
		local phys=hail:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self:GetVelocity()/4)
			phys:AddAngleVelocity( VectorRand() * 25 * self.Scale )
		end
		
	end

end

function ENT:PhysicsCollide( data, phys )
	if ( data.Speed > 250 ) then 

		if self.Scale>=1 then

			if data.HitEntity:GetClass()=="prop_physics" then
				local ent = data.HitEntity
				if ent:GetPhysicsObject():GetMass() < (self:GetPhysicsObject():GetMass()*100) then
					if IsValid(ent) then
						ent:GetPhysicsObject():EnableMotion( true )
						ent:TakeDamage( data.Speed/10, self, self )
						if constraint.FindConstraint( ent, "Weld" ) and math.random( 1, 6-math.min(self.Scale,3) ) then constraint.RemoveConstraints( ent, "Weld" ) end  
					end
				end
			end
			
		end
		
		self:EmitSound("weather/hail/hail_impact.mp3",50+(10*self.Scale))
		self:CreateShards(math.random(2,3),data)
		
		local effectdata = EffectData()
		effectdata:SetOrigin( data.HitPos )
		effectdata:SetAngles( data.HitNormal:Angle() )
		effectdata:SetScale( self.Scale )
		util.Effect( "gw_hail_impact", effectdata, nil, true )
		
		self:Remove()
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

function ENT:Think()
	if (CLIENT) then
	
	end

	if (SERVER) then
	--	self:GetPhysicsObject():SetVelocityInstantaneous( Vector(0,0,-4000) )

		self:NextThink(CurTime()+10)
		return true
	end
end


function ENT:OnRemove()

	if (CLIENT) then
	
	
	end

	if (SERVER) then	
	

	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end

