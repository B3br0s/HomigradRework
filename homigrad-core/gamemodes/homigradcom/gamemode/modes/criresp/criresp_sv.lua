criresp = criresp or {}
criresp.swat = false
criresp.untilswat_real = CurTime()

criresp.Models = {
    "models/player/Group01/male_01.mdl",
    "models/player/Group01/male_03.mdl",
    //"models/player/Group03m/female_06.mdl",
}

function criresp.SpawnSWAT(ply)
    local SpawnList = ReadDataMap("criresp_swat")

    local weps_pri = "weapon_ar15"
    local weps_sec = {"weapon_usp_match"}
    local weps_oth = {"weapon_sog","weapon_bandage","weapon_medkit_hg","weapon_handcuffs"}

    ply:SetTeam(1)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    hg.Equip_Armor(ply,"vest6")
    hg.Equip_Armor(ply,"helmet1")
    //hg.Equip_Armor(ply,"mask2")

    local wep_primary = ply:Give(weps_pri)
    local wep_secondary = ply:Give(table.Random(weps_sec))
    for _, wep in pairs(weps_oth) do
        ply:Give(wep)
    end

    if IsValid(wep_primary) then
        wep_primary:SetClip1(wep_primary:GetMaxClip1())
        ply:GiveAmmo(wep_primary:GetMaxClip1() * math.random(8,16), wep_primary:GetPrimaryAmmoType(), true)
    end
    if IsValid(wep_secondary) then
        wep_secondary:SetClip1(wep_secondary:GetMaxClip1())
        ply:GiveAmmo(wep_secondary:GetMaxClip1() * math.random(2,4), wep_secondary:GetPrimaryAmmoType(), true)
    end


    timer.Simple(0,function()
        ply:SetModel("models/css_seb_swat/css_swat.mdl")
        ply:SetPlayerColor(Color(0,0,255):ToVector())
        ply:SetSubMaterial()
    end)
end

function criresp.SpawnSuspect(ply)
    local SpawnList = ReadDataMap("criresp_suspect")

    local weps_pri = {"weapon_870_b","weapon_doublebarrel"}
    local weps_sec = {"weapon_329pd","weapon_tec9","weapon_glock17"}
    local weps_oth = {"weapon_sog","weapon_bandage","weapon_medkit_hg","weapon_hammer"}

    ply:SetTeam(2)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    hg.Equip_Armor(ply,"vest5")
    hg.Equip_Armor(ply,"helmet1")

    local wep_secondary = ply:Give(table.Random(weps_sec))
    for _, wep in pairs(weps_oth) do
        ply:Give(wep)
    end

    wep_secondary:SetClip1(wep_secondary:GetMaxClip1())
    if math.random(0,20) < 5 then
        local wep_primary = ply:Give(table.Random(weps_pri))
        wep_primary:SetClip1(wep_primary:GetMaxClip1())
        ply:GiveAmmo(wep_primary:GetMaxClip1() * math.random(1,2), wep_primary:GetPrimaryAmmoType(), true)
    end

    ply:GiveAmmo(wep_secondary:GetMaxClip1() * math.random(6,12), wep_secondary:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetModel(table.Random(criresp.Models))
        ply:SetPlayerColor(Color(255,0,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function criresp.StartRoundSV()
    team.DirectTeams(1,2)

    local SWATs = team.GetPlayers(1)
    local Suspects = team.GetPlayers(2)

    for _, ply in ipairs(Suspects) do
        criresp.SpawnSuspect(ply)
    end

    for _, ply in ipairs(SWATs) do
        ply:KillSilent()
    end

    criresp.untilswat_real = CurTime() + criresp.untilswat
    criresp.swat = false
    
    game.CleanUpMap(false)
end

function criresp.RoundThink()
    local T_ALIVE = team.GetCountLive(team.GetPlayers(2))
    local CT_ALIVE = team.GetCountLive(team.GetPlayers(1))
    local SWATs = team.GetPlayers(1)

    if T_ALIVE == 0 and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(1)
    end

    if criresp.untilswat_real < CurTime() and !criresp.swat then
        for _, ply in ipairs(SWATs) do
            criresp.SpawnSWAT(ply)
        end

        criresp.swat = true
    end

    if criresp.swat and (criresp.untilswat_real + 1) < CurTime() then
        if CT_ALIVE == 0 and !ROUND_ENDED then
            ROUND_ENDED = true
            ROUND_ENDSIN = CurTime() + 8

            EndRound(2)
        end
    end
end

function criresp.CanStart()
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

function criresp.LootSpawn()
    return false
end