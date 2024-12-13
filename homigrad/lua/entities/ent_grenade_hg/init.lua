AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("cl_init.lua")
include("shared.lua")

if SERVER then

function ENT:SpoonEffect()
		local Spewn = ents.Create("ent_jack_spoon")
		Spewn:SetPos(self:GetPos())
		Spewn:Spawn()
		Spewn:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity() + VectorRand() * 250)
		self:EmitSound("weapons/darsu_eft/grenades/rgd_lever.ogg", 60, math.random(90, 110))
end

function ENT:PhysicsCollide(data, physobj)
    if data.DeltaTime > 0.2 and data.Speed > 30 then
        local sound = table.Random(self.ImpactSound)
        self:EmitSound(sound)
    end
	if self.TypeGren == "Impact" then
		local SelfPos = self:GetPos()
		JMod.Sploom(self:GetOwner(), self:GetPos(), math.random(10, 20))
		sound.Play("weapons/darsu_eft/grenades/gren_expl3_distant.ogg",self:GetPos())
		self:EmitSound("weapons/darsu_eft/grenades/rgo_rgn_explosion_close.ogg", 551, 100)
		local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		plooie:SetScale(.2)
		plooie:SetRadius(1)
		plooie:SetNormal(vector_up)
		ParticleEffect("pcf_jack_groundsplode_small",SelfPos,vector_up:Angle())
		util.ScreenShake(SelfPos, 20, 20, 1, 1000)

		local OnGround = util.QuickTrace(SelfPos + Vector(0, 0, 5), Vector(0, 0, -15), {self}).Hit

		local Spred = Vector(0, 0, 0)
		JMod.FragSplosion(self, SelfPos + Vector(0, 0, 20), 650, 500, 3500, self:GetOwner() or game.GetWorld())

		self:Remove() 
	elseif self.TypeGren == "Molotov" then
        local SelfPos, Owner, SelfVel = self:LocalToWorld(self:OBBCenter()), self:GetOwner() or self, self:GetPhysicsObject():GetVelocity()
		self:EmitSound("weapons/tfa_csgo/molotov/molotov_detonate_1.wav")

		for i = 1, 5 do
			local FireVec = (VectorRand() * .3 + Vector(0, 0, .3)):GetNormalized()
			FireVec.z = FireVec.z / 2
			local Flame = ents.Create("ent_jack_gmod_eznapalm")
			Flame:SetPos(SelfPos + Vector(0, 0, 30))
			Flame:SetAngles(FireVec:Angle())
			--Flame:SetOwner(game.GetWorld())
			--JMod.SetOwner(Flame, game.GetWorld())
			Flame.SpeedMul = 0.2
			Flame.Creator = game.GetWorld()
			Flame.HighVisuals = true
			Flame:Spawn()
			Flame:Activate()
		end
		
		self:Remove()
	elseif self.TypeGren == "Inc" then
        local SelfPos, Owner, SelfVel = self:LocalToWorld(self:OBBCenter()), self:GetOwner() or self, self:GetPhysicsObject():GetVelocity()
		self:EmitSound("arccw_go/incgrenade/inc_grenade_detonate_1.wav")

		for i = 1, 5 do
			local FireVec = (VectorRand() * .3 + Vector(0, 0, .3)):GetNormalized()
			FireVec.z = FireVec.z / 2
			local Flame = ents.Create("ent_jack_gmod_eznapalm")
			Flame:SetPos(SelfPos + Vector(0, 0, 30))
			Flame:SetAngles(FireVec:Angle())
			--Flame:SetOwner(game.GetWorld())
			--JMod.SetOwner(Flame, game.GetWorld())
			Flame.SpeedMul = 0.2
			Flame.Creator = game.GetWorld()
			Flame.HighVisuals = true
			Flame:Spawn()
			Flame:Activate()
		end
		
		self:Remove()
	end
end

function ENT:Initialize()
    self:SetModel("models/props_junk/PopCan01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Think()
    if self.TypeGren != "Smoke" then return end

    if self.Delay < CurTime() or not self.Delay then

        if not self.Fuel then
            self.Fuel = 4
        end

		if not self.scale then
			self.scale = 0
		end

        if self.Fuel <= 0 then return end

        self.Delay = CurTime() + 0.3

        self.Fuel = self.Fuel - .05

		if self.scale < 0.5 then
        self.scale = (4 - self.Fuel)
		end

        local fxdata = EffectData()
        fxdata:SetOrigin(self:GetPos())
        fxdata:SetStart(Vector(15, 0, 0))
        fxdata:SetScale(self.scale)

        util.Effect("eff_jack_hmcd_smoke", fxdata)

        self:EmitSound("snd_jack_hmcd_flare.wav", 65, math.random(95, 105))
    end
end



function ENT:Detonate()
    if self.TypeGren == "Flash" then
		self:EmitSound("weapons/darsu_eft/grenades/grenade_flash_start_outdoor_close.ogg", 551, 100)

        local SelfPos, Time = self:GetPos() + Vector(0, 0, 10), CurTime()

        local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		util.Effect("eff_jack_gmod_flashbang", plooie, true, true)
		util.ScreenShake(SelfPos, 20, 20, .2, 1000)

		for k, v in pairs(ents.FindInSphere(SelfPos, 200)) do
			if v:IsNPC() then
				v.EZNPCincapacitate = Time + math.Rand(3, 5)
			end
		end

		local Pos = self:GetPos()

		for i,ply in pairs(player.GetAll()) do
			local plyPos = ply:GetPos()
			local dis = Pos:Distance(plyPos)

			if dis < 1000 then
				if not util.TraceLine({
					start = Pos,
					endpos = plyPos,
					filter = {self,ply}
				}).Hit then
					player.Event(ply,"flashbang",1 - dis / 1000)
				end
			end
		end
        self:Remove()
    elseif self.TypeGren == "HE" then

    elseif self.TypeGren == "Frag" then
        local SelfPos = self:GetPos()
		JMod.Sploom(self:GetOwner(), self:GetPos(), math.random(10, 20))
		self:EmitSound("weapons/darsu_eft/grenades/gren_expl1_indoor_close.ogg", 551, 100)
		sound.Play("weapons/darsu_eft/grenades/gren_expl3_distant.ogg",self:GetPos())
		local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		plooie:SetScale(.2)
		plooie:SetRadius(1)
		plooie:SetNormal(vector_up)
		ParticleEffect("pcf_jack_groundsplode_small",SelfPos,vector_up:Angle())
		util.ScreenShake(SelfPos, 20, 20, 1, 1000)

		local OnGround = util.QuickTrace(SelfPos + Vector(0, 0, 5), Vector(0, 0, -15), {self}).Hit

		local Spred = Vector(0, 0, 0)
		JMod.FragSplosion(self, SelfPos + Vector(0, 0, 20), 650, 500, 3500, self:GetOwner() or game.GetWorld())

		self:Remove() 
    end
end

function ENT:Arm()
    if self.HasLever and self.RequiresLever and self.TypeGren != "Smoke" and self.TypeGren != "Molotov" then
        self:SpoonEffect()
    end
    timer.Simple(self.Delay,function()
        self:Detonate()
    end)
end

end