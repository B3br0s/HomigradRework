function scpcb.SpawnsGet()
	local spawnsSCP = ReadDataMap("spawnpointsscp")
	local spawnsGUARD = ReadDataMap("spawnpointguard")
	local spawnsNS = ReadDataMap("spawnpointsns")
	local spawnsDCLASS = ReadDataMap("spawnpointsdclass")

	return spawnsSCP,spawnsGUARD,spawnsNS,spawnsDCLASS
end

SPAWN_KEYCARD2 = {
		Vector(-973.46978759766, 59.544757843018, 244.03125),
		Vector(-1719.0118408203, 1572.8146972656, 148.03125),
		Vector(-865.41015625, 804.12603759766, -107.96874237061),
		Vector(-1334.4851074219, 25.354717254639, 239.03125),
		Vector(-967.65496826172, 1991.4643554688, 143.03125),
		Vector(-2206.6071777344, 239.39010620117, 239.03125),
		Vector(-2014.5384521484, 1190.0989990234, 143.03125),
		Vector(-433.64489746094, -177.19830322266, -235.96875),
		Vector(-376.93325805664, 898.18023681641, 56.03125),
		Vector(-378.37875366211, 1266.0665283203, 56.03125),
		Vector(-167.99784851074, 1338.5423583984, 56.031242370605),
		Vector(-553.99975585938, 1952.3541259766, 20.03125),
		Vector(109.20375823975, 1957.4532470703, 276.03125),
		Vector(2452.431640625, 391.7321472168, 20.03125),
		Vector(2764.8984375, -1436.8538818359, 20.03125),
		Vector(2571.0368652344, 1234.0698242188, 20.031242370605),
		Vector(2574.1118164063, -388.20559692383, 20.03125),
		Vector(846.67999267578, -301.67749023438, 20.03125),
		Vector(1694.9299316406, 385.57537841797, 20.031257629395),
		Vector(1757.0490722656, 387.83758544922, 20.031242370605),
		Vector(1825.421875, 389.88623046875, 20.03125),
		Vector(1890.6043701172, 389.14758300781, 20.031242370605),
		Vector(1692.9235839844, 512.01770019531, 20.031257629395),
		Vector(1759.7608642578, 510.46966552734, 20.03125),
		Vector(1821.2641601563, 509.14459228516, 20.031257629395),
		Vector(1886.7398681641, 508.58343505859, 20.031242370605),
		Vector(1711.4041748047, 706.68511962891, 20.031257629395),
		Vector(1891.2886962891, 284.65869140625, 20.03125),
		Vector(1985.5706787109, 349.28100585938, 20.031257629395),
		Vector(1783.6055908203, 159.189453125, 62.03125),
}
SPAWN_KEYCARD3 = {
		Vector(1170.3599853516, 488.56060791016, 20.03125),
		Vector(1693.7802734375, 892.77014160156, 20.03125),
		Vector(1913.4068603516, 1299.3720703125, 20.031257629395),
		Vector(2307.7004394531, 876.65191650391, 20.031253814697),
		Vector(2304.9973144531, 1295.5843505859, 20.03125),
		Vector(2176.1931152344, -2181.2805175781, 21.03125),
		Vector(86.409568786621, -1830.4000244141, -107.96875),
		Vector(576.30590820313, -1666.4543457031, 21.031253814697),
		Vector(220.74691772461, -262.36468505859, 20.03125),
		Vector(-1435.3547363281, -997.93432617188, 21.03125),
}
SPAWN_KEYCARD4 = {
		Vector(5147.666015625, 3757.9318847656, 20.031257629395),
		Vector(7265.0141601563, 4690.0283203125, -1129.8533935547),
		Vector(4992.685546875, 2371.7456054688, 20.03125),
		Vector(5561.1552734375, -922.13189697266, 20.03125),
		Vector(5023.7836914063, -2261.5729980469, 72.03125),
		Vector(4006.9145507813, 457.2883605957, -363.96875),
		Vector(5511.7275390625, 1119.1184082031, -491.96875),
		Vector(934.20153808594, -346.54061889648, -747.96875),
		Vector(1002.470703125, -1022.0648193359, -747.96875),
		Vector(1464.1553955078, -1942.9885253906, -747.96875),
		Vector(-574.044921875, 4135.4946289063, -7.9687404632568),
		Vector(-991.01947021484, 3769.2963867188, -7.96875),
		Vector(-2521.5017089844, 2370.9533691406, 37.017501831055),
		Vector(-85.46036529541, 3624.4426269531, -107.96875),
		Vector(62.2659034729, 2247.8588867188, 56.031257629395),
		Vector(217.70761108398, 2536.4987792969, 56.03125),
		Vector(-735.12176513672, 2945.6921386719, 20.031253814697),
		Vector(-775.41339111328, 3297.7707519531, 62.03125),
		Vector(-1131.8254394531, 2492.8095703125, 45.841468811035),
		Vector(-1051.2081298828, 2584.3764648438, 56.031246185303),
		Vector(-1859.9642333984, 2550.4519042969, -71.96875),
		Vector(1304.2673339844, 4010.4653320313, 20.03125),
		Vector(2077.1372070313, 5030.3559570313, -199.96876525879),
}
SPAWN_MEDKITS = {
	Vector(-1498.2027587891, 3482.6940917969, 25.03125),
	Vector(-60.792743682861, 3149.59765625, -102.96875),
	Vector(474.02795410156, 2488.3110351563, 61.03125),
}
SPAWN_GMEDKITS = {
	Vector(1900.8157958984, 3486.8972167969, -245.96875),
	Vector(1900.4997558594, 3540.1274414063, -245.96875),
}
SPAWN_MISCITEMS = {
	Vector(210.51342773438, -673.15850830078, 5.03125),
	Vector(2823.7763671875, -1111.8072509766, -26.968753814697),
	Vector(4798.3076171875, -2763.767578125, 21.031257629395),
	Vector(5526.5483398438, -235.85719299316, 6.03125),
	Vector(1421.677734375, 1948.5020751953, 41.03125),
	Vector(447.73638916016, 3503.7104492188, -82.96875),
	Vector(177.75852966309, 3127.0778808594, -122.96875),
	Vector(421.99377441406, -1841.1298828125, -122.96875),
	Vector(1435.6799316406, 2954.0561523438, 105.03124237061),
}
SPAWN_MELEEWEPS = {
	Vector(2750.3227539063, -1148.0911865234, -6.96875),
	Vector(136.375, -673.91833496094, 25.03125),
	Vector(261.33114624023, 3815.8701171875, -62.96875),
	Vector(1435.9907226563, 3064.5197753906, 89.03125),
	Vector(-1520.3510742188, 2550.8671875, -102.96873474121),
	Vector(-48.573299407959, 2270.046875, 25.031248092651),
	Vector(1784.5053710938, 3487.2453613281, 25.03125),
	Vector(3999.53515625, 3875.9763183594, 25.03125),
}
SPAWN_PISTOLS = {
	Vector(-2836.4599609375, 4016.7541503906, 286.84194946289),
	Vector(-1606.4586181641, 3501.9631347656, 5.0312423706055),
	Vector(1282.1854248047, -1596.8283691406, 5.03125),
	Vector(1277.5786132813, -1528.9841308594, 5.03125),
	Vector(1337.1435546875, -1564.4315185547, 5.03125),
	Vector(1283.2905273438, -1462.1614990234, 5.03125),
}
SPAWN_SMGS = {
	Vector(1533.1491699219, -1643.9223632813, 5.03125),
	Vector(868.98992919922, 4564.9653320313, 5.03125),
	Vector(889.45794677734, 4564.0634765625, 5.0312538146973),
	Vector(3916.2507324219, -954.69647216797, -122.96875),
	Vector(2118.6433105469, -1830.5573730469, -762.96875),
}
SPAWN_RIFLES = {
	Vector(844.81573486328, 4475.1552734375, 5.03125),
	Vector(843.27038574219, 4449.7900390625, 5.03125),
	Vector(842.29821777344, 4427.044921875, 5.03125),
	Vector(841.80322265625, 4401.7431640625, 5.03125),
	Vector(841.33001708984, 4377.5693359375, 5.03125),
	Vector(2124.6655273438, 3437.4912109375, -245.96875),
	Vector(2064.392578125, 3439.177734375, -245.96875),
	Vector(2003.4000244141, 3440.2915039063, -245.96875),
	Vector(1930.82421875, 3437.689453125, -245.96875),
}
SPAWN_SHOTGUNS = {
	Vector(782.86785888672, 4511.0639648438, 5.0312538146973),
	Vector(815.62542724609, 4508.9868164063, 5.03125),
	Vector(2131.3046875, 3364.0288085938, -245.96875),
	Vector(2073.5422363281, 3358.4501953125, -245.96875),
	Vector(2102.8791503906, 3389.26953125, -245.96875),
	Vector(2052.1381835938, 3396.1345214844, -245.96875),
}

