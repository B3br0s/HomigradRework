function SWEP:DoHolo()
    cam.Start3D()
        local tbl = self.Attachments["sight"]
        local mdl = self.AttDrawModels["sight"]
        if !IsValid(mdl) then
            cam.End3D()
            return
        end
        
        local material = Material(tbl.Reticle or "empty", "noclamp nocull smooth")
        local size = tbl.ReticleSize or 1
        local pos = mdl:GetPos()
        local ang = mdl:GetAngles()
        local up = ang:Up()
        local right = ang:Right()
        local forward = ang:Forward()

        local Pos = self.worldModel:GetPos()
        local Ang = self.worldModel:GetAngles()

        Ang:RotateAroundAxis(Ang:Forward(),tbl.CorrectAng[1])
        Ang:RotateAroundAxis(Ang:Right(),tbl.CorrectAng[2])
        Ang:RotateAroundAxis(Ang:Up(),tbl.CorrectAng[3])
        mdl:SetModelScale(tbl.CorrectSize,0)
        mdl:SetOwner(ply)
        mdl:SetParent(ply)
        mdl:SetPredictable(true)
        Pos = self.worldModel:GetPos() + Ang:Forward() * tbl.CorrectPos[1] + Ang:Right() * tbl.CorrectPos[2] + Ang:Up() * tbl.CorrectPos[3]
        Pos = Pos + Ang:Forward() * self.AttachmentPos["sight"][1] + Ang:Right() * self.AttachmentPos["sight"][2] + Ang:Up() * self.AttachmentPos["sight"][3]

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

        mdl:SetPos(Pos)
        mdl:SetAngles(Ang)
                
        mdl:SetRenderAngles(Ang)
        mdl:SetRenderOrigin(Pos)
        mdl:DrawModel()
        
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

hook.Add("PostDrawOpaqueRenderables","Holo_Draw",function()
    local ply = LocalPlayer()
    if ply:GetActiveWeapon().ishgweapon then
        local self = ply:GetActiveWeapon()
        for placement, att in pairs(self.Attachments) do
        	if self.Attachments[placement] != NULL then
				if self.Attachments[placement].IsHolo then
					self:DoHolo()
				end
			end
		end
    end
end)

hook.Add("RenderScene","Holo_Draw",function()
    local ply = LocalPlayer()
    if ply:GetActiveWeapon().ishgweapon then
        local self = ply:GetActiveWeapon()
        for placement, att in pairs(self.Attachments) do
        	if self.Attachments[placement] != NULL then
				if self.Attachments[placement].IsHolo then
					self:DoHolo()
				end
			end
		end
    end
end)