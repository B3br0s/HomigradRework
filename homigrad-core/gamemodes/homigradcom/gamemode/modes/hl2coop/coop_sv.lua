coop = coop or {}

coop.RoundEnds = 1e8

coop.Models = {}

coop.Gordon = NULL

coop.GuiltEnabled = true

local mdls = coop.Models

util.AddNetworkString("coop exiting")

mdls.citizens = {
    "models/player/group02/male_02.mdl",
    "models/player/group02/male_04.mdl",
    "models/player/group02/male_06.mdl",
    "models/player/group02/male_08.mdl",
}

mdls.refugees = {
    "models/player/group02/male_02.mdl",
    "models/player/group02/male_04.mdl",
    "models/player/group02/male_06.mdl",
    "models/player/group02/male_08.mdl",
}

mdls.rebels = {
    "models/player/group03/female_01.mdl",
    "models/player/group03/female_02.mdl",
    "models/player/group03/female_03.mdl",
    "models/player/group03/female_04.mdl",
    "models/player/group03/female_05.mdl",
    "models/player/group03/female_06.mdl",

    "models/player/group03/male_01.mdl",
    "models/player/group03/male_02.mdl",
    "models/player/group03/male_03.mdl",
    "models/player/group03/male_04.mdl",
    "models/player/group03/male_05.mdl",
    "models/player/group03/male_06.mdl",
    "models/player/group03/male_07.mdl",
    "models/player/group03/male_08.mdl",
    "models/player/group03/male_09.mdl",
}

mdls.rebels_better = { //заменю на модели покруче
    "models/player/group03/female_01.mdl",
    "models/player/group03/female_02.mdl",
    "models/player/group03/female_03.mdl",
    "models/player/group03/female_04.mdl",
    "models/player/group03/female_05.mdl",
    "models/player/group03/female_06.mdl",

    "models/player/group03/male_01.mdl",
    "models/player/group03/male_02.mdl",
    "models/player/group03/male_03.mdl",
    "models/player/group03/male_04.mdl",
    "models/player/group03/male_05.mdl",
    "models/player/group03/male_06.mdl",
    "models/player/group03/male_07.mdl",
    "models/player/group03/male_08.mdl",
    "models/player/group03/male_09.mdl",
}

