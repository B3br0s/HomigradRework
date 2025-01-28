include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.AutomaticFrameAdvance = true

--- Implement this base class function.
function ENT:OnPostInitialize()
    self.brakePressure = 0
    self.rpmFraction = 0
end

function ENT:OnGearChange( _, _, gear )
    if self.lastGear then
        self.doWobble = gear > 1 and gear > self.lastGear
    end

    self.lastGear = gear

    if self.stream and self.stream.firstPerson then
        if self.InternalGearSwitchSound ~= "" then
            Glide.PlaySoundSet( self.InternalGearSwitchSound, self )
        end

    elseif self.ExternalGearSwitchSound ~= "" then
        Glide.PlaySoundSet( self.ExternalGearSwitchSound, self )
    end
end

function ENT:OnHeadlightColorChange()
    self.headlightState = 0 -- Let OnUpdateMisc recreate the lights
end

--- Override this base class function.
function ENT:OnEngineStateChange( _, lastState, state )
    if state == 1 then
        if self.rfSounds and self.rfSounds.isActive then
            local snd = self:CreateLoopingSound( "start", Glide.GetRandomSound( self.StartSound ), 70, self )
            snd:PlayEx( 1, 100 )
        end

    elseif lastState ~= 3 and state == 2 then
        self:OnTurnOn()

    elseif state == 0 then
        self:OnTurnOff()
    end
end

--- Implement this base class function.
function ENT:OnTurnOn()
    if self.StartedSound ~= "" then
        self:EmitSound( self.StartedSound, 85, 100, 1.0 )
    end
end

--- Implement this base class function.
function ENT:OnTurnOff()
    if self.StoppedSound ~= "" then
        self:EmitSound( self.StoppedSound, 75, 100, 1.0 )
    end

    self:DeactivateSounds()
end

--- Implement this base class function.
function ENT:OnActivateMisc()
    self.brakePressure = 0
    self.rpmFraction = 0

    self.headlightState = nil
    self.headlights = {}
end

--- Implement this base class function.
function ENT:OnDeactivateMisc()
    self:RemoveHeadlights()
end

--- Implement this base class function.
function ENT:OnDeactivateSounds()
    if self.stream then
        self.stream:Destroy()
        self.stream = nil
    end
end

local Clamp = math.Clamp
local FrameTime = FrameTime
local GetVolume = Glide.Config.GetVolume

function ENT:UpdateTurboSound( sounds )
    local volume = self:GetEngineThrottle() * 0.5

    if volume < 0.2 then
        if sounds.turbo then
            sounds.turbo:Stop()
            sounds.turbo = nil

            if self.rpmFraction > 0.5 then
                self:EmitSound( self.TurboBlowoffSound, 80, math.random( 100, 110 ), self.TurboBlowoffVolume )
            end
        end

        return
    end

    local pitch = self.TurboPitch * 0.5
    pitch = pitch + self.rpmFraction * pitch
    volume = volume * self.TurboVolume * self.rpmFraction * GetVolume( "carVolume" )

    if sounds.turbo then
        sounds.turbo:ChangeVolume( volume )
        sounds.turbo:ChangePitch( pitch )
    else
        local snd = self:CreateLoopingSound( "turbo", self.TurboLoopSound, 80, self )
        snd:PlayEx( volume, pitch )
    end
end

