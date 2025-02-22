util.AddNetworkString("main_bcst")

MAX_PAIN = 50 --я мокс пеи

hook.Add("Player Think","Homigrad_Pain_Think",function(ply)
    if not ply:Alive() then return end
    ply:SetNWFloat("pain",ply.pain)
    if ply.pain > MAX_PAIN then
        if not ply.Fake then
            Faking(ply)
        end
        ply.otrub = true
    else
        ply.otrub = false
    end
    if not ply.NextPL then
        ply.NextPL = 0
    end
    if ply.NextPL < CurTime() then
        ply.NextPL = CurTime() + 0.4
        ply.pain = math.Clamp(ply.pain - ply.painlosing,0,400)
    end
end)