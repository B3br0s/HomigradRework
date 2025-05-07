GProfiler.Hooks = GProfiler.Hooks or {}
GProfiler.Hooks.IsDetoured = GProfiler.Hooks.IsDetoured or false
GProfiler.Hooks.ProfileData = GProfiler.Hooks.ProfileData or {}
GProfiler.Hooks.RestoreHookTable = GProfiler.Hooks.RestoreHookTable or {}

local SysTime = SysTime
local unpack = unpack
local debug = debug

function GProfiler.Hooks:DetourHooks(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) or GProfiler.Hooks.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " hook profile started!", 2)
	GProfiler.Hooks.ProfileData = {}
	GProfiler.Hooks.IsDetoured = true
	GProfiler.Hooks.AddHook = GProfiler.Hooks.AddHook or hook.Add

	local function profileHook(hookName, receiverName, receiverFunc, ...)
		if type(receiverName) != "string" or type(receiverFunc) != "function" then return end
		local dataIdent = string.format("%s_%s", hookName, receiverName)
		GProfiler.Hooks.ProfileData[dataIdent] = {
			h = hookName,
			r = receiverName,
			c = 0,
			t = 0,
			f = receiverFunc,
			extra = {...}
		}

		local Source = debug.getinfo(receiverFunc, "S")
		if Source and Source.short_src and Source.linedefined and Source.lastlinedefined then
			GProfiler.Hooks.ProfileData[dataIdent].Source = Source.short_src
			GProfiler.Hooks.ProfileData[dataIdent].Lines = { Source.linedefined, Source.lastlinedefined }
		end

		GProfiler.Hooks.AddHook(hookName, receiverName, function(...)
			local startTime = SysTime()
			local result = { receiverFunc(...) }
			local endTime = SysTime()
			local deltaTime = endTime - startTime

			GProfiler.Hooks.ProfileData[dataIdent].c = GProfiler.Hooks.ProfileData[dataIdent].c + 1
			GProfiler.Hooks.ProfileData[dataIdent].t = GProfiler.Hooks.ProfileData[dataIdent].t + deltaTime

			return unpack(result)
		end, ...)
	end

	for hookName, hookReceivers in pairs(hook.GetTable()) do
		for receiverName, receiverFunc in pairs(hookReceivers) do
			profileHook(hookName, receiverName, receiverFunc)
		end
	end

	hook.Add = function(hookName, receiverName, receiverFunc, ...)
		profileHook(hookName, receiverName, receiverFunc, ...)
	end
end

function GProfiler.Hooks:RestoreHooks(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) or not GProfiler.Hooks.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " hook profile stopped, sending data!", 2)
	GProfiler.Hooks.IsDetoured = false

	hook.Add = GProfiler.Hooks.AddHook

	for hookName, hookReceivers in pairs(hook.GetTable()) do
		for receiverName, receiverFunc in pairs(hookReceivers) do
			if type(receiverName) != "string" or type(receiverFunc) != "function" then continue end
			local data = GProfiler.Hooks.ProfileData[string.format("%s_%s", hookName, receiverName)]
			if data then
				-- 5802dd5f74bf8d5ef8c655d8e71178cd44203cbdb75e65f6b9995af1c503e5c2
				hook.Add(hookName, receiverName, data.f, unpack(data.extra or {}))
			end
		end
	end

	if SERVER then
		net.Start("GProfiler_Hooks_SendData")
		net.WriteUInt(table.Count(GProfiler.Hooks.ProfileData), 20)
		for k, v in pairs(GProfiler.Hooks.ProfileData) do
			net.WriteString(v.r)
			net.WriteString(v.h)
			net.WriteUInt(v.c, 32)
			net.WriteFloat(v.t)
			net.WriteString(v.Source or "")
			net.WriteUInt(v.Lines and v.Lines[1] or 0, 16)
			net.WriteUInt(v.Lines and v.Lines[2] or 0, 16)
		end
		net.Send(ply)
	end
end

if SERVER then
	util.AddNetworkString("GProfiler_Hooks_ToggleServerProfile")
	util.AddNetworkString("GProfiler_Hooks_ServerProfileStatus")
	util.AddNetworkString("GProfiler_Hooks_SendData")
	util.AddNetworkString("GProfiler_Hooks_HookTbl")
	util.AddNetworkString("GProfiler_Hooks_RemoveHook")

	net.Receive("GProfiler_Hooks_ToggleServerProfile", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		local startStop = net.ReadBool()
		if startStop then
			GProfiler.Hooks:DetourHooks(ply)
			net.Start("GProfiler_Hooks_ServerProfileStatus")
			net.WriteBool(true)
			net.WriteEntity(ply)
			net.Broadcast()
		else
			GProfiler.Hooks:RestoreHooks(ply)
			net.Start("GProfiler_Hooks_ServerProfileStatus")
			net.WriteBool(false)
			net.WriteEntity(ply)
			net.Broadcast()
		end
	end)

	net.Receive("GProfiler_Hooks_HookTbl", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		local hooks = hook.GetTable()
		net.Start("GProfiler_Hooks_HookTbl")
		net.WriteUInt(table.Count(hooks), 15)
		for hookName, hookReceivers in pairs(hooks) do
			net.WriteString(hookName)
			net.WriteUInt(table.Count(hookReceivers), 10)
		end
		net.Send(ply)
	end)

	net.Receive("GProfiler_Hooks_RemoveHook", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		local hookName = net.ReadString()
		local receiverName = net.ReadString()

		if not hookName or not receiverName then return end

		hook.Remove(hookName, receiverName)
	end)
end