--- Implement this base class function.
function ENT:OnUpdateSounds()
    local sounds = self.sounds

    if sounds.start and self:GetEngineState() ~= 1 then
        sounds.start:Stop()
        sounds.start = nil
        Glide.PlaySoundSet( self.StartTailSound, self )
    end

    local dt = FrameTime()

    if self:GetIsHonking() and self.HornSound then
        if sounds.horn then
            sounds.horn:ChangeVolume( GetVolume( "hornVolume" ) )
        else
            local snd = self:CreateLoopingSound( "horn", self.HornSound, 85, self )
            snd:PlayEx( GetVolume( "hornVolume" ), 100 )
        end

    elseif sounds.horn then
        if sounds.horn:GetVolume() > 0 then
            sounds.horn:ChangeVolume( sounds.horn:GetVolume() - dt * 8 )
        else
            sounds.horn:Stop()
            sounds.horn = nil
        end
    end

    local signal = self:GetTurnSignalState()

    if signal > 0 then
        local signalBlink = ( CurTime() % self.TurnSignalCycle ) > self.TurnSignalCycle * 0.5

        if self.lastSignalBlink ~= signalBlink then
            self.lastSignalBlink = signalBlink

            if signalBlink and self.TurnSignalTickOnSound ~= "" then
                self:EmitSound( self.TurnSignalTickOnSound, 65, self.TurnSignalPitch, self.TurnSignalVolume )

            elseif not signalBlink and self.TurnSignalTickOffSound ~= "" then
                self:EmitSound( self.TurnSignalTickOffSound, 65, self.TurnSignalPitch, self.TurnSignalVolume )
            end
        end
    end

    if self.lastSirenEnableTime and CurTime() - self.lastSirenEnableTime > 0.25 then
        if sounds.siren then
            sounds.siren:ChangeVolume( self.SirenVolume * GetVolume( "hornVolume" ) )
        else
            local snd = self:CreateLoopingSound( "siren", self.SirenLoopSound, 90, self )
            snd:PlayEx( self.SirenVolume * GetVolume( "hornVolume" ), 100 )
        end

    elseif sounds.siren then
        sounds.siren:Stop()
        sounds.siren = nil
    end

    if not self:IsEngineOn() then return end

    if self:GetGear() == -1 and self.ReverseSound ~= "" then
        if not sounds.reverse then
            local snd = self:CreateLoopingSound( "reverse", self.ReverseSound, 85, self )
            snd:PlayEx( GetVolume( "hornVolume" ) * 0.9, 100 )
        end

    elseif sounds.reverse then
        sounds.reverse:Stop()
        sounds.reverse = nil
    end

    if self:GetTurboCharged() then
        self:UpdateTurboSound( sounds )

    elseif sounds.turbo then
        sounds.turbo:Stop()
        sounds.turbo = nil
    end

    -- Handle the engine sound
    local stream = self.stream

    if not stream then
        self.stream = Glide.CreateEngineStream( self )
        self:OnCreateEngineStream( self.stream )
        self.stream:Play()

        return
    end

    stream.firstPerson = self.isLocalPlayerInFirstPerson

    local health = self:GetEngineHealth()
    local inputs = stream.inputs

    inputs.rpmFraction = self.rpmFraction or 0
    inputs.throttle = self:GetEngineThrottle()

    local isRedlining = self:GetIsRedlining() and inputs.throttle > 0.9

    if isRedlining ~= stream.isRedlining then
        stream.isRedlining = isRedlining

        if isRedlining and ( self:GetGear() < 3 or health < 0.1 ) then
            self:DoExhaustPop()
        end
    end

    if self.doWobble and inputs.throttle > 0.9 then
        self.doWobble = false
        stream.wobbleTime = 1
    end

    -- Handle damaged engine sounds
    if health < 0.4 then
        if sounds.runDamaged then
            sounds.runDamaged:ChangePitch( 100 + self.rpmFraction * 20 )
            sounds.runDamaged:ChangeVolume( Clamp( ( 0.6 - health ) + inputs.throttle, 0, 1 ) * 0.8 )
        else
            local snd = self:CreateLoopingSound( "runDamaged", "glide/engines/run_damaged_1.wav", 75, self )
            snd:PlayEx( 0.5, 100 )
        end

    elseif sounds.runDamaged then
        sounds.runDamaged:Stop()
        sounds.runDamaged = nil
    end

    if health < 0.5 then
        if sounds.rattle then
            sounds.rattle:ChangeVolume( Clamp( self.rpmFraction - inputs.throttle, 0, 1 ) * ( 1 - health ) * 0.8 )
        else
            local snd = self:CreateLoopingSound( "rattle", "glide/engines/exhaust_rattle.wav", 75, self )
            snd:PlayEx( 0.5, 100 )
        end

    elseif sounds.rattle then
        sounds.rattle:Stop()
        sounds.rattle = nil
    end
end

local CurTime = CurTime
local DrawLight = Glide.DrawLight
local DrawLightSprite = Glide.DrawLightSprite
local COLOR_HEADLIGHT = Color( 255, 255, 255 )

