tdm = tdm or {}

function tdm.SpawnBlue(ply)
    local SpawnList = ReadDataMap("tdm_blue")

    local weps_pri = {"weapon_ak47","weapon_m4a1","weapon_mp7","weapon_xm1014","weapon_scar","weapon_mag7"}
    local weps_sec = {"weapon_deagle","weapon_glock17","weapon_r8","weapon_fiveseven"}
    local weps_oth = {"weapon_kabar"}

    ply:SetTeam(1)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_primary = ply:Give(table.Random(weps_pri))
    local wep_secondary = ply:Give(table.Random(weps_sec))
    local wep_other = ply:Give(table.Random(weps_oth))

    wep_primary:SetClip1(wep_primary:GetMaxClip1())
    wep_secondary:SetClip1(wep_secondary:GetMaxClip1())

    ply:GiveAmmo(wep_primary:GetMaxClip1() * math.random(8,16), wep_primary:GetPrimaryAmmoType(), true)
    ply:GiveAmmo(wep_secondary:GetMaxClip1() * math.random(2,4), wep_secondary:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(0,0,255):ToVector())
        ply:SetSubMaterial()
    end)
end

function tdm.SpawnRed(ply)
    local SpawnList = ReadDataMap("tdm_red")

    local weps_pri = {"weapon_ak47","weapon_m4a1","weapon_mp7","weapon_xm1014","weapon_scar","weapon_mag7"}
    local weps_sec = {"weapon_deagle","weapon_glock17","weapon_r8","weapon_fiveseven"}
    local weps_oth = {"weapon_kabar"}

    ply:SetTeam(2)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_primary = ply:Give(table.Random(weps_pri))
    local wep_secondary = ply:Give(table.Random(weps_sec))
    local wep_other = ply:Give(table.Random(weps_oth))

    wep_primary:SetClip1(wep_primary:GetMaxClip1())
    wep_secondary:SetClip1(wep_secondary:GetMaxClip1())

    ply:GiveAmmo(wep_primary:GetMaxClip1() * math.random(8,16), wep_primary:GetPrimaryAmmoType(), true)
    ply:GiveAmmo(wep_secondary:GetMaxClip1() * math.random(2,4), wep_secondary:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(255,0,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function tdm.StartRoundSV()
    team.DirectTeams(1,2)

    local blus = team.GetPlayers(1)
    local reds = team.GetPlayers(2)

    for _, ply in ipairs(reds) do
        tdm.SpawnRed(ply)
    end

    for _, ply in ipairs(blus) do
        tdm.SpawnBlue(ply)
    end
    
    game.CleanUpMap(false)
end

function tdm.RoundThink()
    local T_ALIVE = team.GetCountLive(team.GetPlayers(2))
    local CT_ALIVE = team.GetCountLive(team.GetPlayers(1))

    if T_ALIVE == 0 and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(1)
    end

    if CT_ALIVE == 0 and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(2)
    end
end

function tdm.CanStart()
    local nonspect = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 then
            table.insert(nonspect,ply)
        end
    end

    if #nonspect < 8 then
        return false
    else
        return true
    end
end