local maps_fraction = {
    ["d1_trainstation_01"] = "citizens",
    ["d1_trainstation_02"] = "citizens",
    ["d1_trainstation_03"] = "citizens",
    ["d1_trainstation_04"] = "citizens",
    ["d1_trainstation_05"] = "citizens",
    ["d1_trainstation_06"] = "refugees",
    ["d1_canals_01"] = "refugees",
    ["d1_canals_01a"] = "refugees",
    ["d1_canals_02"] = "refugees",
    ["d1_canals_03"] = "rebels",
    ["d1_canals_05"] = "rebels",
    ["d1_canals_06"] = "rebels",
    ["d1_canals_07"] = "rebels",
    ["d1_canals_08"] = "rebels",
    ["d1_canals_09"] = "rebels",
    ["d1_canals_10"] = "rebels",
    ["d1_canals_11"] = "rebels",
    ["d1_canals_12"] = "rebels",
    ["d1_canals_13"] = "rebels",
    ["d1_eli_01"] = "rebels",
    ["d1_eli_02"] = "rebels_better",
    ["d1_town_01"] = "rebels_better",
    ["d1_town_01a"] = "rebels_better",
    ["d1_town_02"] = "rebels_better",
    ["d1_town_02a"] = "rebels_better",
    ["d1_town_03"] = "rebels_better",
    ["d1_town_04"] = "rebels_better",
    ["d1_town_05"] = "rebels_better",
    ["d2_coast_01"] = "rebels_better",
    ["d2_coast_03"] = "rebels_better",
    ["d2_coast_04"] = "rebels_better",
    ["d2_coast_05"] = "rebels_better",
    ["d2_coast_07"] = "rebels_better",
    ["d2_coast_08"] = "rebels_better",
    ["d2_coast_09"] = "rebels_better",
    ["d2_coast_10"] = "rebels_better",
    ["d2_coast_11"] = "rebels_better",
    ["d2_coast_12"] = "rebels_better",
    ["d2_prison_01"] = "rebels_better",
    ["d2_prison_02"] = "rebels_better",
    ["d2_prison_03"] = "rebels_better",
    ["d2_prison_04"] = "rebels_better",
    ["d2_prison_05"] = "rebels_better",
    ["d2_prison_06"] = "rebels_better",
    ["d2_prison_07"] = "rebels_better",
    ["d2_prison_08"] = "rebels_better",
    ["d3_c17_01"] = "rebels_better",
    ["d3_c17_02"] = "rebels_better",
    ["d3_c17_03"] = "rebels_better",
    ["d3_c17_04"] = "rebels_better",
    ["d3_c17_05"] = "rebels_better",
    ["d3_c17_06a"] = "rebels_better",
    ["d3_c17_06b"] = "rebels_better",
    ["d3_c17_07"] = "rebels_better",
    ["d3_c17_08"] = "rebels_better",
    ["d3_c17_09"] = "rebels_better",
    ["d3_c17_10a"] = "rebels_better",
    ["d3_c17_10b"] = "rebels_better",
    ["d3_c17_11"] = "rebels_better",
    ["d3_c17_12"] = "rebels_better",
    ["d3_c17_12b"] = "rebels_better",
    ["d3_c17_13"] = "rebels_better",
    ["d3_citadel_01"] = "rebels_better",
    ["d3_citadel_02"] = "rebels_better",
    ["d3_citadel_03"] = "rebels_better",
    ["d3_citadel_04"] = "rebels_better",
    ["d3_citadel_05"] = "rebels_better",
    ["d3_breen_01"] = "citizens",
}

local maps = {
    ["d1_trainstation_01"] = "d1_trainstation_02",
    ["d1_trainstation_02"] = "d1_trainstation_03",
    ["d1_trainstation_03"] = "d1_trainstation_04",
    ["d1_trainstation_04"] = "d1_trainstation_05",
    ["d1_trainstation_05"] = "d1_trainstation_06",
    ["d1_trainstation_06"] = "d1_canals_01",
    ["d1_canals_01"] = "d1_canals_01a",
    ["d1_canals_01a"] = "d1_canals_02",
    ["d1_canals_02"] = "d1_canals_03",
    ["d1_canals_03"] = "d1_canals_05",
    ["d1_canals_05"] = "d1_canals_06",
    ["d1_canals_06"] = "d1_canals_07",
    ["d1_canals_07"] = "d1_canals_08",
    ["d1_canals_08"] = "d1_canals_09",
    ["d1_canals_09"] = "d1_canals_10",
    ["d1_canals_10"] = "d1_canals_11",
    ["d1_canals_11"] = "d1_canals_12",
    ["d1_canals_12"] = "d1_canals_13",
    ["d1_canals_13"] = "d1_eli_01",
    ["d1_eli_01"] = "d1_eli_02",
    ["d1_eli_02"] = "d1_town_01",
    ["d1_town_01"] = "d1_town_01a",
    ["d1_town_01a"] = "d1_town_02",
    ["d1_town_02"] = "d1_town_02a",
    ["d1_town_02a"] = "d1_town_04", // я еблан,не d1_town_03 а d1_town_04
    ["d1_town_03"] = "d1_town_04",
    ["d1_town_04"] = "d1_town_05",
    ["d1_town_05"] = "d2_coast_01",
    ["d2_coast_01"] = "d2_coast_03",
    ["d2_coast_03"] = "d2_coast_04",
    ["d2_coast_04"] = "d2_coast_05",
    ["d2_coast_05"] = "d2_coast_07",
    ["d2_coast_07"] = "d2_coast_08",
    ["d2_coast_08"] = "d2_coast_09",
    ["d2_coast_09"] = "d2_coast_10",
    ["d2_coast_10"] = "d2_coast_11",
    ["d2_coast_11"] = "d2_coast_12",
    ["d2_coast_12"] = "d2_prison_01",
    ["d2_prison_01"] = "d2_prison_02",
    ["d2_prison_02"] = "d2_prison_03",
    ["d2_prison_03"] = "d2_prison_04",
    ["d2_prison_04"] = "d2_prison_05",
    ["d2_prison_05"] = "d2_prison_06",
    ["d2_prison_06"] = "d2_prison_07",
    ["d2_prison_07"] = "d2_prison_08",
    ["d2_prison_08"] = "d3_c17_01",
    ["d3_c17_01"] = "d3_c17_02",
    ["d3_c17_02"] = "d3_c17_03",
    ["d3_c17_03"] = "d3_c17_04",
    ["d3_c17_04"] = "d3_c17_05",
    ["d3_c17_05"] = "d3_c17_06a",
    ["d3_c17_06a"] = "d3_c17_06b",
    ["d3_c17_06b"] = "d3_c17_07",
    ["d3_c17_07"] = "d3_c17_08",
    ["d3_c17_08"] = "d3_c17_09",
    ["d3_c17_09"] = "d3_c17_10a",
    ["d3_c17_10a"] = "d3_c17_10b",
    ["d3_c17_10b"] = "d3_c17_11",
    ["d3_c17_11"] = "d3_c17_12",
    ["d3_c17_12"] = "d3_c17_12b",
    ["d3_c17_12b"] = "d3_c17_13",
    ["d3_c17_13"] = "d3_citadel_01",
    ["d3_citadel_01"] = "d3_citadel_02",
    ["d3_citadel_02"] = "d3_citadel_03",
    ["d3_citadel_03"] = "d3_citadel_04",
    ["d3_citadel_04"] = "d3_citadel_05",
    ["d3_citadel_05"] = "d3_breen_01",
    ["d3_breen_01"] = nil,
}

