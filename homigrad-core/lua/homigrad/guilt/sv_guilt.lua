function IsGuilted(ply, att)
    if !ply:Alive() then
        return
    end
    if not IsValid(ply) or not IsValid(att) or ply == NULL or att == NULL then
        return false
    end
    
    if ply:GetClass() ~= "player" or att:GetClass() ~= "player" then
        return false
    end
    
    if ROUND_ENDED or ply == att then
        return false
    end
    
    if ROUND_NAME == "hmcd" then
        if not ply.IsTraitor and not att.IsTraitor then
            return true
        elseif ply.IsTraitor and att.IsTraitor then
            return true
        end
        return false
    end
    
    local Round = TableRound()
    if Round then
        if Round.GuiltEnabled or Round.TeamBased then
            return ply:Team() == att:Team()
        end
    end
    
    return false
end

function GuiltThink(ply,att)
    local IsGuilted = IsGuilted(ply,att)

    if !ply.LastDMGInfo then
        return
    end

    local clamped_dmg = math.Clamp(ply.LastDMGInfo:GetDamage(),0,7)

    if ply.isGordon and ROUND_NAME == "coop" then
        clamped_dmg = clamped_dmg * 1.25
    end

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

hook.Add("EntityTakeDamage","Homigrad_Guilt",function(ent,dmginfo)
    local ply = (ent:IsPlayer() and ent or hg.RagdollOwner(ent))
    if !ply:IsPlayer() then
        //print(123)
        return
    end
    if !ply:Alive() then
        return
    end
    local att = dmginfo:GetAttacker()

    if IsValid(att) and att:IsWeapon() then
        att = att:GetOwner()
    end

    if !IsValid(att) or att == nil or IsValid(att) and !att:IsPlayer() then
        return
    end

    GuiltThink(ply,att)
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