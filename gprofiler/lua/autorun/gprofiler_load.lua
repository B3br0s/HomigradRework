GProfiler = GProfiler or { Config = {}, Access = {} }

local logLevels = {
	[1] = {"DEBUG", Color(0, 255, 0)},
	[2] = {"INFO", Color(0, 0, 255)},
	[3] = {"WARNING", Color(255, 255, 0)},
	[4] = {"ERROR", Color(255, 0, 0)},
	[5] = {"LOAD", Color(255, 0, 255)}
}

local color_white = Color(255, 255, 255)

function GProfiler.Log(str, lvl)
	lvl = logLevels[lvl or 1] and lvl or 1

	if not GProfiler.Config[string.format("LOG_%s", logLevels[lvl][1])] then return end

	MsgC(logLevels[lvl][2], string.format("[GProfiler][%s] ", logLevels[lvl][1]), color_white, str, "\n")
end

local incFuncs = {
	sv = SERVER and include or function() end,
	cl = SERVER and AddCSLuaFile or include,
	sh = function(f) include(f) AddCSLuaFile(f) end
}

local function incFile(f)
	(incFuncs[string.GetFileFromFilename(f):sub(1,2)] or incFuncs.sh)(f)
	GProfiler.Log(string.format("Loading file %s", f), 5)
end

local function incFolder(folder)
	GProfiler.Log(string.format("Loading folder %s", folder), 5)

	local files, folders = file.Find(folder.."/*", "LUA")
	for _, f in pairs(files) do incFile(string.format("%s/%s", folder, f)) end
	for _, f in pairs(folders) do incFolder(folder.."/"..f) end
end

incFile("gprofiler/sh_config.lua")
incFile("gprofiler/sh_utils.lua")
incFile("gprofiler/cl_language.lua")
incFile("gprofiler/cl_menu.lua")
incFile("gprofiler/sh_access.lua")
incFolder("gprofiler/profilers")

-- 76561197961078988
