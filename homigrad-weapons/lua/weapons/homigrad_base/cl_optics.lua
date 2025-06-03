function SWEP:GetSightPos()
    local placement = "sight"
    
    if not IsValid(self.worldModel) then
        return Vector(0, 0, 0), Angle(0, 0, 0)
    end
    
    local modeltodraw = self.worldModel
    local tbl = self.Attachments[placement][1] and hg.GetAtt(self.Attachments[placement][1])
    
    local Pos = modeltodraw:GetPos()
    local Ang = modeltodraw:GetAngles()
    
    if self.AttBone then
        local boneIndex = modeltodraw:LookupBone(self.AttBone)
        if boneIndex then
            local boneMatrix = modeltodraw:GetBoneMatrix(boneIndex)
            if boneMatrix then
                Pos = boneMatrix:GetTranslation()
                Ang = boneMatrix:GetAngles()
            end
        end
    end
    
    if self.AttachmentAng and self.AttachmentAng[placement] then
        local aaa = self.AttachmentAng[placement]
        Ang:RotateAroundAxis(Ang:Forward(), aaa[1])
        Ang:RotateAroundAxis(Ang:Right(), aaa[2])
        Ang:RotateAroundAxis(Ang:Up(), aaa[3])
    end
    
    if self.AttachmentPos and self.AttachmentPos[placement] then
        Pos = Pos + Ang:Forward() * self.AttachmentPos[placement][1] + Ang:Right() * self.AttachmentPos[placement][2] + Ang:Up() * self.AttachmentPos[placement][3]
    end
    
    return Pos, Ang
end

local delta = 0

hook.Add("InputMouseApply", "ChangeZoom", function(cmd,x,y,ang)
	local ply = LocalPlayer()

    local tbl = {
        x = x,
        y = y,
        ang = ang
    }

	delta = Lerp(FrameTime() * 5, delta, 0)

	if ply:GetActiveWeapon().IsSighted and ply:GetActiveWeapon():IsSighted() and ply:GetActiveWeapon().Attachments["sight"][1] then
		delta = input.WasMousePressed(MOUSE_WHEEL_UP) and delta + 1 * (FrameTime() / engine.TickInterval()) or input.WasMousePressed(MOUSE_WHEEL_DOWN) and delta - 1 * (FrameTime() / engine.TickInterval()) or delta
		if LocalPlayer():KeyDown(IN_WALK) then
			delta = delta - tbl.y / 24
            //print(delta)
			tbl.y = 0
            return true
            //atstaliy = ang.p
		end
	end
end)

function SWEP:DoHolo(IsRender)
    cam.Start3D()
        local placement = "sight"
        local tbl = hg.GetAtt(self.Attachments[placement][1])
        local mdl = self.AttDrawModels[placement]
        if !IsValid(mdl) then
            cam.End3D()
            return
        end

        if !tbl then
            return
        end

        if !tbl.IsHolo then
            cam.End3D()
            return
        end

        local Pos,Ang = self:GetSightPos()
        
        local material = Material(tbl.Reticle or "empty", "noclamp nocull smooth")
        local size = tbl.ReticleSize or 1
        local pos = mdl:GetPos()
        local ang = mdl:GetAngles()
        local up = ang:Up()
        local right = ang:Right()
        local forward = ang:Forward()

        pos = pos + forward * 100 + up * (tbl.ReticleUp or 0) + right * (tbl.ReticleRight or 0)

        render.UpdateScreenEffectTexture()
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilCompareFunction(STENCIL_ALWAYS)
        render.SetStencilPassOperation(STENCIL_REPLACE)
        render.SetStencilFailOperation(STENCIL_KEEP)
        render.SetStencilZFailOperation(STENCIL_REPLACE)
        render.SetStencilWriteMask(255)
        render.SetStencilTestMask(255)
	    render.DepthRange(0, 0)

        render.SetBlend(0)

        render.SetStencilReferenceValue(1)

        //self:DrawAttachments()

        mdl:SetPos(Pos)
        mdl:SetAngles(Ang)
        mdl:SetRenderAngles(Ang)
        mdl:SetRenderOrigin(Pos)
        mdl:SetPredictable(true)
        mdl:SetupBones()
        
        if IsRender then
            mdl:DrawModel()
        end
        
        render.SetBlend(1)

        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilCompareFunction(STENCIL_EQUAL)

	    render.SetMaterial(material or Material("empty"))
        
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilPassOperation(STENCIL_KEEP)
        
        render.SetMaterial(material)
        render.DrawQuad(
        	pos + (up * size / 2) - (right * size / 2),
        	pos + (up * size / 2) + (right * size / 2),
        	pos - (up * size / 2) + (right * size / 2),
        	pos - (up * size / 2) - (right * size / 2),
        Color(255,255,255,255)
        )

        render.DepthRange(0, 1)
        render.SetStencilEnable(false)
    cam.End3D()
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

local rt_size = 512
local rt_mat_shit = GetRenderTarget("rt-z-glass", rt_size, rt_size, false)
local rt_mat = Material("rt-z-glass")

