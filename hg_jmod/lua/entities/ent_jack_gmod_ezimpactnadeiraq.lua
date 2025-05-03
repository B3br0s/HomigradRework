-- Jackarunda 2021
AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Jackarunda, TheOnly8Z"
ENT.Category = "JMod - EZ Explosives"
ENT.PrintName = "COCA COLA ESPUMA"
ENT.Spawnable = true
ENT.Model = "models/foodnhouseholditems/sodacan01.mdl"
local BaseClass = baseclass.Get(ENT.Base)

if SERVER then
	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("opencan.wav", 60, 100)
		timer.Simple(1,function ()
			self:Detonate()
		end)
	end

	function ENT:Arm()
		self:SetState(JMod.EZ_STATE_ARMING)

		timer.Simple(0.2, function()
			if IsValid(self) then
				self:SetState(JMod.EZ_STATE_ARMED)
			end
		end)
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 and data.Speed > 250 then
			self:Detonate()
		else
			self:EmitSound("physics/metal/soda_can_impact_soft"..math.random(1,3)..".wav")
		end
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos = self:GetPos()
		self:EmitSound("explodecan.wav", 5000, 100, 100)
		
		for i = 1,15 do
			local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetAngles(Angle(math.random(360),math.random(360),math.random(360)))
		effectdata:SetScale(25)
	
		--util.Effect("WaterSurfaceExplosion", effectdata)
		util.Effect("watersplash", effectdata)
		end
		
		local radius = 400
		local forceMultiplier = 555500
		
		for _, ent in pairs(ents.FindInSphere(SelfPos, radius)) do
			if IsValid(ent) then
				local entPos = ent:GetPos()
	
				if entPos then
					local dir = (entPos - SelfPos):GetNormalized()
					local phys = ent:GetPhysicsObject()
		
					if phys:IsValid() then
						local force = dir * forceMultiplier
						phys:ApplyForceCenter(force)
					end
		
					if ent:IsPlayer() or ent:IsNPC() then
						ent:SetVelocity(dir * forceMultiplier)
					end
				end
			end
		end
		
		self:Remove()
	end
	
	
elseif CLIENT then
	--language.Add("ent_jack_gmod_ezimpactnade", "EZ Impact Nade")
end
