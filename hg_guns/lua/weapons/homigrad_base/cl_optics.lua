-- cl_optics.lua"

AddCSLuaFile()
--
local delta = 0
function SWEP:InitializePost()
	hook.Add("CreateMove", "ChangeZoom", function(cmd)
		if LocalPlayer():KeyDown(IN_WALK) then delta = delta - cmd:GetMouseY() / 6 end
		delta = input.WasMousePressed(MOUSE_WHEEL_UP) and delta + 1 or input.WasMousePressed(MOUSE_WHEEL_DOWN) and delta - 1 or delta
		delta = LerpFT(0.1, delta, 0)
	end)
end

hook.Add("CreateMove", "ChangeZoom", function(cmd)
	if LocalPlayer():KeyDown(IN_WALK) then delta = delta - cmd:GetMouseY() / 6 end
	delta = input.WasMousePressed(MOUSE_WHEEL_UP) and delta + 1 * (FrameTime() / engine.TickInterval()) or input.WasMousePressed(MOUSE_WHEEL_DOWN) and delta - 1 * (FrameTime() / engine.TickInterval()) or delta
	delta = LerpFT(0.1 / (FrameTime() / engine.TickInterval()), delta, 0)
end)

local rtsize = 512
local rtmat = GetRenderTarget("huy-glass", rtsize, rtsize, false)
local mat = Material("huy-glass")
local mat2 = Material("huy-glass")
SWEP.scopemat = Material("decals/scope.png")
SWEP.perekrestie = Material("decals/perekrestie3.png")
local limit = 1
local vecVel = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local vecZero = Vector(0, 0, 0)
SWEP.localScopePos = Vector(-21, 3.95, -0.2)
SWEP.scope_blackout = 400
SWEP.maxzoom = 3.5
SWEP.rot = 37
SWEP.FOVMin = 3.5
SWEP.FOVMax = 10
SWEP.blackoutsize = 2500
function surface.DrawTexturedRectRotatedHuy(x, y, w, h, rot, offsetX, offsetY, rotHuy)
	rotHuy = rotHuy or 0
	local newX = x + offsetX * math.sin(math.rad(rot))
	local newY = x + offsetX * math.cos(math.rad(rot))
	local newX = newX + offsetY * math.cos(math.rad(rot))
	local newY = newY - offsetY * math.sin(math.rad(rot))
	surface.DrawTexturedRectRotated(newX, newY, w, h, rot + rotHuy)
end

function surface.DrawTexturedRectRotatedPoint(x, y, w, h, rot, x0, y0)
	local c = math.cos(math.rad(rot))
	local s = math.sin(math.rad(rot))
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s
	surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
end

local addmat_r = Material("CA/add_r")
local addmat_g = Material("CA/add_g")
local addmat_b = Material("CA/add_b")
local vgbm = Material("vgui/black")
local function DrawCA(rx, gx, bx, ry, gy, by, mater)
	render.UpdateScreenEffectTexture()
	addmat_r:SetTexture("$basetexture", mater)
	addmat_g:SetTexture("$basetexture", mater)
	addmat_b:SetTexture("$basetexture", mater)
	render.SetMaterial(vgbm)
	render.DrawScreenQuad()
	render.SetMaterial(addmat_r)
	render.DrawScreenQuadEx(-rx / 2, -ry / 2, ScrW() + rx, ScrH() + ry)
	render.SetMaterial(addmat_g)
	render.DrawScreenQuadEx(-gx / 2, -gy / 2, ScrW() + gx, ScrH() + gy)
	render.SetMaterial(addmat_b)
	render.DrawScreenQuadEx(-bx / 2, -by / 2, ScrW() + bx, ScrH() + by)
end