do
    local lightState = {
        brake = false,
        reverse = false,
        headlight = false,
        taillight = false,
        signal_left = false,
        signal_right = false
    }

    local COLOR_BRAKE = Color( 255, 0, 0, 255 )
    local COLOR_REV = Color( 255, 255, 255, 200 )

    --- Update out model's bodygroups depending on which lights are on.
    function ENT:DrawLights()
        lightState.brake = self:GetIsBraking()
        lightState.reverse = self:GetGear() == -1
        lightState.headlight = self:GetHeadlightState() > 0
        lightState.taillight = lightState.headlight

        local signal = self:GetTurnSignalState()
        local signalBlink = ( CurTime() % self.TurnSignalCycle ) > self.TurnSignalCycle * 0.5

        lightState.signal_left = signal == 1 or signal == 3
        lightState.signal_right = signal == 2 or signal == 3

        local myPos = self:GetPos()
        local pos, dir, ltype, enable

        for _, l in ipairs( self.LightSprites ) do
            pos = self:LocalToWorld( l.offset )
            dir = self:LocalToWorld( l.dir ) - myPos
            ltype = l.type
            enable = lightState[ltype]

            -- Blink "signal_*" light types
            if ltype == "signal_left" or ltype == "signal_right" then
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

            if enable and ltype == "headlight" then
                DrawLightSprite( pos, dir, l.size or 30, COLOR_HEADLIGHT )

            elseif enable and ( ltype == "taillight" or ltype == "signal_left" or ltype == "signal_right" ) then
                DrawLightSprite( pos, dir, l.size or 30, l.color or COLOR_BRAKE )
                DrawLight( pos + dir * 10, l.color or COLOR_BRAKE, l.lightRadius )

            elseif enable and ltype == "brake" then
                DrawLightSprite( pos, dir, l.size or 30, COLOR_BRAKE )
                DrawLight( pos + dir * 10, COLOR_BRAKE, l.lightRadius )

            elseif enable and ltype == "reverse" then
                DrawLightSprite( pos, dir, l.size or 20, COLOR_REV )
                DrawLight( pos + dir * 10, COLOR_REV, l.lightRadius )
            end
        end
    end
end

local IsValid = IsValid
local ExpDecay = Glide.ExpDecay

--- Implement this base class function.
function ENT:OnUpdateMisc()
    self:OnUpdateAnimations()

    local dt = FrameTime()
    local rpmFraction = ( self:GetEngineRPM() - self:GetMinRPM() ) / ( self:GetMaxRPM() - self:GetMinRPM() )

    self.rpmFraction = ExpDecay( self.rpmFraction, rpmFraction, 7, dt )

    local headlightState = self:GetHeadlightState()
    local isHeadlightOn = headlightState > 0

    if isHeadlightOn then
        local colorVec = self:GetHeadlightColor()
        COLOR_HEADLIGHT.r = colorVec[1] * 255
        COLOR_HEADLIGHT.g = colorVec[2] * 255
        COLOR_HEADLIGHT.b = colorVec[3] * 255
    end

    -- Render lights and sprites
    self:DrawLights()

    -- Brake release sounds
    if self:GetIsBraking() and self.BrakeSqueakSound ~= "" then
        if self.brakePressure < 1 then
            self.brakePressure = self.brakePressure + dt
        end

    elseif self.brakePressure > 0.5 then
        self.brakePressure = 0

        if self:GetVelocity():LengthSqr() < 1000 and self.BrakeReleaseSound ~= "" then
            self:EmitSound( self.BrakeReleaseSound, 80, 100, 0.8 )
        else
            Glide.PlaySoundSet( self.BrakeSqueakSound, self, 0.8 )
        end
    end

    -- Create/remove headlight projected textures
    if self.headlightState ~= headlightState then
        self.headlightState = headlightState
        self:RemoveHeadlights()

        if headlightState == 0 then return end

        for _, v in ipairs( self.Headlights ) do
            v.angles = v.angles or Angle( 10, 0, 0 )
            self:CreateHeadlight( v.offset, v.angles, COLOR_HEADLIGHT )
        end
    end

    for i, l in ipairs( self.headlights ) do
        if IsValid( l ) then
            local data = self.Headlights[i]
            l:SetPos( self:LocalToWorld( data.offset ) )
            l:SetAngles( self:LocalToWorldAngles( data.angles ) )
            l:Update()
        end
    end

    -- Siren lights/bodygroups
    local siren = self:GetSirenState()

    if self.lastSirenState ~= siren then
        self.lastSirenState = siren

        if siren > 1 then
            self.lastSirenEnableTime = CurTime()

        elseif self.lastSirenEnableTime then
            if CurTime() - self.lastSirenEnableTime < 0.25 then
                Glide.PlaySoundSet( self.SirenInterruptSound, self, self.SirenVolume )
            end

            self.lastSirenEnableTime = nil
        end

        -- Set bodygroups to default
        for _, v in ipairs( self.SirenLights ) do
            if v.bodygroup then
                self:SetBodygroup( v.bodygroup, 0 )
            end
        end
    end

    if siren < 1 then return end

    local myPos = self:GetPos()
    local t = ( CurTime() % self.SirenCycle ) / self.SirenCycle
    local on, pos, dir, radius

    local bodygroupState = {}

    for _, v in ipairs( self.SirenLights ) do
        on = t > v.time and t < v.time + ( v.duration or 0.125 )

        if on and v.offset then
            pos = self:LocalToWorld( v.offset )
            radius = v.lightRadius or 150

            if radius > 0 then
                DrawLight( pos, v.color or color_white, radius )
            end

            dir = v.dir and self:LocalToWorld( v.dir ) - myPos or nil
            DrawLightSprite( pos, dir, v.size or 30, v.color or color_white )
        end

        -- Merge multiple bodygroup entries so that any one of them can "enable" a bodygroup
        if v.bodygroup then
            bodygroupState[v.bodygroup] = bodygroupState[v.bodygroup] or on
        end
    end

    for id, state in pairs( bodygroupState ) do
        self:SetBodygroup( id, state and 1 or 0 )
    end
