table.insert(LevelList, "gangrazborki")

gangrazborki = {}
gangrazborki.Name = "Gang Wars"

gangrazborki.red = {"Crips",Color(66, 135, 245),
	weapons = {
		"weapon_hands",
		"med_band_small",
		"medkit"
	},
	main_weapon = {
		"weapon_sog",
	},
	secondary_weapon = {"weapon_ar15g","weapon_draco","weapon_deserteagle","weapon_p22","weapon_pm","weapon_fnp45"},
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
		"medkit"
	},
	main_weapon = {
		"weapon_sog",
	},

	secondary_weapon = {"weapon_ar15g","weapon_draco","weapon_deserteagle","weapon_p22","weapon_pm","weapon_fnp45"},
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