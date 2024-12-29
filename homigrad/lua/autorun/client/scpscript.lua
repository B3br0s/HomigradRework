local glowMaterial = Material("holo/huy-collimator2.png")

net.Receive("SCPTargetsWH", function()
    local targets = net.ReadTable()
    local localPlayer = LocalPlayer()
    if localPlayer then
        localPlayer.TargetsToKill = targets
    end
end)

local function CheckTargetsDead()
    local targets = LocalPlayer().TargetsToKill or {}
    for _, target in ipairs(targets) do
        if IsValid(target) and target:Alive() then
            return false
        end
    end
    return true
end

local triggered = false
local Blinking = false
local BlinkingNR = false
local prevblink = 0
local blinknrdur = 0
local LastSCPMeet = 0
local hg_blinkdisable = CreateClientConVar("hg_blinkdisable", "0", true, true, "Переключает Моргание", 0, 1)
local blinkkd = 0
local fov = GetConVar("hg_fov"):GetInt()
local fovadd = 0
local fovtarget = 0

local function DrawTargets()
    local localPlayer = LocalPlayer()
    if not IsValid(localPlayer) or not localPlayer:GetNWBool("isSCP") then
        localPlayer.TargetsToKill = {}
        return
    end

    local targets = localPlayer.TargetsToKill or {}
    if CheckTargetsDead() and localPlayer:GetNWBool("RageSCP") then
        localPlayer.TargetsToKill = {}
        net.Start("StopRageSCP096")
        net.SendToServer()
    end

    for _, target in ipairs(targets) do
        if not IsValid(target) or not target:Alive() then
            continue
        end

        local target1 = target:GetNWBool("fake") and target:GetNWBool("Ragdoll") or target
        if IsValid(target1) then
            local obbCenterWorldPos = target1:LocalToWorld(target1:OBBCenter())
            local screenPos = obbCenterWorldPos:ToScreen()
            surface.SetMaterial(glowMaterial)
            surface.DrawTexturedRect(screenPos.x - 100, screenPos.y - 100, 200, 200)
        end
    end
end

hook.Add("HUDPaint", "SCPWallHack", function()
    local localPlayer = LocalPlayer()
    if not localPlayer:Alive() or not localPlayer:GetNWBool("isSCP") then return end
    DrawTargets()
end)

hook.Add("Think", "BlinkFunc", function()
    local localPlayer = LocalPlayer()
    if localPlayer:GetNWBool("isSCP") or not localPlayer:Alive() then
        Blinking = false
        return
    end
    if blinkkd > CurTime() then
        Blinking = true
        return
    end
    if prevblink > CurTime() then
        Blinking = false
        return
    end
    prevblink = CurTime() + 3
    blinkkd = CurTime() + 0.8
    Blinking = true
end)

hook.Add("HUDPaint", "BlinkHudPaint", function()
    SETFOV(GetConVar("hg_fov"):GetInt() + fovadd)
    if roundActiveName ~= "scpcb" then return end
    if Blinking and not hg_blinkdisable:GetBool() then
        draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255))
    end
end)

local lastCheckTime = 0
local checkInterval = 0.1

hook.Add("Think", "CheckSCPInView", function()
    if CurTime() - lastCheckTime < checkInterval then return end
    lastCheckTime = CurTime()

    local ply = LocalPlayer()
    if not ply:Alive() then
        ply:SetNWBool("IsTarget", false)
        return
    end

    local plyPos = ply:GetPos()
    local viewDir = ply:GetAimVector()
    local maxDistance = 4500
    local fov = 0.2

    for _, target in ipairs(player.GetAll()) do
        if target ~= ply and target:Alive() and target:GetNWBool("isSCP", false) and not ply:GetNWBool("isSCP") then
            local targetPos = target:GetPos()
            local distance = plyPos:Distance(targetPos)

            fovadd = Lerp(0.005, fovadd, fovtarget)

            if distance <= maxDistance then
                local targetDir = (targetPos - plyPos):GetNormalized()
                local dotProduct = targetDir:Dot(viewDir)

                if dotProduct > fov then
                    local traceData = {
                        start = plyPos + Vector(0, 0, 64),
                        endpos = targetPos + Vector(0, 0, 64),
                        filter = {ply, target}
                    }

                    local traceResult = util.TraceLine(traceData)

                    if not traceResult.Hit then
                        if LastSCPMeet < CurTime() then
                            surface.PlaySound("scp/scpmeet" .. math.random(1, 3) .. ".wav")
                            fovtarget = 35
                            fovadd = 35
                            timer.Simple(1.5, function()
                                fovtarget = 0
                            end)
                        end
                        LastSCPMeet = CurTime() + 5

                        local activeWeapon = target:GetActiveWeapon()
                        if activeWeapon ~= NULL and not ply:GetNWBool("isSCP") then
                            local weaponClass = activeWeapon:GetClass()
                            if weaponClass == "weapon_173" and not Blinking then
                                net.Start("SCP173Stop")
                                net.WriteEntity(target)
                                net.SendToServer()
                            elseif weaponClass == "weapon_096" then
                                if not target:GetNWBool("RageSCP") and not ply:GetNWBool("IsTarget", false) then
                                    ply:SetNWBool("IsTarget", true)
                                    net.Start("RageSCP096")
                                    net.WriteEntity(target)
                                    net.WriteEntity(ply)
                                    net.SendToServer()

                                    net.Start("SCPTargetsWH")
                                    net.WriteEntity(target)
                                    net.SendToServer()
                                elseif target:GetNWBool("RageSCP") and not ply:GetNWBool("IsTarget", false) then
                                    net.Start("SCPTargetsWH")
                                    net.WriteEntity(target)
                                    net.SendToServer()
                                    ply:SetNWBool("IsTarget", true)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)