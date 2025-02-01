util.AddNetworkString("hmcd_role")
util.AddNetworkString("hmcd_roundtype")
util.AddNetworkString("EndRound")

homicide.TRAITORLOADOUT = {
    "weapon_fiveseven",
    "weapon_kabar",
    "weapon_ied",
    "weapon_vx",
    "weapon_tdoxin"
}

homicide.GUNMANLOADOUT = {
    "weapon_870"
}

homicide.TRAITOR = homicide.TRAITOR or nil
homicide.GUNMAN = homicide.GUNMAN or nil

function homicide.StartRoundSV()
    --nil / NULL
end

function homicide.RetryTraitor()
    homicide.SetTraitor()
end
 
function homicide.SetTraitor()
    homicide.TRAITOR = table.Random(player.GetAll())
    homicide.TRAITOR.RoleT = true

    local ply = homicide.TRAITOR

    net.Start("hmcd_role")
    net.WriteFloat(1)--1 traitor/2 gunman
    net.Send(homicide.TRAITOR)

    for _, wep in ipairs(homicide.TRAITORLOADOUT) do
        local nigga = ply:Give(wep)
        if not IsValid(nigga) then continue end
        nigga:SetClip1(nigga:GetMaxClip1())
        nigga:SetNWBool("HideBack",true)
    end
end

function homicide.RetryGun()
    homicide.SetGunMan()
end

function homicide.CanJoin(teamID)
    if teamID == 3 then return false end
    return true
end

function homicide.EndRound(winner)
    if winner == 1 and IsValid(homicide.TRAITOR) then--Выиграл трейтор
    net.Start("EndRound")
    net.WriteColor(Color(180,0,0))
    net.WriteString("Предатель убил всех.")
    net.WriteString("Предателем был "..homicide.TRAITOR:Name())
    net.WriteEntity(homicide.TRAITOR)
    net.Broadcast()
    elseif winner == 2 and IsValid(homicide.TRAITOR) then--Выиграли инносенты
    net.Start("EndRound")
    net.WriteColor(Color(0,33,180))
    local attacker = NULL
    if homicide.TRAITOR.LastDMGInfo != nil then
        if homicide.TRAITOR.LastDMGInfo:GetAttacker():IsPlayer() then
            attacker = homicide.TRAITOR.LastDMGInfo:GetAttacker()
        end
    end
    net.WriteString("Предатель был убит " .. (attacker != NULL and attacker:Name() or " "))
    net.WriteString("Предателем был "..homicide.TRAITOR:Name())
    net.WriteEntity(attacker != NULL and attacker or homicide.GUNMAN)
    net.Broadcast()
    else
    PrintMessage(3,"?")
    end
end

function homicide.SetGunMan()
    local ply = table.Random(player.GetAll())

    if ply.RoleT then
        ply = nil
        homicide.RetryGun()
        return
    end

    homicide.GUNMAN = ply
    homicide.GUNMAN.RoleCT = true

    net.Start("hmcd_role")
    net.WriteFloat(2)
    net.Send(homicide.GUNMAN)

    for _, wep in ipairs(homicide.GUNMANLOADOUT) do
        local nigga = ply:Give(wep)
        if not IsValid(nigga) then continue end
        nigga:SetClip1(nigga:GetMaxClip1())
    end
end