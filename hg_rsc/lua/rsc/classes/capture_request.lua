--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
local setmetatable = setmetatable
local RSC = RSC
local promise = promise
local timer = timer
local IsValid = IsValid
local IsEntity = IsEntity
local RecipientFilter = RecipientFilter
local isnumber = isnumber
local net = net
local tostring = tostring
local CLIENT = CLIENT
local SERVER = SERVER
local ipairs = ipairs
local hook = hook

module("RSC.CaptureRequest")

Requests = Requests or {}

-- Meta for capture request class
CAPTURE_REQUEST = CAPTURE_REQUEST or {}
CAPTURE_REQUEST.__index = CAPTURE_REQUEST

-- This is async function
function CAPTURE_REQUEST:Capture(victim, serviceName, quality)
    -- We can't initiate capture while it is already capturing someone
    if self:IsInQueue() then return promise.Reject("already in queue") end

    self.victim = nil
    self.prepareData = nil
    self.successful = nil
    self.result = nil

    -- Sets service class or recommended service
    self.service = RSC.Service.Get(serviceName) or
                   RSC.Service.Get(RSC.RECOMMENDED_SERVICE)

    -- Sets quality in range from 0 to 2, or sets 2
    self.quality = (isnumber(quality) and quality >= 0 and quality <= 3) and
                   quality or
                   2 -- By default use best quality

    if not self.service then return promise.Reject("#rsc.errors.invalid_service") end

    -- Validating victim
    if not IsEntity(victim) or not victim:IsValid() or not victim:IsPlayer() or victim:IsBot() then
        return promise.Reject("#rsc.errors.invalid_victim")
    end

    while Requests[victim] do
        -- Waiting until list is free
        promise.New(function(resolve)
            Requests[victim].onResult:Once(resolve)
        end):Await()
    end

    -- Registering this capture request in the list
    self.victim = victim
    Requests[self.victim] = self

    -- Clients must wait for server approve their request
    if CLIENT then
        net.Start("RSC.NetworkV2")
            net.WriteUInt(RSC.NET_OP_REQUEST_CAPTURE, 4)
            net.WriteEntity( self:GetVictim() )
            net.WriteUInt( self:GetQuality(), 2 )
            net.WriteString( self:GetService():GetName() )
        net.SendToServer()

        -- Waiting for this request become registered
        promise.New(function(resolve)
            self.onRegistered:Once(resolve)
        end):Await()

        hook.Run("RSC.OnCaptureStarted", self)
    return end

    -- If victim didn't respond with result in specified timeout, then set timeout error
    timer.Simple(RSC.Config.CaptureTimeout or 30, function()
        if not self:IsInQueue() then return end
        self:Error("#rsc.errors.timeout")
    end)

    -- Get prepare data (like auth token) from current service
    local ok, prepareData = self:GetService():Prepare():SafeAwait()
    if not ok then return promise.Reject(prepareData) end
    self.prepareData = prepareData and tostring(prepareData)

    -- Registering all CaptureRequest instances on receivers
    if self.receivers:GetCount() ~= 0 then
        for _, ply in ipairs( self:GetReceivers() ) do
            self:AddReceiver(ply)
        end
    end

    -- Requesting capture from victim
    net.Start("RSC.NetworkV2")
        net.WriteUInt(RSC.NET_OP_REQUEST_CAPTURE, 4)
        net.WriteUInt( self:GetQuality(), 2 )
        net.WriteString( self:GetService():GetName() )
        net.WriteBool( self:GetPrepareData() ~= nil )
        if self:GetPrepareData() then net.WriteString( self:GetPrepareData() ) end
    net.Send( self:GetVictim() )

    hook.Run("RSC.OnCaptureStarted", self)
end
CAPTURE_REQUEST.Capture = promise.Async(CAPTURE_REQUEST.Capture)

