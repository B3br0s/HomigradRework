util.AddNetworkString("DropItemInv")
util.AddNetworkString("ChangeInvSlot")-- :p
util.AddNetworkString("ChangeInvSlot_ToClient")

net.Receive("ChangeInvSlot",function(len,ply)
    local SlotID1 = net.ReadFloat()
    local SlotID2 = net.ReadFloat()

    local Slot1Backpack = net.ReadBool()
    local Slot2Backpack = net.ReadBool()

    local Slot1Item = net.ReadEntity()
    local Slot2Item = net.ReadEntity()
    local backpackss
    if Slot1Backpack or Slot2Backpack then
        local armorid,ArmorTBL,ArmorTBL2 = GetItemInSlot(ply.EZarmor, "back")
        
        if ArmorTBL2 != nil and ArmorTBL2.IsBackpack then
            backpackss = ArmorTBL
        end
    end

    if Slot1Backpack then
        backpackss.items_bp[SlotID1] = NULL
        --ply:PickupWeapon(Slot1Item) завтра -- какой нахуй пикап вепон
    else
        ply:SetNWEntity("Slot"..SlotID1,NULL)
        ply.Slots[SlotID1] = NULL
    end

    if Slot2Backpack then
        backpackss.items_bp[SlotID2] = Slot1Item
        --JMod.UpdateInventory_ToClient(ply) 
        --[[Just a Bogler — Сегодня, в 16:28
            убирай её нахуй
            из кода
            я забыл её вырезать
            её нету как раз таки
            я ее в полу бреду написал]]
        --ply:StripWeapon(Slot1Item:GetClass()) завтра
    else
        ply:SetNWEntity("Slot"..SlotID2,Slot1Item)
        ply.Slots[SlotID2] = Slot1Item
    end
    if Slot1Backpack or Slot2Backpack then
    end
end)


net.Receive("DropItemInv",function(l,ply)
    local wepdrop = net.ReadString()
    local prevplywep = ply:GetActiveWeapon()
    for i=1,ply.SlotsAvaible do
        if ply.Slots[i] == nil or ply.Slots[i] == NULL then continue end
        if ply.Slots[i]:GetClass() == wepdrop or ply.Slots[i]:GetClass() == 'worldspawn' then
            ply.Slots[i] = NULL
            ply:SetNWEntity("Slot"..i,NULL)
        end
    end
    if !ply:HasWeapon(wepdrop) then
        return
    end
    
    ply:SelectWeapon(wepdrop)
    ply:Say("*drop")
    ply:SelectWeapon(prevplywep)

end)

local BlackList = {
    ["weapon_hands"] = true,
    ["weapon_physgun"] = true,
    ["gmod_tool"] = true,
}

local DoNotClaim = {
    ["weapon_m4super"] = true,
    ["weapon_870"] = true,
    ["weapon_r8"] = true,
    ["homigrad_base"] = true,
}

local DEFAULT_SLOTS = 10


hook.Add("PlayerSpawn", "PlayerSpawn_Inventory", function(ply)
    ply:Give("weapon_hands")
    ply.Slots = {}
    ply.SlotsAvaible = 10
    for i = 1, ply.SlotsAvaible do
        ply.Slots[i] = NULL 
        ply:SetNWEntity("Slot"..i,NULL)
    end
end)

function SlotsHaveWep(ply, wep)
    for i = 1, ply.SlotsAvaible do
        if weapons.Get(ply.Slots[i]) and ply.Slots[i]:GetClass() == wep then
            return true
        end
    end
    return false
end

function PlayerHasWeapon(ply,item)
    for i=1,10 do
        if ply.Slots[i] ~= NULL then
            if item:EntIndex() == ply.Slots[i]:EntIndex() then
                return true 
            end
        end
    end
    return false 
end

