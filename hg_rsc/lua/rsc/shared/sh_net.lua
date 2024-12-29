--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
-- Operations
RSC.NET_OP_REQUEST_CAPTURE = 0
RSC.NET_OP_MESSAGE = 1
RSC.NET_OP_CAPTURE_RESULT = 2
RSC.NET_OP_REQUEST_REGISTERED = 3 -- Client only
RSC.NET_OP_CANCEL_REQUEST = 4 -- Server only
RSC.NET_OP_CHECK_ACCESS = 5
RSC.NET_OP_UPDATE_CONFIG = 6
RSC.NET_OP_REQUEST_TRANSLATION = 7

-- Message types
RSC.MESSAGE_TYPE_INFO = 0
RSC.MESSAGE_TYPE_ERROR = 1
RSC.MESSAGE_TYPE_SUCCESS = 2

-- Message source
RSC.MESSAGE_SOURCE_VICTIM = 0
RSC.MESSAGE_SOURCE_SERVER = 1

function RSC.SendMessage(type, message, ply, source, victim)
    net.Start("RSC.NetworkV2")
        net.WriteUInt(RSC.NET_OP_MESSAGE, 4)
        net.WriteUInt(type, 4)
        net.WriteString(message)
        if SERVER then
            net.WriteUInt(source, 4)
            net.WriteEntity(victim)
        end
    if SERVER then net.Send(ply) else net.SendToServer() end
end

function RSC.SendError(message, ply, source, victim)
    RSC.SendMessage(RSC.MESSAGE_TYPE_ERROR, message, ply, source, victim)
end

function RSC.ReadMessage()
    local type, message, source, victim = net.ReadUInt(4), net.ReadString(), CLIENT and net.ReadUInt(4), CLIENT and net.ReadEntity()
    return type, message, source, victim
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801