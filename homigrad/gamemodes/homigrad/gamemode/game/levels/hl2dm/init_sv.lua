function hl2dm.StartRoundSV()
	tdm.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 60 * (2 + math.min(#player.GetAll() / 8,2))

	tdm.DirectOtherTeam(3,1,2)

	OpposingAllTeam()
	AutoBalanceTwoTeam()

	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)
	tdm.SpawnCommand(team.GetPlayers(2),spawnsCT)

	tdm.CenterInit()
end

function hl2dm.RoundEndCheck()

	if roundTimeStart + roundTime - CurTime() <= 0 then EndRound() end
	
	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local CTAlive = tdm.GetCountLive(team.GetPlayers(2))

	if TAlive == 0 and CTAlive == 0 then EndRound() return end

	if TAlive == 0 then EndRound(2) end
	if CTAlive == 0 then EndRound(1) end

	tdm.Center()
end

function hl2dm.EndRound(winner) tdm.EndRoundMessage(winner) end

function hl2dm.PlayerInitialSpawn(ply) ply:SetTeam(math.random(1,2)) end

function hl2dm.PlayerSpawn(ply,teamID)
	local teamTbl = hl2dm[hl2dm.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])

    ply:SetPlayerColor(color:ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	tdm.GiveSwep(ply,teamTbl.main_weapon)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon)
	
	if teamID == 2 then
		ply:SetPlayerClass("combine")
	end

	if teamID == 1 then
		if math.random(1,4) == 4 then ply:Give("adrinaline") end
		if math.random(1,4) == 4 then ply:Give("morphine") end
		if math.random(1,3) == 3 then ply:Give("weapon_hg_hl2") end

		JMod.EZ_Equip_Armor(ply,"M2")
		JMod.EZ_Equip_Armor(ply,"ACHHC Olive")
	end

end

function hl2dm.PlayerCanJoinTeam(ply,teamID)
    if teamID == 3 then ply:ChatPrint("Иди нахуй") return false end
end

function hl2dm.ShouldSpawnLoot() return false end
function hl2dm.PlayerDeath(ply,inf,att) if ply.isCombine then 

	ply:GetNWEntity("Ragdoll"):EmitSound("npc/metropolice/die" .. math.random(1,4) .. ".wav") 
timer.Simple(3.2,function ()
	ply:GetNWEntity("Ragdoll"):EmitSound("npc/combine_soldier/vo/on1.wav")
end)
timer.Simple(3.8,function ()
	ply:GetNWEntity("Ragdoll"):EmitSound("npc/combine_soldier/vo/requestmedical.wav")
end)
timer.Simple(5,function ()
	ply:GetNWEntity("Ragdoll"):EmitSound("npc/combine_soldier/vo/off3.wav")
end)
end return false end