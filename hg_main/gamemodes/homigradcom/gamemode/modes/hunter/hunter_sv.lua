hunter = hunter or {}

hunter.TimeUntilSWAT = 120
hunter.SwatArrived = false
hunter.UntilSwat = 1e8

function hunter.SWATSpawn(ply)
    local weps_pri = {"weapon_m4a1","weapon_r870"}
    local weps_sec = {"weapon_glock17"}
    local weps_oth = {"weapon_kabar"}

    ply:SetTeam(3)

    local wep_primary = ply:Give(table.Random(weps_pri))
    local wep_secondary = ply:Give(table.Random(weps_sec))
    local wep_other = ply:Give(table.Random(weps_oth))

    wep_primary:SetClip1(wep_primary:GetMaxClip1())
    wep_secondary:SetClip1(wep_secondary:GetMaxClip1())

    ply:GiveAmmo(wep_primary:GetMaxClip1() * math.random(8,16), wep_primary:GetPrimaryAmmoType(), true)
    ply:GiveAmmo(wep_secondary:GetMaxClip1() * math.random(2,4), wep_secondary:GetPrimaryAmmoType(), true)

    timer.Simple(0,function()
        ply:SetModel("models/player/riot.mdl")
    end)
end

function hunter.SpawnHunter(ply)
    local SpawnList = ReadDataMap("hunt_hunter")

    local weps_pri = {"weapon_ak47","weapon_mag7","weapon_m4a1","weapon_r870"}
    local weps_sec = {"weapon_deagle","weapon_glock17","weapon_r8"}
    local weps_oth = {"weapon_kknife","weapon_hatchet","weapon_tomahawk","weapon_kabar"}

    ply:SetTeam(2)

    ply:Spawn()

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

function hunter.SpawnVictim(ply)
    local weps_oth = {"weapon_knife","","weapon_chips","weapon_energy_drink","weapon_milk","weapon_water_bottle"}

    local SpawnList = ReadDataMap("hunt_victim")

    ply:SetTeam(1)

    ply:Spawn()

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    local wep_other = ply:Give(table.Random(weps_oth))

    timer.Simple(0,function()
        ply:SetPlayerColor(Color(0,255,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function hunter.StartRoundSV()
    local plys = {}

    hunter.UntilSwat = CurTime() + hunter.TimeUntilSWAT
    hunter.SwatArrived = false

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == 1002 then
            continue 
        end
        table.insert(plys,ply)
        ply:SetTeam(1)
        hunter.SpawnVictim(ply)
        ply.AppearanceOverride = true
    end

    local htr = table.Random(plys)

    hunter.SpawnHunter(htr)

    game.CleanUpMap(false)
end

function hunter.RoundThink()
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

    if hunter.UntilSwat < CurTime() then
        if !hunter.SwatArrived then
            hunter.SwatArrived = true
            net.Start("localized_chat")
            net.WriteString('swat_arrived')
            net.Broadcast()
            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() then
                    continue
                end
                ply:SetTeam(3)
                local SpawnList = ReadDataMap("hunt_law")

                if SpawnList != nil and SpawnList != {} then
                    ply:Spawn()

                    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

                    hunter.SWATSpawn(ply)
                else
                    ply:Spawn()

                    hunter.SWATSpawn(ply)
                end
            end
        end
    end
end

function hunter.CanStart()
    local nonspect = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 then
            table.insert(nonspect,ply)
        end
    end

    if #nonspect < 4 then
        return false
    else
        return true
    end
end