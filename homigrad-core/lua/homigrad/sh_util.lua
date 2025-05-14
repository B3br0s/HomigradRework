--ну подумаешь пару строчек спиздил с зсити,ну что будет?

local ENTITY = FindMetaTable("Entity")

function ENTITY:SetBoneMatrix2(boneID,matrix,dontset)
	local localpos = self:GetManipulateBonePosition(boneID)
	local localang = self:GetManipulateBoneAngles(boneID)
	local newmat = Matrix()
	newmat:SetTranslation(localpos)
	newmat:SetAngles(localang)
	local inv = newmat:GetInverse()
	local oldMat = self:GetBoneMatrix(boneID) * inv
	local newMat = oldMat:GetInverse() * matrix
	local lpos,lang = newMat:GetTranslation(),newMat:GetAngles()

	if not dontset then
		self:ManipulateBonePosition(boneID,lpos,false)
		self:ManipulateBoneAngles(boneID,lang,false)
	end

	return lpos,lang
end

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
	local PUNCH_DAMPING = 20
	local PUNCH_SPRING_CONSTANT = 300
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

	function Viewpunch(angle,speed)
		if not angle then
			print("[Local Viewpunch] Viewpunch called without an angle. wtf?")
			return
		end

		vp_punch_angle_velocity = vp_punch_angle_velocity + angle * 20

		PUNCH_DAMPING = speed or 20
	end

	function Viewpunch2(angle,speed)
		if not angle then
			print("[Local Viewpunch] Viewpunch called without an angle. wtf?")
			return
		end

		vp_punch_angle_velocity2 = vp_punch_angle_velocity2 + angle * 20
	end

	function ViewPunch(angle,speed)
		Viewpunch(angle,speed)
	end

	function ViewPunch2(angle,speed)
		Viewpunch2(angle,speed)
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
			angle_hitground.p = math.Clamp(speedPrevious / 15, 0, 20)

			ViewPunch(angle_hitground / 2)
			Recoil = 2
		end
	end)

	hook.Add("Player Think","Homigrad_Run",function(ply)
		if ply:GetVelocity():Length() > 100 and ply:IsSprinting() and ply.sidemove then
			hg.bone.Set(ply,"spine4",Vector(0,0,0),Angle(0,0,0),1,0.1)
			hg.bone.Set(ply,"spine2",Vector(0,0,0),Angle(ply.sidemove / 1600,ply.move / 600,0),1,0.1)
			hg.bone.Set(ply,"spine1",Vector(0,0,0),Angle(ply.sidemove / 2600,ply.move / 1200,0),1,0.1)
		else
			hg.bone.Set(ply,"spine4",Vector(0,0,0),Angle(0,0,0),1,0.05)
			hg.bone.Set(ply,"spine2",Vector(0,0,0),Angle(0,0,0),1,0.05)
			hg.bone.Set(ply,"spine1",Vector(0,0,0),Angle(0,0,0),1,0.05)
		end
	end)
end

function hg.RagdollOwner(ent)
    if not ent:IsRagdoll() then return NULL end

    return ent:GetNWEntity("RagdollOwner",NULL)
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

function hg.UseCrate(ply,ent)
	local self = ent
	if !ply:IsPlayer() then
		return
	end

	if hg.eyeTrace(ply,100).Entity == self then
		net.Start("hg inventory")
		net.WriteEntity(self)
		net.WriteTable(self.Inventory)
		net.WriteFloat(self.AmtLoot)
		if self.JModEntInv then
			net.WriteEntity(self.JModEntInv)
		end
		net.Send(ply)
	end
end

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

hook.Add("Think", "Homigrad_Player_Think", function(ply)
	tbl = player.GetAll()
	time = CurTime()

	for _, ply in ipairs(tbl) do
        hook.Run("Player Think", ply, time)
	end
end)

