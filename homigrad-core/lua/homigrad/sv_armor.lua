util.AddNetworkString("armor_sosal")

hg = hg or {}

concommand.Add("hg_equiparmor",function(ply,cmd,args)
    if hg.Armors[args[1]] then
        local tbl = hg.Armors[args[1]]
        if !ply.armor then
            ply.armor = {}
        end

        ply.armor[tbl.Placement] = args[1]

        net.Start("armor_sosal")
        net.WriteEntity(ply)
        net.WriteTable(ply.armor)
        net.Broadcast()
    end
end)

function hg.Equip_Armor(ply,name)
    if !hg.Armors[name] then
        return
    end

    local tbl = hg.Armors[name]

    ply.armor[tbl.Placement] = name

    net.Start("armor_sosal")
    net.WriteEntity(ply)
    net.WriteTable(ply.armor)
    net.Broadcast()
end

local hit_armor = {
    [HITGROUP_HEAD] = "head",
    [HITGROUP_CHEST] = "torso",
    [HITGROUP_STOMACH] = "torso",
}

function hg.Armor_Effect(ply,ent,dmg,hitgroup)
    if !hit_armor[dmg:GetDamageType()] then
        return 1,dmg:GetDamageType()
    end
    if dmg:IsDamageType(DMG_CRUSH) then
        return 0.5,dmg:GetDamageType()
    end
    if !dmg:IsDamageType(DMG_CLUB+DMG_SLASH+DMG_BULLET+DMG_BUCKSHOT) then
        return 1,dmg:GetDamageType()
    end
    local hit = hit_armor[hitgroup]
    if !hit then
        return 1,dmg:GetDamageType()
    end
    if ply.armor[hit] != "NoArmor" then
        sound.Play("physics/metal/metal_solid_impact_bullet"..math.random(1,4)..".wav",dmg:GetDamagePosition(),75,100,1)
        if IsValid(dmg:GetAttacker()) then
            local dir = -dmg:GetDamageForce()
		    dir:Normalize()
		    local effdata = EffectData()
            
		    effdata:SetOrigin( dmg:GetDamagePosition() - dir )
		    effdata:SetNormal( dir )
		    effdata:SetMagnitude(0.25)
		    effdata:SetRadius(4)
		    effdata:SetNormal(dir)
		    effdata:SetStart(dmg:GetDamagePosition() + dir)
		    effdata:SetEntity(ent)
		    effdata:SetSurfaceProp(surfaceprop or 67)
		    effdata:SetDamageType(dmg:GetDamageType())

            util.Effect("Impact",effdata)
        end
        local tbl = hg.Armors[ply.armor[hit]]
        local dmg_mul = math.Clamp(2.25 - tbl.Protection,0,1)
        return dmg_mul,DMG_CLUB
    end
    return 1,dmg:GetDamageType()
end

hook.Add("InitArmor","Player_Armor",function(ply)
    ply.armor = {}

    ply.armor.torso = "NoArmor"
    ply.armor.head =  "NoArmor"
    ply.armor.face =  "NoArmor"
    ply.armor.back =  "NoArmor"
end)

function hg.DropArmor(ply,name,pos,vel)
    local ent_name = ("ent_armor_"..name)
    local tbl = hg.Armors[name]

    if !ply.armor then
        return
    end

    if !tbl then
        return
    end

    if !ply.armor[tbl.Placement] then
        return
    end

    local tr = hg.eyeTrace(ply,50)

    if not pos then
        pos = tr.HitPos
    end

    if not vel then
        vel = Vector(0,0,0)
    end

    local ent = ents.Create(ent_name)
    ent:SetPos(pos)
    ent:Spawn()
    ent:GetPhysicsObject():SetVelocity(vel)
end