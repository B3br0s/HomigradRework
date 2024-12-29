--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
-- You can optionally configure Retro's Screengrabber
RSC.Config = {}
local Config = RSC.Config

--[[----------------------------------
    Advanced settings
----------------------------------]]--
Config.DefaultLanguage = "en" -- Set to "en", "fr", "es", "tr", "pl", "cz", "ua", "ru"
Config.ForceLanguage = false -- If set to true, then every admin will have the same language as server language. Disables automatic language detection

Config.CaptureTimeout = 30 -- How many seconds server should wait before ending capture process with timeout error

-- Customization of admin menu
-- Available fields: name, steamid, steamid64, steamname, usergroup
Config.PlayerTopField = "name"
Config.PlayerBottomField = "steamid"

-- Custom rank system
-- If set to true, then permission settings from admin mods will be ignored
Config.UseCustomRanks = false
Config.CustomRanks = {
    ["superadmin"] = true, -- Superadmins have access to RSC
    ["admin"] = false, -- Admins don't
    -- every other rank that isn't defined won't have access
}

-- Crowdin OTA identifier. Only change if you know what are you doing!
Config.CrowdinOTAHash = "67242505567f938f5b343d9bydn"

--[[----------------------------------
    Integration with "Trixter's Discord Integration"
    If enabled, then RSC will also send all screengrabs to specified channel
    
    Warning: All images will be uploaded to imgur.com (and this service permanently saves screengrabs)

    Note: This integration isn't tested. If it isn't working, make a ticket
----------------------------------]]--
Config.DiscordIntegration = true -- Change to true to enable discord integration
Config.DiscordChannel = "Admin" -- A Channel where screengrabs will be sent to ( "Admin" or "Relay" )
Config.DiscordCommand = "screengrab" -- Command to trigger capture of the player *REQUIRES SERVER RESTART*

Config.ImgurClientID = "aca6d2502f5bfd8" -- You can configure your own client id if you want
                                         -- https://api.imgur.com/oauth2/addclient

-- DO NOT TOUCH CODE BELOW
hook.Run("RSC.OnConfigUpdated")

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801