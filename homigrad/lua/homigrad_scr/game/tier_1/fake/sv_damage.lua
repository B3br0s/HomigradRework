if engine.ActiveGamemode() == "homigradcom" then
    hook.Add("PlayerSpawn","Damage",function(ply)
        if PLYSPAWN_OVERRIDE then return end
    
        ply.Organs = {
            ['brain']=2,
            ['lungs']=5,
            ['liver']=10,
            ['stomach']=3,
            ['intestines']=10,
            ['heart']=2,
            ['artery']=0.1,
            ['spine']=2
        }
    
        ply.InternalBleeding=nil
        ply.InternalBleeding2=nil
        ply.InternalBleeding3=nil
        ply.InternalBleeding4=nil
        ply.InternalBleeding5=nil
        ply.arterybleeding=false
        ply.brokenspine=false
        ply.Attacker = nil
        ply.KillReason = nil
    
    
        ply.msgLeftArm = 0
        ply.msgRightArm = 0
        ply.msgLeftLeg = 0
        ply.msgRightLeg = 0
        
        ply.LastDMGInfo = nil
        ply.LastHitPhysicsBone = nil
        ply.LastHitBoneName = nil
        ply.LastHitGroup = nil
        ply.LastAttacker = nil
    end)
    
    local filterEnt
    local function filter(ent)
        return ent == filterEnt
    end
    
    local util_TraceLine = util.TraceLine
    
    function GetPhysicsBoneDamageInfo(ent,dmgInfo)
        local pos = dmgInfo:GetDamagePosition()
        local dir = dmgInfo:GetDamageForce():GetNormalized()
    
        dir:Mul(1024 * 16)
    
        local tr = {}
        tr.start = pos
        tr.endpos = pos + dir
        tr.filter = filter
        filterEnt = ent
        tr.ignoreworld = true
    
        local result = util_TraceLine(tr)
        if result.Entity ~= ent then
            tr.endpos = pos - dir
    
            return util_TraceLine(tr).PhysicsBone
        else
            return result.PhysicsBone
        end
    end
    
    local NULLENTITY = Entity(-1)
    
    hook.Add("EntityTakeDamage","ragdamage",function(ent,dmginfo) --урон по разным костям регдолла
        if IsValid(ent:GetPhysicsObject()) and dmginfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT+DMG_CLUB+DMG_GENERIC+DMG_BLAST) then ent:GetPhysicsObject():ApplyForceOffset(dmginfo:GetDamageForce():GetNormalized() * math.min(dmginfo:GetDamage() * 10,3000),dmginfo:GetDamagePosition()) end
        local ply = RagdollOwner(ent) or ent
        if ent.IsArmor then
            ply = ent.Owner
            ent = ply:GetNWEntity("Ragdoll") or ply
        end
    
        if not ply or not ply:IsPlayer() or not ply:Alive() or ply:HasGodMode() then
            return
        end
    
        local rag = ply ~= ent and ent
        
        if rag and dmginfo:IsDamageType(DMG_CRUSH) and att and att:IsRagdoll() then
            dmginfo:SetDamage(0)
    
            return true
        end
    
        local physics_bone = GetPhysicsBoneDamageInfo(ent,dmginfo)
    
        --[[if not bone then
            local att = dmginfo:GetAttacker()
            if IsValid(att) and att:IsPlayer() then att:ChatPrint("Незарегало.") end
            ply:ChatPrint("Незарегало.")--fun moment
            print("незарегало.")
    
            return --impossible
        end]]--
    
        local hitgroup
        local isfall
    
        local bonename = ent:GetBoneName(ent:TranslatePhysBoneToBone(physics_bone))
        ply.LastHitBoneName = bonename
    
        if bonetohitgroup[bonename] then hitgroup = bonetohitgroup[bonename] end
    
        local mul = RagdollDamageBoneMul[hitgroup]
    
        if rag and mul then dmginfo:ScaleDamage(mul) end
    
        local entAtt = dmginfo:GetAttacker()
        local att =
            (entAtt:IsPlayer() and entAtt:Alive() and entAtt) or
            --RagdollOwner(entAtt) or
            (entAtt:GetClass() == "wep" and entAtt:GetOwner())-- or
            --(IsValid(att) and att)
        --att = att ~= ply and att
        att = dmginfo:GetDamageType() ~= DMG_CRUSH and att or ply.LastAttacker
    
        ply.LastAttacker = att
        ply.LastHitGroup = hitgroup
    
        local armors = JMod.LocationalDmgHandling(ply,hitgroup,dmginfo)
        local armorMul,armorDur = 1,0
        local haveHelmet
    
        for armorInfo,armorData in pairs(armors) do
            local dur = armorData.dur / armorInfo.dur
    
            local slots = armorInfo.slots
            if dmginfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT) then
                if (slots.mouthnose or slots.head) then
                    sound.Emit(ent,"homigrad/player/headshot_helmet.wav",90)
    
                    haveHelmet = true
                elseif
                    slots.leftshoulder or
                    slots.rightshoulder or
                    slots.leftforearm or
                    slots.rightforearm or
                    slots.leftthigh or
                    slots.rightthigh or
                    slots.leftcalf or
                    slots.rightcalf
                then
                    sound.Emit(ent,"homigrad/physics/shield/bullet_hit_shield_0"..math.random(1,7)..".wav",90)
                else
                    sound.Emit(ent,"homigrad/physics/shield/bullet_hit_shield_0"..math.random(1,7)..".wav",90)
                end
            end
    
            if dur >= 0.25 then
                armorDur = (armorData.dur / 100) * dur
                --dur = math.max(dur - 0.5,0)
    
                armorMul = math.max(1 - armorDur,0.25)
    
                break
            end
        end
    
        dmginfo:SetDamage(dmginfo:GetDamage() * armorMul)
        local rubatPidor = DamageInfo()
        rubatPidor:SetAttacker(dmginfo:GetAttacker())
        rubatPidor:SetInflictor(dmginfo:GetInflictor())
        rubatPidor:SetDamage(dmginfo:GetDamage())
        rubatPidor:SetDamageType(dmginfo:GetDamageType())
        rubatPidor:SetDamagePosition(dmginfo:GetDamagePosition())
        rubatPidor:SetDamageForce(dmginfo:GetDamageForce())
    
        ply.LastDMGInfo = rubatPidor
        if ply.LastDMGInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT+DMG_BURN+DMG_BLAST+DMG_SLOWBURN)then
            if ply.Explosive then
                ply.Explosive = false
                for i = 1,30 do
                local FireVec = ( VectorRand() * .3 + Vector(math.random(-10,10), math.random(-10,10), .3)):GetNormalized()
                FireVec.z = FireVec.z / 2
                local Flame = ents.Create("ent_jack_gmod_eznapalm")
                Flame:SetPos(ply:GetPos() + Vector(math.random(-10,10), math.random(-10,10), 50))
                Flame:SetAngles(FireVec:Angle())
                Flame:SetOwner(game.GetWorld())
                JMod.SetOwner(Flame, game.GetWorld())
                Flame.SpeedMul = 0.25
                Flame.Creator = game.GetWorld()
                Flame.HighVisuals = true
                Flame:Spawn()
                Flame:Activate()
                end
                local dinfo = DamageInfo()
                dinfo:SetDamage(999999)
                dinfo:SetDamageType(DMG_BLAST)
                ply:TakeDamageInfo(dinfo)
                ply:ChatPrint("Ты взорвался от пропана в твоём организме.")
                local effectdata = EffectData()
                effectdata:SetOrigin(ply:GetPos())
                effectdata:SetAngles(Angle(math.random(360),math.random(360),math.random(360)))
                effectdata:SetScale(75)
                util.Effect("Explosion", effectdata)
                util.Effect("HelicopterMegaBomb", effectdata)
                util.Effect("Explosion", effectdata)
                util.Effect("ElectricSpark", effectdata)
                util.Effect("HelicopterImpact", effectdata)
                JMod.Sploom(ply,ply:GetPos(),150)
                JMod.Sploom(ply,ply:GetPos(),150)
                sound.Play("explosions/doi_panzerschreck_02_close.wav",ply:GetPos())
                ply:EmitSound("explosions/doi_ty_03_water.wav")
                JMod.WreckBuildings(ply, ply:GetPos(), 3)
                JMod.BlastDoors(ply, ply:GetPos(), 3)
    
                timer.Simple(.01, function()
                    for i = 1, 5 do
                        timer.Simple(.02 * i,function ()
                            ParticleEffect("50lb_air", ply:GetPos() * math.random(1,5), Angle(math.random(360),math.random(360),math.random(360)))
                            ParticleEffect("50lb_air", ply:GetPos() * math.random(1,3), Angle(math.random(360),math.random(360),math.random(360)))
                            ParticleEffect("50lb_air", ply:GetPos() * math.random(1,4), Angle(math.random(360),math.random(360),math.random(360)))
                        end)	
                    end
                end)
            end
        end
        if ply.LastDMGInfo:IsDamageType(DMG_CRUSH+DMG_FALL)then
        if rag:GetVelocity():Length() > 2 and rag:GetVelocity():Length() < 150 then
            dmginfo:ScaleDamage(0)
        elseif rag:GetVelocity():Length() > 150 and rag:GetVelocity():Length() < 350 then
            dmginfo:ScaleDamage(0.1)
        elseif rag:GetVelocity():Length() > 350 and rag:GetVelocity():Length() < 460 then
            dmginfo:ScaleDamage(0.2)
        elseif rag:GetVelocity():Length() > 460 and rag:GetVelocity():Length() < 550 then
            dmginfo:ScaleDamage(0.3)
        elseif rag:GetVelocity():Length() > 550 and rag:GetVelocity():Length() < 600 then
            dmginfo:ScaleDamage(0.4)
        elseif rag:GetVelocity():Length() > 600 and rag:GetVelocity():Length() < 700 then
            dmginfo:ScaleDamage(0.5)
        elseif rag:GetVelocity():Length() > 700 and rag:GetVelocity():Length() < 800 then
            dmginfo:ScaleDamage(0.6)
        end
        else
            dmginfo:ScaleDamage(1)
        end
        
        hook.Run("HomigradDamage",ply,hitgroup,dmginfo,rag,armorMul,armorDur,haveHelmet)
        local dmgmult = {
            ['ValveBiped.Bip01_Head1']=1.5,
            ['ValveBiped.Bip01_Spine']=0.26,
            ['ValveBiped.Bip01_R_Hand']=0.23,
            ['ValveBiped.Bip01_R_Forearm']=0.23,
            ['ValveBiped.Bip01_R_Foot']=0.23,
            ['ValveBiped.Bip01_R_Thigh']=0.23,
            ['ValveBiped.Bip01_R_Calf']=0.23,
            ['ValveBiped.Bip01_R_Shoulder']=0.23,
            ['ValveBiped.Bip01_R_Elbow']=0.23,
            ['ValveBiped.Bip01_L_Hand']=0.23,
            ['ValveBiped.Bip01_L_Forearm']=0.23,
            ['ValveBiped.Bip01_L_Foot']=0.23,
            ['ValveBiped.Bip01_L_Thigh']=0.23,
            ['ValveBiped.Bip01_L_Calf']=0.23,
            ['ValveBiped.Bip01_L_Shoulder']=0.23,
            ['ValveBiped.Bip01_L_Elbow']=0.23
        }
        if ply.LastDMGInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT)then
        if dmgmult[ply.LastHitBoneName] then
            dmginfo:ScaleDamage(dmgmult[ply.LastHitBoneName])
        else
            dmginfo:ScaleDamage(0.18)
        end
    end	
        if rag then
    
            ply:SetHealth(ply:Health() - dmginfo:GetDamage())
    
            if ply:Health() <= 0 then ply:Kill() end
        end
    end)
    
    local bonenames = {
        ['ValveBiped.Bip01_Head1']="голову",
        ['ValveBiped.Bip01_Spine']="спину",
        ['ValveBiped.Bip01_R_Hand']="правую руку",
        ['ValveBiped.Bip01_R_Forearm']="правое предплечье",
        ['ValveBiped.Bip01_R_Foot']="правую ногу",
        ['ValveBiped.Bip01_R_Thigh']='правое бедро',
        ['ValveBiped.Bip01_R_Calf']='правую голень',
        ['ValveBiped.Bip01_R_Shoulder']='правое плечо',
        ['ValveBiped.Bip01_R_Elbow']='правый локоть',
        ['ValveBiped.Bip01_L_Hand']='левую руку',
        ['ValveBiped.Bip01_L_Forearm']='левое предплечье',
        ['ValveBiped.Bip01_L_Foot']='левую ногу',
        ['ValveBiped.Bip01_L_Thigh']='левое бедро',
        ['ValveBiped.Bip01_L_Calf']='левую голень',
        ['ValveBiped.Bip01_L_Shoulder']='левое плечо',
        ['ValveBiped.Bip01_L_Elbow']='левый локоть'
    }
    
    local reasons = {
        ["blood"] = "Вы умерли от кровопотери.",
        ["pain"] = "Вы умерли от болевого шока.",
        ["painlosing"] = "Вы умерли от передоза обезболивающим.",
        ["stimulator"] = "Вы умерли от передоза стимулятором.",
        ["obdolbos"] = "Вы умерли от стимулятора обдолбос.",
        ["adrenaline"] = "Вы умерли от передоза адреналином.",
        ["killyourself"] = "Вы совершили суицид.",
        ["killyourselfartery"] = "Вы совершили суицид пробив себе артерию.",
        ["hungry"] = "Вы умерли от голода.",
        ["virus"] = "Вы умерли от заражения.",
        ["ntoxin"] = "Вы умерли от заражения нейро-токсином.",
        ["water"] = "Вы захлебнулись.",
        ["poison"] = "Вы были отравлены.",
        ["instant"] = "Вы умерли от смертельного попадания."
    }
    
    hook.Add("PlayerDeath","plymessage",function(ply,hitgroup,dmginfo)
        local att = ply.LastAttacker
        --if not IsValid(att) then return end
        local boneName = bonenames[ply.LastHitBoneName]
        local add = (boneName and " в " .. boneName or "")
    
        local reason = ply.KillReason
        local dmgInfo = dmgInfo or ply.LastDMGInfo
    
        if ply.KilledByKnifeThrow then ply:ChatPrint(reasons["instant"]) return end
        if ply == att and reasons["killyourself"] then
            ply:ChatPrint("Вы совершили суицид" .. add)	
        elseif reason then
            ply:ChatPrint(reasons[reason])
        elseif att then
            local dmgtype = "от ранения"
        
            dmgtype = dmgInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT) and (dmgInfo:IsDamageType(DMG_BUCKSHOT) and "от ранения осколками/дробью" or "от огнестрельного ранения") or 
                dmgInfo:IsExplosionDamage() and "от минно-взрывной травмы" or 
                dmgInfo:IsDamageType(DMG_SLASH) and "от ножевого ранения" or 
                dmgInfo:IsDamageType(DMG_CLUB+DMG_GENERIC) and "от ранения тупым оружием" or 
                dmgtype
            
            ply:ChatPrint("Вы умерли " .. dmgtype .. add)
            ply:ChatPrint("Вас убил игрок " .. att:Name())
        
            player.EventPoint(att:GetPos(),"hitgroup killed",512,att,ply)
        end
    end)
    end