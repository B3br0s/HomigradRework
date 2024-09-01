table.insert(LevelList,"eftdm")
eftdm = {}
eftdm.Name = "EFT DM"

local models = {}
for i = 1,9 do table.insert(models,"models/player/group03/male_0" .. i .. ".mdl") end

eftdm.red = {"Bear",Color(125,95,60),
	weapons = {"weapon_radio","weapon_hands"},
	main_weapon = {"weapon_sar2","weapon_spas12","weapon_akm","weapon_mp7"},
	secondary_weapon = {"weapon_hk_usp","weapon_p220"},
	models = models
}


eftdm.blue = {"Usec",Color(75,75,125),
	weapons = {"weapon_hands"},
	main_weapon = {"weapon_sar2","weapon_spas12","weapon_mp7"},
	secondary_weapon = {"weapon_hk_usp"},
	models = {"models/player/combine_soldier.mdl"}
}

eftdm.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function eftdm.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,eftdm.red[2])
	team.SetColor(2,eftdm.blue[2])

	if CLIENT then

		eftdm.StartRoundCL()
		return
	end

	eftdm.StartRoundSV()
end
eftdm.RoundRandomDefalut = 2
eftdm.SupportCenter = true
