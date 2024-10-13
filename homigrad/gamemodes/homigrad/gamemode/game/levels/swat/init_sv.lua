function swat.StartRoundSV()
	swat.roundstarted = false
	tdm.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 60 * (5 + math.min(#player.GetAll() / 4,2))
	roundTimeSWAT = 120

	tdm.DirectOtherTeam(3,1,2)

	OpposingAllTeam()
	AutoBalanceTwoTeam()

	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(2),spawnsCT)

	tdm.CenterInit()

end

function swat.RoundEndCheck()

	if (roundTimeStart + roundTimeSWAT - CurTime()) < 0 and not swat.roundstarted == true then
		local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
		tdm.SpawnCommand(team.GetPlayers(1),spawnsCT)
		swat.roundstarted = true
	end

	if roundTimeStart + roundTime - CurTime() <= 0 then EndRound() end

	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local CTAlive = tdm.GetCountLive(team.GetPlayers(2))

	if TAlive == 0 and CTAlive == 0 then EndRound() return end

	if TAlive == 0 and swat.roundstarted then EndRound(2) end
	if CTAlive == 0  then EndRound(1) end

	tdm.Center()
end

function swat.EndRound(winner) tdm.EndRoundMessage(winner) end

function swat.PlayerInitialSpawn(ply) ply:SetTeam(math.random(1,2)) end

function swat.PlayerSpawn(ply,teamID)
	local teamTbl = swat[swat.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	tdm.GiveSwep(ply,teamTbl.main_weapon,teamID == 1 and 16 or 4)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon,teamID == 1 and 8 or 2)

	if teamID == 1 then
		local color = Color(65,65,65):ToVector()
		ply:SetPlayerColor(Color(255,255,255):ToVector())
		if math.random(1,3) == 3 then
			ply:SetPlayerClass("dozer")
		else
			ply:SetPlayerClass("swat")
		end
	else
		if math.random(1,2) == 1 then
			ply:SetPlayerColor(Color(150,0,0):ToVector())
			JMod.EZ_Equip_Armor(ply,"Lower Half-Mask",Color(255,255,255))
			JMod.EZ_Equip_Armor(ply,"Basmach Leather Cap",Color(255,255,255))
		else
			ply:SetPlayerColor(Color(0,150,0):ToVector())
			JMod.EZ_Equip_Armor(ply,"Ghost Half-Mask",Color(255,255,255))
			JMod.EZ_Equip_Armor(ply,"Basmach Leather Cap",Color(255,255,255))
		end
	end

	if roundStarter then
		ply.allowFlashlights = false
	end
end

function swat.PlayerCanJoinTeam(ply,teamID)
    if teamID == 3 then ply:ChatPrint("Иди нахуй") return false end
end

local common = {"food_lays","weapon_pipe","weapon_bat","medkit","food_monster","food_fishcan","food_spongebob_home"}
local uncommon = {"weapon_molotok","painkiller"}

function swat.ShouldSpawnLoot()
	local chance = math.random(100)

	if chance < 30 then
		return true,uncommon[math.random(#uncommon)]
	elseif chance < 70 then
		return true,common[math.random(#common)]
	else
		return false
	end
end

function swat.PlayerDeath(ply,inf,att) return false end
