GProfiler.Net = GProfiler.Net or {}
GProfiler.Net.IsDetoured = GProfiler.Net.IsDetoured or false
GProfiler.Net.ProfileData = GProfiler.Net.ProfileData or {}

local netReadHeader = net.ReadHeader
local util = util

function GProfiler.Net:DetourNet(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) or GProfiler.Net.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " net profile started!", 2)
	GProfiler.Net.ProfileData = {}
	GProfiler.Net.IsDetoured = true

	GProfiler.Net.OriginalIncoming = GProfiler.Net.OriginalIncoming or net.Incoming

	function net.Incoming(len, client)
		local i = netReadHeader()
		local strName = util.NetworkIDToString(i)

		if not strName then return end

		if not GProfiler.Net.ProfileData[strName] then
			GProfiler.Net.ProfileData[strName] = {0, 0, 0}
		end

		len = len - 16

		GProfiler.Net.ProfileData[strName][1] = GProfiler.Net.ProfileData[strName][1] + 1
		GProfiler.Net.ProfileData[strName][2] = math.max(GProfiler.Net.ProfileData[strName][2], len)
		GProfiler.Net.ProfileData[strName][3] = GProfiler.Net.ProfileData[strName][3] + len

		local func = net.Receivers[strName:lower()]
		if not func then return end

		if not GProfiler.Net.ProfileData[strName][4] then
			local Source = debug.getinfo(func, "S")
			if Source then
				GProfiler.Net.ProfileData[strName][4] = Source.short_src
				GProfiler.Net.ProfileData[strName][5] = Source.linedefined
				GProfiler.Net.ProfileData[strName][6] = Source.lastlinedefined
			end
		end

		func(len, client)
	end
end

function GProfiler.Net:RestoreNet(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) or not GProfiler.Net.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " net profile stopped, sending data!", 2)
	GProfiler.Net.IsDetoured = false

	net.Incoming = GProfiler.Net.OriginalIncoming

	if SERVER then
		net.Start("GProfiler_Net_SendData")
		net.WriteUInt(table.Count(GProfiler.Net.ProfileData), 32)
		for name, data in pairs(GProfiler.Net.ProfileData) do
			net.WriteString(name)
			net.WriteUInt(data[1], 32)
			net.WriteUInt(data[2], 32)
			net.WriteUInt(data[3], 32)
			net.WriteString(data[4] or "")
			net.WriteUInt(data[5] or 0, 16)
			net.WriteUInt(data[6] or 0, 16)
		end
		net.Send(ply)
	end
end

if SERVER then
	util.AddNetworkString("GProfiler_Net_ToggleServerProfile")
	util.AddNetworkString("GProfiler_Net_ServerProfileStatus")
	util.AddNetworkString("GProfiler_Net_SendData")
	util.AddNetworkString("GProfiler_Net_ReceiverTbl")

	net.Receive("GProfiler_Net_ToggleServerProfile", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		local startStop = net.ReadBool()
		if startStop then
			GProfiler.Net:DetourNet(ply)
			net.Start("GProfiler_Net_ServerProfileStatus")
			net.WriteBool(true)
			net.WriteEntity(ply)
			net.Broadcast()
		else
			GProfiler.Net:RestoreNet(ply)
			net.Start("GProfiler_Net_ServerProfileStatus")
			net.WriteBool(false)
			net.WriteEntity(ply)
			net.Broadcast()
		end
	end)

	net.Receive("GProfiler_Net_ReceiverTbl", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		net.Start("GProfiler_Net_ReceiverTbl")
		net.WriteUInt(table.Count(net.Receivers), 32)
		for name, func in pairs(net.Receivers) do
			local Source = debug.getinfo(func, "S") or {}
			net.WriteString(name)
			net.WriteString(string.format("%s (%s)", tostring(func), GProfiler.GetFunctionLocation(func)))
			net.WriteString(Source.short_src or "")
			net.WriteUInt(Source.linedefined or 0, 16)
			net.WriteUInt(Source.lastlinedefined or 0, 16)
		end
		net.Send(ply)
	end)
end
