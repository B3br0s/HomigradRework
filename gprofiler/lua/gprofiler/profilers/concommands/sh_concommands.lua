GProfiler.ConCommands = GProfiler.ConCommands or {}
GProfiler.ConCommands.ProfileData = GProfiler.ConCommands.ProfileData or {}
GProfiler.ConCommands.IsDetoured = GProfiler.ConCommands.IsDetoured or false

local SysTime = SysTime
local math = math

function GProfiler.ConCommands.GetFunction(cmd, tbl)
	local commands = tbl or concommand.GetTable()
	local command = commands[cmd]

	if not command then return "Unknown", 0, 0 end

	local dbgInfo = debug.getinfo(command)
	return dbgInfo.short_src, dbgInfo.linedefined, dbgInfo.lastlinedefined
end

function GProfiler.ConCommands:DetourCommands(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) or GProfiler.ConCommands.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " commands profile started!", 2)
	GProfiler.ConCommands.OldRun = GProfiler.ConCommands.OldRun or concommand.Run
	GProfiler.ConCommands.ProfileData = {}
	GProfiler.ConCommands.IsDetoured = true

	concommand.Run = function(ply, cmd, ...)
		local start = SysTime()
		local ret = GProfiler.ConCommands.OldRun(ply, cmd, ...)
		local time = SysTime() - start

		if not GProfiler.ConCommands.ProfileData[cmd] then
			local source, lineStart, lineEnd = GProfiler.ConCommands.GetFunction(cmd)
			GProfiler.ConCommands.ProfileData[cmd] = {
				Count = 0,
				Time = 0,
				AverageTime = 0,
				LongestTime = 0,
				Source = source,
				Lines = {lineStart, lineEnd}
			}
		end

		GProfiler.ConCommands.ProfileData[cmd].Count = GProfiler.ConCommands.ProfileData[cmd].Count + 1
		GProfiler.ConCommands.ProfileData[cmd].Time = GProfiler.ConCommands.ProfileData[cmd].Time + time
		GProfiler.ConCommands.ProfileData[cmd].AverageTime = GProfiler.ConCommands.ProfileData[cmd].Time / GProfiler.ConCommands.ProfileData[cmd].Count
		GProfiler.ConCommands.ProfileData[cmd].LongestTime = math.max(GProfiler.ConCommands.ProfileData[cmd].LongestTime, time)

		return ret
	end
end

function GProfiler.ConCommands:RestoreCommands(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) or not GProfiler.ConCommands.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " commands profile stopped, sending data!", 2)
	GProfiler.ConCommands.IsDetoured = false
	concommand.Run = GProfiler.ConCommands.OldRun

	if SERVER then
		net.Start("GProfiler_ConCommands_SendData")
			net.WriteUInt(table.Count(GProfiler.ConCommands.ProfileData), 32)
			for k, v in pairs(GProfiler.ConCommands.ProfileData) do
				net.WriteString(k)
				net.WriteUInt(v.Count, 32)
				net.WriteFloat(v.Time)
				net.WriteFloat(v.AverageTime)
				net.WriteFloat(v.LongestTime)
				net.WriteString(v.Source)
				net.WriteUInt(v.Lines[1], 16)
				net.WriteUInt(v.Lines[2], 16)
			end
		net.Send(ply)
	end
end

if SERVER then
	util.AddNetworkString("GProfiler_ConCommands_ToggleServerProfile")
	util.AddNetworkString("GProfiler_ConCommands_ServerProfileStatus")
	util.AddNetworkString("GProfiler_ConCommands_CommandList")
	util.AddNetworkString("GProfiler_ConCommands_SendData")

	net.Receive("GProfiler_ConCommands_ToggleServerProfile", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		if net.ReadBool() then
			if net.ReadBool() then
				GProfiler.ConCommands.Focus = net.ReadString()
			else
				GProfiler.ConCommands.Focus = false
			end

			GProfiler.ConCommands:DetourCommands(ply)
			net.Start("GProfiler_ConCommands_ServerProfileStatus")
			net.WriteBool(true)
			net.WriteEntity(ply)
			net.Broadcast()
		else
			GProfiler.ConCommands:RestoreCommands(ply)
			net.Start("GProfiler_ConCommands_ServerProfileStatus")
			net.WriteBool(false)
			net.WriteEntity(ply)
			net.Broadcast()
		end
	end)

	net.Receive("GProfiler_ConCommands_CommandList", function(_, ply)
		local commandList = {}
		for k, v in pairs(concommand.GetTable()) do
			local source, lineStart, lineEnd = GProfiler.ConCommands.GetFunction(k, concommand.GetTable())
			commandList[k] = {Source = source, Lines = {lineStart, lineEnd}}
		end

		net.Start("GProfiler_ConCommands_CommandList")
			net.WriteUInt(table.Count(commandList), 32)
			for k, v in pairs(commandList) do
				net.WriteString(k)
				net.WriteString(v.Source)
				net.WriteUInt(v.Lines[1], 16)
				net.WriteUInt(v.Lines[2], 16)
			end
		net.Send(ply)
	end)
end