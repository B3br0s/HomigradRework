local blockedWeapons = {
    ["weapon_ar2"] = true,
    ["weapon_smg1"] = true,
    ["weapon_shotgun"] = true,
    ["weapon_pistol"] = true,
    ["weapon_357"] = true,
    ["weapon_bugbait"] = true,
    ["weapon_physcannon"] = false,
    ["weapon_stunstick"] = true,
    ["weapon_rpg"] = true,
    ["weapon_slam"] = true
}

hook.Add("PlayerCanPickupWeapon", "BlockSpecificWeaponsPickup", function(ply, weapon)
    if blockedWeapons[weapon:GetClass()] then
        return false
    end
end)
