AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

DEFINE_BASECLASS( "base_glide" )

include( "shared.lua" )
include( "sv_engine.lua" )

local EntityMeta = FindMetaTable( "Entity" )
local getTable = EntityMeta.GetTable

--- Implement this base class function.
function ENT:OnPostInitialize()
    -- Setup variables used on all cars
    self.headlights = {}
    self.inputSteer = 0

    self.inputAirRoll = 0
    self.inputAirPitch = 0
    self.inputAirYaw = 0

    -- Initialize the engine
    self:EngineInit()

    -- Set default network values
    self:SetIsRedlining( false )
    self:SetIsHonking( false )
    self:SetIsBraking( false )
    self:SetHeadlightState( 0 )
    self:SetTurnSignalState( 0 )
    self:SetGear( 0 )

    local headlightColor = Glide.DEFAULT_HEADLIGHT_COLOR
    self:SetHeadlightColor( Vector( headlightColor.r / 255, headlightColor.g / 255, headlightColor.b / 255 ) )

    self:SetSteering( 0 )
    self:SetEngineRPM( 0 )
    self:SetEngineThrottle( 0 )

    self:SetTireSmokeColor( Vector( 0.6, 0.6, 0.6 ) )
    self:SetWheelRadius( 15 )

    -- Setup default NW wheel params
    local params = {
        -- Suspension
        suspensionLength = 10,
        springStrength = 800,
        springDamper = 3000,

        -- Brake force
        brakePower = 3000,

        -- Forward traction
        forwardTractionMax = 2600,

        -- Side traction
        sideTractionMultiplier = 20,
        sideTractionMaxAng = 25,
        sideTractionMax = 2400,
        sideTractionMin = 800
    }

    -- Maximum length of the suspension
    self:SetSuspensionLength( params.suspensionLength )

    -- How strong is the suspension spring
    self:SetSpringStrength( params.springStrength )

    -- Damping coefficient for when the suspension is compressed/expanded
    self:SetSpringDamper( params.springDamper )

    -- Brake coefficient
    self:SetBrakePower( params.brakePower )

    -- Traction parameters
    self:SetForwardTractionMax( params.forwardTractionMax )
    self:SetForwardTractionBias( 0.0 )

    self:SetSideTractionMultiplier( params.sideTractionMultiplier )
    self:SetSideTractionMaxAng( params.sideTractionMaxAng )
    self:SetSideTractionMax( params.sideTractionMax )
    self:SetSideTractionMin( params.sideTractionMin )

    -- Fake engine parameters
    self:SetMinRPM( 2000 )
    self:SetMaxRPM( 20000 )

    self:SetMinRPMTorque( 1200 )
    self:SetMaxRPMTorque( 1500 )
    self:SetDifferentialRatio( 1.9 )
    self:SetTransmissionEfficiency( 0.8 )
    self:SetPowerDistribution( -0.9 )

    -- Steering parameters
    self:SetMaxSteerAngle( 35 )
    self:SetSteerConeChangeRate( 8 )
    self:SetSteerConeMaxSpeed( 1800 )
    self:SetSteerConeMaxAngle( 0.25 )
    self:SetCounterSteer( 0.1 )

    -- Update wheel parameters next tick
    self.shouldUpdateWheelParams = true

    -- Update power distribution next tick
    self.shouldUpdatePowerDistribution = true

    -- Trigger wire outputs
    if WireLib then
        WireLib.TriggerOutput( self, "MaxGear", self.maxGear )
        WireLib.TriggerOutput( self, "Gear", 0 )
        WireLib.TriggerOutput( self, "EngineRPM", 0 )
    end
end

--- Update the `params` table for each wheel,
--- using values from our network variables.
function ENT:UpdateWheelParameters()
    self.shouldUpdateWheelParams = false

    local suspensionLength = self:GetSuspensionLength()
    local springStrength = self:GetSpringStrength()
    local springDamper = self:GetSpringDamper()
    local brakePower = self:GetBrakePower()
    local forwardTractionMax = self:GetForwardTractionMax()

    local sideTractionMultiplier = self:GetSideTractionMultiplier()
    local sideTractionMaxAng = self:GetSideTractionMaxAng()
    local sideTractionMax = self:GetSideTractionMax()
    local sideTractionMin = self:GetSideTractionMin()

    for _, w in ipairs( self.wheels ) do
        local p = w.params

        p.suspensionLength = suspensionLength
        p.springStrength = springStrength
        p.springDamper = springDamper
        p.brakePower = brakePower
        p.forwardTractionMax = forwardTractionMax

        p.sideTractionMultiplier = sideTractionMultiplier
        p.sideTractionMaxAng = sideTractionMaxAng
        p.sideTractionMax = sideTractionMax
        p.sideTractionMin = sideTractionMin
    end