coop.Equipment = {}

local eqp = coop.Equipment

eqp.refugees = {
    ["main"] = {"weapon_usp_match"},
    ["secondary"] = {"weapon_hatchet"},
    ["required"] = {"weapon_bandage"}
}

eqp.rebels = {
    ["main"] = {"weapon_hg_smg1","weapon_mp5"},
    ["secondary"] = {"weapon_sog","weapon_usp_match"},
    ["required"] = {"weapon_bandage","weapon_painkillers_hg"}
}

eqp.rebels_better = {
    ["main"] = {"weapon_ar2_hl2","weapon_hg_smg1","weapon_xm1014"},
    ["secondary"] = {"weapon_usp_match","weapon_329pd"},
    ["required"] = {"weapon_bandage","weapon_painkillers_hg","weapon_medkit_hg"}
}

function coop.SpawnResistance(ply)
    local SpawnList = ReadDataMap("coop_spawn_rebel")

    ply:SetTeam(1)

    if !ply:Alive() then
        ply:Spawn()
    end

    if #ReadDataMap("coop_spawn_rebel") != 0 then
        ply:SetPos(table.Random(SpawnList)[1])
    end

    local fraction = maps_fraction[game.GetMap()]
    
    timer.Simple(0,function()
        ply:SetPlayerColor(Color(241,232,189):ToVector())
        if !ply.isGordon then
            ply:SetModel(table.Random(mdls[fraction]))
        end
        ply:SetSubMaterial()

        timer.Simple(0,function()
            ply.AppearanceOverride = true
            if ply.isGordon then
                if fraction == "rebel_better" then
                    ply:Give("weapon_physcannon")
                end
            end
            timer.Simple(0.2,function()
            if ply.isGordon and fraction != "citizens" then
                ply:SetModel("models/gordon_mkv.mdl")
                ply:Give("weapon_crowbar_hg")
                ply:SetPlayerClass("gordon") //повторочка
            elseif ply.isGordon and fraction == "citizens" then
                ply:SetModel("models/humans/gordon/group01/gordoncitizen.mdl")
            end
            end)
            if eqp[fraction] then
                local MainWep = ply:Give(table.Random(eqp[fraction]["main"]))
                local SecondWep = ply:Give(table.Random(eqp[fraction]["secondary"]))
                
                for _, wep in ipairs(eqp[fraction]["required"]) do
                    ply:Give(wep)
                end

                if string.match(fraction,"rebel") and !ply.isGordon then
                    hg.Equip_Armor(ply,"vest2")
                    hg.Equip_Armor(ply,"helmet1")
                end
            
                if IsValid(MainWep) then
                    ply:GiveAmmo(MainWep:GetMaxClip1() * math.random(3,6), MainWep:GetPrimaryAmmoType(), true)

                    MainWep:SetClip1(MainWep:GetMaxClip1())
                end
            
                if IsValid(SecondWep) and SecondWep.ishgweapon then
                    ply:GiveAmmo(SecondWep:GetMaxClip1() * math.random(2,4), SecondWep:GetPrimaryAmmoType(), true)

                    SecondWep:SetClip1(SecondWep:GetMaxClip1())
                end
            end
        end)
    end)
