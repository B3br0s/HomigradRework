JMod.NukeFlashEndTime = 0
JMod.NukeFlashPos = nil
JMod.NukeFlashRange = 0
JMod.NukeFlashIntensity = 1
JMod.NukeFlashSmokeEndTime = 0
JMod.Wind = JMod.Wind or Vector(0, 0, 0)

JMod.LuaConfig = JMod.LuaConfig or {}
JMod.LuaConfig.ArmorOffsets = {}

surface.CreateFont("JMod-Display", {
	font = "Arial",
	extended = false,
	size = 35,
	weight = 900,
	blursize = 0,
	scanlines = 4,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-Display-L", {
	font = "Arial",
	extended = false,
	size = 60,
	weight = 900,
	blursize = 0,
	scanlines = 4,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-NumberLCD", {
	font = "ds-digital bold",
	extended = false,
	size = 35,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-Display-S", {
	font = "Arial",
	extended = false,
	size = 20,
	weight = 900,
	blursize = 0,
	scanlines = 4,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-Display-XS", {
	font = "Arial",
	extended = false,
	size = 15,
	weight = 900,
	blursize = 0,
	scanlines = 4,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-Stencil", {
	font = "capture it",
	extended = false,
	size = 60,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-Stencil-MS", {
	font = "capture it",
	extended = false,
	size = 40,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-Stencil-S", {
	font = "capture it",
	extended = false,
	size = 20,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-Stencil-XS", {
	font = "capture it",
	extended = false,
	size = 10,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-SharpieHandwriting", {
	font = "handwriting",
	extended = false,
	size = 40,
	weight = 900,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-Debug", {
	font = "Arial",
	extended = false,
	size = 120,
	weight = 900,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("JMod-Debug-S", {
	font = "Arial",
	extended = false,
	size = 60,
	weight = 900,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

local function CreateClientLag(amt)
	local W, H = ScrW(), ScrH()

	for i = 0, amt do
		draw.SimpleText("LAG", "DermaDefault", math.random(W * .4, W * .6), math.random(H * .8, H * .9), Color(255, 0, 0, 255 * math.Rand(0, 1) ^ 10), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

local WindChange, NextThink = Vector(0, 0, 0), 0
local Count, Sum = 0, 0

hook.Add("Think", "JMOD_CLIENT_THINK", function()
	--[[
	local dlight=DynamicLight( LocalPlayer():EntIndex() )
	if ( dlight ) then
		dlight.pos=LocalPlayer():GetShootPos()
		dlight.r=255
		dlight.g=255
		dlight.b=255
		dlight.brightness=5
		dlight.Decay=1000
		dlight.Size=25600
		dlight.DieTime=CurTime()+1
	end
	--]]
	local Time = CurTime()
	local ply, DrawNVGlamp = LocalPlayer(), false

	if not ply:ShouldDrawLocalPlayer() then
		if ply:Alive() and JMod.PlyHasArmorEff(ply) then
			local ArmorEffects = ply.EZarmor.effects
			if ArmorEffects.nightVision or ArmorEffects.nightVisionWP then
				DrawNVGlamp = true

				if not IsValid(ply.EZNVGlamp) then
					ply.EZNVGlamp = ProjectedTexture()
					ply.EZNVGlamp:SetTexture("effects/flashlight001")
					ply.EZNVGlamp:SetBrightness(.025)
				else
					local Dir = ply:GetAimVector()
					local Ang = Dir:Angle()
					ply.EZNVGlamp:SetPos(EyePos() + Dir * 10)
					ply.EZNVGlamp:SetAngles(Ang)
					ply.EZNVGlamp:SetConstantAttenuation(.2)
					local FoV = ply:GetFOV()
					ply.EZNVGlamp:SetFOV(FoV)
					ply.EZNVGlamp:SetFarZ(150000 / FoV)
					ply.EZNVGlamp:Update()
				end
			end
		end
	end

	if not DrawNVGlamp then
		if IsValid(ply.EZNVGlamp) then
			ply.EZNVGlamp:Remove()
		end
	end

	if NextThink > Time then return end
	NextThink = Time + 5
	JMod.Wind = GetGlobal2Vector("JMod_Wind", JMod.Wind)
end)

local WDir = VectorRand()

hook.Add("CreateMove", "ParachuteShake", function(cmd)
	local Ply = LocalPlayer()
	if not Ply:Alive() then return end

	if Ply:GetNW2Bool("EZparachuting", false) then
		local Amt, Sporadicness, FT = 30, 20, FrameTime()

		if Ply:KeyDown(IN_FORWARD) then
			Sporadicness = Sporadicness * 1.5
			Amt = Amt * 2
		end

		local S, EAng = .05, cmd:GetViewAngles()
		--(JMod.Wind + EAng:Forward())
		WDir = (WDir + FT * VectorRand() * Sporadicness):GetNormalized()
		EAng.pitch = math.NormalizeAngle(EAng.pitch + math.sin(RealTime() * 2) * 0.02)
		Ply.LerpedYaw = math.ApproachAngle(Ply.LerpedYaw, EAng.y, FT * 120)
		EAng.yaw = Ply.LerpedYaw + math.NormalizeAngle(WDir.x * FT * Amt * S)
		cmd:SetViewAngles(EAng)
	else
		Ply.LerpedYaw = cmd:GetViewAngles().y
	end
end)

--[[
	Sum=Sum+(1/FrameTime())
	Count=Count+1
	if(Count>=100)then
		LocalPlayer():ChatPrint(tostring(math.Round(Sum/100)))
		Count=0
		Sum=0
	end
	--]]
local BeamMat = CreateMaterial("xeno/beamgauss", "UnlitGeneric", {
	["$basetexture"] = "sprites/spotlight",
	["$additive"] = "1",
	["$vertexcolor"] = "1",
	["$vertexalpha"] = "1",
})

local GlowSprite, KnownSLAMs, NextSlamScan = Material("sprites/mat_jack_basicglow"), {}, 0
local ThermalGlowMat = Material("models/debug/debugwhite")

hook.Add("PostDrawTranslucentRenderables", "JMOD_POSTDRAWTRANSLUCENTRENDERABLES", function()
	local Time = CurTime()

	if Time > NextSlamScan then
		NextSlamScan = Time + .5
		KnownSLAMs = ents.FindByClass("ent_jack_gmod_ezslam")
	end

	for k, ent in pairs(KnownSLAMs) do
		if IsValid(ent) then
			local pos = ent:GetAttachment(1).Pos

			if pos then
				local trace = util.QuickTrace(pos, ent:GetUp() * 1000, ent)
				local State, Vary = ent:GetState(), math.sin(CurTime() * 50) / 2 + .5
				local Forward = -ent:GetUp()
				pos = pos - Forward * .5

				if State == JMod.EZ_STATE_ARMING then
					render.SetMaterial(GlowSprite)
					render.DrawSprite(pos, 15, 15, Color(255, 0, 0, 100 * Vary))
					render.DrawSprite(pos, 7, 7, Color(255, 255, 255, 100 * Vary))
					render.DrawQuadEasy(pos, Forward, 15, 15, Color(255, 0, 0, 100 * Vary), 0)
					render.DrawQuadEasy(pos, Forward, 7, 7, Color(255, 255, 255, 100 * Vary), 0)
				elseif State == JMod.EZ_STATE_ARMED then
					render.SetMaterial(BeamMat)
					render.DrawBeam(pos, trace.HitPos, 0.2, 0, 255, Color(255, 0, 0, 30))

					if trace.Hit then
						render.SetMaterial(GlowSprite)
						render.DrawSprite(trace.HitPos, 8, 8, Color(255, 0, 0, 100))
						render.DrawSprite(trace.HitPos, 4, 4, Color(255, 255, 255, 100))
						render.DrawQuadEasy(trace.HitPos, trace.HitNormal, 15, 15, Color(255, 0, 0, 100), 0)
						render.DrawQuadEasy(trace.HitPos, trace.HitNormal, 7, 7, Color(255, 255, 255, 100), 0)
					end
				end
			end
		end
	end
end)

function JMod.MakeModel(self, mdl, mat, scale, col)
	local Mdl = ClientsideModel(mdl)

	if mat then
		if isnumber(mat) then
			Mdl:SetSkin(mat)
		else
			Mdl:SetMaterial(mat)
		end
	end

	if scale then
		Mdl:SetModelScale(scale, 0)
	end

	if col then
		Mdl:SetColor(col)
	end

	Mdl:SetPos(self:GetPos())
	Mdl:SetParent(self)
	Mdl:SetNoDraw(true)
	-- store this on a table for cleanup later
	self.CSmodels = self.CSmodels or {}
	table.insert(self.CSmodels, Mdl)

	return Mdl
end

function JMod.RenderModel(mdl, pos, ang, scale, color, mat, fullbright, translucency)
	if not IsValid(mdl) then return end
	--mdl:SetupBones()

	if pos then
		mdl:SetRenderOrigin(pos)
	end

	if ang then
		mdl:SetRenderAngles(ang)
	end

	if scale then
		local Matricks = Matrix()
		Matricks:Scale(scale)
		mdl:EnableMatrix("RenderMultiply", Matricks)
	end

	local R, G, B = render.GetColorModulation()
	local RenderCol = color or Vector(1, 1, 1)
	render.SetColorModulation(RenderCol.x, RenderCol.y, RenderCol.z)

	if mat and not(tonumber(mat)) then
		render.ModelMaterialOverride(mat)
	end

	if fullbright then
		render.SuppressEngineLighting(true)
	end

	if translucenty then
		render.SetBlend(translucency)
	end

	--mdl:SetLOD(8)
	mdl:DrawModel()
	render.SetColorModulation(R, G, B)
	render.ModelMaterialOverride(nil)
	render.SuppressEngineLighting(false)
	render.SetBlend(1)
end