--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
local function RequestCapture()
    local quality, serviceName, prepareData = net.ReadUInt(2), net.ReadString(), net.ReadBool() and net.ReadString()
    local service = RSC.Service.Get(serviceName)

    local onResult = promise.Async(function(data)
        RSC.SendMessage(RSC.MESSAGE_TYPE_SUCCESS, "#rsc.notify.uploading")
        local ok, uploadData = service:Upload(data, quality, prepareData):SafeAwait()
        if not ok then return promise.Reject(RSC.GetPhrase("rsc.errors.upload_failed"):format(uploadData)) end

        RSC.SendMessage(RSC.MESSAGE_TYPE_SUCCESS, "#rsc.notify.upload_success")
        net.Start("RSC.NetworkV2")
            net.WriteUInt(RSC.NET_OP_CAPTURE_RESULT, 4)
            net.WriteBool(ok)
            net.WriteString(uploadData)
        net.SendToServer()
    end)

    RSC.Capture(quality, RSC.SendMessage, function(...)
        onResult(...):Catch(RSC.SendError)
    end)
end

local RequestRegistered = promise.Async(function()
    local victim, quality, serviceName, prepareData = net.ReadEntity(), net.ReadUInt(2), net.ReadString(), net.ReadBool() and net.ReadString()

    local request = RSC.CaptureRequest.Requests[victim]
    if not request then
        request = RSC.CaptureRequest.New()
        request.victim = victim
        RSC.CaptureRequest.Requests[victim] = request
    end

    request.onRegistered:Emit(request, quality, serviceName, prepareData)
end)

local OPS = {
    [RSC.NET_OP_REQUEST_CAPTURE] = RequestCapture,
    [RSC.NET_OP_REQUEST_REGISTERED] = RequestRegistered,
    [RSC.NET_OP_MESSAGE] = function()
        local type, message, source, victim = RSC.ReadMessage()
        local request = RSC.CaptureRequest.Requests[victim]
        if request then request.onMessage:Emit(request, type, message, source) end
    end,
    [RSC.NET_OP_CAPTURE_RESULT] = function()
        local victim, ok, result = net.ReadEntity(), net.ReadBool(), net.ReadString()
        local request = RSC.CaptureRequest.Requests[victim]
        if request then request:SetResult(ok, result) end
    end,
    [RSC.NET_OP_CHECK_ACCESS] = function()
        local can = net.ReadBool()
        for i, cb in ipairs(RSC.AccessRequests) do
            RSC.AccessRequests[i] = nil
            if not isfunction(cb) then continue end

            xpcall(cb, ErrorNoHaltWithStack, can)
        end
    end,
    [RSC.NET_OP_UPDATE_CONFIG] = function()
        while net.ReadBool() do
            RSC.Config[ net.ReadString() ] = net.ReadType()
        end
        hook.Run("RSC.OnConfigUpdated")
    end,
    [RSC.NET_OP_REQUEST_TRANSLATION] = function()
        local strings = {}
        local lang = net.ReadString()
        while net.ReadBool() do
            strings[net.ReadString()] = net.ReadString()
        end

        RSC.PhraseStore[lang] = strings
        RSC.UpdateCurrentLanguage()
    end,
}
net.Receive("RSC.NetworkV2", function()
    local op = net.ReadUInt(4)
    if OPS[op] then OPS[op]() end
end)

-- Request config from a server
hook.Add("InitPostEntity", "RSC.OnNetReady", function()
    RSC.NetworkReady = true

    net.Start("RSC.NetworkV2")
        net.WriteUInt(RSC.NET_OP_UPDATE_CONFIG, 4)
    net.SendToServer()
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801