JMod.Wind = Vector(0, 0, 0)

local function JackaSpawnHook(ply, transition)
	if JMod.Иди_Нахуй then return end
	if transition then return end
	ply.JModSpawnTime = CurTime()
	ply.JModFriends = ply.JModFriends or {}

	if ply.EZarmor and ply.EZarmor.suited then
		ply:SetColor(Color(255, 255, 255))
	end

	ply.EZarmor = {
		items = {},
		speedFrac = nil,
		effects = {},
		mskmat = nil,
		sndlop = nil,
		suited = false,
		bodygroups = nil,
		totalWeight = 0
	}

	ply.JModInv = table.Copy(JMod.DEFAULT_INVENTORY)

	ply.EZhealth = nil
	ply.EZirradiated = nil
	ply.EZoxygen = 100
	ply.EZbleeding = 0
	ply.EZvirus = nil

	timer.Simple(0, function()
		if IsValid(ply) then
			ply.EZoriginalPlayerModel = ply:GetModel()
		end
	end)
	
	-- Greetings, Reclaimer. I am 343 Guilty Spark, monitor of Installation 04
	timer.Simple(1, function()
		if (IsValid(ply)) then
			if not(ply.JMod_DidPlayerReclaimItems) then
				local PlayerTeam = ply:Team()
				-- this will only run once per player per session
				local ID, num = ply:SteamID64(), 0
				for k, v in ents.Iterator() do
					if (v.EZownerID and v.EZownerID == ID) then
						local EntLastKnownTeam = v.EZownerTeam or TEAM_UNASSIGNED
						if (EntLastKnownTeam == PlayerTeam) then
							JMod.SetEZowner(v, ply)
							num = num + 1
						else
							JMod.SetEZowner(v, game.GetWorld(), true)
						end
					end
				end
				ply.JMod_DidPlayerReclaimItems = true
				if (num > 0) then ply:PrintMessage(HUD_PRINTTALK, "JMod: you reclaimed control of " .. num .. " JMod items") end
			end
		end
	end)
end

hook.Add("PlayerSpawn", "JMod_PlayerSpawn", JackaSpawnHook)
hook.Add("PlayerInitialSpawn", "JMod_PlayerInitialSpawn", function(ply, transit) 
	JackaSpawnHook(ply, transit) 
end)

hook.Add("PlayerLoadout", "JMod_PlayerLoadout", function(ply)
	if JMod.Config and JMod.Config.QoL.GiveHandsOnSpawn then
		ply:Give("wep_jack_gmod_hands")
	end
end)

hook.Add("GetPreferredCarryAngles", "JMOD_PREFCARRYANGS", function(ent)
	if ent.JModPreferredCarryAngles then return ent.JModPreferredCarryAngles end
end)

hook.Add("AllowPlayerPickup", "JMOD_PLAYERPICKUP", function(ply, ent)
	if ent.JModNoPickup then return false end
end)

function JMod.ShouldDamageBiologically(ent)
	if not IsValid(ent) then return false end
	if ent.JModDontIrradiate then return not ent.JModDontIrradiate end
	if (ent.Mutation) and (ent.Mutation < 100) then return true end
	if ent:IsPlayer() then return ent:Alive() end

	if (ent:IsNPC() or ent:IsNextBot()) and ent.Health and ent:Health() then
		local Phys = ent:GetPhysicsObject()

		if IsValid(Phys) then
			local Mat = Phys:GetMaterial()

			if Mat then
				if Mat == "metal" then return false end
				if Mat == "default" then return false end
			end
		end

		return ent:Health() > 0
	end

	return false
end

local function ShouldVirusInfect(ent)
	if not IsValid(ent) then return false end
	if ent.EZvirus and ent.EZvirus.Immune then return false end
	if ent:IsPlayer() then return ent:Alive() end
	if ent:IsNPC() then return string.find(ent:GetClass(), "citizen") end

	return false
end

local function VirusHostCanSee(host, ent)
	local Tr = util.TraceLine({
		start = host:GetPos(),
		endpos = ent:GetPos(),
		filter = {host, ent},
		mask = MASK_SHOT
	})

	return not Tr.Hit
end

function JMod.ViralInfect(ply, att)
	if ply.EZvirus then return end
	if ((ply.JModSpawnTime or 0) + 30) > CurTime() then return end
	local Severity, Latency = math.random(50, 500), math.random(10, 100)

	ply.EZvirus = {
		Severity = Severity,
		NextCough = CurTime() + Latency,
		InfectionWarned = false,
		Immune = false,
		Attacker = (IsValid(att) and att) or game.GetWorld(),
		NextFoodImmunityBoost = 0,
		NextAntibioticsImmunityBoost = 0
	}
