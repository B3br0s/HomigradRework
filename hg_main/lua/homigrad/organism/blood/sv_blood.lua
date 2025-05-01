hook.Add("Player Think","Bleed_Homigrad",function(ply,time)
    if not ply:Alive() then ply.bleed = 0 ply.blood = 5000 return end
    if not ply.blood then
        ply.blood = 5000
    end

    if ply.blood < 3500 then
        ply.otrub = true
        ply.pain = 55
    end
    if ply.bloodNext < CurTime() then
        ply.bloodNext = CurTime() + 0.3

        if ply.bleed > 0 then
            ply.bleed = math.Clamp(ply.bleed - 0.25,0,1000)

            ply.blood = math.Clamp(ply.blood - math.random(5,12),0,5000)

            //print(ply.blood)
            
            ply.bleeding = true
        else
            ply.blood = math.Clamp(ply.blood + 1,0,5000)

            ply.bleeding = false
        end
    end
end)