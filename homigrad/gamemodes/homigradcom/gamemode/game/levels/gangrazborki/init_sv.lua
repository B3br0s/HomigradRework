function gangrazborki.SpawnsTwoCommand()
	local spawnsT = ReadDataMap("spawnpointst")
	local spawnsCT = ReadDataMap("spawnpointsct")

	gangrazborki.police = false

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

	return spawnsT,spawnsCT
end

function gangrazborki.SpawnCommand(tbl,aviable,func,funcShould)
	for i,ply in RandomPairs(tbl) do
		if funcShould and funcShould(ply) ~= nil then continue end

		if ply:Alive() then ply:KillSilent() end

		if func then func(ply) end

		ply:Spawn()
		ply.allowFlashlights = true

		local point,key = table.Random(aviable)
		point = ReadPoint(point)
		if not point then continue end

		ply:SetPos(point[1])
		if #aviable > 1 then table.remove(aviable,key) end
	end
end

function gangrazborki.DirectOtherTeam(start,min,max)
	if not max then max = min end

	for i = start,team.MaxTeams do
		for i,ply in pairs(team.GetPlayers(i)) do
			ply:SetTeam(math.random(min,max))
		end
	end
end

function gangrazborki.GetListMul(list,mul,func,max)
	local newList = {}
	mul = math.Round(#list * mul)
	if max then mul = math.max(mul,max) end

	for i = 1,mul do
		local ply,key = table.Random(list)
		list[key] = nil

		if func and func(ply) ~= true then continue end

		newList[#newList + 1] = ply
	end

	return newList
end

function gangrazborki.RemoveItems()
	for i,ent in pairs(ents.GetAll()) do
		if ent:GetName() == "biboran" then
			ent:Remove()
		end
	end
end

function gangrazborki.StartRoundSV()
    gangrazborki.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 90 * (2 + math.min(#player.GetAll() / 8,2))

	for i,ply in pairs(team.GetPlayers(3)) do ply:SetTeam(math.random(1,2)) end

	OpposingAllTeam()
	AutoBalanceTwoTeam()

	local spawnsT,spawnsCT = gangrazborki.SpawnsTwoCommand()
	gangrazborki.SpawnCommand(team.GetPlayers(1),spawnsT)
	gangrazborki.SpawnCommand(team.GetPlayers(2),spawnsCT)

	gangrazborki.CenterInit()
end

function gangrazborki.GetCountLive(list,func)
	local count = 0
	local result

	for i,ply in pairs(list) do
		if not IsValid(ply) then continue end

		result = func and func(ply)
		if result == true then count = count + 1 continue elseif result == false then continue end
		if ply:Alive() then count = count + 1 end
	end

	return count
end

function SpawnNigErmany()
	if not gangrazborki.police then
	gangrazborki.police = true
	--PrintMessage(3,"На звуки выстрелов приехала полиция.")
	PrintMessage(3,"Police arrived at the sound of gunshots.")
	for i, ply in ipairs( player.GetAll() ) do
		if not ply:Alive() and ply:Team() != 1002 then
			ply:Spawn()

			ply:SetPlayerClass("police")	

			ply:Give("weapon_mp5")

			ply:GiveAmmo(180,"9х19 mm Parabellum",true)
		end
			sound.Play("snd_jack_hmcd_policesiren.wav",ply:GetPos(),100,100,10)
    end
end
end

function gangrazborki.RoundEndCheck()
	gangrazborki.Center()

	if roundTimeStart + roundTime - CurTime() <= 0 then SpawnNigErmany() end
	local TAlive = gangrazborki.GetCountLive(team.GetPlayers(1))
	local CTAlive = gangrazborki.GetCountLive(team.GetPlayers(2))

	if TAlive == 0 and CTAlive == 0 then EndRound() return end

	if TAlive == 0 then EndRound(2) end
	if CTAlive == 0 then EndRound(1) end
end

function gangrazborki.EndRoundMessage(winner,textNobody)
	local tbl = TableRound()
	if winner == 2 and not gangrazborki.police and tbl.blue[1] then
	PrintMessage(3,"Bloods Have Taken Over Crips Territory.")
	elseif winner == 1 and not gangrazborki.police and tbl.red[1] then
	PrintMessage(3,"The Crips have defended their turf.")
	elseif gangrazborki.police then
	PrintMessage(3,"Both gangs retreat as police arrive.")
	else
	end
end

function gangrazborki.EndRound(winner) gangrazborki.EndRoundMessage(winner) end

--

function gangrazborki.GiveSwep(ply,list,mulClip1)
	if not list then return end

	local wep = ply:Give(type(list) == "table" and list[math.random(#list)] or list)

	mulClip1 = mulClip1 or 3

    if IsValid(wep) then
        wep:SetClip1(wep:GetMaxClip1())
	    ply:GiveAmmo(wep:GetMaxClip1() * mulClip1,wep:GetPrimaryAmmoType())
    end
end

function gangrazborki.PlayerSpawn(ply,teamID)
	local teamTbl = gangrazborki[gangrazborki.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
    ply:SetPlayerColor(color:ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	gangrazborki.GiveSwep(ply,teamTbl.main_weapon)
	gangrazborki.GiveSwep(ply,teamTbl.secondary_weapon)
end

function gangrazborki.PlayerInitialSpawn(ply) ply:SetTeam(math.random(2)) end

function gangrazborki.PlayerCanJoinTeam(ply,teamID)
    if teamID == 3 then ply:ChatPrint("Иди нахуй") return false end
end

local common = {"food_lays","weapon_pipe","weapon_bat","medkit","food_monster","food_fishcan","food_spongebob_home"}
local uncommon = {"weapon_molotok","painkiller"}

function riot.ShouldSpawnLoot()
	local chance = math.random(0)

	if chance < 0 then
		return true,uncommon[math.random(#uncommon)]
	elseif chance < 0 then
		return true,common[math.random(#common)]
	else
		return false
	end
end

function gangrazborki.PlayerDeath(ply,inf,att) return false end