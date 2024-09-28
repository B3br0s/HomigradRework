function hl2coop.StartRoundSV(data)
    tdm.RemoveItems()

	tdm.DirectOtherTeam(1,2)

	roundTimeStart = CurTime()
	roundTime = 900
	roundTimeLoot = 9999

    local players = team.GetPlayers(2)

    for i,ply in pairs(players) do
		ply.exit = false

		if ply.hl2coopForceT then
			ply.hl2coopForceT = nil

			ply:SetTeam(1)
		end
    end

	players = team.GetPlayers(2)
		for i = 1,#players do
			local ply,key = table.Random(players)
			players[key] = nil
	
			ply:SetTeam(1)
		end
	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)
	tdm.SpawnCommand(team.GetPlayers(2),spawnsCT)

	hl2coop.police = false

	tdm.CenterInit()

	return {roundTimeLoot = roundTimeLoot}
end

function hl2coop.RoundEndCheck()
    if roundTimeStart + roundTime < CurTime() then
		if not hl2coop.police then
			hl2coop.police = true
			PrintMessage(3,"Раунд Закончен.")

			EndRound(1)
		end
	end

	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local CTAlive,CTExit = 0,0
	local OAlive = 0

	CTAlive = tdm.GetCountLive(team.GetPlayers(2),function(ply)
		if ply.exit then CTExit = CTExit + 1 return false end
	end)

	if CTExit > 0 and TAlive == 0 then EndRound(1) return end

	OAlive = tdm.GetCountLive(team.GetPlayers(3))

	if TAlive == 0 and CTExit == 0 then EndRound(2) return end

	CTAlive = tdm.GetCountLive(team.GetPlayers(1),function(ply)
		if ply.exit then CTExit = CTExit + 1 return false end
	end)

	local list = ReadDataMap("spawnpoints_ss_exit")

		for i,ply in pairs(team.GetPlayers(1)) do
			if not ply:Alive() or ply.exit then continue end

			for i,point in pairs(list) do
				if ply:GetPos():Distance(point[1]) < (point[3] or 250) then
					ply.exit = true
					ply:KillSilent()

					CTExit = CTExit + 1

					PrintMessage(3,ply:Nick() .. " прошёл, осталось " .. (TAlive - 1))
				end
			end
		end
end

function hl2coop.EndRound(winner) tdm.EndRoundMessage(winner) end



function hl2coop.PlayerSpawn(ply,teamID)
	local teamTbl = hl2coop[hl2coop.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
    ply:SetPlayerColor(color:ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	tdm.GiveSwep(ply,teamTbl.main_weapon,teamID == 1 and 16 or 4)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon,teamID == 1 and 8 or 2)

    if teamID == 1 then
		JMod.EZ_Equip_Armor(ply,"TC 800")
		JMod.EZ_Equip_Armor(ply,"HPC")
		JMod.EZ_Equip_Armor(ply,"Triton")
		JMod.EZ_Equip_Armor(ply,"Gruppa 99 T30 (B)")
	elseif teamID == 2 then
		ply:KillSilent()
    end
end

function hl2coop.PlayerInitialSpawn(ply) ply:SetTeam(2) end

function hl2coop.PlayerCanJoinTeam(ply,teamID)
	ply.hl2coopForceT = nil

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
			ply.hl2coopForceT = true

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

local common = {"food_lays","weapon_pipe","weapon_bat","med_band_big","med_band_small","medkit","food_monster","food_fishcan","food_spongebob_home"}
local uncommon = {"medkit","weapon_molotok","painkiller"}
local rare = {"weapon_glock18","weapon_gurkha","weapon_t","weapon_per4ik"}

function hl2coop.ShouldSpawnLoot()
   	if roundTimeStart + roundTimeLoot - CurTime() > 0 then return false end

	local chance = math.random(100)
	if chance < 5 then
		return true,rare[math.random(#rare)]
	elseif chance < 30 then
		return true,uncommon[math.random(#uncommon)]
	elseif chance < 70 then
		return true,common[math.random(#common)]
	else
		return false
	end
end

function hl2coop.PlayerDeath(ply,inf,att) return false end

function hl2coop.GuiltLogic(ply,att,dmgInfo)
	if att.isContr and ply:Team() == 2 then return dmgInfo:GetDamage() * 3 end
end

function hl2coop.NoSelectRandom()
	local a,b,c = string.find(string.lower(game.GetMap()),"school")
    return a ~= nil
end