end

function ENT:CreateHeadlight( offset, angles, color )
    color = color or Color( 255, 255, 255 )

    local state = self.headlightState
    local fov = state > 1 and 80 or 70

    local index = #self.headlights + 1
    local light = ProjectedTexture()

    self.headlights[index] = light

    light:SetConstantAttenuation( 0 )
    light:SetLinearAttenuation( 50 )
    light:SetTexture( "effects/flashlight001" )
    light:SetBrightness( state > 1 and 6 or 4 )
    light:SetEnableShadows( Glide.Config.headlightShadows )
    light:SetColor( color )
    light:SetNearZ( 10 )
    light:SetFarZ( state > 1 and 3000 or 1500 )
    light:SetFOV( fov )
    light:SetPos( self:LocalToWorld( offset ) )
    light:SetAngles( self:LocalToWorldAngles( angles or Angle() ) )
    light:Update()
end

function ENT:RemoveHeadlights()
    if not self.headlights then return end

    for _, light in ipairs( self.headlights ) do
        if IsValid( light ) then
            light:Remove()
        end
    end

    self.headlights = {}
end

local DEFAULT_EXHAUST_ANG = Angle()
local EXHAUST_COLOR = Color( 255, 190, 100 )

function ENT:DoExhaustPop()
    if self:GetEngineHealth() < 0.3 then
        Glide.PlaySoundSet( "Glide.Damaged.ExhaustPop", self )

    elseif self.ExhaustPopSound == "" then
        return
    end

    Glide.PlaySoundSet( self.ExhaustPopSound, self )

    local eff = EffectData()
    eff:SetEntity( self )

    for _, v in ipairs( self.ExhaustOffsets ) do
        local pos = self:LocalToWorld( v.pos )
        local dir = -self:LocalToWorldAngles( v.ang or DEFAULT_EXHAUST_ANG ):Forward()

        eff:SetOrigin( pos )
        eff:SetStart( pos + dir * 10 )
        eff:SetScale( 0.5 )
        eff:SetFlags( 0 )
        eff:SetColor( 0 )
        util.Effect( "glide_tracer", eff )

        DrawLight( pos + dir * 50, EXHAUST_COLOR, 80 )
    end
end

local Effect = util.Effect
local EffectData = EffectData

