hook.Add("Player Think", "BloodManager", function(ply)
    if not ply:Alive() then return end
    
    ply.bloodnext = ply.bloodnext or 0
    
    if not ply:GetNWBool("bleeding") or ply.bloodnext > CurTime() then 
        return
    end
    
    ply.bloodnext = CurTime() + 0.3
    
    local rag = ply:GetNWEntity("FakeRagdoll")
    
    bp_hit((IsValid(rag) and rag:GetPos() or ply:GetPos()) or ply:GetPos() + Vector(0, 0, 32), Vector(0, 0, -2))
    blood_Bleed((IsValid(rag) and rag:GetPos() or ply:GetPos()) or ply:GetPos() + Vector(0, 0, 32), Vector(0, 0, -2))
end)

hook.Add( "RenderScreenspaceEffects", "Blood_FX", function()

    local ply = LocalPlayer()

    if !ply:Alive() then
        return
    end

    local blood = ply:GetNWFloat("blood")

    local frac = math.Clamp(1 - (blood - 3200) / ((5000 - 1400) - 1800), 0, 1)

    if !ply:GetNWBool("otrub") then
	    DrawToyTown(frac * 13, ScrH() * (frac * 1.5))
    end

    //print(frac * 13)
    //print(blood)
end )