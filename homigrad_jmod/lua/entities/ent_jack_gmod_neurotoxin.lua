AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Neurotoxin"
ENT.Author = "Человек,ты запостил кринж,тебя ждёт сюрприз,смертельный нейро-токсин"
ENT.NoSitAllowed = true
ENT.Editable = false
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.EZgasParticle = true

if SERVER then
	function ENT:Initialize()
		local Time = CurTime()
		self.LifeTime = math.random(50, 100) * JMod.Config.PoisonGasLingerTime
		self.DieTime = Time + self.LifeTime
		self:SetModel("models/dav0r/hoverball.mdl")
		self:SetMaterial("models/debug/debugwhite")
		self:RebuildPhysics()
		self:DrawShadow(false)
		self.NextDmg = Time + 0.5
	end

	function ENT:ShouldDamage(ent)
		if not IsValid(ent) then return false end
		if ent:IsPlayer() and ent:Alive() then return true end
		if ent:IsNPC() and ent:Health() > 0 then return true end
		if ent:IsRagdoll() and IsValid(RagdollOwner(ent)) and RagdollOwner(ent):Alive() then return true end
		return false
	end

	function ENT:CanSee(ent)
		local Tr = util.TraceLine({
			start = self:GetPos(),
			endpos = ent:GetPos(),
			filter = {self, ent},
			mask = MASK_VISIBLE
		})
		return not Tr.Hit
	end

	function ENT:Think()
		if CLIENT then return end
		local Time, SelfPos = CurTime(), self:GetPos()

		if self.DieTime < Time then
			self:Remove()
			return
		end

		local Force = VectorRand() * 5

		for _, obj in pairs(ents.FindInSphere(SelfPos, 1000)) do
			if obj ~= self and self:CanSee(obj) then
				if obj.EZgasParticle then
					local Vec = (obj:GetPos() - SelfPos):GetNormalized()
					Force = Force - Vec * 20
				elseif self:ShouldDamage(obj) and (math.random(1, 3) == 1) and (self.NextDmg < Time) then
					local Dmg = DamageInfo()
					Dmg:SetDamageType(DMG_NERVEGAS)
					Dmg:SetDamage(math.random(15, 36) * JMod.Config.PoisonGasDamage)
					
					local Attacker = IsValid(self:GetOwner()) and self:GetOwner() or game.GetWorld()
					Dmg:SetInflictor(self)
					Dmg:SetAttacker(Attacker)
					Dmg:SetDamagePosition(obj:GetPos())
					
					obj:TakeDamageInfo(Dmg)

					if obj:IsPlayer() then
						JMod.TryCough(obj)
						obj.pain = (obj.pain or 0) + 5
						if obj.informedaboutneuro == false then
							obj.informedaboutneuro = true
							obj:ChatPrint("Ты вдохнул нейротоксин.")
						end
					elseif obj:IsRagdoll() and IsValid(RagdollOwner(obj)) then
						local owner = RagdollOwner(obj)
						if not owner.Otrub then
							JMod.TryCough(owner)
						end
						owner.pain = (owner.pain or 0) + 15
						if owner.informedaboutneuro == false then
							owner.informedaboutneuro = true
							owner:ChatPrint("Ты вдохнул нейротоксин.")
						end
					end

					self.NextDmg = Time + 0.5
				end
			end
		end

		local Phys = self:GetPhysicsObject()
		Phys:SetVelocity(Phys:GetVelocity() * 0.6)
		Phys:ApplyForceCenter(Force + Vector(0, 0, -100))

		self:NextThink(Time + math.Rand(2, 4))
		return true
	end

	function ENT:RebuildPhysics()
		local size = 1
		self:PhysicsInitSphere(size, "gmod_silent")
		self:SetCollisionBounds(Vector(-.1, -.1, -.1), Vector(.1, .1, .1))
		self:PhysWake()
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		local Phys = self:GetPhysicsObject()
		Phys:SetMass(1)
		Phys:EnableGravity(false)
		Phys:SetMaterial("gmod_silent")
	end

	function ENT:PhysicsCollide(data, physobj)
		physobj:ApplyForceCenter(data.HitNormal * 150)
	end

	function ENT:OnTakeDamage(dmginfo)
	end

	function ENT:Use(activator, caller)
	end

	function ENT:GravGunPickupAllowed(ply)
		return false
	end
elseif CLIENT then
	local Mat = Material("particle/smokestack")

	function ENT:Initialize()
		self.Col = Color(153, 129, 69)
		self.Visible = true
		self.Show = true
		self.siz = 1
		self.NextVisCheck = CurTime() + 6
		self.DebugShow = LocalPlayer().EZshowGasParticles

		if self.DebugShow then
			self:SetModelScale(2)
		end
	end

	function ENT:DrawTranslucent()
		if self.DebugShow then
			self:DrawModel()
		end

		if self:GetDTBool(0) then return end

		local Time = CurTime()

		if self.NextVisCheck < Time then
			self.NextVisCheck = Time + 1
			self.Show = self.Visible and 1 / FrameTime() > 50
		end

		if self.Show then
			local SelfPos = self:GetPos()
			render.SetMaterial(Mat)
			render.DrawSprite(SelfPos, self.siz, self.siz, Color(self.Col.r, self.Col.g, self.Col.b, 120))
			self.siz = math.Clamp(self.siz + FrameTime() * 200, 100, 500)
		end
	end
end
