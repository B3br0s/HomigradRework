AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/signpole001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end

    self.ConnectedZipline = nil
end

function ENT:FindConnectedZipline()
    local constraints = constraint.FindConstraints(self, "Rope")
    for _, constraintData in ipairs(constraints) do
        if self == constraintData.Ent2 then
        otherEnt = constraintData.Ent1
        else
        otherEnt = constraintData.Ent2   
        end
        if IsValid(otherEnt) and otherEnt:GetClass() == "ent_zipline" then
            self.ConnectedZipline = otherEnt
            return otherEnt
        end
    end
    self.ConnectedZipline = nil
end

local function StartZiplineRide(ply, ziplineStart, ziplineEnd)
    if not IsValid(ziplineEnd) then return end
    if ply.RidingOnZipline then return end

    ply.RidingOnZipline = true
    ply:SetLaggedMovementValue(0)
    ply:SetGravity(0)
    ply:EmitSound("zipline/zipline_attach.wav")
    ply:EmitSound("zipline/zipline_loop.wav")

    local totalDistance = ziplineStart:GetPos():Distance(ziplineEnd:GetPos())
    local travelTime = totalDistance / 300
    local startTime = CurTime()
    speed = 10

    local function ZiplineThink()
        if not IsValid(ply) or not ply:Alive() or ply.fake or ply:GetMoveType() == MOVETYPE_NOCLIP then ply:StopSound("zipline/zipline_loop.wav") ply:EmitSound("zipline/zipline_detach.wav") ply.RidingOnZipline = false return end
        

        local elapsed = CurTime() - startTime
        local progress = math.Clamp(elapsed / travelTime, 0, 1)
        local newPos = LerpVector(progress, ziplineStart:GetPos(), ziplineEnd:GetPos())
        ply:SetPos(newPos + Vector(0,0,3))

        speed = math.min(300, speed + (elapsed * 50)) * 2
        travelTime = totalDistance / speed

        if progress >= 0.95 then
            ply:SetGravity(1)
            ply:StopSound("zipline/zipline_loop.wav")
            ply:EmitSound("zipline/zipline_detach.wav")
            ply.RidingOnZipline = false
            ply:SetLaggedMovementValue(1)
            return false
        end

        return true
    end

    hook.Add("Think", "ZiplineMove_" .. ply:EntIndex(), function()
        if not ZiplineThink() then
            hook.Remove("Think", "ZiplineMove_" .. ply:EntIndex())
        end
    end)
end

function ENT:Use(activator)
    if activator:IsPlayer() then
        self:FindConnectedZipline()

        if not IsValid(self.ConnectedZipline) then return end

        if activator.RidingOnZipline then return end

        StartZiplineRide(activator, self, self.ConnectedZipline)
    end
end
