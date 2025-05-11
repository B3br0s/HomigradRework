function IsGuilted(ply, att)
    if ply:GetClass() != "player" then
        return false
    end
    if att:GetClass() != "player" then
        return false
    end
    if ROUND_ENDED then
        return false
    end
    if ply == att then
        return
    end
    if !IsValid(ply) or !IsValid(att) or att == NULL or ply == NULL then
        return
    end
    if ROUND_NAME == "hmcd" then
        if !ply.IsTraitor and !att.IsTraitor then
            return true
        elseif ply.IsTraitor and att.IsTraitor then
            return true
        end
    else
        local Round = TableRound()
        if Round and Round.TeamBased then
            if ply:Team() == att:Team() then
                return true
            end
        end
    end

    return false
end

function GuiltThink(ply,att)
    local IsGuilted = IsGuilted(ply,att)

    local clamped_dmg = math.Clamp(ply.LastDMGInfo:GetDamage(),0,40)

    if IsGuilted then
        att.guilt = math.Clamp(att.guilt - clamped_dmg,0,100)

        file.Write("hgr/guilt/"..att:SteamID64(),att.guilt)
    end

    if !att.guilt then
        att.guilt = 100
    end

    if !ply.guilt then
        ply.guilt = 100
    end

    if att.guilt <= 0 and IsGuilted then
        att.guilt = 30
        if att:IsAdmin() then
            att:Kick("GUILT SYSTEM")
        else
            RunConsoleCommand("ulx","ban",att:Name(),180,"GUILT SYSTEM")
        end
    end
end

hook.Add("PlayerDeath","Homigrad_Guilt",function(ply,killed_with,att)
    GuiltThink(ply,att)

    file.Write("hgr/guilt/"..ply:SteamID64(),ply.guilt)
end)

hook.Add("PlayerInitialSpawn","Guilt_Shit",function(ply)
    file.CreateDir("hgr/guilt")

    if !file.Exists("hgr/guilt/"..ply:SteamID64(),"DATA") then
        ply.guilt = 100
        file.Write("hgr/guilt/"..ply:SteamID64(),ply.guilt)
    else
        ply.guilt = file.Read("hgr/guilt/"..ply:SteamID64(),"DATA")
    end
end)

hook.Add("Player Think","Guilt_Regen",function(ply)
    if !ply.guilt then
        ply.guilt = 100
    end

    ply.LastGuiltRegen = ply.LastGuiltRegen or 0

    if ply.LastGuiltRegen < CurTime() then
        ply.LastGuiltRegen = CurTime() + 5
        ply.guilt = math.Clamp(ply.guilt + 5,0,100)
    end
end)