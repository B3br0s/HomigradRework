--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
--[[
    MIT License

    Copyright (c) 2023 Retro

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

--[[
    GLua library for Crowdin Over-The-Air Content Delivery
    https://github.com/dankmolot/gm_crowdin_ota

    Documentation can be found at: https://github.com/dankmolot/gm_crowdin_ota
]]

require("promise")
assert(promise, "failed to include promise library (https://github.com/dankmolot/gm_promise)" .. (CLIENT and " [have you forgot to AddCSLuaFile it?]" or ""))

local promise = promise
local isstring = isstring
local istable = istable
local setmetatable = setmetatable
local util = util
local assert = assert
local ipairs = ipairs
local table = table
local cvars = cvars
local emptyFunc = function() end

module( "crowdin_ota" )

_VERSION = "1.0.0" -- major.minor.patch
_VERSION_NUM = 010000 -- _VERSION in number format: 1.2.3 -> 010203 | 99.56.13 -> 995613

-- Helper functions
function HTTPRequest(url)
    return promise.HTTP({ url = url })
        :Then(function(res)
            if res.code == 200 then
                if res.headers["Content-Type"] == "application/json" then
                    return util.JSONToTable(res.body)
                end

                return res.body
            end

            return promise.Reject("bad http response code " .. res.code)
        end)
end

-- Ota client metatable
OTA_CLIENT = OTA_CLIENT or {}
OTA_CLIENT.__index = OTA_CLIENT

OTA_CLIENT.BASE_URL = "https://distributions.crowdin.net"

function OTA_CLIENT:GetCurrentLocale()
    return self.locale
end

function OTA_CLIENT:SetCurrentLocale(locale)
    self.locale = locale
end

function OTA_CLIENT:GetHash()
    return self.hash
end

function OTA_CLIENT:GetManifest()
    if self.manifestCache and not self.disableManifestCache then
        return self.manifestCache
    else
        self.manifestCache = HTTPRequest(self.BASE_URL .. "/" .. self.hash .. "/manifest.json")
        return self.manifestCache
    end
end

function OTA_CLIENT:GetManifestTimestamp()
    return self:GetManifest():Then(function(manifest) return manifest.timestamp end)
end

function OTA_CLIENT:ListFiles()
    return self:GetManifest():Then(function(manifest) return manifest.files end)
end

function OTA_CLIENT:ListLanguages()
    return self:GetManifest():Then(function(manifest) return manifest.languages end)
end

function OTA_CLIENT:GetLanguageMappings()
    return self:GetManifest():Then(function(manifest) return manifest.language_mapping or {} end)
end

function OTA_CLIENT:GetCustomLanguages()
    return self:GetManifest():Then(function(manifest) return manifest.custom_languages or {} end)
end

function OTA_CLIENT:GetLanguages()
    return promise.Resolve({}) -- Not implemented
end

function OTA_CLIENT:ClearStringsCache()
    table.Empty( self.stringsCache )
end

function OTA_CLIENT:GetJSONFiles(file)
    return self:ListFiles():Then(function(files)
        local jsonFiles = {}
        for _, f in ipairs(files) do
            if (not file or file == f) and f:lower():EndsWith(".json") then
                table.insert(jsonFiles, f)
            end
        end

        return jsonFiles
    end)
end

function OTA_CLIENT:GetLanguageCode(lang)
    return lang or self.locale
end

function OTA_CLIENT:GetFileTranslations(file, lang)
    local url = self.BASE_URL .. "/" .. self.hash .. "/content"
    local lang = self:GetLanguageCode(lang)
    -- local languageMappings = self:GetLanguageMappings():Await()[lang]
    -- local customLanguages = self:GetCustomLanguages():Await()[lang]
    -- local apiLanguages = self:GetLanguages():Await()

    -- ToDo implement language placeholders
    url = url .. "/" .. lang .. file
    url = url .. "?timestamp=" .. self:GetManifestTimestamp():Await()

    return HTTPRequest(url):Catch(emptyFunc)
end
OTA_CLIENT.GetFileTranslations = promise.Async(OTA_CLIENT.GetFileTranslations)

function OTA_CLIENT:GetLanguageTranslations(lang)
    local lang = self:GetLanguageCode(lang)
    local files = self:ListFiles():Await()

    local results = {}
    for _, file in ipairs(files) do
        results[#results + 1] = self:GetFileTranslations(file, lang)
            :Then(function(content)
                return { file = file, content = content }
            end)
    end

    return promise.All(results)
end
OTA_CLIENT.GetLanguageTranslations = promise.Async(OTA_CLIENT.GetLanguageTranslations)

function OTA_CLIENT:GetTranslations()
    local languages = self:ListLanguages():Await()
    local promises = {}
    local translations = {}
    for _, lang in ipairs(languages) do
        promises[#promises + 1] = self:GetLanguageTranslations(lang)
            :Then(function(data)
                translations[lang] = data
            end)
    end
    promise.All(promises):Await()
    return translations
end
OTA_CLIENT.GetTranslations = promise.Async(OTA_CLIENT.GetTranslations)

function OTA_CLIENT:GetStringsByFilesAndLocale(files, lang)
    local strings = {}
    for _, filePath in ipairs(files) do
        local content
        local fileCache = self.stringsCache[filePath] and promise.Await(self.stringsCache[filePath][lang])
        if fileCache then
            content = fileCache
        else
            if not self.disableStringsCache then
                self.stringsCache[filePath] = self.stringsCache[filePath] or {}
                self.stringsCache[filePath][lang] = self:GetFileTranslations(filePath, lang)
            end

            content = promise.Await( self.stringsCache[filePath][lang] )
        end

        if self.disableJsonDeepMerge then
            for k, v in pairs(content or {}) do
                strings[k] = v
            end
        else
            table.Merge(strings, content or {})
        end
    end

    return strings
end
OTA_CLIENT.GetStringsByFilesAndLocale = promise.Async(OTA_CLIENT.GetStringsByFilesAndLocale)

function OTA_CLIENT:GetStringsByLocale(file, lang)
    local lang = self:GetLanguageCode(lang)
    local files = self:GetJSONFiles(file):Await()
    return self:GetStringsByFilesAndLocale(files, lang)
end
OTA_CLIENT.GetStringsByLocale = promise.Async(OTA_CLIENT.GetStringsByLocale)

function OTA_CLIENT:GetStringByKey(key, file, lang)
    local strings = self:GetStringsByLocale(file, lang):Await()
    local path = istable(key) and key or { key }
    local firstKey = table.remove(path, 1)
    if not firstKey then return end

    local res = strings[firstKey]
    for _, keyPart in ipairs(path) do
        res = res and res[keyPart]
    end
    return res
end
OTA_CLIENT.GetStringByKey = promise.Async(OTA_CLIENT.GetStringByKey)

function OTA_CLIENT:GetStrings(file)
    local files = self:GetJSONFiles(file):Await()
    local languages = self:ListLanguages():Await()
    local res = {}
    local promises = {}
    for _, lang in ipairs(languages) do
        promises[#promises+1] = self:GetStringsByFilesAndLocale(files, lang):Then(function(strings)
            res[lang] = strings
        end)
    end
    promise.All(promises):Await()
    return res
end
OTA_CLIENT.GetStrings = promise.Async(OTA_CLIENT.GetStrings)


-- Returns a new ota client
function New(hash, params)
    assert(isstring(hash), "invalid hash given to crowdin_ota.New(hash) function")

    local client = setmetatable({}, OTA_CLIENT)
    client.hash = hash
    client.locale = cvars.String("gmod_language") or "en"
    client.stringsCache = {}

    if istable(params) then
        if params.disableManifestCache then client.disableManifestCache = true end
        if params.disableStringsCache then client.disableStringsCache = true end
        if params.disableLanguagesCache then client.disableLanguagesCache = true end
        if params.disableJsonDeepMerge then client.disableJsonDeepMerge = true end
        if params.languageCode then client.locale = params.languageCode end
    end

    return client
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801