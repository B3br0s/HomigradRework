riot = riot or {}

function riot.SpawnBlue(ply)
    local SpawnList = ReadDataMap("tdm_blue")

    local weps_pri = {"weapon_pbat","weapon_handcuffs"}
    local weps_sec = {"","","","","","","","",""}

    ply:SetTeam(1)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    for _, wep in pairs(weps_pri) do
        ply:Give(wep)
    end

    hg.Equip_Armor(ply,"helmet1")

    local wep_secondary = ply:Give(table.Random(weps_sec))


    if IsValid(wep_secondary) then
        wep_secondary:SetClip1(wep_secondary:GetMaxClip1())
        ply:GiveAmmo(wep_secondary:GetMaxClip1() * 1, wep_secondary:GetPrimaryAmmoType(), true)
    end

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(0,0,255):ToVector())
        ply:SetSubMaterial()
        ply:SetModel("models/player/riot.mdl")
    end)
end

function riot.SpawnRed(ply)
    local SpawnList = ReadDataMap("tdm_red")

    local weps_pri = {"","","","","","","","","weapon_glockp80","","",""}
    local weps_sec = {"weapon_shovel","weapon_hatchet","weapon_sog","weapon_hammer"}

    ply:SetTeam(2)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_primary = ply:Give(table.Random(weps_pri))
    local wep_secondary = ply:Give(table.Random(weps_sec))

    if IsValid(wep_primary) then
    wep_primary:SetClip1(wep_primary:GetMaxClip1())
    end

    if math.random(1,3) == 2 then
        hg.Equip_Armor(ply,"mask2")
    end

    ply:Give("weapon_bandage")

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(148,54,31):ToVector())
        ply:SetSubMaterial()
    end)
end

function riot.StartRoundSV()
    team.DirectTeams(1,2)

    local blus = team.GetPlayers(1)
    local reds = team.GetPlayers(2)

    for _, ply in ipairs(reds) do
        riot.SpawnRed(ply)
    end

    for _, ply in ipairs(blus) do
        riot.SpawnBlue(ply)
    end
    
    game.CleanUpMap(false)
end

function riot.RoundThink()
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

function riot.CanStart(forced)
    local nonspect = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 then
            table.insert(nonspect,ply)
        end
    end

    if #nonspect < 4 then
        return false
    else
        local world = game.GetWorld()
    
        local min, max = world:GetModelBounds()
        local size = max - min
        
        local size_final = size:Length()
        
        if size_final < 10000 then
            return false
        else
            return true 
        end
    end
end

function riot.LootSpawn()
    return false
end