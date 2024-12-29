local blockedWeapons = {
    ["weapon_ar2"] = "",
    ["weapon_smg1"] = "",
    ["weapon_crossbow"] = "",
    ["weapon_shotgun"] = "",
    ["weapon_pistol"] = "",
    ["weapon_357"] = "",
    ["weapon_bugbait"] = "",
    ["weapon_stunstick"] = "",
    ["weapon_slam"] = "",
    ["weapon_crowbar"] = "weaponn_crowbar"
}

hook.Add("PlayerCanPickupWeapon", "BlockSpecificWeaponsPickup", function(ply, weapon)
    if not IsValid(ply) or not IsValid(weapon) then return end

    local blockedClass = blockedWeapons[weapon:GetClass()]
    if blockedClass then
        local hasReplacement = false
        weapon.spawned = true
        for _, value in ipairs(ply:GetWeapons()) do
            if value:GetClass() == blockedClass then
                hasReplacement = true
                weapon.Spawned = true
                weapon.spawned = true
                break
            end
        end

        timer.Simple(0.1, function()
            if not IsValid(ply) then return end

            if blockedClass ~= "" then
                if not hasReplacement then
                    ply:Give(blockedClass)
                else
                    local weaponInfo = weapons.Get(blockedClass)
                    if weaponInfo and weaponInfo.Primary and weaponInfo.Primary.Ammo then
                        ply:GiveAmmo(30, weaponInfo.Primary.Ammo)
                    end
                end
            end
            if IsValid(weapon) then
                weapon:Remove()
            end
        end)
        return false
    end
end)

hook.Add( "Think", "ReplaceShit", function()
    for id, ent in ipairs( ents.GetAll() ) do
            if IsValid(ent) and weapons.Get(ent:GetClass()) then
                ent.Spawned = true
            end
        if not IsValid(ent) then continue end
		if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_physics_multiplayer" then
            if ent:GetModel() == 'models/props_c17/metalpot002a.mdl' then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
    
                ent:Remove()
    
                local weapon = ents.Create("weapon_pan")

                weapon:SetPos(pos)
                weapon:SetAngles(ang)
                weapon.Spawned = true
                weapon:Spawn()
                weapon.spawned = true
                weapon.Spawned = true
            end
            if ent:GetModel() == 'models/props_junk/garbage_glassbottle003a.mdl' or ent:GetModel() == 'models/props_junk/GlassBottle01a.mdl' then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
    
                ent:Remove()
    
                local weapon = ents.Create("weapon_bottle")

                weapon:SetPos(pos)
                weapon:SetAngles(ang)
                weapon.Spawned = true
                weapon:Spawn()
                weapon.spawned = true
                weapon.Spawned = true
            end
            if ent:GetModel() == 'models/weapons/w_knife_ct.mdl' or ent:GetModel() == 'models/weapons/w_knife_t.mdl' then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
    
                ent:Remove()
    
                local weapon = ents.Create("weapon_sog")

                weapon:SetPos(pos)
                weapon:SetAngles(ang)
                weapon.Spawned = true
                weapon:Spawn()
                weapon.spawned = true
                weapon.Spawned = true
            end
            if ent:GetModel() == 'models/props_junk/shovel01a.mdl' then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
    
                ent:Remove()
    
                local weapon = ents.Create("weapon_shovel")

                weapon:SetPos(pos)
                weapon:SetAngles(ang)
                weapon.Spawned = true
                weapon:Spawn()
                weapon.spawned = true
                weapon.Spawned = true
            end
            if ent:GetModel() == 'models/props_canal/mattpipe.mdl' then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
    
                ent:Remove()
    
                local weapon = ents.Create("weapon_pipe")

                weapon:SetPos(pos)
                weapon:SetAngles(ang)
                weapon.Spawned = true
                weapon:Spawn()
                weapon.spawned = true
                weapon.Spawned = true
            end
            if ent:GetModel() == 'models/props_interiors/pot01a.mdl' then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
    
                ent:Remove()
    
                local weapon = ents.Create("weapon_pot")

                weapon:SetPos(pos)
                weapon:SetAngles(ang)
                weapon.Spawned = true
                weapon:Spawn()
                weapon.spawned = true
                weapon.Spawned = true
            end
            if ent:GetModel() == 'models/props_interiors/pot02a.mdl' then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
    
                ent:Remove()
    
                local weapon = ents.Create("weapon_pot2")

                weapon:SetPos(pos)
                weapon:SetAngles(ang)
                weapon.Spawned = true
                weapon:Spawn()
                weapon.spawned = true
                weapon.Spawned = true
            end
            if ent:GetModel() == 'models/props_junk/garbage_coffeemug001a.mdl' then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
    
                ent:Remove()
    
                local weapon = ents.Create("weapon_cup")

                weapon:SetPos(pos)
                weapon:SetAngles(ang)
                weapon.Spawned = true
                weapon:Spawn()
                weapon.spawned = true
                weapon.Spawned = true
            end
            if ent:GetModel() == 'models/props_junk/Shovel01a.mdl' then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
    
                ent:Remove()
    
                local weapon = ents.Create("weapon_shovel")

                weapon:SetPos(pos)
                weapon:SetAngles(ang)
                weapon.Spawned = true
                weapon:Spawn()
                weapon.spawned = true
                weapon.Spawned = true
            end
            if ent:GetModel() == 'models/props_forest/axe.mdl' or ent:GetModel() == 'models/props/cs_militia/axe.mdl' then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
    
                ent:Remove()
    
                local weapon = ents.Create("weapon_axe")

                weapon:SetPos(pos)
                weapon:SetAngles(ang)
                weapon.Spawned = true
                weapon:Spawn()
                weapon.spawned = true
                weapon.Spawned = true
            end
        end
    end
end)