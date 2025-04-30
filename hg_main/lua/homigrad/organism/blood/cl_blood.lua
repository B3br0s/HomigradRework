hook.Add("Player Think", "BloodManager", function(ply)
    if not ply:Alive() then return end
    
    ply.bloodnext = ply.bloodnext or 0
    
    if not ply:GetNWBool("bleeding") or ply.bloodnext > CurTime() then 
        return
    end
    
    ply.bloodnext = CurTime() + 0.3
    
    local bleedPos
    if ply:GetNWBool("Fake") then
        local ragdoll = ply:GetNWEntity("FakeRagdoll")
        bleedPos = IsValid(ragdoll) and ragdoll:GetPos() or ply:GetPos()
    else
        bleedPos = ply:GetPos() + Vector(0, 0, 32)
    end
    
    bp_hit(bleedPos, Vector(0, 0, -2))
    blood_Bleed(bleedPos, Vector(0, 0, -2))
end)

hook.Add( "RenderScreenspaceEffects", "Blood_FX", function()

    local ply = LocalPlayer()

    local blood = ply:GetNWFloat("blood")

    local frac = math.Clamp(1 - (blood - 3200) / ((5000 - 1400) - 1800), 0, 1)

	DrawToyTown(frac * 13, ScrH() * (frac * 1.5))

    //print(frac * 13)
    //print(blood)
end )