AddCSLuaFile()

local cam = cam
local render = render
local surface = surface
local CurTime = CurTime
local IsValid = IsValid

ENT.Type = "anim"
ENT.Spawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Player" )
	self:NetworkVar( "String", 0, "ID")
	self:NetworkVar( "Bool", 0, "ShowID")
end

function ENT:Initialize()
	if ( SERVER ) then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_NONE )
		self:DrawShadow( false )

		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:Wake()
			phys:EnableMotion(false)
		end
	end
end

function ENT:FindCamera()
	if IsValid(self.camera) then return self.camera end
	local myID = self:GetID()
	for k,v in ipairs(ents.FindByClass('gmod_rtcameraprop')) do
		if v:GetID() == myID then
			self.camera = v
			return v
		end
	end
	self.camera = NULL
	return NULL
end

if CLIENT then
	surface.CreateFont('rtcamFont', {
		font = 'Courier New',
		size = 50,
		weight = 400,
		shadow = true
	})

	function ENT:FindTarget()
		local target = self.target
		if not target then
			target = rtcam.getTarget(self:GetID())
			self.target = target
		end
		return target
	end

	local drawing = false
	local nextDrawTime = CurTime()
	hook.Add('ShouldDrawLocalPlayer', 'p-rt-camera.rttv', function()
		if drawing then return true end
		--return drawing
	end)

	hook.Add('PreRender', 'p-rt-render-stuff', function()
		if nextDrawTime > CurTime() then return end
		nextDrawTime = CurTime()

		local LocalPlayer = LocalPlayer()

		for k, self in ipairs(ents.FindByClass('gmod_rttv')) do
			local distSqr = self:GetPos():DistToSqr(LocalPlayer:GetPos())
			self.shouldDraw = distSqr < GetConVarNumber("prtcamera_drawRange", 5000) * GetConVarNumber("prtcamera_drawRange", 5000)
			if not self.shouldDraw then
				if self.target then
					rtcam.releaseTarget(self.target)
					self.target = nil
				end
				continue
			end

			local target = self:FindTarget()
			if target.nextUpdate and target.nextUpdate > CurTime() then continue end
			target.nextUpdate = CurTime() + ( 1 / GetConVarNumber("prtcamera_refreshRate", 10) )

			local screenRt = render.GetRenderTarget()
			local oldScrW, oldScrH = ScrW(), ScrH()
			render.SetRenderTarget(target.rt)
			render.SetViewPort(0, 0, 512, 512)

			local camera = self:FindCamera()
			if IsValid(self.camera) then
				camera:SetNoDraw(true)

				cam.Start3D(LocalPlayer:GetPos(), LocalPlayer:EyeAngles(), camera:GetFOV())

				drawing = true
				render.OverrideAlphaWriteEnable(true, true)
				render.RenderView( {
					origin = camera:GetPos(),
					angles = camera:GetAngles(),
					x = 0,
					y = 0,
					w = ScrW(),
					h = ScrH(),
					fov = camera:GetFOV(),
					drawviewmodel = false,
				})
				drawing = false

				cam.End3D()
				camera:SetNoDraw(false)
			else
				surface.SetDrawColor(40, 40, 40)
				surface.DrawRect(0, 0, ScrW(), ScrH())
			end

			render.SetRenderTarget(screenRt)
			render.SetViewPort(0, 0, oldScrW, oldScrH)
		end
	end)

	function ENT:OnRemove()
		if self.target then
			rtcam.releaseTarget(self.target)
		end
	end

	function ENT:Draw()
		local meta = self.meta
		if not meta then
			self.meta = list.Get('RTMonitorModels')[self:GetModel()]
			meta = self.meta
		end
		self:DrawModel()

		if meta and self.shouldDraw then
			local target = self:FindTarget()
			if target then

				--TODO: Finish this!
				--if ( GetConVarNumber( "prtcamera_drawScreens" ) == 0 ) and (if self:GetNWString("owner", nil) != client:Name()) then return end
				--if (GetConVarNumber("prtcamera_drawSelfScreens") == 0) then return end
				if (GetConVarNumber("prtcamera_drawScreens") == 0) then return end

				cam.Start3D2D(self:LocalToWorld(meta.offset), self:LocalToWorldAngles(meta.ang), meta.scale)
					surface.SetDrawColor(255, 255, 255)
					target.mat:SetTexture('$basetexture', target.rt)
					surface.SetMaterial(target.mat)
					surface.DrawTexturedRect(-256 * meta.ratio, -256, 512 * meta.ratio, 512)

					if self:GetShowID() then
						draw.SimpleText(self:GetID(), 'rtcamFont', -256 * meta.ratio + 30, -256 + 30, color_white, 0, 0, TEXT_ALIGN_LEFT)
					end

				cam.End3D2D()
				
			end
		end
	end
end

if SERVER then
	hook.Add('SetupPlayerVisibility', 'cam_pvs', function(ply, viewEntity)
		local plyPos = ply:GetPos()
		local curDistance = math.huge
		local curTV = nil

		for k,v in ipairs(ents.FindInSphere(ply:GetPos(), GetConVarNumber("prtcamera_drawRange", 500))) do
			if v:GetClass() == 'gmod_rttv' then
				local d = plyPos:DistToSqr(v:GetPos())
				if d < curDistance then
					curTV = v
					curDistance = d
				end
			end
		end

		if curTV then
			if (GetConVarNumber("prtcamera_pvs") == 0) then return end
			local camera = curTV:FindCamera()
			if not IsValid(camera) then return end
			AddOriginToPVS(camera:GetPos())
		end
	end)
end