function SWEP:DoRT()
    if !self.Attachments["sight"][1] then return end
    if !hg.GetAtt(self.Attachments["sight"][1]).IsOptic then return end
    local view = render.GetViewSetup(true)

    local att = hg.GetAtt(self.Attachments["sight"][1])

    local mdl = self.AttDrawModels["sight"]

    local pos = mdl:GetPos()
    local angg = mdl:GetPos()
    local _,ang = self:GetTrace()
    ang = ang + att.ScopeAng

    att.Fov = math.Clamp(att.Fov - (delta / 10 or 0), att.MaxFov, att.MinFov)

    pos = pos + ang:Forward() * att.ScopePos[1] + ang:Right() * att.ScopePos[2] + ang:Up() * att.ScopePos[3]

    Material(att.Mat):SetTexture("$basetexture", rt_mat_shit)

    local rt = {
		x = 0,
		y = 0,
		w = rt_size,
		h = rt_size,
		angles = ang,
		origin = pos,
		drawviewmodel = false,
		fov = att.Fov,
		znear = 1,
		zfar = 16000,
		bloomtone = true
	}

    local diff, point = util.DistanceToLine(view.origin, view.origin + ang:Forward() * 50, pos)
	local scope_pos = WorldToLocal(point, Angle(0, 0, 0), pos, view.angles)

    local xx = pos:ToScreen()

    //render.DrawLine(scope_pos,point, Color( 255, 255, 255 ))

    local scrw, scrh = ScrW(), ScrH()
	local scr1 = pos:ToScreen()
	local scr2 = point:ToScreen()
	local diffa = Vector((scr1.x-scr2.x)/scrw,(scr1.y-scr2.y)/scrh)
	
	render.PushRenderTarget(rt_mat_shit, 0, 0, rt_size, rt_size)
	render.Clear(1, 1, 1, 1)
	local old = DisableClipping(true)

	diffa[1] = diffa[1] * ScrW() * 2
	diffa[2] = diffa[2] * ScrH() * 2
	
	if diffa:LengthSqr() < 2000.0 * (rt_size / 512) / (att.BlackScope / 400) then
		
		render.RenderView(rt)
		
		cam.Start3D()
			local aimWay = (ang:Forward()) * 10000000000
			local toscreen = aimWay:ToScreen()
			local x, y = toscreen.x, toscreen.y
			local hitPos
            //if GetConVar("hg_show_hitposmuzzle"):GetBool() then
                local pos,ang = self:GetTrace()
                local trr = {
                    start = pos,
                    endpos = pos + ang:Forward() * 100000,
                    filter = {LocalPlayer()}
                }
                local tr = util.TraceLine(trr)
				hitPos = tr.HitPos:ToScreen()
			//end
		cam.End3D()
		
		local distMul = 1.2
		local dist = math.sqrt(((x - scrw / 2) * distMul)^2 + ((y - scrh / 2) * distMul)^2)
		
		if dist > 850 * distMul then render.Clear(1, 1, 1, 1) end
		
		cam.Start2D()
            if GetConVar("hg_show_hitposmuzzle"):GetBool() then
		    	draw.RoundedBox(0, hitPos.x / (scrw / ScrW()) - 12, hitPos.y / (scrh / ScrH()) - 12, 24, 24, Color(255,0,0))
		    end
            //print((att.MaxFov - att.Fov / att.MaxFov))
            //print(rt_size / 512 + 512 * math.Clamp((att.MaxFov - att.Fov / att.MaxFov * 0.65),0.7,att.MaxFov))
            local siz = att.ReticleSize * (rt_size / 512 + 512 * math.Clamp((att.MaxFov - att.Fov / att.MaxFov * 0.65),0.7,att.MaxFov))
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material(att.Reticle))
			surface.DrawTexturedRectRotatedHuy(0, 0, siz, siz, 0, -diffa[2] * distMul + rt_size / 2, -diffa[1] * distMul + rt_size / 2)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetMaterial(Material(att.BlackMat))
			surface.DrawTexturedRectRotatedHuy(0, 0, att.BlackSize * rt_size / 512 + 512, att.BlackSize * rt_size / 512 + 512, 0, (ScrH() - y / (scrh / ScrH()) - rt_size / 2) * distMul * 25 + rt_size / 2, (ScrW() - x / (scrw / ScrW()) - rt_size / 2) * distMul * 25 + rt_size / 2)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetMaterial(Material(att.BlackMat))
			surface.DrawTexturedRectRotatedHuy(0, 0, att.BlackSize * rt_size / 512 + 512, att.BlackSize * rt_size / 512 + 512, 0, (y / (scrh / ScrH()) - rt_size / 2) * distMul * 25 + rt_size / 2, (x / (scrw / ScrW()) - rt_size / 2) * distMul * 25 + rt_size / 2)
			surface.DrawTexturedRectRotatedHuy(0, 0, att.BlackSize * rt_size / 512 + 512, att.BlackSize * rt_size / 512 + 512, 0, -diffa[2] * 15 * distMul + rt_size / 2, -diffa[1] * 15 * distMul + rt_size / 2)
		cam.End2D()
	end

	DisableClipping(old)
	render.PopRenderTarget()
end

hook.Add("HUDPaint","holo",function() //как я додумался? не спрашивайте,но оно рендерит блять.
    local ply = LocalPlayer()
    if ply:GetActiveWeapon().ishgwep then
        ply:GetActiveWeapon():DoHolo(true)
        ply:GetActiveWeapon():DoRT()
    end
end)

hook.Add("AdjustMouseSensitivity","Homigrad-Camera",function()
	local lply = LocalPlayer()

	vis_recoil = LerpFT(0.075,vis_recoil,0)

	if !lply:Alive() then
		return 1
	end

	local wep = lply:GetActiveWeapon()

	if wep.IsSighted and wep:IsSighted() then
		return (wep.Attachments["sight"][1] and wep.Attachments["sight"][1].IsOptic and math.Clamp(0.05 * wep.Attachments["sight"][1].Fov,0.1,0.4) or 0.5)
	end
	
	return 1
end)