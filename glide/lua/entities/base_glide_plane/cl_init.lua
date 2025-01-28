include( "shared.lua" )

DEFINE_BASECLASS( "base_glide_aircraft" )

--- Implement the base class `OnTurnOn` function.
function ENT:OnTurnOn()
    if self:GetPower() < 0.01 then
        self:EmitSound( self.StartSoundPath, 80, 100, 0.6 )
    end
end

--- Implement this base class function.
function ENT:AllowWindSound()
    return true, 0.8 - self:GetPower()
end

--- Implement this base class function.
function ENT:OnActivateSounds()
    self:CreateLoopingSound( "engine", self.EngineSoundPath, self.EngineSoundLevel )
    self:CreateLoopingSound( "exhaust", self.ExhaustSoundPath, self.ExhaustSoundLevel )
    self:CreateLoopingSound( "distant", self.DistantSoundPath, self.DistantSoundLevel )

    if self.ThrustSound ~= "" then
        self:CreateLoopingSound( "thrust", self.ThrustSound, self.ThrustSoundLevel )
    end

    if self.PropSoundPath == "" then return end

    -- Create a client-side entity to play the propeller sound
    self.entProp = ClientsideModel( "models/hunter/plates/plate.mdl" )
    self.entProp:SetPos( self:LocalToWorld( self.PropOffset ) )
    self.entProp:Spawn()
    self.entProp:SetParent( self )
    self.entProp:SetNoDraw( true )

    self:CreateLoopingSound( "prop", self.PropSoundPath, self.PropSoundLevel, self.entProp )
end

--- Implement this base class function.
function ENT:OnDeactivateSounds()
    if IsValid( self.entProp ) then
        self.entProp:Remove()
        self.entProp = nil
    end
end

--- Implement this base class function.
function ENT:OnActivateMisc()
    self.controlSoundCD = 0
    self.nextControlTime = 0
    self.lastControlInput = {}
end

local Abs = math.abs

function ENT:UpdateControlSurfaceSound( nwFunc, t )
    local controlInput = Abs( self[nwFunc]( self ) ) > 0.5

    if self.lastControlInput[nwFunc] ~= controlInput then
        self.lastControlInput[nwFunc] = controlInput

        if t > self.controlSoundCD then
            self.controlSoundCD = t + 0.5
            Glide.PlaySoundSet( "Glide.Plane.ControlSurface", self, 0.5 )
        end
    end
end

local RealTime = RealTime

--- Override this base class function.
function ENT:OnUpdateMisc()
    BaseClass.OnUpdateMisc( self )

    self:OnUpdateAnimations()

    local t = RealTime()

    if t > self.nextControlTime then
        self.nextControlTime = t + 0.1
        self:UpdateControlSurfaceSound( "GetElevator", t )
        self:UpdateControlSurfaceSound( "GetRudder", t )
        self:UpdateControlSurfaceSound( "GetAileron", t )
    end
end

local Clamp = math.Clamp
local Remap = math.Remap
local GetVolume = Glide.Config.GetVolume

--- Implement this base class function.
function ENT:OnUpdateSounds()
    local sounds = self.sounds
    local vol = GetVolume( "aircraftVolume" )

    for _, snd in pairs( sounds ) do
        if not snd:IsPlaying() then
            snd:PlayEx( 0, 1 )
        end
    end

    local power = self:GetPower()
    local power01 = Clamp( power, 0, 1 )
    local pitch = self:GetExtraPitch()

    if sounds.prop then
        sounds.prop:ChangePitch( Remap( power, 1, 2, self.PropSoundMinPitch, self.PropSoundMaxPitch ) )
        sounds.prop:ChangeVolume( power01 * self.PropSoundVolume * vol )
    end

    if sounds.thrust then
        local thrustVol = Remap( Clamp( self:GetThrottle(), 0, 1 ), 0, 1, self.ThrustSoundLowVolume, self.ThrustSoundHighVolume )

        sounds.thrust:ChangePitch( Remap( power, 0, 2, self.ThrustSoundMinPitch, self.ThrustSoundMaxPitch ) )
        sounds.thrust:ChangeVolume( power01 * thrustVol * vol )
    end

    sounds.engine:ChangePitch( Remap( power, 1, 2, self.EngineSoundMinPitch, self.EngineSoundMaxPitch ) * power01 * pitch )
    sounds.engine:ChangeVolume( power01 * self.EngineSoundVolume * vol )

    sounds.exhaust:ChangePitch( Remap( power, 1, 2, self.ExhaustSoundMinPitch, self.ExhaustSoundMaxPitch ) * power01 * pitch )
    sounds.exhaust:ChangeVolume( power01 * self.ExhaustSoundVolume * vol )

    vol = vol * Clamp( self.rfSounds.lastDistance / 1000000, 0, 1 )

    sounds.distant:ChangePitch( Remap( power, 1, 2, 80, 100 ) )
    sounds.distant:ChangeVolume( vol * power01 )

    -- Handle damaged engine sound
    local health = self:GetEngineHealth()

    if health < 0.5 then
        if sounds.rattle then
            sounds.rattle:ChangeVolume( Clamp( power01 * ( 1 - health ), 0, 1 ) * 0.8 )
        else
            local snd = self:CreateLoopingSound( "rattle", self.EngineRattleSound, 85, self )
            snd:PlayEx( 0.1, 100 )
        end

    elseif sounds.rattle then
        sounds.rattle:Stop()
        sounds.rattle = nil
    end
end

DEFINE_BASECLASS( "base_glide_aircraft" )

local Floor = math.floor
local Config = Glide.Config
local DrawStatus = Glide.DrawVehicleStatusItem

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

    x = screenW - w
    y = screenH - margin - h

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
