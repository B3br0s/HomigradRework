if engine.ActiveGamemode() == "homigradcom" then

	local t = {}
	local n, e, r, o
	local d = Material('materials/scopes/scope_dbm.png')
	CameraSetFOV = 120
	
	CreateClientConVar("hg_fov","120",true,false,nil,90,120)
	
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
	
	local function a()
		e = 360
		r = GetRenderTarget('weaponSight-' .. e, e, e)
		if not t[e] then
			t[e] = CreateMaterial('weaponSight-' .. e, 'UnlitGeneric', {})
		end
		o = t[e]
		n = {}
		local r, o, t, e = 0, 0, e / 2, 24
		n[#n+1] = {
			x = r,
			y = o,
			u = .5,
			v = .5
		}
		for a = 0, e do
			local e = math.rad( (a/e)*-360 )
			n[#n+1] = {
				x = r+math.sin(e)*t,
				y = o+math.cos(e)*t,
				u = math.sin(e)/2+.5,
				v = math.cos(e)/2+.5
			}
		end
	end
	
	a()
	
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
	
	local hg_disable_stoprenderunfocus = CreateClientConVar("hg_disable_stoprenderunfocus","0",true)
	
	local prekols = {
		"HG:R"
	}
	
	local developer = GetConVar("developer")
	local CalcView--fuck
	local vel = 0
	local diffang = Vector(0,0,0)
	local diffpos = Vector(0,0,0)
	
	hook.Add("RenderScene","octoweapons",function(pos,angle,fov)
		local focus = HasFocus()
		if focus ~= oldFocus then
			oldFocus = focus
	
			if not focus then
				text = table.Random(prekols)
			end
		end
	
		hook.Run("Frame",pos,angle)
		
		STOPRENDER = not hg_disable_stoprenderunfocus:GetBool() and not developer:GetBool() and not focus
	
		if STOPRENDER then
			cam.Start2D()
				draw.SimpleText(text,"DebugFixedSmall",ScrW() / 2,ScrH() / 2,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			cam.End2D()
	
			return true
		end
	
		RENDERSCENE = true
		local _view = CalcView(LocalPlayer(),pos,angle,fov)
	
		if not _view then RENDERSCENE = nil return end
	
		view.fov = fov
		view.origin = _view.origin
		view.angles = _view.angles
		view.znear = _view.znear
		view.drawviewmodel = _view.drawviewmodel
	
		if CAMERA_ZFAR then
			view.zfar = CAMERA_ZFAR + 300--cl_fog in homigrad gamemode
		else
			view.zfar = nil
		end
	
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
		["weapon_physcannon"] = true,
		["gmod_camera"] = true,
		["drgbase_possessor"] = true,
		["weapon_rpg"] = true
	}
	
	function RagdollOwner(rag)
		if not IsValid(rag) then return end
	
		local ent = rag:GetNWEntity("RagdollController")
	
		return IsValid(ent) and ent
	end
	
	hg_cool_camera = CreateClientConVar("hg_cool_camera","1",true,false,"huy",0,1)
	
	local angZero = Angle(0,0,0)
	local ScopeLerp = 0
	local scope
	local G = 0
	local size = 0.03
	local angle = Angle(0)
	local possight = Vector(0)
	
	local function scopeAiming()
		local wep = LocalPlayer():GetActiveWeapon()
	
		return IsValid(wep) and wep.Base == 'b3bros_base' and LocalPlayer():KeyDown(IN_ATTACK2) and not LocalPlayer():KeyDown(IN_SPEED)
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
	
	function ChangesCamera(wep)
		for i = 1,#wep.CurrentAtt do
			if wep.CurrentAtt[i].ChangesCamera then
				return true
			else
				if i == #wep.CurrentAtt then
					return false
				end
			end
		end
	end
	
	function getpos(wep)
		for i = 1,#wep.CurrentAtt do
			if wep.CurrentAtt[i].ChangesCamera then
				return wep.CurrentAtt[i].CameraPos
			end
		end
	end
	
	local helmEnt
	
	net.Receive("nodraw_helmet",function()
		helmEnt = net.ReadEntity()
	end)
	
	function CalcView(ply,vec,ang,fov,znear,zfar)
		if STOPRENDER then return end

		local fov = CameraSetFOV + ADDFOV
		local lply = LocalPlayer()
	
		if !ply:Alive() and timer.Exists("DeathCam") and IsValid(deathrag) then
			--deathrag:ManipulateBoneScale(6,vecZero)
			
			local att = deathrag:GetAttachment(deathrag:LookupAttachment("eyes"))
			
			LerpEyeRagdoll = LerpAngleFT(0.08,LerpEyeRagdoll,att.Ang)
	
			LerpEyeRagdoll[3] = LerpEyeRagdoll[3] + ADDROLL
	
			local view = {
				origin = att.Pos,
				angles = LerpEyeRagdoll,
				fov = fov,
				drawviewer = true
			}
	
			return view
		end
	
		DRAWMODEL = nil
	
		ADDFOV = 0
		ADDROLL = 0
	
	
		hook.Run("CalcAddFOV",ply)--megaggperkostil
		
		local result = hook.Run("PreCalcView",ply,vec,ang,fov,znear,zfar)
		if result ~= nil then
			result.fov = fov + ADDFOV
			result.angles[3] = result.angles[3] + ADDROLL
	
			return result
		end
		
		firstPerson = GetViewEntity() == lply
	
		local bone = lply:LookupBone("ValveBiped.Bip01_Head1")
		if bone then lply:ManipulateBoneScale(bone,firstPerson and vecZero or vecFull) end
		if not firstPerson then DRAWMODEL = true return end
		local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
		local eye = ply:GetAttachment(ply:LookupAttachment("eyes"))
		local body = ply:LookupBone("ValveBiped.Bip01_Spine2")
	
		angEye = lply:EyeAngles()
		angEye[3] = 0
		vecEye = (eye and eye.Pos + eye.Ang:Up() * -1.5 + eye.Ang:Forward() * 2) or lply:EyePos()
	
		local ragdoll = ply:GetNWEntity("Ragdoll")
	
		if ply:Alive() and ply:GetNWBool("fake") and IsValid(ragdoll) then
			ragdoll:ManipulateBoneScale(6,vecZero)
			
			local att = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))
			
			local eyeAngs = lply:EyeAngles()
			
			local matrix = ragdoll:GetBoneMatrix(body)
			local bodypos = matrix:GetTranslation()
			local bodyang = matrix:GetAngles()
			att.Pos = (eye and bodypos + bodyang:Up() * 0 + bodyang:Forward() * 20 - bodyang:Right() * Vector(2, 2, 2)) or lply:EyePos()
			local anghook = 0 --Камера в фейке
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
	
		if not RENDERSCENE then
			
			scope = IsValid(wep) and wep.IsScope and wep:IsScope() and not wep.isClose
			if scope then
				if lply:GetNWFloat("PosaVistrela") == 1 then 
					ScopeLerp = LerpFT(0.07,ScopeLerp,1)
				end
			else
				ScopeLerp = LerpFT(0.1,ScopeLerp,0)
			end
	
		end
	
		fov = Lerp(ScopeLerp,fov,CameraSetFOV)
	
		angRecoil[3] = 0
		
		if wep and wep.Base == 'b3bros_base' then
			local weaponClass = wep:GetClass()
			local att = wep.Attachments
	
			if not RENDERSCENE then
				local lastShootTime = wep:LastShootTime()
				if not oldShootTime then oldShootTime = lastShootTime else
					if oldShootTime ~= lastShootTime then
						oldShootTime = lastShootTime
						startRecoil = CurTime() + 0.1
						recoil = math.Rand(0.2,0.6) * (scope and 0.5 or 0.5)
					end
				end
			end
			
			local anim_pos = max(startRecoil - CurTime(),0) * 5
	
			fov = fov
			angRecoil[3] = anim_pos * (scope and 10 or 5)
		if wep.sightyes == false then
			if wep.CurrentAtt then
			local changescamera = ChangesCamera(wep)
			local pos = getpos(wep)	
			if changescamera then
				vecWep = hand.Pos + hand.Ang:Up() * pos[1] - hand.Ang:Forward() * pos[2] + hand.Ang:Right() * pos[3]
			else
				vecWep = hand.Pos + hand.Ang:Up() * wep.CameraPos[1] - hand.Ang:Forward() * wep.CameraPos[2] + hand.Ang:Right() * wep.CameraPos[3]
			end
			else
			vecWep = hand.Pos + hand.Ang:Up() * wep.CameraPos[1] - hand.Ang:Forward() * wep.CameraPos[2] + hand.Ang:Right() * wep.CameraPos[3]
			end
			if wep.CameraAng then
				angWep = hand.Ang + wep.CameraAng
			else
				angWep = hand.Ang
			end
		else
			if not wep.SightPos then return end
			vecWep = hand.Pos + hand.Ang:Up() * (wep.SightPos.x or 0) - hand.Ang:Forward() * (wep.SightPos.x or 0) + hand.Ang:Right() * (wep.SightPos.z or 0)
			--angWep = hand.Ang + Angle(0,0,0)
		end
		
		end
	
	
		if not RENDERSCENE then
			LerpEye = LerpAngleFT(0.15,LerpEye,angEye)
		else
			angEye = LerpAngleFT(0.25,LerpEye,angEye)
		end
	
		angEye = LerpEye
		vecEye = LerpVector(ScopeLerp,vecEye,vecWep or vecEye)
		angEye = LerpAngle(ScopeLerp/2,angEye,angWep or angEye)
	
	
		view.fov = fov
	
		if lply:InVehicle() or not firstPerson then return end
	
		if not lply:Alive() or (IsValid(wep) and whitelistweps[wep:GetClass()]) or lply:GetMoveType() == MOVETYPE_NOCLIP then
			view.origin = ply:EyePos()
			view.angles = ply:EyeAngles()
			view.drawviewer = false
	
			return view
		end
	
		local output_ang = angEye + angRecoil
		local output_pos = vecEye
	
		if wep and hand then
			local posRecoil = Vector(recoil,0,recoil * 1.5)
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
		
		sprinthuy = LerpFT(0.1,sprinthuy,-math.abs(math.sin(CurTime() * 6)) * vel / 200)
		output_ang[1] = output_ang[1] + sprinthuy * 2
	
		output_ang[3] = 0
	
		local anim_pos = max(startRecoil - CurTime(),0) * 5
	
		local tick = 1 / engine.AbsoluteFrameTime()
		playerFPS = math.Round(Lerp(0.1,playerFPS or tick,tick))
		
		local val = math.min(math.Round(playerFPS / 120,1),1)
		
		diffpos = LerpFT(0.1,diffpos,(output_pos - (oldview.origin or output_pos)) / 2)
		diffang = LerpFT(0.1,diffang,(output_ang:Forward() - (oldview.angles or output_ang):Forward()) * 20 + (lply:EyeAngles() + (lply:GetActiveWeapon().eyeSpray or angZero) * 1000):Forward() * anim_pos * 1)
	
		if RENDERSCENE then
			if hg_cool_camera:GetBool() then
				output_ang[3] = output_ang[3] + math.min(diffang:Dot(output_ang:Right()) * 3 * val,10)
			end
			
			if hg_cool_camera:GetBool() then
				output_ang[3] = output_ang[3] + math.min(diffpos:Dot(output_ang:Right()) * 25 * val,10)
			end
		end
	
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
		pos[3] = tr.HitPos[3] + 1
		local trace = util.TraceLine({start = lply:EyePos(),endpos = pos,filter = ply,mask = MASK_SOLID_BRUSHONLY})
		tr.HitPos[3] = trace.HitPos[3] - 1
		output_pos = tr.HitPos
		output_pos = output_pos
	
		if trZNear.Hit then view.znear = 0.1 else view.znear = 1 end--САСАТЬ!!11.. не работает ;c
	
		output_ang[3] = output_ang[3] + ADDROLL
		
		view.origin = output_pos
		view.angles = output_ang
		view.drawviewer = true
	
		oldview = table.Copy(view)
	
		DRAWMODEL = true
	
		return view
	end
	
	hook.Add("CalcView","VIEW",CalcView)
	
	hide = {
		["CHudHealth"] = true,
		["CHudBattery"] = true,
		["CHudAmmo"] = true,
		["CHudSecondaryAmmo"] = true,
		["CHudCrosshair"] = true,
	}
	hook.Add("HUDShouldDraw","HideHUD",function(name)
		if (hide[name]) then return false end
	end)
	
	
	hook.Add("Think","mouthanim",function()
		for i, ply in pairs(player.GetAll()) do
			local ent = IsValid(ply:GetNWEntity("Ragdoll")) and ply:GetNWEntity("Ragdoll") or ply
	
			local flexes = {
				ent:GetFlexIDByName( "jaw_drop" ),
				ent:GetFlexIDByName( "jaw_clencher" ),
				ent:GetFlexIDByName( "left_part" ),
				ent:GetFlexIDByName( "right_part" ),
				ent:GetFlexIDByName( "left_mouth_drop" ),
				ent:GetFlexIDByName( "right_mouth_drop" )
			}
	
			local weight = ply:IsSpeaking() && math.Clamp( ply:VoiceVolume() * 7, 0, 13 ) || 0
	
			--if (ply:VoiceVolume() * 15) > 10.6 and ply:Alive() and math.random(1,60) == 52 and not ply:IsSuperAdmin() then
			--	net.Start("KubegRubeg")
			--	net.WriteEntity(ply)
			--	net.SendToServer()
			--end
	
			for k, v in pairs( flexes ) do
				if ply:Alive() then
					ent:SetFlexWeight( v, weight )	
				end
			end
		end
	end)
	
	net.Receive("fuckfake",function(len)
	--ply:SetNWEntity("Ragdoll",nil)
	--end)
		for i, ply in pairs(player.GetAll()) do
			if IsValid(ply:GetNWEntity("Ragdoll")) and ply:GetNWEntity("Ragdoll") or ply then
				ply:SetNWEntity("Ragdoll",nil)
			end
		end
	end)
	
	local tab = {
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0.1,
		[ "$pp_colour_brightness" ] = -0.05,
		[ "$pp_colour_contrast" ] = 1.5,
		[ "$pp_colour_colour" ] = 0.3,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0.5
	}
	
	local tab2 = {
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = 1,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}
	
	
	local mat = Material("pp/texturize/plain.png")
	
	local blurMat2, Dynamic2 = Material("pp/blurscreen"), 0
	
	local function BlurScreen(den,alp)
		local layers, density, alpha = 1, den, alph
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(blurMat2)
		local FrameRate, Num, Dark = 1 / FrameTime(), 3, 150
	
		for i = 1, Num do
			blurMat2:SetFloat("$blur", (i / layers) * density * Dynamic2)
			blurMat2:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		end
	
		Dynamic2 = math.Clamp(Dynamic2 + (1 / FrameRate) * 7, 0, 1)
	end
	
	local huy = math.random(1,10)
	local triangle = {
		{ x = 1770, y =	150 },
		{ x = 1820, y = 50 },
		{ x = 1870, y = 150 }
	}
	
	local addmat_r = Material("CA/add_r")
	local addmat_g = Material("CA/add_g")
	local addmat_b = Material("CA/add_b")
	local vgbm = Material("vgui/black")
	
	local function DrawCA(rx, gx, bx, ry, gy, by)
		render.UpdateScreenEffectTexture()
		addmat_r:SetTexture("$basetexture", render.GetScreenEffectTexture())
		addmat_g:SetTexture("$basetexture", render.GetScreenEffectTexture())
		addmat_b:SetTexture("$basetexture", render.GetScreenEffectTexture())
		render.SetMaterial(vgbm)
		render.DrawScreenQuad()
		render.SetMaterial(addmat_r)
		render.DrawScreenQuadEx(-rx / 2, -ry / 2, ScrW() + rx, ScrH() + ry)
		render.SetMaterial(addmat_g)
		render.DrawScreenQuadEx(-gx / 2, -gy / 2, ScrW() + gx, ScrH() + gy)
		render.SetMaterial(addmat_b)
		render.DrawScreenQuadEx(-bx / 2, -by / 2, ScrW() + bx, ScrH() + by)
	end
	
	hook.Add("RenderScreenspaceEffects","BloomEffect-homigrad",function()
		
	
		if not LocalPlayer():Alive() then
			LocalPlayer():SetDSP(1)
		end
	
		if LocalPlayer():Alive() and not LocalPlayer():GetNWBool("DOZER") then
			tab2["$pp_colour_colour"] = LocalPlayer():Health() / 90
			DrawColorModify(tab2)
		end
	
		if !LocalPlayer():Alive() and timer.Exists("DeathCam") then
			DrawMotionBlur(0.5,0.3,0.02)
			DrawSharpen( 1, 0.2 )
			local k3 = 15
			DrawCA(4 * k3, 2 * k3, 0, 2 * k3, 1 * k3, 0)
			tab2["$pp_colour_colour"] = 0.5
			tab2[ "$pp_colour_mulb" ] = 0.5
			DrawColorModify(tab2)
			BlurScreen(1,155)
			draw.Text( {
				text = deathtext,
				font = "BodyCamFont",
				pos = { ScrW()/2, ScrH()/1.2 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color = Color(255,35,35,220)
			} )
			LocalPlayer():SetDSP(15)
		elseif not LocalPlayer():Alive() then
			LocalPlayer():SetDSP(1)
		end
		
	end)
	end