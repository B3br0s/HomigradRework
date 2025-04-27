hook.Add("PlayerThink", "BloodManager", function(ply)
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