--- Implement this base class function.
function ENT:OnUpdateParticles()
    local rpmFraction = self.rpmFraction
    local velocity = self:GetVelocity()

    if rpmFraction < 0.5 and self:IsEngineOn() then
        rpmFraction = rpmFraction * 2

        for _, v in ipairs( self.ExhaustOffsets ) do
            local eff = EffectData()
            eff:SetOrigin( self:LocalToWorld( v.pos ) )
            eff:SetAngles( self:LocalToWorldAngles( v.ang or DEFAULT_EXHAUST_ANG ) )
            eff:SetStart( velocity )
            eff:SetScale( v.scale or 1 )
            eff:SetColor( self.ExhaustAlpha )
            eff:SetMagnitude( rpmFraction * 1000 )
            Effect( "glide_exhaust", eff, true, true )
        end
    end

    local health = self:GetEngineHealth()
    if health > 0.5 then return end

    local color = Clamp( health * 255, 0, 255 )
    local scale = 2 - health * 2

    for _, v in ipairs( self.EngineSmokeStrips ) do
        local eff = EffectData()
        eff:SetOrigin( self:LocalToWorld( v.offset ) )
        eff:SetAngles( self:LocalToWorldAngles( v.angle or DEFAULT_EXHAUST_ANG ) )
        eff:SetStart( velocity )
        eff:SetColor( color )
        eff:SetMagnitude( v.width * 1000 )
        eff:SetScale( scale )
        eff:SetRadius( self.EngineSmokeMaxZVel )
        Effect( "glide_damaged_engine", eff, true, true )
    end
end

DEFINE_BASECLASS( "base_glide" )

local RealTime = RealTime
local Floor = math.floor
local DrawRect = surface.DrawRect
local SetColor = surface.SetDrawColor

local Config = Glide.Config
local DrawStatus = Glide.DrawVehicleStatusItem

local GEAR_LABELS = {
    [-1] = "R",
    [0] = "N"
}

local throttle = 0
local w, h, x, y

--- Override this base class function.
function ENT:DrawVehicleHUD( screenW, screenH )
    BaseClass.DrawVehicleHUD( self, screenW, screenH )

    if not Config.showHUD then return end

    w = Floor( screenH * 0.23 )
    h = Floor( screenH * 0.035 )

    local padding = Floor( screenH * 0.008 )
    local radius = Floor( h * 0.15 )
    local margin = Floor( screenH * 0.03 )
    local spacing = Floor( screenH * 0.005 )

    x = screenW - w
    y = screenH - margin - h

    -- RPM
    local rpm = self:GetEngineRPM()
    local stream = self.stream

    if stream and stream.isRedlining then
        local wave = Clamp( math.cos( RealTime() * stream.redlineFrequency * 0.5 ), -1, 1 )
        rpm = rpm - math.abs( wave ) * 500
    end

    DrawStatus( x, y, w, h, radius, padding, "#glide.hud.rpm", Floor( rpm ), rpm / self:GetMaxRPM() )
    y = y - h - spacing

    -- Throttle
    DrawStatus( x, y, w, h, radius, padding, "#glide.hud.throttle" )

    throttle = ExpDecay( throttle, self:GetEngineThrottle(), 20, FrameTime() )

    local barSize = Floor( h * 0.65 )
    local barX = x + w - barSize - padding * 1.3
    local barY = y + ( h * 0.5 ) - barSize * 0.5

    SetColor( 255, 255, 255, 255 )
    DrawRect( barX - 2, barY, 2, barSize )
    DrawRect( barX + barSize, barY, 2, barSize )

    surface.DrawCircle( barX + barSize * 0.5, barY + barSize * 0.5, barSize * 0.1, 255, 255, 255, 255 )
    Glide.DrawRotatedBox( barX + barSize * 0.5, barY + barSize * 0.5, barSize * 0.9, 2, -10 - throttle * 80 )

    y = y - h - spacing

    -- Gear
    DrawStatus( x, y, w, h, radius, padding, "#glide.hud.gear", GEAR_LABELS[self:GetGear()] or self:GetGear() )

    y = y - h - spacing

    -- Speed
    local velocity = self:GetVelocity()
    local speed = velocity:Length() -- Obtain the magnitude from the velocity
    speed = speed * 0.0568182  -- Convert Source units to MPH

    if Config.useKMH then
        speed = speed * 1.60934  -- Convert MPH to km/h
        DrawStatus( x, y, w, h, radius, padding, "#glide.hud.speed", Floor( speed ) .. " km/h" )
    else
        DrawStatus( x, y, w, h, radius, padding, "#glide.hud.speed", Floor( speed ) .. " mph" )
    end
end
