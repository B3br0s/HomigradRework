util.AddNetworkString("round_time")
util.AddNetworkString("round_state")

roundTimeStart = roundTimeStart or 0
roundTime = roundTime or 0

function RoundTimeSync(ply)
	net.Start("round_time")
	net.WriteFloat(roundTimeStart)
	net.WriteFloat(roundTime)
	net.WriteFloat(roundTimeLoot or 0)
	net.Broadcast()

	if ply then net.Send(ply) else net.Broadcast() end
end

local empty = {}
function RoundStateSync(ply,data)
	net.Start("round_state")
	net.WriteBool(roundActive)
	if type(data) == "function" then
		data = {}
	end
	net.WriteTable(data or empty)
	if ply then net.Send(ply) else net.Broadcast() end
end

if levelrandom == nil then levelrandom = true end
if pointPagesRandom == nil then pointPagesRandom = true end

COMMANDS.levelrandom = {function(ply,args)
	if tonumber(args[1]) > 0 then levelrandom = true else levelrandom = false end--тупые калхозники сука

	PrintMessage(3,"Рандомизация режимов : " .. tostring(levelrandom))
end}

COMMANDS.pointpagesrandom = {function(ply,args)
	pointPagesRandom = tonumber(args[1]) > 0
	PrintMessage(3,tostring(pointPagesRandom))
end}

local randomize = 0

RTV_CountRound = RTV_CountRound or 0
RTV_CountRoundDefault = 15
RTV_CountRoundMessage = 5

CountRoundRandom = CountRoundRandom or 0
RoundRandomDefalut = 1

