function IsGuilted(ply,att)
    if ROUND_NAME == "hmcd" then
        if !ply.IsTraitor and !att.IsTraitor then
            return true
        elseif ply.IsTraitor and att.IsTraitor then
            return true
        end
    else
        if TableRound().TeamBased then
            if ply:Team() == att:Team() then
                return true
            end
        end
    end

    return false
end

function GuiltThink(ply,att)
    local IsGuilted = IsGuilted(ply,att)

    
end

hook.Add("PlayerDeath","Homigrad_Guilt",function(ply,killed_with,att)
    GuiltThink(ply,att)
end)