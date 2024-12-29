--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
util.AddNetworkString("RSC.Network")
util.AddNetworkString("RSC.NetworkV2")

function RSC.RegisterCaptureRequestOnClient(ply, victim, quality, serviceName, prepareData)
    net.Start("RSC.NetworkV2")
        net.WriteUInt(RSC.NET_OP_REQUEST_REGISTERED, 4)
        net.WriteEntity(victim)
        net.WriteUInt(quality, 2)
        net.WriteString(serviceName)
        net.WriteBool( isstring(prepareData) )
        if isstring(prepareData) then net.WriteString( prepareData ) end
    net.Send(ply)
end

function RSC.SendResult(ply, victim, ok, result)
    net.Start("RSC.NetworkV2")
        net.WriteUInt(RSC.NET_OP_CAPTURE_RESULT, 4)
        net.WriteEntity(victim)
        net.WriteBool(ok)
        net.WriteString(result)
    net.Send(ply)
end

local OnRequestCapture = promise.Async(function(ply, victim, quality, serviceName)
    if not IsValid(victim) then return promise.Reject("#rsc.errors.invalid_victim") end
    if not RSC.AsyncCanScreengrab(ply, victim):Await() then return promise.Reject("#rsc.errors.no_rights") end

    local request = RSC.CaptureRequest.Requests[victim]
    if not request then
        request = RSC.CaptureRequest.New()
        request:AddReceiver(ply)
        local ok, err = request:Capture(victim, serviceName, quality):SafeAwait()
        if not ok then
            request:Remove()
            return promise.Reject(err)
        end
    else
        request:AddReceiver(ply)
    end
end)

local function OnMessage(victim)
    local type, message = RSC.ReadMessage()
    local source = RSC.MESSAGE_SOURCE_VICTIM

    local request = RSC.CaptureRequest.Requests[victim]
    if request then
        request.onMessage:Emit(request, type, message, source)

        if type == RSC.MESSAGE_TYPE_ERROR then
            request:SetResult(false, message)
        end
    end
end

-- Syncing configuration with client
local SHARED_CONFIG_VALUES = { "DefaultLanguage", "ForceLanguage", "PlayerTopField", "PlayerBottomField" } -- List of config keys that need to be networked
local function SendConfigToPlayer(ply)
    net.Start("RSC.NetworkV2")
        net.WriteUInt(RSC.NET_OP_UPDATE_CONFIG, 4)
        for _, key in ipairs(SHARED_CONFIG_VALUES) do
            net.WriteBool(true)
            net.WriteString(key)
            net.WriteType(RSC.Config[key])
        end
        net.WriteBool(false)
    net.Send(ply)
end

local function SendLanguageTranslations(ply)
    local lang = net.ReadString():sub(1, 2)

    if not ply.RSC_REQUESTED_LANGUAGES then ply.RSC_REQUESTED_LANGUAGES = {} end
    if ply.RSC_REQUESTED_LANGUAGES[lang] then return end
    ply.RSC_REQUESTED_LANGUAGES[lang] = true

    local strings = RSC.PreloadPhrases(lang):Await()
    if not strings then return end

    net.Start("RSC.NetworkV2")
        net.WriteUInt(RSC.NET_OP_REQUEST_TRANSLATION, 4)
        net.WriteString(lang)
        for key, value in pairs(strings) do
            net.WriteBool(true)
            net.WriteString( tostring(key) )
            net.WriteString( tostring(value) )
        end
        net.WriteBool(false)
    net.Send(ply)
end
SendLanguageTranslations = promise.Async(SendLanguageTranslations)

local OPS = {
    [RSC.NET_OP_MESSAGE] = OnMessage,
    [RSC.NET_OP_REQUEST_CAPTURE] = function(ply)
        local victim, quality, serviceName = net.ReadEntity(), net.ReadUInt(2), net.ReadString()
        OnRequestCapture(ply, victim, quality, serviceName):Catch(function(err)
            RSC.RegisterCaptureRequestOnClient(ply, victim, quality, serviceName)
            RSC.SendMessage(RSC.MESSAGE_TYPE_ERROR, err, ply, RSC.MESSAGE_SOURCE_SERVER, victim)
            RSC.SendResult(ply, victim, false, err)
        end)
    end,
    [RSC.NET_OP_CANCEL_REQUEST] = function(ply)
        local victim = net.ReadEntity()
        local request = RSC.CaptureRequest.Requests[victim]
        if request then request.receivers:RemovePlayer(ply) end
    end,
    [RSC.NET_OP_CAPTURE_RESULT] = function(victim)
        local ok, result = net.ReadBool(), net.ReadString()
        local request = RSC.CaptureRequest.Requests[victim]
        if request then
            if request.receivers:GetCount() ~= 0 then
                request.onMessage:Emit(request, RSC.MESSAGE_TYPE_INFO, "#rsc.notify.sending_capture_data", RSC.MESSAGE_SOURCE_SERVER)
            end

            request:SetResult(ok, result)
        end
    end,
    [RSC.NET_OP_CHECK_ACCESS] = function(ply)
        local function callback(can)
            net.Start("RSC.NetworkV2")
                net.WriteUInt(RSC.NET_OP_CHECK_ACCESS, 4)
                net.WriteBool(can)
            net.Send(ply)
        end

        local ok = xpcall(RSC.HasAccess, ErrorNoHaltWithStack, ply, callback)
        if not ok then callback(false) end
    end,
    [RSC.NET_OP_UPDATE_CONFIG] = function(ply)
        if ply.RSC_CONFIG_REQUESTED then return end -- Allow player to request config only once
        ply.RSC_CONFIG_REQUESTED = true
        SendConfigToPlayer(ply)
    end,
    [RSC.NET_OP_REQUEST_TRANSLATION] = SendLanguageTranslations,
}
net.Receive("RSC.NetworkV2", function(_, ply)
    local op = net.ReadUInt(4)
    if OPS[op] then OPS[op](ply) end
end)

hook.Add("RSC.OnConfigUpdated", "RSC.NetworkConfigurationWithPlayers", function()
    local players = RecipientFilter()
    players:AddAllPlayers()

    SendConfigToPlayer(players)
end)

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801