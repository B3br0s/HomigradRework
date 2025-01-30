util.AddNetworkString("DropItemInv")

net.Receive("DropItemInv",function(l,ply)
    local wepdrop = net.ReadString()
    local prevplywep = ply:GetActiveWeapon()
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

local DEFAULT_SLOTS = 10


hook.Add("PlayerSpawn", "PlayerSpawn_Inventory", function(ply)
    ply.Slots = {}
    ply.SlotsAvaible = 10
    for i = 1, ply.SlotsAvaible do
        ply.Slots[i] = NULL 
        ply:SetNWEntity("Slot"..i,NULL)
    end
end)

hook.Add("Player Think", "SlotsHolder", function(ply, time)
    if #ply:GetWeapons() == 0 then return end
    ply:SetNWFloat("SlotsAvaible",ply.SlotsAvaible)
    if ply.Slots == nil then
        ply.Slots = {}
    end
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
            ply:SetNWEntity("Slot"..i,wep)
        end
    end
    for i = 1,ply.SlotsAvaible do
        if ply.Slots[i] == NULL or ply.Slots[i] != NULL and not ply:HasWeapon(ply.Slots[i]:GetClass()) then
            ply.Slots[i] = NULL-- Null(xiety) кодинг еее😎🤘
            ply:SetNWEntity("Slot"..i,NULL)
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