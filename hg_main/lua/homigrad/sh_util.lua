--ну подумаешь пару строчек спиздил с зсити,ну что будет?
hg.bloodtypes = {
    "O+",
    "O−",
    "A+",
    "A−",
    "B+",
    "B−",
    "AB+",
    "AB−"
}

hg.bloodtypessupported = {
	["O+"] = {["O+"] = true, ["A+"] = true, ["B+"] = true, ["AB+"] = true},
	["O−"] = {["O+"] = true, ["O−"] = true, ["A+"] = true, ["A−"] = true, ["B+"] = true, ["B−"] = true, ["AB+"] = true, ["AB−"] = true},
	["A+"] = {["A+"] = true, ["AB+"] = true},
	["A−"] = {["A+"] = true, ["A−"] = true, ["AB+"] = true, ["AB−"] = true},
	["B+"] = {["B+"] = true, ["AB+"] = true},
	["B−"] = {["B+"] = true, ["B−"] = true, ["AB+"] = true, ["AB−"] = true},
	["AB+"] = {["AB+"] = true},
	["AB−"] = {["AB+"] = true, ["AB−"] = true}
}

FrameTimeClamped = 1/66
ftlerped = 1/66

local def = 1 / 144

local FrameTime, TickInterval, engine_AbsoluteFrameTime = FrameTime, engine.TickInterval, engine.AbsoluteFrameTime
local Lerp, LerpVector, LerpAngle = Lerp, LerpVector, LerpAngle
local math_min = math.min
local math_Clamp = math.Clamp

local host_timescale = game.GetTimeScale

hook.Add("Think", "Mul lerp", function()
	local ft = FrameTime()
	ftlerped = Lerp(0.5,ftlerped,math_Clamp(ft,0.001,0.1))
end)

if CLIENT then
	local PUNCH_DAMPING = 9
	local PUNCH_SPRING_CONSTANT = 95
	vp_punch_angle = vp_punch_angle or Angle()
	local vp_punch_angle_velocity = Angle()
	vp_punch_angle_last = vp_punch_angle_last or vp_punch_angle

	vp_punch_angle2 = vp_punch_angle2 or Angle()
	local vp_punch_angle_velocity2 = Angle()
	vp_punch_angle_last2 = vp_punch_angle_last2 or vp_punch_angle2

	local PLAYER = FindMetaTable("Player")

	local seteyeangles = PLAYER.SetEyeAngles
	local fuck_you_debil = 0

	hook.Add("Think", "viewpunch_think", function()
		--if LocalPlayer():InVehicle() then return end

		if not vp_punch_angle:IsZero() or not vp_punch_angle_velocity:IsZero() then
			vp_punch_angle = vp_punch_angle + vp_punch_angle_velocity * ftlerped
			local damping = 1 - (PUNCH_DAMPING * ftlerped)
			if damping < 0 then damping = 0 end
			vp_punch_angle_velocity = vp_punch_angle_velocity * damping
			local spring_force_magnitude = PUNCH_SPRING_CONSTANT * ftlerped
			vp_punch_angle_velocity = vp_punch_angle_velocity - vp_punch_angle * spring_force_magnitude
			local x, y, z = vp_punch_angle:Unpack()
			vp_punch_angle = Angle(math.Clamp(x, -89, 89), math.Clamp(y, -179, 179), math.Clamp(z, -89, 89))
		else
			vp_punch_angle = Angle()
			vp_punch_angle_velocity = Angle()
		end

		local ang = LocalPlayer():EyeAngles() + vp_punch_angle - vp_punch_angle_last
		--LocalPlayer():SetEyeAngles(ang)

		--

		if not vp_punch_angle2:IsZero() or not vp_punch_angle_velocity2:IsZero() then
			vp_punch_angle2 = vp_punch_angle2 + vp_punch_angle_velocity2 * ftlerped
			local damping = 1 - (PUNCH_DAMPING * ftlerped)
			if damping < 0 then damping = 0 end
			vp_punch_angle_velocity2 = vp_punch_angle_velocity2 * damping
			local spring_force_magnitude = PUNCH_SPRING_CONSTANT * ftlerped
			vp_punch_angle_velocity2 = vp_punch_angle_velocity2 - vp_punch_angle2 * spring_force_magnitude
			local x, y, z = vp_punch_angle2:Unpack()
			vp_punch_angle2 = Angle(math.Clamp(x, -89, 89), math.Clamp(y, -179, 179), math.Clamp(z, -89, 89))
		else
			vp_punch_angle2 = Angle()
			vp_punch_angle_velocity2 = Angle()
		end

		--if not LocalPlayer():Alive() then vp_punch_angle:Zero() vp_punch_angle_velocity:Zero() vp_punch_angle2:Zero() vp_punch_angle_velocity2:Zero() end

		if vp_punch_angle:IsZero() and vp_punch_angle_velocity:IsZero() and vp_punch_angle2:IsZero() and vp_punch_angle_velocity2:IsZero() then return end
		local ang = LocalPlayer():EyeAngles() + vp_punch_angle - vp_punch_angle_last

		LocalPlayer():SetEyeAngles(ang + vp_punch_angle2 - vp_punch_angle_last2)
		vp_punch_angle_last = vp_punch_angle
		vp_punch_angle_last2 = vp_punch_angle2
	end)

	function SetViewPunchAngles(angle)
		if not angle then
			print("[Local Viewpunch] SetViewPunchAngles called without an angle. wtf?")
			return
		end

		vp_punch_angle = angle
	end

	function SetViewPunchVelocity(angle)
		if not angle then
			print("[Local Viewpunch] SetViewPunchVelocity called without an angle. wtf?")
			return
		end

		vp_punch_angle_velocity = angle * 20
	end

	function Viewpunch(angle)
		if not angle then
			print("[Local Viewpunch] Viewpunch called without an angle. wtf?")
			return
		end

		vp_punch_angle_velocity = vp_punch_angle_velocity + angle * 20
	end

	function Viewpunch2(angle)
		if not angle then
			print("[Local Viewpunch] Viewpunch called without an angle. wtf?")
			return
		end

		vp_punch_angle_velocity2 = vp_punch_angle_velocity2 + angle * 20
	end

	function ViewPunch(angle)
		Viewpunch(angle)
	end

	function ViewPunch2(angle)
		Viewpunch2(angle)
	end

	function GetViewPunchAngles()
		return vp_punch_angle
	end

	function GetViewPunchAngles2()
		return vp_punch_angle2
	end

	function GetViewPunchVelocity()
		return vp_punch_angle_velocity
	end

	local angle_hitground = Angle(0, 0, 0)
	hook.Add("OnPlayerHitGround", "sadsafsafas", function(ply, water, floater, speed)
		--[[if ply == LocalPlayer() then
			angle_hitground.p = speed / 50
			ViewPunch(angle_hitground)
		end--]]
	end)

	local prev_on_ground,current_on_ground,speedPrevious,speed = false,false,0,0
	local angle_hitground = Angle(0,0,0)
	hook.Add("Think", "CP_detectland", function()
		prev_on_ground = current_on_ground
		current_on_ground = LocalPlayer():OnGround()

		speedPrevious = speed
		speed = -LocalPlayer():GetVelocity().z

		if prev_on_ground != current_on_ground and current_on_ground and LocalPlayer():GetMoveType() != MOVETYPE_NOCLIP then
			angle_hitground.p = math.Clamp(speedPrevious / 25, 0, 20)

			ViewPunch(angle_hitground)
		end
	end)