hook.Add("Player Think", "SlotsHolder", function(ply, time)

    if #ply:GetWeapons() == 0 then return end
    ply:SetNWFloat("SlotsAvaible", ply.SlotsAvaible)
        
    if not ply.Slots then
        ply.Slots = {}
    end
    if not ply.NextINVThink then
        ply.NextINVThink = 0
    end
    
    if ply.NextINVThink > CurTime() then
        ply.NextINVThink = CurTime() + 0.1
    end
    for i=1,ply.SlotsAvaible do 
        if ply.Slots[i] ~= NULL and IsValid(ply.Slots[i]) then 
            if !ply:HasWeapon(ply.Slots[i]:GetClass()) then
                if not IsValid(ply.Slots[i]) or not weapons.Get(ply.Slots[i]) then
                    ply.Slots[i] = NULL
                    ply:SetNWEntity("Slot" .. i, NULL) 
                end
            end
        end
    end
    for ig, wep in pairs(ply:GetWeapons()) do
        --print(IsValid(wep) and BlackList[wep:GetClass()])
        if !PlayerHasWeapon(ply,wep) then
            for i=1,10 do 
                if IsValid(wep) and BlackList[wep:GetClass()] then continue end
                if ply.Slots[i - 1] == NULL then 
                    ply.Slots[i - 1] = wep
                    ply:SetNWEntity("Slot" .. i - 1, wep)
                    break 
                end
            end
        end
    end
    
end)


function CheckSlots(ply)
    local FilledSlots = 0
    if not ply.SlotsAvaible then
        ply.SlotsAvaible = 10
    end
    for i = 1,ply.SlotsAvaible do
        --print(ply.Slots[i]:GetClass() .. " " .. i)
        if ply.Slots == nil then return end
        if ply.Slots[i] == NULL then return false end
        if ply.Slots[i] != NULL then FilledSlots = FilledSlots + 1 end
    end
    if FilledSlots == ply.SlotsAvaible then
        return true
    end
end

hook.Add("PlayerCanPickupWeapon","Homigrad_Inventory",function(ply,wep)
    if wep.IgnoreAll then
        return true
    end
    if wep.CanPickup then
        return wep.CanPickup
    end
    if wep.TwoHanded ~= nil then
        for _, weapon in pairs(ply:GetWeapons()) do 
            if weapon.TwoHanded ~= nil then  
                return false
            end
        end
    end
    if wep.TwoHanded == nil and wep.Base == 'homigrad_base' then
        for _, weapon in pairs(ply:GetWeapons()) do 
            if weapon.TwoHanded == nil and weapon.weaponInvCategory != nil and wep.Base == 'homigrad_base' then  
                return false
            end
        end
    end

    
    local slotsfull = CheckSlots(ply)
    if wep.AdminOnly or BlackList[wep:GetClass()] then
        if not ply:IsAdmin() then return false end
        if ply:IsAdmin() then return true end
    end
    return not slotsfull
end)

--[[                            :*.                
                           =*:*:          ==.  
                           -*:*:        -+:*-  
                           -*:*:     :-+:.==.  
                           -*:**====**:.-+     
                       .:*++-:+=..+:-*.+:      
                      :-.......++:#:-*.*-      
                       :#***-:..-+.+=.:+-      
                             -++:..:=+-        
        .-+###*+-.             ++..*=          
     .-*@#++++:-#@%+.        :+:.==            
    *+*#.     **   =@#     :*:.=+              
  :*=:+#   :@@--@@.-@+*- .*-.:*.               
 .++:.:=+   :%#*@@#+-:*+--.:+:                 
 =*:..:-:#@%#:....:--:-:.:+-                   
 ++..-#@:--::::::-:  -=++-                     
 =*::-#%  +  .=   :  -=*=                      
 .++:-+%     -*     =++.                      
  :*=::=  #.-  %:.=*++*-                       
   .**=---. .% * -==**:                        
     :=*+====--=++*+:                          
        .-+####+=:                             
                                               
                                               ]]
--https://media.tenor.com/vsB8nAqmCrgAAAAe/emoticon-rock-and-roll.png