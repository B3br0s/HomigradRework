--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
local DEFAULT_LANGUAGE = {
    ["rsc.errors.invalid_victim"] = "Invalid victim",
    ["rsc.errors.no_rights"] = "You don't have enough rights",
    ["rsc.errors.capture_faked"] = "Failed to get actual screen capture (capture has been faked)",
    ["rsc.errors.error_happened"] = "An error happened :(",
    ["rsc.errors.timeout"] = "Request timed out (victim didn't respond)",
    ["rsc.errors.player_disconnected"] = "Player disconnected",
    ["rsc.errors.upload_failed"] = "Upload failed (%s)",
    ["rsc.errors.download_failed"] = "Download failed (%s)",
    ["rsc.errors.not_implemented"] = "not implemented",
    ["rsc.errors.capture_is_running"] = "Capture is already running...",
    ["rsc.errors.invalid_service"] = "Invalid service specified",

    ["rsc.notify.copying_screen"] = "Capturing screen...",
    ["rsc.notify.screen_to_image"] = "Getting a screen image...",
    ["rsc.notify.checking_image"] = "Checking the image for faking...",
    ["rsc.notify.uploading"] = "Uploading the image...",
    ["rsc.notify.sending_capture_data"] = "Got capture data. Sending it to you...",
    ["rsc.notify.downloading"] = "Downloading the image...",
    ["rsc.notify.receiver_added"] = "Player '%s' has been added as receiver",
    ["rsc.notify.upload_success"] = "Image successfully uploaded. Sending image url to the server...",

    ["rsc.ui.in_progress"] = "In progress...",
    ["rsc.ui.open_gallery"] = "Open gallery",
    ["rsc.ui.screengrab"] = "Screengrab",
    ["rsc.ui.options"] = "OPTIONS",
    ["rsc.ui.transfer_service"] = "Transfer service",
    ["rsc.ui.checking_status"] = "Checking status...",
    ["rsc.ui.online"] = "Online",
    ["rsc.ui.offline"] = "Offline",
    ["rsc.ui.more_later"] = "More later...",
    ["rsc.ui.image_quality"] = "Image quality",
    ["rsc.ui.quality_best"] = "Best",
    ["rsc.ui.quality_good"] = "Good",
    ["rsc.ui.quality_low"] = "Low",
    ["rsc.ui.other"] = "Other",
    ["rsc.ui.save_screengrabs"] = "Save screengrabs",
    ["rsc.ui.image_check"] = "If you don't see this text, then image has been faked.",
    ["rsc.ui.search_placeholder"] = "name / steamid / usergroup",

    ["rsc.discord.new_screengrab"] = "Received new screengrab",
    ["rsc.discord.screengrabbed_by"] = "From player '%s'",
}

-- DO NOT TOUCH CODE BELOW
RSC.CurrentLang = RSC.CurrentLang or "en"
RSC.Phrases = RSC.Phrases or {}
RSC.PhraseStore = RSC.PhraseStore or {}
RSC.PhraseStore["en"] = DEFAULT_LANGUAGE

if SERVER then
    require("crowdin_ota")
    RSC.CrowdinOTAClient = RSC.CrowdinOTAClient or crowdin_ota.New(RSC.Config.CrowdinOTAHash)

    function RSC.IsLanguageSupported(languageCode)
        if languageCode == "en" then return true end
        local ok, languages = RSC.CrowdinOTAClient:ListLanguages():SafeAwait()
        if ok then
            for _, lang in ipairs(languages) do
                if languageCode == lang then return true end
            end
        end
        return false
    end
    RSC.IsLanguageSupported = promise.Async(RSC.IsLanguageSupported)

    function RSC.PreloadPhrases(lang)
        if RSC.PhraseStore[lang] then return RSC.PhraseStore[lang] end
        if not RSC.IsLanguageSupported(lang):Await() then return end

        local ok, strings = RSC.CrowdinOTAClient:GetStringsByLocale(nil, lang):SafeAwait()
        if not ok then return end

        RSC.PhraseStore[lang] = strings
        return strings
    end
    RSC.PreloadPhrases = promise.Async(RSC.PreloadPhrases)
end

function RSC.GetPhrase(phrase, lang) -- Just copies language.GetPhrase for server and clients
    if phrase:StartWith("#") then phrase = phrase:sub(2) end
    return lang and RSC.PhraseStore[lang] and RSC.PhraseStore[lang][phrase] or RSC.Phrases[phrase]
end

local function RegisterLanguage(lang)
    for placeholder, fulltext in pairs(lang or {}) do
        if CLIENT then language.Add(placeholder, fulltext) end
        RSC.Phrases[placeholder] = fulltext
    end
end

function RSC.UpdateCurrentLanguage()
    RSC.CurrentLang = SERVER and RSC.Config.DefaultLanguage or cvars.String("gmod_language") or "en"

    -- Forcing language if specified
    if RSC.Config.ForceLanguage then
        RSC.CurrentLang = RSC.Config.DefaultLanguage
    end

    if CLIENT then
        if not RSC.PhraseStore[RSC.CurrentLang] and RSC.NetworkReady then
            -- Request language translations from the server
            net.Start("RSC.NetworkV2")
                net.WriteUInt( RSC.NET_OP_REQUEST_TRANSLATION, 4 )
                net.WriteString( RSC.CurrentLang )
            net.SendToServer()
        else
            RegisterLanguage( RSC.PhraseStore[RSC.CurrentLang] )
        end
    else
        RSC.PreloadPhrases(RSC.CurrentLang):Then(RegisterLanguage)
    end
end

cvars.AddChangeCallback("gmod_language", RSC.UpdateCurrentLanguage, "RSC.OnLanguageChange")
hook.Add("RSC.OnConfigUpdated", "RSC.OnLanguageChange", RSC.UpdateCurrentLanguage)

RegisterLanguage(RSC.PhraseStore["en"])
RSC.UpdateCurrentLanguage()
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801