end

function hg.RagdollOwner(ent)
    if not ent:IsRagdoll() then return NULL end

    return ent:GetNWEntity("RagdollOwner")
end

local lend = 2
local vec = Vector(lend,lend,lend)
local traceBuilder = {
	mins = -vec,
	maxs = vec,
	mask = MASK_SOLID,
	collisiongroup = COLLISION_GROUP_DEBRIS
}

local util_TraceHull = util.TraceHull

function hg.hullCheck(startpos,endpos,ply)
	if ply:InVehicle() then return {HitPos = endpos} end
	traceBuilder.start = IsValid(ply.FakeRagdoll) and endpos or startpos
	traceBuilder.endpos = endpos
	traceBuilder.filter = {ply,hg.GetCurrentCharacter(ply)}
	local trace = util_TraceHull(traceBuilder)

	return trace
end

if SERVER then
	concommand.Add("suicide",function(ply,args)
		ply.suiciding = not ply.suiciding
		ply:SetNWBool("suiciding",ply.suiciding)
	end)
end

function hg.eyeTrace(ply, dist, ent, aim_vector, startpos)
	local fakeCam = IsValid(ply.FakeRagdoll)
	local ent = IsValid(ent) and ent or hg.GetCurrentCharacter(ply)
	if ent == NULL then return end
	local bon = ent:LookupBone("ValveBiped.Bip01_Head1")
	if not bon then return end
	if not IsValid(ply) then return end
	if not ply.GetAimVector then return end
	
	local aim_vector = aim_vector or ply:GetAimVector()

	if not bon or not ent:GetBoneMatrix(bon) then
		local tr = {
			start = ply:EyePos(),
			endpos = ply:EyePos() + aim_vector * (dist or 60),
			filter = ply
		}
		return util.TraceLine(tr)
	end

	if (ply.InVehicle and ply:InVehicle() and IsValid(ply:GetVehicle())) then
		local veh = ply:GetVehicle()
		local vehang = veh:GetAngles()
		local tr = {
			start = ply:EyePos() + vehang:Right() * -6 + vehang:Up() * 4,
			endpos = ply:EyePos() + aim_vector * (dist or 60),
			filter = ply
		}
		return util.TraceLine(tr), nil, headm
	end

	local headm = ent:GetBoneMatrix(bon)

	if CLIENT and ply.headmat then headm = ply.headmat end

	--local att_ang = ply:GetAttachment(ply:LookupAttachment("eyes")).Ang
	--ply.lerp_angle = LerpFT(0.1, ply.lerp_angle or Angle(0,0,0), ply:GetNWBool("TauntStopMoving", false) and att_ang or aim_vector:Angle())
	--aim_vector = ply.lerp_angle:Forward()

	local eyeAng = aim_vector:Angle()

	local eyeang2 = aim_vector:Angle()
	eyeang2.p = 0

	local pos = startpos or headm:GetTranslation() + (fakeCam and (headm:GetAngles():Forward() * 2 + headm:GetAngles():Up() * -2 + headm:GetAngles():Right() * 3) or (eyeAng:Up() * 1 + eyeang2:Forward() * 4))
	
	local trace = hg.hullCheck(ply:EyePos(),pos,ply)

	--[[if CLIENT then
		cam.Start3D()
			render.DrawWireframeBox(trace.HitPos,angle_zero,traceBuilder.mins,traceBuilder.maxs,color_white)
		cam.End3D()
	end--]]
	
	local tr = {}
	if !ply:IsPlayer() then return false end
	tr.start = trace.HitPos
	tr.endpos = tr.start + aim_vector * (dist or 60)
	tr.filter = {ply,ent}

	return util.TraceLine(tr), trace, headm
