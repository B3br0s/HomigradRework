jb = jb or {}

function jb.SpawnWarden(ply)
    local SpawnList = {}

    local weps_pri = {"weapon_m4_css"}
    local weps_sec = {"weapon_deagle_css"}
    local weps_oth = {"weapon_kknife","weapon_handcuffs"}

    if #ReadDataMap("jb_warden") == 0 then
	    for i, ent in RandomPairs(ents.FindByClass("info_player_counterterrorist")) do
	    	table.insert(SpawnList,ent:GetPos())
	    end
    end

    ply:SetTeam(2)

    ply:Spawn()

    if #ReadDataMap("jb_warden") != 0 then
        ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))
    else
        ply:SetPos(table.Random(SpawnList))
    end

    local wep_primary = ply:Give(table.Random(weps_pri))
    local wep_secondary = ply:Give(table.Random(weps_sec))
    for _, wep in pairs(weps_oth) do
        ply:Give(wep)
    end

    wep_primary:SetClip1(wep_primary:GetMaxClip1())
    wep_secondary:SetClip1(wep_secondary:GetMaxClip1())

    ply:GiveAmmo(wep_primary:GetMaxClip1() * math.random(8,16), wep_primary:GetPrimaryAmmoType(), true)
    ply:GiveAmmo(wep_secondary:GetMaxClip1() * math.random(2,4), wep_secondary:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(0,17,255):ToVector())
        ply:SetSubMaterial()
    end)
end

function jb.SpawnPrisoner(ply)
    local weps_oth = {"weapon_knife_css"}

    local SpawnList = {}

    if #ReadDataMap("jb_prisoner") == 0 then
	    for i, ent in RandomPairs(ents.FindByClass("info_player_terrorist")) do
	    	table.insert(SpawnList,ent:GetPos())
	    end
    end

    ply:SetTeam(1)

    ply:Spawn()

    if #ReadDataMap("jb_prisoner") != 0 then
        ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))
    else
        ply:SetPos(table.Random(SpawnList))
    end

    local wep_other = ply:Give(table.Random(weps_oth))

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(255,0,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function jb.StartRoundSV()
    local plys = {}

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == 1002 then
            continue 
        end
        table.insert(plys,ply)
        ply:SetTeam(1)
        ply.AppearanceOverride = true
        jb.SpawnPrisoner(ply)
    end

    local htr = table.Random(plys)

    jb.SpawnWarden(htr)

    game.CleanUpMap(false)
end

function jb.RoundThink()
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

function jb.CanStart()
    local mapname = string.lower(game.GetMap())

    if !string.match(mapname,"jb_") then
        return false
    else
        return true
    end
end