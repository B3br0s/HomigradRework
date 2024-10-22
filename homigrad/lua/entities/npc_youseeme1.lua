
AddCSLuaFile()

ENT.Base = "base_nextbot"

ENT.PhysgunDisabled = true
ENT.AutomaticFrameAdvance = false

ENT.JumpSound = Sound("homigrad/scp/kevin/footsteps/step1.wav")
ENT.JumpHighSound = Sound("homigrad/scp/kevin/footsteps/step_metal1.wav")
ENT.TauntSounds = {
	Sound("homigrad/scp/kevin/kill1.wav"),
	Sound("homigrad/scp/kevin/kill2.wav"),
}
ENT.KillSounds = {
	Sound("homigrad/scp/kevin/killed1.wav"),
	Sound("homigrad/scp/kevin/killed2.wav"),
	Sound("homigrad/scp/kevin/killed3.wav"),
	Sound("homigrad/scp/kevin/killed4.wav"),
}

local IsValid = IsValid

if SERVER then -- SERVER --

local npc_youseeme1_acquire_distance =
	CreateConVar("npc_youseeme1_acquire_distance", 100500, FCVAR_NONE,
	"The maximum distance at which youseeme1 will chase a target.")

local npc_youseeme1_attack_distance =
	CreateConVar("npc_youseeme1_attack_distance", 80, FCVAR_NONE,
	"The reach of youseeme1's attack.")

local npc_youseeme1_attack_interval =
	CreateConVar("npc_youseeme1_attack_interval", 0.1, FCVAR_NONE,
	"The delay between youseeme1's attacks.")