if SERVER then
    hook.Add("PlayerDeathSound", "DisableDeathSound", function()
        return true
    end)
	hook.Add("Player Think","Homigrad_Organism",function(ply,time)
	ply:GetViewModel():SetPlaybackRate(0.9) --а зачем? хз
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

if CLIENT then
	hook.Add("InitPostEntity","123",function()
		if not file.Exists("hgr/appearance.json","DATA") then
			CreateRandomAppearance()

			ApplyAppearance(util.JSONToTable(file.Read("hgr/appearance.json","DATA")))
		else
			ApplyAppearance(util.JSONToTable(file.Read("hgr/appearance.json","DATA")))
		end
	end)
end

gameevent.Listen("player_spawn")
local hull = 10 
local HullMin = -Vector(hull,hull,0)
local Hull = Vector(hull,hull,72)
local HullDuck = Vector(hull,hull,36)
hook.Add("player_spawn","PlayerAdditional",function(data)
    local ply = Player(data.userid)
	if not IsValid(ply) then return end

	if ply.PLYSPAWN_OVERRIDE then return end

	if SERVER then
		timer.Simple(0,function()
			ApplyAppearance(ply,ply.Appearance)
		end)
	end

	ply.KillReason = " "
	ply.LastHitBone = " "
	ply.Fake = false 
	ply:SetDSP(0)
	ply.FakeRagdoll = NULL
	ply.otrub = false
	ply.pain = 0

	for bone = 0, ply:GetBoneCount() - 1 do
		ply:ManipulateBoneAngles(bone,Angle(0,0,0))
	end

	ply:SetHull(ply:GetNWVector("HullMin",HullMin) or HullMin,ply:GetNWVector("Hull",Hull) or Hull)
	ply:SetHullDuck(ply:GetNWVector("HullMin",HullMin) or HullMin,ply:GetNWVector("HullDuck",HullDuck) or HullDuck)
	ply:SetViewOffset(Vector(0,0,64))
	ply:SetViewOffsetDucked(Vector(0,0,38))
    ply:SetMoveType(MOVETYPE_WALK)
    ply:DrawShadow(true)
    ply:SetRenderMode(RENDERMODE_NORMAL)

    if SERVER then
        ply:SetSolidFlags(bit.band(ply:GetSolidFlags(),bit.bnot(FSOLID_NOT_SOLID)))
        ply:SetNWEntity("ragdollWeapon", NULL)
        ply:SetNWEntity("ActiveWeapon", NULL)
    end

    timer.Simple(0,function()
        local ang = ply:EyeAngles()
        if ang[3] == 180 then
            ang[2] = ang[2] + 180
        end
        ang[3] = 0
        ply:SetEyeAngles(ang)
    end)

    if SERVER then
        hg.send(nil,ply,true)
    end
end)

if SERVER then
	hook.Add("PlayerSpawn","Homigrad_Orgia_S_Negrami",function(ply)
	ply:Give("weapon_hands")
	if ply.PLYSPAWN_OVERRIDE then return end
	ApplyOrganism(ply)
	end)
end

if CLIENT then
	hg_camshake_amount = CreateClientConVar("hg_camshake_amount","1",true,false,nil,0,1.5)
    hg_camshake_enabled = CreateClientConVar("hg_camshake_enabled","1",true,false,nil,0,1)

	function hg.DrawWeaponSelection(self, x, y, wide, tall, alpha )

		/*wide = wide * 1.1
		tall = tall * 1.1

		x = x / 1.025
		y = y / 1.025*/

		/*x = wide/2
		y = tall/2*/

		//self.PrintName = hg.GetPhrase(self:GetClass())
		
		local WM = self.WorldModel
	
		if not IsValid(DrawingModel) then
			DrawingModel = ClientsideModel(self.WorldModel,RENDERGROUP_OPAQUE)
			DrawingModel:SetNoDraw(true)
		else
			DrawingModel:SetModel(self.WorldModel)
			if self.Bodygroups then
				for _, bodygroup in ipairs(self.Bodygroups) do
					DrawingModel:SetBodygroup(_,bodygroup)
				end
			else
				DrawingModel:SetBodygroup(0,0)
				DrawingModel:SetBodygroup(1,0)
				DrawingModel:SetBodygroup(2,0)
				DrawingModel:SetBodygroup(3,0)
			end
			local vec = Vector(18.7,150,-3)
			local ang = Vector(0,-90,0):Angle()
	
			cam.Start3D( vec, ang, 20, x, y+(IsValid(self) and 35 or 0), wide, tall, 5, 4096 )
				cam.IgnoreZ( true )
				render.SuppressEngineLighting( true )
	
				if IsValid(self) then
				render.SetLightingOrigin( self:GetPos() )
				end
				render.ResetModelLighting( 50/255, 50/255, 50/255 )
				render.SetColorModulation( 1, 1, 1 )
				render.SetBlend( 255 )
	
				render.SetModelLighting( 4, 1, 1, 1 )
	
				DrawingModel:SetRenderAngles( self.IconAng )
				DrawingModel:SetRenderOrigin( self.IconPos)
				DrawingModel:DrawModel()
				DrawingModel:SetRenderAngles()
	
				render.SetColorModulation( 1, 1, 1 )
				render.SetBlend( 1 )
				render.SuppressEngineLighting( false )
				cam.IgnoreZ( false )
			cam.End3D()
		end
	
		surface.SetDrawColor( 255, 255, 255, alpha )
		surface.SetMaterial( (self.WepSelectIcon2 or Material("null")) )
	
		surface.DrawTexturedRect( x, y + 10,  256 * ScrW()/1920 , 128 * ScrH()/1080 )
	
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	
	end
end

function hg.ShouldTPIK(ply,wpn)
	if wpn.SupportTPIK then
		return true
	end
	return false
end

hook.Add("Move", "Homigrad_Move", function(ply, mv)
    if not ply:Alive() then return end

	if GetGlobalBool("DefaultMove",false) then
		ply:SetDuckSpeed(0.5)
    	ply:SetUnDuckSpeed(0.5)
    	ply:SetSlowWalkSpeed(30)
    	ply:SetCrouchedWalkSpeed(1)
    	ply:SetWalkSpeed(200)
    	ply:SetRunSpeed(400)
    	ply:SetJumpPower(200)
		return
	end
    
    local isSprinting = ply:IsSprinting()
    local forwardSpeed = mv:GetForwardSpeed()
    local sideSpeed = mv:GetSideSpeed()
    local maxSpeed = mv:GetMaxSpeed()
    local velocity = ply:GetVelocity():Length()
    
	local stamina = ply:GetNWFloat("stamina")
    local adrenalineBoost = (ply.adrenaline or 0) * 50
    
    if SERVER and ply.CanMove == false then
        mv:SetMaxSpeed(0)
        ply:SetCrouchedWalkSpeed(0)
        return
    end
  
    ply.move = forwardSpeed
    ply.sidemove = sideSpeed
    
    ply:SetDuckSpeed(0.5)
    ply:SetUnDuckSpeed(0.5)
    ply:SetSlowWalkSpeed(30)
    ply:SetWalkSpeed(170)
    ply:SetJumpPower(200)
    
    local targetRunSpeed = isSprinting and ((forwardSpeed > 1 and 330 or 260) + adrenalineBoost) * stamina / 85
                          or (ply:GetWalkSpeed() / 1.5) * stamina / 100
    
    local lerpFactor = isSprinting and 0.025 or 0.1
    local newRunSpeed = Lerp(lerpFactor, ply:GetRunSpeed(), targetRunSpeed)
    ply:SetRunSpeed(newRunSpeed)

    ply:SetCrouchedWalkSpeed(1 * stamina / 200)
	
    if isSprinting and forwardSpeed > 30 then
        ply.stamina = math.Clamp((ply.stamina or 100) - 0.01, 0, 100)
    elseif velocity < 200 then
        ply.stamina = math.Clamp((ply.stamina or 0) + 0.035 + adrenalineBoost / 15, 0, 100)
    end
    
    if not ply:Crouching() then
        mv:SetMaxSpeed(maxSpeed)
        mv:SetMaxClientSpeed(newRunSpeed)
    end
end)

function hg.GetCurrentCharacter(ent)
    return (ent:IsPlayer() and (ent:GetNWBool("Fake") and ent:GetNWEntity("FakeRagdoll") or ent) or nil)
end
hook.Add("HomigradRun", "RunShit", function()
    local entitis = player.GetAll()
    table.Add(entitis,ents.FindByClass("prop_ragdoll"))

    for k, ply in ipairs(entitis) do
        ply.RenderOverride = function(self)
            local ply = self:IsPlayer() and self or IsValid(self:GetNWEntity("RagdollOwner", NULL)) and self:GetNWEntity("RagdollOwner", NULL)
            local ent = ply and IsValid(ply:GetNWEntity("Ragdoll", NULL)) and ply:GetNWEntity("Ragdoll", NULL) or ply or self
            
            if ent then
                hook.Run( "HG_PostPlayerDraw", ent, ply )
        
                ent:DrawModel()
            end
        end
    end
end)

gameevent.Listen( "entity_killed" )
hook.Add("entity_killed","player_deathhg",function(data) 
	local ply = Entity(data.entindex_killed)
    local attacker = Entity(data.entindex_attacker)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	
	hook.Run("Player Death", ply, attacker)
end)

local override = {}
net.Receive("Override Spawn", function() override[net.ReadEntity()] = true end)
hook.Add("Player Spawn", "!Override", function(ply)
	if override[ply] then
		override[ply] = nil
		return false
	end
end)

hook.Add("Player Spawn", "zOverride", function(ply)
	if override[ply] then
		override[ply] = nil
		return false
	end
end)

local hull = 10 
local HullMin = -Vector(hull,hull,0)
local Hull = Vector(hull,hull,72)
local HullDuck = Vector(hull,hull,36)

hook.Add("Player Activate","SetHull",function(ply)
	ply:SetHull(ply:GetNWVector("HullMin",HullMin) or HullMin,ply:GetNWVector("Hull",Hull) or Hull)
	ply:SetHullDuck(ply:GetNWVector("HullMin",HullMin) or HullMin,ply:GetNWVector("HullDuck",HullDuck) or HullDuck)
	ply:SetViewOffset(Vector(0,0,64))
	ply:SetViewOffsetDucked(Vector(0,0,38))
    ply:SetMoveType(MOVETYPE_WALK)
    ply:DrawShadow(true)
    ply:SetRenderMode(RENDERMODE_NORMAL)

    if SERVER then
        ply:SetSolidFlags(bit.band(ply:GetSolidFlags(),bit.bnot(FSOLID_NOT_SOLID)))
        ply:SetNWEntity("ragdollWeapon", NULL)
        ply:SetNWEntity("ActiveWeapon", NULL)
    end

    timer.Simple(0,function()
        local ang = ply:EyeAngles()
        if ang[3] == 180 then
            ang[2] = ang[2] + 180
        end
        ang[3] = 0
        ply:SetEyeAngles(ang)
    end)

    if SERVER then
        hg.send(nil,ply,true)
    end
end)

hook.Add("Player Death","SetHull",function(ply, attacker)
    timer.Simple(0,function()
        local ang = ply:EyeAngles()
        if ang[3] == 180 then
            ang[2] = ang[2] + 180
        end
        ang[3] = 0
        ply:SetEyeAngles(ang)
    end)
end)

if CLIENT then
    hook.Add("EntityNetworkedVarChanged", "newfakeentity", function(ply, name, oldval, rag)
        --print(ply,name,oldval,rag)
        --[[if name == "Ragdoll" then
            ply.FakeRagdoll = rag
            if IsValid(rag) then
                hook.Run("Fake", "faked", ply, rag)
            end
        end--]]
    end)
end

if CLIENT then
    hook.Add("NetworkEntityCreated","huyhuy",function(ent)
        if not ent:IsRagdoll() then return end
        timer.Simple(LocalPlayer():Ping() / 100 + 0.1,function()
            if not IsValid(ent) then return end
            if IsValid(ent:GetNWEntity("RagdollOwner")) then
                hook.Run("Fake",ent:GetNWEntity("RagdollOwner"),ent)
            end
        end)
    end)
end

hook.Add("Fake","faked",function(ply, rag)
    ply:SetHull(-Vector(1,1,1),Vector(1,1,1))
	ply:SetHullDuck(-Vector(1,1,1),Vector(1,1,1))
    ply:SetViewOffset(Vector(0,0,0))
    ply:SetViewOffsetDucked(Vector(0,0,0))
    ply:SetMoveType(MOVETYPE_NONE)
end)

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

function hg.eyeTrace(ply, dist, ent, aim_vector)
	local fakeCam = IsValid(ply.FakeRagdoll)
	local ent = hg.GetCurrentCharacter(ply)
	if ent == nil then
		ent = ply
	end
	if ent == NULL then
		ent = ply
	end
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
    eyeAng:Normalize()
	local eyeang2 = aim_vector:Angle()
	eyeang2.p = 0
    
	local trace = hg.hullCheck(ply:EyePos()+select(2,ply:GetHull())[2] * eyeAng:Forward(),headm:GetTranslation() + (fakeCam and (headm:GetAngles():Forward() * 2 + headm:GetAngles():Up() * -2 + headm:GetAngles():Right() * 3) or (eyeAng:Up() * 1 + eyeang2:Forward() * ((math.max(eyeAng[1],0) / 90 + 0.5) * 4) + eyeang2:Right() * 0.5)),ply)

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

hook.Add("Player Think","FUCKING FUCK YOU",function(ply,time)		
	if (ply.FUCKYOU_TIMER or 0) < time then
		ply.FUCKYOU_TIMER = time + 1

		ply:SetRenderMode(IsValid(ply:GetNWEntity("Ragdoll")) and RENDERMODE_NONE or RENDERMODE_NORMAL)
	end
end)

function hg.KeyDown(owner,key)
	if not IsValid(owner) then return false end
	owner.keydown = owner.keydown or {}
	local localKey
	if CLIENT then
		if owner == LocalPlayer() then
			localKey = owner:KeyDown(key)
		else
			localKey = owner.keydown[key]
		end
	end
	return SERVER and owner:IsPlayer() and owner:KeyDown(key) or CLIENT and localKey
end

function hg.KeyPressed(owner,key)
	if not IsValid(owner) then return false end
	owner.keypressed = owner.keypressed or {}
	local localKey
	if CLIENT then
		if owner == LocalPlayer() then
			localKey = owner:KeyPressed(key)
		else
			localKey = owner.keypressed[key]
		end
	end
	return SERVER and owner:IsPlayer() and owner:KeyPressed(key) or CLIENT and localKey
end

-- PewPaws!!!
game.AddParticles("particles/muzzleflashes_test.pcf")
game.AddParticles("particles/muzzleflashes_test_b.pcf")
game.AddParticles("particles/pcfs_jack_muzzleflashes.pcf")
game.AddParticles("particles/ar2_muzzle.pcf")

local huyprecahche = {
    "muzzleflash_SR25",
    "pcf_jack_mf_tpistol",
    "pcf_jack_mf_mshotgun",
    "pcf_jack_mf_msmg",
    "pcf_jack_mf_spistol",
    "pcf_jack_mf_mrifle2",
    "pcf_jack_mf_mrifle1",
    "pcf_jack_mf_mpistol",
    "pcf_jack_mf_suppressed",
    "muzzleflash_pistol_rbull",
    "muzzleflash_m24",
    "muzzleflash_m79",
    "muzzleflash_M3",
    "muzzleflash_m14",
    "muzzleflash_g3",
    "muzzleflash_FAMAS",
    "muzzleflash_ak74",
    "muzzleflash_ak47",
    "muzzleflash_mp5",
    "muzzleflash_suppressed",
    "muzzleflash_MINIMI",
    "muzzleflash_svd",
    "new_ar2_muzzle"
}
for k,v in ipairs(huyprecahche) do
    PrecacheParticleSystem(v)
end
-- CAAABOOOOMS!

game.AddParticles("particles/pcfs_jack_explosions_large.pcf")
game.AddParticles("particles/pcfs_jack_explosions_medium.pcf")
game.AddParticles("particles/pcfs_jack_explosions_small.pcf")
game.AddParticles("particles/pcfs_jack_nuclear_explosions.pcf")
game.AddParticles("particles/pcfs_jack_moab.pcf")
game.AddParticles("particles/gb5_large_explosion.pcf")
game.AddParticles("particles/gb5_500lb.pcf")
game.AddParticles("particles/gb5_100lb.pcf")
game.AddParticles("particles/gb5_50lb.pcf")
game.AddParticles("particles/pcfs_jack_muzzleflashes.pcf")
game.AddParticles("particles/pcfs_jack_explosions_incendiary2.pcf")
game.AddParticles("particles/lighter.pcf")

PrecacheParticleSystem("Lighter_flame")
PrecacheParticleSystem("pcf_jack_nuke_ground")
PrecacheParticleSystem("pcf_jack_nuke_air")
PrecacheParticleSystem("pcf_jack_moab")
PrecacheParticleSystem("pcf_jack_moab_air")
PrecacheParticleSystem("cloudmaker_air")
PrecacheParticleSystem("cloudmaker_ground")
PrecacheParticleSystem("500lb_air")
PrecacheParticleSystem("500lb_ground")
PrecacheParticleSystem("100lb_air")
PrecacheParticleSystem("100lb_ground")
PrecacheParticleSystem("50lb_air")
PrecacheParticleSystem("pcf_jack_incendiary_ground_sm2")
PrecacheParticleSystem("pcf_jack_groundsplode_small3")
PrecacheParticleSystem("pcf_jack_smokebomb3")
PrecacheParticleSystem("pcf_jack_groundsplode_medium")
PrecacheParticleSystem("pcf_jack_groundsplode_large")
PrecacheParticleSystem("pcf_jack_airsplode_medium")

if CLIENT then
	local cached_children = {}

	function hg.get_children(ent, bone, endbone)
		local bones = {}

		local mdl = ent:GetModel()
		if cached_children[mdl] and cached_children[mdl][bone] then return cached_children[mdl][bone] end

		hg.recursive_get_children(ent, bone, bones, endbone)

		cached_children[mdl] = cached_children[mdl] or {}
		cached_children[mdl][bone] = bones

		return bones
	end

	function hg.recursive_get_children(ent, bone, bones, endbone)
		local bone = isstring(bone) and ent:LookupBone(bone) or bone

		if not bone or isstring(bone) or bone == -1 then return end
		
		local children = ent:GetChildBones(bone)
		if #children > 0 then
			local id
			for i = 1,#children do
				id = children[i]
				if id == endbone then continue end
				hg.recursive_get_children(ent, id, bones, endbone)
				table.insert(bones, id)
			end
		end
	end

	function hg.bone_apply_matrix_ex(ent, bone, new_matrix, endbone)
		local bone = isstring(bone) and ent:LookupBone(bone) or bone

		if not bone or isstring(bone) or bone == -1 then return end

		local matrix = ent:GetBoneMatrix(bone)
		if not matrix then return end
		local inv_matrix = matrix:GetInverse()
		if not inv_matrix then return end

		local children = hg.get_children(ent, bone, endbone)
		
		local id
		for i = 1,#children do
			id = children[i]
			local mat = ent:GetBoneMatrix(id)
			if not mat then continue end
			ent.matrixes_old[id] = new_matrix * (inv_matrix * mat)
		end

		ent.matrixes_old[bone] = new_matrix
	end

	function hg.bone_apply_matrix(ent, bone, new_matrix, endbone)
		local bone = isstring(bone) and ent:LookupBone(bone) or bone

		if not bone or isstring(bone) or bone == -1 then return end

		local matrix = ent:GetBoneMatrix(bone)
		if not matrix then return end
		local inv_matrix = matrix:GetInverse()
		if not inv_matrix then return end

		local children = hg.get_children(ent, bone, endbone)

		local id
		for i = 1,#children do
			id = children[i]
			local mat = ent:GetBoneMatrix(id)
			if not mat then continue end
			ent:SetBoneMatrix(id, new_matrix * (inv_matrix * mat))
		end

		ent:SetBoneMatrix(bone, new_matrix)
	end

	local hand_poses = {
		["ak_hold"] = {
			['ValveBiped.Anim_Attachment_LH'] = Matrix({
				{-0.00000,	0.00000,	1.00000,	2.67615},
				{1.00000,	0.00000,	-0.00000,	-1.71259},
				{0.00000,	1.00000,	0.00000,	0.00000},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger42'] = Matrix({
				{-0.94591,	0.27700,	0.16890,	3.54791},
				{-0.30619,	-0.93432,	-0.18247,	-1.92862},
				{0.10726,	-0.22431,	0.96860,	-1.02161},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger41'] = Matrix({
				{-0.33096,	0.89941,	0.28551,	3.78937},
				{-0.94323,	-0.32425,	-0.07194,	-1.24072},
				{0.02788,	-0.29311,	0.95567,	-1.04199},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger4'] = Matrix({
				{-0.04830,	0.87322,	0.48492,	3.85278},
				{-0.99005,	-0.10611,	0.09247,	0.05881},
				{0.13220,	-0.47563,	0.86966,	-1.21545},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger32'] = Matrix({
				{-0.89734,	0.43983,	0.03652,	3.88898},
				{-0.43921,	-0.89806,	0.02398,	-2.14607},
				{0.04334,	0.00548,	0.99905,	-0.27673},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger31'] = Matrix({
				{-0.55578,	0.82941,	0.05636,	4.55377},
				{-0.82883,	-0.55809,	0.03974,	-1.15453},
				{0.06441,	-0.02463,	0.99762,	-0.35364},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger3'] = Matrix({
				{0.40515,	0.90826,	0.10449,	3.93042},
				{-0.91189,	0.39324,	0.11756,	0.24893},
				{0.06568,	-0.14292,	0.98755,	-0.45465},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger22'] = Matrix({
				{-0.80179,	0.59719,	-0.02193,	4.12610},
				{-0.59716,	-0.79926,	0.06765,	-2.30994},
				{0.02287,	0.06736,	0.99747,	0.36749},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger21'] = Matrix({
				{-0.55616,	0.82995,	-0.04349,	4.79871},
				{-0.83102,	-0.55479,	0.03996,	-1.30507},
				{0.00905,	0.05838,	0.99825,	0.35626},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger2'] = Matrix({
				{0.53286,	0.84495,	-0.04613,	3.88226},
				{-0.84567,	0.52979,	-0.06446,	0.14911},
				{-0.03002,	0.07336,	0.99686,	0.40833},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger12'] = Matrix({
				{-0.76564,	0.60825,	-0.20935,	4.27423},
				{-0.64018,	-0.75231,	0.15556,	-2.53366},
				{-0.06288,	0.25312,	0.96540,	1.28217},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger11'] = Matrix({
				{-0.31689,	0.90408,	-0.28674,	4.62231},
				{-0.94762,	-0.31451,	0.05561,	-1.49168},
				{-0.03991,	0.28934,	0.95639,	1.32605},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger1'] = Matrix({
				{0.43860,	0.83784,	-0.32505,	3.86847},
				{-0.89863,	0.41297,	-0.14808,	0.05353},
				{0.01017,	0.35704,	0.93404,	1.30878},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger02'] = Matrix({
				{0.50243,	0.85495,	0.12890,	2.51984},
				{-0.49077,	0.15927,	0.85660,	-1.93399},
				{0.71183,	-0.49365,	0.49961,	3.16608},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger01'] = Matrix({
				{0.52369,	0.82281,	0.22077,	1.88818},
				{-0.63107,	0.20059,	0.74934,	-1.17212},
				{0.57228,	-0.53174,	0.62429,	2.47565},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger0'] = Matrix({
				{0.59067,	0.80398,	0.06873,	0.83069},
				{-0.48029,	0.28184,	0.83060,	-0.31262},
				{0.64841,	-0.52362,	0.55262,	1.31488},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				
				
				
		},
		["pistol_hold"] = {
			['ValveBiped.Anim_Attachment_LH'] = Matrix({
				{-0.00000,	0.00000,	1.00000,	2.67621},
				{1.00000,	-0.00000,	0.00000,	-1.71246},
				{0.00000,	1.00000,	-0.00000,	0.00003},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger22'] = Matrix({
				{-0.01749,	0.99334,	0.11387,	6.02985},
				{-0.97449,	-0.04242,	0.22040,	-1.66858},
				{0.22376,	-0.10711,	0.96874,	0.55327},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger21'] = Matrix({
				{0.51410,	0.85003,	0.11468,	5.40814},
				{-0.84802,	0.48365,	0.21666,	-0.64301},
				{0.12871,	-0.20863,	0.96949,	0.39767},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger2'] = Matrix({
				{0.88753,	0.44555,	0.11738,	3.88190},
				{-0.46071,	0.86152,	0.21339,	0.14917},
				{-0.00605,	-0.24347,	0.96989,	0.40808},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger12'] = Matrix({
				{-0.09313,	0.95159,	-0.29292,	5.74945},
				{-0.98149,	-0.03829,	0.18766,	-1.67291},
				{0.16736,	0.30498,	0.93754,	2.22884},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger11'] = Matrix({
				{0.42919,	0.85458,	-0.29240,	5.27753},
				{-0.85153,	0.49078,	0.18449,	-0.73663},
				{0.30116,	0.16981,	0.93833,	1.89777},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger1'] = Matrix({
				{0.81943,	0.49413,	-0.29047,	3.86847},
				{-0.45961,	0.86925,	0.18211,	0.05353},
				{0.34248,	-0.01572,	0.93939,	1.30884},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger02'] = Matrix({
				{0.45101,	0.46180,	0.76376,	0.99359},
				{-0.89058,	0.28921,	0.35103,	-2.93256},
				{-0.05879,	-0.83851,	0.54171,	2.74484},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger01'] = Matrix({
				{0.11163,	0.71261,	0.69263,	0.85889},
				{-0.90098,	-0.22147,	0.37307,	-1.84503},
				{0.41925,	-0.66569,	0.61732,	2.23883},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger0'] = Matrix({
				{0.01574,	0.63272,	0.77422,	0.83069},
				{-0.85632,	-0.39123,	0.33713,	-0.31244},
				{0.51620,	-0.66829,	0.53565,	1.31491},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
		},
		["pistol_hold2"] = {
			['ValveBiped.Anim_Attachment_LH'] = Matrix({
				{0.00000,	0.00000,	1.00000,	2.67624},
				{1.00000,	0.00000,	0.00000,	-1.71219},
				{0.00000,	1.00000,	0.00000,	0.00125},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger22'] = Matrix({
				{-0.01749,	0.99334,	0.11387,	6.02979},
				{-0.97449,	-0.04242,	0.22040,	-1.66882},
				{0.22376,	-0.10711,	0.96874,	0.55479},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger21'] = Matrix({
				{0.51410,	0.85003,	0.11468,	5.40826},
				{-0.84802,	0.48365,	0.21666,	-0.64151},
				{0.12871,	-0.20863,	0.96949,	0.39841},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger2'] = Matrix({
				{0.88753,	0.44555,	0.11738,	3.88205},
				{-0.46071,	0.86152,	0.21339,	0.14990},
				{-0.00605,	-0.24347,	0.96989,	0.40967},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger12'] = Matrix({
				{0.04883,	0.93152,	0.36040,	5.93692},
				{-0.94806,	-0.07033,	0.31021,	-1.68707},
				{0.31431,	-0.35683,	0.87971,	1.06296},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger11'] = Matrix({
				{0.53655,	0.76259,	0.36135,	5.34744},
				{-0.84070,	0.44598,	0.30712,	-0.76180},
				{0.07304,	-0.46857,	0.88040,	0.98254},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger1'] = Matrix({
				{0.85928,	0.35981,	0.36356,	3.86862},
				{-0.47470,	0.82571,	0.30475,	0.05447},
				{-0.19054,	-0.43444,	0.88032,	1.30991},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger02'] = Matrix({
				{0.96372,	-0.25079,	0.09129,	3.71692},
				{-0.23753,	-0.65006,	0.72180,	-0.67805},
				{-0.12168,	-0.71731,	-0.68605,	2.00784},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger01'] = Matrix({
				{0.96779,	0.00605,	0.25170,	2.54880},
				{-0.18421,	-0.66437,	0.72434,	-0.45737},
				{0.17162,	-0.74738,	-0.64186,	1.80225},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger0'] = Matrix({
				{0.95950,	0.11401,	0.25760,	0.83066},
				{-0.08016,	-0.76613,	0.63767,	-0.31189},
				{0.27007,	-0.63250,	-0.72596,	1.31686},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				
		},
		["grip_hold"] = {
			['ValveBiped.Anim_Attachment_LH'] = Matrix({
				{-0.00000,	0.00000,	1.00000,	2.67603},
				{1.00000,	-0.00000,	0.00000,	-1.71242},
				{0.00000,	1.00000,	-0.00000,	-0.00003},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger22'] = Matrix({
				{-0.97924,	0.20271,	-0.00014,	3.74866},
				{-0.20076,	-0.96973,	0.13898,	-2.21208},
				{0.02804,	0.13613,	0.99029,	0.41345},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger21'] = Matrix({
				{-0.73487,	0.67761,	-0.02840,	4.63727},
				{-0.67613,	-0.72870,	0.10877,	-1.39452},
				{0.05301,	0.09914,	0.99366,	0.34940},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger2'] = Matrix({
				{0.43925,	0.89832,	-0.00901,	3.88190},
				{-0.89772,	0.43853,	-0.04240,	0.14917},
				{-0.03413,	0.02671,	0.99906,	0.40808},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger12'] = Matrix({
				{-0.99956,	-0.01974,	-0.02234,	3.86542},
				{0.01938,	-0.99968,	0.01623,	-2.35136},
				{-0.02265,	0.01579,	0.99962,	1.09308},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger11'] = Matrix({
				{-0.63952,	0.75470,	-0.14642,	4.56860},
				{-0.76220,	-0.64730,	-0.00734,	-1.51318},
				{-0.10032,	0.10691,	0.98920,	1.20340},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger1'] = Matrix({
				{0.40735,	0.87616,	-0.25768,	3.86835},
				{-0.91121,	0.37097,	-0.17910,	0.05359},
				{-0.06132,	0.30776,	0.94949,	1.30881},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger02'] = Matrix({
				{0.85313,	-0.04293,	0.51993,	2.97278},
				{-0.41533,	0.54722,	0.72667,	-2.11815},
				{-0.31571,	-0.83589,	0.44902,	2.23587},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger01'] = Matrix({
				{0.76975,	0.35296,	0.53189,	2.04376},
				{-0.63041,	0.28937,	0.72031,	-1.35727},
				{0.10032,	-0.88977,	0.44525,	2.11478},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger0'] = Matrix({
					{0.94183,	0.32924,	-0.06756,	0.83057},
					{-0.17855,	0.66041,	0.72936,	-0.31244},
					{0.28475,	-0.67487,	0.68078,	1.31494},
					{0.00000,	0.00000,	0.00000,	1.00000},
				}),
		},
		["normal"] = {
			['ValveBiped.Anim_Attachment_LH'] = Matrix({
				{-0.00000,	0.00000,	1.00000,	2.67612},
				{1.00000,	0.00000,	0.00000,	-1.71246},
				{0.00000,	1.00000,	-0.00000,	0.00011},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger22'] = Matrix({
				{-0.29595,	0.95278,	0.06800,	5.70983},
				{-0.95268,	-0.29959,	0.05143,	-1.95068},
				{0.06937,	-0.04956,	0.99636,	0.37529},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger21'] = Matrix({
				{0.33266,	0.94060,	0.06787,	5.30755},
				{-0.94279,	0.33004,	0.04704,	-0.81073},
				{0.02185,	-0.07964,	0.99658,	0.34882},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger2'] = Matrix({
				{0.82903,	0.55477,	0.07033,	3.88195},
				{-0.55815,	0.82863,	0.04294,	0.14893},
				{-0.03446,	-0.07485,	0.99660,	0.40813},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger12'] = Matrix({
				{-0.08428,	0.99281,	0.08499,	5.85923},
				{-0.99636,	-0.08288,	-0.01983,	-1.77557},
				{-0.01264,	-0.08635,	0.99618,	1.09001},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger11'] = Matrix({
				{0.46127,	0.88312,	0.08559,	5.35198},
				{-0.88521,	0.46461,	-0.02311,	-0.80212},
				{-0.06017,	-0.06510,	0.99606,	1.15631},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger1'] = Matrix({
				{0.86281,	0.49787,	0.08766,	3.86842},
				{-0.49768,	0.86698,	-0.02563,	0.05341},
				{-0.08876,	-0.02151,	0.99582,	1.30876},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger02'] = Matrix({
				{0.93636,	-0.05663,	0.34646,	3.07861},
				{-0.33561,	0.14505,	0.93076,	-1.36694},
				{-0.10297,	-0.98780,	0.11681,	2.87762},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger01'] = Matrix({
				{0.87590,	0.36578,	0.31466,	2.02138},
				{-0.37139,	0.09478,	0.92363,	-0.91876},
				{0.30802,	-0.92586,	0.21886,	2.50584},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_L_Finger0'] = Matrix({
				{0.66529,	0.65242,	0.36297,	0.83065},
				{-0.33863,	-0.16960,	0.92551,	-0.31274},
				{0.66537,	-0.73864,	0.10810,	1.31494},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),				
		},
			
	}

	local hand_posesrh = {
		["pistol_hold"] = {
			['ValveBiped.Anim_Attachment_RH'] = Matrix({
				{0.00000,	0.00000,	1.00000,	2.67606},
				{-1.00000,	0.00000,	0.00000,	-1.71246},
				{-0.00000,	-1.00000,	0.00000,	0.00002},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger22'] = Matrix({
				{-0.72247,	-0.69045,	0.03619,	3.59613},
				{0.68088,	-0.71960,	-0.13627,	-2.10107},
				{0.12013,	-0.07381,	0.99001,	-0.70821},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger21'] = Matrix({
				{-0.81663,	0.57602,	0.03631,	4.58354},
				{-0.57506,	-0.80666,	-0.13638,	-1.40582},
				{-0.04927,	-0.13225,	0.98999,	-0.64864},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger2'] = Matrix({
				{0.40803,	0.91223,	0.03655,	3.88191},
				{-0.90229,	0.40904,	-0.13621,	0.14581},
				{-0.13920,	0.02260,	0.99001,	-0.40927},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger12'] = Matrix({
				{0.38305,	0.89067,	0.24489,	6.36687},
				{-0.87335,	0.43556,	-0.21806,	-0.71552},
				{-0.30089,	-0.13035,	0.94471,	-2.29142},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger11'] = Matrix({
				{0.82500,	0.46776,	0.31714,	5.45959},
				{-0.43831,	0.88385,	-0.16339,	-0.23364},
				{-0.35672,	-0.00421,	0.93420,	-1.89915},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger1'] = Matrix({
				{0.92545,	0.20620,	0.31783,	3.86839},
				{-0.16063,	0.97334,	-0.16376,	0.04260},
				{-0.34312,	0.10050,	0.93390,	-1.30919},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger02'] = Matrix({
				{0.91919,	0.01437,	-0.39356,	2.56244},
				{-0.22476,	0.83975,	-0.49427,	-2.46594},
				{0.32339,	0.54278,	0.77512,	-1.12394},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger01'] = Matrix({
				{0.89306,	0.24370,	-0.37822,	1.48447},
				{-0.39602,	0.82473,	-0.40371,	-1.98792},
				{0.21354,	0.51032,	0.83305,	-1.38169},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger0'] = Matrix({
				{0.36535,	0.67044,	-0.64578,	0.83058},
				{-0.93006,	0.23399,	-0.28325,	-0.32336},
				{-0.03880,	0.70410,	0.70904,	-1.31224},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),

		},
		["pistol_hold2"] = {
			['ValveBiped.Anim_Attachment_RH'] = Matrix({
				{-0.00000,	-0.00000,	1.00000,	2.67590},
				{-1.00000,	0.00000,	0.00000,	-1.71245},
				{-0.00000,	-1.00000,	0.00000,	-0.00018},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger22'] = Matrix({
				{-0.72247,	-0.69045,	0.03619,	3.59595},
				{0.68088,	-0.71960,	-0.13627,	-2.10101},
				{0.12013,	-0.07381,	0.99001,	-0.70869},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger21'] = Matrix({
				{-0.81663,	0.57602,	0.03631,	4.58325},
				{-0.57506,	-0.80666,	-0.13638,	-1.40576},
				{-0.04927,	-0.13225,	0.98999,	-0.64896},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger2'] = Matrix({
				{0.40803,	0.91223,	0.03655,	3.88184},
				{-0.90229,	0.40904,	-0.13621,	0.14584},
				{-0.13920,	0.02260,	0.99001,	-0.40953},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger12'] = Matrix({
				{-0.64674,	0.67462,	0.35582,	5.34323},
				{-0.72666,	-0.68676,	-0.01868,	-1.51030},
				{0.23174,	-0.27064,	0.93437,	-1.63513},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger11'] = Matrix({
				{-0.13709,	0.89443,	0.42567,	5.49384},
				{-0.99051,	-0.11955,	-0.06781,	-0.42105},
				{-0.00976,	-0.43093,	0.90233,	-1.62455},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger1'] = Matrix({
				{0.94541,	0.27139,	0.18037,	3.86847},
				{-0.26957,	0.96235,	-0.03501,	0.04260},
				{-0.18308,	-0.01552,	0.98298,	-1.30880},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger02'] = Matrix({
				{0.99624,	0.06471,	-0.05769,	2.81659},
				{-0.08661,	0.77220,	-0.62945,	-2.12851},
				{0.00382,	0.63207,	0.77490,	-1.95563},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger01'] = Matrix({
				{0.96151,	0.27211,	-0.03794,	1.65674},
				{-0.24833,	0.80174,	-0.54364,	-1.82861},
				{-0.11751,	0.53214,	0.83846,	-1.81313},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger0'] = Matrix({
				{0.46226,	0.81687,	-0.34503,	0.83054},
				{-0.84134,	0.28111,	-0.46166,	-0.32336},
				{-0.28012,	0.50369,	0.81720,	-1.31165},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				
		},
		["ak_hold"] = {
			['ValveBiped.Anim_Attachment_RH'] = Matrix({
				{-0.00000,	0.00000,	1.00000,	2.67609},
				{-1.00000,	-0.00000,	-0.00000,	-1.71246},
				{-0.00000,	-1.00000,	0.00000,	0.00006},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger22'] = Matrix({
				{-0.93110,	0.35667,	-0.07637,	5.55054},
				{-0.31636,	-0.89387,	-0.31766,	-1.13599},
				{-0.18157,	-0.27162,	0.94512,	-0.15540},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger21'] = Matrix({
				{-0.01361,	0.98969,	-0.14256,	5.56680},
				{-0.99768,	-0.02294,	-0.06406,	0.07031},
				{-0.06667,	0.14136,	0.98771,	-0.07477},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger2'] = Matrix({
				{0.97992,	0.04619,	-0.19397,	3.88190},
				{-0.04384,	0.99890,	0.01639,	0.14563},
				{0.19451,	-0.00755,	0.98087,	-0.40924},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger12'] = Matrix({
				{-0.79259,	0.58780,	0.16215,	5.92780},
				{-0.55895,	-0.80666,	0.19203,	-1.24109},
				{0.24368,	0.06157,	0.96790,	-1.39969},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger11'] = Matrix({
				{0.34147,	0.92588,	0.16172,	5.55237},
				{-0.93122,	0.30995,	0.19173,	-0.21698},
				{0.12739,	-0.21607,	0.96803,	-1.53979},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger1'] = Matrix({
				{0.97941,	0.12047,	0.16201,	3.86835},
				{-0.15089,	0.96993,	0.19095,	0.04248},
				{-0.13414,	-0.21146,	0.96814,	-1.30917},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger02'] = Matrix({
				{0.99825,	0.01739,	-0.05635,	3.03442},
				{-0.04002,	0.90167,	-0.43059,	-2.16174},
				{0.04332,	0.43209,	0.90079,	-1.86401},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger01'] = Matrix({
				{0.90272,	0.42076,	-0.08968,	1.94482},
				{-0.41680,	0.80369,	-0.42469,	-1.65881},
				{-0.10661,	0.42075,	0.90088,	-1.73535},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger0'] = Matrix({
				{0.62252,	0.77258,	-0.12482,	0.83057},
				{-0.74605,	0.53767,	-0.39285,	-0.32355},
				{-0.23639,	0.33768,	0.91109,	-1.31219},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
		},
		["normal"] = {
			['ValveBiped.Anim_Attachment_RH'] = Matrix({
				{0.00000,	0.00000,	1.00000,	2.67609},
				{-1.00000,	0.00000,	0.00000,	-1.71240},
				{0.00000,	-1.00000,	0.00000,	-0.00003},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger22'] = Matrix({
				{-0.96502,	0.21943,	0.14350,	4.92922},
				{-0.22411,	-0.97441,	-0.01712,	-2.37482},
				{0.13607,	-0.04868,	0.98950,	-0.60452},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger21'] = Matrix({
				{-0.04046,	0.98880,	0.14365,	4.97814},
				{-0.99912,	-0.03840,	-0.01709,	-1.16669},
				{-0.01138,	-0.14422,	0.98948,	-0.59076},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger2'] = Matrix({
				{0.63750,	0.75694,	0.14366,	3.88191},
				{-0.76319,	0.64595,	-0.01679,	0.14569},
				{-0.10551,	-0.09894,	0.98948,	-0.40930},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger12'] = Matrix({
				{-0.06498,	0.97425,	0.21589,	6.14457},
				{-0.99649,	-0.05193,	-0.06558,	-1.45105},
				{-0.05268,	-0.21940,	0.97421,	-1.85055},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger11'] = Matrix({
				{0.67922,	0.70148,	0.21586,	5.39766},
				{-0.70660,	0.70452,	-0.06612,	-0.67401},
				{-0.19846,	-0.10761,	0.97418,	-1.63230},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger1'] = Matrix({
				{0.88940,	0.41611,	0.18924,	3.86839},
				{-0.41671,	0.90822,	-0.03854,	0.04260},
				{-0.18791,	-0.04458,	0.98117,	-1.30923},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger02'] = Matrix({
				{0.96589,	0.23494,	-0.10889,	2.51287},
				{-0.25337,	0.77071,	-0.58465,	-2.42767},
				{-0.05343,	0.59230,	0.80395,	-1.96227},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger01'] = Matrix({
				{0.90463,	0.41992,	-0.07287,	1.42098},
				{-0.39736,	0.76919,	-0.50046,	-1.94806},
				{-0.15410,	0.48169,	0.86269,	-1.77628},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				['ValveBiped.Bip01_R_Finger0'] = Matrix({
				{0.32986,	0.86917,	-0.36843,	0.83059},
				{-0.90773,	0.18485,	-0.37663,	-0.32330},
				{-0.25925,	0.45867,	0.84995,	-1.31228},
				{0.00000,	0.00000,	0.00000,	1.00000},
				}),
				
		},
	}

	function hg.set_hold(ent, hold)
		local lhmat = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_L_Hand"))
		for bone,invmat in pairs(hand_poses[hold]) do
			bone = isstring(bone) and ent:LookupBone(bone) or bone
			if not bone or isstring(bone) or bone == -1 then continue end
			if not ent:GetBoneMatrix(bone) then continue end
			ent:SetBoneMatrix(bone,lhmat * invmat)
		end
	end

	function hg.set_holdrh(ent,hold)
		local lhmat = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_R_Hand"))
		for bone,invmat in pairs(hand_posesrh[hold]) do
			bone = isstring(bone) and ent:LookupBone(bone) or bone
			if not bone or isstring(bone) or bone == -1 then continue end
			if not ent:GetBoneMatrix(bone) then continue end
			ent:SetBoneMatrix(bone,lhmat * invmat)
		end
	end

	function hg.copy_hold(ply)
		local lh = ply:LookupBone("ValveBiped.Bip01_L_Hand")
		local lhmat = ply:GetBoneMatrix(lh)
		print("\n")
		for i,bone in pairs(hg.get_children(ply,lh)) do
			local bon = ply:GetBoneName(bone)
			print("['"..bon.."'] = Matrix({\n"..string.Replace(string.Replace(tostring(lhmat:GetInverse() * ply:GetBoneMatrix(bone)),"[","{"),"]","},").."\n}),")
		end
		print("\n")
	end

	function hg.copy_holdrh(ply)
		local lh = ply:LookupBone("ValveBiped.Bip01_R_Hand")
		local lhmat = ply:GetBoneMatrix(lh)
		print("\n")
		for i,bone in pairs(hg.get_children(ply,lh)) do
			local bon = ply:GetBoneName(bone)
			print("['"..bon.."'] = Matrix({\n"..string.Replace(string.Replace(tostring(lhmat:GetInverse() * ply:GetBoneMatrix(bone)),"[","{"),"]","},").."\n}),")
		end
		print("\n")
	end

	local hg_tpik_distance = ConVarExists("hg_tpik_distance") and GetConVar("hg_tpik_distance") or CreateClientConVar("hg_tpik_distance",1024,true,false,"The distance (in hammer units) at which the third person inverse kinematics enables, 0 = inf",0,2048)

	local render_GetViewSetup = render.GetViewSetup

	--copy hold делаешь когда нужно скопировать пальчики левой руки
	--set hold когда хочешь чтобы пальчики встали ровно как надо по копии (и не двигались)
	--hg.copy_hold(Entity(1))
end