end

function coop.SpawnPlayerHook(ply)
    coop.SpawnResistance(ply)
end

function coop.SpawnCar(shit)
    local non_spect = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 then
            table.insert(non_spect,ply)
        end
    end
    if #ReadDataMap("coop_car") == 0 then
        return
    end
    for _, point in ipairs(ReadDataMap("coop_car")) do
        if _ > #non_spect then
            return
        else
            local pos = point[1]
            local ang = point[2]

            local buggy = ents.Create(shit or "prop_vehicle_jeep")
            buggy:SetKeyValue("vehiclescript","scripts/vehicles/jeep_test.txt")
            buggy:SetModel("models/buggy.mdl")
            buggy:Activate()
            buggy:SetPos(pos)
            ang.p = 0
            buggy:SetAngles(ang - Angle(0,90,0))
            buggy:Spawn()
        end
    end
end

function coop.SpawnCater(shit)
    local non_spect = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 then
            table.insert(non_spect,ply)
        end
    end
    if #ReadDataMap("coop_cater") == 0 then
        return
    end
    for _, point in ipairs(ReadDataMap("coop_cater")) do
        if _ > #non_spect then
            return
        else
            local pos = point[1]
            local ang = point[2]

            local airboat = ents.Create(shit or "prop_vehicle_airboat")
            airboat:SetKeyValue("vehiclescript","scripts/vehicles/airboat.txt")
            airboat:SetModel("models/airboat.mdl")
            airboat:Activate()
            airboat:SetPos(pos)
            airboat:SetAngles(ang - Angle(0,90,0))
            airboat:Spawn()
        end
    end
end

function coop.PostCleanUpHook()
    for _, ent in ipairs(ents.FindByClass("prop_vehicle_airboat")) do
        if isentity(ent) and IsValid(ent) then
            ent:Remove()
        end
    end
    for _, ent in ipairs(ents.FindByClass("prop_vehicle_jeep")) do
        if isentity(ent) and IsValid(ent) then
            ent:Remove()
        end
    end

    for _, ent in ipairs(ents.FindByClass("item_suit")) do
        if isentity(ent) and IsValid(ent) then
            ent:Remove()
        end
    end
    for _, ent in ipairs(ents.GetAll()) do
        if isentity(ent) and IsValid(ent) and ent:IsWeapon() and (ent:GetOwner() == NULL or !IsValid(ent:GetOwner())) then
            ent:Remove()
        end
    end
end

