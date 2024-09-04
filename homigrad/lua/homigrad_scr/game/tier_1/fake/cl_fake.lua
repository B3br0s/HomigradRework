local ATTInformation = {
    ["weapon_m4a1"] = {
        ["Elcan"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_elcan_specter_hco_lod0_mark.png",
            ReticleSize = 10,
            ReticleUp = 2,
            ReticleRight = 0,
        },
        ["Walther"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_walther_mrs_mark_002.png",
            ReticleSize = 15,
            ReticleUp = 2.8,
            ReticleRight = -0.2,
        }
    },
    ["weapon_r8"] = {
        ["Leapers"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_base_aimpoint_acro_p1_mark.png",
            ReticleSize = 15,
            ReticleUp = 4,
            ReticleRight = -0.2,
        }
    },
    ["weapon_mp7"] = {
        ["Pilad"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_walther_mrs_mark_002.png",
            ReticleSize = 15,
            ReticleUp = 4,
            ReticleRight = -0.2,
        }
    },
    ["weapon_akm"] = {
        ["Opk7"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_ekb_okp7_true_marks.png",
            ReticleSize = 10,
            ReticleUp = 1,
            ReticleRight = -0.2,
        },
        ["Pkaa"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_30mm_leupold_mark4_lr_6,5_20x50_marks.png",
            ReticleSize = 60,
            ReticleUp = 2,
            ReticleRight = 0,
        }
    },
    ["weapon_galilsar"] = {
        ["Opk7"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_ekb_okp7_true_marks.png",
            ReticleSize = 10,
            ReticleUp = 2,
            ReticleRight = -0.2,
        },
    },
    ["weapon_ak74u"] = {
        ["Opk7"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_ekb_okp7_true_marks.png",
            ReticleSize = 10,
            ReticleUp = 1,
            ReticleRight = -0.2,
        }
    },
    ["weapon_m249"] = {
        ["Eotech553"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_eotech_xps3-0_marks.png",
            ReticleSize = 10,
            ReticleUp = 1,
            ReticleRight = -0.3,
        }
    },
    ["weapon_remington870"] = {
        ["Eotech553"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_eotech_xps3-0_marks.png",
            ReticleSize = 5,
            ReticleUp = 9,
            ReticleRight = -0.3,
        }
    },
    ["weapon_m3super"] = {
        ["Eotech553"] = {
            ReticleMaterial = "vgui/arc9_eft_shared/reticles/scope_all_eotech_xps3-0_marks.png",
            ReticleSize = 10,
            ReticleUp = -1.5,
            ReticleRight = -0.3,
        }
    }
}

hook.Add("PostDrawOpaqueRenderables", "Holosightes", function()
    local ply = LocalPlayer()
    local weapon = ply:GetActiveWeapon()
    if not IsValid(weapon) or not weapon.ActivitySight then return end
    local sight = weapon.ActivitySight
    local infoatt = ATTInformation[weapon:GetClass()][sight]
    local sightsam = weapon.ATTObjects[sight]
    local material = Material(infoatt.ReticleMaterial, "noclamp nocull smooth")
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
    local size = infoatt.ReticleSize
    local attachment = correctpos:GetAttachment(1)
    if not attachment then return end
	local pos = attachment.Pos
	local ang = sightsam:GetAngles()
    local up = ang:Up()
    local right = ang:Right()
    local forward = ang:Forward()
    pos = pos + forward * 100 + up * infoatt.ReticleUp + right * infoatt.ReticleRight
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