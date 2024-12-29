--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801

hook.Add("PlayerDisconnected", "RSC.OnPlayerDisconnected", function(ply)
    local request = RSC.CaptureRequest.Requests[ply]
    if request then
        request:SetError("#rsc.errors.player_disconnected")
    end
end)

hook.Add("PlayerSay", "RSC.OnPlayerSay", function(ply, text, team)
    if text:lower():StartWith("!rsc") then
        ply:ConCommand("rsc")
        return ""
    end
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801