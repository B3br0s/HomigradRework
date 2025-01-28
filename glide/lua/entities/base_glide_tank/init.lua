AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

DEFINE_BASECLASS( "base_glide" )

--- Implement this base class function.
function ENT:OnPostInitialize()
    -- Setup variables used on all tanks
    self.wheelCountL = 0
    self.wheelCountR = 0

    self.availableTorqueL = 0
    self.availableTorqueR = 0

    self.isGrounded = false
    self.isTurningInPlace = false
    self.isCannonInsideWall = false
    self.brake = 0.5

    self:SetEngineThrottle( 0 )
    self:SetEnginePower( 0 )
    self:SetTrackSpeed( 0 )

    self:SetTurretAngle( Angle() )
    self:SetIsAimingAtTarget( false )
end

--- Implement this base class function.
function ENT:OnDriverEnter()
    self:TurnOn()
end

--- Implement this base class function.
function ENT:OnDriverExit()
    self:TurnOff()
end

--- Override this base class function.
function ENT:TurnOn()
    local state = self:GetEngineState()

    if state ~= 2 then
        self:SetEngineState( 1 )
    end

    self:SetEngineThrottle( 0 )
    self:SetEnginePower( 0 )
end

--- Override this base class function.
function ENT:TurnOff()
    BaseClass.TurnOff( self )

    self.startupTimer = nil
    self.availableTorqueL = 0
    self.availableTorqueR = 0
    self.isTurningInPlace = false
    self.brake = 0.5
end

--- Implement this base class function.
function ENT:OnSeatInput( seatIndex, action, pressed )
    if not pressed or seatIndex > 1 then return end

    if action == "toggle_engine" then
        if self:GetEngineState() == 0 then
            self:TurnOn()
        else
            self:TurnOff()
        end
    end
end

--- Override this base class function.
function ENT:OnTakeDamage( dmginfo )
    if dmginfo:IsDamageType( 64 ) then -- DMG_BLAST
        local inflictor = dmginfo:GetInflictor()

        -- Increase damage taken by Half-life 2 RPGs
        if IsValid( inflictor ) and inflictor:GetClass() == "rpg_missile" then
            dmginfo:SetDamage( dmginfo:GetDamage() * 2.5 )
        end
    end

    BaseClass.OnTakeDamage( self, dmginfo )

    if self:GetEngineHealth() <= 0 and self:GetEngineState() == 2 then
        self:TurnOff()
    end
end

function ENT:GetTurretOrigin()
    return self:LocalToWorld( self.TurretOffset )
end

function ENT:GetTurretAimDirection()
    local origin = self:GetTurretOrigin()
    local ang = self:LocalToWorldAngles( self:GetTurretAngle() )

    -- Use the driver's aim position directly when
    -- the turret is aiming close enough to it.
    local driver = self:GetDriver()

    if IsValid( driver ) and self:GetIsAimingAtTarget() then
        local dir = driver:GlideGetAimPos() - origin
        dir:Normalize()
        ang = dir:Angle()
    end

    return ang:Forward()
end

local TraceLine = util.TraceLine

function ENT:GetTurretAimPosition()
    local origin = self:GetTurretOrigin()
    local target = origin + self:GetTurretAimDirection() * 50000
    local tr = TraceLine( self:GetTraceData( origin, target ) )

    if tr.Hit then
        target = tr.HitPos
    end

    return target
end

--- Implement this base class function.
function ENT:OnWeaponFire( weapon )
    if self:WaterLevel() > 2 then return end

    if self.isCannonInsideWall then
        weapon.nextFire = 0
        return
    end

    local aimPos = self:GetTurretAimPosition()
    local projectilePos = self:GetProjectileStartPos()

    -- Make the projectile point towards the direction the
    -- turret is aiming at, no matter where it spawned.
    local dir = aimPos - projectilePos
    dir:Normalize()

    local projectile = Glide.FireProjectile( projectilePos, dir:Angle(), self:GetDriver(), self )
    projectile.damage = self.TurretDamage

    self:EmitSound( self.TurretFireSound, 100, math.random( 95, 105 ), self.TurretFireVolume )

    local eff = EffectData()
    eff:SetOrigin( projectilePos )
    eff:SetNormal( dir )
    eff:SetScale( 1 )
    util.Effect( "glide_tank_cannon", eff )

    local phys = self:GetPhysicsObject()

    if IsValid( phys ) then
        phys:ApplyForceOffset( dir * phys:GetMass() * -self.TurretRecoilForce, projectilePos )
    end

    local driver = self:GetDriver()

    if IsValid( driver ) then
        Glide.SendViewPunch( driver, -0.2 )
    end
