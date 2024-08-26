function zombieinfection.StartRoundSV(data)
    tdm.RemoveItems()

	tdm.DirectOtherTeam(1,2)

	roundTimeStart = CurTime()
	roundTime = 400
	roundTimeLoot = 9999

    local players = team.GetPlayers(2)

    for i,ply in pairs(players) do
		ply.exit = false

		if ply.zombieinfectionForceT then
			ply.zombieinfectionForceT = nil

			ply:SetTeam(2)
			
		end
    end

	players = team.GetPlayers(2)

	local count = math.min(math.floor(#players / 1.5,1))
    for i = 1,count do
        local ply,key = table.Random(players)
		players[key] = nil

        ply:SetTeam(1)
		
		ply.Blood = 50000

		ply.adrenaline = math.random(1,2)

		ply.painlosing = 5

		ply.virusvichblya = true
    end

	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)
	tdm.SpawnCommand(team.GetPlayers(2),spawnsCT)

	zombieinfection.police = false

	zombieinfection.respawned = false

	tdm.CenterInit()

	return {roundTimeLoot = roundTimeLoot}
end

function zombieinfection.RoundEndCheck()
	if not zombieinfection.respawned then
	for i,ply in pairs(tdm.GetListMul(player.GetAll(),1,function(ply) return not ply:Alive() and ply:Team() ~= 1002 end),1) do
		zombieinfection.respawned = true
		timer.Simple(3,function() ply:Spawn() ply:SetTeam(1) ply:Spawn() ply:Spawn() ply:StripWeapons() ply:Give("weapon_handsinfected") ply.virusvichblya = true ply.Blood = 50000 ply.adrenaline = math.random(1,2) ply.painlosing = 5 ply:ChatPrint("Не обращай внимания на сообщения о гилте.") zombieinfection.respawned = false end )
	end
end
    if roundTimeStart + roundTime < CurTime() then
		if not zombieinfection.police then
			zombieinfection.police = true
			PrintMessage(3,"Рассвет наступил")
			EndRound(2)
		end
	end

	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local CTAlive,CTExit = 0,0
	local OAlive = 0

	CTAlive = tdm.GetCountLive(team.GetPlayers(2),function(ply)
		if ply.exit then CTExit = CTExit + 1 return false end
	end)

	local list = ReadDataMap("spawnpoints_ss_exit")

	if zombieinfection.police then
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

	OAlive = tdm.GetCountLive(team.GetPlayers(3))
	
	if CTAlive == 0 then EndRound(1) PrintMessage(3,"Люди не дожили до рассвета") return end
end

function zombieinfection.EndRound(winner) tdm.EndRoundMessage(winner) end

function zombieinfection.PlayerSpawn(ply,teamID)
	local teamTbl = zombieinfection[zombieinfection.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
	ply:SetPlayerColor(Color(0,0,0):ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	tdm.GiveSwep(ply,teamTbl.main_weapon,teamID == 1 and 16 or 4)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon,teamID == 1 and 8 or 2)

    if teamID == 2 then
        JMod.EZ_Equip_Armor(ply,"CSA")
        JMod.EZ_Equip_Armor(ply,"Slick Black")
		JMod.EZ_Equip_Armor(ply,"Bastion Shield")
		JMod.EZ_Equip_Armor(ply,"NeoSteel Mandible")
		JMod.EZ_Equip_Armor(ply,"Caiman FA Visor",Color(50,50,50):ToVector())
		JMod.EZ_Equip_Armor(ply,"MK4A P R.Brassard",Color(50,50,50):ToVector())
		JMod.EZ_Equip_Armor(ply,"MK4A P L.Brassard",Color(50,50,50):ToVector())
		ply:GiveAmmo(500,"4.6 x30mm",true)
		ply:GiveAmmo(500,"9х19 mm Parabellum",true)
		ply:GiveAmmo(500,"12/70 beanbag",true)
    end
	ply.allowFlashlights = false
end

function zombieinfection.PlayerInitialSpawn(ply) ply:SetTeam(2) end

function zombieinfection.PlayerCanJoinTeam(ply,teamID)
	ply.zombieinfectionForceT = nil

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
			ply.zombieinfectionForceT = true

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

function zombieinfection.ShouldSpawnLoot()
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

function zombieinfection.PlayerDeath(ply,inf,att) return false end

function zombieinfection.GuiltLogic(ply,att,dmgInfo)
	if att.isContr and ply:Team() == 2 then return dmgInfo:GetDamage() * 3 end
end

function zombieinfection.NoSelectRandom()
	local a,b,c = string.find(string.lower(game.GetMap()),"school")
    return a ~= nil
end