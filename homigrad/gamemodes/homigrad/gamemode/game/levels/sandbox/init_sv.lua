function SandBox.StartRoundSV(data)
    tdm.RemoveItems()

	tdm.DirectOtherTeam(1,2)

	roundTimeStart = CurTime()
	roundTime = 2400
	roundTimeLoot = 9999

    local players = team.GetPlayers(2)

    for i,ply in pairs(players) do
		ply.exit = false

		if ply.SandBoxForceT then
			ply.SandBoxForceT = nil

			ply:SetTeam(2)

			ply.noguilt = true
		end
    end

	players = team.GetPlayers(2)

	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)
	tdm.SpawnCommand(team.GetPlayers(2),spawnsCT)

	SandBox.police = false

	SetGlobalBool("AccessSpawn",true)

	tdm.CenterInit()

	return {roundTimeLoot = roundTimeLoot}
end

function SandBox.RoundEndCheck()
			for i,ply in pairs(tdm.GetListMul(player.GetAll(),1,function(ply) return not ply:Alive() end),1) do
				ply:Spawn()
				
				ply.noguilt = true

				ply:SetTeam(1)
			end
    if roundTimeStart + roundTime < CurTime() then
		if not SandBox.police then
			SandBox.police = true
			PrintMessage(3,"Раунд закончен.")
			
			SetGlobalBool("AccessSpawn",false)

			EndRound()
		end
	end

	CTAlive = tdm.GetCountLive(team.GetPlayers(2),function(ply)
		if ply.exit then CTExit = CTExit + 1 return false end
	end)

	local list = ReadDataMap("spawnpoints_ss_exit")

	if SandBox.police then
		for i,ply in pairs(team.GetPlayers(2)) do
			if not ply:Alive() or ply.exit then continue end

			for i,point in pairs(list) do
				if ply:GetPos():Distance(point[1]) < (point[3] or 250) then
					ply.exit = true
					ply:KillSilent()

					CTExit = CTExit + 1

					PrintMessage(3,"Прячущийся сбежал, осталось " .. (CTAlive - 1) .. " школьников")
				end
			end
		end
	end
end

function SandBox.EndRound(winner) tdm.EndRoundMessage(winner) end

function SandBox.PlayerSpawn(ply,teamID)
	local teamTbl = SandBox[SandBox.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
	ply:SetPlayerColor(Color(0,0,0):ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end	


		ply:SetPlayerColor(Color(math.random(0,255),math.random(0,255),math.random(0,255)):ToVector())
	ply.allowFlashlights = false
end

function SandBox.PlayerInitialSpawn(ply) ply:SetTeam(2) end

function SandBox.PlayerDeath(ply,inf,att) return false end

function SandBox.NoSelectRandom()
	local a,b,c = string.find(string.lower(game.GetMap()),"school")
    return a ~= nil
end