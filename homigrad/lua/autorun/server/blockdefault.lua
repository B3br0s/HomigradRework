local blockedWeapons = {
    ["weapon_ar2"] = "weapon_sar2",
    ["weapon_smg1"] = "weapon_ump",
    ["weapon_crossbow"] = "weapon_hk_arbalet",
    ["weapon_shotgun"] = "weapon_spas12",
    ["weapon_pistol"] = "weapon_m1a1",
    ["weapon_357"] = "weapon_deagle",
    ["weapon_bugbait"] = "",
    ["weapon_stunstick"] = "weapon_stunstick_hg",
    ["weapon_rpg"] = "weapon_rpgg",
    ["weapon_slam"] = ""
}

hook.Add("PlayerCanPickupWeapon", "BlockSpecificWeaponsPickup", function(ply, weapon)
    if blockedWeapons[weapon:GetClass()] then
        local plyweaponstable = {}
        for index, value in ipairs(ply:GetWeapons()) do
            if value:GetClass() != blockedWeapons[weapon:GetClass()] then
                table.insert(plyweaponstable,value)
            end
        end
        timer.Simple(0.1,function ()
            if plyweaponstable[blockedWeapons[weapon:GetClass()]] then
                ply:Give(blockedWeapons[weapon:GetClass()])
                weapon:Remove()
            else
                ply:GiveAmmo(30,weapons.Get(blockedWeapons[weapon:GetClass()]).Primary.Ammo)
                ply:EmitSound("weapons/pistol/pistol_empty.wav")
                weapon:Remove()
            end
        end)
        return false
    end
end)