end

function JMod.GeigerCounterSound(ply, intensity)
	if intensity <= .1 and math.random(1, 2) == 1 then return end
	local Num = math.Clamp(math.Round(math.Rand(0, intensity) * 15), 1, 10)
	ply:EmitSound("snds_jack_gmod/geiger" .. Num .. ".ogg", 55, math.random(95, 105))
	--local Leaf = EffectData()
	--Leaf:SetOrigin(ply:GetPos() + VectorRand(-100, 100) + Vector(0, 0, 64))
	--util.Effect("eff_jack_gmod_ezleaf", Leaf, true, true)
end

function JMod.FalloutIrradiate(self, obj)
	local DmgAmt = self.DmgAmt or math.random(4, 20) * JMod.Config.Particles.NuclearRadiationMult

	if obj:WaterLevel() >= 3 then
		DmgAmt = DmgAmt / 3
	end

	---
	local Dmg, Helf, Att = DamageInfo(), obj:Health(), (IsValid(self.EZowner) and self.EZowner) or self
	Dmg:SetDamageType(DMG_RADIATION)
	Dmg:SetDamage(DmgAmt)
	Dmg:SetInflictor(self)
	Dmg:SetAttacker(Att)
	Dmg:SetDamagePosition(obj:GetPos())

	if obj:IsPlayer() then
		DmgAmt = DmgAmt / 4
		Dmg:SetDamage(DmgAmt)
		obj:TakeDamageInfo(Dmg)
		---
		JMod.GeigerCounterSound(obj, math.Rand(.1, .5))

		timer.Simple(math.Rand(.1, 2), function()
			if IsValid(obj) then
				JMod.GeigerCounterSound(obj, math.Rand(.1, .5))
			end
		end)

		---
		local DmgTaken = Helf - obj:Health()

		if (DmgTaken > 0) and JMod.Config.Explosives.Nuke.RadiationSickness then
			obj.EZirradiated = (obj.EZirradiated or 0) + DmgTaken * 3
		end
	else
		obj:TakeDamageInfo(Dmg)
	end
end

function JMod.TryVirusInfectInRange(host, att, hostFaceProt, hostSkinProt)
	local Range, SelfPos = 300 * JMod.Config.Particles.VirusSpreadMult, host:GetPos()

	if hostFaceProt > 0 or hostSkinProt > 0 then
		Range = Range * (1 - (hostFaceProt + hostSkinProt) / 2)
	end

	if Range <= 0 then return end

	for key, obj in pairs(ents.FindInSphere(SelfPos, Range)) do
		if not (obj == host) and VirusHostCanSee(host, obj) and ShouldVirusInfect(obj) then
			local DistFrac = 1 - (obj:GetPos():Distance(SelfPos) / (Range * 1.2))
			local Chance = DistFrac * .2

			if obj:WaterLevel() >= 3 then
				Chance = Chance / 3
			end

			---
			local VictimFaceProtection, VictimSkinProtection = JMod.GetArmorBiologicalResistance(obj, DMG_RADIATION)

			if VictimFaceProtection > 0 or VictimSkinProtection > 0 then
				Chance = Chance * (1 - (VictimFaceProtection + VictimSkinProtection) / 2)
			end

			if Chance > 0 then
				local AAA = math.Rand(0, 1)

				if AAA < Chance then
					JMod.ViralInfect(obj, att)
				end
			end
		end
	end
end

local function VirusCough(ply)
	if math.random(1, 10) == 2 then
		JMod.TryCough(ply)
	end

	local Dmg = DamageInfo()
	Dmg:SetDamageType(DMG_GENERIC) -- why aint this working to hazmat wearers?
	Dmg:SetAttacker((IsValid(ply.EZvirus.Attacker) and ply.EZvirus.Attacker) or game.GetWorld())
	Dmg:SetInflictor(ply)
	Dmg:SetDamagePosition(ply:GetPos())
	Dmg:SetDamageForce(Vector(0, 0, 0))
	Dmg:SetDamage(1)
	ply:TakeDamageInfo(Dmg)
	--
	local HostFaceProtection, HostSkinProtection = JMod.GetArmorBiologicalResistance(ply, DMG_RADIATION)
	if (HostFaceProtection + HostSkinProtection) >= 2 then return end
	JMod.TryVirusInfectInRange(ply, ply.EZvirus.Attacker, HostFaceProtection, HostSkinProtection)

	if math.random(1, 10) == 10 then
		local Gas = ents.Create("ent_jack_gmod_ezvirusparticle")
		Gas:SetPos(ply:GetPos())
		JMod.SetEZowner(Gas, ply)
		Gas:Spawn()
		Gas:Activate()
		Gas.CurVel = (ply:GetVelocity() + ply:GetForward() * 10)
	end
