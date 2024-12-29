--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
local ScreenFraction = 1
do
    local round, max = math.Round, math.max
    function RSC.ScreenScale(size)
        local f = max(1, ScreenFraction * RSC.ScrH) -- Do not downscale UI
        return size and round(f * size) or f
    end
end

function RSC.GenerateFonts()
    surface.CreateFont("RSC 16", {
        font = "Roboto",
        extended = true,
        size = RSC.ScreenScale(16)
    })

    surface.CreateFont("RSC 16 Bold", {
        font = "Roboto",
        extended = true,
        size = RSC.ScreenScale(16),
        weight = 700
    })

    surface.CreateFont("RSC 18", {
        font = "Roboto",
        extended = true,
        size = RSC.ScreenScale(18)
    })

    surface.CreateFont("RSC 18 Bold", {
        font = "Roboto",
        extended = true,
        size = RSC.ScreenScale(18),
        weight = 700
    })

    surface.CreateFont("RSC 24", {
        font = "Roboto",
        extended = true,
        size = RSC.ScreenScale(24),
    })

    surface.CreateFont("RSC 48", {
        font = "Roboto",
        extended = true,
        size = RSC.ScreenScale(48),
    })
end

function RSC.OnScreenSizeChanged()
    RSC.ScrW = ScrW()
    RSC.ScrH = ScrH()
    ScreenFraction = 1 / 1080
    RSC.GenerateFonts()
end

hook.Add("OnScreenSizeChanged", "RSC", RSC.OnScreenSizeChanged)
RSC.OnScreenSizeChanged()

local MaterialCache = {}
function RSC.URLMaterial(url, params)
    if MaterialCache[url] then
        return MaterialCache[url]
    end

    local filename = util.CRC(url) .. "." .. (url:GetExtensionFromFilename() or "dat")
    local path = "cache/images/" .. filename
    if not file.Exists("cache/images", "DATA") then file.CreateDir("cache/images") end
    if file.Exists(path, "DATA") then
        local mat = Material("data/" .. path, params)
        return mat
    end

    local mat = CreateMaterial(filename, "UnlitGeneric", {
        ["$basetexture"] = "___error",
        ["$alpha"] = 0,
    })

    local function failed(err)
        mat:SetInt("$alpha", 1)
        MaterialCache[url] = nil
    end

    local function success(body, _, _, code)
        if code ~= 200 then
            failed("invalid status code")
            return
        end

        file.Write(path, body)
        local try = Material("data/" .. path, params)

        for k, v in pairs(try:GetKeyValues()) do
            local vtype = type(v)

            if (vtype == "ITexture") then
                mat:SetTexture(k, v)
            elseif (vtype == "VMatrix") then
                mat:SetMatrix(k, v)
            elseif (vtype == "Vector") then
                mat:SetVector(k, v)
            elseif (vtype == "number") then
                if (math.floor(v) == v) then
                    mat:SetInt(k, v)
                else
                    mat:SetFloat(k, v)
                end
            end
        end

        MaterialCache[url] = nil
    end

    http.Fetch(url, success, failed)

    MaterialCache[url] = mat
    return mat
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801