function scpcb.SpawnRifles()
	local weapons = {
		"weapon_m4a1",
		"weapon_hk416"
	}

	for i = 1,#SPAWN_RIFLES do
		local weapon = ents.Create(table.Random(weapons))
		weapon:SetPos(SPAWN_RIFLES[i])
		weapon:Spawn()
		weapon.Spawned = true
		weapon:GetPhysicsObject():Wake()
	end
end

function scpcb.SpawnKeyCard2()
	for i = 1,#SPAWN_KEYCARD2 do
		local weapon = ents.Create("weapon_key2")
		weapon:SetPos(SPAWN_KEYCARD2[i])
		weapon:Spawn()
		weapon.Spawned = true
		weapon:GetPhysicsObject():Wake()
	end
end

function scpcb.SpawnKeyCard3()
	for i = 1,#SPAWN_KEYCARD3 do
		local weapon = ents.Create("weapon_key3")
		weapon:SetPos(SPAWN_KEYCARD3[i])
		weapon:Spawn()
		weapon.Spawned = true
		weapon:GetPhysicsObject():Wake()
	end
end

function scpcb.SpawnKeyCard4()
	for i = 1,#SPAWN_KEYCARD4 do
		local weapon = ents.Create("weapon_key4")
		weapon:SetPos(SPAWN_KEYCARD4[i])
		weapon:Spawn()
		weapon.Spawned = true
		weapon:GetPhysicsObject():Wake()
	end
