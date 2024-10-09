function pcoop.StartRoundSV(data)
    tdm.RemoveItems()

	tdm.DirectOtherTeam(1,2)

	roundTimeStart = CurTime()
	roundTime = 900
	roundTimeLoot = 9999

	local players = team.GetPlayers(2)
		for i = 1,#players do
			local ply,key = table.Random(players)
			players[key] = nil

			ply.exit = false
	
			ply:SetTeam(1)
		end
	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)

	pcoop.police = false

	tdm.CenterInit()

	return {roundTimeLoot = roundTimeLoot}
end

function pcoop.RoundEndCheck()
    if roundTimeStart + roundTime < CurTime() then
		if not pcoop.police then
			pcoop.police = true
			PrintMessage(3,"Раунд Закончен.")

			EndRound(1)
		end
	end

	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local TExit = 0
	
	if TAlive == 0 and TExit < 1 then EndRound() return end

	if TAlive == 0 and TExit > 0 then EndRound(1) return end

	CTAlive = tdm.GetCountLive(team.GetPlayers(1),function(ply)
		if ply.exit then TExit = TExit + 1 return false end
	end)

	local list = ReadDataMap("spawnpoints_ss_exit")

		for i,ply in pairs(team.GetPlayers(1)) do
			if not ply:Alive() or ply.exit then continue end

			for i,point in pairs(list) do
				if ply:GetPos():Distance(point[1]) < (point[3] or 250) then
					ply.exit = true
					ply:KillSilent()

					TExit = TExit + 1

					PrintMessage(3,ply:Nick() .. " прошёл, осталось " .. (TAlive - 1))
				end
			end
		end
end

function pcoop.EndRound(winner) tdm.EndRoundMessage(winner) end



function pcoop.PlayerSpawn(ply,teamID)
	local teamTbl = pcoop[pcoop.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
    ply:SetPlayerColor(Color(255, 89, 0):ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end
end

function pcoop.PlayerInitialSpawn(ply) ply:SetTeam(2) end

function pcoop.PlayerCanJoinTeam(ply,teamID)

	if teamID == 3 then
		return false
	end

    if teamID == 1 then
		return true
	end

	if teamID == 2 then
		return false
	end
end

function pcoop.ShouldSpawnLoot()
		return false
end

function pcoop.PlayerDeath(ply,inf,att) return false end

function pcoop.NoSelectRandom()
	local a,b,c = string.find(string.lower(game.GetMap()),"testchmb")
    return a ~= nil
end