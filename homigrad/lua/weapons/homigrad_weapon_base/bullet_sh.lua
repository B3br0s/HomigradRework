local SWEP = oop.Get("hg_wep")
if not SWEP then return end

local buckshot = {}
buckshot["12/70 gauge"] = true
buckshot["buckshot"] = true

local HullBullet = 1

local bullet = {}

if CLIENT then
	local last = 0

	net.Receive("weapon shoot point",function()
		if not InitNET then return end
		
		local wep = weapons.Get(net.ReadString())
		local pos = net.ReadVector()
		local dir = net.ReadVector()
		local entIndex = net.ReadInt(14)

		wep:FireBulletOutPerson(pos,dir,entIndex)

		wep:ShootSound(pos,dir,entIndex)

		local ent = Entity(entIndex)
		
		if IsEntity(ent) and ent.AttackShotSetupVars then
			ent:AttackShotSetupVars()
			ent:ShootEffect(pos,dir)
		end//если очень далека смысла нет
	end)

	function SWEP:FireBulletOutPerson(pos,dir)
		local primary = self.Primary

		local cone = primary.Cone

		local ply = self.GetOwner and self:GetOwner()

		bullet.Num 			= (self.NumBullet or 1)
		bullet.Src 			= pos
		bullet.Dir 			= dir
		bullet.Spread 		= Vector()
		bullet.Force		= primary.Force / 40 / (self.NumBullet or 1)
		bullet.Damage		= primary.Damage
		bullet.AmmoType     = primary.Ammo
		bullet.Attacker 	= ply
		bullet.Tracer       = primary.Tracer
		bullet.HullSize 	= HullBullet
		bullet.TracerName   = "Tracer"
		bullet.IgnoreEntity = ply
	
		bullet.Callback = function() return {false,false} end

		local gun = (IsEntity(wep) and wep:GetGun())

		if not gun then
			gun = ClientsideModel("models/hunter/plates/plate.mdl")
			gun:SetNoDraw(true)
			gun:SetPos(pos)

			timer.Simple(0,function() gun:Remove() end)
		end

		gun:FireBullets(bullet)
	end
else
    util.AddNetworkString("weapon shoot point")
end

function SWEP:GetShootMatrix() return self:GetMuzzlePos() end

function SWEP:FireBullet()
	local ply = self:GetOwner()

	local gun,isFake = self:GetGun()
	gun.forceAtt = self
	
	local pos,ang

	pos,ang = self:GetShootMatrix()
	
	local shootDir = ang:Forward()

	local cone = self.Primary.Cone

	local bullet = {}
	bullet.Num 			= (self.NumBullet or 1)
	bullet.Src 			= pos
	bullet.Dir 			= shootDir
	bullet.Spread 		= Vector(cone,cone,0.125)
	bullet.Force		= self.Primary.Force / 40 / (self.NumBullet or 1)
	bullet.Damage		= self.Primary.Damage
	bullet.AmmoType     = self.Primary.Ammo
	bullet.Attacker 	= ply
	bullet.Tracer       = 0
	bullet.HullSize 	= HullBullet
	bullet.TracerName   = self.Tracer or "Tracer"
	bullet.IgnoreEntity = ply

	if SERVER then
		bullet.Callback = function(ply,tr,dmgInfo)
			dmgInfo:ScaleDamage(1 / (self.NumBullet or 1))

			local dis = tr.StartPos:Distance(tr.HitPos)
			local startTab,endTab
			local tab = self.Primary.DamageDisK

			for i,tab in pairs(tab) do
				if not startTab then
					if dis >= tab[1] then startTab = tab end
				else
					endTab = tab
				end
			end

			if not startTab then
				startTab = tab[1]
				endTab = startTab
			end

			endTab = endTab or startTab

			local k = Lerp(math.Clamp((dis - startTab[1]) / (endTab[1] - startTab[1]),0,1),startTab[2],endTab[2])
			dmgInfo:ScaleDamage(k)

			if self.Tracer == "none" then dmgInfo:SetDamageType(DMG_BLAST) end
		end
	end

	self:SetClip1(self:Clip1() - 1)

	if not ply.fake and ply:GetNWBool("Suiciding") then
		if SERVER then
			local head = ply:LookupBone("ValveBiped.Bip01_Head1")
			head = head and ply:GetBoneMatrix(head)

			dmgTab = CreateDamageTab(ply,ply,self,100,DMG_BULLET)
			dmgTab:AddKill("killyourself")
			dmgTab.hitgroup = HITGROUP_HEAD
			dmgTab.isBullet = true
			dmgTab.bone = ply:LookupBone("ValveBiped.Bip01_Head1")
			dmgTab.pos = head and head:GetTranslation() or self:EyePos()
			dmgTab.force = Vector(0,0,1)
			
			timer.Simple(0,function()
				if not IsValid(ply) then return end

				ply:TakeDamageTab(dmgTab,{"killyourself"})
			end)
		end
	else
		if ply:IsNPC() then
			local target = ply:GetEnemy()

			bullet.Damage = bullet.Damage * 0.75
			
			if SERVER then
				if IsValid(target) then
					if target:IsPlayer() and target.fake then ply:SetEnemy(target.fakeEnt.bull) end
	
					target = ply:GetEnemy()

					if target:GetClass() == "npc_bullseye" then
						//bullet.Dir = Vector(1,0,0):Rotate((bullet.Src - (bullet.Src + target:GetPos())):Angle())

						//bullet.Dir:Rotate(Angle(math.Rand(-3,3),math.Rand(-3,3),0))
					end
				end

				bullet.Damage = bullet.Damage / 2

				gun:FireBullets(bullet)

				bullet.Src = ply:GetShootPos()
				bullet.Dir = ply:GetAimVector()

				gun:FireBullets(bullet)
			end
		else
			ply:LagCompensation(true)

			if CLIENT then
				bullet.Tracer = 1
				
				gun:FireBullets(bullet)
			else
				self:FireBullets(bullet)
			end

			ply:LagCompensation(false)
		end

		self:SetLastShootTime()
	end
	
	/*local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetAngles(ang)
	effectdata:SetScale(self:IsScope() and 0.1 or 1)
	effectdata:SetNormal(shootDir)
	util.Effect(self.Efect or "MuzzleEffect",effectdata)*/

	if SERVER then
		net.Start("weapon shoot point",true)
		net.WriteString(self:GetClass())
		net.WriteVector(bullet.Src)
		net.WriteVector(bullet.Dir)
		net.WriteInt(self:EntIndex(),14)
		if ply:IsNPC() then net.Broadcast() else net.SendOmit(ply) end
	else
		self:ShootSound(bullet.Src,bullet.Dir,self:EntIndex())
	end

	self:SetNWInt("Chamber",2)

	if self.ChamberAuto then self:InsertChamber() end

	if CLIENT then
		self:ShootEffect(pos,shootDir)
	end
end

function SWEP:dmgTabPre(target,dmgTab) dmgTab.noBlood = self.Primary.NoBlood end