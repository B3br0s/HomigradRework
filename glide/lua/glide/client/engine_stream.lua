--[[
    Utility class to handle engine sounds with the BASS library.

    Allows the manipulation of the pitch/volume of many sound
    layers using a combination of "controllers".

    Handles the math to make 2D sounds behave like 3D on demand,
    to prevent sounds "lagging behind" fast-moving entities.
]]

local IsValid = IsValid

-- Default stream parameters
local DEFAULT_PARAMS = {
    pitch = 1,
    volume = 1,
    fadeDist = 1500,

    redlineFrequency = 55,
    wobbleFrequency = 25,
    wobbleStrength = 0.13
}

Glide.DEFAULT_STREAM_PARAMS = DEFAULT_PARAMS

local EngineStream = Glide.EngineStream or {}
EngineStream.__index = EngineStream
Glide.EngineStream = EngineStream

local streamInstances = Glide.streamInstances or {}
Glide.streamInstances = streamInstances

function Glide.CreateEngineStream( parent )
    local id = ( Glide.lastStreamInstanceID or 0 ) + 1
    Glide.lastStreamInstanceID = id

    local stream = {
        -- Internal parameters
        id = id,
        parent = parent,
        offset = Vector(),
        layers = {},

        wobbleTime = 0,
        isPlaying = false,
        isRedlining = false,
        firstPerson = false,

        inputs = {
            throttle = 0,
            rpmFraction = 0
        }
    }

    -- Customizable parameters
    for k, v in pairs( DEFAULT_PARAMS ) do
        stream[k] = v
    end

    streamInstances[id] = stream
    Glide.PrintDev( "Stream instance #%s has been created.", id )

    return setmetatable( stream, EngineStream )
end

function EngineStream:Destroy()
    self:RemoveAllLayers()
    self.layers = nil
    self.parent = nil

    streamInstances[self.id] = nil
    Glide.PrintDev( "Stream instance #%s has been destroyed.", self.id )

    setmetatable( self, nil )
end

function EngineStream:RemoveAllLayers()
    for id, _ in pairs( self.layers ) do
        self:RemoveLayer( id )
    end
end

--- Convenience function to parse and load a JSON preset file
--- from `garrysmod/data_static/glide/stream_presets/`.
function EngineStream:LoadPreset( name )
    local path = "data_static/glide/stream_presets/" .. name .. ".json"
    local data = file.Read( path, "GAME" )

    if data then
        self:LoadJSON( data )
    else
        Glide.Print( "Engine stream preset not found: %s", path )
    end
end

function EngineStream:LoadJSON( data )
    data = Glide.FromJSON( data )

    local keyValues = data.kv or {}
    local layers = data.layers

    if type( keyValues ) ~= "table" then
        Glide.Print( "JSON does not have valid key-value data!" )
        return
    end

    for k, v in pairs( keyValues ) do
        if DEFAULT_PARAMS[k] and type( v ) == "number" then
            self[k] = v
        else
            Glide.Print( "Invalid key/value: %s/$s", k, v )
        end
    end

    if type( layers ) ~= "table" then
        Glide.Print( "JSON does not have valid layer data!" )
        return
    end

    for id, layer in SortedPairs( layers ) do
        if type( layer ) ~= "table" then
            Glide.Print( "JSON does not look like sound preset data!" )
            return
        end

        local p = layer.path
        local c = layer.controllers

        if
            type( id ) == "string" and
            type( p ) == "string" and
            type( c ) == "table"
        then
            self:AddLayer( id, p, c, layer.redline == true )
        else
            Glide.Print( "JSON does not look like sound preset data!" )
            return
        end
    end
end

local outputs = {
    volume = 0,
    pitch = 0
}

do
    local VALIDATION_MSG = "Layer '%s', controller #%d: %s"

    local function Validate( controller, controllerId, layerId, stream )
        if not stream.inputs[controller[1]] then
            return false, VALIDATION_MSG:format( layerId, controllerId, "Invalid input type!" )
        end

        if type( controller[2] ) ~= "number" then
            return false, VALIDATION_MSG:format( layerId, controllerId, "Min. input value must be a number!" )
        end

        if type( controller[3] ) ~= "number" then
            return false, VALIDATION_MSG:format( layerId, controllerId, "Max. input value must be a number!" )
        end

        if not outputs[controller[4]] then
            return false, VALIDATION_MSG:format( layerId, controllerId, "Invalid output type!" )
        end

        if type( controller[5] ) ~= "number" then
            return false, VALIDATION_MSG:format( layerId, controllerId, "Min. output value must be a number!" )
        end

        if type( controller[6] ) ~= "number" then
            return false, VALIDATION_MSG:format( layerId, controllerId, "Max. output value must be a number!" )
        end

        return true
    end

    function EngineStream:AddLayer( id, path, controllers, redline )
        if self.layers[id] then
            Glide.Print( "Layer '%s' already exists!", id )
            return
        end

        if not table.IsSequential( controllers ) then
            Glide.Print( "Controllers for the layer '%s' must be a sequential table!", id )
            return
        end

        for i, c in ipairs( controllers ) do
            local valid, msg = Validate( c, i, id, self )

            if not valid then
                Glide.Print( msg )
                return
            end
        end

        self.layers[id] = {
            path = path,
            redline = redline,
            controllers = controllers,

            -- Load sound one by one to prevent random `FILEFORM` errors
            isLoaded = false,

            -- Outputs generated by our controllers
            volume = 0,
            pitch = 0
        }
    end
end

function EngineStream:RemoveLayer( id )
    local layer = self.layers[id]
    if not layer then return end

    if IsValid( layer.channel ) then
        layer.channel:Stop()
    end

    layer.channel = nil
    self.layers[id] = nil
