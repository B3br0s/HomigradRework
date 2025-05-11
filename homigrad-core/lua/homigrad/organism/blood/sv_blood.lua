hook.Add("Player Think","Bleed_Homigrad",function(ply,time)
    if not ply:Alive() then ply.bleed = 0 ply.blood = 5000 return end
    if ROUND_NAME == "dr" then
        return
    end
    if not ply.blood then
        ply.blood = 5000
    end

    if ply.blood < 3500 then
        ply.otrub = true
        ply.pain = 55
    end
    if ply.blood <= 0 then
        ply:Kill()
    end
    if ply.bloodNext < CurTime() then
        ply.bloodNext = CurTime() + 0.3

        if ply.bleed > 0 then
            ply.bleed = math.Clamp(ply.bleed - 0.35,0,1000)

            ply.blood = math.Clamp(ply.blood - math.random(5,10),0,5000)

            //print(ply.blood)
            
            ply.bleeding = true
        else
            ply.blood = math.Clamp(ply.blood + 1,0,5000)

            ply.bleeding = false
        end
    end
end)