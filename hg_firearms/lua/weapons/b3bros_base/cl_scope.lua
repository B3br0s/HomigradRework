local rtsize = 512
local rtmat = GetRenderTarget("huy-glass", rtsize, rtsize, false)
local mat = Material("effects/arc9/rt")
local mat2 = Material("effects/arc9/rt")
SWEP.scopemat = Material("decals/scope.png")
SWEP.perekrestie = Material("decals/perekrestie3.png")
local limit = 1
local vecVel = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local vecZero = Vector(0, 0, 0)
SWEP.scope_blackout = 400
SWEP.maxzoom = 3.5
SWEP.rot = 90
SWEP.aimOffset = Angle(0,0,0)
SWEP.FOVMin = 3.5
SWEP.FOVMax = 10
SWEP.blackoutsize = 2500

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


function SWEP:DoRT()
	local lply = LocalPlayer()
	local gun = self.ClientModel
	local att = self:GetOwner():GetAttachment(self:GetOwner():LookupAttachment("anim_attachment_rh"))
	if not att then return end
	if not self.sizeperekrestie then return end
	local ang = gun:GetAngles()
	local pos = gun:GetPos()
	local pos2 = att.Pos
	pos = self:GetNWVector("PositionSight")
	local localPos = vecZero
	localPos:Set(self.localScopePos)
	localPos:Rotate(ang)
	pos:Add(localPos)
	pos2 = att.Pos + ang:Up() * self.OffsetDamnPricel[1] - ang:Forward() * self.OffsetDamnPricel[2] + ang:Right() * self.OffsetDamnPricel[3]
	pos2:Add(localPos)
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
		origin = pos2,
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
	--render.Clear(1, 1, 1, 1)
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
		
		if dist > 5500 * distMul then render.Clear(1, 1, 1, 1) end
		
		cam.Start2D()
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.perekrestie)
		surface.DrawTexturedRectRotatedHuy(0, 0, (self.sizeperekrestie * rtsize / 512) / (self.perekrestieSize and 4 or self.ZoomFOV / 3), (self.sizeperekrestie * rtsize / 512) / (self.perekrestieSize and 4 or self.ZoomFOV / 3), 0, y / (scrh / ScrH())  + (self.ReticleUp), x / (scrw / ScrW()) + (self.ReticleRight), 0)
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