end

function EngineStream:Play()
    self.isPlaying = true

    for _, layer in pairs( self.layers ) do
        if IsValid( layer.channel ) then
            layer.channel:Play()
        end
    end
end

function EngineStream:Pause()
    self.isPlaying = false

    for _, layer in pairs( self.layers ) do
        if IsValid( layer.channel ) then
            layer.channel:Pause()
        end
    end
end

local Clamp = math.Clamp
local Remap = math.Remap
local Cos = math.cos

local Time = RealTime
local GetVolume = Glide.Config.GetVolume

local vol, pitch, pan
local origin, dir, dist

function EngineStream:Think( dt, eyePos, eyeRight )
    if not self.isPlaying then return end
    if not IsValid( self.parent ) then return end

    vol = self.volume * GetVolume( "carVolume" )
    pitch = 1
    pan = 0

    -- Calculate direction and distance from the camera
    origin = self.parent:LocalToWorld( self.offset )
    dir = origin - eyePos
    dist = dir:Length()

    -- Attenuate depending on distance
    vol = vol * ( 1 - Clamp( dist / self.fadeDist, 0, 1 ) )

    -- Pan to make the sound have a fake position
    -- in the world, but only in 3rd person camera.
    if self.firstPerson then
        pan = 0
    else
        dir:Normalize()
        pan = eyeRight:Dot( dir )
    end

    -- Gear switch "wobble"
    if self.wobbleTime > 0 then
        self.wobbleTime = self.wobbleTime - dt

        pitch = pitch + Cos( self.wobbleTime * self.wobbleFrequency ) * self.wobbleTime * ( 1 - self.wobbleTime ) * self.wobbleStrength
    end

    pitch = pitch * self.pitch

    -- Rapidly change volume to simulate hitting the rev limiter
    local redlineVol = 1

    if self.isRedlining then
        redlineVol = 0.75 + Cos( Time() * self.redlineFrequency ) * 0.25
    end

    local inputs = self.inputs
    local channel, value

    for _, layer in pairs( self.layers ) do
        channel = layer.channel

        if IsValid( channel ) then
            outputs.volume, outputs.pitch = 1, 1

            for _, c in ipairs( layer.controllers ) do
                value = Clamp( inputs[c[1]], c[2], c[3] )
                value = Remap( value, c[2], c[3], c[5], c[6] )

                -- If any previous controller(s) changed the
                -- same output type, mix their output with this one.
                outputs[c[4]] = outputs[c[4]] * value
            end

            layer.volume = outputs.volume * ( layer.redline and redlineVol or 1 )
            layer.pitch = outputs.pitch * pitch

            channel:SetPlaybackRate( layer.pitch )
            channel:SetVolume( layer.volume * vol )
            channel:SetPan( pan )

            if channel:GetState() < 1 then
                channel:Play()
            end
        end
    end
end

--[[
    Update existing stream instances, and handle
    loading `IGModAudioChannel`s one at a time.
]]

local function DestroyChannel( channel )
    if IsValid( channel ) then
        channel:Stop()
    end
end

-- Hold info about which stream and layer
-- we're loading a IGModAudioChannel for.
local loading = nil

local function LoadCallback( channel, _, errorName )
    -- Sanity check
    if loading == nil then
        DestroyChannel( channel )
        return
    end

    -- Make sure the stream instance still exists
    local stream = streamInstances[loading.streamId]

    if not stream then
        Glide.PrintDev( "Destroying channel, stream instance #%s no longer exists.", loading.streamId )
        DestroyChannel( channel )
        loading = nil
        return
    end

    -- Make sure the stream layer still exists
    local layer = stream.layers[loading.layerId]

    if not layer then
        Glide.PrintDev( "Destroying channel, stream #%s/layer #%s no longer exists.", loading.streamId, loading.layerId )
        DestroyChannel( channel )
        loading = nil
        return
    end

    -- Make sure the stream audio path has not changed
    if layer.path ~= loading.layerPath then
        Glide.PrintDev( "Destroying channel, stream #%s/layer #%s has a different path now.", loading.streamId, loading.layerId )
        DestroyChannel( channel )
        loading = nil
        return
    end

    -- Make sure the channel is valid
    if not IsValid( channel ) then
        Glide.Print( "Could not load audio for stream #%s/layer #%s: %s", loading.streamId, loading.layerId, errorName )
        loading = nil

        if stream.errorCallback then
            stream.errorCallback( layer.path, errorName )
        end

        return
    end

    loading = nil
    layer.channel = channel

    channel:EnableLooping( true )
    channel:SetPlaybackRate( 1.0 )
    channel:SetVolume( 0.0 )
    channel:SetPan( 0 )
end

local pairs = pairs
local FrameTime = FrameTime
local GetLocalViewLocation = Glide.GetLocalViewLocation

hook.Add( "Think", "Glide.ProcessEngineStreams", function()
    local dt = FrameTime()
    local eyePos, eyeAng = GetLocalViewLocation()
    local eyeRight = eyeAng:Right()

    for streamId, stream in pairs( streamInstances ) do
        -- Let the stream do it's thing
        stream:Think( dt, eyePos, eyeRight )

        for layerId, layer in pairs( stream.layers ) do
            -- If this layer has not loaded yet,
            -- and we are not busy loading another one...
            if not layer.isLoaded and loading == nil then
                loading = {
                    streamId = streamId,
                    layerId = layerId,
                    layerPath = layer.path,
                }

                -- Prevent processing this layer again
                layer.isLoaded = true

                -- Try to create a IGModAudioChannel
                sound.PlayFile( "sound/" .. layer.path, "noplay noblock", LoadCallback )
            end
        end
    end
end )