end

local function VirusHostThink(dude)
	local Time = CurTime()

	if dude.EZvirus and not dude.EZvirus.Immune and dude.EZvirus.NextCough < Time then
		dude.EZvirus.NextCough = Time + math.Rand(.5, 2)

		if not dude.EZvirus.InfectionWarned then
			dude.EZvirus.InfectionWarned = true

			if dude.PrintMessage then
				dude:PrintMessage(HUD_PRINTTALK, "You've contracted the JMod virus. Get medical attention, eat food, and avoid contact with others.")
			end
		end

		VirusCough(dude)
		dude.EZvirus.Severity = math.Clamp(dude.EZvirus.Severity - 1, 0, 9e9)

		if dude.EZvirus.Severity <= 0 then
			dude.EZvirus.Immune = true

			if dude.PrintMessage then
				dude:PrintMessage(HUD_PRINTTALK, "You are now immune to the JMod virus.")
			end
		end
	end
end

local function ImmobilizedThink(dude)
	local Time = CurTime()
	dude.EZImmobilizationTime = 0
	if dude.EZimmobilizers and next(dude.EZimmobilizers) and dude:Alive() then
		for immobilizer, immobilizeTime in pairs(dude.EZimmobilizers) do
			if not(IsValid(immobilizer)) or (immobilizer.GetTrappedPlayer and (immobilizer:GetTrappedPlayer() != dude)) or (immobilizeTime < Time) then
				dude.EZimmobilizers[immobilizer] = nil
			else
				dude.EZImmobilizationTime = math.max(dude.EZImmobilizationTime, immobilizeTime)
			end
		end
	else
		dude.EZimmobilizers = nil
	end
end

--- Sleepy Logic

local function SleepySitThink(dude)
	local Time = CurTime()
	if dude.JMod_IsSleeping then
		if dude:Health() < (dude:GetMaxHealth() * .15) then
			dude.EZhealth = math.max(dude.EZhealth or 0, 1)
		end
	end
end

--- Egg hunt logic

