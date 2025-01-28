util.AddNetworkString("bcst_org")

hook.Add("Player Think","Homigrad_Pain",function(ply,time)
    if not ply:Alive() then ply.organism.pain = 0 return end
    if not ply.NextCheck then ply.NextCheck = 0 end
    if ply.NextCheck < CurTime() then
        ply.NextCheck = CurTime() + 0.25
        ply.organism.owner = ply
        net.Start("bcst_org")
        net.WriteTable(ply.organism)
        net.Send(ply)
        ply.organism.pain = math.Clamp(ply.organism.pain - ply.organism.painlosing / 4,0,400)--потрошу тебя разрезая тело,аж душа запела,потрошу тебя
        --ply.organism.pain = math.Round(ply.organism.pain)
        if ply.organism.pain > 50 then
            ply.organism.otrub = true
        else
            ply.organism.otrub = false
        end    
    end
end)