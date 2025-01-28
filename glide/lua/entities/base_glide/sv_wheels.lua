function ENT:WheelInit()
    self.wheels = {}
    self.wheelCount = 0
    self.wheelsEnabled = true
    self.steerAngle = Angle()

    -- This was deprecated. Putting values here does nothing.
    -- Wheel parameters are stored on each wheel now.
    -- This will be removed in the future.
    self.wheelParams = {}
end

function ENT:CreateWheel( offset, params )
    params = params or {}
    params.localPos = offset

    local pos = self:LocalToWorld( offset )
    local ang = self:LocalToWorldAngles( Angle() )

    local wheel = ents.Create( "glide_wheel" )
    wheel:SetPos( pos )
    wheel:SetAngles( ang )
    wheel:SetParent( self )
    wheel:Spawn()
    wheel:SetupWheel( params )

    self:DeleteOnRemove( wheel )

    local index = self.wheelCount + 1

    self.wheelCount = index
    self.wheels[index] = wheel

    return wheel
end

function ENT:ChangeWheelRadius( radius )
    if not self.wheels then return end

    for _, w in ipairs( self.wheels ) do
        if IsValid( w ) then
            w.params.radius = radius
            w:ChangeRadius( radius )
        end
    end
end

local GetDevMode = Glide.GetDevMode

function ENT:WheelThink( dt )
    local phys = self:GetPhysicsObject()
    local isAsleep = phys:IsValid() and phys:IsAsleep()

    for _, w in ipairs( self.wheels ) do
        w:Update( self, self.steerAngle, isAsleep, dt )
    end

    if GetDevMode() then
        debugoverlay.Axis( self:LocalToWorld( phys:GetMassCenter() ), self:GetAngles(), 15, 0.1, true )
    end
end

local Clamp = math.Clamp
local ClampForce = Glide.ClampForce

local linForce, angForce = Vector(), Vector()

function ENT:PhysicsSimulate( phys, dt )
    -- Prepare output vectors, do angular drag
    local drag = self.AngularDrag
    local mass = phys:GetMass()
    local angVel = phys:GetAngleVelocity()

    linForce[1] = 0
    linForce[2] = 0
    linForce[3] = 0

    angForce[1] = angVel[1] * drag[1] * mass
    angForce[2] = angVel[2] * drag[2] * mass
    angForce[3] = angVel[3] * drag[3] * mass

    -- Do wheel physics
    if self.wheelCount > 0 and self.wheelsEnabled then
        local traceData = self.traceData

        for _, w in ipairs( self.wheels ) do
            w:DoPhysics( self, phys, traceData, linForce, angForce, dt )
        end
    end

    -- Let children classes do additional physics if they want to
    self:OnSimulatePhysics( phys, dt, linForce, angForce )

    -- Indirectly and subtly make the PhysObj go asleep when not moving
    local factor = 1 - Clamp( self.totalSpeed / 10, 0, 1 )

    if factor > 0.1 then
        local vel = phys:GetVelocity()

        factor = factor * mass * 10
        linForce[1] = linForce[1] - vel[1] * factor
        linForce[2] = linForce[2] - vel[2] * factor
        linForce[3] = linForce[3] - vel[3] * factor
    end

    -- Prevent crashes
    ClampForce( angForce )
    ClampForce( linForce )

    return angForce, linForce, 4 -- SIM_GLOBAL_FORCE
end
