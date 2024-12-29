--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
-- oshi.at is a free anonymous public file sharing service.
-- Licensed under DWTFYWTPL license
-- https://github.com/somenonymous/OshiUpload/blob/master/LICENSE
--
-- P.S. oshi.at used as backup service, in case if gmod_express will be updated or closed, but oshi.at often down.



local oshi = RSC.Service.New("oshi.at")

function oshi:Ping()
    local ok, res = promise.HTTP({ url = "https://oshi.at/", timeout = 5 }):SafeAwait()
    return ok and res.code == 200
end
oshi.Ping = promise.Async(oshi.Ping)

function oshi:Upload(data)
    local imageFormat = RSC.ParseQuality(quality)
    local ok, res = promise.HTTP({
        url = "https://oshi.at/?expire=60",
        method = "PUT",
        body = data,
        type = "image/" .. imageFormat,
    }):SafeAwait()

    if not ok then return promise.Reject("http error: " .. res) end
    if res.code ~= 200 then return promise.Reject("invalid response code: " .. tostring(code)) end

    local url = res.body:match("https://oshi.at/[%w]-%s%[Download%]")
    url = url and url:gsub("%s%[Download%]", "")
    if not url then return promise.Reject("failed to parse download url") end

    return url
end
oshi.Upload = promise.Async(oshi.Upload)

function oshi:Download(url)
    if not url:StartWith("https://oshi.at/") then return promise.Reject("invalid download url") end

    local ok, res = promise.HTTP({ url = url }):SafeAwait()
    if not ok then return promise.Reject("http error: " .. res) end
    if res.code ~= 200 then return promise.Reject("invalid response code: " .. tostring(code)) end

    return res.body
end
oshi.Download = promise.Async(oshi.Download)

oshi:Register()
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801