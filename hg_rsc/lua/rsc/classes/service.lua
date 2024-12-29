--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
local RSC = RSC
local setmetatable = setmetatable
local tostring = tostring
local promise = promise

RSC.RECOMMENDED_SERVICE = "gmod.express"

-- Transfer service
module("RSC.Service")

Services = {}

-- Metatable for service class
SERVICE = SERVICE or {}
SERVICE.__index = SERVICE

function SERVICE:GetName() return tostring(self.name) end
function SERVICE:GetDownloadURL(data, prepareData) return data end -- Can be async

function SERVICE:Ping() -- Must be async
    return promise.Resolve(true)
end

function SERVICE:Prepare() -- Must be async
    return promise.Resolve()
end

function SERVICE:Upload(data, quality, prepareData) -- Must be async
    return promise.Reject("#rsc.errors.not_implemented")
end

function SERVICE:Download(uploadData, quality, prepareData) -- Must be async
    return promise.Reject("#rsc.errors.not_implemented")
end

function SERVICE:Register()
    Services[ self:GetName() ] = self
end

-- Constructs a new service with specified name
function New(name)
    return setmetatable({ name = name }, SERVICE)
end

-- Gets registered service by name
function Get(name)
    return Services[tostring(name)]
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801