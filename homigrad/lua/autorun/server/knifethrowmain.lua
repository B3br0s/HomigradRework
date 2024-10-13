util.AddNetworkString("ThrowKnife")

net.Receive("ThrowKnife", function ()
    local knifemdl = net.ReadString()
    local power = net.ReadFloat()
    local ply = net.ReadEntity()
    local throwedknife = ply:GetActiveWeapon():GetClass()

    if not IsValid(ply) then return end

    ply:GetActiveWeapon():Remove()

    ply:SelectWeapon("weapon_hands")

    local trace = ply:GetEyeTrace()

    local ent = ents.Create("prop_physics")
    if not IsValid(ent) then return end

    ent:SetModel(knifemdl)
    ent:SetPos(ply:EyePos() + (ply:GetAimVector() * 16))
    ent:SetAngles(ply:EyeAngles())
    ent:Spawn()
    ent.Hitted = false

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        local throwForce = power
        phys:ApplyForceCenter(ply:GetAimVector() * throwForce)

        local spinAxis = Vector(0, 100, 0)
        local spinForce = 500
        phys:AddAngleVelocity(spinAxis * spinForce)
    end

    ent:AddCallback("PhysicsCollide", function(ent, data)
        local hitEntity = data.HitEntity
        if hitEntity and (hitEntity:IsWorld() or hitEntity:IsValid()) and not hitEntity:IsPlayer() and ent.Hitted == false then
            ent.Hitted = true
            local hitPos = data.HitPos
            local hitNormal = data.HitNormal

            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then
                phys:EnableMotion(false)
            end
            local newAng = hitNormal:Angle() + Angle(math.random(40,90), 0, 0)
            ent:SetPos(hitPos - hitNormal * 8)
            ent:SetAngles(newAng)
            ent:EmitSound("weapons/melee/metal_solid_impact_bullet4.wav")
            local droppedknife = ents.Create(throwedknife)
            droppedknife:SetPos(ent:GetPos())
            droppedknife:SetAngles(ent:GetAngles())
            droppedknife:Spawn()
            local physdk = droppedknife:GetPhysicsObject()
            if IsValid(physdk) then
                physdk:EnableMotion(false)
            end
            ent:Remove()
        elseif hitEntity:IsPlayer() and ent.Hitted == false then
            ent.Hitted = true
            local dmg = DamageInfo()
            dmg:SetDamage(25)
            dmg:SetDamageType(DMG_SLASH)
            hitEntity:TakeDamageInfo(dmg)
            hitEntity.Bloodlosing = 25

            ent:EmitSound("weapons/crossbow/hitbod1.wav")

            if !hitEntity.fake then
                Faking(hitEntity)
            end
            
            local droppedknife = ents.Create(throwedknife)
            droppedknife:SetPos(ent:GetPos())
            droppedknife:SetAngles(ent:GetAngles())
            droppedknife:Spawn()
            
            local physdk = droppedknife:GetPhysicsObject()
            if IsValid(physdk) then
                physdk:EnableMotion(true)
            end

            timer.Simple(0.2, function()

                for i, weap in ipairs(hitEntity:GetWeapons()) do
                    if throwedknife == weap:GetClass() then return end
                end
                local ragdoll = hitEntity:GetNWEntity("Ragdoll")
                
                if IsValid(ragdoll) and hitEntity.fake == true then
                    local headBoneIndex = ragdoll:LookupBone("ValveBiped.Bip01_Neck1")    
                    
                    if headBoneIndex then
                        local physBoneIndex = ragdoll:TranslateBoneToPhysBone(headBoneIndex)
            
                        local bone = ragdoll:GetPhysicsObjectNum(physBoneIndex)
                        
                        if IsValid(bone) then
                            local headPos, headAng = ragdoll:GetBonePosition(headBoneIndex)
                                droppedknife:SetPos(headPos + headAng:Forward() * 8 + headAng:Right() * 12)
                                droppedknife:SetAngles(headAng - Angle(0,90,0))
                                if hitEntity["Organs"].artery != 0 then
                                hitEntity["Organs"].artery = 0
                                hitEntity:EmitSound("physics/body/body_medium_break4.wav")
                                hitEntity:EmitSound("artery.wav")
                                hitEntity:EmitSound("physics/flesh/flesh_bloody_impact_hard1.wav")
                                hitEntity:ChatPrint("Тебе в артерию вонзился "..weapons.Get(throwedknife).PrintName)
                                end
                            constraint.Weld(droppedknife, ragdoll, 0, physBoneIndex, 0, true, false)
                        end
                    end
                end
            end)
            
        
            ent:Remove()
        end
                
    end)
end)