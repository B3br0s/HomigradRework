if engine.ActiveGamemode() == "homigradcom" then
	if SERVER then
		AddCSLuaFile()
		SWEP.Weight = 5
		SWEP.AutoSwitchTo = false
		SWEP.AutoSwitchFrom = false
	else
		--SWEP.PrintName = "Руки"
		SWEP.PrintName = "Hands"
		SWEP.Slot = 0
		SWEP.SlotPos = 1
		SWEP.DrawAmmo = false
		SWEP.DrawCrosshair = false
		SWEP.ViewModelFOV = 45
		SWEP.BounceWeaponIcon = false
		SWEP.WepSelectIcon = surface.GetTextureID( "vgui/wep_jack_hmcd_hands" )
		local HandTex, ClosedTex = surface.GetTextureID("vgui/hud/gmod_hand"), surface.GetTextureID("vgui/hud/gmod_closedhand")
	
		function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
			surface.SetDrawColor( 255, 255, 255, alpha )
			surface.SetTexture( self.WepSelectIcon )
	
			local fsin = 0
	
	
			y = y + 10
			x = x + 10
			wide = wide - 20
	
			surface.DrawTexturedRect( x + (fsin), y - (fsin),  wide-fsin*2 , ( wide / 2 ) + (fsin) )
	
			self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
		end
	
		function SWEP:DrawHUD()
			local eye = LocalPlayer():GetAttachment(LocalPlayer():LookupAttachment("eyes"))
			if not eye then return end
	
			if not (GetViewEntity() == LocalPlayer()) then return end
			if LocalPlayer():InVehicle() then return end
	
				local ply = self:GetOwner()
				local t = {}
				t.start = eye.Pos
				t.start[3] = t.start[3] - 2
				t.endpos = t.start + ply:GetAngles():Forward() * 60
				t.filter = self:GetOwner()
				local Tr = util.TraceLine(t)
	
			if not self:GetFists() then
				--local Tr = util.QuickTrace(ply:GetAttachment(ply:LookupAttachment("eyes")).Pos, self:GetOwner():GetAimVector() * self.ReachDistance, {self:GetOwner()})
	
				if Tr.Hit then
					if self:CanPickup(Tr.Entity) then
						local Size = math.max(1 - Tr.Fraction,0.25)
						
						self.OffsetX = self.OffsetX or 0
						self.OffsetY = self.OffsetY or 0
						self.SizeX = self.SizeX or 5
						self.SizeY = self.SizeY or 5
						
						local centerX, centerY = Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y
						
						local TargetOffsetX = 0
						local TargetOffsetY = 0
						local TargetSizeX = 5
						local TargetSizeY = 5
						
						if self:GetOwner():KeyDown(IN_ATTACK2) then
							TargetOffsetX = 40
							TargetOffsetY = 2.5
							TargetSizeX = 80
							TargetSizeY = 5
						end
						
						local lerpSpeed = FrameTime() * 5
						self.OffsetX = Lerp(lerpSpeed, self.OffsetX, TargetOffsetX)
						self.OffsetY = Lerp(lerpSpeed, self.OffsetY, TargetOffsetY)
						self.SizeX = Lerp(lerpSpeed, self.SizeX, TargetSizeX)
						self.SizeY = Lerp(lerpSpeed, self.SizeY, TargetSizeY)
						
						draw.RoundedBox(0, centerX - self.OffsetX, centerY - self.OffsetY, self.SizeX, self.SizeY, Color(255, 255, 255, 50))
						draw.RoundedBox(0, centerX - self.OffsetY, centerY - self.OffsetX, self.SizeY, self.SizeX, Color(255, 255, 255, 50))

	
						surface.SetDrawColor(Color(255, 255, 255, 255 * Size))
						--surface.DrawTexturedRect(Tr.HitPos:ToScreen().x - 30, Tr.HitPos:ToScreen().y - 30, 128 * Size, 128 * Size)
						
						local col
						if Tr.Entity:IsPlayer() then
							col = Tr.Entity:GetPlayerColor():ToColor()
						elseif Tr.Entity.GetPlayerColor ~= nil then
							col = Tr.Entity.playerColor:ToColor()
						else
							col = Color(255,255,255,255)
						end
						col.a = 255 * Size * 2
						draw.DrawText( Tr.Entity:IsPlayer() and Tr.Entity:Name() or Tr.Entity:GetNWString("Nickname") or "", "MersRadial", Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y - 30, col, TEXT_ALIGN_CENTER )
	
					else
						local TargetOffsetX = 0
						local TargetOffsetY = 0
						local TargetSizeX = 0
						local TargetSizeY = 0

						local Size = math.max(1 - Tr.Fraction,0.25)
						surface.SetDrawColor(Color(200, 200, 200, 200))
						draw.NoTexture()
						local centerX, centerY = Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y

						local lerpSpeed = FrameTime() * 5

						self.SizeX = Lerp(lerpSpeed, self.SizeX, TargetSizeX)
						self.SizeY = Lerp(lerpSpeed, self.SizeY, TargetSizeY)
						self.OffsetX = Lerp(lerpSpeed, self.OffsetX, TargetOffsetX)
						self.OffsetY = Lerp(lerpSpeed, self.OffsetY, TargetOffsetY)
						
						draw.RoundedBox(0, centerX - self.OffsetX, centerY - self.OffsetY, self.SizeX, self.SizeY, Color(255, 255, 255, 50))
						draw.RoundedBox(0, centerX - self.OffsetY, centerY - self.OffsetX, self.SizeY, self.SizeX, Color(255, 255, 255, 50))
	
						surface.SetDrawColor(Color(255, 255, 255, 255 * Size/0.5))
						draw.NoTexture()
						local col
						if Tr.Entity:IsPlayer() then
							col = Tr.Entity:GetPlayerColor():ToColor()
						elseif Tr.Entity.GetPlayerColor ~= nil then
							col = Tr.Entity.playerColor:ToColor()
						else
							col = Color(255,255,255,255)
						end
						col.a = 255 * Size * 2
						draw.DrawText( Tr.Entity:IsPlayer() and Tr.Entity:Name() or Tr.Entity:GetNWString("Nickname") or "", "MersRadial", Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y + 30, col, TEXT_ALIGN_CENTER )
	
					end
				end
			else
				--local Tr = util.QuickTrace(ply:GetAttachment(ply:LookupAttachment("eyes")).Pos, self:GetOwner():GetAimVector() * self.ReachDistance, {self:GetOwner()})
	
				if Tr.Hit then

					TargetOffsetX = 40
					TargetOffsetY = 2.5
					TargetSizeX = 80
					TargetSizeY = 5

					if self:GetNWBool("Hit") then
						TargetSizeX = 12.5
						TargetSizeY = 12.5
						TargetOffsetX = 25
						TargetOffsetY = 25
					else
						TargetSizeX = 80
						TargetSizeY = 5
						TargetOffsetX = 40
						TargetOffsetY = 2.5
					end
				
					local Size = math.max(1 - Tr.Fraction,0.25)
					surface.SetDrawColor(Color(200, 200, 200, 200))
					draw.NoTexture()
					local centerX, centerY = Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y
	
					surface.SetDrawColor(Color(255, 255, 255, 255 * Size/0.5))
					draw.NoTexture()
					local col
					if Tr.Entity:IsPlayer() then
						col = Tr.Entity:GetPlayerColor():ToColor()
					elseif Tr.Entity.GetPlayerColor ~= nil then
						col = Tr.Entity.playerColor:ToColor()
					else
						col = Color(255,255,255,255)
					end
					col.a = 255 * Size * 2
					local centerX, centerY = Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y

					local lerpSpeed = FrameTime() * 5

					self.SizeX = Lerp(lerpSpeed, self.SizeX, TargetSizeX)
					self.SizeY = Lerp(lerpSpeed, self.SizeY, TargetSizeY)
					self.OffsetX = Lerp(lerpSpeed, self.OffsetX, TargetOffsetX)
					self.OffsetY = Lerp(lerpSpeed, self.OffsetY, TargetOffsetY)
					
					if not self:GetNWBool("Hit") then
					draw.RoundedBox(0, centerX - self.OffsetX, centerY - self.OffsetY, self.SizeX, self.SizeY, Color(255, 255, 255, 50))
					draw.RoundedBox(0, centerX - self.OffsetY, centerY - self.OffsetX, self.SizeY, self.SizeX, Color(255, 255, 255, 50))
					else
					draw.RoundedBox(0, centerX - self.OffsetX, centerY - self.OffsetY, self.SizeX, self.SizeY, Color(189, 6, 6))
					draw.RoundedBox(0, centerX - self.OffsetY, centerY - self.OffsetX, self.SizeY, self.SizeX, Color(189, 6, 6))
					end

					draw.DrawText( Tr.Entity:IsPlayer() and Tr.Entity:Name() or Tr.Entity:GetNWString("Nickname") or "", "MersRadial", Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y + 30, col, TEXT_ALIGN_CENTER )
				end
			end
		end
	end

	function Circle( x, y, radius, seg )
		local cir = {}
	
		table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -360 )
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		end
	
		local a = math.rad( 0 ) -- This is needed for non absolute segment counts
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	
		surface.DrawPoly( cir )
	end
	
	function JMod.WhomILookinAt(ply, cone, dist)
		local CreatureTr, ObjTr, OtherTr = nil, nil, nil
	
		for i = 1, 150 * cone do
			local Vec = (ply:GetAimVector() + VectorRand() * cone):GetNormalized()
	
			local Tr = util.QuickTrace(ply:GetAttachment(ply:LookupAttachment("eyes")).Pos, Vec * dist, {ply})
	
			if Tr.Hit and not Tr.HitSky and Tr.Entity then
				local Ent, Class = Tr.Entity, Tr.Entity:GetClass()
	
				if Ent:IsPlayer() or Ent:IsNPC() then
					CreatureTr = Tr
				elseif (Class == "prop_physics") or (Class == "prop_physics_multiplayer") or (Class == "prop_ragdoll") then
					ObjTr = Tr
				else
					OtherTr = Tr
				end
			end
		end
	
		if CreatureTr then return CreatureTr.Entity, CreatureTr.HitPos, CreatureTr.HitNormal end
		if ObjTr then return ObjTr.Entity, ObjTr.HitPos, ObjTr.HitNormal end
		if OtherTr then return OtherTr.Entity, OtherTr.HitPos, OtherTr.HitNormal end
	
		return nil, nil, nil
	end
	
	SWEP.SwayScale = 3
	SWEP.BobScale = 3
	SWEP.OffsetX = 0
	SWEP.OffsetY = 0
	SWEP.SizeX = 0
	SWEP.SizeY = 0
	SWEP.InstantPickup = true -- FF compat
	SWEP.Author = ""
	SWEP.Contact = ""
	SWEP.Purpose = ""
	SWEP.Instructions = "ЛКМ/ПЕРЕЗАРЯДИТЬ: поднять/опустить кулаки \n В режиме кулаков: ЛКМ - Ударить, ПКМ - Блок \n В режиме рук: ПКМ - Поднять проп, ПЕРЕЗАРЯДКА - Проверить пульс"
	SWEP.Spawnable = true
	SWEP.AdminOnly = false
	SWEP.HoldType = "normal"
	SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
	SWEP.WorldModel = "models/props_junk/cardboard_box004a.mdl"
	SWEP.UseHands = true
	SWEP.AttackSlowDown = .5
	SWEP.Primary.ClipSize = -1
	SWEP.Primary.DefaultClip = -1
	SWEP.Primary.Automatic = true
	SWEP.Primary.Ammo = "none"
	SWEP.Secondary.ClipSize = -1
	SWEP.Secondary.DefaultClip = -1
	SWEP.Secondary.Automatic = false
	SWEP.Secondary.Ammo = "none"
	SWEP.ReachDistance = 100
	SWEP.HomicideSWEP = true
	
	function SWEP:SetupDataTables()
		self:NetworkVar("Float", 0, "NextIdle")
		self:NetworkVar("Bool", 2, "Fists")
		self:NetworkVar("Float", 1, "NextDown")
		self:NetworkVar("Bool", 3, "Blocking")
		self:NetworkVar("Bool", 4, "IsCarrying")
	end
	
	function SWEP:PreDrawViewModel(vm, wep, ply)
		vm:SetMaterial("engine/occlusionproxy") -- Hide that view model with hacky material
	end
	
	function SWEP:Initialize()
		self:SetNextIdle(CurTime() + 5)
		self:SetNextDown(CurTime() + 5)
		self:SetHoldType(self.HoldType)
		self:SetFists(false)
		self:SetBlocking(false)
	end
	
	function SWEP:Deploy()
		local ply = self:GetOwner()
		for i = 0, ply:GetBoneCount() - 1 do
			ply:ManipulateBoneAngles(i, Angle(0, 0, 0))
		end

		if not IsFirstTimePredicted() then
			self:DoBFSAnimation("fists_draw")
			self:GetOwner():GetViewModel():SetPlaybackRate(.1)
	
			return
		end
	
		self:SetNextPrimaryFire(CurTime() + .5)
		self:SetFists(false)
		self:SetNextDown(CurTime())
		self:DoBFSAnimation("fists_draw")
	
		return true
	end
	
	function SWEP:Holster()
		self:OnRemove()
	
		return true
	end
	
	function SWEP:CanPrimaryAttack()
		return true
	end
	
	local pickupWhiteList = {
		["prop_ragdoll"] = true,
		["prop_physics"] = true,
		["prop_physics_multiplayer"] = true
	}
	
	function SWEP:CanPickup(ent)
		if ent:IsNPC() then return false end
		if ent:IsPlayer() then return false end
		if ent:IsWorld() then return false end
		local class = ent:GetClass()
		if pickupWhiteList[class] then return true end
		if CLIENT then return true end
		if IsValid(ent:GetPhysicsObject()) then return true end
	
		return false
	end
	
	function SWEP:SecondaryAttack()
	    if not IsFirstTimePredicted() then return end
	    if self:GetFists() then return end

	    if SERVER then
	        self:SetCarrying()
	        local ply = self:GetOwner()
	        local tr = util.QuickTrace(ply:GetAttachment(ply:LookupAttachment("eyes")).Pos - vector_up * 2, self:GetOwner():GetAimVector() * self.ReachDistance, {self:GetOwner()})

	        if IsValid(tr.Entity) and self:CanPickup(tr.Entity) and not tr.Entity:IsPlayer() then
	            local Dist = (self:GetOwner():GetShootPos() - tr.HitPos):Length()

	            if Dist < self.ReachDistance then
	                sound.Play("Flesh.ImpactSoft", self:GetOwner():GetShootPos(), 65, math.random(90, 110))
	                self:SetCarrying(tr.Entity, tr.PhysicsBone, tr.HitPos, Dist)
	                tr.Entity.Touched = true
	                self:ApplyForce()
	            end
	        elseif IsValid(tr.Entity) and tr.Entity:IsPlayer() then
	            local Dist = (self:GetOwner():GetShootPos() - tr.HitPos):Length()

	            if Dist < self.ReachDistance then
	                sound.Play("Flesh.ImpactSoft", self:GetOwner():GetShootPos(), 65, math.random(90, 110))
	                self:GetOwner():SetVelocity(self:GetOwner():GetAimVector() * 5)
	                tr.Entity:SetVelocity(-self:GetOwner():GetAimVector() * 5)
	                self:SetNextSecondaryFire(CurTime() + .25)
	            end
	        end
	    end
	end
	
	function SWEP:ApplyForce()
		local target = self:GetOwner():GetAimVector() * self.CarryDist + self:GetOwner():GetShootPos()
		local phys = self.CarryEnt:GetPhysicsObjectNum(self.CarryBone)

		if IsValid(phys) then
			local TargetPos = phys:GetPos()
	
			if self.CarryPos then
				TargetPos = self.CarryEnt:LocalToWorld(self.CarryPos)
			end
	
			local vec = target - TargetPos
			local len, mul = vec:Length(), self.CarryEnt:GetPhysicsObject():GetMass()
	
			if len > self.ReachDistance then
				self:SetCarrying()
	
				return
			end
	
			if self.CarryEnt:GetClass() == "prop_ragdoll" then
				mul = mul * 4
				local ply = RagdollOwner(self.CarryEnt)
				if self:GetOwner():KeyPressed( IN_RELOAD ) then
					if not ply then
						self:GetOwner():ChatPrint("У него нет пульса.")
					else
						if ply.heartstop then
							self:GetOwner():ChatPrint("У него нет пульса.")
						else
							self:GetOwner():ChatPrint(ply.nextPulse < 0.9 and "У него сильный пульс." or (ply.nextPulse <= 1.5 and "У него нормальный пульс") or (ply.nextPulse < 2 and "У него слабый пульс.") or (ply.nextPulse >= 2 and "У него нет пульса."))
						end
					end
				end
			end
			vec:Normalize()
	
			if SERVER then
				local ply = RagdollOwner(self.CarryEnt)
				--self:GetOwner():ChatPrint(tostring(ply.CPR).." "..tostring(ply.Blood).." "..tostring(ply.Organs["brain"]).." "..tostring(ply.heartstop))
				if self:GetOwner():KeyDown(IN_ATTACK) then
					if ply and ply.heartstop then
						if self.firstTimePrint then self:GetOwner():ChatPrint("You begin to perform CPR.... (hold the CPR button down until a pulse)") end
						self.firstTimePrint = false
	
						if (self.CPRThink or 0) < CurTime() then
							self.CPRThink = CurTime() + 1
							ply.CPR = math.max(ply.CPR + 50,0)
							
							ply.o2 = math.min(ply.o2 + 0.5,1)
							self.CarryEnt:EmitSound("physics/body/body_medium_impact_soft"..tostring(math.random(7))..".wav")
						end
					else
						if not ply and self.CarryEnt:GetClass() == "prop_ragdoll" then
							--if self.firstTimePrint then self:GetOwner():ChatPrint("Вы начинаете проводить СЛР... (держите ЛКМ зажатым до появления пульса)") end
							if self.firstTimePrint then self:GetOwner():ChatPrint("You begin to perform CPR.... (hold the CPR button down until a pulse)") end
							self.firstTimePrint = false
							if (self.CPRThink or 0) < CurTime() then
								self.CPRThink = CurTime() + 1
								self.CarryEnt:EmitSound("physics/body/body_medium_impact_soft"..tostring(math.random(7))..".wav")
							end
						end
					end
				else
					self.firstTimePrint = true
				end
			end
			local avec, velo = vec * len, phys:GetVelocity() - self:GetOwner():GetVelocity()
			local Force = (avec - velo / 2) * (self.CarryBone > 3 and mul / 2 or mul) / (phys:GetMass() / 3)
	
			local ForceMagnitude = Force:Length()
	
			if ForceMagnitude > 7000 * 1 then
				self:SetCarrying()
	
				return
			end
	
			local CounterDir, CounterAmt = velo:GetNormalized(), velo:Length()
	
			if self.CarryPos then
				phys:ApplyForceOffset(Force, self.CarryEnt:LocalToWorld(self.CarryPos))
			else
				phys:ApplyForceCenter(Force)
			end
	
			phys:ApplyForceCenter(Vector(0, 0, mul))
			phys:AddAngleVelocity(-phys:GetAngleVelocity() / 10)
		end
	end
	
	function SWEP:OnRemove()
		if IsValid(self:GetOwner()) and CLIENT and self:GetOwner():IsPlayer() then
			local vm = self:GetOwner():GetViewModel()
	
			if IsValid(vm) then
				vm:SetMaterial("")
			end
		end
	end
	
	function SWEP:GetCarrying()
		return self.CarryEnt
	end
	
	function SWEP:SetCarrying(ent, bone, pos, dist)
		if IsValid(ent) then
			--self:GetOwner():ChatPrint(pos:Distance(self:GetOwner():GetPos()))
			self:SetNWBool( "Pickup", true )
			self.CarryEnt = ent
			self.CarryBone = bone
			self.CarryDist = dist
	
			if not (ent:GetClass() == "prop_ragdoll") then
				self.CarryPos = ent:WorldToLocal(pos)
			else
				self.CarryPos = nil
			end
		else
			self:SetNWBool( "Pickup", false )
			self.CarryEnt = nil
			self.CarryBone = nil
			self.CarryPos = nil
			self.CarryDist = nil
		end
	end

	function SWEP:ArmsThink()

	end
	
	function SWEP:Think()
		if not self.CarryEnt then
	local ply = self:GetOwner()
	for i = 0, ply:GetBoneCount() - 1 do
		if i ~= ply:LookupBone("ValveBiped.Bip01_Spine") then
			ply:ManipulateBoneAngles(i, Angle(0, 0, 0))
		end
	end
