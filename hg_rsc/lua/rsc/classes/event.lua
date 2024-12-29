--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
local setmetatable = setmetatable
local pairs = pairs
local type = type
local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local xpcall = xpcall
local table = table

-- Simple event handler
module("RSC.Event")

-- Metatable
EVENT = EVENT or {}
EVENT.__index = EVENT

function EVENT:RegisterData(data)
    self:Remove(data.id)
    table.insert(self.receivers, data)
end

function EVENT:On(func, identifier)
    if type(func) == "function" then
        self:RegisterData({
            id = identifier or func,
            func = func
        })
    end
end

function EVENT:Once(func, identifier)
    if type(func) == "function" then
        self:RegisterData({
            id = identifier or func,
            func = func,
            once = true
        })
    end
end

function EVENT:Remove(identifier)
    if identifier ~= nil then
        for i, t in pairs(self.receivers) do
            if t.id == identifier then
                self.receivers[i] = nil
            end
        end
    end
end

function EVENT:Emit(...)
    for i, t in pairs(self.receivers) do
        local func = t.func

        if type(func) == "function" then
            xpcall(func, ErrorNoHaltWithStack, ...)
        end

        if t.once then
            self.receivers[i] = nil
        end
    end
end

-- Constructor for Event class
function New()
    return setmetatable({
        receivers = {}
    }, EVENT)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801