end 

function hg.FrameTimeClamped(ft)
	return math_Clamp(1 - math.exp(-0.5 * (ft or ftlerped) * host_timescale()), 0.000, 0.01)
end

local FrameTimeClamped_ = hg.FrameTimeClamped

local function lerpFrameTime(lerp,frameTime)
	return math_Clamp(1 - lerp ^ (frameTime or FrameTime()), 0, 1)
end

local function lerpFrameTime2(lerp,frameTime)
	return math_Clamp(lerp * FrameTimeClamped_(frameTime) * 150, 0, 1)
end

hg.lerpFrameTime2 = lerpFrameTime2
hg.lerpFrameTime = lerpFrameTime

function LerpFT(lerp, source, set)
	return Lerp(lerpFrameTime2(lerp), source, set)
end

function LerpVectorFT(lerp, source, set)
	return LerpVector(lerpFrameTime2(lerp), source, set)
end

function LerpAngleFT(lerp, source, set)
	return LerpAngle(lerpFrameTime2(lerp), source, set)
end

local max, min = math.max, math.min
function util.halfValue(value, maxvalue, k)
	k = maxvalue * k
	return max(value - k, 0) / k
end

function util.halfValue2(value, maxvalue, k)
	k = maxvalue * k
	return min(value / k, 1)
end

function util.safeDiv(a, b)
	if a == 0 and b == 0 then
		return 0
	else
		return a / b
	end
end

local organism_main = {
    ["blood"] = 5000,
	["bleeding"] = 0,
	["pain"] = 0, --50 - отключка 2 минуты, 100 - отключка 5 минут,150 и больше - a few minutes. - НЕ ПЕРЕБОРЩИТЬ С БОЛЬЮ КОГДА БУДУ ДЕЛАТЬ SV_PAIN!!!!!!
    ["pulse"] = 80,--bpm
	["pulseadd"] = 0,
    ["painlosing"] = 1,
    ["stamina"] = 100,
    ["jaw"] = 1,
	["brokenribs"] = 0,
	["hunger"] = 0,
	["staminamul"] = 1,
    ["removespeed"] = 0,
	['brain'] = 5,
	['lungs'] = 40,
	['lungsL'] = 20,
	['lungsR'] = 20,
    ['liver'] = 10,
	['stomach'] = 30,
	['critical'] = false,
	['otrub'] = false,
	['incapacitated'] = false,
	['handshake'] = 0.5,
	['intestines'] = 30,
	['heart'] = 20,
	['spine'] = 5,
	['lspine'] = 2,
	['kidney'] = 2,
	['owner'] = NULL,
	['spleen'] = 4,
	['CanMove'] = true,
	['adrenaline'] = 0,
	['mannitol'] = 0,
    ['bloodtype'] = "A+",
}

if SERVER then
	function ApplyOrganism(ent,organism)
		if ent:IsPlayer() then
			ent:AddCallback("PhysicsCollide",function(phys,data)
				hook.Run("Player Collide",ent,data.HitEntity,data)
			end)
		end
		if organism then
			ent.owner = (ent:IsRagdoll() and RagdollOwner(ent))
		else
			ent.owner = ent
			ent.bloodtype = table.Random(hg.bloodtypes)
		end
	end
