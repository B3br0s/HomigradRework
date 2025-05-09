MAX_PAIN = 50 --мокс пеин

hook.Add("Player Think","Homigrad_Pain_Think",function(ply)
    if not ply:Alive() then return end

    if ROUND_NAME == "dr" then
        ply.pain = 0
        return
    end

    if ply.painNext < CurTime() then
        ply.painNext = CurTime() + 0.25

        ply.pain = math.Clamp(ply.pain - (ply.painlosing * (1 + ply.adrenaline)) * 0.75,0,100)
    
        ply.painlosing = math.Clamp(ply.painlosing - 1,1,100)
    end

    if ply.pain >= MAX_PAIN then
        ply.otrub = true
        if !ply.Fake then
            hg.Faking(ply)
        end
    else
        ply.otrub = false
    end
end)