hook.Add("PostDrawOpaqueRenderables","Render_Fix",function()
    for _, ply in ipairs(player.GetAll()) do
        hook.Run("Render")
    end
end)

hook.Add("PreRender","Render_Fix",function()
    for _, ply in ipairs(player.GetAll()) do
        hook.Run("Render")
    end
end)

function hg.RagdollRender(ent)
    local ply = hg.RagdollOwner(ent)
    if (IsValid(ply) and IsValid(ent)) and ply.FakeRagdoll == ent then
        hg.DoTPIK(ply,ent)
        hg.RenderArmor(ply)
    else
        //hg.RenderArmorEnt(ent)
    end
    ent:DrawModel()
end

function hg.RenderOverride(ply)
    local ent = hg.GetCurrentCharacter(ply)

    hg.RenderArmor(ply)

    hg.DoTPIK(ply,ent)

    ply:DrawModel()
end