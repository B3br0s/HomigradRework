AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.launched = false
	self:SetModel(self.Model)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(true)
	self:SetModelScale(self:GetModelScale()*self.ModelScale,0)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(25)
		phys:Wake()
		phys:EnableMotion(true)
	end
end

function ENT:Use( activator )
end

function ENT:Launch(vel)
	self.isjammed = math.random(1,15) == 7
	self.flying = CurTime() + 1.5
	self.launched = true
	self.velo = vel
	if !self.isjammed then
		self:GetPhysicsObject():ApplyForceCenter(vel)
		self:SetVelocity(vel)
	else
		sound.Play("zcitysnd/sound/weapons/m4a1/handling/m4a1_boltrelease.wav",self:GetPos(),125,100,1)
		self.flying = CurTime() + 0.05
		self:GetPhysicsObject():ApplyForceCenter(vel/5000)
		self:SetVelocity(vel/5000)
		self:GetPhysicsObject():SetAngleVelocity(VectorRand(-1000,100))
		self.launched = false
	end
end

function ENT:Think()
	if self.launched then
		if self.flying > CurTime() then
			self:GetPhysicsObject():ApplyForceCenter(self.velo)
			self:GetPhysicsObject():SetVelocity(self.velo)
		end
	end

	self:SetNWBool("Launched",self.launched)
end

function ENT:Detonate()
	if self.deton then
		return
	end
	self:Remove()

	self.deton = true

	sound.Play(istable(self.ExplodeSound) and table.Random(self.ExplodeSound) or self.ExplodeSound,self:GetPos(),150,100,1)

	local plooie = EffectData()
	plooie:SetOrigin(self:GetPos())
	plooie:SetScale(.01)
	plooie:SetRadius(.5)
	plooie:SetNormal(vector_up)
	ParticleEffect("pcf_jack_groundsplode_large",self:GetPos(),vector_up:Angle())
	util.ScreenShake(self:GetPos(), 20, 20, 1, 1000)

	JMod.FragSplosion(self, self:GetPos(), 500, 1500, 1500, IsValid(self:GetOwner()) and self:GetOwner() or game.GetWorld())
	//JMod.FragSplosion(self, self:GetPos(), 800, 2450, 3500, IsValid(self:GetOwner()) and self:GetOwner() or game.GetWorld())
end

function ENT:PhysicsCollide(c,collide)
	if c.Speed > 180 then
		self:Detonate()
	else
		sound.Play(istable(self.CollideSound) and table.Random(self.CollideSound) or self.CollideSound,self:GetPos(),75,100,1)
	end
end