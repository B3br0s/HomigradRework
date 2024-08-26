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

	SandBox.respawned = false

	tdm.CenterInit()

	return {roundTimeLoot = roundTimeLoot}
end

function SandBox.RoundEndCheck()
	if not SandBox.respawned then
		for i,ply in pairs(tdm.GetListMul(player.GetAll(),1,function(ply) return not ply:Alive() and ply:Team() ~= 1002 end),1) do
			SandBox.respawned = true
			timer.Simple(5,function() ply:SetTeam(1) ply:Spawn() SandBox.respawned = false end )
		end
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

function SandBox.ShouldSpawnLoot()
	if roundTimeStart + roundTimeLoot - CurTime() > 0 then return false end
end

function SandBox.PlayerDeath(ply,inf,att) return false end

function SandBox.GuiltLogic(ply,att,dmgInfo)
 if att.isContr and ply:Team() == 2 then return dmgInfo:GetDamage() * 3 end
end


function SandBox.NoSelectRandom()
	local a,b,c = string.find(string.lower(game.GetMap()),"school")
    return a ~= nil
end