end

function scpcb.SpawnSmgs()
	local weapons = {
		"weapon_vector",
		"weapon_mp5"
	}

	for i = 1,#SPAWN_SMGS do
		local weapon = ents.Create(table.Random(weapons))
		weapon:SetPos(SPAWN_SMGS[i])
		weapon:Spawn()
		weapon.Spawned = true
		weapon:GetPhysicsObject():Wake()
	end
end

function scpcb.SpawnShotGuns()
	local weapons = {
		"weapon_xm1014",
		"weapon_obrez",
		"weapon_saiga12"
	}

	for i = 1,#SPAWN_SHOTGUNS do
		local weapon = ents.Create(table.Random(weapons))
		weapon:SetPos(SPAWN_SHOTGUNS[i])
		weapon:Spawn()
		weapon.Spawned = true
		weapon:GetPhysicsObject():Wake()
	end
end

function scpcb.SpawnCommand(tbl,aviable,func,funcShould)
	for i,ply in RandomPairs(tbl) do
		if funcShould and funcShould(ply) ~= nil then continue end

		if ply:Alive() then ply:KillSilent() end

		if func then func(ply) end

		ply:Spawn()
		ply.allowFlashlights = true

		local point,key = table.Random(aviable)
		point = ReadPoint(point)
		if not point then continue end

		ply:SetPos(point[1])
		if #aviable > 1 then table.remove(aviable,key) end
	end
end

