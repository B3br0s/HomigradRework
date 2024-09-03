function eft.StartRoundSV()
	tdm.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 150 * (2 + math.min(#player.GetAll() / 8,2))

	tdm.DirectOtherTeam(3,1,2)

	OpposingAllTeam()
	AutoBalanceTwoTeam()

	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)
	tdm.SpawnCommand(team.GetPlayers(2),spawnsCT)

	tdm.CenterInit()
end

function eft.RoundEndCheck()

	if roundTimeStart + roundTime - CurTime() <= 0 then EndRound() end
	
	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local CTAlive = tdm.GetCountLive(team.GetPlayers(2))

	if TAlive == 0 and CTAlive == 1 then EndRound(2) return end
	if TAlive == 1 and CTAlive == 0 then EndRound(1) return end

	tdm.Center()
end

function eft.EndRound(winner)
    for i, ply in ipairs( player.GetAll() ) do
	    if ply:Alive() then
        end
    end
end


function eft.PlayerInitialSpawn(ply) ply:SetTeam(math.random(1,2)) end

function eft.PlayerSpawn(ply,teamID)
	local teamTbl = eft[eft.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])

    ply:SetPlayerColor(color:ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	tdm.GiveSwep(ply,teamTbl.main_weapon)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon)
	
	if teamID == 2 then
		ply:SetPlayerClass("usec")
		JMod.EZ_Equip_Armor(ply,"Galvion Caiman")
		JMod.EZ_Equip_Armor(ply,"Slick Tan")
		JMod.EZ_Equip_Armor(ply,"TT Trooper 35")
	end

	if teamID == 1 then
		ply:SetPlayerClass("bear")

		JMod.EZ_Equip_Armor(ply,"Pillbox")
		JMod.EZ_Equip_Armor(ply,"Bastion")
		JMod.EZ_Equip_Armor(ply,"Korund")
	end

end

function eft.PlayerCanJoinTeam(ply,teamID)
    if teamID == 3 then ply:ChatPrint("Иди нахуй") return false end
end

function eft.ShouldSpawnLoot() return false end
function eft.PlayerDeath(ply,inf,att) return false end