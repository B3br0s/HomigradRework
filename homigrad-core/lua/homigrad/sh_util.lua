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
    
    local targetRunSpeed = isSprinting and ((forwardSpeed > 1 and 340 or 240) + adrenalineBoost) * stamina / 85
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