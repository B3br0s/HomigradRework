--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
-- Integration with Trixter's Discord Integration
-- https://www.gmodstore.com/market/view/trixter-s-discord-integration

RSC.Discord = RSC.Discord or {}

function RSC.Discord.IsReady()
    return RSC.Discord.Ready and Discord.Backend.Authed
end

function RSC.Discord.RequestScreengrab(commandData)
    if not Discord.Util.Commands.hasPermission(commandData.author, RSC.Config.DiscordCommand) then
        Discord.Util.Commands.commandError(commandData, Discord.Util:GetLang("NO_PERMISSIONS"))
    return end

    local victim = RSC.FindPlayer(commandData.args[1])
    if not victim then
        Discord.Util.Commands.commandError(commandData, Discord.Util:GetLang("PLAYER_COULDNT_BE_FOUND"))
    return end

    local request = RSC.CaptureRequest.New()
    request._requested_by_discord = true
    request:Capture(victim):Await()

    return RSC.Discord.SendScreengrab(request, commandData.channel)
end
RSC.Discord.RequestScreengrab = promise.Async(RSC.Discord.RequestScreengrab)


function RSC.Discord.UploadToImgur(data)
    return promise.HTTP({
        url = "https://api.imgur.com/3/upload",
        method = "POST",
        headers = { Authorization = "Client-ID " .. RSC.Config.ImgurClientID },
        parameters = {
            image = util.Base64Encode(data),
            type = "base64",
        },
    }):Then(function(res)
        if res.code ~= 200 then return promise.Reject("invalid http code") end

        local data = util.JSONToTable(res.body)
        if not data or not data.data or not data.data.link then return promise.Reject("failed to parse download link") end

        return data.data.link
    end)
end

function RSC.Discord.SendScreengrab(request, channel)
    if not RSC.Discord.IsReady() then return end

    channel = channel or RSC.Config.DiscordChannel
    if not channel then return end

    local ok, captureData = request:Download():SafeAwait()
    if not ok then return promise.Reject(captureData) end

    local ok, link = RSC.Discord.UploadToImgur(captureData):SafeAwait()
    if not ok then return promise.Reject(link) end

    Discord.Backend.API:Send(
        Discord.OOP:New("Message"):SetChannel(RSC.Config.DiscordChannel):SetEmbed({
            color = 0xfaa705,
            title = RSC.GetPhrase("rsc.discord.new_screengrab"),
            description = RSC.GetPhrase("rsc.discord.screengrabbed_by"):format( request:GetVictim():GetName() ),
            type = "image",
            image = {
                url = link
            }
        }):ToAPI()
    )
end
RSC.Discord.SendScreengrab = promise.Async(RSC.Discord.SendScreengrab)

hook.Add("RSC.OnCaptureStarted", "RSC.DiscordIntegration", function(request)
    if request._requested_by_discord then return end -- Ignore requests that were made by discord

    request.onResult:On(function(request, ok, result)
        if not ok then return end
        RSC.Discord.SendScreengrab(request)
    end)
end)

function RSC.Discord.Initialize()
    if RSC.Discord.Ready then return end
    if not Discord or not Discord.Backend or not Discord.Backend.API then return end
    if not RSC.Config.DiscordIntegration then return end

    Discord:RegisterCommand(RSC.Config.DiscordCommand, RSC.Discord.RequestScreengrab)

    RSC.Log("info", "Discord integration ready!")
    RSC.Discord.Ready = true
end
hook.Add("Discord_Backend_Connected", "RSC.Discord.Initialize", RSC.Discord.Initialize)

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801