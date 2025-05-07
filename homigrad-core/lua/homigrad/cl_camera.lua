local t = {}
local n, e, r, o
local d = Material('materials/scopes/scope_dbm.png')
CameraSetFOV = 120

Recoil = 0
RecoilS = 0
RecoilAng = Angle(0,0,0)

CreateClientConVar("hg_fov","120",true,false,nil,70,120)
local smooth_cam = CreateClientConVar("hg_smooth_cam","1",true,false,nil,0,1)

CreateClientConVar("hg_bodycam","0",true,false,nil,0,1)

CreateClientConVar("hg_fakecam_mode","0",true,false,nil,0,1)

CreateClientConVar("hg_deathsound","1",true,false,nil,0,1)
CreateClientConVar("hg_deathscreen","1",true,false,nil,0,1)

function SETFOV(value)
	CameraSetFOV = value or GetConVar("hg_fov"):GetInt()
end

SETFOV()

cvars.AddChangeCallback("hg_fov",function(cmd,_,value)
    timer.Simple(0,function()
		SETFOV()
		print("	hg: change fov")
	end)
end)

surface.CreateFont("HomigradFontBig",{
	font = "Roboto",
	size = 25,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("BodyCamFont",{
	font = "Arial",
	size = 40,
	weight = 1100,
	outline = false,
	shadow = true
})

local view = {
	x = 0,
	y = 0,
	drawhud = true,
	drawviewmodel = false,
	dopostprocess = true,
	drawmonitors = true
}

local render_Clear = render.Clear
local render_RenderView = render.RenderView

local white = Color(255,255,255)
local HasFocus = system.HasFocus
local oldFocus
local text

local developer = GetConVar("developer")
local CalcView--fuck
local vel = 0
local diffang = Vector(0,0,0)
local diffpos = Vector(0,0,0)
local shit_ang = Angle(0,0,0)
diffang2 = Angle(0,0,0)

hook.Add("RenderScene","homigrad_mainrenderscene",function(pos,angle,fov)
	local focus = HasFocus()

	hook.Run("Frame",pos,angle)

	RENDERSCENE = true
	local _view = CalcView(LocalPlayer(),pos,angle,fov)

	if not _view then RENDERSCENE = nil return end

	view.fov = fov
	view.origin = _view.origin
	view.angles = _view.angles
	view.znear = _view.znear
	view.drawviewmodel = _view.drawviewmodel

	render_Clear(0,0,0,255,true,true,true)
	render_RenderView(view)

	RENDERSCENE = nil

	return true
end)

local ply = LocalPlayer()
local scrw, scrh = ScrW(), ScrH()
local whitelistweps = {
	["weapon_physgun"] = true,
	["gmod_tool"] = true,
	["gmod_camera"] = true,
	["drgbase_possessor"] = true,
}

function RagdollOwner(rag)
	if not IsValid(rag) then return end

	local ent = rag:GetNWEntity("RagdollController")

	return IsValid(ent) and ent
end

local ScopeLerp = 0
local scope
local G = 0
local size = 0.03
local angle = Angle(0)
local possight = Vector(0)

local function scopeAiming()
	local wep = LocalPlayer():GetActiveWeapon()

	return IsValid(wep) and weps[wep:GetClass()] and LocalPlayer():KeyDown(IN_ATTACK2) and not LocalPlayer():KeyDown(IN_SPEED)
end

LerpEyeRagdoll = Angle(0,0,0)

local lply = LocalPlayer()
LerpEye = IsValid(lply) and lply:EyeAngles() or Angle(0,0,0)

local vecZero,vecFull = Vector(0,0,0),Vector(1,1,1)
local firstPerson

local max = math.max
local upang = Angle(-90,0,0)
local oldShootTime
local startRecoil = 0
local angRecoil = Angle(0,0,0)
local recoil = 0
local sprinthuy = 0
local oldview = {}

local whitelistSimfphys = {}
whitelistSimfphys.gred_simfphys_brdm2 = true
whitelistSimfphys.gred_simfphys_brdm2_atgm = true
whitelistSimfphys.gred_simfphys_brdm_hq = true

local view = {}

ADDFOV = 0
ADDROLL = 0

follow = follow or NULL

local oldangles = Angle(0,0,0)
local angZero = Angle(0,0,0)

local lastcall = 0

function CalcView(ply,vec,ang,fov,znear,zfar)
	shit_ang = LerpAngleFT(0.1,shit_ang,ang)
	local dtime = SysTime() - lastcall
	lastcall = SysTime()
	if STOPRENDER then return end
	Recoil = LerpFT(0.1,Recoil,0)
	if RecoilS < 15 then
		RecoilS = LerpFT(0.07,RecoilS,0)
	else
		RecoilS = LerpFT(0.035,RecoilS,0)
	end
	local fov = CameraSetFOV + ADDFOV
	local lply = LocalPlayer()

	if !lply:Alive() and lply:GetNWInt("specmode") == 1 and IsValid(lply:GetNWEntity("SpectEnt")) then
		local bone = lply:LookupBone("ValveBiped.Bip01_Head1")
		if bone then lply:ManipulateBoneScale(bone,firstPerson and vecZero or vecFull) end
		local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
		local body = ply:LookupBone("ValveBiped.Bip01_Spine2")
		
		local tr, hullcheck, headm = hg.eyeTrace(lply)

		angEye = lply:EyeAngles()

		vecEye = tr.StartPos or lply:EyePos()

		local nigga = (IsValid(lply:GetNWEntity("SpectEnt"):GetNWEntity("FakeRagdoll")) and lply:GetNWEntity("SpectEnt"):GetNWEntity("FakeRagdoll") or lply:GetNWEntity("SpectEnt"))

		local eye = nigga:GetAttachment(nigga:LookupAttachment("eyes"))

		view.origin = eye.Pos
		view.angles = (IsValid(lply:GetNWEntity("SpectEnt"):GetNWEntity("FakeRagdoll")) and eye.Ang or nigga:EyeAngles())

		return view
	elseif !lply:Alive() then
		return
	end

	DRAWMODEL = nil

	ADDFOV = 0
	ADDROLL = 0


	hook.Run("CalcAddFOV",ply)--megaggperkostil
	
	local result = hook.Run("PreCalcView",ply,vec,ang,fov,znear,zfar)
	if result != nil then
		result.fov = fov + ADDFOV
		//result.angles[3] = result.angles[3] + ADDROLL

		return result
	end

	--[[if lply:InVehicle() then
		local diffvel = lply:GetVehicle():GetPos() - vel
		
		local view = {
			origin = lply:EyePos() + diffvel * 10,
			angles = lply:EyeAngles(),
			fov = fov
		}
		
		vel = lply:GetVehicle():GetPos()
		return view
	end--]]

	firstPerson = GetViewEntity() == lply

	local bone = lply:LookupBone("ValveBiped.Bip01_Head1")
	if bone then lply:ManipulateBoneScale(bone,firstPerson and vecZero or vecFull) end
	if not firstPerson then DRAWMODEL = true return end
	local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
	local eye = ply:GetAttachment(ply:LookupAttachment("eyes"))
	local body = ply:LookupBone("ValveBiped.Bip01_Spine2")
	
	local tr, hullcheck, headm = hg.eyeTrace(lply)

	//hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(0,0,0),1,0.1)

	if GetConVar("hg_bodycam"):GetInt() == 0 then
		angEye = lply:EyeAngles()
		
		vecEye = tr.StartPos or lply:EyePos()
	else
		local matrix = ply:GetBoneMatrix(body)
		local bodypos = matrix:GetTranslation()
		local bodyang = matrix:GetAngles()
		--bodyang:RotateAroundAxis(bodyang:Right(),90)

		--bodyang[2] = eye.Ang[2]
		--bodyang[3] = 0
		angEye = eye.Ang--bodyang
		vecEye = (eye and bodypos + bodyang:Up() * 0 + bodyang:Forward() * 14 + bodyang:Right() * -6) or lply:EyePos()
	end

	local ragdoll = ply:GetNWEntity("FakeRagdoll")
	follow = ragdoll

	if ply:Alive() and IsValid(ragdoll) then
		ragdoll:ManipulateBoneScale(ragdoll:LookupBone("ValveBiped.Bip01_Head1"),vecZero)
		
		local att = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))
		
		local eyeAngs = lply:EyeAngles()
		if GetConVar("hg_bodycam"):GetInt() == 1 then
			local matrix = ragdoll:GetBoneMatrix(body)
			local bodypos = matrix:GetTranslation()
			local bodyang = matrix:GetAngles()
			
			eyeAngs = att.Ang
			att.Pos = (eye and bodypos + bodyang:Up() * 0 + bodyang:Forward() * 10 + bodyang:Right() * -8) or lply:EyePos()
		end
		local anghook = GetConVar("hg_fakecam_mode"):GetFloat()
		LerpEyeRagdoll = LerpAngleFT(0.08,LerpEyeRagdoll,LerpAngle(anghook,eyeAngs,att.Ang))

		LerpEyeRagdoll[3] = LerpEyeRagdoll[3] + ADDROLL

		local view = {
			origin = att.Pos,
			angles = LerpEyeRagdoll,
			fov = fov,
			drawviewer = true
		}

		if IsValid(helmEnt) then
			helmEnt:SetNoDraw(true)
		end

		return view
	end

	local wep = lply:GetActiveWeapon()
	wep = IsValid(wep) and wep

	local traca = lply:GetEyeTrace()
	local dist = traca.HitPos:Distance(lply:EyePos())

	view.fov = fov

	if lply:InVehicle() or not firstPerson then return end

	if not lply:Alive() or (IsValid(wep) and whitelistweps[wep:GetClass()]) or lply:GetMoveType() == MOVETYPE_NOCLIP or IsValid(wep) and string.match(wep:GetClass(),"_css") then
		return
	end
	
	local output_ang = angEye
	local output_pos = vecEye

	if wep and wep.Camera then
		output_pos, output_ang, fov = wep:Camera(ply, output_pos, output_ang, fov)
	end

	view.fov = fov

	if wep and hand then
		local posRecoil = Vector(recoil * 8,0,recoil * 1.5)
		posRecoil:Rotate(hand.Ang)
		view.znear = Lerp(ScopeLerp,1,max(1 - recoil,0.2))
		output_pos = output_pos + posRecoil

		if not RENDERSCENE then
			recoil = LerpFT(scope and (wep.CLR_Scope or 0.25) or (wep.CLR or 0.1),recoil,0)
		end
	else
		recoil = 0
	end

	vec = Vector(vec[1],vec[2],eye and eye.Pos[3] or vec[3])

	vel = math.max(math.Round(Lerp(0.1,vel,lply:GetVelocity():Length())) - 1,0)
	
	sprinthuy = LerpFT(0.1,sprinthuy,-math.abs(math.sin(CurTime() * 6)) * vel / 400)
	output_ang[1] = output_ang[1] + sprinthuy

	output_ang[3] = 0

	output_ang = output_ang + vp_punch_angle / 1.5

	ang:Add(RecoilAng * math.Clamp(Recoil,0,1))

	output_ang[3] = output_ang[3] + Recoil

	local anim_pos = max(startRecoil - CurTime(),0) * 5

	local tick = 1 / engine.AbsoluteFrameTime()
	playerFPS = math.Round(Lerp(0.1,playerFPS or tick,tick))
	
	local val = math.min(math.Round(playerFPS / 120,1),1)
	
	diffpos = LerpFT(0.1,diffpos,(output_pos - (oldview.origin or output_pos)) / 6)
	diffang = LerpFT(0.1,diffang,(output_ang:Forward() - (oldview.angles or output_ang):Forward()) * 50 + (lply:EyeAngles() + (lply:GetActiveWeapon().eyeSpray or angZero) * 1000):Forward() * anim_pos * 1)

	local _, lang = WorldToLocal(vector_origin, lply:EyeAngles(), vector_origin, (oldangles or lply:EyeAngles()))
	oldangles = lply:EyeAngles()

	diffang2 = LerpFT(0.05, diffang2, lang * val)
    
	if diffang then output_pos:Add((diffang * 1.5 + diffpos) * val) end

	local size = Vector(6,6,0)
	local tr = {}
	local dir = (output_pos - vec):GetNormalized()
	tr.start = vec
	tr.endpos = output_pos
	tr.mins = -size
	tr.maxs = size

	tr.filter = ply
	local trZNear = util.TraceHull(tr)
	size = size / 2
	tr.mins = -size
	tr.maxs = size

	tr = util.TraceHull(tr)

	local pos = lply:GetPos()
	pos[3] = tr.HitPos[3] + 1--wtf is this bullshit
	local trace = util.TraceLine({start = lply:EyePos(),endpos = pos,filter = ply,mask = MASK_SOLID_BRUSHONLY})
	tr.HitPos[3] = trace.HitPos[3] - 1
	output_pos = tr.HitPos
	output_pos = output_pos

	if trZNear.Hit then view.znear = 0.1 else view.znear = 1 end--САСАТЬ!!11.. не работает ;c sharik loh

	output_ang[3] = output_ang[3] + (math.random(-2,2) * Recoil)

	--print(Recoil)
	
	view.origin = output_pos
	view.angles = output_ang
	view.drawviewer = true
	
	oldview = table.Copy(view)

	DRAWMODEL = true
	
	return view
end

hook.Add("CalcView","VIEWhuy",CalcView)

hook.Add("InputMouseApply", "asdasd2", function(cmd, x, y, angle)
	if not IsValid(LocalPlayer()) or not LocalPlayer():Alive() then return end
	if not IsValid(follow) then return end
	
	local att = follow:GetAttachment(follow:LookupAttachment("eyes"))
	if not att or not istable(att) then return end

	local attang = LocalPlayer():EyeAngles()
	local view = render.GetViewSetup(true)
	local anglea = view.angles
	local angRad = math.rad(angle[3])
	local newX = x * math.cos(angRad) - y * math.sin(angRad)
	local newY = x * math.sin(angRad) + y * math.cos(angRad)

	angle.pitch = math.Clamp(angle.pitch + newY / 50, -180, 180)
	angle.yaw = angle.yaw - newX / 50

	if math.abs(angle.pitch) > 89 then
		angle.roll = angle.roll + 180
		angle.yaw = angle.yaw + 180
		angle.pitch = 89 * (angle.pitch / math.abs(angle.pitch))
	end

	cmd:SetViewAngles(angle)
	return true
end)