local SpawnFails=0
// copied from Homicide
function JMod.FindHiddenSpawnLocation()
	local DistMul, InitialDist, MinAddDist, SpawnExclusionDist = 10, 200, 300, 1000
	local SpawnPos, Tries, Players, TryDist = nil, 0, player.GetAll(), InitialDist * DistMul
	local NoBlockEnts = {}
	table.Add(NoBlockEnts, Players)
	for key, potential in pairs(Players) do
		if not (potential:Alive()) then table.remove(Players, key) end
	end
	if (#Players < 1) then return nil end
	local SelectedPlaya = table.Random(Players)
	local Origin = SelectedPlaya:GetPos()
	while ((SpawnPos == nil) and (TryDist <= 9000 * DistMul)) do
		while ((SpawnPos == nil) and (Tries < 15)) do
			local RandVec, Below, Vertical = VectorRand() * (math.Rand(10, TryDist) + MinAddDist), false, 0
			if (math.random(1, 3) == 2) then RandVec.z = math.abs(RandVec.z) end
			RandVec.z = RandVec.z / 2
			if (math.random(1, 3) == 2) then RandVec.z = RandVec.z / 2 end
			Vertical = RandVec.z
			local TryPos = Origin + RandVec
			if (util.IsInWorld(TryPos)) then
				local Contents = util.PointContents(TryPos)
				if ((Contents == CONTENTS_EMPTY) or (Contents == CONTENTS_TESTFOGVOLUME)) then
					local Close = false
					for key, plaiyah in pairs(Players) do -- spawn may not be close to a player
						if(TryPos:Distance(plaiyah:GetPos()) < MinAddDist) then Close=true; break end
					end
					if not (Close) then
						local AboveGround = true
						if (Vertical < 0) then -- if the pos is below the player, then the player must be standing on something
							local UpTr = util.QuickTrace(TryPos, Vector(0, 0, -Vertical + 10), Players) -- we therefore should be able to detect that something
							if not (UpTr.Hit) then AboveGround=false end -- if we can't, then the pos is probably below the surface of "solid" groud
						elseif (Vertical > 0) then -- if the pos is above the player, there's gotta be something that we can fall onto
							local DownTr = util.QuickTrace(TryPos, Vector(0, 0, -Vertical * 5), Players) -- try to detect the surface we're gonna fall on
							if not (DownTr.Hit) then AboveGround = false end -- if we can't see anything that far down, we're probably below the ground
						end
						if (AboveGround) then
							local FinalDownTr = util.QuickTrace(TryPos, Vector(0, 0, -20000), NoBlockEnts)
							if (FinalDownTr.Hit) then
								TryPos = FinalDownTr.HitPos + Vector(0, 0, 10)
								local CanSee = false
								for key, ply in pairs(Players) do
									if (ply:Alive()) then
										local ToTrace = util.TraceLine({start = ply:GetShootPos(), endpos = TryPos + Vector(0, 0, 10), filter = NoBlockEnts})
										if not (ToTrace.Hit) then
											CanSee = true
											break
										end
										local ToTrace2 = util.TraceLine({start = ply:GetShootPos(), endpos = TryPos - Vector(0, 0, 10), filter = NoBlockEnts})
										if not (ToTrace2.Hit) then
											CanSee=true
											break
										end
									end
								end
								for key, cayum in pairs(ents.FindByClass("sky_camera")) do -- don't spawn shit in the skybox you stupid fucking game
									local ToTrace = util.TraceLine({start = cayum:GetPos(), endpos = TryPos})
									if not (ToTrace.Hit) then
										CanSee = true
										break
									end
								end
								if not (CanSee) then
									SpawnPos = TryPos
								end
							end
						end
					end
				end
			end
			Tries=Tries + 1
		end
		TryDist = TryDist + 200 * DistMul
		Tries=0
	end
	if(SpawnPos == nil)then
		SpawnFails=SpawnFails + 1
	else
		SpawnFails = 0
	end
	return SpawnPos
end

local NextEasterThink = 0
local function EasterEggThink(dude)
	local Time = CurTime()
	if (Time > NextEasterThink) then
		NextEasterThink = Time + 50
		local Pos = JMod.FindHiddenSpawnLocation()
		if (Pos) then
			local Eg = ents.Create("ent_jack_gmod_ezeasteregg")
			Eg:SetPos(Pos)
			Eg:SetAngles(AngleRand())
			Eg:Spawn()
			Eg:Activate()
		end
	end
end

--- PARACHUTE LOGIC

local function OpenChute(ply)
	ply:EmitSound("JMod_ZipLine_Clip")
	ply:SetNW2Bool("EZparachuting", true)
	local Chute = ents.Create("ent_jack_gmod_ezparachute")
	Chute:SetPos(ply:GetPos())
	Chute:SetNW2Entity("Owner", ply)
	for k, v in pairs(ply.EZarmor.items) do
		if JMod.ArmorTable[v.name].eff and JMod.ArmorTable[v.name].eff.parachute then
			Chute.ParachuteName = ply.EZarmor.items[k].name
			Chute.ChuteColor = ply.EZarmor.items[k].col 
			break
		end
	end
	Chute:Spawn()
	Chute:Activate()
	ply.EZparachute = Chute
end

local function DetachChute(ply) 
	ply:ViewPunch(Angle(5, 0, 0))
	ply:EmitSound("JMod_ZipLine_Clip")
	ply:SetNW2Bool("EZparachuting", false)
end

hook.Add("KeyPress", "JMOD_KEYPRESS", function(ply, key)
	if ply:GetMoveType() != MOVETYPE_WALK then return end
	if ply.IsProne and ply:IsProne() then return end
	if not(JMod.PlyHasArmorEff(ply, "parachute")) then return end

	local IsParaOpen = ply:GetNW2Bool("EZparachuting", false) or IsValid(ply.EZparachute)
	if key == IN_JUMP and not IsParaOpen and not ply:OnGround() then
		if not(util.QuickTrace(ply:GetShootPos(), Vector(0, 0, -350), ply).Hit) then
			if ply:GetVelocity():Length() > 250 then OpenChute(ply) end
		end
	end

	if IsFirstTimePredicted() and key == IN_JUMP and ply:KeyDown(JMod.Config.General.AltFunctionKey) and IsParaOpen then
		DetachChute(ply)
	end
end)

hook.Add("OnPlayerHitGround", "JMOD_HITGROUND", function(ply, water, float, speed)
	--print("Player: " .. tostring(ply) .. " hit ", (water and "water") or "ground", "floater: " .. tostring(float), "Going: " .. tostring(speed))
	if ply:GetNW2Bool("EZparachuting", false) then
		timer.Simple(0.2, function()
			if IsValid(ply) and ply:Alive() then
				ply:ViewPunch(Angle(2, 0, 0))
				if ply:OnGround() then
					DetachChute(ply)
				end
			end
		end)
	end
end)



local NextMainThink, NextNutritionThink, NextArmorThink, NextSlowThink, NextNatrualThink, NextSync = 0, 0, 0, 0, 0, 0
local WindChange = Vector(0, 0, 0)

hook.Add("Think", "JMOD_SERVER_THINK", function()
	--[[
	if(A<CurTime())then
		A=CurTime()+1
		JMod.Sploom(game.GetWorld(),Vector(0,0,0),10)
		JMod.FragSplosion(game.GetWorld(),Vector(0,0,0),3000,80,5000,game.GetWorld())
	end
	--]]
	--[[
	local Pos=ents.FindByClass("sky_camera")[1]:GetPos()
	local AAA=util.TraceLine({
		start=Pos+Vector(0,0,1000),
		endpos=player.GetAll()[1]:GetShootPos()+Vector(0,0,100),
		filter=player.GetAll()[1]
	})
	if(AAA.Hit)then jprint("VALID") else jprint("INVALID") end
	--]]
	--[[
	local ply=player.GetAll()[1]
	local pos=ply:GetPos()
	for k,v in pairs(ents.FindInSphere(pos,600))do
		if(v.GetPhysicsObject)then
			local Phys=v:GetPhysicsObject()
			if(IsValid(Phys))then
				local vec=(v:GetPos()-pos):GetNormalized()
				Phys:ApplyForceCenter(-vec*400)
			end
		end
	end
	--]]
	local Time = CurTime()
	if NextMainThink > Time then return end
	NextMainThink = Time + 1

	if JMod.GetHoliday() == "Easter" then
		EasterEggThink()
	end

	local PlyIterator, Playas, startingindex = player.Iterator()
	---
	for k, playa in PlyIterator, Playas, startingindex do

		if playa:Alive() then
			if playa.EZhealth then
				local Healin = playa.EZhealth

				if Healin > 0 then
					local Amt = 1

					if math.random(1, 3) == 2 then
						Amt = 2
					end

					playa.EZhealth = Healin - Amt
					local Helf, Max = playa:Health(), playa:GetMaxHealth()

					if Helf < Max then
						playa:SetHealth(math.Clamp(Helf + Amt, 0, Max))

						if playa:Health() == Max then
							playa:RemoveAllDecals()
						end
					end
				end
			end

			VirusHostThink(playa)

			ImmobilizedThink(playa)

			SleepySitThink(playa)
		end
	end

	---
	if NextNatrualThink < Time then
		NextNatrualThink = Time + 5
		JMod.Wind = JMod.Wind + WindChange / 10
		SetGlobal2Vector("JMod_Wind", JMod.Wind)

		if JMod.Wind:Length() > 1 then
			JMod.Wind:Normalize()
			WindChange = -WindChange
		end
	
		WindChange = WindChange + Vector(math.Rand(-.5, .5), math.Rand(-.5, .5), 0)
	
		if WindChange:Length() > 1 then
			WindChange:Normalize()
		end
	end
end)

function JMod.EZ_Remote_Trigger(ply)
	if not IsValid(ply) then return end
	if not ply:Alive() then return end
	sound.Play("snd_jack_detonator.ogg", ply:GetShootPos(), 55, math.random(90, 110))

	timer.Simple(.75, function()
		if IsValid(ply) and ply:Alive() then
			for k, v in ents.Iterator() do
				if v.JModEZremoteTriggerFunc and v.EZowner and (v.EZowner == ply) then
					v:JModEZremoteTriggerFunc(ply)
				end
			end
		end
	end)
end

hook.Add("PlayerCanSeePlayersChat", "JMOD_PLAYERSEECHAT", function(txt, teamOnly, listener, talker)
	if not IsValid(talker) then return end
	if talker.EZarmor and talker.EZarmor.effects.teamComms then return JMod.PlayersCanComm(listener, talker) end
end)

hook.Add("PlayerCanHearPlayersVoice", "JMOD_PLAYERHEARVOICE", function(listener, talker)
	if talker.EZarmor and talker.EZarmor.effects.teamComms then return JMod.PlayersCanComm(listener, talker) end
end)

local function ResetBouyancy(ply, ent)
	if ent.EZbuoyancy then
		local phys = ent:GetPhysicsObject()
		timer.Simple(0, function()
			if IsValid(phys) then
				phys:SetBuoyancyRatio(ent.EZbuoyancy)
			end
		end)
	end
end

hook.Add("PhysgunDrop", "JMod_ResetBouyancy", ResetBouyancy)

hook.Add("GravGunDrop", "JMod_ResetBouyancy", ResetBouyancy)

hook.Add("GravGunPunt", "JMod_ResetBouyancy", ResetBouyancy)

hook.Add("OnPlayerPhysicsDrop", "JMod_ResetBouyancy", ResetBouyancy)