local npc_youseeme1_attack_force =
	CreateConVar("npc_youseeme1_attack_force", 800, FCVAR_NONE,
	"The physical force of youseeme1's attack. Higher values throw things \z
	farther.")

local npc_youseeme1_smash_props =
	CreateConVar("npc_youseeme1_smash_props", 1, FCVAR_NONE,
	"If set to 1, youseeme1 will punch through any props placed in their way.")

local npc_youseeme1_allow_jump =
	CreateConVar("npc_youseeme1_allow_jump", 0, FCVAR_NONE,
	"If set to 1, youseeme1 will be able to jump.")

local npc_youseeme1_chase_repath_interval =
	CreateConVar("npc_youseeme1_chase_repath_interval", 0.1, FCVAR_NONE,
	"The path to and position of youseeme1's target will be redetermined every \z
	X seconds.")

local npc_youseeme1_expensive_scan_interval =
	CreateConVar("npc_youseeme1_expensive_scan_interval", 1, FCVAR_NONE,
	"Slightly expensive operations (distance calculations and entity \z
	searching) will occur every X seconds.")

 -- So we don't spam voice TOO much.
local TAUNT_INTERVAL = 1.2
local PATH_INFRACTION_TIMEOUT = 5

util.AddNetworkString("youseeme1_nag")
util.AddNetworkString("youseeme1_navgen")

 -- Pathfinding is only concerned with static geometry anyway.
local trace = {
	mask = MASK_SOLID_BRUSHONLY
}

local VECTOR_youseeme1_HEIGHT = Vector(0, 0, 96)

local ai_ignoreplayers = GetConVar("ai_ignoreplayers")
local function isValidTarget(ent)
	-- Ignore non-existant entities.
	if not IsValid(ent) then return false end

	-- Ignore dead players (or all players if `ai_ignoreplayers' is 1)
	if ent:IsPlayer() then
		if ai_ignoreplayers:GetBool() then return false end
		return ent:Alive()
	end

	-- Ignore dead NPCs, other youseeme1s, and dummy NPCs.
	local class = ent:GetClass()
	return (ent:IsNPC()
		and ent:Health() > 0
		and class ~= "npc_youseeme1"
		and not class:find("bullseye"))
end

hook.Add("PlayerSpawnedNPC", "youseeme1MissingNavmeshNag", function(ply, ent)
	if not IsValid(ent) then return end
	if ent:GetClass() ~= "npc_youseeme1" then return end
	if navmesh.GetNavAreaCount() > 0 then return end

	-- Try to explain why youseeme1 isn't working.
	net.Start("youseeme1_nag")
	net.Send(ply)
end)

local generateStart = 0
local function navEndGenerate()
	local timeElapsedStr = string.NiceTime(SysTime() - generateStart)

	if not navmesh.IsGenerating() then
		print("npc_youseeme1: Navmesh generation completed in " .. timeElapsedStr)
	else
		print("npc_youseeme1: Navmesh generation aborted after " .. timeElapsedStr)
	end

	-- Turn this back off.
	RunConsoleCommand("developer", "0")
end

local DEFAULT_SEEDCLASSES = {
	-- Source games in general
	"info_player_start",

	-- Garry's Mod (Obsolete)
	"gmod_player_start", "info_spawnpoint",

	-- Half-Life 2: Deathmatch
	"info_player_combine", "info_player_rebel", "info_player_deathmatch",

	-- Counter-Strike (Source & Global Offensive)
	"info_player_counterterrorist", "info_player_terrorist",

	-- Day of Defeat: Source
	"info_player_allies", "info_player_axis",

	-- Team Fortress 2
	"info_player_teamspawn",

	-- Left 4 Dead (1 & 2)
	"info_survivor_position",

	-- Portal 2
	"info_coop_spawn",

	-- Age of Chivalry
	"aoc_spawnpoint",

	-- D.I.P.R.I.P. Warm Up
	"diprip_start_team_red", "diprip_start_team_blue",

	-- Dystopia
	"dys_spawn_point",

	-- Insurgency
	"ins_spawnpoint",

	-- Pirates, Vikings, and Knights II
	"info_player_pirate", "info_player_viking", "info_player_knight",

	-- Obsidian Conflict (and probably some generic CTF)
	"info_player_red", "info_player_blue",

	-- Synergy
	"info_player_coop",

	-- Zombie Master
	"info_player_zombiemaster",

	-- Zombie Panic: Source
	"info_player_human", "info_player_zombie",

	-- Some maps start you in a cage room with a start button, have building
	-- interiors with teleportation doors, or the like.
	-- This is so the navmesh will (hopefully) still generate correctly and
	-- fully in these cases.
	"info_teleport_destination",
}

local function addEntitiesToSet(set, ents)
	for _, ent in pairs(ents) do
		if IsValid(ent) then
			set[ent] = true
		end
	end
end

local NAV_GEN_STEP_SIZE = 25
local function navGenerate()
	local seeds = {}

	-- Add a bunch of the usual classes as walkable seeds.
	for _, class in pairs(DEFAULT_SEEDCLASSES) do
		addEntitiesToSet(seeds, ents.FindByClass(class))
	end

	-- For gamemodes that define their own spawnpoint entities.
	addEntitiesToSet(seeds, GAMEMODE.SpawnPoints or {})

	if next(seeds, nil) == nil then
		print("npc_youseeme1: Couldn't find any places to seed nav_generate")
		return false
	end

	for seed in pairs(seeds) do
		local pos = seed:GetPos()
		pos.x = NAV_GEN_STEP_SIZE * math.Round(pos.x / NAV_GEN_STEP_SIZE)
		pos.y = NAV_GEN_STEP_SIZE * math.Round(pos.y / NAV_GEN_STEP_SIZE)

		-- Start a little above because some mappers stick the
		-- teleport destination right on the ground.
		trace.start = pos + vector_up
		trace.endpos = pos - vector_up * 16384
		local tr = util.TraceLine(trace)

		if not tr.StartSolid and tr.Hit then
			print(string.format("npc_youseeme1: Adding seed %s at %s", seed, pos))
			navmesh.AddWalkableSeed(tr.HitPos, tr.HitNormal)
		else
			print(string.format("npc_youseeme1: Couldn't add seed %s at %s", seed,
				pos))
		end
	end

	-- The least we can do is ensure they don't have to listen to this noise.
	for _, youseeme1 in pairs(ents.FindByClass("npc_youseeme1")) do
		youseeme1:Remove()
	end

	-- This isn't strictly necessary since we just added EVERY spawnpoint as a
	-- walkable seed, but I dunno. What does it hurt?
	navmesh.SetPlayerSpawnName(next(seeds, nil):GetClass())

	navmesh.BeginGeneration()

	if navmesh.IsGenerating() then
		generateStart = SysTime()
		hook.Add("ShutDown", "youseeme1NavGen", navEndGenerate)
	else
		print("npc_youseeme1: nav_generate failed to initialize")
		navmesh.ClearWalkableSeeds()
	end

	return navmesh.IsGenerating()
end

concommand.Add("npc_youseeme1_learn", function(ply, cmd, args)
	if navmesh.IsGenerating() then
		return
	end

	-- Rcon or single-player only.
	local isConsole = (ply:EntIndex() == 0)
	if game.SinglePlayer() then
		print("npc_youseeme1: Beginning nav_generate requested by " .. ply:Name())

		-- Disable expensive computations in single-player. youseeme1 doesn't use
		-- their results, and it consumes a massive amount of time and CPU.
		-- We'd do this on dedicated servers as well, except that sv_cheats
		-- needs to be enabled in order to disable visibility computations.
		RunConsoleCommand("nav_max_view_distance", "1")
		RunConsoleCommand("nav_quicksave", "1")

		-- Enable developer mode so we can see console messages in the corner.
		RunConsoleCommand("developer", "1")
	elseif isConsole then
		print("npc_youseeme1: Beginning nav_generate requested by server console")
	else
		return
	end

	local success = navGenerate()

	-- If it fails, only the person who started it needs to know.
	local recipients = (success and player.GetHumans() or {ply})

	net.Start("youseeme1_navgen")
		net.WriteBool(success)
	net.Send(recipients)
end)

ENT.LastPathRecompute = 0
ENT.LastTargetSearch = 0
ENT.LastJumpScan = 0
ENT.LastCeilingUnstick = 0
ENT.LastAttack = 0
ENT.LastHidingPlaceScan = 0
ENT.LastTaunt = 0

ENT.CurrentTarget = nil
ENT.HidingSpot = nil

function ENT:Initialize()
	-- Spawn effect resets render override. Bug!!!
	self:SetSpawnEffect(false)

	self:SetBloodColor(DONT_BLEED)

	-- Just in case.
	self:SetHealth(1e8)

	--self:DrawShadow(false) -- Why doesn't this work???

	--HACK!!! Disables shadow (for real).
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(Color(255, 255, 255, 1))

	-- Human-sized collision.
	self:SetCollisionBounds(Vector(-13, -13, 0), Vector(13, 13, 72))

	-- We're a little timid on drops... Give the player a chance. :)
	self.loco:SetDeathDropHeight(600)

	-- In Sandbox, players are faster in singleplayer.
	self.loco:SetDesiredSpeed(30000003000000)

	-- Take corners a bit sharp.
	self.loco:SetAcceleration(500)
	self.loco:SetDeceleration(500)

	-- This isn't really important because we reset it all the time anyway.
	self.loco:SetJumpHeight(300)

	-- Rebuild caches.
	self:OnReloaded()
end

function ENT:OnInjured(dmg)
	-- Just in case.
	dmg:SetDamage(0)
end

function ENT:OnReloaded()
end

function ENT:OnRemove()
end

function ENT:GetNearestTarget()
	local maxAcquireDist = npc_youseeme1_acquire_distance:GetInt()
	local maxAcquireDistSqr = 1e8
	local myPos = self:GetPos()
	local acquirableEntities = ents.FindInSphere(myPos, 1e8)
	local distToSqr = myPos.DistToSqr
	local getPos = self.GetPos
	local target = nil
	local getClass = self.GetClass

	--[[for _, ent in pairs(acquirableEntities) do
		-- Ignore invalid targets, of course.
		if not isValidTarget(ent) then continue end
			continue

		-- Find the nearest target to chase.
		local distSqr = distToSqr(getPos(ent), myPos)
		if distSqr < maxAcquireDistSqr then
			target = ent
			maxAcquireDistSqr = distSqr
		end
	end]]

	for _, ent in pairs(acquirableEntities) do
		if ent:IsPlayer() and ent:Alive() then
			target = ent
			self.loco:SetDesiredSpeed(30000003000000)
		end
	end

	return target
end

--TODO: Giant ugly monolith of a function eww eww eww.
function ENT:AttackNearbyTargets(radius)
	local attackForce = npc_youseeme1_attack_force:GetInt()
	local hitSource = self:LocalToWorld(self:OBBCenter())
	local nearEntities = ents.FindInSphere(hitSource, radius)
	local hit = false
	for _, ent in pairs(nearEntities) do
		if isValidTarget(ent) then
			local health = ent:Health()

			if ent:IsPlayer() and IsValid(ent:GetVehicle()) then
				-- Hiding in a vehicle, eh?
				local vehicle = ent:GetVehicle()

				local vehiclePos = vehicle:LocalToWorld(vehicle:OBBCenter())
				local hitDirection = (vehiclePos - hitSource):GetNormal()

				-- Give it a good whack.
				local phys = vehicle:GetPhysicsObject()
				if IsValid(phys) then
					phys:Wake()
					local hitOffset = vehicle:NearestPoint(hitSource)
					phys:ApplyForceOffset(hitDirection
						* (attackForce * phys:GetMass()),
						hitOffset)
				end
				vehicle:TakeDamage(math.max(1e8, ent:Health()), self, self)

				-- Oh, and make a nice SMASH noise.
				vehicle:EmitSound(string.format(
					"physics/metal/metal_sheet_impact_hard%d.wav",
					math.random(6, 8)), 350, 120)
			else
				ent:EmitSound(string.format(
					"physics/body/body_medium_impact_hard%d.wav",
					math.random(1, 6)), 350, 120)
			end

			local hitDirection = (ent:GetPos() - hitSource):GetNormal()
			-- Give the player a good whack. youseeme1 means business.
			-- This is for those with god mode enabled.
			ent:SetVelocity(hitDirection * attackForce + vector_up * 500)

			local dmgInfo = DamageInfo()
			dmgInfo:SetAttacker(self)
			dmgInfo:SetInflictor(self)
			dmgInfo:SetDamage(1e8)
			dmgInfo:SetDamageType(DMG_CRUSH)
			dmgInfo:SetDamagePosition(self:GetPos())
			dmgInfo:SetDamageForce((hitDirection * attackForce
				+ vector_up * 500) * 100)
			ent:TakeDamageInfo(dmgInfo)
			self.loco:SetDesiredSpeed(0)
			timer.Simple(0.8,function ()
				self.loco:SetDesiredSpeed(30000003000000)
				self:SetPos(self:GetPos() + Vector(math.random(700,900),math.random(700,900),0))
			end)

			local newHealth = ent:Health()

			-- Hits only count if we dealt some damage.
			hit = (hit or (newHealth < health))
		elseif ent:GetMoveType() == MOVETYPE_VPHYSICS then
			if not npc_youseeme1_smash_props:GetBool() then continue end
			if ent:IsVehicle() and IsValid(ent:GetDriver()) then continue end

			-- Knock away any props put in our path.
			local entPos = ent:LocalToWorld(ent:OBBCenter())
			local hitDirection = (entPos - hitSource):GetNormal()
			local hitOffset = ent:NearestPoint(hitSource)

			-- Remove anything tying the entity down.
			-- We're crashing through here!
			constraint.RemoveAll(ent)

			-- Get the object's mass.
			local phys = ent:GetPhysicsObject()
			local mass = 0
			local material = "Default"
			if IsValid(phys) then
				mass = phys:GetMass()
				material = phys:GetMaterial()
			end

			-- Don't make a noise if the object is too light.
			-- It's probably a gib.
			if mass >= 5 then
				ent:EmitSound(material .. ".ImpactHard", 350, 120)
			end

			-- Unfreeze all bones, and give the object a good whack.
			for id = 0, ent:GetPhysicsObjectCount() - 1 do
				local phys = ent:GetPhysicsObjectNum(id)
				if IsValid(phys) then
					phys:EnableMotion(true)
					phys:ApplyForceOffset(hitDirection * (attackForce * mass),
						hitOffset)
				end
			end

			-- Deal some solid damage, too.
			ent:TakeDamage(25, self, self)
		end
	end

	return hit
end

local HIGH_JUMP_HEIGHT = 500
--[[function ENT:AttemptJumpAtTarget()
	-- No double-jumping.
	if not self:IsOnGround() then return end

	local targetPos = self.CurrentTarget:GetPos()
	local xyDistSqr = (targetPos - self:GetPos()):Length2DSqr()
	local zDifference = targetPos.z - self:GetPos().z
	local maxAttackDistance = npc_youseeme1_attack_distance:GetInt()
	if xyDistSqr <= math.pow(maxAttackDistance + 2000 * 2000, 2)
		and zDifference >= maxAttackDistance
	then
		--TODO: Set up jump so target lands on parabola.
		local jumpHeight = zDifference + 50
		self.loco:SetJumpHeight(jumpHeight)
		self.loco:Jump()
		self.loco:SetJumpHeight(300)

		self:EmitSound((jumpHeight > HIGH_JUMP_HEIGHT and
			self.JumpHighSound or self.JumpSound), 350, 100)
	end
end]]

local VECTOR_HIGH = Vector(0, 0, 16384)
ENT.LastPathingInfraction = 0
function ENT:RecomputeTargetPath()
    if not IsValid(self.CurrentTarget) then return end

    -- Move towards the player's position
    local targetPos = self.CurrentTarget:GetPos()

    -- Recalculate the path to the player's current position
    self.MovePath:Compute(self, targetPos)
end

-- Prevent unsticking or hiding-related movement (optional)
function ENT:OnStuck()
    -- Don't teleport or move when stuck, just stop movement
    self.loco:ClearStuck()
end

function ENT:BehaveStart()
	self.MovePath = Path("Follow")
	self.MovePath:SetMinLookAheadDistance(500)
	self.MovePath:SetGoalTolerance(10)
end

local ai_disabled = GetConVar("ai_disabled")
function ENT:BehaveUpdate()
    if ai_disabled:GetBool() then
        return
    end

    local currentTime = CurTime()

    -- Check for a valid player target every few seconds
    if currentTime - self.LastTargetSearch > npc_youseeme1_expensive_scan_interval:GetFloat() then
        local target = self:GetNearestTarget()

        -- If we have a new target, reset path recompute timer
        if target ~= self.CurrentTarget then
            self.LastPathRecompute = 0
        end

        self.CurrentTarget = target
        self.LastTargetSearch = currentTime
    end

    -- If we have a valid player target, move towards them
    if IsValid(self.CurrentTarget) then
        -- Recompute path only if we have a valid target
        local repathInterval = npc_youseeme1_chase_repath_interval:GetFloat()
        if currentTime - self.LastPathRecompute > repathInterval then
            self.LastPathRecompute = currentTime
            self:RecomputeTargetPath() -- Recalculate the path to player
        end

        -- Move along the computed path to the player
        self.MovePath:Update(self)
    else
        -- If no target, stop the bot's movement
        self.loco:SetDesiredSpeed(0)
    end

    -- Attack nearby targets if in range
    if IsValid(self.CurrentTarget) then
        if currentTime - self.LastAttack > npc_youseeme1_attack_interval:GetFloat() then
            local attackDistance = npc_youseeme1_attack_distance:GetInt()
            if self:AttackNearbyTargets(attackDistance) then
                -- Play sound on attack if it's time
                if currentTime - self.LastTaunt > TAUNT_INTERVAL then
                    self.LastTaunt = currentTime
                    self:EmitSound(table.Random(self.KillSounds), 350, 100)
                end
                self.LastTargetSearch = 0 -- Force an immediate target search after attacking
            end
            self.LastAttack = currentTime
        end
    end
end
ENT.LastStuck = 0
ENT.StuckTries = 0
function ENT:OnStuck()
	-- Jump forward a bit on the path.
	self.LastStuck = CurTime()

	local newCursor = self.MovePath:GetCursorPosition()
		+ 40 * math.pow(2, self.StuckTries)
	self:SetPos(self.MovePath:GetPositionOnPath(newCursor))
	self.StuckTries = self.StuckTries + 1

	-- Hope that we're not stuck anymore.
	self.loco:ClearStuck()
end

function ENT:UnstickFromCeiling()
	if self:IsOnGround() then return end

	-- NextBots LOVE to get stuck. Stuck in the morning. Stuck in the evening.
	-- Stuck in the ceiling. Stuck on each other. The stuck never ends.
	local myPos = self:GetPos()
	local myHullMin, myHullMax = self:GetCollisionBounds()
	local myHull = myHullMax - myHullMin
	local myHullTop = myPos + vector_up * myHull.z
	trace.start = myPos
	trace.endpos = myHullTop
	trace.filter = self
	local upTrace = util.TraceLine(trace, self)

	if upTrace.Hit and upTrace.HitNormal ~= vector_origin
		and upTrace.Fraction > 0.5
	then
		local unstuckPos = myPos
			+ upTrace.HitNormal * (myHull.z * (1 - upTrace.Fraction))
		self:SetPos(unstuckPos)
	end
end

else -- CLIENT --

local MAT_youseeme1 = Material("homigrad/scp/scared/youseemee1.png")
killicon.Add("npc_youseeme1", "npc_youseeme1/killicon", color_white)
language.Add("npc_youseeme1", "youseeme1 ")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local developer = GetConVar("developer")

local REPEAT_FOREVER = 0

local SPRITE_SIZE = 128
local SPRITEX = 128
local SPRITEY = 128
function ENT:Initialize()
	self:SetRenderBounds(
		Vector(-SPRITE_SIZE / 2, -SPRITE_SIZE / 2, 0),
		Vector(SPRITE_SIZE / 2, SPRITE_SIZE / 2, SPRITE_SIZE),
		Vector(5, 5, 5)
	)
end

local DRAW_OFFSET = SPRITE_SIZE / 2 * vector_up
function ENT:DrawTranslucent()
	if math.random(1,5) != 1 then
		if math.random(1,10) == 4 then
		SPRITEX = math.random(128,160)
		SPRITEY = math.random(128,160)
		end
		render.SetMaterial(MAT_youseeme1)
	else
		render.SetMaterial(Material("null.vmt"))
	end

	-- Get the normal vector from youseeme1 to the player's eyes, and then compute
	-- a corresponding projection onto the xy-plane.
	local pos = self:GetPos() + DRAW_OFFSET
	local normal = EyePos() - pos
	normal:Normalize()
	local xyNormal = Vector(normal.x, normal.y, 0)
	xyNormal:Normalize()

	-- youseeme1 should only look 1/3 of the way up to the player so that they
	-- don't appear to lay flat from above.
	local pitch = math.acos(math.Clamp(normal:Dot(xyNormal), -1, 1)) / 3
	local cos = math.cos(pitch)
	normal = Vector(
		xyNormal.x * cos,
		xyNormal.y * cos,
		math.sin(pitch)
	)

	render.DrawQuadEasy(pos, normal, SPRITEX, SPRITEY,
		color_white, 180)
end

local SECONDS_PER_BRACKET = 300 -- 5 minutes
local color_yellow = Color(255, 255, 80)
local flavourText = ""
local lastBracket = 0
local generateStart = 0

local nagMe = true

end
list.Set("NPC", "npc_youseeme1", {
	Name = "YOU SEE ME 1",
	Class = "npc_youseeme1",
	Category = "Homigrad",
	AdminOnly = true
})