function SWEP:DoRT()
	local lply = LocalPlayer()
	local gun = self:GetWeaponEntity()
	local att = self:GetMuzzleAtt(gun, true)
	if not att then return end
	if not self.sizeperekrestie then return end
	local ang = att.Ang
	local pos = att.Pos
	if string.find(self.attachments.sight[1], "optic") and not string.find(self.attachments.sight[1], "0") and self.modelAtt and IsValid(self.modelAtt.sight) then pos = self.modelAtt.sight:GetPos() end
	local localPos = vecZero
	localPos:Set(self.localScopePos)
	localPos:Rotate(ang)
	pos:Add(localPos)
	local view = render.GetViewSetup(true)
	local diff, point = util.DistanceToLine(view.origin, view.origin + ang:Forward() * 50, pos)
	local scope_pos = WorldToLocal(point, Angle(0, 0, 0), pos, view.angles)
	local mat = self.mat or mat2
	mat:SetTexture("$basetexture", rtmat)
	--[[cam.Start3D()
        render.DrawLine(pos,point, Color( 255, 255, 255 ))
    cam.End3D()]]--
	local tr = util.TraceLine({
		start = pos - ang:Forward() * 50,
		endpos = pos + ang:Forward() * 50,
		filter = {lply, gun, lply.FakeRagdoll}
	})

	local firstPerson = lply == GetViewEntity()
	ang:RotateAroundAxis(ang:Forward(), -90)
	view.angles:RotateAroundAxis(view.angles:Right(), -0.10)
	ang:RotateAroundAxis(view.angles:Right(), -0.10)
	view.angles[3] = view.angles[3]
	local localhuy = pos - view.origin
	local anghuy = localhuy:Angle()
	--local dist = localhuy:Length()
	anghuy[3] = self.rot + ang[3]
	--dist = math.Clamp(dist,0,1.5)
	local rt = {
		x = 0,
		y = 0,
		w = rtsize,
		h = rtsize,
		angles = anghuy,
		origin = pos,
		drawviewmodel = false,
		fov = self.ZoomFOV,
		znear = 1,
		zfar = 16000,
		bloomtone = true
	}

	ang[3] = ang[3] + 101
	local scrw, scrh = ScrW(), ScrH() --retarded
	--render.RenderView(rt)
	render.PushRenderTarget(rtmat, 0, 0, rtsize, rtsize)
	render.Clear(1, 1, 1, 1)
	local old = DisableClipping(true)
	if diff < 1.0 * (rtsize / 512) / (self.scope_blackout / 400) then
		render.RenderView(rt)
		cam.Start3D()
			local aimWay = ang:Forward() * 10000000000
			local toscreen = aimWay:ToScreen()
			local x, y = toscreen.x, toscreen.y
		cam.End3D()
		
		local distMul = 6
		local dist = math.sqrt(((x - scrw / 2) * distMul)^2 + ((y - scrh / 2) * distMul)^2)
		
		if dist > 350 * distMul then render.Clear(1, 1, 1, 1) end
		
		cam.Start2D()
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.perekrestie)
		surface.DrawTexturedRectRotatedHuy(0, 0, (self.sizeperekrestie * rtsize / 512) / (self.perekrestieSize and 4 or self.ZoomFOV / 3), (self.sizeperekrestie * rtsize / 512) / (self.perekrestieSize and 4 or self.ZoomFOV / 3), 0, y / (scrh / ScrH()), x / (scrw / ScrW()), self.rot)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetMaterial(self.scopemat)
		surface.DrawTexturedRectRotatedHuy(0, 0, self.blackoutsize * rtsize / 512 + 512, self.blackoutsize * rtsize / 512 + 512, 0, (ScrH() - y / (scrh / ScrH()) - rtsize / 2) * distMul + rtsize / 2, (ScrW() - x / (scrw / ScrW()) - rtsize / 2) * distMul + rtsize / 2)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetMaterial(self.scopemat)
		surface.DrawTexturedRectRotatedHuy(rtsize / 2, rtsize / 2, self.blackoutsize * rtsize / 512 + 100, self.blackoutsize * rtsize / 512 + 100, self.rot, -scope_pos[3] * (self.scope_blackout * self.blackoutsize / 4000), -scope_pos[2] * (self.scope_blackout * self.blackoutsize / 4000))
		cam.End2D()
	end

	DisableClipping(old)
	render.PopRenderTarget()
end

function SWEP:ChangeFOV()
	self.ZoomFOV = math.Clamp(self.ZoomFOV - (delta / 10 or 0), self.FOVMin, self.FOVMax)
end

--
local vecZero = Vector(0, 0, 0)
local function WorldToScreen(vWorldPos, vPos, vScale, aRot, verticalScale)
	local vWorldPos = vWorldPos - vPos
	vWorldPos:Rotate(Angle(0, -aRot.y, 0))
	vWorldPos:Rotate(Angle(-aRot.p, 0, 0))
	vWorldPos:Rotate(Angle(0, 0, -aRot.r))
	return vWorldPos.x / vScale, (-vWorldPos.y) / (vScale * verticalScale)
end

SWEP.size = 0.0007
SWEP.holo_pos = Vector(-0.82, 3.48, 25)
SWEP.holo = Material("holo/huy-holo2.png")
SWEP.scale = Vector(1, 1.3, 1)
function SWEP:DoHolo()
	local gun = self:GetWeaponEntity()
	local lply = LocalPlayer()
	local att = self:GetMuzzleAtt(gun, true)
	if not att then return end
	local pos, ang = att.Pos, att.Ang
	local holosight = self.attachments.sight[1] and string.find(self.attachments.sight[1], "holo") and (self.modelAtt and self.modelAtt.sight)
	if holosight then
		pos = holosight:GetPos()
		--ang = holosight:GetAngles()
	end

	local eye = render.GetViewSetup(true)
	local eyePos, eyeAng = eye.origin, eye.angles
	ang = eyeAng
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	local atta = att --self:GetMuzzleAtt(gun,true)
	local posa, anga = atta.Pos, atta.Ang
	if holosight then
		posa = holosight:GetPos()
		--anga = holosight:GetAngles()
	end

	local hitPos = eyePos + anga:Forward() * 2624
	anga:RotateAroundAxis(anga:Right(), 90)
	local vec = vecZero
	vec:Set(self.holo_pos)
	vec:Rotate(anga)
	pos:Add(vec)
	local dist = pos:Distance(eyePos) / 10
	dist = dist * (self.holo_size or 1)
	local x, y = WorldToScreen(hitPos, pos, self.size, anga, self.scale[2])
	local m = Matrix()
	m:Scale(self.scale)
	cam.Start3D()
	cam.Start3D2D(pos, anga, self.size)
	cam.PushModelMatrix(m, true)
	--[[surface.SetDrawColor(0, 255, 0, 255)
	surface.SetMaterial( Material( "models/wireframe" ) )
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())]]--
	surface.SetMaterial(self.holo)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(x - 200 * dist * self.scale[2], y - 200 * dist, 400 * dist * self.scale[2], 400 * dist)
	cam.PopModelMatrix()
	cam.End3D2D()
	cam.End3D()
end