end

--- Override this base class function.
function ENT:CreateWheel( offset, params )
    -- Tweak default wheel params
    params = params or {}

    params.brakePower = params.brakePower or 15000
    params.suspensionLength = params.suspensionLength or 15
    params.springStrength = params.springStrength or 6000
    params.springDamper = params.springDamper or 30000

    params.forwardTractionMax = params.forwardTractionMax or 50000
    params.sideTractionMultiplier = params.sideTractionMultiplier or 800
    params.sideTractionMinAng = params.sideTractionMinAng or 70
    params.sideTractionMax = params.sideTractionMax or 12000
    params.sideTractionMin = params.sideTractionMin or 10000

    -- Let the base class create the wheel
    local wheel = BaseClass.CreateWheel( self, offset, params )

    -- Check if the wheel is on the left side
    wheel.isLeftTrack = offset[2] > 0

    if wheel.isLeftTrack then
        -- Count left side wheels
        self.wheelCountL = self.wheelCountL + 1

        -- Don't play sounds for the second wheel on this side
        if self.wheelCountL == 2 then
            wheel:SetSoundsEnabled( false )
        end
    else
        -- Count right side wheels
        self.wheelCountR = self.wheelCountR + 1

        -- Don't play sounds for the second wheel on this side
        if self.wheelCountR == 2 then
            wheel:SetSoundsEnabled( false )
        end
    end

    return wheel
end

local Abs = math.abs
local Clamp = math.Clamp

--- Implement this base class function.
function ENT:OnPostThink( dt, selfTbl )
    local state = self:GetEngineState()

    -- Damage the engine when underwater
    if self:WaterLevel() > 2 then
        if state == 2 then
            self:TurnOff()
        end

        self:SetEngineHealth( 0 )
        self:UpdateHealthOutputs()
    end

    local health = self:GetEngineHealth()

    -- Attempt to start the engine
    if state == 1 then
        if selfTbl.startupTimer then
            if CurTime() > selfTbl.startupTimer then
                selfTbl.startupTimer = nil

                if health > 0 then
                    self:SetEngineState( 2 )
                else
                    self:SetEngineState( 0 )
                end
            end
        else
            local startupTime = health < 0.5 and math.Rand( 1, 2 ) or selfTbl.StartupTime
            selfTbl.startupTimer = CurTime() + startupTime
        end
    end

    if self:IsEngineOn() then
        self:UpdateEngine( dt )

        -- Make sure the physics stay awake when necessary,
        -- otherwise the driver's input won't do anything.
        local phys = self:GetPhysicsObject()

        if IsValid( phys ) and phys:IsAsleep() then
            self:SetTrackSpeed( 0 )
            selfTbl.availableTorqueL = 0
            selfTbl.availableTorqueR = 0

            local driverInput = self:GetInputFloat( 1, "accelerate" ) + self:GetInputFloat( 1, "brake" ) + self:GetInputFloat( 1, "steer" )

            if Abs( driverInput ) > 0.01 then
                phys:Wake()
            end
        end
    end

    -- Update wheel state
    local torqueL = selfTbl.availableTorqueL / selfTbl.wheelCountL
    local torqueR = selfTbl.availableTorqueR / selfTbl.wheelCountR

    local isGrounded = false
    local totalSideSlip = 0
    local totalAngVel = 0
    local s

    for _, w in ipairs( self.wheels ) do
        s = w.state
        totalAngVel = totalAngVel + Abs( s.angularVelocity )

        if s.isOnGround then
            s.brake = selfTbl.brake
            s.torque = w.isLeftTrack and torqueL or torqueR

            isGrounded = true
            totalSideSlip = totalSideSlip + w:GetSideSlip()
        else
            s.brake = 1
            s.torque = 0
        end
    end

    selfTbl.isGrounded = isGrounded
    self:SetTrackSpeed( totalAngVel / selfTbl.wheelCount )

    local inputSteer = self:GetInputFloat( 1, "steer" )
    local sideSlip = Clamp( totalSideSlip / selfTbl.wheelCount, -1, 1 )

    -- Limit the input and the rate of change depending on speed,
    -- but allow a faster rate of change when slipping sideways.
    local invSpeedOverFactor = 1 - Clamp( selfTbl.totalSpeed / selfTbl.MaxSpeed, 0, 1 )

    inputSteer = inputSteer * Clamp( invSpeedOverFactor, 0.2, 1 )

    -- Counter-steer when slipping and going fast
    local counterSteer = Clamp( sideSlip * ( 1 - invSpeedOverFactor ), -0.05, 0.05 )
    inputSteer = Clamp( inputSteer + counterSteer, -1, 1 )

    local maxAng = selfTbl.isTurningInPlace and 90 or selfTbl.MaxSteerAngle

    selfTbl.inputSteer = inputSteer
    selfTbl.steerAngle[2] = -inputSteer * maxAng

    -- Update turret angles, if we have a driver
    local driver = self:GetDriver()

    if IsValid( driver ) and self:WaterLevel() < 2 then
        local newAng, isAimingAtTarget = self:UpdateTurret( driver, dt, self:GetTurretAngle() )

        -- Don't let it shoot while inside walls
        local origin = self:GetTurretOrigin()
        local projectilePos = self:GetProjectileStartPos()
        local tr = TraceLine( self:GetTraceData( origin, projectilePos ) )

        selfTbl.isCannonInsideWall = tr.Hit

        if selfTbl.isCannonInsideWall then
            isAimingAtTarget = false
        end

        self:SetTurretAngle( newAng )
        self:SetIsAimingAtTarget( isAimingAtTarget )
        self:ManipulateTurretBones( newAng )
    end
