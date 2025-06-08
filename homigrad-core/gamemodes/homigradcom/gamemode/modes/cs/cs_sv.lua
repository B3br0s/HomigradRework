cs = cs or {}

function cs.SpawnBlue(ply)
    local SpawnList = ReadDataMap("tdm_blue")

    ply:SetTeam(1)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_1 = ply:Give("weapon_usp_match")
    ply:Give("weapon_sog")

    ply:GiveAmmo(wep_1:GetMaxClip1() * 4, wep_1:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetModel("models/player/Custom_counter_terrorists/ct_gign.mdl")
        ply:SetPlayerColor(Color(0,0,255):ToVector())
        ply:SetBodygroup(1,2)
        ply:SetSubMaterial()
    end)
end

function cs.SpawnRed(ply)
    local SpawnList = ReadDataMap("tdm_red")

    ply:SetTeam(2)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_1 = ply:Give("weapon_glockp80")
    ply:Give("weapon_sog")

    ply:GiveAmmo(wep_1:GetMaxClip1() * 4, wep_1:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetModel("models/player/Custom_terrorists/t_phoenix.    mdl")
        ply:SetPlayerColor(Color(255,0,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function cs.StartRoundSV()
    team.DirectTeams(1,2)

    local blus = team.GetPlayers(1)
    local reds = team.GetPlayers(2)

    for _, ply in ipairs(reds) do
        cs.SpawnRed(ply)
    end

    for _, ply in ipairs(blus) do
        cs.SpawnBlue(ply)
    end
    
    game.CleanUpMap(false)
end

function cs.RoundThink()
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

function cs.CanStart(forced)
    local world = game.GetWorld()
    
    local min, max = world:GetModelBounds()
    local size = max - min

    local size_final = size:Length()

    local chance = math.random(20,100) > 40

    if !chance and !forced then
        return false
    end

    if size_final < 10000 then
        return false
    else
        return true 
    end
end

function cs.LootSpawn()
    return false
end