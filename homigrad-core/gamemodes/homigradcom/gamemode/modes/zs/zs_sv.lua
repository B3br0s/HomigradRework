zs = zs or {}

zs.WaveIn = 0
zs.WaveEndsIn = 0
zs.SpawnWave = 0
zs.wave_active = false
zs.wave = 0

util.AddNetworkString("zs wave")
util.AddNetworkString("zs buy")
util.AddNetworkString("zs_buymenu")

hook.Add("ShowTeam","ZS_OPEN",function(ply)
    if ply:Alive() and ply:Team() == 2 and ROUND_NAME == "zs" and !TableRound().wave_active then
        net.Start("zs_buymenu")
        net.Send(ply)
    end
end)

function zs.SpawnZombie(ply)
    local SpawnList = ReadDataMap("zs_zombie")

    ply:SetTeam(1)

    ply:Spawn()

    ply.AppearanceOverride = true

    local rand = math.random(1,5)

    if zs.wave < 3 then
        if rand == 2 then
            ply:SetPlayerClass("fast_zombie")
        end
    elseif zs.wave < 6 then
        if rand == 1 then
            ply:SetPlayerClass("ghoul")
        if rand == 3 then
            ply:SetPlayerClass("fast_zombie")
        end
    else
        if rand == 2 then
            ply:SetPlayerClass("wraith")
        elseif rand == 1 then
            ply:SetPlayerClass("ghoul")
        if rand == 3 then
            ply:SetPlayerClass("fast_zombie")
        end
    end

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    timer.Simple(0,function()
        ply:SetPlayerClass("zombie")
        ply:SetModel("models/player/zombie_classic.mdl")
        ply:SetPlayerColor(Color(255,0,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function zs.SpawnSurv(ply)
    local SpawnList = ReadDataMap("zs_surv")

    ply:SetTeam(2)

    ply:Spawn()

    ply.AppearanceOverride = true

    ply:SetPos(((table.Random(SpawnList) != nil and table.Random(SpawnList)[1] != nil) and table.Random(SpawnList)[1] or ply:GetPos()))

    ply:Give("weapon_hammer")

    ply:SetNWInt("ZS_POINTS",150)

    timer.Simple(0,function()
        ply:SetModel(table.Random(tdm.Models))
        ply:SetPlayerColor(Color(23,138,0):ToVector())
        ply:SetSubMaterial()
    end)
end

function zs.StartRoundSV()
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 then
            ply:SetTeam(2)
        end
    end

    zs.wave = 0

    //zs.wave_active = false

    timer.Simple(0,function()
        zs.Wave_Wait()

        local Surv = team.GetPlayers(2)

        for _, ply in ipairs(Surv) do
            zs.SpawnSurv(ply)
        end

        for i = 1, (#Surv > 9 and 4 or (#Surv > 4 and 2 or 1)) do
            local zimbi = table.Random(Surv)
            table.RemoveByValue(Surv,zimbi)

            zimbi:SetTeam(1)

            zimbi:KillSilent()
        end

        game.CleanUpMap(false)
    end)
end

function zs.Wave_Wait()
    zs.wave_active = false
    zs.WaveIn = CurTime() + 60
    SetGlobalFloat("zs_wavein",zs.WaveIn)
end

function zs.Wave_Start()
    zs.WaveEndsIn = CurTime() + 60 * 2.5
    SetGlobalFloat("zs_waveendin",zs.WaveEndsIn)
    SetGlobalFloat("zs_wavein",0)
    zs.wave = zs.wave + 1

    local zss = team.GetPlayers(1)

    for _, ply in ipairs(zss) do
        zs.SpawnZombie(ply)
    end
end

function zs.RoundThink()
    local ALIVE = team.GetCountLive(team.GetPlayers(2))
    local Z_ALIVE = team.GetCountLive(team.GetPlayers(1))

    if zs.WaveIn < CurTime() and !zs.wave_active then
        timer.Simple(0,function()
            zs.Wave_Start()
            zs.wave_active = true
        end)
    end

    if zs.WaveEndsIn < CurTime() and zs.wave_active /*or Z_ALIVE == 0 and zs.wave_active*/ then
        zs.wave_active = false
        timer.Simple(0,function()
            zs.Wave_Wait()
        end)
    end

    for _, ply in ipairs(team.GetPlayers(2)) do
        if !ply:Alive() and ply:Team() != 1002 then
            ply:SetTeam(1)
        end
    end

    if zs.wave_active then
        if zs.SpawnWave < CurTime() then
            zs.SpawnWave = CurTime() + 20
            local zss = team.GetPlayers(1)

            for _, ply in ipairs(zss) do
                if ply:Alive() then
                    continue 
                end

                zs.SpawnZombie(ply)
            end
        end
    end

    if ALIVE == 0 and !ROUND_ENDED then
        ROUND_ENDED = true
        ROUND_ENDSIN = CurTime() + 8

        EndRound(1)
    end
end

function zs.LootSpawn()
    return false
end

local cost = {
    ["ent_ammo_5.56x45mm"] = 35,
    ["ent_ammo_7.62x39mm"] = 45,
    ["ent_ammo_12/70gauge"] = 50,
    ["ent_ammo_12/70beanbag"] = 30,
    ["ent_ammo_9x19mmparabellum"] = 20,
    ["ent_ammo_.44magnum"] = 125,
    ["ent_ammo_.50actionexpress"] = 75,
    ["ent_ammo_4.6x30mmnato"] = 45,
    ["ent_ammo_5.7x28mm"] = 50,
    ["ent_ammo_rpg7proj"] = 200,
    ["weapon_glock17"] = 50,  
    ["weapon_fiveseven"] = 60,
    ["weapon_tec9"] = 50,     
    ["weapon_usp_match"] = 60,
    ["weapon_fubar"] = 90,    
    ["weapon_hammer"] = 10,    
    ["weapon_329pd"] = 200,       
    ["weapon_doublebarrel"] = 230,
    ["weapon_ar15"] = 250,        
    ["weapon_870_b"] = 220,       
    ["weapon_sawnoff"] = 280, 
    ["weapon_mp7"] = 200,     
    ["weapon_mp5"] = 180,     
    ["weapon_deagle_b"] = 250,
    ["weapon_deagle_a"] = 270,
    ["weapon_rpk"] = 300,     
    ["weapon_m16a1"] = 250,   
    ["weapon_rpg7"] = 450
}

net.Receive("zs buy",function(l,ply)
    local ent = net.ReadString()
    local tip = net.ReadString()

    local real_ent = ent

    if ply:GetNWInt("ZS_POINTS") < cost[ent] then
        return
    end

    local success

    if tip == "ammo" then
        if string.StartWith(ent, "ent_ammo_") then
            ent = string.sub(ent, 10)

            ent = hg.ammotypes[ent].name

            ply:GiveAmmo(24,ent,true)

            success = true
        end
    elseif tip == "weps" and !ply:HasWeapon(ent) then
        local wep = ply:Give(ent)
        success = true
        if wep.Primary.Ammo != "none" then
            wep:SetClip1(wep:GetMaxClip1())
            //ply:GiveAmmo(wep:Clip1()/2,wep:GetPrimaryAmmoType(),true)
        end
    end

    if success then
        zs.AddPoints(ply,-cost[real_ent])  
    end
end)

function zs.AddPoints(ply,amt)
    local oldval = ply:GetNWInt("ZS_POINTS")

    print(ply:GetNWInt("ZS_POINTS"))

    ply:SetNWInt("ZS_POINTS",oldval + amt)

    print(ply:GetNWInt("ZS_POINTS"))
end 

local dmg_zmb = {
    ["zombie"] = {["low"] = 1,["normal"] = 3,["high"] = 7},
    ["ghoul"] = {["low"] = 2,["normal"] = 5,["high"] = 10},
    ["wraith"] = {["low"] = 3,["normal"] = 7,["high"] = 13},
    ["fast_zombie"] = {["low"] = 2,["normal"] = 5,["high"] = 9},
    ["poison_zombie"] = {["low"] = 5,["normal"] = 9,["high"] = 16},
    ["zombine"] = {["low"] = 4,["normal"] = 4,["high"] = 10},
    ["tank"] = {["low"] = 7,["normal"] = 17,["high"] = 25}
}

hook.Add('EntityTakeDamage', 'ZS_Points_Damage', function(ply, dmginfo)
    if ROUND_NAME != "zs" then
        return
    end
    local att = dmginfo:GetAttacker()
    local inf
    if IsValid(att) and att:IsWeapon() then
        inf = att
        att = att:GetOwner()
    end
    if !ply:IsPlayer() then
        return
    end
    if not IsValid(att) or IsValid(att) and !att:IsPlayer() then print(att) return end
    if att:Team() == 1 then return end
    if ply:Team() == 2 then return end
    if !ply.PlayerClassName then
        return
    end

    if !IsValid(inf) then
        inf = ply:GetActiveWeapon()
    end

    local mul = 1

    if inf.NumBullet then
        mul = inf.NumBullet / 2
    end

    //print(ply.PlayerClassName)

    local dmg_mul

    local dmg = dmginfo:GetDamage() * mul

    if dmg < 30 then
        dmg_mul = "low"
    elseif dmg < 50 then
        dmg_mul = "normal"
    elseif dmg < 70 then
        dmg_mul = "high"
    end

    zs.AddPoints(att,dmg_zmb[ply.PlayerClassName][dmg_mul] or 1)

    return
end )