end

--- Implement this base class function.
function ENT:OnDriverEnter()
    self:TurnOn()
end

--- Implement this base class function.
function ENT:OnDriverExit()
    local keepOn = IsValid( self.lastDriver ) and self.lastDriver:KeyDown( IN_WALK )

    if not self.hasRagdolledAllPlayers and not keepOn then
        self:TurnOff()
    end

    self:SetIsHonking( false )
end

--- Override this base class function.
function ENT:TurnOn()
    self.reducedThrottle = false
    self:SetGear( 0 )

    local state = self:GetEngineState()

    if state == 3 then
        self:SetEngineState( 2 )
        return
    end

    if state ~= 2 then
        self:SetEngineState( 1 )
    end

    self:SetFlywheelRPM( 0 )
end

--- Override this base class function.
function ENT:TurnOff()
    BaseClass.TurnOff( self )

    self:SetIsHonking( false )
    self:SetEngineState( 3 )
    self:SetGear( 0 )
    self.startupTimer = nil

    self.clutch = 1
    self.frontBrake = 0.2
    self.rearBrake = 0.2
    self.reducedThrottle = false
end

--- Override this base class function.
function ENT:ChangeWheelRadius( radius, dontSetNW )
    BaseClass.ChangeWheelRadius( self, radius )

    -- Avoid infinite loops when called by `OnWheelRadiusChange`
    if not dontSetNW then
        self:SetWheelRadius( radius )
    end
end

function ENT:OnWheelRadiusChange( _, _, radius )
    self:ChangeWheelRadius( radius, true )
end

function ENT:OnPowerDistributionChange()
    self.shouldUpdatePowerDistribution = true
end

--- Implement this base class function.
function ENT:OnSeatInput( seatIndex, action, pressed )
    if seatIndex > 1 then return end

    if action == "horn" then
        self:SetIsHonking( pressed )
    end

    if not pressed then return end

    if action == "headlights" then
        self:ChangeHeadlightState( self:GetHeadlightState() + 1 )

    elseif action == "siren" then
        self:ChangeSirenState( self:GetSirenState() + 1 )

    elseif action == "signal_left" then
        -- If the driver is also holding "signal_right"
        if self:GetInputBool( 1, "signal_right" ) then
            -- Toggle hazard lights
            self:ChangeTurnSignalState( self:GetTurnSignalState() == 3 and 0 or 3 )
        else
            -- Toggle left turn signal
            self:ChangeTurnSignalState( self:GetTurnSignalState() == 1 and 0 or 1 )
        end

    elseif action == "signal_right" then
        -- If the driver is also holding "signal_left"
        if self:GetInputBool( 1, "signal_left" ) then
            -- Toggle hazard lights
            self:ChangeTurnSignalState( self:GetTurnSignalState() == 3 and 0 or 3 )
        else
            -- Toggle right turn signal
            self:ChangeTurnSignalState( self:GetTurnSignalState() == 2 and 0 or 2 )
        end

    elseif action == "reduce_throttle" then
        self.reducedThrottle = not self.reducedThrottle

        Glide.SendNotification( self:GetAllPlayers(), {
            text = "#glide.notify.reduced_throttle_" .. ( self.reducedThrottle and "on" or "off" ),
            icon = "materials/glide/icons/" .. ( self.reducedThrottle and "play_next" or "fast_forward" ) .. ".png",
            immediate = true
        } )

    elseif action == "toggle_engine" then
        if self:GetEngineState() == 0 then
            self:TurnOn()
        else
            self:TurnOff()
        end

    elseif action == "accelerate" and self:GetEngineState() == 0 then
        self:TurnOn()
    end

    if not self.inputManualShift then return end

    if action == "shift_up" then
        self:SwitchGear( self:GetGear() + 1 )

    elseif action == "shift_down" then
        self:SwitchGear( self:GetGear() - 1 )

    elseif action == "shift_neutral" then
        self:SwitchGear( 0 )
    end
