local DAMAGE_AMOUNT = 5
local DAMAGE_INTERVAL = 0.1
local VIEW_ANGLE_THRESHOLD = 67

local function CheckPlayerLookingAtSlenderman(ply)
    if not ply:Alive() or ply:InVehicle() then return end

    local plyPos = ply:EyePos()
    local plyAim = ply:GetAimVector()

    for _, target in ipairs(player.GetAll()) do
        if target:IsPlayer() and target != ply and target:GetNWBool("slendermanblya", true) then
            local targetPos = target:GetPos() + Vector(0, 0, 64)
            local toTarget = (targetPos - plyPos):GetNormalized()

            local traceData = {}
            traceData.start = plyPos
            traceData.endpos = targetPos
            traceData.filter = ply
            local traceResult = util.TraceLine(traceData)

            if traceResult.Hit and traceResult.Entity != target then
                continue
            end

            local dotProduct = plyAim:Dot(toTarget)

            dotProduct = math.Clamp(dotProduct, -1, 1)
            local angleToTarget = math.deg(math.acos(dotProduct))

            if angleToTarget <= VIEW_ANGLE_THRESHOLD then
                local dmginfo = DamageInfo()
                dmginfo:SetDamage(DAMAGE_AMOUNT)
                dmginfo:SetAttacker(game.GetWorld())
                dmginfo:SetDamageType(DMG_GENERIC)
                ply:TakeDamageInfo(dmginfo)
            else
            end
        end
    end
end

hook.Add("Think", "CheckPlayersLookingAtSlenderman", function()
    for _, ply in ipairs(player.GetAll()) do
        if ply.NextDamageCheck and ply.NextDamageCheck > CurTime() then continue end
        ply.NextDamageCheck = CurTime() + DAMAGE_INTERVAL

        if not ply:GetNWBool("slendermanblya", true) then
            CheckPlayerLookingAtSlenderman(ply)
        end
    end
end)