function CAPTURE_REQUEST:IsValid() return IsValid(self.victim) end
function CAPTURE_REQUEST:GetVictim() return self:IsValid() and self.victim end
function CAPTURE_REQUEST:IsInQueue() return self:IsValid() and Requests[ self:GetVictim() ] == self end
function CAPTURE_REQUEST:GetService() return self.service end
function CAPTURE_REQUEST:GetQuality() return self.quality or 2 end
function CAPTURE_REQUEST:GetReceivers() return SERVER and self.receivers:GetPlayers() or {} end
function CAPTURE_REQUEST:GetPrepareData() return self.prepareData end
function CAPTURE_REQUEST:IsEnded() return not self:IsInQueue() and self.successful ~= nil end
function CAPTURE_REQUEST:IsOk() return self.successful end
function CAPTURE_REQUEST:GetResult() return self.result end

function CAPTURE_REQUEST:AddReceiver(ply)
    if CLIENT then return end

    self.receivers:AddPlayer(ply)

    if self:IsInQueue() then
        RSC.RegisterCaptureRequestOnClient(
            ply,
            self:GetVictim(),
            self:GetQuality(),
            self:GetService():GetName(),
            self:GetPrepareData()
        )

        local phrase = RSC.GetPhrase("rsc.notify.receiver_added")
        self.onMessage:Emit(self, RSC.MESSAGE_TYPE_INFO, phrase:format(ply:GetName()), RSC.MESSAGE_SOURCE_SERVER)
    end
end

function CAPTURE_REQUEST:Remove()
    if self:IsInQueue() then
        Requests[ self:GetVictim() ] = nil

        if CLIENT then
            net.Start("RSC.NetworkV2")
                net.WriteUInt(RSC.NET_OP_CANCEL_REQUEST, 4)
                net.WriteEntity( self:GetVictim() )
            net.SendToServer()
        end
    end
end

function CAPTURE_REQUEST:SetResult(ok, result)
    if not self:IsInQueue() then return end

    self.successful = ok
    self.result = result

    self:Remove()
    self.onResult:Emit(self, ok, result)
end

function CAPTURE_REQUEST:Error(err, source)
    source = source or RSC.MESSAGE_SOURCE_SERVER

    self.onMessage:Emit(self, RSC.MESSAGE_TYPE_ERROR, err, source)
    self:SetResult(false, err)
end

function CAPTURE_REQUEST:WaitForResult()
    return promise.New(function(res, rej)
        if self:IsEnded() then
            if self:IsOk() then res( self:GetResult() ) else rej( self:GetResult() ) end
        return end

        self.onResult:Once(function(_, ok, result)
            if ok then res(result) else rej(result) end
        end)
    end)
end

-- Aliases for service
function CAPTURE_REQUEST:GetDownloadURL()
    return self:WaitForResult():Then(function(result)
        return self:GetService():GetDownloadURL(result, self:GetPrepareData())
    end)
end

function CAPTURE_REQUEST:Download()
    return self:WaitForResult():Then(function(result)
        return self:GetService():Download(result, self:GetQuality(), self:GetPrepareData())
    end)
end

-- Constructor for capture request class
function New()
    local request = setmetatable({}, CAPTURE_REQUEST)
    request.onMessage = RSC.Event.New() -- onMessage:On( function(request, messageType, messageStr, source) end )
    request.onResult = RSC.Event.New() -- onResult:On( function(request, ok, result) end )

    if SERVER then request.receivers = RecipientFilter() end

    if SERVER then
        request.onMessage:On(function(self, messageType, messageStr, source)
            if not self:IsValid() then return end
            RSC.SendMessage(messageType, messageStr, self.receivers, source, self:GetVictim())
        end)

        request.onResult:On(function(self, ok, result)
            if not self:IsValid() then return end
            RSC.SendResult(self.receivers, self:GetVictim(), ok, result)
        end)
    end

    if CLIENT then
        request.onRegistered = RSC.Event.New() -- onRegistered:On( function(request, quality, serviceName, prepareData) end )
        request.onRegistered:On(function(self, quality, serviceName, prepareData)
            if not self:IsInQueue() then return end
            self.quality = quality
            self.service = RSC.Service.Get(serviceName)
            self.prepareData = prepareData
        end)
    end

    return request
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801