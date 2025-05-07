GProfiler.Functions = GProfiler.Functions or {}
GProfiler.Functions.IsDetoured = GProfiler.Functions.IsDetoured or false
GProfiler.Functions.ProfileData = GProfiler.Functions.ProfileData or {}
GProfiler.Functions.Focus = GProfiler.Functions.Focus or false

local SysTime = SysTime

-- Chunked net messages to avoid net message overflow
local chunkSizeLimit = 90000 -- 187765611979610789976877

local recurse = {}
local startTimes = {}
local IgnoreCache = {}

local function handleFunction(event)
	local time = SysTime()
	local func = event.func

	if IgnoreCache[func] or string.find(event.short_src, "/lua/gprofiler/", 1, true) then IgnoreCache[func] = true return end

	if not recurse[func] then recurse[func] = 0 end
	recurse[func] = recurse[func] + 1

	startTimes[func] = time
end

local function handleReturn(event)
	local time = SysTime()
	local func = event.func

	if not startTimes[func] then return end

	local runTime = time - startTimes[func]

	if GProfiler.Functions.Focus and GProfiler.Functions.Focus != tostring(func) then return end

	if not GProfiler.Functions.ProfileData[func] then
		GProfiler.Functions.ProfileData[func] = {
			name = event.name,
			source = event.short_src,
			lines = event.linedefined .. " - " .. event.lastlinedefined,
			calls = 0,
			time = 0,
			average = 0,
			focus = tostring(func)
		}
	end

	GProfiler.Functions.ProfileData[func].time = GProfiler.Functions.ProfileData[func].time + runTime
	GProfiler.Functions.ProfileData[func].calls = GProfiler.Functions.ProfileData[func].calls + 1
	GProfiler.Functions.ProfileData[func].average = GProfiler.Functions.ProfileData[func].time / GProfiler.Functions.ProfileData[func].calls

	recurse[func] = recurse[func] - 1
	if recurse[func] == 0 then recurse[func] = nil end
end

local function onEvent(event)
	local info = debug.getinfo(3)
	if not info then return end
	local func = info.func

	if event == "call" or event == "tail call" then
		handleFunction(info)
	else
		if not recurse[func] or recurse[func] == 0 then return end
		handleReturn(info)
	end
end

function GProfiler.Functions:DetourFunctions(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) or GProfiler.Functions.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " function profile started!", 2)
	GProfiler.Functions.ProfileData = {}
	GProfiler.Functions.IsDetoured = true

	recurse = {}
	startTimes = {}

	debug.sethook(function(event) onEvent(event) end, "cr")
end

function GProfiler.Functions:RestoreFunctions(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) or not GProfiler.Functions.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " function profile stopped, sending data!", 2)
	GProfiler.Functions.IsDetoured = false

	debug.sethook()

	if SERVER then
		local chunks = {}
		local chunkCount = 1
		local currentChunkSize = 0
		for k, v in pairs(GProfiler.Functions.ProfileData) do
			local curChunkSize = 68 + (v.name and string.len(v.name) or 7) + string.len(v.source) + string.len(v.lines) + string.len(v.focus)
			local chunkSize = currentChunkSize + curChunkSize
			if chunkSize > chunkSizeLimit then
				chunkCount = chunkCount + 1
				currentChunkSize = 0
				chunkSize = 0
			end

			if not chunks[chunkCount] then chunks[chunkCount] = {} end
			table.insert(chunks[chunkCount], v)
			currentChunkSize = chunkSize
		end

		local i = 1
		local function sendChunk()
			if not chunks[i] then return end
			net.Start("GProfiler_Functions_SendData", true)
			net.WriteBool(i == 1)
			net.WriteBool(i == table.Count(chunks))
			net.WriteUInt(table.Count(chunks[i]), 32)
			for k, v1 in pairs(chunks[i]) do
				net.WriteString(v1.name or "Unknown")
				net.WriteString(v1.source)
				net.WriteString(v1.lines)
				net.WriteUInt(v1.calls, 32)
				net.WriteFloat(v1.time)
				net.WriteFloat(v1.average)
				net.WriteString(v1.focus)
			end
			net.Send(ply)

			i = i + 1
			timer.Simple(.2, sendChunk)
		end
		sendChunk()
	end
end

if SERVER then
	util.AddNetworkString("GProfiler_Functions_ToggleServerProfile")
	util.AddNetworkString("GProfiler_Functions_ServerProfileStatus")
	util.AddNetworkString("GProfiler_Functions_SendData")

	net.Receive("GProfiler_Functions_ToggleServerProfile", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		local startStop = net.ReadBool()
		if startStop then
			local hasFocus = net.ReadBool()
			if hasFocus then
				GProfiler.Functions.Focus = net.ReadString()
			else
				GProfiler.Functions.Focus = false
			end

			GProfiler.Functions:DetourFunctions(ply)
			net.Start("GProfiler_Functions_ServerProfileStatus")
			net.WriteBool(true)
			net.WriteEntity(ply)
			net.Broadcast()
		else
			GProfiler.Functions:RestoreFunctions(ply)
			net.Start("GProfiler_Functions_ServerProfileStatus")
			net.WriteBool(false)
			net.WriteEntity(ply)
			net.Broadcast()
		end
	end)
end
