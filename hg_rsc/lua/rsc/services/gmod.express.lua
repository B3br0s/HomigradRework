--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
-- This api uses code from two open-source projects from CFC-Servers that was made by Brandon Sturgeon
-- https://github.com/CFC-Servers/gm_express
-- https://github.com/CFC-Servers/gm_express_service
--
-- These libraries are licensed under GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
-- https://github.com/CFC-Servers/gm_express/blob/main/LICENSE
-- https://github.com/CFC-Servers/gm_express_service/blob/main/LICENSE

local GM_EXPRESS_DOMAIN = "gmod-express.dankmolot.workers.dev"
local GM_EXPRESS_DOMAIN_CL

local GM_EXPRESS_VERSION = 1
local GM_EXPRESS_REVISION = 1

local JSON_TYPE = "application/json"
local BYTES_TYPE = "application/octet-stream"

local gm_express = RSC.Service.New("gmod.express")

function gm_express:GetServerToken()
    return (self.tokenLifetime or 0) > SysTime() and self.serverToken
end

function gm_express:GetClientToken()
    return (self.tokenLifetime or 0) > SysTime() and self.clientToken
end

function gm_express:GetToken()
    return SERVER and self:GetServerToken() or self:GetClientToken()
end

function gm_express:GetDomain()
    return CLIENT and GM_EXPRESS_DOMAIN_CL or GM_EXPRESS_DOMAIN
end

function gm_express:GetBaseURL()
    return string.format("%s://%s/v%d", "http", self:GetDomain(), GM_EXPRESS_VERSION)
end

function gm_express:GetURL(...)
    local url = self:GetBaseURL()
    local args = { url, ... }
    return table.concat(args, "/")
end

function gm_express:GetAccessURL(token, action, ...)
    return self:GetURL(action, token or self:GetToken(), ...)
end

function gm_express:GetDownloadURL(id, token)
    return self:GetAccessURL(token, "read", id)
end

function gm_express:Ping()
    local ok, res = promise.HTTP({ url = self:GetURL("revision"), headers = { ["Accept"] = JSON_TYPE, timeout = 5 } }):SafeAwait()

    local data = ok and res.code == 200 and util.JSONToTable(res.body)
    return data and data.revision == GM_EXPRESS_REVISION
end
gm_express.Ping = promise.Async(gm_express.Ping)

function gm_express:Upload(data, _, token)
    if not token then return promise.Reject("failed to get an upload token") end

    local ok, res = promise.HTTP({
        url = self:GetAccessURL(token, "write"),
        method = "POST",
        body = data,
        headers = { ["Accept"] = JSON_TYPE, ["Content-Length"] = #data },
        type = BYTES_TYPE,
        timeout = 20,
    }):SafeAwait()

    if not ok then return promise.Reject("http error: " .. tostring(res)) end
    if res.code ~= 200 then return promise.Reject("upload wasn't successful: http code - " .. res.code) end

    local response = util.JSONToTable(res.body)
    if not response or not response.id then return promise.Reject("invalid response from " .. self:GetDomain()) end

    return response.id
end
gm_express.Upload = promise.Async(gm_express.Upload)

function gm_express:Download(id, _, token)
    if not token then return promise.Reject("failed to get an upload token") end

    local ok, res = promise.HTTP({
        url = self:GetDownloadURL(id, token),
        method = "GET",
        headers = { ["Accept"] = BYTES_TYPE },
        timeout = 60,
    }):SafeAwait()

    if not ok then return promise.Reject("http error: " .. tostring(res)) end
    if res.code ~= 200 then return promise.Reject("upload wasn't successful: http code - " .. res.code) end

    return res.body
end
gm_express.Download = promise.Async(gm_express.Download)

function gm_express:Prepare()
    if not self:GetToken() then
        local oneDay = 60 * 60 * 24
        self.tokenLifetime = SysTime() + oneDay
        self.serverToken = nil
        self.clientToken = nil

        local ok, res = promise.HTTP({ url = self:GetURL("register"), headers = { ["Accept"] = JSON_TYPE } }):SafeAwait()
        if not ok or res.code ~= 200 then return end

        local data = util.JSONToTable(res.body)
        if not data or not data.client or not data.server then return end

        self.serverToken = data.server
        self.clientToken = data.client
    end

    return self:GetClientToken()
end
gm_express.Prepare = promise.Async(gm_express.Prepare)

gm_express:Register()
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801