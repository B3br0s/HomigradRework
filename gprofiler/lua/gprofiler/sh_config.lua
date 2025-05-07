-- 1.2.1 | b7bd8a44-2f52-4e9c-8103-f70e186d3b7f | 7309eb3b8b4f5c0a14d53672e97203e6 | 76561197961078997

GProfiler.Version = "1.2.1"
GProfiler.Config.VersionCheck = true -- Should we check for updates on gmodstore?

-- Available languages: english, french, german, dutch, russian
GProfiler.Config.Language = "english"

-- Enable/Disable Log Types
GProfiler.Config.LOG_DEBUG = true
GProfiler.Config.LOG_INFO = true
GProfiler.Config.LOG_WARNING = true
GProfiler.Config.LOG_ERROR = true
GProfiler.Config.LOG_LOAD = false

GProfiler.Config.AllowedSteamIDs = { -- SteamIDs that can access GProfiler
	["76561197961078997"] = true
}

if CLIENT then
	GProfiler.MenuColors = {
		White = Color(255, 255, 255),
		Blue = Color(91, 118, 255),

		-- Menu
		Background = Color(8, 27, 48, 220),
		OpaqueBlack = Color(0, 0, 0, 200),
		TopBarSeparator = Color(91, 118, 255, 10),
		HeaderSeparator = Color(91, 118, 255, 50),
		RealmSelectorBackground = Color(38, 57, 78),
		RealmSelectorOutline = Color(88, 107, 138),
		ActiveProfile = Color(10, 155, 10),

		-- Lists
		DListBackground = Color(18, 37, 58),
		DListColumnBackground = Color(68, 87, 108),
		DListColumnOutline = Color(88, 107, 138),
		DListRowBackground = Color(48, 67, 88),
		DListRowHover = Color(68, 87, 108),
		DListRowTextColor = Color(235, 235, 235),
		DListRowSelected = Color(91, 118, 255, 50),

		-- Scrollbars
		ScrollBar = Color(38, 57, 78),
		ScrollBarGrip = Color(68, 87, 108),
		ScrollBarGripOutline = Color(88, 107, 138),

		-- Buttons
		ButtonOutline = Color(88, 107, 138),
		ButtonBackground = Color(38, 57, 78),
		ButtonHover = Color(58, 77, 98),
	}

	GProfiler.Config.MenuCommands = {
		Chat = '!gprofiler', -- False to disable
		Console = 'gprofiler', -- False to disable
		Closekey = KEY_F4 -- False to disable
	}
else
	local URL = "https://fastdl.zarpgaming.com/callum/gprofiler/version.txt"
	if GProfiler.Config.VersionCheck then
		hook.Add("PlayerInitialSpawn", "GProfiler_VersionCheck", function()
			http.Fetch(URL, function(body, _, __, code)
				if code == 200 and body != GProfiler.Version then
					GProfiler.Log(string.format("You are running an outdated version of GProfiler! (Current: %s, Latest: %s)", GProfiler.Version, body), 3)
				end
			end)
			hook.Remove("PlayerInitialSpawn", "GProfiler_VersionCheck")
		end)
	end
end
