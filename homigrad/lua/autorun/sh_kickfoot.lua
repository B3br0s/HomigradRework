if SERVER then
    if roundActiveName == "deathrun" then return end
    AddCSLuaFile()

    util.AddNetworkString("FootKick")

    net.Receive("FootKick", function(len, ply)
        if ply.LastKickTime and ply.LastKickTime > CurTime() then return end
        ply:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
        ply.Kicking = true
        if not ply.KickedTimes then
            ply.KickedTimes = 0
        end

        ply.LastKickTime = CurTime() + 3

        if not ply:Alive() then return end

        if ply.ISEXPLOITERHAHA then ply:ChatPrint("лох)))00)00))0000)0)))") return end

        ply.stamina = ply.stamina - 10

        timer.Simple(0.3, function()
            ply.Kicking = false
        end)
        local dmgtype = DMG_CLUB
        local dmg = 7.5 --не чеч,не пойдет так,саси

        local trace = ply:GetEyeTrace()
        local kickRadius = 90

        if ply.fake then return end

        if trace.Hit and IsValid(trace.Entity) then
            local target = trace.Entity
            local distance = ply:GetPos():Distance(target:GetPos())

            if distance <= kickRadius then
                if target:GetClass() == "prop_door_rotating" or target:GetClass() == "func_door_rotating" then
                    if math.random(1, 15) == 5 or ply:SteamID() == "STEAM_0:1:526713154" then
                        local doorPos = target:GetPos()
                        local doorAngles = target:GetAngles()
                        local doorModel = target:GetModel()
                        local doorSkin = target:GetSkin() or 0

                        target:EmitSound("physics/wood/wood_box_break" .. math.random(1, 2) .. ".wav")
                        target:Fire("Unlock", "", 0)
                        target:Fire("Open", "", 0)
                        target:Remove()

                        local physDoor = ents.Create("prop_physics")
                        physDoor:SetModel(doorModel)
                        physDoor:SetPos(doorPos)
                        physDoor:SetAngles(doorAngles)
                        physDoor:SetSkin(doorSkin)
                        physDoor:Spawn()

                        local phys = physDoor:GetPhysicsObject()
                        if IsValid(phys) then
                            local forceDirection = ply:GetAimVector() * 1000
                            for i = 1, 50 do
                                timer.Simple(0.001 * i, function()
                                    phys:ApplyForceCenter(forceDirection)
                                end)
                            end
                        end
                    else
                        target:Fire("SetAnimation", "Open", 0)
                        target:SetKeyValue("speed", 1000)
                        target:Fire("Open", "", 0)
                        timer.Simple(0.03, function()
                            target:SetKeyValue("speed", 100)
                        end)
                        target:EmitSound("physics/wood/wood_box_break" .. math.random(1, 2) .. ".wav")
                    end
                elseif target:GetClass() == "player" then
                    target:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 4) .. ".wav")
                    local dmginfo = DamageInfo()
                    dmginfo:SetDamageType(dmgtype)
                    dmginfo:SetAttacker(ply)
                    dmginfo:SetDamage(dmg)
                    target:TakeDamageInfo(dmginfo)
                    Faking(target)

                    local rag = target:GetNWEntity("Ragdoll")
                    if IsValid(rag) then
                        local forceDirection = ply:GetAimVector() * 230
                        for i = 1, 20 do
                            timer.Simple(0.001 * i, function()
                                rag:GetPhysicsObject():ApplyForceCenter(forceDirection * 2)
                            end)
                        end
                    end
                elseif target:GetClass() == "prop_ragdoll" then
                    target:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 4) .. ".wav")

                    if RagdollOwner(target):Alive() then
                        local dmginfo = DamageInfo()
                        dmginfo:SetDamageType(dmgtype)
                        dmginfo:SetAttacker(ply)
                        dmginfo:SetDamage(dmg)
                        target:TakeDamageInfo(dmginfo)
                    end
                    local forceDirection = ply:GetAimVector() * 30
                    for i = 1, 10 do
                        timer.Simple(0.001 * i, function()
                            target:GetPhysicsObject():ApplyForceCenter(forceDirection * 20)
                        end)
                    end
                elseif target:GetClass() == "prop_physics" or target:GetClass() == "prop_physics_multiplayer" or target:GetClass() == "Pod" or target:GetClass() == "pod" then
                    target:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 4) .. ".wav")
                    local forceDirection = ply:GetAimVector() * 250
                    for i = 1, 50 do
                        timer.Simple(0.001 * i, function()
                            target:GetPhysicsObject():ApplyForceCenter(forceDirection * 40)
                        end)
                    end
                end
            end
        end
    end)

    timer.Create("DecreaseKickedTimes", 1, 0, function()
        for _, ply in ipairs(player.GetAll()) do
            if ply.KickedTimes and ply.LastKickTime and CurTime() - ply.LastKickTime > 5 then
                ply.KickedTimes = math.max(0, ply.KickedTimes - 1)
                ply.LastKickTime = CurTime()
            end
        end
    end)

    hook.Add("PlayerThink", "KickingAnim", function(ply, time)
        if ply.Kicking then
            if not ply.CurAngle then
                ply.CurAngle = Angle(0, 0, 0)
            end
            ply.CurAngle = ply.CurAngle + Angle(0, 10, 0)

            local targetAngle = Angle(0, 0, 0)

            local lerpedAngle = LerpAngle(FrameTime() * 150, ply.CurAngle, targetAngle)

            local boneIndex = ply:LookupBone("ValveBiped.Bip01_R_Thigh")
            if boneIndex then
                ply:ManipulateBoneAngles(boneIndex, lerpedAngle)
            end
        else
            ply.CurAngle = Angle(0, 0, 0)

            local boneIndex = ply:LookupBone("ValveBiped.Bip01_R_Thigh")
            if boneIndex then
                ply:ManipulateBoneAngles(boneIndex, Angle(0, 0, 0))
            end
        end
    end)

else
    local bind = IN_ZOOM

    hook.Add("Think", "FootKick", function()
        local ply = LocalPlayer()
        if not ply:Alive() then return end
        if ply:KeyPressed(bind) and ply:Alive() and not ply:GetNWBool("fake") then
            net.Start("FootKick")
            net.SendToServer()
        end
    end)
end