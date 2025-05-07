hook.Add("Player Think","Adrenaline_Hander",function(ply)
    if !ply:Alive() then
        return
    end

    if ply.adrenaNext < CurTime() then
        ply.adrenaNext = CurTime() + 0.75

        //print(ply.adrenaline)

        ply.adrenaline = math.Clamp(ply.adrenaline - 0.025,0,100)
    end
end)