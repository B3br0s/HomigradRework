function construct.StartRoundSV(data)
    tdm.RemoveItems()

	tdm.DirectOtherTeam(1,2)

	roundTimeStart = CurTime()
	roundTime = 780 * (2 + math.min(#player.GetAll() / 16,2))
	roundTimeLoot = 30

	SetGlobalBool("AccessSpawn",true)

	construct.NiGermany = false

    local players = team.GetPlayers(2)

    for i,ply in pairs(players) do
			ply:SetTeam(1)
    end

	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)

	tdm.CenterInit()

	return {roundTimeLoot = roundTimeLoot}
end

function construct.RoundEndCheck()
	if roundTimeStart + roundTime < CurTime() then
		if !construct.NiGermany then
			construct.NiGermany = true
			EndRound()
		end
	end

	--local TAlive = tdm.GetCountLive(team.GetPlayers(1))

	--if TAlive == 0 or TAlive == 1 then return end
end

function construct.EndRound(winner) end

function construct.PlayerSpawn(ply,teamID)
	local teamTbl = construct[construct.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
    ply:SetPlayerColor(color:ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	ply:SetPlayerColor(Color(math.random(255),math.random(255),math.random(255)):ToVector())

	ply.allowFlashlights = true
end

function construct.PlayerInitialSpawn(ply) ply:SetTeam(1) ply.CanSpawn = false ply.CanSpawnTime = CurTime() + 5 end

function construct.PlayerCanJoinTeam(ply,teamID)
	ply.constructForceT = nil

	if teamID == 3 then
		return false
	end

	if teamID == 2 then
		return false
	end

    if teamID == 1 then
		return true
	end
end

local common = {"food_lays","weapon_pipe","weapon_bat","med_band_big","base_crate","base_crate","base_crate","med_band_small","medkit","food_monster","food_fishcan","food_spongebob_home"}
local uncommon = {"medkit","weapon_molotok","painkiller","base_crate","base_crate"}
local rare = {"weapon_glock18","weapon_gurkha","weapon_t","weapon_per4ik","base_crate","base_crate"}

function construct.ShouldSpawnLoot()
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

function construct.PlayerDeath(ply,inf,att)
	ply.CanSpawn = false
	ply.CanSpawnTime = CurTime() + 15
	--[[local aviable2 = ReadDataMap("spawnpointsct")
	local aviable1 = ReadDataMap("spawnpointst")
	if #aviable2 > 0 then
	if math.random(1,2) == 1 then
		ply:SetPos(aviable1[math.random(1,#aviable)][3])
	else
		ply:SetPos(aviable2[math.random(1,#aviable)][3])
	end
	end]]
end

function construct.GuiltLogic(ply,att,dmgInfo)
	if att.isContr and ply:Team() == 2 then return dmgInfo:GetDamage() * 3 end
end