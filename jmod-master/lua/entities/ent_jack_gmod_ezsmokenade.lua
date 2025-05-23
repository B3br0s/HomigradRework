-- Jackarunda 2021
AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Jackarunda, TheOnly8Z"
ENT.PrintName = "Smoke Nade"
ENT.Category = "JMod - EZ Explosives"
ENT.Spawnable = true
ENT.JModPreferredCarryAngles = Angle(0, 140, 0)
ENT.Model = "models/jmod/explosives/grenades/firenade/incendiary_grenade.mdl"
ENT.Material = "models/mats_jack_nades/smokescreen"
ENT.SpoonScale = 2
ENT.PinBodygroup = {3, 1}
ENT.SpoonBodygroup = {2, 1}
ENT.DetDelay = 2

if SERVER then
	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		self.FuelLeft = 100
		//self:EmitSound("snd_jack_fragsplodeclose.ogg", 70, 150)
		self.BurnSound = CreateSound(self, "snds_jack_gmod/flareburn.wav")
		self.BurnSound:Play()
	end

	function ENT:CustomThink(State, Time)
		if self.Exploded then
			local Foof = EffectData()
			Foof:SetOrigin(self:GetPos())
			Foof:SetNormal(-self:GetUp())
			Foof:SetScale(self.FuelLeft / 100)
			Foof:SetStart(self:GetPhysicsObject():GetVelocity())
			util.Effect("eff_jack_gmod_ezsmokesignal", Foof, true, true)
			//self:EmitSound("snd_jack_sss.wav", 55, 80)
			self.FuelLeft = self.FuelLeft - .5

			if self.FuelLeft <= 0 then
				SafeRemoveEntityDelayed(self, 1)
				self.BurnSound:Stop()
			end
		end
	end

	function ENT:OnRemove()
		if self.BurnSound then
			self.BurnSound:Stop()
		end
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_jack_gmod_ezsmokenade", "Smokescreen Nade")
end