end
		if self.CarryEnt then
			self:ArmsThink()
		end
		if IsValid(self:GetOwner()) and self:GetOwner():KeyDown(IN_ATTACK2) and not self:GetFists() then
			if IsValid(self.CarryEnt) then
				self:ApplyForce()
			end
		elseif self.CarryEnt then
			self:SetCarrying()
		end

		if SERVER then
			local ply = self:GetOwner()
        	local tr = util.QuickTrace(ply:GetAttachment(ply:LookupAttachment("eyes")).Pos - vector_up * 2, self:GetOwner():GetAimVector() * self.ReachDistance, {self:GetOwner()})

        	if tr.Hit then
        	    if tr.HitTexture then
        	        local materialName = tr.HitTexture:lower()
        	        if tostring(materialName) == Material("ground/snow01") or materialName:find("snow") then
        	            if not ply:HasWeapon("weapon_snowball") and ply:KeyDown(IN_USE) and ply:KeyDown(IN_ATTACK2) then
							ply.AllowSpawn = true
        	                ply:Give("weapon_snowball")
							ply.AllowSpawn = false
							ply:SelectWeapon("weapon_snowball")
        	            end
        	        end
        	    end
        	end
		end
	
		if self:GetFists() and self:GetOwner():KeyDown(IN_ATTACK2) then
			self:SetNextPrimaryFire(CurTime() + .5)
			self:SetBlocking(true)
		else
			self:SetBlocking(false)
		end
	
		local HoldType = "fist"
	
		if self:GetFists() then
			HoldType = "fist"
			local Time = CurTime()
	
			if self:GetNextIdle() < Time then
				self:DoBFSAnimation("fists_idle_0" .. math.random(1, 2))
				self:UpdateNextIdle()
			end
	
			if self:GetBlocking() then
				self:SetNextDown(Time + 1)
				HoldType = "camera"
			end
	
			if (self:GetNextDown() < Time) or self:GetOwner():KeyDown(IN_SPEED) then
				self:SetNextDown(Time + 1)
				self:SetFists(false)
				self:SetBlocking(false)
			end
		else
			HoldType = "normal"
			self:DoBFSAnimation("fists_draw")
		end
	
		if IsValid(self.CarryEnt) or self.CarryEnt then
			HoldType = "magic"
		end
	
		if self:GetOwner():KeyDown(IN_SPEED) then
			HoldType = "normal"
		end
	
		if SERVER then
			self:SetHoldType(HoldType)
		end
	end
	
	function SWEP:PrimaryAttack()

		if self:GetOwner().ISEXPLOITERHAHA then
			self:GetOwner():ChatPrint("Это недоступно в пацифистком режиме,иди нахуй)0)0))))))")
			return
		end
	
		local side = "fists_left"
	
		if math.random(1, 2) == 1 then
			side = "fists_right"
		end
	
		if self:GetOwner():KeyDown(IN_ATTACK2) then return end
		
		self:SetNextDown(CurTime() + 7)
	
		if not self:GetFists() then
			self:SetFists(true)
			self:DoBFSAnimation("fists_draw")
			self:SetNextPrimaryFire(CurTime() + .35)
	
			return
		end
	
		if self:GetBlocking() then return end
		if self:GetOwner():KeyDown(IN_SPEED) then return end
	
		if not IsFirstTimePredicted() then
			self:DoBFSAnimation(side)
			self:GetOwner():GetViewModel():SetPlaybackRate(1.25)
	
			return
		end
	
		self:GetOwner():ViewPunch(Angle(0, 0, math.random(-2, 2)))
		self:DoBFSAnimation(side)
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
		self:GetOwner():GetViewModel():SetPlaybackRate(1.25)
		self:UpdateNextIdle()
	
		if SERVER then
			sound.Play("weapons/slam/throw.wav", self:GetPos(), 65, math.random(90, 110))
			self:GetOwner():ViewPunch(Angle(0, 0, math.random(-2, 2)))
	
			timer.Simple(.075, function()
				if IsValid(self) then
					self:AttackFront()
				end
			end)
		end
	
		self:SetNextPrimaryFire(CurTime() + .35)
		self:SetNextSecondaryFire(CurTime() + .35)
	end
	
	function SWEP:AttackFront()
		if CLIENT then return end
		self:GetOwner():LagCompensation(true)
		local Ent, HitPos = JMod.WhomILookinAt(self:GetOwner(), .3, 55)
		local AimVec = self:GetOwner():GetAimVector()
	
		if IsValid(Ent) or (Ent and Ent.IsWorld and Ent:IsWorld()) then
			local SelfForce, Mul = -150, 1
			
			if self:IsEntSoft(Ent) then
				SelfForce = 25
	
				if Ent:IsPlayer() and IsValid(Ent:GetActiveWeapon()) and Ent:GetActiveWeapon().GetBlocking and Ent:GetActiveWeapon():GetBlocking() and not RagdollOwner(Ent) then
					sound.Play("Flesh.ImpactSoft", HitPos, 65, math.random(90, 110))
				else
					sound.Play("Flesh.ImpactHard", HitPos, 65, math.random(90, 110))
				end
			else
				sound.Play("Flesh.ImpactSoft", HitPos, 65, math.random(90, 110))
			end
	
			local DamageAmt = math.random(6, 15)
			local Dam = DamageInfo()
			Dam:SetAttacker(self:GetOwner())
			Dam:SetInflictor(self.Weapon)
			Dam:SetDamage(DamageAmt * Mul)
			Dam:SetDamageForce(AimVec * Mul ^ 2)
			Dam:SetDamageType(DMG_CLUB)
			Dam:SetDamagePosition(HitPos)
			Ent:TakeDamageInfo(Dam)
			self:SetNWBool("Hit",true)
			timer.Simple(0.1,function()
				self:SetNWBool("Hit",false)
			end)
			local Phys = Ent:GetPhysicsObject()
	
			if IsValid(Phys) then
				if Ent:IsPlayer() then
					Ent:SetVelocity(AimVec * SelfForce * 3)
				end
	
				Phys:ApplyForceOffset(AimVec * 10000 * Mul, HitPos)
			end
	
			if Ent:GetClass() == "func_breakable_surf" then
				if math.random(1, 20) == 10 then
					Ent:Fire("break", "", 0)
					self:GetOwner().Bloodlosing = self:GetOwner():GetNWInt("BloodLosing") + 4
					self:GetOwner():SetNWInt("BloodLosing",self:GetOwner().Bloodlosing)
				end
			end
	
			if Ent:GetClass() == "func_breakable" then
				if math.random(7, 11) == 10 then
					Ent:Fire("break", "", 0)
					self:GetOwner().Bloodlosing = self:GetOwner():GetNWInt("BloodLosing") + 4
					self:GetOwner():SetNWInt("BloodLosing",self:GetOwner().Bloodlosing)
				end
			end
	
		end
	
		self:GetOwner():LagCompensation(false)
	end
	
	--self.CarryDist
	--self.CarryPos
	--self.CarryBone
	
	function SWEP:Reload()
		self:SetFists(false)
	end
	if SERVER then
		local angZero = Angle(0,0,0)
	
		hook.Add("Think","held-entities",function()
			heldents = heldents or {}
			for i,tbl in pairs(heldents) do
				if not tbl or not IsValid(tbl[1]) then heldents[i] = nil continue end
				local ent,ply,dist,target,bone,pos = tbl[1],tbl[2],tbl[3],tbl[4],tbl[5],tbl[6]
				local phys = ent:GetPhysicsObjectNum(bone)
				local TargetPos = phys:GetPos()
	
				if pos then
					TargetPos = ent:LocalToWorld(pos)
				end
				
				local vec = target - TargetPos
				local len, mul = vec:Length(), ent:GetPhysicsObject():GetMass()
				vec:Normalize()
				local avec, velo = vec * len, phys:GetVelocity() - ply:GetVelocity()
				local Force = (avec - velo / 10) * (bone > 3 and mul / 10 or mul)
				--слушай а это вообще прикольнее даже чем у кета
				if math.abs((tbl[2]:GetPos() - tbl[1]:GetPos()):Length()) < 80 and tbl[2]:GetGroundEntity() != tbl[1] then
					if tbl[6] then
						phys:ApplyForceOffset(Force, ent:LocalToWorld(pos))
					else
						phys:ApplyForceCenter(Force)
					end
	
					phys:ApplyForceCenter(Vector(0, 0, mul))
					phys:AddAngleVelocity(-phys:GetAngleVelocity() / 10)
				else
					heldents[i] = nil
				end
			end
		end)
	end
	
	function SWEP:DrawWorldModel()
	end
	
	-- no, do nothing
	function SWEP:DoBFSAnimation(anim)
		--local vm = self:GetOwner():GetViewModel()
		--vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
	
	function SWEP:UpdateNextIdle()
		local vm = self:GetOwner():GetViewModel()
		self:SetNextIdle(CurTime() + vm:SequenceDuration())
	end
	
	function SWEP:IsEntSoft(ent)
		return ent:IsNPC() or ent:IsPlayer() or RagdollOwner(ent) or ent:IsRagdoll()
	end
	
	if CLIENT then
		local BlockAmt = 0
	
		function SWEP:GetViewModelPosition(pos, ang)
			if self:GetBlocking() then
				BlockAmt = math.Clamp(BlockAmt + FrameTime() * 1.5, 0, 1)
			else
				BlockAmt = math.Clamp(BlockAmt - FrameTime() * 1.5, 0, 1)
			end
	
			pos = pos - ang:Up() * 15 * BlockAmt
			ang:RotateAroundAxis(ang:Right(), BlockAmt * 60)
	
			return pos, ang
		end
	end end