table.insert(LevelList, "gangrazborki")

gangrazborki = {}
gangrazborki.Name = "Разборки Гетто"

gangrazborki.red = {"Crips",Color(66, 135, 245),
	weapons = {
		"weapon_hands",
		"med_band_small",
		"stim3",
		"medkit"
	},
	main_weapon = {
		"weapon_throwknife",
		"weapon_knife",
		"weapon_kabar",
		"stim2",
		"stim4",
		"stim1"
	},
	secondary_weapon = {"weapon_glock","weapon_glock18","weapon_de"},
	models = {
		"models/player/Group01/male_01.mdl",
		"models/player/Group01/male_03.mdl",
		"models/player/Group03/male_01.mdl"
	}
}


gangrazborki.blue = {"Bloods",Color(196, 65, 59),
	weapons = {
		"weapon_hands",
		"med_band_small",
		"stim3",
		"medkit"
	},
	main_weapon = {
		"weapon_throwknife",
		"weapon_knife",
		"weapon_kabar",
		"stim2",
		"stim4",
		"stim1"
	},

	secondary_weapon = {"weapon_glock","weapon_glock18","weapon_de"},
	models = {
		"models/player/Group01/male_01.mdl",
		"models/player/Group01/male_03.mdl",
		"models/player/Group03/male_01.mdl"
	}
}

gangrazborki.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function gangrazborki.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,gangrazborki.red[2])
	team.SetColor(2,gangrazborki.blue[2])

	if CLIENT then

		gangrazborki.StartRoundCL()
		return
	end

	gangrazborki.StartRoundSV()
end

gangrazborki.SupportCenter = true

gangrazborki.NoSelectRandom = false