function coop.StartRoundSV()
    local plys = {}

    coop.Exiting = false

    net.Start("coop exiting")
    net.WriteBool(false)
    net.Broadcast()

    coop.RoundEnds = CurTime() + coop.TimeRoundEnds

    coop.Gordon = NULL

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == 1002 then
            continue 
        end
        table.insert(plys,ply)
        ply:Spawn()
        ply:SetTeam(1)
        ply.AppearanceOverride = true
    end

    local gondon = table.Random(plys)

    gondon.isGordon = true

    for _, ply in ipairs(plys) do
        coop.SpawnResistance(ply)
    end

    timer.Simple(0,function()
        game.CleanUpMap(false)   
    end)

    coop.Gordon = gondon

    local fraction = maps_fraction[game.GetMap()]

    timer.Simple(0.1,function()
        //coop.SpawnResistance(gondon)
        gondon.isGordon = true
        timer.Simple(1,function()
            if fraction == "rebel_better" then
                gondon:Give("weapon_physcannon")
            end
        end)

        for _, ent in ipairs(ents.FindByClass("prop_vehicle_airboat")) do
            if isentity(ent) and IsValid(ent) then
                ent:Remove()
            end
        end

        for _, ent in ipairs(ents.FindByClass("prop_vehicle_jeep")) do
            if isentity(ent) and IsValid(ent) then
                ent:Remove()
            end
        end
    
        for _, ent in ipairs(ents.FindByClass("item_suit")) do
            if isentity(ent) and IsValid(ent) then
                ent:Remove()
            end
        end

        for _, ent in ipairs(ents.GetAll()) do
            if isentity(ent) and IsValid(ent) and ent:IsWeapon() and (ent:GetOwner() == NULL or !IsValid(ent:GetOwner())) then
                ent:Remove()
            end
        end

        timer.Simple(0.5,function()
            coop.SpawnCater()
            coop.SpawnCar()
        end)
    end) 
end

function coop.RoundThink()
    local CT_ALIVE = team.GetCountLive(team.GetPlayers(1))

    local ExitList = ReadDataMap("coop_nextlevel")

    if #ExitList > 0 then
        for _, Exit in ipairs(ExitList) do
        local Pos = Exit[1]

        for _, ent in ipairs(ents.FindInSphere(Pos,250)) do
            if ent:IsPlayer() and !ent:Alive() then
                    continue 
                end

                if ent:IsPlayer() and ent:Team() == 1002 then
                    continue 
                end
                if ent:IsPlayer() then
                    if ent:InVehicle() then
                        ent:ExitVehicle()
                    end
                    if ent.Fake then
                        ent.LastRagdollTime = 0
                        hg.Faking(ent)
                    end
                    ent:GodEnable()
                    ent:Freeze(true)
                    if !coop.Exiting then
                        coop.Exiting = true
                        coop.ExitsIn = CurTime() + 20
                        net.Start("coop exiting")
                        net.WriteBool(true)
                        net.Broadcast()
                    end
                end
            end
        end
    end

    for _, ent in ipairs(ents.FindByClass("npc_mossman")) do
        ent:SetHealth(100)
    end

    for _, ent in ipairs(ents.FindByClass("npc_alyx")) do
        ent:SetHealth(100)
    end

    for _, ent in ipairs(ents.FindByClass("npc_barney")) do
        ent:SetHealth(100)
    end

    for _, ent in ipairs(ents.FindByClass("npc_eli")) do
        ent:SetHealth(100)
    end

    for _, ent in ipairs(ents.FindByClass("npc_breen")) do
        ent:SetHealth(100)
    end

    for _, ent in ipairs(ents.FindByClass("npc_odessa")) do
        ent:SetHealth(100)
    end

    for _, ent in ipairs(ents.FindByClass("npc_monk")) do
        ent:SetHealth(100)
    end

    if CT_ALIVE == 0 and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(2)
    end

    if coop.RoundEnds < CurTime() and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(2)
    end

    if (IsValid(coop.Gordon) and coop.Gordon and !coop.Gordon:Alive() or coop.Gordon == NULL or !IsValid(coop.Gordon)) and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(2)
    end

    if coop.Exiting and coop.ExitsIn < CurTime() then
        RunConsoleCommand("ulx","map",maps[game.GetMap()])
    end
end

function coop.CanStart()
    local mapname = string.lower(game.GetMap())

    if !string.match(mapname,"d1_") and !string.match(mapname,"d2_") and !string.match(mapname,"d3_") then
        return false
    else
        return true
    end
end

function coop.LootSpawn()
    return false
end