end

function ENT:ChangeHeadlightState( state, dontPlaySound )
    if not self.CanSwitchHeadlights then return end

    state = math.floor( state )

    if state < 0 then state = 2 end
    if state > 2 then state = 0 end

    self:SetHeadlightState( state )

    if dontPlaySound then return end

    local driver = self:GetDriver()
    local soundEnt = IsValid( driver ) and driver or self

    soundEnt:EmitSound( state == 0 and "glide/headlights_off.wav" or "glide/headlights_on.wav", 70, 100, 1.0 )
end

function ENT:ChangeSirenState( state )
    if not self.CanSwitchSiren then return end

    state = math.floor( state )

    if state < 0 then state = 2 end
    if state > 2 then state = 0 end

    self:SetSirenState( state )
end

function ENT:ChangeTurnSignalState( state, dontPlaySound )
    state = math.Clamp( math.floor( state ), 0, 3 )
    self:SetTurnSignalState( state )

    if dontPlaySound then return end

    local driver = self:GetDriver()
    local soundEnt = IsValid( driver ) and driver or self

    soundEnt:EmitSound( state == 0 and "glide/headlights_off.wav" or "glide/headlights_on.wav", 70, 60, 0.5 )
end

do
    local lightState = {
        brake = false,
        reverse = false,
        headlight = false,
        signal_left = false,
        signal_right = false
    }

    local CurTime = CurTime

    --- Update out model's bodygroups depending on which lights are on.
    function ENT:UpdateBodygroups()
        lightState.brake = self:GetIsBraking()
        lightState.reverse = self:GetGear() == -1
        lightState.headlight = self:GetHeadlightState() > 0

        local signal = self:GetTurnSignalState()
        local signalBlink = ( CurTime() % self.TurnSignalCycle ) > self.TurnSignalCycle * 0.5

        lightState.signal_left = signal == 1 or signal == 3
        lightState.signal_right = signal == 2 or signal == 3

        local enable

        for _, l in ipairs( self.LightBodygroups ) do
            enable = lightState[l.type]

            -- Blink "signal_*" light types
            if l.type == "signal_left" or l.type == "signal_right" then
                enable = enable and signalBlink
            end

            -- Allow other types of light to blink with turn signals, if "signal" is set.
            if l.signal and signal > 0 then
                if l.signal == "left" and lightState.signal_left then
                    enable = signalBlink

                elseif l.signal == "right" and lightState.signal_right then
                    enable = signalBlink
                end
            end

            self:SetBodygroup( l.bodyGroupId, enable and l.subModelId or 0 )
        end
    end
end

