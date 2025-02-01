hook.Add("Player Think","Bleed_Homigrad",function(ply,time)
    if not ply:Alive() then ply.bleed = 0 ply.blood = 5000 return end
    if not ply.blood then
        ply.blood = 5000
    end
    if not ply.NextBloodThink then
        ply.NextBloodThink = CurTime() + 0.6
    end
    if ply.NextBloodThink < CurTime() then
        ply.NextBloodThink = CurTime() + 0.6

        if ply.bleed > 0 then
            ply.bleed = math.Clamp(ply.bleed - 1,0,1000)

            ply.blood = math.Clamp(ply.blood - 15,0,5000)
            
            net.Start("blood particle")
            net.WriteVector(ply.Fake and ply.FakeRagdoll:GetPos() or ply:GetPos() + Vector(0,0,32))
            net.WriteVector(Vector(0, 0, 0))
            net.Broadcast()
        else
            ply.blood = math.Clamp(ply.blood + 5,0,5000)
        end
    end
end)