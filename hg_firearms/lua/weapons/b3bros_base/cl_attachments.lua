local function GetHolo(num, info)
    if num > 1 then
        for i = 1, num do
            if info[i] and info[i].Holo then
                return i
            end
        end
    else
        if info[1] and info[1].Holo then
            return 1
        end
    end
    return nil
end

hook.Add("PostDrawOpaqueRenderables", "HoloGraph", function()
    local ply = LocalPlayer()
    local weapon = ply:GetActiveWeapon()
    local sightsam = weapon.SightModel
    if not IsValid(sightsam) then return end
    local infoatt = weapon.CurrentAtt
    local holographnum = GetHolo(#infoatt,infoatt)
    if holographnum == nil then return end
    if not IsValid(weapon) or not weapon.HasSight or not infoatt[holographnum].Holo or ply:GetMoveType() == MOVETYPE_NOCLIP then return end
    local material = Material(infoatt[GetHolo(#infoatt,infoatt)].ReticleMaterial, "noclamp nocull smooth")
    local correctpos = weapon
    render.UpdateScreenEffectTexture()
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_REPLACE)
    render.SetStencilWriteMask(255)
    render.SetStencilTestMask(255)

    render.SetBlend(0)

    render.SetStencilReferenceValue(1)

    sightsam:DrawModel()
    
    render.SetBlend(1)

    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilCompareFunction(STENCIL_EQUAL)

	render.DepthRange(0.93, 0)
	render.SetMaterial(material or Material("empty"))
    local size = infoatt[holographnum].ReticleSize
    local attachment = ply:GetAttachment(ply:LookupAttachment("anim_attachment_RH"))
    if not attachment then return end
	local pos = attachment.Pos
	local ang = sightsam:GetAngles()
    local up = ang:Up()
    local right = ang:Right()
    local forward = ang:Forward()
    
    pos = pos + forward * 100 + up * infoatt[holographnum].ReticleUp + right * infoatt[holographnum].ReticleRight

	local xr, yr = pos:ToScreen().x, pos:ToScreen().y
	local lighted = size + 0.7
    render.DrawQuad(
        	pos + (up * size / 2) - (right * size / 2),
        	pos + (up * size / 2) + (right * size / 2),
        	pos - (up * size / 2) + (right * size / 2),
        	pos - (up * size / 2) - (right * size / 2),
        Color(255,255,255,255)
    )
	render.DepthRange(0, 1)
    render.SetStencilEnable(false)
end)