--- Override this base class function.
function ENT:SetupWiremodPorts( inputs, outputs )
    BaseClass.SetupWiremodPorts( self, inputs, outputs )

    inputs[#inputs + 1] = { "Ignition", "NORMAL", "1: Turn the engine on\n0: Turn the engine off" }
    inputs[#inputs + 1] = { "Steer", "NORMAL", "A value between -1.0 and 1.0" }
    inputs[#inputs + 1] = { "Throttle", "NORMAL", "A value between 0.0 and 1.0\nAlso acts brake input when reversing." }
    inputs[#inputs + 1] = { "Brake", "NORMAL", "A value between 0.0 and 1.0\nAlso acts throttle input when reversing." }
    inputs[#inputs + 1] = { "Handbrake", "NORMAL", "A value larger than 0 will set the handbrake" }
    inputs[#inputs + 1] = { "Headlights", "NORMAL", "0: Off\n1: Low beams\n2: High beams" }
    inputs[#inputs + 1] = { "Horn", "NORMAL", "Set to 1 to sound the horn" }
    inputs[#inputs + 1] = { "TurnSignal", "NORMAL", "0: Off\n1: Left-turn signal\n2: Right-turn signal\n3: Hazard lights" }

    outputs[#outputs + 1] = { "MaxGear", "NORMAL", "Highest gear available for this vehicle" }
    outputs[#outputs + 1] = { "Gear", "NORMAL", "Current engine gear" }
    outputs[#outputs + 1] = { "EngineState", "NORMAL", "0: Off\n1: Starting\n2: Running\n3: Shutting down/Ignition cut-off" }
    outputs[#outputs + 1] = { "EngineRPM", "NORMAL", "Current engine RPM" }
    outputs[#outputs + 1] = { "MaxRPM", "NORMAL", "Max. engine RPM" }
end

function ENT:CheckWaterLevel()
    if self:WaterLevel() > 2 then
        if self:GetEngineState() == 2 then
            self:TurnOff()
        end

        self:SetEngineHealth( 0 )
        self:SetFlywheelRPM( 0 )
        self:UpdateHealthOutputs()
    end
end

local Abs = math.abs
local Clamp = math.Clamp
local Approach = math.Approach
local TriggerOutput = WireLib and WireLib.TriggerOutput or nil

--- Implement this base class function.
function ENT:OnPostThink( dt, selfTbl )
    self:UpdateBodygroups()

    if selfTbl.shouldUpdateWheelParams then
        self:UpdateWheelParameters()
    end

    if selfTbl.shouldUpdatePowerDistribution then
        self:UpdatePowerDistribution()
    end

    local state = self:GetEngineState()

    if TriggerOutput then
        local maxRPM = self:GetMaxRPM()
        TriggerOutput( self, "MaxRPM", maxRPM )
        TriggerOutput( self, "Gear", self:GetGear() )
        TriggerOutput( self, "EngineState", state )
        TriggerOutput( self, "EngineRPM", Clamp( self:GetFlywheelRPM(), 0, maxRPM ) )

        if selfTbl.wireSetEngineOn ~= nil then
            if selfTbl.wireSetEngineOn then
                if state < 1 then
                    self:TurnOn()
                end

            elseif state > 0 then
                self:TurnOff()
            end

            selfTbl.wireSetEngineOn = nil
        end
    end

    -- Damage the engine when underwater
    self:CheckWaterLevel()

    local health = self:GetEngineHealth()

    -- Attempt to start the engine
    if state == 1 then
        if selfTbl.startupTimer then
            if CurTime() > selfTbl.startupTimer then
                selfTbl.startupTimer = nil

                if health > 0 then
                    self:SetEngineState( 2 )
                    self:SetEngineThrottle( 2 )
                else
                    self:SetEngineState( 0 )
                    Glide.PlaySoundSet( "Glide.Engine.CarStartTail", self )
                end
            end
        else
            local startupTime = health < 0.5 and math.Rand( 1, 2 ) or selfTbl.StartupTime
            selfTbl.startupTimer = CurTime() + startupTime
        end

    elseif state == 2 then
        if health <= 0 then
            self:TurnOff()

        elseif health < 0.25 then
            -- Stop the throttle at random intervals
            if selfTbl.damageThrottleCooldown and selfTbl.damageThrottleCooldown > 0 then
                selfTbl.damageThrottleCooldown = selfTbl.damageThrottleCooldown - dt
            else
                selfTbl.damageThrottleCooldown = math.Rand( 3, 0.2 )
                Glide.PlaySoundSet( "Glide.Damaged.GearGrind", self, 0.6 - health )
            end
        else
            selfTbl.damageThrottleCooldown = nil
        end
    else
        selfTbl.damageThrottleCooldown = nil
        selfTbl.startupTimer = nil
    end

    if self:IsEngineOn() then
        -- Make sure the physics stay awake,
        -- otherwise the driver's input won't do anything.
        local phys = self:GetPhysicsObject()

        if IsValid( phys ) and phys:IsAsleep() then
            local driverInput = self:GetInputFloat( 1, "accelerate" ) + self:GetInputFloat( 1, "brake" )

            if Abs( driverInput ) > 0.01 then
                phys:Wake()
            end
        end

        -- Ignition cut-off, slowdown the flywheel and then turn off
        if state == 3 then
            local rpm = self:GetFlywheelRPM()

            selfTbl.clutch = 1
            self:SetFlywheelRPM( rpm )
            self:EngineAccelerate( selfTbl.flywheelFriction, dt )
            self:SetEngineThrottle( Approach( self:GetEngineThrottle(), 0, dt ) )

            if rpm < self:GetMinRPM() then
                self:SetEngineState( 0 )
                self:SetFlywheelRPM( 0 )
            end
        else
            self:EngineThink( dt )
        end
    else
        selfTbl.availableFrontTorque = 0
        selfTbl.availableRearTorque = 0
    end

    -- Update driver inputs
    self:UpdateSteering( dt )

    local phys = self:GetPhysicsObject()

    if selfTbl.groundedCount < 1 and IsValid( phys ) then
        if selfTbl.totalSpeed > 200 then
            self:UpdateAirControls( phys, dt )
        else
            self:UpdateUnflip( phys, dt )
        end
    else
        selfTbl.inputAirRoll = 0
        selfTbl.inputAirPitch = 0
        selfTbl.inputAirYaw = 0
    end

    return true
end

local ExpDecay = Glide.ExpDecay

function ENT:UpdateSteering( dt )
    local inputSteer = self:GetInputFloat( 1, "steer" )
    local absInputSteer = Abs( inputSteer )

    local sideSlip = Clamp( self.avgSideSlip, -1, 1 )
    local steerConeFactor = Clamp( self.totalSpeed / self:GetSteerConeMaxSpeed(), 0, 1 )

    -- Limit the input depending on speed...
    local steerCone = 1 - steerConeFactor * ( 1 - self:GetSteerConeMaxAngle() )

    -- But only while not slipping.
    steerCone = Clamp( steerCone, Abs( sideSlip ), 1 )
    inputSteer = ExpDecay( self.inputSteer, inputSteer * steerCone, self:GetSteerConeChangeRate(), dt )

    self.inputSteer = inputSteer
    self:SetSteering( inputSteer )

    -- Counter-steer when slipping, going fast and not using steer input
    local counterSteer = sideSlip * steerConeFactor * ( 1 - absInputSteer )

    counterSteer = Clamp( counterSteer, -1, 1 ) * self:GetCounterSteer()
    inputSteer = Clamp( inputSteer + counterSteer, -1, 1 )

    self.steerAngle[2] = -inputSteer * self:GetMaxSteerAngle()
end

--- Let the driver unflip the vehicle when it is upside down.
function ENT:UpdateUnflip( phys, dt )
    if Abs( self.inputSteer ) < 0.1 then return end

    local ang = self:GetAngles()
    if Abs( ang[3] ) < 70 then return end

    if phys:IsAsleep() then
        phys:Wake()
    end

    local angVel = phys:GetAngleVelocity()
    local force = self.inputSteer * phys:GetMass() * Clamp( 1 - Abs( angVel[1] ) / 50, 0, 1 ) * self.UnflipForce

    phys:AddAngleVelocity( Vector( force * dt, 0, 0 ) )
end

--- Let the driver spin the car while airborne.
function ENT:UpdateAirControls( phys, dt )
    local mass = phys:GetMass()
    local angVel = phys:GetAngleVelocity()

    local roll, pitch, yaw = self:GetAirInputs()

    self.inputAirRoll = Approach( self.inputAirRoll, roll, dt )
    self.inputAirPitch = Approach( self.inputAirPitch, pitch, dt )
    self.inputAirYaw = Approach( self.inputAirYaw, yaw, dt )

    local rollMult = Clamp( 1 - Abs( angVel[1] / self.AirMaxAngularVelocity[1] ), 0, 1 )
    local pitchMult = Clamp( 1 - Abs( angVel[2] / self.AirMaxAngularVelocity[2] ), 0, 1 )
    local yawMult = Clamp( 1 - Abs( angVel[3] / self.AirMaxAngularVelocity[3] ), 0, 1 )

    -- Logic to only apply the limit when rotating in the same direction as the input
    roll = roll * ( roll > 0 and ( angVel[1] > 0 and rollMult or 1 ) or ( angVel[1] < 0 and rollMult or 1 ) )
    pitch = pitch * ( pitch > 0 and ( angVel[2] > 0 and pitchMult or 1 ) or ( angVel[2] < 0 and pitchMult or 1 ) )
    yaw = yaw * ( yaw > 0 and ( angVel[3] > 0 and yawMult or 1 ) or ( angVel[3] < 0 and yawMult or 1 ) )

    phys:AddAngleVelocity( Vector(
        self.AirControlForce[1] * roll * mass * dt,
        self.AirControlForce[2] * pitch * mass * dt,
        self.AirControlForce[3] * yaw * mass * dt
    ) )
end

--- Override this base class function.
function ENT:CreateWheel( offset, params )
    local wheel = BaseClass.CreateWheel( self, offset, params )

    -- If the `isFrontWheel` param is not forced, figure it out now
    if params.isFrontWheel == nil then
        wheel.isFrontWheel = offset[1] > 0
    else
        wheel.isFrontWheel = params.isFrontWheel == true
    end

    -- Update power distribution next tick
    wheel.distributionFactor = 0
    self.shouldUpdatePowerDistribution = true

    return wheel
end

local traction, tractionFront, tractionRear
local frontTorque, rearTorque, steerAngle, frontBrake, rearBrake
local groundedCount, rpm, avgRPM, totalSideSlip, totalForwardSlip, state

--- Implement this base class function.
function ENT:WheelThink( dt )
    local selfTbl = getTable( self )

    local phys = self:GetPhysicsObject()
    local isAsleep = IsValid( phys ) and phys:IsAsleep()
    local maxRPM = self:GetTransmissionMaxRPM( self:GetGear() )
    local inputHandbrake = self:GetInputBool( 1, "handbrake" )

    traction = self:GetForwardTractionBias()
    tractionFront = ( 1 + Clamp( traction, -1, 0 ) ) * selfTbl.frontTractionMult
    tractionRear = ( 1 - Clamp( traction, 0, 1 ) ) * selfTbl.rearTractionMult

    frontTorque = selfTbl.availableFrontTorque
    rearTorque = selfTbl.availableRearTorque
    steerAngle = selfTbl.steerAngle

    frontBrake, rearBrake = selfTbl.frontBrake, selfTbl.rearBrake
    groundedCount, avgRPM, totalSideSlip, totalForwardSlip = 0, 0, 0, 0

    for _, w in ipairs( selfTbl.wheels ) do
        w:Update( self, steerAngle, isAsleep, dt )

        totalSideSlip = totalSideSlip + w:GetSideSlip()
        totalForwardSlip = totalForwardSlip + w:GetForwardSlip()

        rpm = w:GetRPM()
        avgRPM = avgRPM + rpm * w.distributionFactor

        state = w.state
        state.torque = w.distributionFactor * ( w.isFrontWheel and frontTorque or rearTorque )
        state.brake = w.isFrontWheel and frontBrake or rearBrake
        state.forwardTractionMult = w.isFrontWheel and tractionFront or tractionRear

        if inputHandbrake and not w.isFrontWheel then
            state.angularVelocity = 0
        end

        if rpm > maxRPM then
            w:SetRPM( maxRPM )
        end

        if state.isOnGround then
            groundedCount = groundedCount + 1
        end
    end

    selfTbl.avgPoweredRPM = avgRPM
    selfTbl.groundedCount = groundedCount
    selfTbl.avgSideSlip = totalSideSlip / selfTbl.wheelCount
    selfTbl.avgForwardSlip = totalForwardSlip / selfTbl.wheelCount
end

local Floor = math.floor

--- Override this base class function.
function ENT:TriggerInput( name, value )
    BaseClass.TriggerInput( self, name, value )

    if name == "Ignition" then
        -- Avoid continous triggers
        self.wireSetEngineOn = value > 0

    elseif name == "Throttle" then
        self:SetInputFloat( 1, "accelerate", Clamp( value, 0, 1 ) )

    elseif name == "Steer" then
        self:SetInputFloat( 1, "steer", Clamp( value, -1, 1 ) )

    elseif name == "Brake" then
        self:SetInputFloat( 1, "brake", Clamp( value, 0, 1 ) )

    elseif name == "Handbrake" then
        self:SetInputBool( 1, "handbrake", value > 0 )

    elseif name == "Gear" then
        value = Clamp( Floor( value ), -2, self.maxGear )

        if value > -2 then
            -- Manual gears
            self.inputManualShift = true

            if value ~= self:GetGear() then
                self:SwitchGear( value, 0 )
            end
        else
            self.inputManualShift = false
        end

    elseif name == "Headlights" then
        self:ChangeHeadlightState( Floor( value ), true )

    elseif name == "Horn" then
        self:SetIsHonking( value > 0 )

    elseif name == "TurnSignal" then
        self:ChangeTurnSignalState( value, true )
    end
end