function scpcb.StartRoundSV(data)
    tdm.RemoveItems()

	tdm.DirectOtherTeam(1,2)

	scpcb.SCP096 = nil
	scpcb.SCP173 = nil
	scpcb.SCP049 = nil

	scpcb.AlphaArmed = false

	local GUARD = {
		"weapon_m7920",
		"weapon_mp7",
		"weapon_m9",
		"weapon_handcuffs",
		"weapon_sog",
		"weapon_key3"
	}
	local SCIENTIST = {
		"weapon_key2",
		"med_ifak"
	}

	local spawnsSCP,spawnsGUARD,spawnsNS,spawnsDCLASS = scpcb.SpawnsGet()
	
	scpcb.SpawnCommand(team.GetPlayers(1),spawnsSCP)
	scpcb.SpawnCommand(team.GetPlayers(2),spawnsDCLASS)

	roundTimeStart = CurTime()
	roundTime = 120 * (2 + math.min(#player.GetAll() / 16,2))

	local WarHeadButton = ents.Create("prop_physics")
	WarHeadButton:SetPos(Vector(3991.762939, 261.911407, -347.979004))
	WarHeadButton:SetAngles(Angle(11.409,-0.753,-0.033))
	WarHeadButton:SetModel("models/bull/buttons/key_switch.mdl")
	WarHeadButton:Spawn()
	WarHeadButton:GetPhysicsObject():EnableMotion(false)
	scpcb.WarHeadButton = WarHeadButton

	local players = team.GetPlayers(2)

	for _, ply in ipairs(players) do
		ply.Role = "Класс-Д"
		ply.RoleColor = Color(255,94,0)
		ply:SetPlayerColor(Color(255,94,0):ToVector())
		ply:SetPos(table.Random(ReadDataMap("spawnpointsdclass"))[1])
	end

	if #player.GetAll() < 8 then
		count = 1
	elseif #player.GetAll() > 8 and #player.GetAll() < 14 then
		count = 2
	elseif #player.GetAll() > 14 then
		count = 3
	end
	for i = 1,count do
		local ply,key = table.Random(players)
		players[key] = nil

		ply:SetTeam(1)

		if scpcb.SCP096 == nil then
		scpcb.SCP096 = ply
		ply.isSCP = true
		ply.Role = "SCP-096"
		ply.RoleColor = Color(255,0,0)
		ply:SetPlayerClass("096")
		ply:SetPlayerColor(Color(255,0,0):ToVector())
		ply:SetPos(table.Random(ReadDataMap("spawnpointsscp096"))[1])
		end
		if scpcb.SCP173 == nil and scpcb.SCP096 != ply then
		scpcb.SCP173 = ply
		ply.isSCP = true
		ply.Role = "SCP-173"
		ply.RoleColor = Color(255,0,0)
		ply:SetPlayerClass("173")
		ply:SetPlayerColor(Color(255,0,0):ToVector())
		ply:SetPos(table.Random(ReadDataMap("spawnpointsscp173"))[1])
		end
		if scpcb.SCP096 != ply and scpcb.SCP173 != ply and scpcb.SCP049 == nil then
		scpcb.SCP049 = ply
		ply.isSCP = true
		ply.Role = "SCP-049"
		ply.RoleColor = Color(255,0,0)
		ply:SetPlayerClass("049")
		ply:SetPlayerColor(Color(255,0,0):ToVector())
		ply:SetPos(table.Random(ReadDataMap("spawnpointsscp049"))[1])
		end
	end

	count = (#team.GetPlayers(2) / 2.5)

	scpcb.SpawnKeyCard2()
	scpcb.SpawnKeyCard3()
	scpcb.SpawnKeyCard4()
	/*timer.Simple(math.random(60,180),function()
		scpcb.SpawnShotGuns()
	end)
	timer.Simple(math.random(60,180),function()
		scpcb.SpawnSmgs()
	end)
	timer.Simple(math.random(60,180),function()
		scpcb.SpawnRifles()
	end)*/

	for i = 1,count do
		local ply,key = table.Random(players)
		players[key] = nil

		ply:SetTeam(3)

		if math.random(1,2) == 1 then
			ply.Role = "Научный Сотрудник"
			ply.RoleColor = Color(255,242,126)
			ply:SetPlayerColor(Color(255,242,126):ToVector())
			ply:SetModel("models/player/hostage/hostage_04.mdl")
			ply:SetPos(table.Random(ReadDataMap("spawnpointsns"))[1])
			for _, Z in ipairs(SCIENTIST) do
				ply:Give(Z)
			end
		else
			ply.Role = "Охрана"
			ply.RoleColor = Color(134,134,134)
			ply:SetModel("models/player/swat.mdl")
			ply:SetPlayerColor(Color(134,134,134):ToVector())
			ply:SetPos(table.Random(ReadDataMap("spawnpointguard"))[1])
			for _, Z in ipairs(GUARD) do
				ply:Give(Z)
			end
		end
	end

	scpcb.mtfarrive = false

	tdm.CenterInit()

	return {roundTimeLoot = roundTimeLoot}
end

function scpcb.RoundEndCheck()
	if not IsValid(scpcb.WarHeadButton) then
		local WarHeadButton = ents.Create("prop_physics")
		WarHeadButton:SetPos(Vector(3991.762939, 261.911407, -347.979004))
		WarHeadButton:SetAngles(Angle(11.409,-0.753,-0.033))
		WarHeadButton:SetModel("models/bull/buttons/key_switch.mdl")
		WarHeadButton:Spawn()
		WarHeadButton:GetPhysicsObject():EnableMotion(false) 

		scpcb.WarHeadButton = WarHeadButton
	end
	local MTFWeapons = {
		"weapon_sog",
		"weapon_hk416",
		"weapon_glockp80",
		"weapon_m7920",
		"weapon_rgd5",
		"weapon_handcuffs",
		"weapon_key5"
	}
	local CHAOSWeapons = {
		"weapon_taiga",
		"weapon_m249",
		"weapon_tec9",
		"weapon_key5"
	}

	for _, ply in ipairs(player.GetAll()) do
		net.Start("SCPRoleGet")
		net.WriteEntity(ply)
		net.WriteString(tostring(ply.Role))
		net.WriteColor(ply.RoleColor or Color(255,255,255))
		net.Broadcast()	
	end

    if roundTimeStart + roundTime < CurTime() then
		if not scpcb.mtfarrive then
			scpcb.mtfarrive = true
			net.Start("SoundPlay")
			net.WriteString("scp/announcements/mtf.wav")
			net.Broadcast()

			for i,ply in pairs(tdm.GetListMul(player.GetAll(),1,function(ply) return not ply:Alive() and ply:Team() ~= 1002 end),1) do
				ply:Spawn()

				for _, Z in ipairs(MTFWeapons) do
					ply:Give(Z)
				end
				 
				ply:GiveAmmo(48,"9х19 mm Parabellum",true)
				ply:GiveAmmo(120,"5.56x45 mm",true)

				ply:SetTeam(3)

				ply:SetModel("models/scp_mtf_russian/mtf_rus_07.mdl")

				ply.Role = "М.О.Г"

				ply:SetPos(table.Random(ReadDataMap("spawnpointsmtf"))[1])

				ply.RoleColor = Color(0,47,255)

				ply:SetPlayerColor(Color(0,47,255):ToVector())
			end
		end
	end

	local SCPAlive = tdm.GetCountLive(team.GetPlayers(1))
	local DAlive = tdm.GetCountLive(team.GetPlayers(2))
	local FOUNDAlive = tdm.GetCountLive(team.GetPlayers(3))
	
	local list = ReadDataMap("spawnpoints_ss_exit")

	for i,ply in pairs(team.GetPlayers(2)) do
		if not ply:Alive() or ply.exit or ply.Role != "Научный Сотрудник" and ply.Role != "Класс-Д" then continue end
		for i,point in pairs(list) do
			if ply:GetPos():Distance(point[1]) < (point[3] or 250) then
				if ply.Role == "Класс-Д" then
					ply:Spawn()
					ply.Role = "Повстанцы Хаоса"
					ply.RoleColor = Color(0,97,8)
					ply:SetPos(table.Random(ReadDataMap("spawnpointschaos"))[1])
					ply:SetPlayerColor(Color(0,97,8):ToVector())
					for _, Z in ipairs(CHAOSWeapons) do
						ply:Give(Z)
					end
					 
					ply:GiveAmmo(48,"9х19 mm Parabellum",true)
					ply:GiveAmmo(200,"7.62x39 mm",true)
				else
					ply:Spawn()
					ply.Role = "М.О.Г"
					ply.RoleColor = Color(0,97,8)
					ply:SetPos(table.Random(ReadDataMap("spawnpointsmtf"))[1])
					ply.RoleColor = Color(0,47,255)
					ply:SetPlayerColor(Color(0,47,255):ToVector())
					for _, Z in ipairs(MTFWeapons) do
						ply:Give(Z)
					end
					 
					ply:GiveAmmo(48,"9х19 mm Parabellum",true)
					ply:GiveAmmo(120,"5.56x45 mm",true)
				end
			end
		end
	end

	if SCPAlive == 0 and DAlive == 0 and FOUNDAlive > 0 then EndRound(3) end
	if SCPAlive > 0 and DAlive == 0 and FOUNDAlive == 0 then EndRound(1) end
	if SCPAlive == 0 and DAlive > 0 and FOUNDAlive == 0 then EndRound(2) end
	if SCPAlive == 0 and DAlive == 0 and FOUNDAlive == 0 then EndRound(math.random(1,3)) end
end

function scpcb.EndRound(winner) net.Start("TextOnScreen") net.WriteString("Выиграли - "..(winner == 1 and TableRound().red[1] or winner == 2 and "Повстанцы Хаоса" or TableRound().blue[1])) net.Broadcast() end

function scpcb.PlayerSpawn(ply,teamID)
	local teamTbl = scpcb[scpcb.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
	ply:SetPlayerColor(Color(0,0,0):ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	tdm.GiveSwep(ply,teamTbl.main_weapon,teamID == 1 and 16 or 4)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon,teamID == 1 and 8 or 2)

	ply:SetPlayerColor(color:ToVector())

	ply.allowFlashlights = false
end

function scpcb.PlayerInitialSpawn(ply) ply:SetTeam(2) end

function scpcb.PlayerCanJoinTeam(ply,teamID)
	if not ply:IsAdmin() then
		return false
	else
		return true
	end
end

function scpcb.ShouldSpawnLoot()
		return false
end

function scpcb.PlayerDeath(ply,inf,att)
	return false
end

function scpcb.GuiltLogic(ply,att,dmgInfo)
	return false
end

function scpcb.NoSelectRandom()
    return true
end