end

if SERVER then
hook.Add("Think", "Homigrad_Player_Think", function(ply)
	tbl = player.GetAll()
	time = CurTime()

	for _, ply in ipairs(tbl) do
		ply.owner = ply --решение проблем,ура
        hook.Run("Player Think", ply, time)
	end
end)
end

if SERVER then
    hook.Add("PlayerDeathSound", "DisableDeathSound", function()
        return true
    end)
	hook.Add("Player Think","Homigrad_Organism",function(ply,time)
	ply:SetNWFloat("pain",ply.pain)
	ply:SetNWFloat("painlosing",ply.painlosing)
	ply:SetNWBool("otrub",ply.otrub)
	end)--ее без неток
else
    hook.Add("DrawDeathNotice", "DisableKillFeed", function()
        return false
    end)
end

hook.Add("PlayerInitialSpawn","Homigrad_KS",function(ply)
	ply.KSILENT = true
end)

gameevent.Listen("player_spawn")
hook.Add("player_spawn","PlayerAdditional",function(data)
    local ply = Player(data.userid)
	if not IsValid(ply) then return end

	if CLIENT then
		if ply == LocalPlayer() then
			if not file.Exists("hgr/appearance.json","DATA") then
				CreateRandomAppearance()
	
				ApplyAppearance(util.JSONToTable(file.Read("hgr/appearance.json","DATA")))
			else
				ApplyAppearance(util.JSONToTable(file.Read("hgr/appearance.json","DATA")))
			end
		end
	end

	if PLYSPAWN_OVERRIDE then return end

	ply.Fake = false 
	ply.FakeRagdoll = NULL
	ply.lerp_rh = 0
	ply.lerp_lh = 0

	ply.larm = 0.2
	ply.rarm = 0.2
	ply.painlosing = 1
	ply.pain = 0
	ply.pulse = 80
	ply.blood = 5000
	ply.bleed = 0
	ply.adrenaline = 0
	ply.removespeed = 0
	ply.stamina = 100
	ply.otrub = false
	ply.CanMove = true

	ply.inventory = {}
	ply.inventory.attachments = {}

	if SERVER then
		ply:SetCanZoom(false)
		ApplyAppearance(ply,ply.Appearance)
		ply:Give("weapon_hands")
		ply:SetNetVar("Inventory",{})
	end
end)

if SERVER then
	hook.Add("PlayerSpawn","Homigrad_Orgia_S_Negrami",function(ply)
	if SERVER then
		ply:SetCanZoom(false)
		ApplyAppearance(ply,ply.Appearance)
		ply:Give("weapon_hands")
		ply:SetNetVar("Inventory",{})
	end
	ply:Give("weapon_hands")
	if PLYSPAWN_OVERRIDE then return end
	ApplyOrganism(ply)
	end)
end

hook.Add("Move","Movement",function(ply,mv)
    if !ply then
        return
    end
	if !ply:Alive() then
		return
	end
	local value = mv:GetMaxSpeed()
	local adr = ply.adrenaline * 50
	if SERVER then
		if ply.CanMove == false then
			value = 0
			ply:SetCrouchedWalkSpeed(0)
		end
	end
	if ply:KeyDown(IN_FORWARD) and not ply:KeyDown(IN_LEFT) and not ply:KeyDown(IN_RIGHT) and not ply:KeyDown(IN_BACK) then
		ply.move = mv:GetForwardSpeed()
	end

	ply:SetDuckSpeed(0.5)
	ply:SetUnDuckSpeed(0.5)
	ply:SetSlowWalkSpeed(30)
	ply:SetCrouchedWalkSpeed(60)
	ply:SetRunSpeed(Lerp(ply:IsSprinting() and 0.05 or 1,ply:GetRunSpeed(),ply:IsSprinting() and 350 + adr - ply.removespeed * 2 or ply:GetWalkSpeed() - ply.removespeed * 2))
	ply:SetJumpPower(200)

	if ply:IsSprinting() and mv:GetForwardSpeed() > 30 then
	ply.stamina = math.Clamp(ply.stamina - 0.03,0,100)
	elseif ply:GetVelocity():Length() < 120 and not ply:IsSprinting() then
	ply.stamina = math.Clamp(ply.stamina + 0.03 + adr / 15,0,100)
	end

	if not ply:Crouching() then
		mv:SetMaxSpeed(value)
		mv:SetMaxClientSpeed(value)
	end
end)

function hg.GetCurrentCharacter(ent)
    return (ent:IsPlayer() and ent or ent:IsRagdoll() and ent.owner.FakeRagdoll == hg.RagdollOwner(ent) and ent)
end