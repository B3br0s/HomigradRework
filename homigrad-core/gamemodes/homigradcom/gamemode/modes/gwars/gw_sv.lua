gw = gw or {}

gw.ModelsRed = {
    "models/gang_ballas/gang_ballas_1.mdl",
    "models/gang_ballas/gang_ballas_2.mdl"
}

gw.ModelsBlue = {
    "models/gang_groove/gang_1.mdl",
    "models/gang_groove/gang_2.mdl"
} 

function gw.SpawnBlue(ply)
    local SpawnList = ReadDataMap("tdm_blue")

    local weps_pri = {"weapon_draco","weapon_glock18","weapon_glockp80","weapon_329pd","weapon_tec9"}

    ply:SetTeam(1)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    hg.Equip_Armor(ply,"helmet1")

    local wep_primary = ply:Give(table.Random(weps_pri))

    wep_primary:SetClip1(wep_primary:GetMaxClip1())

    ply:GiveAmmo(wep_primary:GetMaxClip1() * math.random(8,16), wep_primary:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetModel(table.Random(gw.ModelsBlue))
        ply:SetPlayerColor(Color(21,184,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function gw.SpawnRed(ply)
    local SpawnList = ReadDataMap("tdm_red")

    local weps_pri = {"weapon_draco","weapon_glock18","weapon_glockp80","weapon_329pd","weapon_tec9"}

    ply:SetTeam(2)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    hg.Equip_Armor(ply,"helmet1")

    local wep_primary = ply:Give(table.Random(weps_pri))

    wep_primary:SetClip1(wep_primary:GetMaxClip1())

    ply:GiveAmmo(wep_primary:GetMaxClip1() * math.random(8,16), wep_primary:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetModel(table.Random(gw.ModelsRed))
        ply:SetPlayerColor(Color(184,21,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function gw.StartRoundSV()
    team.DirectTeams(1,2)

    local blus = team.GetPlayers(1)
    local reds = team.GetPlayers(2)

    for _, ply in ipairs(reds) do
        gw.SpawnRed(ply)
    end

    for _, ply in ipairs(blus) do
        gw.SpawnBlue(ply)
    end
    
    game.CleanUpMap(false)
end

function gw.RoundThink()
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

function gw.CanStart(forced)
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

function gw.LootSpawn()
    return false
end