end

local ExpDecay = Glide.ExpDecay

function ENT:UpdateEngine( dt )
    local inputThrottle = self:GetInputFloat( 1, "accelerate" )
    local inputHandbrake = self:GetInputBool( 1, "handbrake" )
    local inputBrake = self:GetInputFloat( 1, "brake" )
    local inputSteer = self:GetInputFloat( 1, "steer" )

    if inputHandbrake then
        inputThrottle = 0
        inputBrake = 1
    end

    self.isTurningInPlace = Abs( self.forwardSpeed ) < 100 and Abs( inputSteer ) > 0.1 and Abs( inputThrottle + inputBrake ) < 0.1

    local inputL, inputR = 0, 0
    local extraBrake = 0
    local power = 0

    if self.isTurningInPlace then
        inputL = inputSteer * self.SpinEngineTorqueMultiplier
        inputR = -inputSteer * self.SpinEngineTorqueMultiplier
        inputBrake = 0
        power = Abs( inputSteer ) * 0.5

        self:SetEngineThrottle( ExpDecay( self:GetEngineThrottle(), 0.75, 4, dt ) )
    else
        if self.forwardSpeed < 10 and inputBrake > 0.1 and not inputHandbrake then
            inputThrottle, inputBrake = -inputBrake, inputThrottle
        end

        self:SetEngineThrottle( ExpDecay( self:GetEngineThrottle(), Abs( inputThrottle ), 4, dt ) )

        if Abs( self.forwardSpeed ) > self.MaxSpeed then
            inputThrottle = 0
        end

        extraBrake = ( 1 - Abs( inputThrottle ) ) * 0.3
        power = Clamp( Abs( self.forwardSpeed ) / self.MaxSpeed, 0, 1 )

        inputL = inputThrottle
        inputR = inputL
    end

    self.brake = inputBrake + extraBrake
    self.availableTorqueL = self.EngineTorque * inputL
    self.availableTorqueR = self.EngineTorque * inputR

    self:SetEnginePower( ExpDecay( self:GetEnginePower(), power, 2, dt ) )
end
