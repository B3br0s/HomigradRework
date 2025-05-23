function IsGuilted(ply, att)
    if not (IsValid(ply) and IsValid(att)) then return false end
    if not (ply:IsPlayer() and att:IsPlayer()) then return false end
    if not ply:Alive() or not ROUND_ACTIVE or ROUND_ENDED or ply == att then return false end

    if ROUND_NAME == "hmcd" then
        local pTraitor, aTraitor = ply.IsTraitor, att.IsTraitor
        return (not pTraitor and not aTraitor) or (pTraitor and aTraitor)
    end

    local round = TableRound()
    if round and (round.GuiltEnabled or round.TeamBased) then
        return ply:Team() == att:Team()
    end

    return false
end

function GuiltThink(ply, att)
    local guilty = IsGuilted(ply, att)
    if not ply.LastDMGInfo then return end

    ply.guilt = ply.guilt or 100
    att.guilt = att.guilt or 100

    local dmg = math.Clamp(ply.LastDMGInfo:GetDamage(), 0, 4)
    if ply.isGordon and ROUND_NAME == "coop" then
        dmg = dmg * 1.25
    end

    if guilty then
        att.guilt = math.Clamp(att.guilt - dmg, 0, 100)
        file.Write("hgr/guilt/" .. att:SteamID64(), att.guilt)

        if att.guilt <= 0 then
            att.guilt = 30
            if att:IsAdmin() then
                att:Kick("GUILT SYSTEM")
            else
                RunConsoleCommand("ulx", "ban", att:Name(), "180", "GUILT SYSTEM")
            end
        end
    end
end

hook.Add("EntityTakeDamage", "Homigrad_Guilt", function(ent, dmginfo)
    local ply = ent:IsPlayer() and ent or hg.RagdollOwner(ent)
    if not (IsValid(ply) and ply:IsPlayer() and ply:Alive()) then return end

    local att = dmginfo:GetAttacker()
    if IsValid(att) and att:IsWeapon() then
        att = att:GetOwner()
    end
    if not (IsValid(att) and att:IsPlayer()) or ply == att then return end

    GuiltThink(ply, att)
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