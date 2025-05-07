-- For timers, we must detour instantly, as there is no way to get timers created before the detour was created.

GProfiler.Timers = GProfiler.Timers or {}
GProfiler.Timers.Simple = GProfiler.Timers.Simple or {}
GProfiler.Timers.Create = GProfiler.Timers.Create or {}
GProfiler.Timers.IsDetoured = GProfiler.Timers.IsDetoured or false
GProfiler.Timers.OldSimpleTimer = GProfiler.Timers.OldSimpleTimer or timer.Simple
GProfiler.Timers.OldCreateTimer = GProfiler.Timers.OldCreateTimer or timer.Create

-- Chunked net messages to avoid net message overflow
local chunkSizeLimit = 65535 -- 187765611979610789976877

function GProfiler.Timers:Start(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) then return end

	if GProfiler.Timers.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " timer profile started!", 2)
	GProfiler.Timers.IsDetoured = true
	GProfiler.Timers.Simple = {}
	GProfiler.Timers.Create = {}
end

function GProfiler.Timers:Stop(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) then return end

	if not GProfiler.Timers.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " timer profile stopped, sending data!", 2)
	GProfiler.Timers.IsDetoured = false

	if SERVER then
		local ProfileData = table.Merge(GProfiler.Timers.Simple, GProfiler.Timers.Create)
		local chunkCount = 1
		local currentChunkSize = 0
		local chunks = {}
		for k, v in pairs(ProfileData) do
			local chunkSize = 146 + string.len(v.Type) + string.len(tostring(k)) + string.len(v.Source)
			if currentChunkSize + chunkSize > chunkSizeLimit then
				chunkCount = chunkCount + 1
				currentChunkSize = 0
			end

			if not chunks[chunkCount] then chunks[chunkCount] = {} end
			currentChunkSize = currentChunkSize + chunkSize
			table.insert(chunks[chunkCount], {k, v})
		end

		for k, v in ipairs(chunks) do
			net.Start("GProfiler_Timers_SendData")
				net.WriteBool(k == 1)
				net.WriteBool(k == table.Count(chunks))
				net.WriteUInt(table.Count(v), 32)
				for _, data in ipairs(v) do
					net.WriteString(data[2].Type)
					net.WriteString(tostring(data[1]))
					net.WriteUInt(data[2].Count, 32)
					net.WriteFloat(data[2].Delay)
					net.WriteFloat(data[2].TotalTime)
					net.WriteFloat(data[2].LongestTime)
					net.WriteFloat(data[2].AverageTime)
					net.WriteString(data[2].Source)
					net.WriteUInt(data[2].Lines[1], 16)
					net.WriteUInt(data[2].Lines[2], 16)
				end
			net.Send(ply)
		end

		if table.Count(chunks) == 0 then
			net.Start("GProfiler_Timers_SendData")
				net.WriteBool(true)
				net.WriteBool(true)
				net.WriteUInt(0, 32)
			net.Send(ply)
		end
	end
end

function GProfiler.Timers.CollectTimerData(type, name, delay, func, funcTime)
	if not GProfiler.Timers.IsDetoured then return end

	if not GProfiler.Timers[type][name] then
		local dbgInfo = debug.getinfo(func)
		GProfiler.Timers[type][name] = {
			Count = 0,
			TotalTime = 0,
			LongestTime = 0,
			AverageTime = 0,
			Func = func,
			Delay = delay,
			Source = dbgInfo.short_src,
			Lines = {dbgInfo.linedefined, dbgInfo.lastlinedefined},
			Type = type
		}
	end

	GProfiler.Timers[type][name].Count = GProfiler.Timers[type][name].Count + 1
	GProfiler.Timers[type][name].TotalTime = GProfiler.Timers[type][name].TotalTime + funcTime
	GProfiler.Timers[type][name].AverageTime = GProfiler.Timers[type][name].TotalTime / GProfiler.Timers[type][name].Count
	GProfiler.Timers[type][name].LongestTime = math.max(GProfiler.Timers[type][name].LongestTime, funcTime)
end

timer.Simple = function(delay, func, ...)
	local args = {...}
	GProfiler.Timers.OldSimpleTimer(delay, function()
		local start = SysTime()
		func(unpack(args))
		local endtime = SysTime() - start
		GProfiler.Timers.CollectTimerData("Simple", func, delay, func, endtime)
	end)
end

timer.Create = function(name, delay, reps, func, ...)
	assert(name, "timer.Create - bad argument #1 (string expected, got no value)")
	assert(delay, "timer.Create - bad argument #2 (number expected, got no value)")
	assert(reps, "timer.Create - bad argument #3 (number expected, got no value)")
	assert(func, "timer.Create - bad argument #4 (function expected, got no value)")

	name = tostring(name)

	local args = {...}
	GProfiler.Timers.OldCreateTimer(name, delay, reps, function()
		local start = SysTime()
		func(unpack(args))
		local endtime = SysTime() - start
		GProfiler.Timers.CollectTimerData("Create", name, delay, func, endtime)
	end)
end
if SERVER then
	util.AddNetworkString("GProfiler_Timers_ToggleServerProfile")
	util.AddNetworkString("GProfiler_Timers_ServerProfileStatus")
	util.AddNetworkString("GProfiler_Timers_SendData")

	net.Receive("GProfiler_Timers_ToggleServerProfile", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		local startStop = net.ReadBool()
		if startStop then
			GProfiler.Timers:Start(ply)
			net.Start("GProfiler_Timers_ServerProfileStatus")
			net.WriteBool(true)
			net.WriteEntity(ply)
			net.Broadcast()
		else
			GProfiler.Timers:Stop(ply)
			net.Start("GProfiler_Timers_ServerProfileStatus")
			net.WriteBool(false)
			net.WriteEntity(ply)
			net.Broadcast()
		end
	end)
end