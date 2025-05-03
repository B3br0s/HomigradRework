if SERVER then
    util.AddNetworkString("hg foot_kick")
end

function KickFoot(ply)
    if ply.Fake then
        return
    end
    local tr = hg.eyeTrace(ply,125)
    
    ply:SetNWFloat("LastKick",CurTime()+0.25)
    ply:SetNWFloat("KickCD",CurTime() + 1)
    sound.Play("player/foot_fire.wav",ply:GetPos())

    if IsValid(tr.Entity) then
        net.Start("hg foot_kick")
        net.WriteEntity(ply)
        net.WriteEntity(tr.Entity)
        net.Broadcast()

        local dmginfo = DamageInfo()
        dmginfo:SetAttacker(ply)
        dmginfo:SetDamage(math.random(2,5))
        dmginfo:SetDamageType(DMG_CLUB)
        dmginfo:SetInflictor(ply)

        if !tr.Entity:IsPlayer() then
            tr.Entity:GetPhysicsObject():ApplyForceCenter(Vector() + ply:GetAngles():Forward() * 7500 + vector_up * 3000)

            if tr.Entity:GetPhysicsObject():GetMass() > 250 and tr.Entity:GetClass() != "prop_door_rotating" and tr.Entity:GetClass() != "func_door_rotating" then
                sound.Play('homigrad/player/damage'..math.random(1,2)..'.wav',ply:GetPos(),75)
                ply:SetVelocity(ply:GetVelocity() + ply:EyeAngles():Forward() * -250)
                ply:SetHealth(ply:Health() - math.random(3,5))
                ply.rleg = math.Clamp(ply.rleg - 0.25,0,1)
                sound.Play('zcitysnd/male/pain_'..math.random(1,5)..'.mp3',ply:GetPos(),125,2)
                if math.random(1,2) == 2 then
                    hg.Faking(ply,ply:GetVelocity() + ply:EyeAngles():Forward() * -450)
                    net.Start("localized_chat")
                    net.WriteString('leg_hurt')
                    net.Send(ply)
                end
            end

            if tr.Entity:GetClass() == "prop_door_rotating" or tr.Entity:GetClass() == "func_door_rotating" then
                if math.random(1, 5) == 3 then
                    local doorPos = tr.Entity:GetPos()
                    local doorAngles = tr.Entity:GetAngles()
                    local doorModel = tr.Entity:GetModel()
                    local doorSkin = tr.Entity:GetSkin() or 0

                    tr.Entity:EmitSound("physics/wood/wood_box_break" .. math.random(1, 2) .. ".wav")
                    //tr.Entity:Fire("Unlock", "", 0)
                    tr.Entity:Fire("Open", "", 0)
                    tr.Entity:Remove()

                    local physDoor = ents.Create("prop_physics")
                    physDoor:SetModel(doorModel)
                    physDoor:SetPos(doorPos)
                    physDoor:SetAngles(doorAngles)
                    physDoor:SetSkin(doorSkin)
                    physDoor:Spawn()

                    local phys = physDoor:GetPhysicsObject()
                    if IsValid(phys) then
                        local forceDirection = ply:GetAimVector() * 250
                        for i = 1, 50 do
                            timer.Simple(0.001 * i, function()
                                phys:ApplyForceCenter(forceDirection)
                            end)
                        end
                    end
                else
                    tr.Entity:Fire("SetAnimation", "Open", 0)
                    tr.Entity:SetKeyValue("speed", 1000)
                    tr.Entity:Fire("Open", "", 0)
                    timer.Simple(0.03, function()
                        tr.Entity:SetKeyValue("speed", 100)
                    end)
                    tr.Entity:EmitSound("physics/wood/wood_box_break" .. math.random(1, 2) .. ".wav")
                end
            end
        else
            tr.Entity:TakeDamageInfo(dmginfo)
            tr.Entity:SetHealth(ply:Health() - math.random(5,8))
            if math.random(1,3) == 2 then
                hg.Faking(tr.Entity)
            end
        end
    elseif tr.HitWorld and tr.Entity:GetClass() != "prop_door_rotating" and tr.Entity:GetClass() != "func_door_rotating" then
        sound.Play('player/foot_kickwall.wav',ply:GetPos(),75)
        ply:SetVelocity(ply:GetVelocity() + ply:EyeAngles():Forward() * -150)
        ply:SetHealth(ply:Health() - math.random(3,5))
        ply.rleg = math.Clamp(ply.rleg - 0.15,0,1)
        sound.Play('zcitysnd/male/pain_'..math.random(1,5)..'.mp3',ply:GetPos(),125,2)
        if math.random(1,4) == 2 then
            hg.Faking(ply,ply:GetVelocity() + ply:EyeAngles():Forward() * -250)
            net.Start("localized_chat")
            net.WriteString('leg_hurt')
            net.Send(ply)
        end
    end
end

function KickSmoke(ply,ent)
    local ang = ent:GetAngles()
    local pos = ent:GetPos()
    local emitter = ParticleEmit(pos)

    local random = math.random
    local Rand = math.Rand

    local max = random(23,25)
    local startPos,endPos = ent:GetPos():Add(ent:OBBMins()),ent:GetPos():Add(ent:OBBMaxs():Rotate(ang))

    ent:EmitSound('player/foot_kickbody.wav')

    for i = 1,max do
        local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
        if not part then continue end

        local k = i / max
        
        part:SetDieTime(Rand(2,3))

        part:SetStartAlpha(random(27,65)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(5,25)) part:SetEndSize(Rand(45,65))

        part:SetCollide(true)
        part:SetColor(75,75,75)
        //part:SetLight(true)

        part:SetGravity(ParticleGravity)
        part:SetRoll(Rand(-125,125))
        part:SetAirResistance(Rand(600,900))
        part:SetPos(Lerp(k,startPos,endPos))
    end
end

if CLIENT then
    net.Receive("hg foot_kick",function()
        local ply = net.ReadEntity()
        local ent = net.ReadEntity()

        KickSmoke(ply,ent)
    end)
end

hook.Add("Player Think","FootKick_niggadaun",function(ply)
    if !ply:Alive() then
        return
    end
    if ply.Fake then
        return
    end
    if ply:KeyPressed(IN_ZOOM) and ply:GetNWFloat("KickCD",0) < CurTime() then
        if (SERVER and ply.rleg > 0 or ply:GetNWFloat("rleg",0) > 0) then
            if SERVER then
                KickFoot(ply)
            else
                if ply == LocalPlayer() then
                    Viewpunch(Angle(-2,0,0))
                end
            end
        else
            if SERVER then
                ply:SetNWFloat("KickCD",CurTime() + 1)
                
                net.Start("localized_chat")
                net.WriteString('cant_kick')
                net.Send(ply)
            end
        end
    end
    if ply:GetNWFloat("LastKick",0) > CurTime() then
        hg.bone.Set(ply,"r_thigh",Vector(0,0,0),Angle(0,-90,0),1,0.7)
        hg.bone.Set(ply,"r_calf",Vector(0,0,0),Angle(0,20,0),1,0.7)
    else
        hg.bone.Set(ply,"r_thigh",Vector(0,0,0),Angle(0,0,0),1,0.3)
        hg.bone.Set(ply,"r_calf",Vector(0,0,0),Angle(0,0,0),1,0.1)
    end
    
end)