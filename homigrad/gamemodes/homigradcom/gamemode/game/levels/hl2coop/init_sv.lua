function hl2.StartRoundSV(data)
    tdm.RemoveItems()

	tdm.DirectOtherTeam(1,1)

	roundTimeStart = CurTime()
	roundTime = 1400 * (2 + math.min(#player.GetAll() / 16,2))
	roundTimeLoot = 9999

    local players = team.GetPlayers(1)

    for i,ply in pairs(players) do
		ply.exit = false

		ply:SetTeam(1)
    end

	players = team.GetPlayers(2)

	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)

	hl2.police = false

	tdm.CenterInit()

	return {roundTimeLoot = roundTimeLoot}
end

function hl2.RoundEndCheck()
	local TAlive = tdm.GetCountLive(team.GetPlayers(1))

	if TAlive == 0 then EndRound(3) return end
end

function hl2.EndRound(winner) tdm.EndRoundMessage(winner) end

function hl2.PlayerSpawn(ply,teamID)
	local teamTbl = hl2[hl2.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
	ply:SetPlayerColor(Color(0,0,0):ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	tdm.GiveSwep(ply,teamTbl.main_weapon,teamID == 1 and 16 or 4)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon,teamID == 1 and 8 or 2)

	ply.allowFlashlights = true
end

function hl2.PlayerInitialSpawn(ply) ply:SetTeam(1) end

function hl2.PlayerCanJoinTeam(ply,teamID)
	ply.hl2ForceT = nil
end

local common = {"food_lays","weapon_pipe","weapon_bat","med_band_big","med_band_small","medkit","food_monster","food_fishcan","food_spongebob_home"}
local uncommon = {"medkit","weapon_molotok","painkiller"}
local rare = {"weapon_glock18","weapon_gurkha","weapon_t","weapon_per4ik"}

function hl2.ShouldSpawnLoot()
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

function hl2.PlayerDeath(ply,inf,att) return false end

function hl2.GuiltLogic(ply,att,dmgInfo)
	if att.isContr and ply:Team() == 1 then return dmgInfo:GetDamage() * 3 end
end

function hl2.NoSelectRandom()
    return nil
end