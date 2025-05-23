hmcd = hmcd or {}

util.AddNetworkString("hmcd_start")

hmcd.GunMan = hmcd.GunMan or nil
hmcd.Traitors = hmcd.Traitors or {}
hmcd.TimeUntilCopsDef = 240
hmcd.TimeUntilCops =  0
hmcd.CopsArrive = false

function hmcd.StartRoundSV()
    hmcd.Type = table.Random(hmcd.SubTypes)

    local NotSpect = {}
    
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 then
            table.insert(NotSpect,ply)
        end
    end

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 and not ply:Alive() then
            ply:SetTeam(1)
            ply:Spawn()
        end
    end

    for _, ply in ipairs(player.GetAll()) do
        ply.IsTraitor = false
        ply.IsGunMan = false
    end

    table.Empty(hmcd.Traitors)
    hmcd.GunMan = nil

    for _, ply in ipairs(player.GetAll()) do
        local SpawnList = (ReadDataMap("hmcd"))

        if ply:Team() != 1002 then
            ply:Spawn()
            ply:GodEnable()
            ply:SetTeam(1)
            ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))
        end

    end

    game.CleanUpMap(false)

    hmcd.AssignTraitor(NotSpect)
    hmcd.AssignGunMan(NotSpect)
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 then
            ply:GodDisable()
            ply:SetModel(table.Random(tdm.Models))
            ply:SetPlayerColor(ColorRand(false):ToVector())
        end
        net.Start("hmcd_start") 
        net.WriteString(hmcd.Type)
        net.WriteBool(ply.IsTraitor)
        net.WriteBool(ply.IsGunMan)
        net.Send(ply)
    end 
end

function hmcd.SpawnTraitor(ply)
    if hmcd.Type != "gfz" then
        local Wep1 = ply:Give("weapon_fiveseven")
        local Wep2 = ply:Give("weapon_sog")
        ply:Give("weapon_f1")
        ply:Give("weapon_ied")

        Wep1:SetNWBool("DontShow",true)

        ply:GiveAmmo(Wep1:GetMaxClip1() * 2, Wep1:GetPrimaryAmmoType(), true)
    else
        ply:Give("weapon_sog")
        ply:Give("weapon_ied")

        //local Wep1 = ply:Give("weapon_pnev")

        //Wep1:SetNWBool("DontShow",true)

        //ply:GiveAmmo(Wep1:GetMaxClip1() * 2, Wep1:GetPrimaryAmmoType(), true)
    end
end

function hmcd.AssignTraitor(tbl)
    local RandomPlayer = table.Random(tbl)

    if RandomPlayer == hmcd.GunMan then
        table.RemoveByValue(tbl,RandomPlayer)
        RandomPlayer = table.Random(tbl)
    end

    RandomPlayer.IsTraitor = true

    hmcd.SpawnTraitor(RandomPlayer)   
end

function hmcd.SpawnCop(ply)
    local Wep1 = ply:Give("weapon_taser")
    local Wep2 = ply:Give("weapon_glock17")

   // ply:GiveAmmo(Wep1:GetMaxClip1() * 1, Wep1:GetPrimaryAmmoType(), true)
    ply:GiveAmmo(Wep2:GetMaxClip1() * 3, Wep2:GetPrimaryAmmoType(), true)
end

function hmcd.AssignGunMan(tbl)
    local RandomPlayer = table.Random(tbl)

    if RandomPlayer.IsTraitor then
        table.RemoveByValue(tbl,RandomPlayer)
        RandomPlayer = table.Random(tbl)
    end

    hmcd.GunMan = RandomPlayer
    RandomPlayer.IsGunMan = true

    if hmcd.Type == "soe" then
        if math.random(1,2) == 2 then
            RandomPlayer:Give("weapon_870_a")
        else
            RandomPlayer:Give("weapon_870_b")
        end
    elseif hmcd.Type == "standard" then
        RandomPlayer:Give("weapon_glock17")
    elseif hmcd.Type == "gfz" then
        //RandomPlayer:Give("weapon_pbat")
        RandomPlayer:Give("weapon_handcuffs")
    end
end

function hmcd.RoundThink()
    local BystandAlive = 0
    local TraitorAlive = 0
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == 1002 then
            continue 
        end
        if ply:Team() != 1002 and ply:Team() != 1 then
            ply:SetTeam(1)
        end
        if ply:Alive() and !ply.IsTraitor and !PlayerIsCuffs(ply) then
            BystandAlive = BystandAlive + 1
        elseif ply:Alive() and ply.IsTraitor and !PlayerIsCuffs(ply) then
            TraitorAlive = TraitorAlive + 1
        end
    end

    if BystandAlive == 0 and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(2)
    end

    if TraitorAlive == 0 and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(1)
    end
end