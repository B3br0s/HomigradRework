tdm = tdm or {}

tdm.Models = {
    "models/player/group01/male_01.mdl",
    "models/player/group01/male_02.mdl",
    "models/player/group01/male_03.mdl",
    "models/player/group01/male_04.mdl",
    "models/player/group01/male_05.mdl",
    "models/player/group01/male_06.mdl",
    "models/player/group01/male_07.mdl",
    "models/player/group01/male_08.mdl",
    "models/player/group01/male_09.mdl",

    "models/player/group01/female_01.mdl",
    "models/player/group01/female_02.mdl",
    "models/player/group01/female_03.mdl",
    "models/player/group01/female_04.mdl",
    "models/player/group01/female_05.mdl",
    "models/player/group01/female_06.mdl",
}

function tdm.SpawnBlue(ply)
    local SpawnList = ReadDataMap("tdm_blue")

    local weps_pri = {"weapon_m16a1","weapon_mp7"}
    local weps_sec = {"weapon_deagle","weapon_glock17","weapon_fiveseven"}
    local weps_oth = {"weapon_sog","weapon_bandage","weapon_medkit_hg","weapon_f1"}

    ply:SetTeam(1)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    hg.Equip_Armor(ply,"vest2")
    hg.Equip_Armor(ply,"helmet1")

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
        ply:SetModel(table.Random(tdm.Models))
        ply:SetPlayerColor(Color(0,0,255):ToVector())
        ply:SetSubMaterial()
    end)
end

function tdm.SpawnRed(ply)
    local SpawnList = ReadDataMap("tdm_red")

    local weps_pri = {"weapon_ak47","weapon_mp5"}
    local weps_sec = {"weapon_deagle","weapon_glock17","weapon_fiveseven"}
    local weps_oth = {"weapon_sog","weapon_bandage","weapon_medkit_hg","weapon_f1"}

    ply:SetTeam(2)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    hg.Equip_Armor(ply,"vest2")
    hg.Equip_Armor(ply,"helmet1")

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
        ply:SetModel(table.Random(tdm.Models))
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

function tdm.LootSpawn()
    return false
end