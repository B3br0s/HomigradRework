
-- Include files:
include("zippy_realistic_blood/misc.lua")
include("zippy_realistic_blood/util.lua")
include("zippy_realistic_blood/damage.lua")
include("zippy_realistic_blood/blood.lua")

-- Setup:
local function setup( ent ) if IsValid(ent) && ent:RealisticBlood_Whitelist() then ent:RealisticBlood_Setup() end end
hook.Add("OnEntityCreated", "OnEntityCreated_RealisticBlood", function( ent ) timer.Simple(0.08, function() setup( ent ) end) end)
hook.Add("PlayerSpawn", "PlayerSpawn_RealisticBlood", function( ply ) setup( ply ) end)

-- Remove bone followers from entities when they die:
local function remove_bone_followers( ent )
    if ent.RealisticBlood_BoneFollowers then
        for _,v in ipairs(ent.RealisticBlood_BoneFollowers) do
            if IsValid(v) then v:Remove() end
        end

        ent.RealisticBlood_BoneFollowers = nil
    end
end
hook.Add("PlayerDeath", "PlayerDeath_RealisticBlood", function( ply ) remove_bone_followers(ply) end)
hook.Add("OnNPCKilled", "OnNPCKilled_RealisticBlood", function( npc ) remove_bone_followers(npc) end)

-- Save last hitgroup:
-- hook.Add("ScaleNPCDamage", "ScaleNPCDamage_RealisticBlood", function( npc, hitgroup )
--     if !npc.UsesRealisticBlood then return end
--     npc.RealisticBlood_HitGroup = hitgroup
-- end)

-- Bullet detection:
local grabbing_backup_data = false

local bullet_damage_pos
local bullet_damage_normal

hook.Add("EntityFireBullets", "EntityFireBullets_RealisticBlood", function( ent, data, ... )
    local data_backup = data
    if grabbing_backup_data then return end

    grabbing_backup_data = true
    hook.Run("EntityFireBullets", ent, data, ...)
    grabbing_backup_data = false

    data = data_backup

    local callback = data.Callback
    data.Callback = function(callback_ent, tr, dmginfo, ...)
        if callback then
            callback(callback_ent, tr, dmginfo, ...)
        end

        if tr.Entity.UsesRealisticBlood then
            bullet_damage_pos = tr.HitPos
            bullet_damage_normal = tr.HitNormal
        end
    end

    return true
end)

local function bullet_damage(dmginfo)
    return dmginfo:IsBulletDamage() or dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT)
end

local function dying( ent, dmg )
    return ( ent:IsNPC() or ent:IsNextBot() ) && ent:Health() - dmg < 1
end

local function phys_damage( dmginfo )
    return dmginfo:IsDamageType(DMG_CRUSH) or dmginfo:IsDamageType(DMG_VEHICLE)
end

-- Damage detection:
local function bullet_damage(dmginfo)
    return dmginfo:IsBulletDamage() or dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT)
end

local function dying( ent, dmg )
    return ( ent:IsNPC() or ent:IsNextBot() ) && ent:Health() - dmg < 1
end

local function phys_damage( dmginfo )
    return dmginfo:IsDamageType(DMG_CRUSH) or dmginfo:IsDamageType(DMG_VEHICLE)
end

--fix for update
local function dmg_serialize(dmginfo)
    return {
        dmg = dmginfo:GetDamage(),
        pos = dmginfo:GetDamagePosition(),
        force = dmginfo:GetDamageForce(),
        type = dmginfo:GetDamageType()
    }
end

local function dmg_deserialize(tbl)
    local dmginfo = DamageInfo()
    dmginfo:SetDamage(tbl.dmg)
    dmginfo:SetDamagePosition(tbl.pos)
    dmginfo:SetDamageForce(tbl.force)
    dmginfo:SetDamageType(tbl.type)

    return dmginfo
end

local function entity_take_damage( ent, dmginfo, last_bullet_damage_pos, last_bullet_damage_normal )

    if !ent.UsesRealisticBlood then return end

    local dead = dying( ent, dmginfo:GetDamage() )

    if !dead then ent.RealisticBlood_HitBone = ent:RealisticBlood_ClosestBone( bullet_damage_pos or dmginfo:GetDamagePosition(), ent:GetSolid() == SOLID_BBOX ) end

    if last_bullet_damage_pos then bullet_damage_pos = last_bullet_damage_pos end
    if last_bullet_damage_normal then bullet_damage_normal = last_bullet_damage_normal end

    if (bullet_damage_pos && bullet_damage_normal) or bullet_damage(dmginfo) then
        -- Bullet Damage:
        if !dead then ent:RealisticBlood_BulletDamage( bullet_damage_pos or dmginfo:GetDamagePosition(), bullet_damage_normal or -dmginfo:GetDamageForce():GetNormalized(), dmginfo ) end

        if bullet_damage_pos then
            ent.RealisticBlood_LastBulletDamagePos = bullet_damage_pos
            timer.Simple(0, function() if IsValid(ent) then ent.RealisticBlood_LastBulletDamagePos = nil end end)
            bullet_damage_pos = false
        end

        if bullet_damage_normal then
            ent.RealisticBlood_LastBulletDamageNormal = bullet_damage_normal
            timer.Simple(0, function() if IsValid(ent) then ent.RealisticBlood_LastBulletDamageNormal = nil end end)
            bullet_damage_normal = false
        end
    elseif phys_damage( dmginfo ) && dmginfo:GetDamage() >= 50 then
        -- Phys damage:
        ent:RealisticBlood_PhysDamage( dmginfo )
    elseif !dead && !phys_damage( dmginfo ) then
        -- Everything except phys, and bullet damage:
        ent:RealisticBlood_OtherDamage( dmginfo )
    end

    ent.RealisticBlood_LastDMGINFO = dmg_serialize(dmginfo)
end

hook.Add("EntityTakeDamage", "EntityTakeDamage_RealisticBlood", function( ent, dmginfo, last_bullet_damage_pos, last_bullet_damage_normal )
    entity_take_damage( ent, dmginfo, last_bullet_damage_pos, last_bullet_damage_normal )
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------=#

    -- Entity become ragdoll stuff --

hook.Add("CreateEntityRagdoll", "CreateEntityRagdoll_RealisticBlood", function( own, rag )
    -- Run damage code for ragdoll:

    rag.UsesRealisticBlood = own.UsesRealisticBlood

    if own.RealisticBlood_LastDMGINFO then
        entity_take_damage( rag, dmg_deserialize(own.RealisticBlood_LastDMGINFO), own.RealisticBlood_LastBulletDamagePos, own.RealisticBlood_LastBulletDamageNormal )
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------=#

