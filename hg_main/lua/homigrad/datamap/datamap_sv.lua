file.CreateDir("homigrad")
file.CreateDir("homigrad/maps")

SpawnPointsPage = SpawnPointsPage or 1

hg = hg or {}

hg.Points = hg.Points or {}

function GetDataMapName(name) return "homigrad/maps/" .. name .. "/" .. game.GetMap() .. (SpawnPointsPage == 1 and "" or SpawnPointsPage) ..".dat" end

function GetMaxDataPages(name)
	local i = 0

	while true do
		i = i + 1

		if not file.Exists("homigrad/maps/" .. name .. "/" .. game.GetMap() .. (i == 1 and "" or i) ..".dat","DATA") then return i - 1 end
	end
end

function ReadDataMap(name)
	return util.JSONToTable(file.Read(GetDataMapName(name),"DATA") or "") or {}
end

function WriteDataMap(name,data)
	file.CreateDir("homigrad/maps/" .. name)
	file.Write(GetDataMapName(name),util.TableToJSON(data or {}) or "")
end

function SetupPoints()--чтение и запись
	for name,info in pairs(hg.Points) do
		info[3] = ReadDataMap(name)
	end
end

SetupPoints()

util.AddNetworkString("points")

function SendSpawnPoint(ply)
	net.Start("points")
	net.WriteTable(hg.Points)
	if ply then net.Send(ply) else net.Broadcast() end
end

COMMANDS.point = {function(ply,args)
	local name

	for _name,info in pairs(hg.Points) do
		print(info.Name)
		if info.Name == args[1] then name = _name break end
	end

	if not name then ply:ChatPrint("no") return end

	local tbl = ReadDataMap(name)
	local point = {ply:GetPos() + Vector(0,0,5),Angle(0,ply:EyeAngles()[2],0),tonumber(args[2])}
	table.insert(tbl,point)
	WriteDataMap(name,tbl)

	PrintMessage(3,"Mr.Point " .. args[1])
	SetupPoints()
	SendSpawnPoint()
end}
	
COMMANDS.pointreset = {function(ply,args)
	if args[1] ~= "" then
		for name,info in pairs(hg.Points) do
			if info[1] ~= args[1] then continue end

			WriteDataMap(name)

			break
		end

		PrintMessage(3,"Mr.Points " .. args[1] .. " was reseted.")
	else
		for name,info in pairs(hg.Points) do
			WriteDataMap(name)
		end

		PrintMessage(3,"Mr.Point removed.")
	end

	SetupPoints()
	SendSpawnPoint()
end}

COMMANDS.pointsync = {function(ply,args)
	SetupPoints()
	SendSpawnPoint()
end}

COMMANDS.pointpage = {function(ply,args)
	SpawnPointsPage = tonumber(args[1])
	SetupPoints()
	SendSpawnPoint()
	PrintMessage(3,"Mr.Point variation - " .. SpawnPointsPage)
end}

COMMANDS.pointpages = {function(ply,args)
	PrintMessage(3,GetMaxDataPages("red"))
end}

COMMANDS.points = {function(ply,args)
	for i,point in pairs(hg.Points) do ply:ChatPrint(point.Name) end
end}