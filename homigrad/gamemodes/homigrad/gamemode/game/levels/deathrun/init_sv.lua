function deathrun.StartRoundSV(data)
    tdm.RemoveItems()

	tdm.DirectOtherTeam(1,2)

	roundTimeStart = CurTime()
	roundTime = 900
	roundTimeLoot = 9000

	SetGlobalBool("NoFake",true)

    local players = team.GetPlayers(2)

    for i,ply in pairs(players) do
		ply.exit = false

		if ply.deathrunForceT then
			ply.deathrunForceT = nil

			ply:SetTeam(1)
		end
    end

	players = team.GetPlayers(2)

        local ply,key = table.Random(players)
		players[key] = nil

        ply:SetTeam(1)

	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)
	tdm.SpawnCommand(team.GetPlayers(2),spawnsCT)

	deathrun.police = false

	tdm.CenterInit()

	return {roundTimeLoot = roundTimeLoot}
end

function deathrun.RoundEndCheck()
    if roundTimeStart + roundTime < CurTime() then
		if not deathrun.police then
			deathrun.police = true
			
			SetGlobalBool("NoFake",false)

			EndRound()
		end
	end

	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local CTAlive,CTExit = 0,0
	local OAlive = 0

	CTAlive = tdm.GetCountLive(team.GetPlayers(2),function(ply)
		if ply.exit then CTExit = CTExit + 1 return false end
	end)

	local list = ReadDataMap("spawnpoints_ss_exit")

	if deathrun.police then
		for i,ply in pairs(team.GetPlayers(2)) do
			if not ply:Alive() or ply.exit then continue end

			for i,point in pairs(list) do
				if ply:GetPos():Distance(point[1]) < (point[3] or 250) then
					ply.exit = true
					ply:KillSilent()

					CTExit = CTExit + 1

					PrintMessage(3,"Школьник сбежал, осталось " .. (CTAlive - 1) .. " школьников")
				end
			end
		end
	end

	OAlive = tdm.GetCountLive(team.GetPlayers(3))

	if CTExit > 0 and CTAlive == 0 then EndRound(2) return end
	if OAlive == 0 and TAlive == 0 and CTAlive == 0 then EndRound() return end

	if OAlive == 0 and TAlive == 0 then EndRound(2) return end
	if CTAlive == 0 then EndRound(1) return end
	if TAlive == 0 then EndRound(2) return end
end

function deathrun.EndRound(winner) tdm.EndRoundMessage(winner) end

function deathrun.PlayerSpawn(ply,teamID)
	local teamTbl = deathrun[deathrun.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
    ply:SetPlayerColor(color:ToVector())


	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	tdm.GiveSwep(ply,teamTbl.main_weapon,teamID == 1 and 16 or 4)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon,teamID == 1 and 8 or 2)


    if teamID == 2 then
		ply:SetPlayerColor(Color(0,255,0):ToVector())
		ply.speeed = 600
		ply:SetWalkSpeed(300)
	ply:SetRunSpeed(500)
    end
	ply.allowFlashlights = false
end

function deathrun.PlayerInitialSpawn(ply) ply:SetTeam(2) end

function deathrun.PlayerCanJoinTeam(ply,teamID)
	ply.deathrunForceT = nil

	if teamID == 3 then
		if ply:IsAdmin() then
			ply:ChatPrint("Милости прошу")
			ply:Spawn()

			return true
		else
			ply:ChatPrint("Иди нахуй")

			return false
		end
	end

    if teamID == 1 then
		if ply:IsAdmin() then
			ply.deathrunForceT = true

			ply:ChatPrint("Милости прошу")

			return true
		else
			ply:ChatPrint("Пашол нахуй")

			return false
		end
	end

	if teamID == 2 then
		if ply:Team() == 1 then
			if ply:IsAdmin() then
				ply:ChatPrint("ладно.")

				return true
			else
				ply:ChatPrint("Просижовай жопу до конца раунда, лох.")

				return false
			end
		end

		return true
	end
end

function deathrun.ShouldSpawnLoot()
   	if roundTimeStart + roundTimeLoot - CurTime() > 0 then return false end
end

function deathrun.PlayerDeath(ply,inf,att) return false end

function deathrun.GuiltLogic(ply,att,dmgInfo)
	if att.isContr and ply:Team() == 2 then return dmgInfo:GetDamage() * 3 end
end

function deathrun.NoSelectRandom()
	local a,b,c = string.find(string.lower(game.GetMap()),"school")
    return a ~= nil
end