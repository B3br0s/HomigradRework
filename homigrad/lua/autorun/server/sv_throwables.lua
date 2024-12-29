util.AddNetworkString("ThrowKnife")

net.Receive("ThrowKnife", function ()
    local knifemdl = net.ReadString()
    local power = net.ReadFloat()
    local ply = net.ReadEntity()
    local throwedknife = net.ReadString()
    local istrue = net.ReadBool() or false

    ply:EmitSound("weapons/crowbar/crowbar_swing"..math.random(1,3)..".wav")

    if not IsValid(ply) then return end

    for _, v in ipairs(ply:GetWeapons()) do
        if v:GetClass() == throwedknife then
            v:Remove()
        end
    end

    ply:SelectWeapon("weapon_hands")

    local trace = ply:GetEyeTrace()

    local ent = ents.Create("prop_physics")
    if not IsValid(ent) then return end

    ent:SetModel(knifemdl)
    ent:SetPos(ply:EyePos() + (ply:GetAimVector() * 46))
    ent:SetAngles(ply:EyeAngles())
    ent:Spawn()
    ent.Hitted = false

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        local throwForce = power
        for i = 1,10 do
        phys:ApplyForceCenter(ply:GetAimVector() * throwForce)
        end
        local spinAxis = Vector(0, 100, 0)
        local spinForce = 500
        phys:AddAngleVelocity(spinAxis * spinForce)
    end

    ent:AddCallback("PhysicsCollide", function(ent, data)
        local hitEntity = data.HitEntity
        if hitEntity:GetClass() == "func_breakable" then
            hitEntity:TakeDamage(99999)
        end
        if hitEntity and (hitEntity:IsWorld() or hitEntity:IsValid() and hitEntity:GetClass() != "prop_ragdoll") and not hitEntity:IsPlayer() and ent.Hitted == false and not hitEntity:IsNPC() then
            ent.Hitted = true
            local hitPos = data.HitPos
            local hitNormal = data.HitNormal

            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then
                --phys:EnableMotion(false)
            end
            local newAng = hitNormal:Angle() + Angle(math.random(40,90), 0, 0)
            ent:SetPos(hitPos - hitNormal * 6)
            ent:SetAngles(newAng)
            if not istrue then
            ent:EmitSound("physics/concrete/concrete_impact_bullet"..math.random(1,4)..".wav")
            else
            ent:EmitSound("hit.wav"..math.random(1,4)..".wav")
            end
            if istrue then ent:Remove() return end
            local droppedknife = ents.Create(throwedknife)
            droppedknife:SetPos(ent:GetPos())
            droppedknife:SetAngles(ent:GetAngles())
            droppedknife:Spawn()
            local physdk = droppedknife:GetPhysicsObject()
            if IsValid(physdk) then
                if hitEntity:GetClass() != "func_breakable" then
                --physdk:EnableMotion(false)
                end
            end
            ent:Remove()
            droppedknife.Spawned = true
        elseif hitEntity:IsNPC() and ent.Hitted == false then
            ent.Hitted = true
            local dmg = DamageInfo()
            if not istrue then
            dmg:SetDamage(150)
            dmg:SetDamageType(DMG_SLASH)
            else
            dmg:SetDamage(5)
            dmg:SetDamageType(DMG_CLUB)
            end
            hitEntity:TakeDamageInfo(dmg)

            if istrue then ent:Remove() return end

            local droppedknife = ents.Create(throwedknife)
            droppedknife:SetPos(ent:GetPos())
            droppedknife:SetAngles(ent:GetAngles())
            droppedknife:Spawn()
            
            local physdk = droppedknife:GetPhysicsObject()
            if IsValid(physdk) then
                physdk:EnableMotion(true)
            end
            ent:Remove()
            droppedknife.Spawned = true
        elseif hitEntity:GetClass() == "prop_ragdoll" and ent.Hitted == false and RagdollOwner(hitEntity) != nil then
            ent.Hitted = true
            local dmg = DamageInfo()
            if not istrue then
            dmg:SetDamage(150)
            dmg:SetDamageType(DMG_SLASH)
            RagdollOwner(hitEntity):TakeDamageInfo(dmg)
            RagdollOwner(hitEntity):TakeDamage(80)
            hitEntity:TakeDamageInfo(dmg)
            hitEntity:TakeDamage(150)
            else
            dmg:SetDamage(5)
            dmg:SetDamageType(DMG_CLUB)
            end
            dmg:SetAttacker(ply)
            dmg:SetInflictor(ent)
            RagdollOwner(hitEntity):TakeDamageInfo(dmg)
            ent:EmitSound("weapons/crossbow/hitbod1.wav")

            local droppedknife = ents.Create(throwedknife)
            droppedknife:SetPos(ent:GetPos())
            droppedknife:SetAngles(ent:GetAngles())
            droppedknife:Spawn()
            
            local physdk = droppedknife:GetPhysicsObject()
            if IsValid(physdk) then
                physdk:EnableMotion(true)
            end
            ent:Remove()
            droppedknife.Spawned = true
        elseif hitEntity:IsPlayer() and ent.Hitted == false then
            ent.Hitted = true
            local dmg = DamageInfo()
            if not istrue then
            dmg:SetDamage(150)
            dmg:SetDamageType(DMG_SLASH)
            else
            dmg:SetDamage(5)
            dmg:SetDamageType(DMG_CLUB)
            end
            hitEntity:TakeDamageInfo(dmg)

            ent:EmitSound("weapons/crossbow/hitbod1.wav")
            
            if istrue then ent:Remove() return end
            local droppedknife = ents.Create(throwedknife)
            droppedknife:SetPos(ent:GetPos())
            droppedknife:SetAngles(ent:GetAngles())
            droppedknife:Spawn()
            
            local physdk = droppedknife:GetPhysicsObject()
            if IsValid(physdk) then
                physdk:EnableMotion(true)
            end
            droppedknife.Spawned = true

            ent:Remove()
        end
                
    end)
end)