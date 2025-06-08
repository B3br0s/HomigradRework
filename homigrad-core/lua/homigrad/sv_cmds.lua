COMMANDS = COMMANDS or {}
function COMMAND_FAKEPLYCREATE()
	local fakePly = {}

	function fakePly:IsValid() return true end
	function fakePly:IsAdmin() return true end
	function fakePly:GetUserGroup() return "superadmin" end
	function fakePly:Name() return "Server" end

	fakePly.fakePly = true

	return fakePly
end

local plyServer = COMMAND_FAKEPLYCREATE()

local speak = {}

if not HPrintMessage then HPrintMessage = PrintMessage end

function PrintMessage(type,text)
	HPrintMessage(type,text)

	print("\t" .. text)
end

local validUserGroupSuperAdmin = {
	superadmin = true,
	admin = true
}

local validUserGroup = {
	operator = true
}

function COMMAND_GETASSES(ply)
	local group = ply:GetUserGroup()
	if validUserGroup[group] then
		return 1
	elseif validUserGroupSuperAdmin[group] then
		return 2
	end

	return 0
end

function COMMAND_ASSES(ply,cmd)
	local access = cmd[2] or 1
	if access != 0 and COMMAND_GETASSES(ply) < access then return end

	return true
end

function COMMAND_GETARGS(args)
	local newArgs = {}
	local waitClose,waitCloseText

	for i,text in pairs(args) do
		if not waitClose and string.sub(text,1,1) == "\"" then
			waitClose = true

			if string.sub(text,#text,#text) == "\n" then
				newArgs[#newArgs + 1] = string.sub(text,2,#text - 1)

				waitClose = nil
			else
				waitCloseText = string.sub(text,2,#text)
			end

			continue
		end

		if waitClose then
			if string.sub(text,#text,#text) == "\"" then
				waitClose = nil

				newArgs[#newArgs + 1] = waitCloseText .. string.sub(text,1,#text - 1)
			else
				waitCloseText = waitCloseText .. string.sub(text,1,#text)
			end

			continue
		end

		newArgs[#newArgs + 1] = text
	end

	return newArgs
end

function PrintMessageChat(id,text)
	timer.Simple(0,function()
		if type(id) == "table" or type(id) == "Player" then
			if not IsValid(id) then return end--small littl trol

			id:ChatPrint(text)
		else
			PrintMessage(id,text)
		end
	end)
end

function COMMAND_Input(ply,args)
	local cmd = COMMANDS[args[1]]
	if not cmd then return false end
	if not COMMAND_ASSES(ply,cmd) then return true,false end

	table.remove(args,1)

	return true,cmd[1](ply,args)
end

concommand.Add("hg_say",function(ply,cmd,args,text)
	if not IsValid(ply) then ply = plyServer end

	COMMAND_Input(ply,COMMAND_GETARGS(string.Split(text," ")))

end)

hook.Add("PlayerCanSeePlayersChat","AddSpawn",function(text,_,_,ply)
	if not IsValid(ply) then ply = plyServer end
	if speak[ply] then return end
	speak[ply] = true
	
	COMMAND_Input(ply,COMMAND_GETARGS(string.Split(string.sub(text,2,#text)," ")))

	local func = TableRound().ShouldDiscordOutput
	if ply.fakePly or not func or (func and func(ply,text) == nil) then
	end
end)

hook.Add("Think","Speak Chat Shit",function()
	for k in pairs(speak) do speak[k] = nil end
end)

local PlayerMeta = FindMetaTable("Player")

util.AddNetworkString("consoleprint")
function PlayerMeta:ConsolePrint(text)
	net.Start("consoleprint")
	net.WriteString(text)
	net.Send(self)
end

local validUserGroup = {
	superadmin = true,
	admin = true
}

function player.GetListByName(name)
	local list = {}

	if name == "^" then
		return
	elseif name == "*" then

		return player.GetAll()
	end

	for i,ply in pairs(player.GetAll()) do
		if string.find(string.lower(ply:Name()),string.lower(name)) then list[#list + 1] = ply end
	end

	return list
end

COMMANDS.submat = {function(ply,args)
	for i,ply in pairs(player.GetListByName(args[1]) or {ply}) do
		ply:SetSubMaterial(tonumber(args[1],10),args[2])
	end
end}


COMMANDS.fling = {function(ply,args)
	if !ply:IsAdmin() then return end
	local value = args[2] or 60

	for i,ply in pairs(player.GetListByName(args[1]) or {ply}) do
		ply:SetVelocity(VectorRand(-value * 2,value * 2))
		if !ply.Fake then
			hg.Faking(ply,VectorRand(-value,value))
			ply:SetVelocity(VectorRand(-value * 2,value * 2))
		else
			ply.FakeRagdoll:GetPhysicsObject():AddVelocity(VectorRand(-value * 2,value * 2))
		end
	end
end,1}

COMMANDS.setmodel = {function(ply,args)
	if not ply:IsAdmin() then return end

	for i,ply in pairs(player.GetListByName(args[1]) or {ply}) do
		ply:SetModel(args[2])
		ply:SetSubMaterial()
		ply.OverrideModel = args[2]
	end
end,1}

COMMANDS.forceclass = {function(ply,args)
	for i,ply in pairs(player.GetListByName(args[1]) or {ply}) do
		ply:SetPlayerClass(args[2])
	end
end,1}

COMMANDS.forceteam = {function(ply,args)
	for i,ply in pairs(player.GetListByName(args[1]) or {ply}) do
		ply:SetTeam(args[2])
	end
end,1}

COMMANDS.forceuncon = {function(ply,args)
	for i,ply in pairs(player.GetListByName(args[1]) or {ply}) do
		ply.otrub = true
		ply.pain = 400
	end
end,1}

COMMANDS.nortv = {function(ply,args)
	if not ply:IsAdmin() then return end
	local value = tonumber(args[1]) > 0

	SetGlobalBool("NoRTV",value)
	PrintMessage(3,"No RTV - "..(value and "ON" or "OF"))
end,1}

COMMANDS.nomodechange = {function(ply,args)
	if not ply:IsAdmin() then return end
	local value = tonumber(args[1]) > 0

	SetGlobalBool("NoLevelChange",value)
	PrintMessage(3,"No mode change - "..(value and "ON" or "OF"))
end,1}

COMMANDS.nologs = {function(ply,args)
	if not ply:IsAdmin() then return end
	local value = tonumber(args[1]) > 0

	SetGlobalBool("DefaultMove",value)
	PrintMessage(3,"GMod movement -"..(value and "ON" or "OFF"))
end,1}

COMMANDS.nologs = {function(ply,args)
	if not ply:IsAdmin() then return end
	local value = tonumber(args[1]) > 0

	SetGlobalBool("DisabledLogs",value)
	PrintMessage(3,"Discord logs -"..(value and "OFF" or "ON"))
end,1}

COMMANDS.getmats = {function(ply,args)
	if not ply:IsAdmin() then return end

	local tr = hg.eyeTrace(ply)

	if tr.Entity then
		for _, mats in ipairs(tr.Entity:GetMaterials()) do
			ply:ChatPrint(tostring(mats))
		end
	end
end,1}

COMMANDS.force_posture = {function(ply,args) // :)))
	if not ply:IsAdmin() then return end

	for i,ply in pairs(player.GetListByName(args[1]) or {ply}) do
		ply.posture = tonumber(args[2])
	end
end,1}

COMMANDS.notarget = {function(ply,args)
	if not ply:IsAdmin() then return end
	local value = tonumber(args[2]) > 0

	for i,ply in pairs(player.GetListByName(args[1]) or {ply}) do
		ply:SetNoTarget(value)
		ply:ChatPrint("NoTarget - " .. tostring(value))
	end
end,1}

hook.Add("PlayerSay", "CMDS-Things", function(ply, txt)
    if string.sub(txt, 1, 1) == "!" then
        txt = string.sub(txt, 2)
    end

    local args = {}
    for word in string.gmatch(txt, "%S+") do
        table.insert(args, word)
    end

    local command = string.lower(args[1])
    table.remove(args, 1)

    if COMMANDS[command] then
        COMMANDS[command][1](ply, args)

		return ""
    end
end)

function team.SpawnsTwoCommand(point1,point2)
	local spawnsT = ReadDataMap(point1)
	local spawnsCT = ReadDataMap(point2)

	if #spawnsT == 0 then
		for i, ent in RandomPairs(ents.FindByClass("info_player_terrorist")) do
			table.insert(spawnsT,ent:GetPos())
		end
	end

	if #spawnsCT == 0 then
		for i, ent in RandomPairs(ents.FindByClass("info_player_counterterrorist")) do
			table.insert(spawnsCT,ent:GetPos())
		end
	end

	return spawnsT, spawnsCT
end

function team.SpawnCommand(tbl, aviable, func, funcShould)
	for _, ply in RandomPairs(tbl) do
		if funcShould and funcShould(ply) != nil then continue end

		if ply:Alive() then ply:KillSilent() end
		if func then func(ply) end

		ply:Spawn()

		ply.allowFlashlights = true

		if #aviable > 0 then
			local key = math.random(#aviable)
			local point = ReadPoint(aviable[key])

			if point then
				ply:SetPos(point[1])

				table.remove(aviable, key)
			end
		end
	end
end

COMMANDS.nogib = {function(ply,args)
	if not ply:IsAdmin() then return end

	local value = tonumber(args[2]) > 0

	SetGlobalBool("NoGib",value)
end,1}

COMMANDS.nextmode = {function(ply,args)
	if not ply:IsAdmin() then return end

	if !TableRound(args[1]) then
		return
	end

	if TableRound(args[1]).CanStart then
		if !TableRound(args[1]):CanStart() then
			ply:ChatPrint("This mode cant be started.")
			return
		end
	end

	if table.HasValue(ROUND_LIST,args[1]) then
		ROUND_NEXT = args[1]
		ply:ChatPrint("Next mode - "..args[1])

		net.Start("SyncRound")
    	net.WriteString(ROUND_NAME)
    	net.WriteString(ROUND_NEXT)
		net.WriteBool(false)
    	net.Broadcast()
	else
		ply:ChatPrint("no mode.")
	end
end,1}
COMMANDS.endmode = {function(ply,args)
	if not ply:IsAdmin() then return end

	ROUND_ACTIVE = false
end,1}
COMMANDS.modes = {function(ply,args)
	if not ply:IsAdmin() then return end
	//print(ROUND_LIST)

	for _, mode in ipairs(ROUND_LIST) do
		ply:ChatPrint(mode)
		--ply:ChatPrint(_)
	end
end,1}

COMMANDS.avaiblemodes = {function(ply,args)
	if not ply:IsAdmin() then return end
	local CanBeStarted = {}

    for _, lvl in ipairs(ROUND_LIST) do
        if TableRound(lvl).CantRandom then
            continue 
        end
        if TableRound(lvl).CanStart and TableRound(lvl).CanStart(forced) then
            table.insert(CanBeStarted,lvl)
			ply:ChatPrint(lvl)
        elseif !TableRound(lvl).CanStart then
            table.insert(CanBeStarted,lvl)
			ply:ChatPrint(lvl)
        end
    end
end,1}


	function team.DirectTeams(minTeam, maxTeam)
		local players = {}
		for _, ply in ipairs(player.GetAll()) do
			if ply:Team() != 1002 then
				table.insert(players, ply)
			end
		end

		for i = #players, 2, -1 do
			local j = math.random(i)
			players[i], players[j] = players[j], players[i]
		end

		local splitPoint = math.ceil(#players / 2)

		for i, ply in ipairs(players) do
			if i <= splitPoint then
				ply:SetTeam(minTeam)
			else
				ply:SetTeam(maxTeam)
			end
		end
	end