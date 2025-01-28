--[[
TODO:
    1.Очищение предмета при выкидывании его,
    2.Проверка на админский предмет типо weapons.Get(wep:GetClass()).AdminOnly или как то так.
    3.добавить PLYSPAWN_OVERRIDE return end
]]

local BlackList = {
    ["weapon_hands"] = true,
    ["weapon_physgun"] = true,
}

hook.Add("PlayerSpawn", "PlayerSpawn_Inventory", function(ply)
    ply.Slots = {}
    ply.SlotsAvaible = 10
    for i = 1, 10 do
        ply.Slots[i] = NULL 
    end
end)

hook.Add("Player Think", "SlotsHolder", function(ply, time)
    if #ply:GetWeapons() == 0 then return end
    if not ply.NextINVThink then
        ply.NextINVThink = 0
    end
    if ply.NextINVThink > CurTime() then
        ply.NextINVThink = CurTime() + 0.1
    end
    for i, wep in ipairs(ply:GetWeapons()) do
        if IsValid(wep) and BlackList[wep:GetClass()] then continue end
        if ply:HasWeapon(wep:GetClass()) and (not IsValid(ply.Slots[i]) or ply.Slots[i] == NULL) then
            ply.Slots[i] = wep
        end
    end
    for i = 1,ply.SlotsAvaible do
        if ply.Slots[i] == NULL or ply.Slots[i]:GetClass() == NULL or not ply:HasWeapon(ply.Slots[i]:GetClass()) then
            ply.Slots[i] = NULL
        end
    end
end)

function CheckSlots(ply)
    local FilledSlots = 0
    for i = 1,ply.SlotsAvaible do
        --print(ply.Slots[i]:GetClass() .. " " .. i)
        if ply.Slots[i] == NULL then return false end
        if ply.Slots[i] != NULL then FilledSlots = FilledSlots + 1 end
    end
    if FilledSlots == ply.SlotsAvaible then
        return true
    end
end

hook.Add("PlayerCanPickupWeapon","Homigrad_Inventory",function(ply,wep)
    local slotsfull = CheckSlots(ply)
    if wep.AdminOnly or BlackList[wep:GetClass()] then
        if not ply:IsAdmin() then return false end
        if ply:IsAdmin() then return true end
    end
    return not slotsfull
end)