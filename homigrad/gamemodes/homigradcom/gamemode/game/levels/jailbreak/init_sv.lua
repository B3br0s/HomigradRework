function jailbreak.StartRoundSV(data)
    tdm.RemoveItems()

	tdm.DirectOtherTeam(1,2)

	jailbreak.SetNachalnik = false

	roundTimeStart = CurTime()
	roundTime = 60 * (2 + math.min(#player.GetAll() / 16,2))
	roundTimeLoot = 9999

	players = team.GetPlayers(2)

	local count = math.min(math.floor(#players / 1.2,1))
    for i = 1,count do
        local ply,key = table.Random(players)
		players[key] = nil

        ply:SetTeam(1)
    end

	timer.Simple(2,function()
		local police = team.GetPlayers(2)

		local ply = table.Random(police)

		if not jailbreak.SetNachalnik then
			jailbreak.SetNachalnik = true
			JMod.EZ_Equip_Armor(ply,"Army Cap Brown")
			ply:SetModel("models/player/breen.mdl")
			PrintMessage(3,ply:Name() .. " Стал начальником.")
		end
	end)

	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)
	tdm.SpawnCommand(team.GetPlayers(2),spawnsCT)

	jailbreak.police = false

	tdm.CenterInit()

	return {roundTimeLoot = roundTimeLoot}
end

function jailbreak.RoundEndCheck()
	local aviable = ReadDataMap("spawnpoints_ss_police")

    if roundTimeStart + roundTime < CurTime() then
		if not jailbreak.police then
			jailbreak.police = true
			PrintMessage(3,"Смена Охранников Закончена.")
		end
	end

	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local CTAlive = tdm.GetCountLive(team.GetPlayers(2))

	if CTAlive == 0 then EndRound(2) return end
	if TAlive == 0 then EndRound(1) return end
end

function jailbreak.EndRound(winner) tdm.EndRoundMessage(winner) end

function jailbreak.PlayerSpawn(ply,teamID)
	local teamTbl = jailbreak[jailbreak.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
    ply:SetPlayerColor(color:ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	tdm.GiveSwep(ply,teamTbl.main_weapon,teamID == 1 and 16 or 4)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon,teamID == 1 and 8 or 2)

	tdm.GiveSwep(ply,teamTbl.main_weapon,teamID == 2 and 16 or 4)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon,teamID == 2 and 8 or 2)

    if teamID == 2 then
        JMod.EZ_Equip_Armor(ply,"Medium-Helmet")
        JMod.EZ_Equip_Armor(ply,"Light-Vest")
	elseif teamID == 1 then
		ply:SetPlayerColor(color)
    end
	ply.allowFlashlights = false
end

function jailbreak.PlayerInitialSpawn(ply) ply:SetTeam(1) end

function jailbreak.PlayerCanJoinTeam(ply,teamID)
	return true
end

function jailbreak.ShouldSpawnLoot()
	return false
end

function jailbreak.PlayerDeath(ply,inf,att) return false end

function jailbreak.GuiltLogic(ply,att,dmgInfo)
end

function jailbreak.NoSelectRandom()
    return true
end