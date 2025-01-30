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
	megapenis = true,
	meagsponsor = true
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
	if access ~= 0 and COMMAND_GETASSES(ply) < access then return end

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
	if args[2] == "^" then
		ply:SetSubMaterial(tonumber(args[1],10),args[2])
	end
end}

COMMANDS.superfighter = {function(ply,args)
	if not ply:IsAdmin() then return end
	local value = tonumber(args[2]) > 0

	for i,ply in pairs(player.GetListByName(args[1]) or {ply}) do
		ply.organism.superfighter = value
		ply:ChatPrint("SuperFighter Mode - " .. tostring(value))
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
    end
end)