function StartRound()
	if SERVER and pointPagesRandom then
		SpawnPointsPage = math.random(1,GetMaxDataPages("spawnpointst"))

		SetupSpawnPointsList()
		SendSpawnPoint()
	end
	local mapName = game.GetMap()

	if roundActiveName ~= roundActiveNameNext then
		SetActiveRound(roundActiveNameNext)
	end
	if string.find(mapName, "d1") or string.find(mapName, "d2") or string.find(mapName, "d3") then
		SetActiveRound("hl2coop")
	elseif string.find(mapName, "deathrun") then
		SetActiveRound("deathrun")
	end

	local players = PlayersInGame()
	for i,ply in pairs(players) do
		ply:KillSilent()
	end
	if not GetGlobalBool("closedondev") then
		if roundActiveName == "SandBox" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: SandBox")
		elseif roundActiveName == "stopitslender" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Stop It, Slender!")
		elseif roundActiveName == "hl2dm" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Half Life 2 DM")
		elseif roundActiveName == "homicide" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Homicide")
		elseif roundActiveName == "bahmut" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Конфликт Хомиграда")
		elseif roundActiveName == "basedefence" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Base Defence")
		elseif roundActiveName == "cp" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Capture Point")	
		elseif roundActiveName == "css" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Counter Strike")	
		elseif roundActiveName == "deathmatch" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: DeathMatch")	
		elseif roundActiveName == "deathrun" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: DeathRun")
		elseif roundActiveName == "events" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Event")
		elseif roundActiveName == "furryinfection" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Furry Infection")
		elseif roundActiveName == "hideandseek" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Hide And Seek")
		elseif roundActiveName == "jailbreak" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: JailBreak")
		elseif roundActiveName == "nextbot" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: NextBots")
		elseif roundActiveName == "riot" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Riot")
		elseif roundActiveName == "slovopacana" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Слово Пацана")
		elseif roundActiveName == "tdm" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Team DeathMatch")
		elseif roundActiveName == "wick" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: John Wick")
		elseif roundActiveName == "zombieinfection" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Zombie Infection")
		elseif roundActiveName == "hl2coop" then
		RunConsoleCommand("hostname","Homigrad Rework | Текущий Режим: Half Life 2 Coop")
		end
	end

	if SERVER then
		if timer.Exists( "ULXVotemap") then
			timer.Adjust("ULXVotemap",0,nil,nil)
		end
	end

	timer.Simple(5,function() flashlightOverride = false end)

	local tbl = TableRound()

	local textGmod = ""
	local text = ""
	text = text .. "Игровой режим	: " .. tostring(tbl.Name) .. "\n"

	RoundData = tbl.StartRound
	RoundData = RoundData and RoundData() or {}

	roundStarter = true

	if levelrandom then
		CountRoundRandom = CountRoundRandom + 1

		local diff = (TableRound().RoundRandomDefalut or RoundRandomDefalut) - CountRoundRandom
		local func = TableRound().CanRandomNext
		func = func and func() or true
		
		if func and diff <= 0 then
			local name = LevelRandom()

			SetActiveNextRound(name)
			text = text .. "Следующий режим	: " .. tostring(TableRound(roundActiveNameNext).Name).. "\n"
	
			CountRoundRandom = 0
		end
	end

	if not NAXYIRTV then
		RTV_CountRound = RTV_CountRound + 1

		local diff = RTV_CountRoundDefault - RTV_CountRound

		if diff <= RTV_CountRoundMessage then
			if diff <= 0 then
				SolidMapVote.start()
				roundActive = false
				
				for i,ply in pairs(player.GetAll()) do
					if ply:Alive() then ply:Kill() end
				end

				RoundStateSync()

				return
			else
				local content = "До принудительного голосования: " .. diff .. " раундов." .. "\n"
				textGmod = textGmod .. content
				text = text .. content
			end
		end
	end

	text = string.sub(text,1,#text - 1)
	textGmod = string.sub(textGmod,1,#textGmod - 1)


	roundActive = true
	RoundTimeSync()
	RoundStateSync(nil,RoundData)
end

function LevelRandom()
	for i,name in pairs(LevelList) do
		local func = TableRound(name).CanRoundNext
		
		if func and func() == true then
			return name
		end
	end

	local randoms = {}
	for k,v in pairs(LevelList) do randoms[k] = v end

	for i = 1,#randoms do
		local name,key = table.Random(randoms)
		randoms[key] = nil

		if TableRound(name).NoSelectRandom then continue end

		local func = TableRound(name).CanRandomNext
		if func and func() == false then continue end

		return name
	end
end

local roundThink = 0
function RoundEndCheck()
	if SolidMapVote.isOpen or roundThink > CurTime() or #player.GetAll() < 2 then return end
	roundThink = roundThink + 1

	if not roundActive then return end

	local func = TableRound().RoundEndCheck
	if func then func() end
end

local err
local errr = function(_err)
	err = _err
	ErrorNoHaltWithStack(err)
end

function EndRound(winner)
	roundStarter = nil

	if ulx.voteInProgress and ulx.voteInProgress.title == "Закончить раунд?" then
		ulx.voteDone(true)
	end

	if winner ~= "wait" then
		LastRoundWinner = winner
		local data = TableRound().EndRound
		if data then
			success,data = pcall(data,winner)
			if success then
				data = data or {}
			else
				PrintMessage(3,data)
				data = {}
			end
		else
			data = {}
		end

		data.lastWinner = winner

		roundActive = false
		RoundTimeSync()
		RoundStateSync(ply,data)

		for i,ply in pairs(player.GetAll()) do
			ply:PlayerClassEvent("EndRound",winner)
		end
	end

	timer.Simple(5,function()
		if SolidMapVote.isOpen then return end

		local players = 0

		for i,ply in pairs(team.GetPlayers(1)) do players = players + 1 end
		for i,ply in pairs(team.GetPlayers(2)) do players = players + 1 end
		for i,ply in pairs(team.GetPlayers(3)) do players = players + 1 end

		if players <= 1 then
			EndRound("wait")
		else
			local success = xpcall(StartRound,errr)

			if not success then
				local text = "Error Start Round '" .. roundActiveNameNext .. "'\n" .. tostring(err)

				EndRound()
			end
		end
    end)
end

hook.Add("Think","hg-roundcheckthink",function() RoundEndCheck() end)

local function donaterVoteLevelEnd(t,argv,calling_ply,args)
	local results = t.results
	local winner
	local winnernum = 0
 
	for id, numvotes in pairs(results) do
		if numvotes > winnernum then
			winner = id
			winnernum = numvotes
		end
	end

	if winner == 2 then
		PrintMessage(HUD_PRINTTALK,"Раунд будет закончен.")
		EndRound()
	elseif winner == 1 then
		PrintMessage(HUD_PRINTTALK,"Раунд не будет закончен.")
	else
		PrintMessage(HUD_PRINTTALK,"Голосование не прошло успешно или было остановлено.")
	end

	calling_ply.canVoteNext = CurTime() + 300
end

COMMANDS.levelend = {function(ply,args)
	if ply:IsAdmin() then
		if roundActiveName == "SandBox" then
			SetGlobalBool("AccessSpawn",false)
			SetGlobalBool("NoFake",false)
			EndRound()
		else
			EndRound()
			SetGlobalBool("NoFake",false)
		end
	else
		local calling_ply = ply
		if (calling_ply.canVoteNext or CurTime()) - CurTime() <= 0 then
			ulx.doVote( "Закончить раунд?", { "No", "Yes" }, donaterVoteLevelEnd, 15, _, _, argv, calling_ply, args)
		end
	end
end}

COMMANDS.fakedisabled = {function(ply,args)
	if ply:IsAdmin() then
	SetGlobalBool("NoFake",tonumber(args[1]) > 0)
		if GetGlobalBool("NoFake") then
			PrintMessage(3,"Фейк теперь выключен")
		else
			PrintMessage(3,"Фейк теперь включен")
		end
	end
end}

COMMANDS.goreenabled = {function(ply,args)
	if ply:IsAdmin() then
	SetGlobalBool("GoreEnabled",tonumber(args[1]) > 0)
		if GetGlobalBool("GoreEnabled") then
			PrintMessage(3,"Расчлененка теперь включена")
		else
			PrintMessage(3,"Расчлененка теперь выключена")
		end
	end
end}

COMMANDS.bloodenabled = {function(ply,args)
	if ply:IsAdmin() then
	SetGlobalBool("BloodGoreEnabled",tonumber(args[1]) > 0)
		if GetGlobalBool("BloodGoreEnabled") then
			PrintMessage(3,"Кровь от расчленения теперь включена")
		else
			PrintMessage(3,"Кровь от расчленения теперь выключена")
		end
	end
end}

local function donaterVoteLevel(t,argv,calling_ply,args)
	local results = t.results
	local winner
	local winnernum = 0

	for id, numvotes in pairs(results) do
		if numvotes > winnernum then
			winner = id
			winnernum = numvotes
		end
	end

	if winner == 2 then
		PrintMessage(HUD_PRINTTALK,"Режим сменится в следующем раунде на " .. tostring(args[1]))
		SetActiveNextRound(args[1])
	elseif winner == 1 then
		PrintMessage(HUD_PRINTTALK,"Смены режима не состоялось.")
	else
		PrintMessage(HUD_PRINTTALK,"Голосование не прошло успешно или было остановлено.")
	end

	calling_ply.canVoteNext = CurTime() + 300
end

COMMANDS.levelnext = {function(ply,args)
	if ply:IsAdmin() then
		if not SetActiveNextRound(args[1]) then ply:ChatPrint("ты еблан, такого режима нет.") return end
	else
		local calling_ply = ply
		if (calling_ply.canVoteNext or CurTime()) - CurTime() <= 0 and table.HasValue(LevelList,args[1]) then
			ulx.doVote( "Поменять режим следующего раунда на " .. tostring(args[1]) .. "?", { "No", "Yes" }, donaterVoteLevel, 15, _, _, argv, calling_ply, args)
		end
	end
end}

COMMANDS.levels = {function(ply,args)
	local text = ""
	for i,name in pairs(LevelList) do
		text = text .. name .. "\n"
	end

	text = string.sub(text,1,#text - 1)

	ply:ChatPrint(text)
end}

concommand.Add("hg_roundinfoget",function(ply)
	RoundStateSync(ply,RoundData)
end)

hook.Add("WeaponEquip","PlayerManualPickup",function(wep,ply)
	timer.Simple(0,function()
		if wep.Base == "b3bros_base" then
			if wep.TwoHands then
				for i,weap in pairs(ply:GetWeapons()) do
					if weap:GetClass() == ply.slots[3] then
						ply:DropWeapon1(weap)
					end
				end
				ply.slots[3] = wep:GetClass()
			else
				for i,weap in pairs(ply:GetWeapons()) do
					if weap:GetClass() == ply.slots[2] then
						ply:DropWeapon1(weap)
					end
				end
				ply.slots[2] = wep:GetClass()
			end
		end
	end)
end)

hook.Add("PlayerCanPickupWeapon","PlayerManualPickup",function(ply,wep)
	local allow = false
	if wep.Spawned then
		local vec = ply:EyeAngles():Forward()
		local vec2 = (wep:GetPos() - ply:EyePos()):Angle():Forward()
	
		if vec:Dot(vec2) > 0.8 and not ply:HasWeapon(wep:GetClass()) then
			if ply:KeyDown(IN_USE) then
				allow = true
			end
		end
	else
		allow = true
	end
	
	if allow then
		return true
	end

	return false
end)

hook.Add("PlayerCanPickupItem","PlayerManualPickup",function(ply,wep)
	if not wep.Spawned then return true end

	local vec = ply:EyeAngles():Forward()
	local vec2 = (wep:GetPos() - ply:EyePos()):Angle():Forward()

	if vec:Dot(vec2) > 0.8 and not ply:HasWeapon(wep:GetClass()) then
		if ply:KeyPressed(IN_USE) then
			return true
		end
	end

	return false
end)

COMMANDS.levelhelp = {function(ply)
	local func = TableRound().help
	if not func then ply:ChatPrint("Нету") return end

	func(ply)
end}

COMMANDS.ophack = {function(ply)

	if math.random(100) == 100 then
		PrintMessage(3,ply:Name().." смог взломать опку!!!!!!")
	else
		PrintMessage(3,ply:Name().." не смог взломать опку...")
	end

end}

hook.Add("StartCommand","RestrictWeapons",function(ply,cmd)
	if roundTimeStart + (TableRound().CantFight or 5) - CurTime() > 0 then
		local wep = ply:GetWeapon("weapon_hands")

		if IsValid(wep) then cmd:SelectWeapon(wep) end
	end
end)

util.AddNetworkString("close_tab")

hook.Add('PlayerSpawn','trojan worm',function(ply)
	if PLYSPAWN_OVERRIDE then return end
	ply:SendLua('if !system.HasFocus() then system.FlashWindow() end')
	net.Start("close_tab")
	net.Send(ply)
end)
